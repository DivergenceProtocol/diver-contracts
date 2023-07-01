// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IOracle} from "../../src/core/interfaces/IOracle.sol";

contract OracleForTest is IOracle {
    mapping(string => uint) public price;
    mapping (string=>mapping(uint => uint)) public historyPrice;
    function setPrice(string memory symbol, uint256 ts, uint256 _price) public {
        price[symbol] = _price;
        historyPrice[symbol][ts] = _price;
    }

    function getPriceByExternal(address cOracleAddr, uint256 ts) public view returns (uint256 price_, uint256 actualTs) { 
        price_ = price["BTC"];
        actualTs = ts;
    }

    function getCOracle(string memory symbol) external view returns(address) {
        return address(1);
    }
}
