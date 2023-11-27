// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { GrowthX128, Owed, LiquidityType } from "core/types/common.sol";

enum PositionState {
    LiquidityAdded,
    LiquidityRemoved,
    ObligationWithdrawn,
    ObligationRedeemed
}

struct Position {
    uint256 tokenId;
    address battleAddr;
    int24 tickLower;
    int24 tickUpper;
    uint128 liquidity;
    LiquidityType liquidityType; // The chosen liquidity type can be Collateral, Spear, or Shield
    uint256 seed; //The amount of tokens from the LP for the given liquidity type |
    GrowthX128 insideLast; // GrowthX128 info per unit of liquidity inside the a position's bound as of the last action
    Owed owed; // the amounts of fees and deltas of collateral, Spear and Shield tokens that are owed to a position
    PositionState state; // obligation will be set when liquidity is removed
    uint256 spearObligation; //The obligatory reserve of collateral amount for settling spear tokens sold by the position
    uint256 shieldObligation; //The obligatory reserve of collateral amount for settling shield tokens sold by the position
}
