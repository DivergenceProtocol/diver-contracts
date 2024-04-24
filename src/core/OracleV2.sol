// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Ownable } from "@oz/access/Ownable.sol";
import { OraclePyth } from "./OraclePyth.sol";
import { IBattleState, BattleKey } from "./interfaces/battle/IBattleState.sol";

/// @title Oracle
/// @notice Retrieves underlying asset prices used for settling options.
contract OracleV2 is Ownable {
    mapping(string symbol => address oraclePyth) private _externalOracleOf;
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
        // If the price remains unreported or inaccessible an hour post expiry, the closest available price will be fixed based on the external oracle
        // data.
        if (block.timestamp - ts > 24 hours) {
            require(fixPrices[cOracleAddr][ts] != 0, "setting price");
            price = fixPrices[cOracleAddr][ts];
            actualTs = ts;
        } else {
            BattleKey memory key = IBattleState(msg.sender).battleKey();
            uint256 cPrice = OraclePyth(cOracleAddr).priceOf(key.underlying, ts);
            price = cPrice;
            actualTs = ts;
        }
    }

    function getCOracle(string memory symbol) public view returns (address) {
        address cOracle = _externalOracleOf[symbol];
        require(cOracle != address(0), "not exist");
        return cOracle;
    }
}
