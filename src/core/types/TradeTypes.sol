// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { GrowthX128 } from "./common.sol";

struct TradeCache {
    uint256 feeProtocol; //The protocol fee for the trade
}

struct TradeState {
    /// @dev How much collateral input or SToken output amount is remaining to be swapped in/out
    int256 amountSpecifiedRemaining;
    /// @dev The amount of collateral input or SToken output that has been calculated for the swap
    int256 amountCalculated;
    /// @dev A fixed point Q64.96 number representing the sqrt of the ratio of shieldPrice/spearPrice
    uint160 sqrtPriceX96;
    /// @dev The current tick
    int24 tick;
    /// @dev GrowthX128 info per unit of liquidity as of the last update to the pool's global state
    GrowthX128 global;
    /// @dev The amount of collateral token to be paid as protocol fee
    uint128 protocolFee;
    /// @dev The amount of usable liquidity
    uint128 liquidity;
    /// @dev The transaction fee for the trade
    uint256 transactionFee;
}

struct StepComputations {
    /// @dev The sqrtPrice from which to start step computation
    uint160 sqrtPriceStartX96;
    /// @dev The next tick up to the max or min tick of the virtual curve
    int24 tickNext;
    /// @dev Whether the next tick is initialized
    bool initialized;
    /// @dev The price after swapping the amount in/out, not to exceed the price target
    uint160 sqrtPriceNextX96;
    /// @dev The collateral amount to be swapped in, based on the direction of the swap
    uint256 amountIn;
    /// @dev The amount to be received, of either Spear or Shield token, based on the direction of the swap
    uint256 amountOut;
    /// @dev The amount of collateral input that will be taken as a fee
    uint256 feeAmount;
    /// @dev The lower tick for the step
    int24 tickLower;
    /// @dev The upper tick for the step
    int24 tickUpper;
}
