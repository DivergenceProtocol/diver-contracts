// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

struct CreateBattleParams {
    address collateralToken; //The supported collateral token address for the battle
    string underlying; //The underlying asset symbol
    uint256 expiries; //The of expiry timestamp of the battle
    uint256 strikeValue; //The value of an option's strike price
}
