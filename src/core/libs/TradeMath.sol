// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { SafeCast } from "@oz/utils/math/SafeCast.sol";
import { FullMath } from "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import { SqrtPriceMath } from "@uniswap/v3-core/contracts/libraries/SqrtPriceMath.sol";
import { DiverSqrtPriceMath } from "./DiverSqrtPriceMath.sol";
import { ComputeTradeStepParams } from "../params/ComputeTradeStepParams.sol";
import { TickMath } from "./TickMath.sol";
import { TradeType } from "../types/enums.sol";

import { console2 } from "@std/console2.sol";

library TradeMath {
    using SafeCast for int256;

    error NotSupportYet();

    // function computeTradeStep(ComputeTradeStepParams memory params)
    //     internal
    //     pure
    //     returns (uint160 sqrtRatioNextX96, uint256 amountIn, uint256 amountOut)
    // {
    //     if (params.amountRemaining < 0) {
    //         revert NotSupportYet();
    //     }
    //     bool isSpear = params.tradeType == TradeType.BUY_SPEAR;
    //     if (isSpear) {
    //         // buy spear
    //         uint256 cap = SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, params.sqrtRatioTargetX96, params.liquidity, false);
    //         if (params.amountRemaining < cap) {
    //             sqrtRatioNextX96 = SqrtPriceMath.getNextSqrtPriceFromInput(params.sqrtRatioCurrentX96, params.liquidity, params.amountRemaining, true);
    //             amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, false);

    //             // values.amountIn = params.amountRemaining;
    //             amountIn = SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true);
    //         } else {
    //             sqrtRatioNextX96 = params.sqrtRatioTargetX96;
    //             amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, false);

    //             amountIn = SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true);
    //         }
    //     } else {
    //         // buy shield
    //         uint256 cap = SqrtPriceMath.getAmount1Delta(params.sqrtRatioCurrentX96, params.sqrtRatioTargetX96, params.liquidity, false);
    //         if (params.amountRemaining < cap) {
    //             sqrtRatioNextX96 =
    //                 SqrtPriceMath.getNextSqrtPriceFromInput(params.sqrtRatioCurrentX96, params.liquidity, params.amountRemaining, false);
    //             amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, false);

    //             amountIn = SqrtPriceMath.getAmount1Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true);
    //         } else {
    //             sqrtRatioNextX96 = params.sqrtRatioTargetX96;
    //             amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, false);

    //             amountIn = SqrtPriceMath.getAmount1Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true);
    //         }
    //     }
    // }

    function computeTradeStep(ComputeTradeStepParams memory params)
        internal
        view
        returns (uint160 sqrtRatioNextX96, uint256 amountIn, uint256 amountOut)
    {
        bool isSpear = params.tradeType == TradeType.BUY_SPEAR;
        bool exactIn = params.amountRemaining >= 0;

        // calculate next price
        console2.log("liquidity in step %s", params.liquidity);
        uint160 sqrtRatioNextX96Down;
        uint160 sqrtRatioNextX96Up;
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
                // sqrtRatioNextX96Up = params.sqrtRatioTargetX96;
                // sqrtRatioNextX96Down = params.sqrtRatioTargetX96;
            } else {
                sqrtRatioNextX96 = SqrtPriceMath.getNextSqrtPriceFromInput(params.sqrtRatioCurrentX96, params.liquidity, amount, isSpear);
                // sqrtRatioNextX96Up = SqrtPriceMath.getNextSqrtPriceFromInput(params.sqrtRatioCurrentX96, params.liquidity, amount, true);
                // sqrtRatioNextX96Down = SqrtPriceMath.getNextSqrtPriceFromInput(params.sqrtRatioCurrentX96, params.liquidity, amount, false);
            }
        } else {
            amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, params.sqrtRatioTargetX96, params.liquidity, false);
            uint256 amount = uint256(-params.amountRemaining);
            if (amount >= amountOut) {
                sqrtRatioNextX96 = params.sqrtRatioTargetX96;
                sqrtRatioNextX96Up = sqrtRatioNextX96;
                sqrtRatioNextX96Down = sqrtRatioNextX96;
            } else {
                sqrtRatioNextX96 = isSpear
                    ? DiverSqrtPriceMath.getNextSqrtPriceFromSpear(
                        params.sqrtRatioCurrentX96, params.liquidity, uint256(-params.amountRemaining), params.unit
                    )
                    : DiverSqrtPriceMath.getNextSqrtPriceFromShield(
                        params.sqrtRatioCurrentX96, params.liquidity, uint256(-params.amountRemaining), params.unit
                    );
                sqrtRatioNextX96Up = sqrtRatioNextX96 + 1;
                sqrtRatioNextX96Down = sqrtRatioNextX96;
            }
        }
        bool max = params.sqrtRatioTargetX96 == sqrtRatioNextX96;

        if (isSpear) {

            // if (max && exactIn) {
                
            // } else if (max && !exactIn) {
            //     amountIn = SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Down, params.liquidity, true);
            // } else if (!max && exactIn) {
            //     // amountIn = SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Down, params.liquidity, true);
            //     amountIn = uint(params.amountRemaining);
            // } else if (!max && !exactIn) {
            //     amountIn = SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Down, params.liquidity, true);
            // }

            // amountIn = max && exactIn
            //     ? amountIn
            //     : SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true);
            amountIn = max && exactIn
                ? amountIn
                // ? SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true)
                : SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true);


            // if (max && !exactIn) {

            // } else if (max && exactIn) {
            //     amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Up, params.liquidity, false);
            // } else if (!max && exactIn) {
            //     amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Up, params.liquidity, false);
            // } else if (!max && !exactIn) {
            //     amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Up, params.liquidity, false);
            // }
            amountOut = max && !exactIn
                ? amountOut
                : DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, false);

            // if (max && !exactIn) {

            // } else if (max && exactIn) {
            //     amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Down, params.liquidity, false);
            // } else if (!max && !exactIn) {
            //     amountOut = uint(-params.amountRemaining);
            // } else if (!max && exactIn) {
            //     amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Down, params.liquidity, false);
            // }
        } else {
            amountIn = max && exactIn
                ? amountIn
                // ? SqrtPriceMath.getAmount1Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true)
                : SqrtPriceMath.getAmount1Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true);

            // if (max && exactIn) {

            // } else if (max && !exactIn) {
            //     amountIn = SqrtPriceMath.getAmount1Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Down, params.liquidity, true);
            // } else if (!max && exactIn) {
            //     amountIn = uint(params.amountRemaining);
            // } else if (!max && !exactIn) {
            //     amountIn = SqrtPriceMath.getAmount1Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Down, params.liquidity, true);
            // }



            // if (max && !exactIn) {
            //     amountOut = amountOut;
            // } else if (max && exactIn) {
            //     amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Up, params.liquidity, false);
            // } else if (!max && !exactIn) {
            //     amountOut = uint(-params.amountRemaining);
            //     // amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Up, params.liquidity, true);
            // } else if (!max && exactIn) {
            //     amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Up, params.liquidity, false);
            // }

            amountOut = max && !exactIn
                ? amountOut 
                : DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, exactIn ? false : true);
                // : DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96Up, params.liquidity, false);
        }
        console2.log("reamin in TradeMath    %s", params.amountRemaining);
        console2.log("amountIn in TradeMath  %s", amountIn);
        console2.log("amountOut in TradeMath %s", amountOut);
    }

    //  if (isSpear) {
    //         // buy spear
    //         uint256 cap = SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, params.sqrtRatioTargetX96, params.liquidity, false);
    //         if (params.amountRemaining < int(cap)) {
    //             sqrtRatioNextX96 = SqrtPriceMath.getNextSqrtPriceFromInput(params.sqrtRatioCurrentX96, params.liquidity, uint(params.amountRemaining), true);
    //             amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, false);

    //             // values.amountIn = params.amountRemaining;
    //             amountIn = SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true);
    //         } else {
    //             sqrtRatioNextX96 = params.sqrtRatioTargetX96;
    //             amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, false);

    //             amountIn = SqrtPriceMath.getAmount0Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true);
    //         }
    //     } else {
    //         // buy shield
    //         uint256 cap = SqrtPriceMath.getAmount1Delta(params.sqrtRatioCurrentX96, params.sqrtRatioTargetX96, params.liquidity, false);
    //         if (params.amountRemaining < int256(cap)) {
    //             sqrtRatioNextX96 =
    //                 SqrtPriceMath.getNextSqrtPriceFromInput(params.sqrtRatioCurrentX96, params.liquidity, uint(params.amountRemaining), false);
    //             amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, false);

    //             amountIn = SqrtPriceMath.getAmount1Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true);
    //         } else {
    //             sqrtRatioNextX96 = params.sqrtRatioTargetX96;
    //             amountOut = DiverSqrtPriceMath.getSTokenDelta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, false);

    //             amountIn = SqrtPriceMath.getAmount1Delta(params.sqrtRatioCurrentX96, sqrtRatioNextX96, params.liquidity, true);
    //         }
    //     }
    // }
}
