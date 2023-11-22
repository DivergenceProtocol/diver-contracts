// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Ownable } from "@oz/access/Ownable.sol";
import { SafeCast } from "@oz/utils/math/SafeCast.sol";
import { AggregatorV3Interface } from "chainlink/interfaces/AggregatorV3Interface.sol";
import { getAdjustPrice } from "./utils.sol";

/// @title Oracle
/// @notice Retrieves underlying asset prices used for settling options.
contract Oracle is Ownable {
    using SafeCast for int256;

    mapping(string => address) private _externalOracleOf;
    mapping(address => mapping(uint256 => uint256)) public fixPrices;

    /// @notice Defines the underlying asset symbol and oracle address for a pool. Only called by the owner.
    /// @param symbols The asset symbol for which to retrieve a price feed
    /// @param oracles_ The external oracle address
    function setExternalOracle(string[] calldata symbols, address[] calldata oracles_) external onlyOwner {
        require(symbols.length == oracles_.length, "symbols not match oracles");
        for (uint256 i = 0; i < symbols.length; i++) {
            require(oracles_[i] != address(0), "Zero Address");
            _externalOracleOf[symbols[i]] = oracles_[i];
        }
    }

    function setFixPrice(string memory symbol, uint256 ts, uint256 price) external onlyOwner {
        require(_externalOracleOf[symbol] != address(0), "not support symbol");
        fixPrices[_externalOracleOf[symbol]][ts] = price;
    }

    /// @notice Gets and computes price from external oracles
    /// @param cOracleAddr the contract address for a chainlink price feed
    /// @param ts Timestamp for the asset price
    /// @return price The retrieved price
    function getPriceByExternal(address cOracleAddr, uint256 ts) external view returns (uint256 price, uint256 actualTs) {
        require(block.timestamp >= ts, "price not exist");
        require(cOracleAddr != address(0), "Zero Address");

        AggregatorV3Interface cOracle = AggregatorV3Interface(cOracleAddr);
        (uint80 roundID,,,,) = cOracle.latestRoundData();
        uint256 decimalDiff = 10 ** (18 - cOracle.decimals());
        (uint256 cPrice, uint256 cActualTs) = _getPrice(cOracle, roundID, ts, decimalDiff);

        // If the price remains unreported or inaccessible an hour post expiry, the closest available price will be fixed based on the external oracle data.
        if (block.timestamp - ts > 1 hours && cPrice == 0) {
            require(fixPrices[cOracleAddr][ts] != 0, "setting price");
            price = fixPrices[cOracleAddr][ts];
            actualTs = ts;
        } else {
            price = cPrice;
            actualTs = cActualTs;
        }
    }

    /// @notice Helper for retrieving prices from an external oracle.
    /// @param cOracle Oracle interface for retrieving price feed
    /// @param id The roundId using which price is retrieved
    /// @param ts Timestamp for the asset price
    /// @param decimalDiff Precision differences for the number of decimal places of retrieved data
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
        // get the next price after 8am utc
        uint80 phaseId = _getPhaseIdFromRoundId(id);
        uint80 startRoundId = _getStartRoundId(phaseId);
        try AggregatorV3Interface(cOracle).getRoundData(startRoundId) returns (uint80, int256, uint256, uint256 updatedAt, uint80) {
            //updatedAt == 0, invalid value
            //In case the 'startRound' occurs after the 'endTs' of a battle due to external oracle updates, it returns 0. The correct price will be provided by fixPrices.
            if (updatedAt == 0 || updatedAt >= ts) {
                return (0, 0);
            } else {
                // If the finalPrice is 0, then the price will be provided by fixPrices.
                (finalPrice, finalTs) = _getPriceInPhase(cOracle, startRoundId, id, ts, decimalDiff);
            }
        } catch {
            // If there are any errors encountered, it returns (0, 0). the correct price will be provided by fixPrices.
        }
    }

    function getCOracle(string memory symbol) public view returns (address) {
        address cOracle = _externalOracleOf[symbol];
        require(cOracle != address(0), "not exist");
        return cOracle;
    }

    function _getPhaseIdFromRoundId(uint80 roundId) internal pure returns (uint80) {
        return roundId >> 64;
    }

    function _getStartRoundId(uint80 phaseId) internal pure returns (uint80) {
        return (phaseId << 64) | 1;
    }

    function _getPriceInPhase(
        AggregatorV3Interface cOracle,
        uint80 start,
        uint80 end,
        uint256 ts,
        uint256 decimalDiff
    )
        internal
        view
        returns (uint256 price, uint256 actualTs)
    {
        for (uint80 i = end; i >= start; i--) {
            try cOracle.getRoundData(i) returns (uint80, int256 answer, uint256, uint256 updatedAt, uint80) {
                if (updatedAt > 0 && updatedAt < ts) {
                    break;
                }
                if (updatedAt >= ts && updatedAt - ts <= 1 hours) {
                    price = answer.toUint256() * decimalDiff;
                    actualTs = updatedAt;
                }
            } catch {
                // in case of errors
                return (0, 0);
            }
        }
    }
}
