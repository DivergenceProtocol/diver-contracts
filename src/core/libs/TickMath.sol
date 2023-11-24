// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { TickMath as UniTickMath } from "@uniswap/v3-core/contracts/libraries/TickMath.sol";
import { Errors } from "core/errors/Errors.sol";

/// @notice Math library for computing sqrt prices from ticks and vice versa. Sets the minimum and maximum of ticks and sqrt prices.
/// As digital calls and puts are priced between [0.01, 0.99] per collateral, per put-call parity, the sqrtPrice is the sqrt ratio of shieldPrice/spearPrice is between [sqrt(1/99), sqrt(99)].
/// Computes sqrtPrice for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers.

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
