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

contract AddUnerlyings is BaseScript {
    address public manager;
    address public arena;
    address public oracle;
    address public collateral;
    address public quoter;
    address public constant USDT_ADDR = address(0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9);
    address public constant WETH_ADDR = address(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1);
    address public constant DIVER_ADDR = address(0x5aCAB15Fe93127f550b17eacdF529bc7d3b57e2E);
    address public constant DITANIC_NAIVE_ADDR = address(0x8C2F032c62A59743aAE9B4925f72Ad06ffc4B498);
    string public constant UNDERLYING_DOGE = "DOGE";
    string public constant UNDERLYING_GME = "GME";
    string public constant UNDERLYING_BTCETF = "BTCETF";
    string public constant UNDERLYING_ETHETF = "ETHETF";
    string public constant UNDERLYING_FEDRATECUT = "FEDRATECUT";

    address public constant ARENA = address(0xA0D812cAe2376b90951192319477eF5Fe3Ac56D5);
    address public pyth = address(0xff1a0f4744e8582DF1aE09D5611b887B6a12925C);
    address public constant ORACLE_V2 = address(0x8A17F83FF5000C8ef09B98278956FfE6B2ba4009);
    address public constant ORACLE_PYTH = address(0xB07BfB22c938FBEC9BC9E63F57c760E291f42f4C);
    address public constant ORACLE_CUSTOMER_V2 = address(0xfe612f57F3eae1Eb8830FC4C70Ff928bA0683991);

    // string[] public symbols = ["BTC", "ETH", "DOGE"];
    // string[] public symbols = ["DOGE"];
    // bytes32[] public ids = [ bytes32(0xdcef50dd0a4cd2dcc17e45df1676dcb336a11a61c69df7a0299b0150c672d25c)];
    // address[] public cOracles = [ORACLE_PYTH];

    // string[] public symbols = ["GME"];
    // bytes32[] public ids = [bytes32(0x6f9cd89ef1b7fd39f667101a91ad578b6c6ace4579d5f7f285a4b06aa4504be6)];
    // address[] public cOracles = [ORACLE_PYTH];

    
    string[] public symbols = [
    // "UEFA 24 semi final France vs Spain",
    // "UEFA 24 semi final Netherlands vs England"
    "UEFA 24 Final Spain vs England"
    ];

    // bytes32[] public ids = [bytes32(0x6f9cd89ef1b7fd39f667101a91ad578b6c6ace4579d5f7f285a4b06aa4504be6)];
    // address[] public cOracles = [ORACLE_CUSTOMER_V2, ORACLE_CUSTOMER_V2];
    address[] public cOracles = [ORACLE_CUSTOMER_V2];

    function setUp() public override {
        super.setUp();
    }

    function run() public broadcaster {
        // OraclePyth(ORACLE_PYTH).addSymbolIds(symbols, ids);
        OracleV2(ORACLE_V2).setExternalOracle(symbols, cOracles);
        // Arena(ARENA).setUnderlyingWhitelist(UNDERLYING_GME, true, Fee(0.003e6, 0.3e6, 0.0015e6));
    }
}
