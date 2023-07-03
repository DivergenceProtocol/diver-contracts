// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import { IManagerState, Position, PositionState } from "../interfaces/IManagerState.sol";

interface IQuoter is IManagerState {
    /**
     * @notice Get all positions belong to an account
     */
    function accountPositions(address account) external view returns (Position[] memory);
}
