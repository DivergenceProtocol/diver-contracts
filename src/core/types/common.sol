// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LiquidityType, Outcome, TradeType } from "core/types/enums.sol";

struct BattleKey {
    /// @dev The address of the token used as collateral in the battle, eg: usdt/usdc
    address collateral;
    /// @dev The underlying asset symbol, such as btc, eth, etc
    string underlying;
    /// @dev end time of the battle
    uint256 expiries;
    /// @dev strike price of the options within the pool
    uint256 strikeValue;
}

struct Fee {
    /// @dev The fee ratio taken on every trade
    uint256 transactionFee;
    /// @dev The portion of transaction fee that goes to the protocol
    uint256 protocolFee;
    /// @dev The exercise fee paid by those who call exercise()
    uint256 exerciseFee;
}

struct GrowthX128 {
    /// @dev The all-time growth in transaction fee, per unit of liquidity, in collateral token
    uint256 fee;
    /// @dev The all-time growth in the received collateral inputs, per unit of liquidity, as options premium
    uint256 collateralIn;
    /// @dev The all-time growth in Spear token outputs per unit of liquidity
    uint256 spearOut;
    /// @dev The all-time growth in Shield token outputs per unit of liquidity
    uint256 shieldOut;
}

/// @notice tracking the GrowthX128 amounts owed to a position
struct Owed {
    /// @dev The amount of transaction fee owed to the position as of the last computation
    uint128 fee;
    /// @dev The collateral inputs owed to the position as of the last computation
    uint128 collateralIn;
    /// @dev The Spear token outputs owed to the position as of the last computation
    uint128 spearOut;
    /// @dev The Shield token outputs owed to the position as of the last computation
    uint128 shieldOut;
}

struct TickInfo {
    /// @dev The total amount of liquidity that the pool uses either at tickLower or tickUpper
    uint128 liquidityGross;
    /// @dev The amount of liquidity added (subtracted) when tick is crossed from left to right (right to left)
    int128 liquidityNet;
    /// @dev The GrowthX128 info recorded on the other side of the tick from the current tick
    GrowthX128 outside;
    /// @dev Whether the tick is initialized
    bool initialized;
}

struct PositionInfo {
    /// @dev The amount of usable liquidity
    uint128 liquidity;
    /// @dev The GrowthX128 info per unit of liquidity inside the a position's bound as of the last action
    GrowthX128 insideLast;
}
