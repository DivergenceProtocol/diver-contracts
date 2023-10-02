// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { CreateAndInitBattleParams } from "periphery/params/peripheryParams.sol";

interface IBattleInitializer {
    function createAndInitializeBattle(CreateAndInitBattleParams memory params) external returns (address battle);
}
