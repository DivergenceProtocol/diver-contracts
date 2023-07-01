// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import { BattleKey, Fee } from "../types/common.sol";

struct DeploymentParams {
    address arenaAddr;
    BattleKey battleKey;
    address oracleAddr;
    address cOracleAddr;
    Fee fee;
    address spear;
    address shield;
    address manager;
}
