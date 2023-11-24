// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { LiquidityType } from "core/types/common.sol";

struct BattleBurnParams {
    int24 tickLower; //The lower tick boundary of the position for which to burn liquidity
    int24 tickUpper; //The upper tick boundary of the position for which to burn liquidity
    LiquidityType liquidityType; //The chosen liquidity type can be Collateral, Spear, or Shield
    uint128 liquidityAmount; //The amount of liquidity to be burnt
}
