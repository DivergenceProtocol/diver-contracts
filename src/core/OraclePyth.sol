// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@pyth/IPyth.sol";
import { Ownable } from "@oz/access/Ownable.sol";
import { ICOracle } from "./interfaces/ICOracle.sol";

contract OraclePyth is Ownable, ICOracle {
    IPyth public immutable pyth;
    mapping(string symbol => bytes32 id) public symbolToId;
    mapping(bytes32 id => string symbol) public idToSymbol;
    mapping(string symbol => mapping(uint256 ts => uint256 price)) public override priceOf;

    constructor(address _pyth, string[] memory symbols, bytes32[] memory ids) {
        pyth = IPyth(_pyth);
        addSymbolIds(symbols, ids);
    }

    event SymbolsRemoved(string[] symbols);
    event SymbolIdsAdded(string[] symbols, bytes32[] ids);
    event PriceUpdated(string symbol, uint256 ts, uint256 price);

    function removeSymbolIds(string[] memory symbols) public onlyOwner {
        for (uint256 i = 0; i < symbols.length; i++) {
            delete idToSymbol[symbolToId[symbols[i]]];
            delete symbolToId[symbols[i]];
        }
        emit SymbolsRemoved(symbols);
    }

    function addSymbolIds(string[] memory symbols, bytes32[] memory ids) public onlyOwner {
        require(symbols.length == ids.length, "OraclePyth: symbols and ids length mismatch");
        for (uint256 i = 0; i < symbols.length; i++) {
            require(symbolToId[symbols[i]] == bytes32(0), "OraclePyth: symbol already exists");
            require(bytes(idToSymbol[ids[i]]).length == 0, "OraclePyth: id already exists");
            symbolToId[symbols[i]] = ids[i];
            idToSymbol[ids[i]] = symbols[i];
        }
        emit SymbolIdsAdded(symbols, ids);
    }

    function updatePrice(bytes32[] memory ids, bytes[] memory data, uint64 min, uint64 max) public payable {
        require(ids.length == data.length, "OraclePyth: ids and data length mismatch");
        for (uint256 i = 0; i < ids.length; i++) {
            require(bytes(idToSymbol[ids[i]]).length != 0, "OraclePyth: id not found");
        }
        PythStructs.PriceFeed[] memory ps = pyth.parsePriceFeedUpdatesUnique{ value: msg.value }(data, ids, min, max);
        for (uint256 i = 0; i < ps.length; i++) {
            PythStructs.Price memory price = ps[i].price;
            require(priceOf[idToSymbol[ps[i].id]][price.publishTime] == 0, "OraclePyth: price already exists");
            uint256 price18Decimals = (uint256(uint64(price.price)) * (10 ** 18)) / (10 ** uint8(uint32(-1 * price.expo)));
            priceOf[idToSymbol[ps[i].id]][price.publishTime] = price18Decimals;
            emit PriceUpdated(idToSymbol[ps[i].id], price.publishTime, price18Decimals);
        }
    }
}
