// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { TradeType } from "core/types/common.sol";

struct ComputeTradeStepParams {
    TradeType tradeType;
    uint160 sqrtRatioCurrentX96;
    uint160 sqrtRatioTargetX96;
    uint128 liquidity;
    int256 amountRemaining;
    uint256 unit;
}
