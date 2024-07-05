// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ICOracle } from "./interfaces/ICOracle.sol";

contract OracleCustomV2 is ICOracle {

    function priceOf(string memory symbol, uint256 ts) external override view returns (uint256 price_) {
        return 0;
    }
}
