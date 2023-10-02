// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { getAdjustPrice } from "core/utils.sol";
import { Test } from "@std/Test.sol";
import { console2 } from "@std/console2.sol";

contract AdjustPriceTest is Test {
    function testAdjustShouldWork() public {
        uint256 price = 1234e18;
        uint256 priceAdjusted = getAdjustPrice(price);
        assertEq(priceAdjusted, 1200e18);

        uint256 p1 = 0.0003211e18;
        uint256 pa1 = getAdjustPrice(p1);
        assertEq(pa1, 0.00032e18);

        uint256 p2 = 1.1e12;
        uint256 pa2 = getAdjustPrice(p2);
        assertEq(pa2, 1.1e12);

        uint256 p3 = 2.234e12;
        uint256 pa3 = getAdjustPrice(p3);
        assertEq(pa3, 2.2e12);

        uint256 p4 = 2.23311e18;
        uint256 pa4 = getAdjustPrice(p4);
        assertEq(pa4, 2.2e18);
    }
}
