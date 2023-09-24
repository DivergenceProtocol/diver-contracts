// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import { LiquidityType } from "../types/common.sol";

struct BattleBurnParams {
    int24 tickLower;
    int24 tickUpper;
    LiquidityType liquidityType;
    uint128 liquidityAmount;
}
