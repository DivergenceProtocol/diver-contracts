// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Test } from "@std/Test.sol";
import { OracleCustom } from "core/OracleCustom.sol";
import { Oracle } from "core/Oracle.sol";
import { console2 } from "@std/console2.sol";

contract OracleCustomTest is Test {
    OracleCustom public oc;
    Oracle public oracle;
    string[] public symbols;
    address[] public oracles;

    function setUp() public virtual {
        oc = new OracleCustom();
        oracle = new Oracle();
        symbols.push("XX");
        oracles.push(address(oc));
        oracle.setExternalOracle(symbols, oracles);
    }

    function test_getPriceByExternal() public {
        console2.log(block.timestamp);
        (uint256 p, uint256 ts) = oracle.getPriceByExternal(address(oc), 1);
        assertEq(p, 0);
        assertEq(ts, 0);
    }

    function test_getPriceByExternal_After1Hour() public {
        vm.warp(2 hours);
        vm.expectRevert("setting price");
        oracle.getPriceByExternal(address(oc), 1);
        uint256 price = 2500e18;
        oracle.setFixPrice("XX", 1, price);
        (uint256 p, uint256 ts) = oracle.getPriceByExternal(address(oc), 1);
        assertEq(p, price);
        assertEq(ts, 1);
    }
}
