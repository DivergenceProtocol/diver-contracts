// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { TickMath as UniTickMath } from "@uniswap/v3-core/contracts/libraries/TickMath.sol";
import { Errors } from "../errors/Errors.sol";

library TickMath {
    int24 internal constant MIN_TICK = -45953;
    int24 internal constant MAX_TICK = 45953;

    uint160 internal constant MIN_SQRT_RATIO = 7_962_927_413_460_596_097_951_659_957;
    uint160 internal constant MAX_SQRT_RATIO = 788_290_713_886_932_820_263_790_562_376;

    function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
        if (!(tick >= MIN_TICK && tick <= MAX_TICK)) {
            revert Errors.TickInvalid();
        }
        return UniTickMath.getSqrtRatioAtTick(tick);
    }

    function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
        if (!(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO)) {
            revert Errors.PriceInvalid();
        }
        return UniTickMath.getTickAtSqrtRatio(sqrtPriceX96);
    }
}
