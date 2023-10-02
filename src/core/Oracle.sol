// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Ownable } from "@oz/access/Ownable.sol";
import { SafeCast } from "@oz/utils/math/SafeCast.sol";
import { AggregatorV3Interface } from "chainlink/interfaces/AggregatorV3Interface.sol";
import { getAdjustPrice } from "./utils.sol";

/// @title Oracle
/// @notice Get external price by Oracle
contract Oracle is Ownable {
    using SafeCast for int256;

    mapping(string => address) private externalOracleOf;
    mapping(uint80 => uint80) public startRoundId;
    mapping(uint80 => uint80) public endRoundId;
    mapping(address => mapping(uint256 => uint256)) public fixPrices;
    uint80 public latestPhase;

    /// @notice Defines the underlying asset symbol and oracle address for a
    /// pool.  Only called by the owner.
    /// @param symbols The asset symbol for which to retrieve price feed
    /// @param _oracles The external oracle address
    function setExternalOracle(string[] calldata symbols, address[] calldata _oracles) external onlyOwner {
        require(symbols.length == _oracles.length, "symbols not match oracles");
        for (uint256 i = 0; i < symbols.length; i++) {
            require(_oracles[i] != address(0), "Zero Address");
            externalOracleOf[symbols[i]] = _oracles[i];
        }
    }

    /// @notice Gets and computes price from external oracles
    /// @param cOracleAddr chainlink price contract
    /// @param ts Timestamp for the asset price
    /// @return price_ The retrieved price
    function getPriceByExternal(address cOracleAddr, uint256 ts) public view returns (uint256 price_, uint256 actualTs) {
        require(block.timestamp >= ts, "price not exist");
        if (block.timestamp - ts > 1 hours) {
            // get price from setting
            require(fixPrices[cOracleAddr][ts] != 0, "setting price");
            price_ = fixPrices[cOracleAddr][ts];
            actualTs = ts;
        } else {
            AggregatorV3Interface cOracle = AggregatorV3Interface(cOracleAddr);
            require(cOracleAddr != address(0), "external oracle not exist");

            (uint80 roundID,,,,) = cOracle.latestRoundData();

            uint256 decimalDiff = 10 ** (18 - cOracle.decimals());
            (price_, actualTs) = _getPrice(cOracle, roundID, ts, decimalDiff);
        }
    }

    function setFixPrice(string memory symbol, uint256 ts, uint256 price) external onlyOwner {
        require(externalOracleOf[symbol] != address(0), "not support symbol");
        fixPrices[externalOracleOf[symbol]][ts] = price;
    }

    /// @notice Helper for retrieving prices from an external oracle.
    /// @param cOracle Oracle interface for retrieving price feed
    /// @param id The roundId using which price is retrieved
    /// @param ts Timestamp for the asset price
    /// @param decimalDiff Precision differences for the number of decimal
    /// places of retrieved data
    function _getPrice(
        AggregatorV3Interface cOracle,
        uint80 id,
        uint256 ts,
        uint256 decimalDiff
    )
        private
        view
        returns (uint256 finalPrice, uint256 finalTs)
    {
        // get next price after 8am utc
        uint80 phaseId = getPhaseIdFromRoundId(id);
        uint256 price;
        uint256 actualTs;
        // get price in two phase and select price that closer to 08 utc
        for (uint80 i = phaseId; i >= 1; i--) {
            (uint256 p, uint256 aTs) = getPriceInPhase(cOracle, getStartRoundId(i), i == phaseId ? id : getEndRoundId(i), ts);
            if (price == 0) {
                // first phase
                price = p;
                actualTs = aTs;
                if (i == 1) {
                    price *= decimalDiff;
                    finalPrice = price;
                    finalTs = actualTs;
                }
            } else {
                if (p != 0) {
                    // it is not first phase and closer than pre phase
                    price = p;
                    actualTs = aTs;
                } else {
                    // now, price is the closest to 08 utc
                    price *= decimalDiff;
                    finalPrice = price;
                    finalTs = actualTs;
                }
            }
        }
    }

    function getCOracle(string memory symbol) public view returns (address) {
        address cOracle = externalOracleOf[symbol];
        require(cOracle != address(0), "not exist");
        return cOracle;
    }

    function updatePhase(uint80 roundId, string memory symbol) public {
        try AggregatorV3Interface(getCOracle(symbol)).getRoundData(roundId) returns (uint80, int256 answerF, uint256 startedAtF, uint256, uint80) {
            if (answerF == 0 && startedAtF == 0) {
                revert("invalid roundId");
            }
            uint80 phaseId = getPhaseIdFromRoundId(roundId);
            if (startRoundId[phaseId] == 0) {
                startRoundId[phaseId] = getStartRoundId(phaseId);
            }
            roundId++;
            while (true) {
                try AggregatorV3Interface(getCOracle(symbol)).getRoundData(roundId) returns (
                    uint80, int256 answer, uint256, uint256 updatedAt, uint80
                ) {
                    if (answer == 0 && updatedAt == 0) {
                        endRoundId[phaseId] = (roundId - 1);
                        if (phaseId > latestPhase) {
                            latestPhase = phaseId;
                        }
                        break;
                    }
                    roundId++;
                } catch {
                    endRoundId[phaseId] = (roundId - 1);
                    if (phaseId > latestPhase) {
                        latestPhase = phaseId;
                    }
                    break;
                }
            }
        } catch {
            revert("invalid roundId");
        }
    }

    function getPhaseIdFromRoundId(uint80 roundId) internal pure returns (uint80) {
        return roundId >> 64;
    }

    function getStartRoundId(uint80 phaseId) internal pure returns (uint80) {
        return (phaseId << 64) | 1;
    }

    function getEndRoundId(uint80 phaseId) internal view returns (uint80) {
        require(endRoundId[phaseId] != 0, "round error");
        return endRoundId[phaseId];
    }

    function getPriceInPhase(
        AggregatorV3Interface cOracle,
        uint80 start,
        uint80 end,
        uint256 ts
    )
        internal
        view
        returns (uint256 p, uint256 actualTs)
    {
        for (uint80 i = end; i >= start; i--) {
            try cOracle.getRoundData(i) returns (uint80, int256 answer, uint256 startedAt, uint256, uint80) {
                if (startedAt > 0 && startedAt < ts) {
                    break;
                }
                if (startedAt >= ts && startedAt - ts <= 1 hours) {
                    p = answer.toUint256();
                    actualTs = startedAt;
                }
            } catch {
                // just go to next round
            }
        }
    }
}
