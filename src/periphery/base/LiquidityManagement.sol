// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import { SqrtPriceMath } from "@uniswap/v3-core/contracts/libraries/SqrtPriceMath.sol";
import { IArenaCreation } from "core/interfaces/IArena.sol";
import { IBattleActions } from "core/interfaces/battle/IBattleActions.sol";
import { IBattleState } from "core/interfaces/battle/IBattleState.sol";
import { BattleKey } from "core/types/common.sol";
import { TickMath } from "core/libs/TickMath.sol";
import { Errors } from "core/errors/Errors.sol";
import { LiquidityType } from "core/types/enums.sol";
import { IMintCallback } from "core/interfaces/callback/IMintCallback.sol";
import { BattleMintParams } from "core/params/coreParams.sol";
import { DiverLiquidityAmounts } from "../libs/DiverLiquidityAmounts.sol";
import { CallbackValidation } from "../libs/CallbackValidation.sol";
import { PeripheryPayments } from "./PeripheryPayments.sol";
import { AddLiqParams } from "../params/peripheryParams.sol";
import { PeripheryImmutableState } from "./PeripheryImmutableState.sol";

abstract contract LiquidityManagement is IMintCallback, PeripheryImmutableState, PeripheryPayments {
    struct MintCallbackData {
        BattleKey battleKey;
        address token;
        address payer;
    }

    /// @notice Called to msg.sender after minting liquidity to a position
    /// @param amountOwed The amount of tokens owed for the minted liquidity
    /// @param data Any data passed through by the caller
    function mintCallback(uint256 amountOwed, bytes calldata data) external override {
        MintCallbackData memory decode = abi.decode(data, (MintCallbackData));
        CallbackValidation.verifyCallback(arena, decode.battleKey);
        if (amountOwed > 0) {
            pay(decode.token, decode.payer, msg.sender, amountOwed);
        }
    }

    /// @notice Add liquidity to an initialized pool
    /// @return liquidityAmount The amount of liquidity to add
    /// @return battleAddr The address to which an AMM pool is created
    function _addLiquidity(AddLiqParams memory params) internal returns (uint128 liquidityAmount, address battleAddr) {
        battleAddr = IArenaCreation(arena).getBattle(params.battleKey);
        if (battleAddr == address(0)) {
            revert Errors.BattleNotExist();
        }
        (uint160 sqrtPriceX96,,) = IBattleState(battleAddr).slot0();
        if (sqrtPriceX96 < params.minSqrtPriceX96 || sqrtPriceX96 > params.maxSqrtPriceX96) {
            revert Errors.Slippage();
        }
        if (params.liquidityType == LiquidityType.COLLATERAL) {
            liquidityAmount = DiverLiquidityAmounts.getLiquidityFromCs(
                sqrtPriceX96, TickMath.getSqrtRatioAtTick(params.tickLower), TickMath.getSqrtRatioAtTick(params.tickUpper), params.amount
            );
        } else {
            liquidityAmount = DiverLiquidityAmounts.getLiquidityFromSToken(
                TickMath.getSqrtRatioAtTick(params.tickLower), TickMath.getSqrtRatioAtTick(params.tickUpper), params.amount
            );
        }

        address token;
        if (params.liquidityType == LiquidityType.COLLATERAL) {
            token = params.battleKey.collateral;
        } else if (params.liquidityType == LiquidityType.SPEAR) {
            (address spear,) = IBattleState(battleAddr).spearAndShield();
            token = spear;
        } else {
            (, address shield) = IBattleState(battleAddr).spearAndShield();
            token = shield;
        }

        IBattleActions(battleAddr).mint(
            BattleMintParams({
                recipient: params.recipient,
                tickLower: params.tickLower,
                tickUpper: params.tickUpper,
                liquidityType: params.liquidityType,
                amount: liquidityAmount,
                seed: params.amount,
                data: abi.encode(MintCallbackData({battleKey: params.battleKey, token: token, payer: msg.sender}))
            })
        );
    }
}
