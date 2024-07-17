// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "core/Arena.sol";
import { WETH9 } from "test/shared/WETH9.sol";
import { TestERC20 } from "test/shared/TestERC20.sol";
import { IBattleInitializer } from "periphery/interfaces/IBattleInitializer.sol";
import { IManagerState } from "periphery/interfaces/IManagerState.sol";
import { Quoter } from "periphery/lens/Quoter.sol";
import { Fee } from "core/types/common.sol";
import { Battle } from "core/Battle.sol";
import { Manager } from "periphery/Manager.sol";

struct DeployAddrs {
    address owner;
    address arenaAddr;
    address collateralToken;
    address wethAddr;
    address quoter;
    address oracle;
    uint8 decimal;
    bool hasFee;
}

interface IMulticall {
    function multicall(bytes[] calldata data) external payable returns (bytes[] memory results);
}

function deploy(DeployAddrs memory das) returns (address managerAddr, address arena, address oracle, address collateral, address quoter) {
    if (das.wethAddr == address(0)) {
        WETH9 weth = new WETH9();
        das.wethAddr = address(weth);
    }
    if (das.arenaAddr == address(0)) {
        Battle battleImpl = new Battle();
        if (das.collateralToken == address(0)) {
            das.collateralToken = address(new TestERC20("DAI", "DAI", das.decimal));
            collateral = das.collateralToken;
        }
        // oracle = deployOracle();
        require(das.oracle != address(0), "oracle not exist");
        oracle = das.oracle;
        arena = deployArena(das.collateralToken, das.oracle, address(battleImpl), das.hasFee);
    }
    managerAddr = address(new Manager(arena, das.wethAddr));
    if (das.quoter == address(0)) {
        das.quoter = address(new Quoter(arena, managerAddr));
    }
    Arena(arena).setManager(managerAddr);
    return (managerAddr, arena, oracle, das.collateralToken, das.quoter);
}

function deployArena(address token, address oracle, address battleImpl, bool hasFee) returns (address) {
    Arena arena = new Arena(oracle, battleImpl);
    _initArena(arena, address(token), hasFee);
    return address(arena);
}

function _initArena(Arena arena, address token, bool hasFee) {
    arena.setCollateralWhitelist(token, true);
    if (hasFee) {
        arena.setUnderlyingWhitelist("BTC", true, Fee(0.003e6, 0.3e6, 0.0015e6));
        arena.setUnderlyingWhitelist("ETH", true, Fee(0.003e6, 0.3e6, 0.0015e6));
        arena.setUnderlyingWhitelist("DOGE", true, Fee(0.003e6, 0.3e6, 0.0015e6));
    } else {
        arena.setUnderlyingWhitelist("BTC", true, Fee(0, 0, 0));
        arena.setUnderlyingWhitelist("ETH", true, Fee(0, 0, 0));
        arena.setUnderlyingWhitelist("DOGE", true, Fee(0, 0, 0));
    }
}
