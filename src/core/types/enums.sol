// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

enum LiquidityType {
    COLLATERAL,
    SPEAR,
    SHIELD
}

enum Outcome {
    ONGOING, // battle is ongoing
    SPEAR_WIN, // calls expire in-the-money
    SHIELD_WIN // puts expire in-the-money

}

enum TradeType {
    BUY_SPEAR,
    BUY_SHIELD
}
