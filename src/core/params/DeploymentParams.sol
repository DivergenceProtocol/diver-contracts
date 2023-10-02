// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { BattleKey, Fee } from "core/types/common.sol";

struct DeploymentParams {
    address arenaAddr;
    BattleKey battleKey;
    address oracleAddr;
    address cOracleAddr;
    Fee fee;
    address spear;
    address shield;
    address manager;
    uint160 sqrtPriceX96;
}
