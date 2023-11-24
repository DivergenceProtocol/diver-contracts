// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { LiquidityType } from "core/types/enums.sol";

struct ModifyPositionParams {
    int24 tickLower; //The lower tick boundary of the position
    int24 tickUpper; //The upper tick boundary of the position
    LiquidityType liquidityType; //The chosen liquidity type can be Collateral, Spear, or Shield
    int128 liquidityDelta; //The change in liquidity
}
