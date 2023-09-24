// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import { OracleForTest } from "./OracleForTest.sol";
import { Test } from "@std/Test.sol";

contract OracleForTestT is Test {
    function test_SetAndGetPriceShouldWork() public {
        OracleForTest oracle = new OracleForTest();
        uint256 price = 3000e18;
        oracle.setPrice("BTC", 2000, price);
        (uint256 actualPrice,) = oracle.getPriceByExternal(address(1), 2000);
        assertEq(price, actualPrice, "set price not work");
    }
}
