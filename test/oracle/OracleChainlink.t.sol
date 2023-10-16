// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Test } from "@std/Test.sol";
import { AggregatorV3Interface } from "chainlink/interfaces/AggregatorV3Interface.sol";
import { console2 } from "@std/console2.sol";
import { Oracle } from "core/Oracle.sol";
import { getTS, Period } from "../shared/utils.sol";

contract OracleChainlinkTest is Test {
    address btc_usd = 0x6ce185860a4963106506C203335A2910413708e9;
    address eth_usd = 0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612;
    Oracle oracle;

    string[] public underlyings;
    address[] public oracles;

    function setUp() public virtual {
        console2.log(">>>Divergence Protocol Solidity Test<<<");
        vm.createSelectFork("arbitrum_ankr");
        oracle = new Oracle();
        underlyings.push("BTC");
        underlyings.push("ETH");
        oracles.push(btc_usd);
        oracles.push(eth_usd);
        oracle.setExternalOracle(underlyings, oracles);
    }

    function test_chainLink() public {
        // (uint256 start, uint256 expiries) = getTS(Period.BIWEEKLY);
        console2.log("now: %s", block.timestamp);
        (uint256 price_, uint256 actualTs) = oracle.getPriceByExternal(oracles[0], block.timestamp - 1000);
        console2.log("price: %s, actualTs: %s", price_, actualTs);
        assertGt(price_, 0);
        assertGe(actualTs, 0);
    }

    function test_GtLatestRound() public view {
        (uint80 roundId,,,,) = AggregatorV3Interface(btc_usd).latestRoundData();
        (uint80 roundId1, int256 answer1, uint256 startedAt1, uint256 updatedAt1,) = AggregatorV3Interface(btc_usd).getRoundData(roundId + 1);
        console2.log("roundId1 %s", roundId1);
        console2.log("answer1 %s", answer1);
        console2.log("startedAt1 %s", startedAt1);
        console2.log("updateAt1 %s", updatedAt1);
    }
}
