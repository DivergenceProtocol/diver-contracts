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

contract ArbiManagerDeploy is BaseScript {
    address public manager;
    address public arena;
    address public oracle;
    address public collateral;
    address public quoter;
    address public constant USDT_ADDR = address(0xd567B3d7B8FE3C79a1AD8dA978812cfC4Fa05e75);
    // actual wcanto
    address public constant WETH_ADDR = address(0x826551890Dc65655a0Aceca109aB11AbDbD7a07B);
    // address public constant DIVER_ADDR = address(0x5aCAB15Fe93127f550b17eacdF529bc7d3b57e2E);
    address public constant DITANIC_NAIVE_ADDR = address(0);
    string public constant UNDERLYING_BTCETF = "BTCETF";
    string public constant UNDERLYING_ETHETF = "ETHETF";
    string public constant UNDERLYING_FEDRATECUT = "FEDRATECUT";
    string public constant UEFA_1 = "UEFA 24 semi final France vs Spain";
    string public constant UEFA_2 = "UEFA 24 semi final Netherlands vs England";
    string public constant UEFA_3 = "UEFA 24 Final Spain vs England";
    string public constant BTC_ATH = "BTC Price All Time High";
    string public constant ETH_ATH = "ETH Price All Time High";
    string public constant UNDERLYING_F3 = "Can France rank in the top 3 in the number of gold medals?";
    string public constant UNDERLYING_UB = "Can the USA men's basketball team win a fifth straight championship?";

    string[] public symbols;
    address[] public oracles;

    function setUp() public override {
        super.setUp();
    }

    function run() public broadcaster {
        // address owner = address(this);
        deployNormal();
        // deployDitanic();
        // deployDitanicNaive();
        // setMiner();
        // doBaseThing();

        // deployQuoter();
        // deploy_new();

        // setCollateral(address(0x0031c9dC88baFa6DA825e5d2E9CCFa8dC2ced755), DITANIC_NAIVE_ADDR, true);
        // address _oracle = address(0x07C8C1e84C3814bfE2870Dfed24635Ef715aCB7c);
        // uint256 expires = 1717142400;
        // setFixPrice(_oracle, "BTC", expires, 42863e18);
        // setFixPrice(_oracle, "BTCETF", expires, 200e18);
        // setFixPrice(_oracle, "ETHETF", expires, 101e18);
        // setFixPrice(_oracle, UNDERLYING_FEDRATECUT, expires, 50e18);

        // deployPredictionMarket(address(0x46E7481453D0C39587507Df6e40C5904ba80E5F4), address(0xf4a20C2B2D4a699C0A095692A8501b19e3609263));
    }

    function setCollateral(address _arena, address _collateral, bool isSupported) public {
        Arena(_arena).setCollateralWhitelist(_collateral, isSupported);
    }

    function setFixPrice(address _oracle, string memory symbol, uint256 ts, uint256 price) public {
        OracleV2(_oracle).setFixPrice(symbol, ts, price);
    }

    function setMiner() public {
        Ditanic ditanic = Ditanic(address(0x120987BB69Ba2c62E8E915Db1B81D25E34AE6e9F));
        ditanic.grantRole(ditanic.MINER_ROLE(), address(0xbc3FBC55B50c05D3B2cc29b74104cDeEB52426Ef));
    }

    function deployNormal() public {
        address arenaAddr = address(0);
        address collateralToken = USDT_ADDR;
        address wethAddr = WETH_ADDR;
        // address wethAddr = address(1);
        oracle = _deployOracle();
        // oracle = address(0x8A17F83FF5000C8ef09B98278956FfE6B2ba4009);
        DeployAddrs memory das = DeployAddrs({
            owner: deployer,
            arenaAddr: arenaAddr,
            collateralToken: collateralToken,
            wethAddr: wethAddr,
            quoter: quoter,
            oracle: oracle,
            decimal: 18,
            hasFee: true
        });
        (manager, arena, oracle, collateral, quoter) = deploy(das);
        console2.log("Manager: %s", manager);
        console2.log("Arena: %s", arena);
        console2.log("Oracle: %s", oracle);
        console2.log("Quoter:", quoter);
        // Arena(arena).setCollateralWhitelist(WETH_ADDR, true);
        // Arena(arena).setCollateralWhitelist(DIVER_ADDR, true);
        if (DITANIC_NAIVE_ADDR == address(0)) {
            DitanicNaive dn = new DitanicNaive();
            console2.log("DitanicNaive %s", address(dn));
        }
        // Arena(arena).setCollateralWhitelist(DITANIC_NAIVE_ADDR, true);
        // deployPredictionMarket(arena, manager);
    }

    function deployPredictionMarket(address _arena, address _manager) public {
        // Arena(_arena).setUnderlyingWhitelist(UNDERLYING_BTCETF, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UNDERLYING_ETHETF, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UNDERLYING_FEDRATECUT, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UEFA_1, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UEFA_2, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UEFA_3, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(BTC_ATH, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(ETH_ATH, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        Arena(_arena).setUnderlyingWhitelist(UNDERLYING_F3, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        Arena(_arena).setUnderlyingWhitelist(UNDERLYING_UB, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        // open prediction market
        // uint btcETFExpiries = 1705305600;
        // uint ethETFExpiries = 1706688000;
        // uint fedRateCutExpiries = 1711872000;
        // uint256 btcETFExpiries = 1705305600;
        // uint256 ethETFExpiries = 1706688000;
        // uint256 fedRateCutExpiries = 1727683200;
        // uint256 fedRateCutExpiries = 1727683200;
        // uint256 fedRateCutExpiries = 1727683200;
        // uint256 uefa1Expires = 1720598400;
        // uint256 uefa2Expires = 1720684800;
        // uint256 uefa3Expires = 1721030400;
        // uint256 btcAthExpires = 1725004800;
        // uint256 ethAthExpires = 1725004800;
        uint256 f3Expires = 1723449600;
        uint256 ubExpires = 1723363200;


        uint256 strikeValue = 100e18;
        // BattleKey memory bkBTCETF =
        //     BattleKey({ collateral: USDT_ADDR, underlying: UNDERLYING_BTCETF, expiries: btcETFExpiries, strikeValue: strikeValue });
        // BattleKey memory bkETHETF =
        //     BattleKey({ collateral: USDT_ADDR, underlying: UNDERLYING_ETHETF, expiries: ethETFExpiries, strikeValue: strikeValue });
        // BattleKey memory bkRate =
        //     BattleKey({ collateral: USDT_ADDR, underlying: UNDERLYING_FEDRATECUT, expiries: fedRateCutExpiries, strikeValue: strikeValue });
        // BattleKey memory bkUEFA1 =
        //     BattleKey({ collateral: USDT_ADDR, underlying: UEFA_1, expiries: uefa1Expires, strikeValue: strikeValue });
        // BattleKey memory bkUEFA2 =
        //     BattleKey({ collateral: USDT_ADDR, underlying: UEFA_2, expiries: uefa2Expires, strikeValue: strikeValue });
        // BattleKey memory bkUEFA3 =
        //     BattleKey({ collateral: USDT_ADDR, underlying: UEFA_3, expiries: uefa3Expires, strikeValue: strikeValue });
        // BattleKey memory bkBtcAth =
        //     BattleKey({ collateral: USDT_ADDR, underlying: BTC_ATH, expiries: btcAthExpires, strikeValue: strikeValue });
        // BattleKey memory bkEthAth =
        //     BattleKey({ collateral: USDT_ADDR, underlying: ETH_ATH, expiries: ethAthExpires, strikeValue: strikeValue });
        BattleKey memory bkF3 =
            BattleKey({ collateral: USDT_ADDR, underlying: UNDERLYING_F3, expiries: f3Expires, strikeValue: strikeValue });
        BattleKey memory bkUb =
            BattleKey({ collateral: USDT_ADDR, underlying: UNDERLYING_UB, expiries: ubExpires, strikeValue: strikeValue });


        uint160 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(0);
        // CreateAndInitBattleParams memory paramsBTCETF = CreateAndInitBattleParams({ bk: bkBTCETF, sqrtPriceX96: sqrtPriceX96 });
        // CreateAndInitBattleParams memory paramsETHETF = CreateAndInitBattleParams({ bk: bkETHETF, sqrtPriceX96: sqrtPriceX96 });
        // CreateAndInitBattleParams memory paramsRate = CreateAndInitBattleParams({ bk: bkRate, sqrtPriceX96: sqrtPriceX96 });
        // CreateAndInitBattleParams memory paramsUEFA1 = CreateAndInitBattleParams({ bk: bkUEFA1, sqrtPriceX96: sqrtPriceX96 });
        // CreateAndInitBattleParams memory paramsUEFA2 = CreateAndInitBattleParams({ bk: bkUEFA2, sqrtPriceX96: sqrtPriceX96 });
        // CreateAndInitBattleParams memory paramsUEFA3 = CreateAndInitBattleParams({ bk: bkUEFA3, sqrtPriceX96: sqrtPriceX96 });
        // CreateAndInitBattleParams memory paramsBtcAth = CreateAndInitBattleParams({ bk: bkBtcAth, sqrtPriceX96: sqrtPriceX96 });
        // CreateAndInitBattleParams memory paramsEthAth = CreateAndInitBattleParams({ bk: bkEthAth, sqrtPriceX96: sqrtPriceX96 });
        CreateAndInitBattleParams memory paramsF3 = CreateAndInitBattleParams({ bk: bkF3, sqrtPriceX96: sqrtPriceX96 });
        CreateAndInitBattleParams memory paramsUb = CreateAndInitBattleParams({ bk: bkUb, sqrtPriceX96: sqrtPriceX96 });


        // address battleBTCETF = Manager(payable(_manager)).createAndInitializeBattle(paramsBTCETF);
        // address battleETHETF = Manager(payable(_manager)).createAndInitializeBattle(paramsETHETF);
        // address battleFedETF = Manager(payable(_manager)).createAndInitializeBattle(paramsRate);
        // address battleUEFA1 = Manager(payable(_manager)).createAndInitializeBattle(paramsUEFA1);
        // address battleUEFA2 = Manager(payable(_manager)).createAndInitializeBattle(paramsUEFA2);
        // address battleUEFA3 = Manager(payable(_manager)).createAndInitializeBattle(paramsUEFA3);
        // address battleBtcAth = Manager(payable(_manager)).createAndInitializeBattle(paramsBtcAth);
        // address battleEthAth = Manager(payable(_manager)).createAndInitializeBattle(paramsEthAth);
        address battleF3 = Manager(payable(_manager)).createAndInitializeBattle(paramsF3);
        address battleUb = Manager(payable(_manager)).createAndInitializeBattle(paramsUb);


        // Arena(_arena).setUnderlyingWhitelist(UNDERLYING_BTCETF, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UNDERLYING_ETHETF, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UNDERLYING_FEDRATECUT, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UEFA_1, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UEFA_2, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UEFA_3, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        Arena(_arena).setUnderlyingWhitelist(UNDERLYING_F3, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        Arena(_arena).setUnderlyingWhitelist(UNDERLYING_UB, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        // console2.log("BTCETF ", battleBTCETF);
        // console2.log("ETHETF ", battleETHETF);
        // console2.log("FedRateCutETF ", battleFedETF);
        // console2.log("UEFA1", battleUEFA1);
        // console2.log("UEFA2", battleUEFA2);
        // console2.log("UEFA3", battleUEFA3);
        // console2.log("UEFA3", battleUEFA3);
        // console2.log("btcAth", battleBtcAth);
        // console2.log("ethAth", battleEthAth);
        console2.log("f3", battleF3);
        console2.log("ub", battleUb);
    }

    function deployDitanicNaive() public {
        DitanicNaive d = new DitanicNaive();
    }

    function deployDitanic() public {
        address arenaAddr = address(0);
        Ditanic ditanic = new Ditanic();
        address collateralToken = address(ditanic);
        address wethAddr = address(0);
        oracle = _deployOracle();
        DeployAddrs memory das = DeployAddrs({
            owner: deployer,
            arenaAddr: arenaAddr,
            collateralToken: collateralToken,
            wethAddr: wethAddr,
            quoter: quoter,
            oracle: oracle,
            decimal: 18,
            hasFee: true
        });
        (manager, arena, oracle, collateral, quoter) = deploy(das);
        ditanic.setArena(arena);
    }

    function getBattleKey(uint256 strikeValue) internal view returns (BattleKey memory) {
        (, uint256 expiries) = getTS(Period.WEEKLY);
        BattleKey memory bk = BattleKey({
            collateral: address(0xA87B4e604aCefd6Cf6059bb73a7b4e0bA90434DA),
            underlying: "BTC",
            expiries: expiries,
            strikeValue: strikeValue
        });
        return bk;
    }

     address pyth = address(0x98046Bd286715D3B0BC227Dd7a956b83D8978603);
    // string[] public symbols = ["BTC", "ETH", "DOGE"];
    // string[] public symbols = ["BTC", "ETH"];
    // bytes32[] public ids = [0xe62df6c8b4a85fe1a67db44dc12de5db330f7ac66b72dc658afedf0f4a415b43,
    // 0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace, 0xdcef50dd0a4cd2dcc17e45df1676dcb336a11a61c69df7a0299b0150c672d25c];
    bytes32[] public ids = [
        bytes32(0xe62df6c8b4a85fe1a67db44dc12de5db330f7ac66b72dc658afedf0f4a415b43),
        bytes32(0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace),
        bytes32(0xdcef50dd0a4cd2dcc17e45df1676dcb336a11a61c69df7a0299b0150c672d25c)
    ];
    address[] public cOracles;

    function _deployOracle() private returns (address _oracle) {
        delete symbols;
        delete oracles;
        symbols.push("BTC");
        symbols.push("ETH");
        symbols.push("DOGE");
        require(symbols.length == ids.length, "not match");
        OraclePyth oraclePyth = new OraclePyth(pyth, symbols, ids);
        console2.log("OraclePyth: %s", address(oraclePyth));
        for (uint256 i; i < symbols.length; i++) {
            cOracles.push(address(oraclePyth));
        }

        // deploy oracleV2
        OracleV2 oracleV2 = new OracleV2();
        console2.log("OracleV2: %s", address(oracleV2));

        // deploy OraclePyth
        oracleV2.setExternalOracle(symbols, cOracles);
        _oracle = address(oracleV2);



        // OracleV2 oracleInst = new OracleV2();
        // symbols.push("BTC");
        // symbols.push("ETH");
        // // symbols.push("ARB");
        // oracles.push(address(0x6ce185860a4963106506C203335A2910413708e9));
        // oracles.push(address(0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612));
        // // oracles.push(address(0xb2A824043730FE05F3DA2efaFa1CBbe83fa548D6));
        // // set prediction
        // address pOracle = address(new OracleCustom());
        // // address ethETFOracle = address(new OracleCustom());
        // // address fedRateCutOracle = address(new OracleCustom());
        // symbols.push(UNDERLYING_BTCETF);
        // oracles.push(pOracle);
        // symbols.push(UNDERLYING_ETHETF);
        // oracles.push(pOracle);
        // symbols.push(UNDERLYING_FEDRATECUT);
        // oracles.push(pOracle);
        // require(symbols.length == oracles.length, "not match");
        // oracleInst.setExternalOracle(symbols, oracles);
    }

    function createBattle() public virtual returns (address, address, address) {
        BattleKey memory bk = getBattleKey(25000e18);
        uint160 sqrtPriceX96 = 79_228_162_514_264_337_593_543_950_336;
        CreateAndInitBattleParams memory params = CreateAndInitBattleParams({ bk: bk, sqrtPriceX96: sqrtPriceX96 });
        address battleAddr = IBattleInitializer(address(0xc35717a122b664Fc784De66cF9C27A2cc8cfb62d)).createAndInitializeBattle(params);
        address spear = IBattle(battleAddr).spear();
        address shield = IBattle(battleAddr).shield();

        return (battleAddr, spear, shield);
    }

    function deployQuoter() public returns (address) {
        Quoter quoter0 = new Quoter(address(0xC09619865f6EEAB0C87360D3200da0b6FA4034a1), address(0));
        return address(quoter0);
    }

    function doBaseThing() public {
        createBattle();
    }
}