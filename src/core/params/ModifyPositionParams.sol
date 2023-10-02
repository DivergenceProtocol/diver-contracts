// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { LiquidityType } from "core/types/enums.sol";

struct ModifyPositionParams {
    int24 tickLower;
    int24 tickUpper;
    LiquidityType liquidityType;
    int128 liquidityDelta;
}
