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

contract GoerliManagerDeploy is BaseScript {
    address public manager;
    address public arena;
    address public oracle;
    address public collateral;
    address public quoter;

    string[] public symbols;
    address[] public oracles;

    function setUp() public override {
        super.setUp();
    }

    function run() public broadcaster {
        // address owner = address(this);
        // deployNormal();
        // deployDitanic();
        setMiner();
        // doBaseThing();

        // deployQuoter();
    }

    function setMiner() public {
        Ditanic ditanic = Ditanic(address(0x120987BB69Ba2c62E8E915Db1B81D25E34AE6e9F));
        ditanic.grantRole(ditanic.MINER_ROLE(), address(0xbc3FBC55B50c05D3B2cc29b74104cDeEB52426Ef));
    }

    function deployNormal() public {
        address arenaAddr = address(0);
        address collateralToken = address(0);
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
        Oracle oracleInst = new Oracle();
        symbols.push("BTC");
        symbols.push("ETH");
        oracles.push(address(0x6550bc2301936011c1334555e62A87705A81C12C));
        oracles.push(address(0x62CAe0FA2da220f43a51F86Db2EDb36DcA9A5A08));
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
