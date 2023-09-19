// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { SafeCast } from "@oz/utils/math/SafeCast.sol";
import { FullMath } from "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import { SqrtPriceMath } from "@uniswap/v3-core/contracts/libraries/SqrtPriceMath.sol";
import { DiverSqrtPriceMath } from "./DiverSqrtPriceMath.sol";
import { ComputeTradeStepParams } from "../params/ComputeTradeStepParams.sol";
import { TickMath } from "./TickMath.sol";
import { TradeType } from "../types/enums.sol";

library TradeMath {
    using SafeCast for int256;

    function computeTradeStep(ComputeTradeStepParams memory params)
        internal
        view
        returns (uint160 sqrtRatioNextX96, uint256 amountIn, uint256 amountOut)
    {
        bool isSpear = params.tradeType == TradeType.BUY_SPEAR;
        bool exactIn = params.amountRemaining >= 0;

        // calculate next price
        if (exactIn) {
            amountIn = isSpear
                ? SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, params.sqrtRatioTargetX96, params.liquidity, true)
                : SqrtPriceMath.getAmount1Delta(params.sqrtRatioCurrentX96, params.sqrtRatioTargetX96, params.liquidity, true);
            uint256 amount = uint256(params.amountRemaining);
            if (amount >= amountIn) {
                sqrtRatioNextX96 = params.sqrtRatioTargetX96;
            } else {
                sqrtRatioNextX96 = SqrtPriceMath.getNextSqrtPriceFromInput(params.sqrtRatioCurrentX96, params.liquidity, amount, isSpear);
                amountIn = amount;
            }
            amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, false);
        } else {
            amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, params.sqrtRatioTargetX96, params.liquidity, false);
            uint256 amount = uint256(-params.amountRemaining);
            if (amount >= amountOut) {
                sqrtRatioNextX96 = params.sqrtRatioTargetX96;
            } else {
                sqrtRatioNextX96 = isSpear
                    ? DiverSqrtPriceMath.getNextSqrtPriceFromSpear(
                        params.sqrtRatioCurrentX96, params.liquidity, uint256(-params.amountRemaining), params.unit
                    )
                    : DiverSqrtPriceMath.getNextSqrtPriceFromShield(
                        params.sqrtRatioCurrentX96, params.liquidity, uint256(-params.amountRemaining), params.unit
                    );
                amountOut = amount;
            }
            if (isSpear) {
                amountIn = SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true);
            } else {
                amountIn = SqrtPriceMath.getAmount1Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true);
            }
        }
    }
}
