// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { SafeCast } from "@oz/utils/math/SafeCast.sol";
import { FullMath } from "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import { UnsafeMath } from "@uniswap/v3-core/contracts/libraries/UnsafeMath.sol";
import { FixedPoint96 } from "@uniswap/v3-core/contracts/libraries/FixedPoint96.sol";
import { Math } from "@oz/utils/math/Math.sol";

import { console2 } from "@std/console2.sol";

library DiverSqrtPriceMath {
    using SafeCast for uint256;
    using SafeCast for int128;

    /**
     * formula
     * amount = liquidity * (sqrtRatioBX96 - sqrtRatioAX96) * (1 + 1 /
     * (sqrtRatioAX96 * sqrtRatioBX96));
     *
     */
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

    function getNextSqrtPriceFromSpear(uint160 sqrtPrice, uint128 liquidity, uint256 amount, uint unit) internal view returns (uint160 nextSqrtPrice) {
        uint256 b_2 = FullMath.mulDiv(sqrtPrice, sqrtPrice, FixedPoint96.Q96);
        console2.log("b_2  %s", b_2);
        uint256 l = FullMath.mulDiv(liquidity, FixedPoint96.Q96, 1);
        console2.log("l    %s", l);
        uint256 l_2 = FullMath.mulDiv(liquidity, liquidity, unit);
        console2.log("l_2  %s", l_2);
        uint256 b_2l = FullMath.mulDiv(b_2, l, FixedPoint96.Q96);
        console2.log("b_2l %s", b_2l);
        uint256 bs = FullMath.mulDiv(sqrtPrice, amount, 1);
        console2.log("bs   %s", bs);
        uint256 bl = FullMath.mulDiv(sqrtPrice, liquidity, 1);
        console2.log("bl   %s", bl);
        uint256 f1 = b_2l > bs + l ? b_2l - bs - l : bs + l - b_2l;
        console2.log("f1   %s", f1);
        // uint qd = FixedPoint96.Q96 * unit;
        uint256 f_2 = FullMath.mulDiv(f1, f1 / unit, FixedPoint96.Q96);
        console2.log("f2   %s", f_2);
        uint256 fourB_2L_2 = 4*FullMath.mulDiv(bl, bl, FixedPoint96.Q96*unit);
        
        console2.log("fourB_2L_2    %s", fourB_2L_2);
        uint256 underSqrt = Math.sqrt((f_2 + fourB_2L_2)) * Math.sqrt(FixedPoint96.Q96) * Math.sqrt(unit);
        console2.log("underSqrt     %s", underSqrt);
        uint256 numerator;
        if (b_2l > bs + l) {
            numerator = underSqrt + f1;
        } else {
            numerator = underSqrt -f1;
        }
        console2.log("numerator     %s", numerator);
        nextSqrtPrice = FullMath.mulDiv(numerator, FixedPoint96.Q96, 2 * bl).toUint160();
        console2.log("nextSqrtPrice %s", nextSqrtPrice);
    }

    function getNextSqrtPriceFromShield(uint160 sqrtPrice, uint128 liquidity, uint256 amount, uint unit) internal pure returns (uint160 nextSqrtPrice) {
        uint256 b_2 = FullMath.mulDiv(sqrtPrice, sqrtPrice, FixedPoint96.Q96);
        uint256 l = FullMath.mulDiv(liquidity, FixedPoint96.Q96, 1);
        // uint256 l_2 = FullMath.mulDiv(liquidity, liquidity, unit);
        uint256 b_2l = FullMath.mulDiv(b_2, l, FixedPoint96.Q96);
        uint256 bs = FullMath.mulDiv(sqrtPrice, amount, 1);
        uint256 bl = FullMath.mulDiv(sqrtPrice, liquidity, 1);
        uint256 f1 = b_2l + bs > l ? b_2l + bs - l : l - b_2l - bs;
        uint256 f_2 = FullMath.mulDiv(f1, f1 / unit, FixedPoint96.Q96);
        uint256 fourB_2L_2 = 4*FullMath.mulDiv(bl, bl, FixedPoint96.Q96*unit);
        uint256 underSqrt = Math.sqrt((f_2 + fourB_2L_2)) * Math.sqrt(FixedPoint96.Q96) * Math.sqrt(unit);
        uint256 numerator = underSqrt + b_2l + bs - l;
        nextSqrtPrice = FullMath.mulDiv(numerator, FixedPoint96.Q96, 2 * bl).toUint160();
    }
}
