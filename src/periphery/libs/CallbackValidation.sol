// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import { BattleKey } from "core/types/common.sol";
import { IArenaCreation } from "core/interfaces/IArena.sol";
import { Errors } from "core/errors/Errors.sol";

library CallbackValidation {
    function verifyCallback(address arenaAddr, BattleKey memory battleKey) internal view {
        require(IArenaCreation(arenaAddr).getBattle(battleKey) == msg.sender, "onlyBattle");
        if (IArenaCreation(arenaAddr).getBattle(battleKey) != msg.sender) {
            revert Errors.OnlyBattle();
        }
    }
}
