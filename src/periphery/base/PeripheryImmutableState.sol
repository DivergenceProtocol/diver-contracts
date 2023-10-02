// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IPeripheryImmutableState } from "../interfaces/IPeripheryImmutableState.sol";
import { Errors } from "core/errors/Errors.sol";

abstract contract PeripheryImmutableState is IPeripheryImmutableState {
    address public immutable arena;
    address public immutable WETH9;

    constructor(address _arena, address _WETH9) {
        if (_arena == address(0) || _WETH9 == address(0)) {
            revert Errors.ZeroValue();
        }
        arena = _arena;
        WETH9 = _WETH9;
    }
}
