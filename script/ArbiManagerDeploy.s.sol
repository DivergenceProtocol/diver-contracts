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
    address public constant USDT_ADDR = address(0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9);
    address public constant WETH_ADDR = address(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1);
    address public constant DIVER_ADDR = address(0x5aCAB15Fe93127f550b17eacdF529bc7d3b57e2E);
    address public constant DITANIC_NAIVE_ADDR = address(0x8C2F032c62A59743aAE9B4925f72Ad06ffc4B498);
    string public constant UNDERLYING_BTCETF = "BTCETF";
    string public constant UNDERLYING_ETHETF = "ETHETF";
    string public constant UNDERLYING_FEDRATECUT = "FEDRATECUT";
    string public constant UEFA_1 = "UEFA 24 semi final France vs Spain";
    string public constant UEFA_2 = "UEFA 24 semi final Netherlands vs England";
    string public constant UEFA_3 = "UEFA 24 Final Spain vs England";

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

        // deployPredictionMarket(address(0xA0D812cAe2376b90951192319477eF5Fe3Ac56D5), address(0x55A14661d94C2cE307Ab918bb9564545282C2454));
    }

    function setCollateral(address _arena, address _collateral, bool isSupported) public {
        Arena(_arena).setCollateralWhitelist(_collateral, isSupported);
    }

    function setFixPrice(address _oracle, string memory symbol, uint256 ts, uint256 price) public {
        Oracle(_oracle).setFixPrice(symbol, ts, price);
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
        // oracle = _deployOracle();
        oracle = address(0x8A17F83FF5000C8ef09B98278956FfE6B2ba4009);
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
        Arena(arena).setCollateralWhitelist(WETH_ADDR, true);
        Arena(arena).setCollateralWhitelist(DIVER_ADDR, true);
        Arena(arena).setCollateralWhitelist(DITANIC_NAIVE_ADDR, true);
        // deployPredictionMarket(arena, manager);
    }

    function deployPredictionMarket(address _arena, address _manager) public {
        // Arena(_arena).setUnderlyingWhitelist(UNDERLYING_BTCETF, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UNDERLYING_ETHETF, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UNDERLYING_FEDRATECUT, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UEFA_1, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UEFA_2, true, Fee(0.003e6, 0.3e6, 0.0015e6));
        Arena(_arena).setUnderlyingWhitelist(UEFA_3, true, Fee(0.003e6, 0.3e6, 0.0015e6));
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
        uint256 uefa3Expires = 1721030400;


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
        BattleKey memory bkUEFA3 =
            BattleKey({ collateral: USDT_ADDR, underlying: UEFA_3, expiries: uefa3Expires, strikeValue: strikeValue });


        uint160 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(0);
        // CreateAndInitBattleParams memory paramsBTCETF = CreateAndInitBattleParams({ bk: bkBTCETF, sqrtPriceX96: sqrtPriceX96 });
        // CreateAndInitBattleParams memory paramsETHETF = CreateAndInitBattleParams({ bk: bkETHETF, sqrtPriceX96: sqrtPriceX96 });
        // CreateAndInitBattleParams memory paramsRate = CreateAndInitBattleParams({ bk: bkRate, sqrtPriceX96: sqrtPriceX96 });
        // CreateAndInitBattleParams memory paramsUEFA1 = CreateAndInitBattleParams({ bk: bkUEFA1, sqrtPriceX96: sqrtPriceX96 });
        // CreateAndInitBattleParams memory paramsUEFA2 = CreateAndInitBattleParams({ bk: bkUEFA2, sqrtPriceX96: sqrtPriceX96 });
        CreateAndInitBattleParams memory paramsUEFA3 = CreateAndInitBattleParams({ bk: bkUEFA3, sqrtPriceX96: sqrtPriceX96 });

        // address battleBTCETF = Manager(payable(_manager)).createAndInitializeBattle(paramsBTCETF);
        // address battleETHETF = Manager(payable(_manager)).createAndInitializeBattle(paramsETHETF);
        // address battleFedETF = Manager(payable(_manager)).createAndInitializeBattle(paramsRate);
        // address battleUEFA1 = Manager(payable(_manager)).createAndInitializeBattle(paramsUEFA1);
        // address battleUEFA2 = Manager(payable(_manager)).createAndInitializeBattle(paramsUEFA2);
        address battleUEFA3 = Manager(payable(_manager)).createAndInitializeBattle(paramsUEFA3);


        // Arena(_arena).setUnderlyingWhitelist(UNDERLYING_BTCETF, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UNDERLYING_ETHETF, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UNDERLYING_FEDRATECUT, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UEFA_1, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        // Arena(_arena).setUnderlyingWhitelist(UEFA_2, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        Arena(_arena).setUnderlyingWhitelist(UEFA_3, false, Fee(0.003e6, 0.3e6, 0.0015e6));
        // console2.log("BTCETF ", battleBTCETF);
        // console2.log("ETHETF ", battleETHETF);
        // console2.log("FedRateCutETF ", battleFedETF);
        // console2.log("UEFA1", battleUEFA1);
        // console2.log("UEFA2", battleUEFA2);
        console2.log("UEFA3", battleUEFA3);
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

    function _deployOracle() private returns (address _oracle) {
        delete symbols;
        delete oracles;
        Oracle oracleInst = new Oracle();
        symbols.push("BTC");
        symbols.push("ETH");
        // symbols.push("ARB");
        oracles.push(address(0x6ce185860a4963106506C203335A2910413708e9));
        oracles.push(address(0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612));
        // oracles.push(address(0xb2A824043730FE05F3DA2efaFa1CBbe83fa548D6));
        // set prediction
        address pOracle = address(new OracleCustom());
        // address ethETFOracle = address(new OracleCustom());
        // address fedRateCutOracle = address(new OracleCustom());
        symbols.push(UNDERLYING_BTCETF);
        oracles.push(pOracle);
        symbols.push(UNDERLYING_ETHETF);
        oracles.push(pOracle);
        symbols.push(UNDERLYING_FEDRATECUT);
        oracles.push(pOracle);
        require(symbols.length == oracles.length, "not match");
        oracleInst.setExternalOracle(symbols, oracles);
        _oracle = address(oracleInst);
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