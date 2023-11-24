// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { TradeType } from "core/types/common.sol";

struct ComputeTradeStepParams {
    TradeType tradeType; //whether to buy spear or buy shield
    uint160 sqrtRatioCurrentX96; //The current sqrt ratio of the pool
    uint160 sqrtRatioTargetX96; //The price that cannot be exceeded, from which the direction of the swap is inferred
    uint128 liquidity; // The usable liquidity
    int256 amountRemaining; //How much input or output amount is remaining to be swapped in/out
    uint256 unit; //The token decimal unit, e.g. a token with 18 decimals has a unit of 10**18
}
