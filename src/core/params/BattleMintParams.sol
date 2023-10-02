// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { LiquidityType } from "core/types/enums.sol";

struct BattleMintParams {
    address recipient;
    int24 tickLower;
    int24 tickUpper;
    LiquidityType liquidityType;
    uint128 amount;
    uint128 seed;
    bytes data;
}
