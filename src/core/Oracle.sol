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

    mapping(string => address) public externalOracleOf;

    /// @notice Defines the underlying asset symbol and oracle address for a
    /// pool.  Only called by the owner.
    /// @param symbols The asset symbol for which to retrieve price feed
    /// @param _oracles The external oracle address
    function setExternalOracle(string[] memory symbols, address[] memory _oracles) external onlyOwner {
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
        AggregatorV3Interface cOracle = AggregatorV3Interface(cOracleAddr);
        require(cOracleAddr != address(0), "external oracle not exist");

        (uint80 roundID,,,,) = cOracle.latestRoundData();

        uint256 decimalDiff = 10 ** (18 - cOracle.decimals());
        (price_, actualTs) = _getPrice(cOracle, roundID, ts, decimalDiff);
    }

    /// @notice Helper for retrieving prices from an external oracle
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
        returns (uint256 p, uint256 actualTs)
    {
        // get next price after 8am utc
        for (uint80 i = id; i > 0; i--) {
            (, int256 answer, uint256 startedAt,,) = cOracle.getRoundData(i);
            if (startedAt < ts) {
                break;
            }
            if (startedAt >= ts) {
                p = decimalDiff * answer.toUint256();
                actualTs = startedAt;
            }
        }
        require(p != 0, "price not exist");
    }

    function getCOracle(string memory symbol) external view returns (address) {
        address cOracle = externalOracleOf[symbol];
        require(cOracle != address(0), "not exist");
        return cOracle;
    }
}
