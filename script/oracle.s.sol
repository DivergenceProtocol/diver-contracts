// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { BaseScript } from "./shared/Base.s.sol";
import {Oracle} from "../src/core/Oracle.sol";
import { TestERC20 } from "../test/shared/TestERC20.sol";

contract OracleSet is BaseScript {
    string[] public symbols;
    address[] public oracles;

    function setUp() public virtual override {
        super.setUp();
    }

    function run() public broadcaster {
        // mintToken();
        setPriceForTest();
    }

    function setPriceForTest() public {
        Oracle oracle = Oracle(address(0xcA4988Dc5002E966E361e7d8A927b2201b955408));
        address owner = oracle.owner();

        symbols.push("BTC");
        symbols.push("ETH");
        oracles.push(address(0x8bdFc91FB3f89F4c211461B06afDe84Dc55bedc2));
        oracles.push(address(0x1B8e08a5457b12ae3CbC4233e645AEE2fA809e39));
        oracle.setExternalOracle(symbols, oracles);
        // oracle.setPrice("BTC", 1682668800, 29495e18);
    }

    function mintToken() public {
        TestERC20 token = TestERC20(address(0xA87B4e604aCefd6Cf6059bb73a7b4e0bA90434DA));
        token.mint();
        token.transfer(address(0x22Ca9b22095DE647C28debC4dEa2Cb252Dfd531A), 100000e18);
    }
}
