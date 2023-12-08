// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { SafeCast } from "@oz/utils/math/SafeCast.sol";
import { FullMath } from "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import { UnsafeMath } from "@uniswap/v3-core/contracts/libraries/UnsafeMath.sol";
import { FixedPoint96 } from "@uniswap/v3-core/contracts/libraries/FixedPoint96.sol";
import { Math } from "@oz/utils/math/Math.sol";

library DiverSqrtPriceMath {
    using SafeCast for uint256;
    using SafeCast for int128;

    // @notice Gets the delta amount of Spear or Shield tokens based on the given sqrt ratios and liquidity.
    // Computes for Spear token delta when the sqrtPrice moves from upper to lower; or Shield token delta when the sqrtPrice moves from lower to
    // upper.
    // For the same sqrt ratio range and liquidity, the computed delta amounts of Spear and Shield are equal.
    // Formula for this is:
    // stoken delta amount = liquidity * (sqrtRatioBX96 - sqrtRatioAX96) * (1 + 1 /(sqrtRatioAX96 * sqrtRatioBX96));

    // @param sqrtRatioAX96 A sqrt ratio
    // @param sqrtRatioBX96 Another sqrt ratio
    // @param liquidity The change in liquidity for which to compute the Spear or Shield token delta
    // @param roundUp Whether to round the amount up or down
    // @return amount The amount of Spear or Shield token corresponding to the passed liquidityDelta between the two prices
    function getSTokenDelta(uint160 sqrtRatioAX96, uint160 sqrtRatioBX96, uint128 liquidity, bool roundUp) internal pure returns (uint256 amount) {
        if (sqrtRatioAX96 > sqrtRatioBX96) {
            (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
        }
        if (roundUp) {
            uint256 l = uint256(liquidity) << FixedPoint96.RESOLUTION;
            uint256 l1 = FullMath.mulDivRoundingUp(l, sqrtRatioBX96 - sqrtRatioAX96, FixedPoint96.Q96);
            uint256 l2 = FullMath.mulDivRoundingUp(sqrtRatioAX96, sqrtRatioBX96, FixedPoint96.Q96) + FixedPoint96.Q96;
            uint256 l3 = FullMath.mulDivRoundingUp(l1, l2, sqrtRatioBX96);
            amount = UnsafeMath.divRoundingUp(l3, sqrtRatioAX96);
        } else {
            uint256 l = uint256(liquidity) << FixedPoint96.RESOLUTION;
            uint256 l1 = FullMath.mulDiv(l, sqrtRatioBX96 - sqrtRatioAX96, FixedPoint96.Q96);
            uint256 l2 = FullMath.mulDiv(sqrtRatioAX96, sqrtRatioBX96, FixedPoint96.Q96) + FixedPoint96.Q96;
            uint256 l3 = FullMath.mulDiv(l1, l2, sqrtRatioBX96);
            amount = l3 / sqrtRatioAX96;
        }
    }

    // @notice Helper that gets signed spear or shield token delta
    // @param sqrtRatioAX96 A sqrt ratio
    // @param sqrtRatioBX96 Another sqrt ratio
    // @param liquidity The change in liquidity for which to compute the Spear or Shield token delta
    // @return amount The amount of Spear or Shield token corresponding to the passed liquidityDelta between the two prices
    function getSTokenDelta(uint160 sqrtPriceAX96, uint160 sqrtPriceBX96, int128 liquidity) internal pure returns (int256 amount) {
        if (sqrtPriceAX96 > sqrtPriceBX96) {
            (sqrtPriceAX96, sqrtPriceBX96) = (sqrtPriceBX96, sqrtPriceAX96);
        }
        if (liquidity < 0) {
            amount = -getSTokenDelta(sqrtPriceAX96, sqrtPriceBX96, uint128(-liquidity), false).toInt256();
        } else {
            amount = getSTokenDelta(sqrtPriceAX96, sqrtPriceBX96, uint128(liquidity), true).toInt256();
        }
    }

    // @notice Gets the next sqrt ratio based on the given the Spear token delta and liquidity.
    // The formula for this is:
    // a = (sqrt(4 b^2 L^2 + (b^2 (-L) + b s + L)^2) + b^2 L - b s - L)/(2 b L)
    // where a = sqrtPriceLower b=sqrtPriceUpper s = spear delta
    // Derived from the getSTokenDelta() formula with adjustments for token decimal units and Q96. For reference:
    // https://wolfreealpha.gitlab.io/input/?i=solve+for+a+in+s+%3D+L*%28b-a%29%281%2BDivide%5B1%2Cab%5D&lang=en

    // @param sqrtPrice The starting price, i.e. before accounting for the spear token delta
    // @param liquidity The amount of usable liquidity
    // @param amount The amount of Spear token delta to mint for the trade
    // @param unit The token decimal unit, e.g. a token with 18 decimals has a unit of 10**18
    // @return nextSqrtPrice The next sqrt ratio after minting the given amount of Spear tokens

    function getNextSqrtPriceFromSpear(
        uint160 sqrtPrice,
        uint128 liquidity,
        uint256 amount,
        uint256 unit
    )
        internal
        pure
        returns (uint160 nextSqrtPrice)
    {
        uint256 b_2 = FullMath.mulDiv(sqrtPrice, sqrtPrice, FixedPoint96.Q96);
        uint256 l = FullMath.mulDiv(liquidity, FixedPoint96.Q96, 1);
        uint256 b_2l = FullMath.mulDiv(b_2, l, FixedPoint96.Q96);
        uint256 bs = FullMath.mulDiv(sqrtPrice, amount, 1);
        uint256 bl = FullMath.mulDiv(sqrtPrice, liquidity, 1);
        uint256 f1 = b_2l > bs + l ? b_2l - bs - l : bs + l - b_2l;
        uint256 f_2 = FullMath.mulDiv(f1, f1 / unit, FixedPoint96.Q96);
        uint256 fourB_2L_2 = 4 * FullMath.mulDiv(bl, bl, FixedPoint96.Q96 * unit);

        uint256 underSqrt = Math.sqrt((f_2 + fourB_2L_2)) * Math.sqrt(FixedPoint96.Q96) * Math.sqrt(unit);
        uint256 numerator;
        if (b_2l > bs + l) {
            numerator = underSqrt + f1;
        } else {
            numerator = underSqrt - f1;
        }
        nextSqrtPrice = FullMath.mulDiv(numerator, FixedPoint96.Q96, 2 * bl).toUint160();
    }

    // @notice Gets the next sqrt ratio based on the given the Shield token delta and liquidity.
    // The formula for this is:
    // a = (sqrt(4 b^2 L^2 + ((b^2 - 1) L + b s)^2) + b^2 L + b s - L)/(2 b L)
    // where a = sqrtPriceUpper b=sqrtPriceLower s = shield delta
    // Derived from the getSTokenDelta() formula with adjustments for token decimal units and Q96. For reference:
    // https://wolfreealpha.gitlab.io/input/?i=solve+for+a+in+s+%3D+L*%28a-b%29%281%2BDivide%5B1%2Cab%5D&lang=en

    // @param sqrtPrice The starting price, i.e. before accounting for the Shield token delta
    // @param liquidity The amount of usable liquidity
    // @param amount The amount of Shield token delta to mint for the trade
    // @param unit The token decimal unit, e.g. a token with 18 decimals has a unit of 10**18
    // @return nextSqrtPrice The next sqrt ratio after minting the given amount of Shield tokens

    function getNextSqrtPriceFromShield(
        uint160 sqrtPrice,
        uint128 liquidity,
        uint256 amount,
        uint256 unit
    )
        internal
        pure
        returns (uint160 nextSqrtPrice)
    {
        uint256 b_2 = FullMath.mulDiv(sqrtPrice, sqrtPrice, FixedPoint96.Q96);
        uint256 l = FullMath.mulDiv(liquidity, FixedPoint96.Q96, 1);
        uint256 b_2l = FullMath.mulDiv(b_2, l, FixedPoint96.Q96);
        uint256 bs = FullMath.mulDiv(sqrtPrice, amount, 1);
        uint256 bl = FullMath.mulDiv(sqrtPrice, liquidity, 1);
        uint256 f1 = b_2l + bs > l ? b_2l + bs - l : l - b_2l - bs;
        uint256 f_2 = FullMath.mulDiv(f1, f1 / unit, FixedPoint96.Q96);
        uint256 fourB_2L_2 = 4 * FullMath.mulDiv(bl, bl, FixedPoint96.Q96 * unit);
        uint256 underSqrt = Math.sqrt((f_2 + fourB_2L_2)) * Math.sqrt(FixedPoint96.Q96) * Math.sqrt(unit);
        uint256 numerator = underSqrt + b_2l + bs - l;
        nextSqrtPrice = FullMath.mulDiv(numerator, FixedPoint96.Q96, 2 * bl).toUint160();
    }
}
