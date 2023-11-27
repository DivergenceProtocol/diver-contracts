// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import { FullMath } from "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import { FixedPoint96 } from "@uniswap/v3-core/contracts/libraries/FixedPoint96.sol";
import { SafeCast } from "@oz/utils/math/SafeCast.sol";
import { LiquidityAmounts } from "@uniswap/v3-periphery/contracts/libraries/LiquidityAmounts.sol";

library DiverLiquidityAmounts {
    using SafeCast for uint256;
    /// @notice Computes the amount of liquidity to be received by the pool, for a given amount of collateral and price range. The formula is:
    ///  L = ΔC*sqrtPrice*sqrt(P_h)/(sqrt(P_h) - sqrtPrice +
    /// sqrt(P_h)*sqrtPrice**2 - sqrtPrice*sqrt(P_h)*sqrt(P_l))
    /// @param sqrtRatioX96 The current square root ratio|
    /// @param sqrtRatioAX96 A sqrt ratio
    /// @param sqrtRatioBX96 Another sqrt ratio
    /// @param amount The seed collateral amount for minting the liquidity position
    /// @return liquidity The amount of liquidity to be received by the pool

    function getLiquidityFromCs(
        uint160 sqrtRatioX96,
        uint160 sqrtRatioAX96,
        uint160 sqrtRatioBX96,
        uint256 amount
    )
        internal
        pure
        returns (uint128 liquidity)
    {
        if (sqrtRatioAX96 > sqrtRatioBX96) {
            (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
        }
        if (sqrtRatioX96 <= sqrtRatioAX96) {
            liquidity = LiquidityAmounts.getLiquidityForAmount0(sqrtRatioAX96, sqrtRatioBX96, amount);
        } else if (sqrtRatioX96 < sqrtRatioBX96) {
            uint256 multi = FullMath.mulDivRoundingUp(sqrtRatioX96, sqrtRatioBX96, FixedPoint96.Q96);
            uint256 denominator = FullMath.mulDivRoundingUp(sqrtRatioX96 - sqrtRatioAX96, multi, FixedPoint96.Q96) + sqrtRatioBX96 - sqrtRatioX96;
            uint256 multi2 = FullMath.mulDiv(sqrtRatioX96, sqrtRatioBX96, FixedPoint96.Q96);
            liquidity = FullMath.mulDiv(amount * multi2, 1, denominator).toUint128();
        } else {
            liquidity = LiquidityAmounts.getLiquidityForAmount1(sqrtRatioAX96, sqrtRatioBX96, amount);
        }
    }

    /// @notice Computes the amount of liquidity to be received by the pool, for a given amount of Spear or Shield tokens and price range. The formula is:
    /**
     * @dev liquidity = (amount * sqrtRatioAX96 * sqrtRatioBX96) / (
     * (sqrtRatioBX96 - sqrtRatioAX96) * (1 +
     * sqrtRatioAX96 * sqrtRatioBX96));
     */
    /// @param sqrtRatioAX96 A sqrt ratio
    /// @param sqrtRatioBX96 Another sqrt ratio
    /// @param amount The seed Spear or Shield amount for minting the liquidity position
    /// @return liquidity The amount of liquidity to be received by the pool

    function getLiquidityFromSToken(uint160 sqrtRatioAX96, uint160 sqrtRatioBX96, uint256 amount) internal pure returns (uint128 liquidity) {
        if (sqrtRatioAX96 > sqrtRatioBX96) {
            (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
        }
        uint256 product = FullMath.mulDiv(sqrtRatioAX96, sqrtRatioBX96, FixedPoint96.Q96);
        liquidity = (FullMath.mulDiv(amount * sqrtRatioAX96, sqrtRatioBX96, sqrtRatioBX96 - sqrtRatioAX96) / (FixedPoint96.Q96 + product)).toUint128();
    }
}
