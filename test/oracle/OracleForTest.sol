// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IOracle } from "core/interfaces/IOracle.sol";

contract OracleForTest is IOracle {
    mapping(string => uint256) public price;
    mapping(string => mapping(uint256 => uint256)) public historyPrice;

    function setPrice(string memory symbol, uint256 ts, uint256 _price) public {
        price[symbol] = _price;
        historyPrice[symbol][ts] = _price;
    }

    function getPriceByExternal(address cOracleAddr, uint256 ts) public view returns (uint256 price_, uint256 actualTs) {
        // remove unused function paramter warnning
        cOracleAddr = cOracleAddr;
        price_ = price["BTC"];
        actualTs = ts;
    }

    function getCOracle(string memory symbol) external pure returns (address) {
        // remove unused function paramter warnning
        symbol = symbol;
        return address(1);
    }
}
