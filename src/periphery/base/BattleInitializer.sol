// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import { IBattleInitializer } from "../interfaces/IBattleInitializer.sol";
import { IArenaCreation } from "../../core/interfaces/IArena.sol";
import { IBattleInit } from "../../core/interfaces/battle/IBattleInit.sol";
import { IBattleState } from "../../core/interfaces/battle/IBattleState.sol";
import { TickMath } from "../../core/libs/TickMath.sol";
import { CreateAndInitBattleParams } from "../params/Params.sol";
import { PeripheryImmutableState } from "./PeripheryImmutableState.sol";
import { Errors } from "../../core/errors/Errors.sol";

abstract contract BattleInitializer is IBattleInitializer, PeripheryImmutableState {
    function createAndInitializeBattle(CreateAndInitBattleParams calldata params) external override returns (address battle) {
        battle = IArenaCreation(arena).getBattle(params.bk);
        if (battle == address(0)) {
            (battle) = IArenaCreation(arena).createBattle(params);
        } else {
            revert Errors.BattleExisted();
        }
    }
}
