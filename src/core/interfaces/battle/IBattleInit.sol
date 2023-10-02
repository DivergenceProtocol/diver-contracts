// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { DeploymentParams } from "core/params/coreParams.sol";

interface IBattleInit {
    function init(DeploymentParams memory params) external;
}
