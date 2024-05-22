// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "./shared/DeployUtils.sol" as utils;
import { BaseScript } from "script/shared/Base.s.sol";
import { deploy, DeployAddrs } from "script/shared/DeployUtils.sol";
import { IBattleInitializer } from "periphery/interfaces/IBattleInitializer.sol";
import { CreateAndInitBattleParams } from "periphery/params/peripheryParams.sol";
import { IBattleState } from "core/interfaces/battle/IBattleState.sol";
import { TickMath } from "core/libs/TickMath.sol";
import "core/types/common.sol";
import { IBattle } from "core/interfaces/battle/IBattle.sol";
import { Oracle } from "core/Oracle.sol";
import { OracleV2 } from "core/OracleV2.sol";
import { OraclePyth } from "core/OraclePyth.sol";
import { getTS, Period } from "test/shared/utils.sol";
import { Quoter } from "periphery/lens/Quoter.sol";
import { Ditanic } from "test/shared/Ditanic.sol";
import { DitanicNaive } from "test/shared/DitanicNaive.sol";
import { Arena } from "core/Arena.sol";
import { Manager } from "periphery/Manager.sol";
import { CreateAndInitBattleParams } from "periphery/params/peripheryParams.sol";
import { OracleCustom } from "core/OracleCustom.sol";
import { TickMath } from "core/libs/TickMath.sol";
import { console2 } from "@std/console2.sol";

contract OracleChanger is BaseScript {
    address public manager;
    address public arena;
    address public oracle;
    address public collateral;
    address public quoter;
    address public constant USDT_ADDR = address(0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9);
    address public constant WETH_ADDR = address(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1);
    address public constant DIVER_ADDR = address(0x5aCAB15Fe93127f550b17eacdF529bc7d3b57e2E);
    address public constant DITANIC_NAIVE_ADDR = address(0x8C2F032c62A59743aAE9B4925f72Ad06ffc4B498);
    string public constant UNDERLYING_BTCETF = "BTCETF";
    string public constant UNDERLYING_ETHETF = "ETHETF";
    string public constant UNDERLYING_FEDRATECUT = "FEDRATECUT";

    address public constant ARENA = address(0xA0D812cAe2376b90951192319477eF5Fe3Ac56D5);

    address pyth = address(0xff1a0f4744e8582DF1aE09D5611b887B6a12925C);
    // string[] public symbols = ["BTC", "ETH", "DOGE"];
    string[] public symbols = ["BTC", "ETH"];
    // bytes32[] public ids = [0xe62df6c8b4a85fe1a67db44dc12de5db330f7ac66b72dc658afedf0f4a415b43,
    // 0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace, 0xdcef50dd0a4cd2dcc17e45df1676dcb336a11a61c69df7a0299b0150c672d25c];
    bytes32[] public ids = [
        bytes32(0xe62df6c8b4a85fe1a67db44dc12de5db330f7ac66b72dc658afedf0f4a415b43),
        bytes32(0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace)
    ];
    address[] public cOracles;

    function setUp() public override {
        super.setUp();
    }

    function run() public broadcaster {
        // deploy OraclePyth
        OraclePyth oraclePyth = new OraclePyth(pyth, symbols, ids);
        for (uint256 i; i < symbols.length; i++) {
            cOracles.push(address(oraclePyth));
        }

        // deploy oracleV2
        OracleV2 oracleV2 = new OracleV2();

        // deploy OraclePyth
        oracleV2.setExternalOracle(symbols, cOracles);

        // change oracle in arean
        Arena(ARENA).setOracle(address(oracleV2));
    }
}
