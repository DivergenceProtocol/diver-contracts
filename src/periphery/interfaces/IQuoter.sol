// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import { IManagerState, Position, PositionState } from "../interfaces/IManagerState.sol";
import { BattleTradeParams } from "../../core/params/BattleTradeParams.sol";

interface IQuoter is IManagerState {
    /**
     * @notice Get all positions belong to an account
     */
    function accountPositions(address account) external view returns (Position[] memory);

    function quoteExactInput(BattleTradeParams memory params, address battleAddr) external returns (uint256 spend, uint256 get);
}
