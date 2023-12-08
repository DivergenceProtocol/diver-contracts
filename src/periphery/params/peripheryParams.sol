// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { BattleKey, LiquidityType, TradeType } from "core/types/common.sol";

/// @param bk The battle key
/// @param sqrtPriceX96 The start sqrt price of the battle
struct CreateAndInitBattleParams {
    BattleKey bk;
    uint160 sqrtPriceX96;
}

/// @notice Parameters for adding liquidity
/// @param battleKey The battle key
/// @param recipient The address that receives nft
/// @param tickLower The lower tick boundary of the position
/// @param tickUpper The upper tick boundary of the position
/// @param liquidityType Specifies the type of liquidity added to the position is collateral, spear, or shield
/// @param amount The amount of collateral/spear/shield to add
/// @param deadline The deadline of the transaction
struct AddLiqParams {
    BattleKey battleKey;
    address recipient;
    int24 tickLower;
    int24 tickUpper;
    uint160 minSqrtPriceX96;
    uint160 maxSqrtPriceX96;
    LiquidityType liquidityType;
    uint128 amount;
    uint256 deadline;
}

/// @param battleKey The battle key
/// @param tradeType The trade type, BUY_SPEAR or BUY_SHIELD
/// @param amountSpecified How much collateral input or SToken output amount to be swapped in/out
/// @param recipient The address that receives spear or shield tokens
/// @param amountOutMin The minimum amount of spear or shield tokens to receive
/// @param sqrtPriceLimitX96 The max/min price when trading ends
/// @param deadline The deadline of the transaction
struct TradeParams {
    BattleKey battleKey;
    TradeType tradeType;
    int256 amountSpecified;
    address recipient;
    uint256 amountOutMin;
    uint160 sqrtPriceLimitX96;
    uint256 deadline;
}
