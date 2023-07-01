// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/// @title Get external price by oracle
/// @notice Collects and updates underlying asset prices used for settling
/// options.
/// It retrieves asset prices and supplies them to all contracts that use them.
interface IOracle {
    // function price(string memory symbol) external view returns (uint256);

    // function historyPrice(string memory symbol, uint256 ts) external view returns (uint256);

    // function updatePriceByExternal(string memory symbol, uint256 ts) external returns (uint256 price_);

    function getPriceByExternal(address cOracleAddr, uint256 ts) external view returns (uint256 price_, uint256 actualTs);

    function getCOracle(string memory symbol) external view returns(address);
}
