// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {getAdjustPrice} from "../src/core/utils.sol";
import { Test } from "@std/Test.sol";
import { console2 } from "@std/console2.sol";

contract AdjustPriceTest is Test {

    function testAdjustShouldWork() public {
        uint price = 1234e18;
        uint priceAdjusted = getAdjustPrice(price);
        assertEq(priceAdjusted, 1200e18);

        uint p1 = 0.0003211e18;
        uint pa1 = getAdjustPrice(p1);
        assertEq(pa1, 0.00032e18);

        uint p2 = 1.1e12;
        uint pa2 = getAdjustPrice(p2);
        assertEq(pa2, 1.1e12);

        uint p3 = 2.234e12;
        uint pa3 = getAdjustPrice(p3);
        assertEq(pa3, 2.2e12);


        uint p4 = 2.23311e18;
        uint pa4 = getAdjustPrice(p4);
        assertEq(pa4, 2.2e18);
    }
}