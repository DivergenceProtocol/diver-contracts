// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Oracle } from "../../src/core/Oracle.sol";

contract OracleForTest is Oracle {
    mapping(string => uint) public price;
    mapping (string=>mapping(uint => uint)) public historyPrice;
    function setPrice(string memory symbol, uint256 ts, uint256 _price) public {
        price[symbol] = _price;
        historyPrice[symbol][ts] = _price;
    }

    function getPriceByExternal(address cOracleAddr, uint256 ts) public view override returns (uint256 price_, uint256 actualTs) { 
        price_ = price["BTC"];
        actualTs = ts;
    }
}
