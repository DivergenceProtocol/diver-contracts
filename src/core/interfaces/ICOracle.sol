// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ICOracle {
    function priceOf(string memory symbol, uint256 ts) external view returns (uint256 price_);
}
