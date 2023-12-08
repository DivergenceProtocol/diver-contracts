// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title Get price from external oracle
/// @notice Retrieves underlying asset prices used for settling options.
interface IOracle {
    function getPriceByExternal(address cOracleAddr, uint256 ts) external view returns (uint256 price_, uint256 actualTs);

    function getCOracle(string memory symbol) external view returns (address);
}
