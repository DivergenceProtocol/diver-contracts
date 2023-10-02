pragma solidity ^0.8.0;

import { ReadyFixture } from "../fixtures/Ready.sol";
import { ManagerTrade } from "../ManagerTrade.t.sol";
import {
    getAddLiquidityParams,
    createBattle,
    getCreateBattleParams,
    getTradeParams,
    trade,
    addLiquidity,
    removeLiquidity,
    position,
    settle,
    exercise,
    withdrawObligation
} from "../shared/Actions.sol";
import { IManager } from "../../src/periphery/interfaces/IManager.sol";
import { IBattle } from "core/interfaces/battle/IBattle.sol";
import { CreateAndInitBattleParams } from "periphery/params/peripheryParams.sol";
import { TradeParams, AddLiqParams } from "periphery/params/peripheryParams.sol";
import { TradeType } from "core/types/enums.sol";
import { LiquidityType } from "core/types/common.sol";
import { console2 } from "@std/console2.sol";
import { OracleForTest as Oracle } from "../oracle/OracleForTest.sol";
import { TestERC20 } from "../shared/TestERC20.sol";
import { getTS, Period } from "../shared/utils.sol";
import { Position, PositionState } from "../../src/periphery/types/common.sol";

contract Usecase3 is ManagerTrade {
    function setUp() public virtual override {
        super.setUp();
    }

    function test_Usecase3() public {
        console2.log("============>>Usecase3 begin<<============");
        address battleAddr = createBattle(manager, defaultCreateBattleParams);
        AddLiqParams memory addLiqParams = defaultAddLiqParams;
        addLiqParams.amount = 1000e18;
        vm.startPrank(alice);
        addLiquidity(alice, manager, addLiqParams, quoter);
        vm.stopPrank();

        AddLiqParams memory outRangeAddLiqParams = getAddLiquidityParams(defaultBattleKey, dave, -2100, -1500, LiquidityType.COLLATERAL, 1000e18, 300);
        vm.startPrank(dave);
        addLiquidity(dave, manager, outRangeAddLiqParams, quoter);
        position(dave, manager, quoter);
        vm.stopPrank();

        trade100SpearAnd90Shield(bob);

        vm.startPrank(dave);
        removeLiquidity(dave, manager, 1);
        vm.stopPrank();

        // bob add liquidity by spear
        (uint160 sqrtPriceX96, int24 tick,) = IBattle(battleAddr).slot0();
        console2.log("sqrtPriceX96: %s", sqrtPriceX96);
        console2.log("tick: %s", tick);
        AddLiqParams memory mintParams2 =
            getAddLiquidityParams(defaultBattleKey, bob, (tick - 1000) / 30 * 30, (tick - 100) / 30 * 30, LiquidityType.SPEAR, 20e18, 300);
        vm.startPrank(bob);
        (address spearAddr,) = IBattle(battleAddr).spearAndShield();
        TestERC20(spearAddr).approve(manager, type(uint256).max);
        addLiquidity(bob, manager, mintParams2, quoter);
        vm.stopPrank();

        trade100SpearAnd90Shield(carol);

        vm.startPrank(bob);
        removeLiquidity(bob, manager, 2);
        vm.stopPrank();

        (, uint256 expiries) = getTS(Period.BIWEEKLY);
        skip(expiries + 1);
        Oracle(oracle).setPrice(defaultCreateBattleParams.bk.underlying, expiries, 21_000e18);
        settle(msg.sender, battleAddr);
        exercise(msg.sender, battleAddr);
        vm.startPrank(dave);
        withdrawObligation(dave, manager, 1);
        position(dave, manager, quoter);
        vm.stopPrank();
        console2.log("============>>Usecase3 end<<============");
    }
}
