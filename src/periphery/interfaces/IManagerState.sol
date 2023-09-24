// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { PositionState, Position } from "../types/common.sol";

interface IManagerState {
    
    /**
     * @notice Get the position belong to a nft
     */
    function positions(uint256 tokenId) external view returns (Position memory);

    function nextId() external view returns(uint);

}
