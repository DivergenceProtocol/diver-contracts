// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { LiquidityType } from "core/types/enums.sol";

struct BattleMintParams {
    address recipient; //The address for which the liquidity will be added
    int24 tickLower; //The lower tick boundary of the position in which to add liquidity
    int24 tickUpper; //The upper tick boundary of the position in which to add liquidity
    LiquidityType liquidityType; //The chosen liquidity type can be Collateral, Spear, or Shield
    uint128 amount; // The amount of liquidity to be added
    uint128 seed; //The seed amount for the given liquidity type
    bytes data;
}
