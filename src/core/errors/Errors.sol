// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

library Errors {
    error BattleNotEnd();
    error BattleEnd();
    error BattleSettled();
    error BattleNotExist();
    error BattleExisted();
    error Deadline();
    error InsufficientCollateral();
    error InsufficientSpear();
    error InsufficientShield();
    error InitTwice();
    error Insufficient();
    error LiquidityNotRemoved();
    error LiquidityNotAdded();
    error Locked();
    error NotSupported();
    error NotSupportedExpiries();
    error NotWETH9();
    error OnlyOwner();
    error OnlyBattle();
    error OnlyManager();
    error OraclePriceError();
    error PriceInvalid();
    error Slippage();
    error TickOrderInvalid();
    error TickInvalid();
    error TradeError();
    error ZeroValue();
    error EmptyTrade();
}
