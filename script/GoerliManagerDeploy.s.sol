// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "./shared/DeployUtils.sol" as utils;
import { BaseScript } from "./shared/Base.s.sol";
import { deploy, DeployAddrs } from "script/shared/DeployUtils.sol";
import { IBattleInitializer } from "../src/periphery/interfaces/IBattleInitializer.sol";
import { CreateAndInitBattleParams } from "../src/periphery/params/Params.sol";
import { IBattleState } from "../src/core/interfaces/battle/IBattleState.sol";
import { TickMath } from "../src/core/libs/TickMath.sol";
import "../src/core/types/common.sol";
import "../src/core/types/enums.sol";
import { IBattle } from "../src/core/interfaces/battle/IBattle.sol";
import { Oracle } from "../src/core/Oracle.sol";
import { getTS, Period } from "../test/shared/utils.sol";
import { Quoter } from "../src/periphery/lens/Quoter.sol";

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

        address arenaAddr = address(0);
        address collateralToken = address(0);
        address wethAddr = address(0);
        address oracle = _deployOracle();
        DeployAddrs memory das = DeployAddrs({
            owner: deployer,
            arenaAddr: arenaAddr,
            collateralToken: collateralToken,
            wethAddr: wethAddr,
            quoter: quoter,
            oracle: oracle,
            decimal: 18
        });
        (manager, arena, oracle, collateral, quoter) = deploy(das);

        // doBaseThing();

        // deployQuoter();
    }

    function getBattleKey(uint256 strikeValue) internal returns (BattleKey memory) {
        (, uint256 expiries) = getTS(Period.WEEKLY);
        BattleKey memory bk = BattleKey({
            collateral: address(0xA87B4e604aCefd6Cf6059bb73a7b4e0bA90434DA),
            underlying: "BTC",
            expiries: expiries,
            strikeValue: 25_000_000_000_000_000_000_000
        });
        return bk;
    }

    function _deployOracle() private returns (address oracle) {
        Oracle oracle = new Oracle();
        symbols.push("BTC");
        symbols.push("ETH");
        oracles.push(address(0x8bdFc91FB3f89F4c211461B06afDe84Dc55bedc2));
        oracles.push(address(0x1B8e08a5457b12ae3CbC4233e645AEE2fA809e39));
        oracle.setExternalOracle(symbols, oracles);
        return address(oracle);
    }

    function createBattle() public virtual returns (address) {
        BattleKey memory bk = getBattleKey(100_000e18);
        int24 tick = 22;
        // uint160 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(22);
        uint160 sqrtPriceX96 = 79_228_162_514_264_337_593_543_950_336;
        CreateAndInitBattleParams memory params =
            CreateAndInitBattleParams({ bk: bk, sqrtPriceX96: sqrtPriceX96 });
        address battleAddr = IBattleInitializer(address(0xc35717a122b664Fc784De66cF9C27A2cc8cfb62d)).createAndInitializeBattle(params);
        address spear = IBattle(battleAddr).spear();
        address shield = IBattle(battleAddr).shield();

        return battleAddr;
    }

    function deployQuoter() public {
        Quoter quoter = new Quoter(address(0xC09619865f6EEAB0C87360D3200da0b6FA4034a1), address(0));
    }

    function doBaseThing() public {
        createBattle();
    }
}
