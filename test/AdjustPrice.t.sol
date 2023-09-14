// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {getAdjustPrice} from "../src/core/utils.sol";
import { Test } from "@std/Test.sol";
import { console2 } from "@std/console2.sol";

contract AdjustPriceTest is Test {

    function testAdjustShouldWork() public {
        uint price = 1234e18;
        uint priceAdjusted = getAdjustPrice(price);
        console2.log("p %s", priceAdjusted);
        assertEq(priceAdjusted, 1200e18);

        uint p1 = 0.0003211e18;
        uint pa1 = getAdjustPrice(p1);
        console2.log("pa1 %s", pa1);

        uint p2 = 1e12;
        uint pa2 = getAdjustPrice(p2);
        console2.log("pa2 %s", pa2);

        uint p3 = 2.234e12;
        uint pa3 = getAdjustPrice(p3);
        console2.log("pa3 %s", pa3);


        uint p4 = 2.23311e18;
        uint pa4 = getAdjustPrice(p4);
        console2.log("pa4 %s", pa4);
    }
}