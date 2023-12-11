// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { AggregatorV3Interface } from "chainlink/interfaces/AggregatorV3Interface.sol";

contract OracleCustom is AggregatorV3Interface {
    uint80 public constant start = (1 << 64) | 1;

    function decimals() external pure override returns (uint8) {
        return 18;
    }

    function description() external pure override returns (string memory) {
        return "Custom";
    }

    function version() external pure returns (uint256) {
        return 1;
    }

    function getRoundData(uint80 _roundId)
        external
        pure
        override
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return (start, 0, 0, 0, 0);
    }

    function latestRoundData()
        external
        pure
        override
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return (start, 0, 0, 0, 0);
    }
}
