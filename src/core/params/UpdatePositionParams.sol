// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { ModifyPositionParams } from "./ModifyPositionParams.sol";

struct UpdatePositionParams {
    ModifyPositionParams mpParams;
    int24 tick;
}
