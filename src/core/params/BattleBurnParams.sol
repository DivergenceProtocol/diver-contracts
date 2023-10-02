// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { LiquidityType } from "core/types/common.sol";

struct BattleBurnParams {
    int24 tickLower;
    int24 tickUpper;
    LiquidityType liquidityType;
    uint128 liquidityAmount;
}
