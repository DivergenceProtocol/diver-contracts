// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { BattleKey, Fee } from "core/types/common.sol";

struct DeploymentParams {
    address arenaAddr; //The address for the arena contract
    BattleKey battleKey; //The battle Key containing a pool's specifications
    address oracleAddr; //The address for the oracle
    address cOracleAddr; //the contract address for a chainlink price feed
    Fee fee; // The fee structure for the battle
    address spear; //The address of the Spear tokens for a pool
    address shield; // The address of the Shield tokens for a pool
    address manager; //The address for the manager contract
    uint160 sqrtPriceX96; //The starting sqrt ratio when initiating a battle
}
