// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import { PositionState, Position } from "../types/common.sol";
import { BattleTradeParams } from "core/params/BattleTradeParams.sol";

interface IQuoter {
    function positions(uint256 tokenId) external view returns (Position memory);

    /**
     * @notice Get all positions belong to an account
     */
    function accountPositions(address account) external view returns (Position[] memory);

    function quoteExactInput(BattleTradeParams memory params, address battleAddr) external returns (uint256 spend, uint256 get);
}
