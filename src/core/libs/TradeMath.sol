// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { SafeCast } from "@oz/utils/math/SafeCast.sol";
import { FullMath } from "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import { SqrtPriceMath } from "@uniswap/v3-core/contracts/libraries/SqrtPriceMath.sol";
import { DiverSqrtPriceMath } from "./DiverSqrtPriceMath.sol";
import { ComputeTradeStepParams } from "core/params/ComputeTradeStepParams.sol";
import { TickMath } from "./TickMath.sol";
import { TradeType } from "core/types/enums.sol";

import { console2 } from "@std/console2.sol";

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
        console2.log("liquidity in step %s", params.liquidity);
        if (exactIn) {
            amountIn = isSpear
                ? SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, params.sqrtRatioTargetX96, params.liquidity, true)
                : SqrtPriceMath.getAmount1Delta(params.sqrtRatioCurrentX96, params.sqrtRatioTargetX96, params.liquidity, true);
            uint256 amount = uint256(params.amountRemaining);
            console2.log("current: %s", params.sqrtRatioCurrentX96);
            console2.log("target : %s", params.sqrtRatioTargetX96);
            console2.log("remain amount: %s", amount);
            console2.log("cap amountIn:  %s", amountIn);
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
        console2.log("reamin in TradeMath    %s", params.amountRemaining);
        console2.log("amountIn in TradeMath  %s", amountIn);
        console2.log("amountOut in TradeMath %s", amountOut);
    }
}
