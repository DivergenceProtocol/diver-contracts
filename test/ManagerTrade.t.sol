// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Mint } from "./ManagerMintBurn.t.sol";
import { IManagerActions } from "../src/periphery/interfaces/IManagerActions.sol";
import { IManager } from "../src/periphery/interfaces/IManager.sol";
import { AddLiqParams } from "../src/periphery/params/Params.sol";
import { IBattleState } from "../src/core/interfaces/battle/IBattleState.sol";
import { console2 } from "@std/console2.sol";
import { getTradeParams, getAddLiquidityParams, trade } from "./shared/Actions.sol";
import { IERC20 } from "@oz/token/ERC20/IERC20.sol";
import { IManagerState } from "../src/periphery/interfaces/IManagerState.sol";
import "../src/core/types/common.sol";
import "../src/core/types/enums.sol";
import { TradeParams } from "../src/periphery/params/Params.sol";
import { IBattle } from "../src/core/interfaces/battle/IBattle.sol";
import { IManager } from "../src/periphery/interfaces/IManager.sol";
import { Position, PositionState } from "../src/periphery/types/common.sol";
import {TickMath} from "../src/core/libs/TickMath.sol";
import {DiverSqrtPriceMath} from "../src/core/libs/DiverSqrtPriceMath.sol";
import { Battle } from "../src/core/Battle.sol";
import { SqrtPriceMath } from "@uniswap/v3-core/contracts/libraries/SqrtPriceMath.sol";
import { Tick } from "../src/core/libs/Tick.sol";
import { Tick as UniTick } from "@uniswap/v3-core/contracts/libraries/Tick.sol";

interface BattleProcess {
    function getProcess() external view returns(uint160[] memory, uint160[] memory, uint128[] memory);
}

contract ManagerTrade is Mint {
    function setUp() public virtual override {
        super.setUp();
    }

    // function test_trade() public virtual returns (address) {
    //     address battleAddr = super.test();
    //     (address spear, address shield) = IBattleState(battleAddr).spearAndShield();
    //     // bob will buy shield
    //     TradeParams memory params1 = getTradeParams(defaultBattleKey, TradeType.BUY_SHIELD, 10e18, bob, 0, 0, 300);
    //     (uint160 sqrtPriceX96, int24 tick,) = IBattleState(battleAddr).slot0();
    //     console2.log("tick %s", tick);
    //     console2.log("sqrtPriceX96 %s", sqrtPriceX96);
    //     vm.startPrank(bob);
    //     IManagerActions(manager).trade(params1);
    //     console2.log("shield balance %s", IERC20(shield).balanceOf(bob));
    //     console2.log("spear balance %s", IERC20(spear).balanceOf(bob));

    //     TradeParams memory params2 = params1;
    //     params2.tradeType = TradeType.BUY_SPEAR;
    //     params2.amountSpecified = 100e18;

    //     IManagerActions(manager).trade(params2);
    //     uint256 spearBalance = IERC20(spear).balanceOf(bob);
    //     uint256 shieldBalance = IERC20(shield).balanceOf(bob);
    //     console2.log("shield balance %s", shieldBalance);
    //     console2.log("spear balance %s", spearBalance);
    //     vm.stopPrank();

    //     (sqrtPriceX96, tick,) = IBattleState(battleAddr).slot0();
    //     console2.log("tick %s", tick);
    //     console2.log("sqrtPriceX96 %s", sqrtPriceX96);
    //     // AddLiqParams memory mparams =
    //     //     getAddLiquidityParams(defaultBattleKey, bob, tick - 200, tick - 100, LiquidityType.SPEAR, uint128(spearBalance), 300);
    //     // vm.startPrank(bob);
    //     // IERC20(spear).approve(manager, spearBalance);
    //     // IManagerActions(manager).addLiquidity(mparams);
    //     // IERC20(shield).approve(manager, shieldBalance);
    //     // AddLiqParams memory mparams2 =
    //     //     getAddLiquidityParams(defaultBattleKey, bob, tick + 100, tick + 200, LiquidityType.SHIELD, uint128(shieldBalance), 300);
    //     // IManagerActions(manager).addLiquidity(mparams2);
    //     // vm.stopPrank();

    //     // Position[] memory ps1 = IManagerState(manager).accountPositions(bob);
    //     // Position[] memory ps2 = IManagerState(manager).accountPositions(alice);

    //     // console2.log("position battle addr %s", ps1[0].battleAddr);
    //     // console2.log("position battle addr %s", ps1.length);
    //     // console2.log("position battle addr %s", ps2.length);

    //     return battleAddr;
    // }

    function trade100SpearAnd90Shield(address trader) internal {
        vm.startPrank(trader);
        TradeParams memory params = getTradeParams(defaultBattleKey, TradeType.BUY_SPEAR, 10e18, bob, 0, 0, 300);
        TradeParams memory params2 = getTradeParams(defaultBattleKey, TradeType.BUY_SHIELD, 10e18, bob, 0, 0, 300);
        trade(trader, manager, params, quoter);
        trade(trader, manager, params2, quoter);
        trade(trader, manager, params, quoter);
        trade(trader, manager, params2, quoter);
        trade(trader, manager, params, quoter);
        trade(trader, manager, params2, quoter);
        trade(trader, manager, params2, quoter);
        trade(trader, manager, params, quoter);
        trade(trader, manager, params2, quoter);
        trade(trader, manager, params, quoter);
        trade(trader, manager, params2, quoter);
        trade(trader, manager, params, quoter);
        trade(trader, manager, params, quoter);
        trade(trader, manager, params2, quoter);
        trade(trader, manager, params, quoter);
        trade(trader, manager, params2, quoter);
        trade(trader, manager, params, quoter);
        trade(trader, manager, params2, quoter);
        trade(trader, manager, params, quoter);
        vm.stopPrank();
    }

    function trade100SpearAnd80Shield(address trader) internal {
        vm.startPrank(trader);
        TradeParams memory params = getTradeParams(defaultBattleKey, TradeType.BUY_SPEAR, 20e18, bob, 0, 0, 300);
        TradeParams memory params2 = getTradeParams(defaultBattleKey, TradeType.BUY_SHIELD, 20e18, bob, 0, 0, 300);
        trade(trader, manager, params, quoter);
        trade(trader, manager, params2, quoter);
        trade(trader, manager, params, quoter);
        trade(trader, manager, params2, quoter);
        trade(trader, manager, params, quoter);
        trade(trader, manager, params2, quoter);
        trade(trader, manager, params, quoter);
        trade(trader, manager, params2, quoter);
        trade(trader, manager, params, quoter);
        vm.stopPrank();
    }

    // function test_AddLiquidityByShiled() public virtual {
    //     address battle = test();
    //     (address spear, address shield) =
    // IBattleState(battle).spearAndShield();
    //     IERC20(spear).approve(manager, 100e18);
    //     // IERC20(shield).approve(manager, 100e18);
    //     uint amount = IERC20(shield).balanceOf(bob);
    //     console2.log("shield balance %s", amount);
    //     uint spearAmount = IERC20(spear).balanceOf(bob);
    //    console2.log("spear balance %s", spearAmount);

    // }

    function test_BuySpearByExactOut() public virtual {
        address battleAddr = super.test();
        (address spear, address shield) = IBattleState(battleAddr).spearAndShield();
        // bob will buy shield
        vm.startPrank(bob);
        TradeParams memory params1 = getTradeParams(defaultBattleKey, TradeType.BUY_SPEAR, 10e18, bob, 0, 0, 300);

        IManagerActions(manager).trade(params1);
        uint256 spearBalance = IERC20(spear).balanceOf(bob);
        uint256 shieldBalance = IERC20(shield).balanceOf(bob);
        console2.log("shield balance %s", shieldBalance);
        console2.log("spear balance %s", spearBalance);
        vm.stopPrank();
    }

    function test_BuyShieldByExactOut() public virtual {
        address battleAddr = super.test();
        (address spear, address shield) = IBattleState(battleAddr).spearAndShield();
        // bob will buy shield
        vm.startPrank(bob);
        TradeParams memory params1 = getTradeParams(defaultBattleKey, TradeType.BUY_SHIELD, 10e18, bob, 0, 0, 300);
        (uint160 sqrtPriceX96, int24 tick,) = IBattleState(battleAddr).slot0();
        console2.log("tick %s", tick);
        console2.log("sqrtPriceX96 %s", sqrtPriceX96);
        IManagerActions(manager).trade(params1);        console2.log("shield balance %s", IERC20(shield).balanceOf(bob));
        console2.log("spear balance %s", IERC20(spear).balanceOf(bob));
        vm.stopPrank();
    }

    function test_BuySpearCrossTick() public virtual {
        address battleAddr = super.addMultiLiquidity();
        (address spear, address shield) = IBattleState(battleAddr).spearAndShield();
        // bob will buy shield
        vm.startPrank(bob);
        TradeParams memory params1 = getTradeParams(defaultBattleKey, TradeType.BUY_SPEAR, -250e18, bob, 0, 0, 300);
        IManagerActions(manager).trade(params1);
        uint256 spearBalance = IERC20(spear).balanceOf(bob);
        uint256 shieldBalance = IERC20(shield).balanceOf(bob);
        console2.log("shield balance %s", shieldBalance);
        console2.log("spear balance  %s.%s", spearBalance/1e18, spearBalance%1e18);
        vm.stopPrank();

    }

    function test_BuyShieldCrossTick() public virtual {
        address battleAddr = super.addMultiLiquidity();
        (address spear, address shield) = IBattleState(battleAddr).spearAndShield();
        // bob will buy shield
        vm.startPrank(bob);
        int specific = -250e18;
        TradeParams memory params1 = getTradeParams(defaultBattleKey, TradeType.BUY_SHIELD, specific, bob, 0, 0, 300);
        console2.log("Buy Shield %s ", specific > 0 ? "exactIn" : "exactOut");
        uint sp = specific > 0 ? uint(specific) : uint(-specific);
        console2.log("amount %s.%s", sp/1e18, sp%1e18);
        IManagerActions(manager).trade(params1);
        TradeParams memory p2 = params1;
        p2.amountSpecified = -params1.amountSpecified;
        // IManagerActions(manager).trade(p2);
        uint256 spearBalance = IERC20(spear).balanceOf(bob);
        uint256 shieldBalance = IERC20(shield).balanceOf(bob);
        console2.log("shield balance %s.%s", shieldBalance/1e18, shieldBalance%1e18);
        console2.log("spear balance  %s.%s", spearBalance/1e18, spearBalance%1e18);
        vm.stopPrank();

    }

    function wrapTrade(TradeParams memory params, address battleAddr, address spear, address shield) public returns(uint cAmount, uint sAmount, uint160 latestSqrtPriceX96, int24 latestTick){
        console2.log("Buy %s %s ", params.tradeType == TradeType.BUY_SPEAR ? "Spear" : "Shield", params.amountSpecified > 0 ? "exactIn" : "exactOut");
        uint sp = params.amountSpecified > 0 ? uint(params.amountSpecified) : uint(-params.amountSpecified);
        console2.log("amount %s%s.%s", params.amountSpecified > 0 ? "":"-", sp/1e18, sp%1e18);
        (cAmount, sAmount) = IManagerActions(manager).trade(params);
        uint256 spearBalance = IERC20(spear).balanceOf(bob);
        uint256 shieldBalance = IERC20(shield).balanceOf(bob);
        console2.log("shield balance %s.%s", shieldBalance/1e18, shieldBalance%1e18);
        console2.log("spear balance  %s.%s", spearBalance/1e18, spearBalance%1e18);
        (latestSqrtPriceX96, latestTick, ) = IBattleState(battleAddr).slot0();
        console2.log("===========Trade End==========");
    }

    function test_BuySpearAndShieldToRecoverPriceExactOut(int specific) public virtual {
        address battleAddr = super.addMultiLiquidity();
        (address spear, address shield) = IBattleState(battleAddr).spearAndShield();
        // bob will buy shield
        vm.startPrank(bob);
        (uint160 sqrtPriceX96Start, int24 tickStart,) = IBattleState(battleAddr).slot0();
        // buy exact out spear
        specific = bound(specific, -6000000e18, -1e6);
        // int specific = -500e18;
        TradeParams memory params1 = getTradeParams(defaultBattleKey, TradeType.BUY_SPEAR, specific, bob, 0, 0, 300);
        (uint cAmount1, uint sAmount1, , ) = wrapTrade(params1, battleAddr, spear, shield);
        TradeParams memory params2 = params1;
        params2.tradeType = TradeType.BUY_SHIELD;
        (uint cAmount2, uint sAmount2, uint160 sqrtPriceX96End, int24 tickEnd) = wrapTrade(params2, battleAddr, spear, shield);

        assertEq(sAmount1, sAmount2, "sAmount violated");
        assertGe(cAmount1+cAmount2, sAmount1>sAmount2 ? sAmount1 : sAmount2, "cAmount >= sAmount1");
        // assert(cAmount1+cAmount2 == uint(-specific));
        // assertEq(sAmount1, sAmount2, "sAmount violated");
        // assertGe(cAmount1+cAmount2, sAmount1, "amount violated");
        // assertGe(sqrtPriceX96End, sqrtPriceX96Start, "price violated");
        // assertGt(tickStart, tickEnd, "tick violated");
        vm.stopPrank();
    }

    function test_BuyShiedAndSpearToRecoverPriceExactOut(int specific) public virtual {
        address battleAddr = super.addMultiLiquidity();
        (address spear, address shield) = IBattleState(battleAddr).spearAndShield();
        // bob will buy shield
        vm.startPrank(bob);
        (uint160 sqrtPriceX96Start, int24 tickStart,) = IBattleState(battleAddr).slot0();
        // buy exact out spear
        specific = bound(specific, -6000000e18, -1e6);
        // int specific = -500e18;
        TradeParams memory params1 = getTradeParams(defaultBattleKey, TradeType.BUY_SHIELD, specific, bob, 0, 0, 300);
        (uint cAmount1, uint sAmount1, , ) = wrapTrade(params1, battleAddr, spear, shield);
        TradeParams memory params2 = params1;
        params2.tradeType = TradeType.BUY_SPEAR;
        (uint cAmount2, uint sAmount2, uint160 sqrtPriceX96End, int24 tickEnd) = wrapTrade(params2, battleAddr, spear, shield);

        assertEq(sAmount1, sAmount2, "sAmount violated");
        assertGe(cAmount1+cAmount2, sAmount1>sAmount2 ? sAmount1 : sAmount2, "cAmount >= sAmount1");
        // assert(cAmount1+cAmount2 == uint(-specific));
        // assertGe(cAmount1+cAmount2, sAmount1, "amount violated");
        // assertGe(sqrtPriceX96End, sqrtPriceX96Start, "price violated");
        // assertGt(tickStart, tickEnd, "tick violated");
        vm.stopPrank();
    }


    // exact in and exact out
    function test_BuySpearAndShieldToRecoverPriceMix(int specific) public virtual {
        address battleAddr = super.addMultiLiquidity();
        (address spear, address shield) = IBattleState(battleAddr).spearAndShield();
        // bob will buy shield
        vm.startPrank(bob);
        (uint160 sqrtPriceX96Start, int24 tickStart,) = IBattleState(battleAddr).slot0();
        // buy exact out spear
        specific = int(bound(specific, 1e6, 1e24));
        TradeParams memory params1 = getTradeParams(defaultBattleKey, TradeType.BUY_SPEAR, specific, bob, 0, 0, 300);
        (uint cAmount1, uint sAmount1, , ) = wrapTrade(params1, battleAddr, spear, shield);
        TradeParams memory params2 = params1;
        params2.tradeType = TradeType.BUY_SHIELD;
        params2.amountSpecified = -int(sAmount1);
        (uint cAmount2, uint sAmount2, uint160 sqrtPriceX96End, int24 tickEnd) = wrapTrade(params2, battleAddr, spear, shield);

        assertGe(cAmount1+cAmount2, sAmount1, "c1+c2 >= s1");
        // assertGt(sqrtPriceX96Start, sqrtPriceX96End, "price violated");
        // assertGt(tickStart, tickEnd, "tick violated");
        vm.stopPrank();
    }


        uint160[]  sqrtStarts;
        uint160[]  sqrtEnds;
        uint128[]  liquidities;
     // exact in and exact out
    function test_BuySpearAndShieldToRecoverPriceExactIn(int specific) public virtual {
        delete sqrtStarts;
        delete sqrtEnds;
        delete liquidities;
        address battleAddr = super.addMultiLiquidity();
        (address spear, address shield) = IBattleState(battleAddr).spearAndShield();
        // bob will buy shield
        vm.startPrank(bob);
        (uint160 sqrtPriceX96Start, ,) = IBattleState(battleAddr).slot0();
        // buy exact out spear
        specific = int(bound(specific, 1e6, 1e26));
        TradeParams memory params1 = getTradeParams(defaultBattleKey, TradeType.BUY_SPEAR, specific, bob, 0, 0, 300);
        (uint cAmount1, uint sAmount1, uint160 sqrtPriceX96End1, ) = wrapTrade(params1, battleAddr, spear, shield);

        (sqrtStarts, 
        sqrtEnds,
        liquidities)
        = BattleProcess(battleAddr).getProcess();
        assertGt(sqrtStarts.length, 0);
        assertEq(sqrtStarts.length, sqrtEnds.length);
        assertEq(sqrtStarts.length, liquidities.length);
        uint fakeC2;
        for (uint i; i < sqrtStarts.length; i++) {
            fakeC2 += SqrtPriceMath.getAmount1Delta(sqrtStarts[i], sqrtEnds[i], liquidities[i], true);
        }

        TradeParams memory params2 = params1;
        params2.tradeType = TradeType.BUY_SHIELD;
        params2.amountSpecified = int(fakeC2);
        (uint cAmount2, uint sAmount2,  , ) = wrapTrade(params2, battleAddr, spear, shield);
        console2.log("c1+c2 %s", cAmount1+cAmount2);
        console2.log("s1 %s", sAmount1);
        console2.log("s2 %s", sAmount2);
        uint c12 = cAmount1+cAmount2;
        assertGe(c12, sAmount1 > sAmount2 ? sAmount1:sAmount2, "c1+c2 >= max(s1, s2)");
        // assertEq(sAmount1, sAmount2, "sAmount1 should equal to sAmount2");
        // assertEq(sqrtPriceX96Start, sqrtPriceX96End, "price violated");
        // assertEq(tickStart, tickEnd, "tick violated");
        vm.stopPrank();
    }

    function test_BuySpearAndShieldToRecoverPriceExactIn2(int specific) public virtual {
        address battleAddr = super.addMultiLiquidity();
        (address spear, address shield) = IBattleState(battleAddr).spearAndShield();
        // bob will buy shield
        vm.startPrank(bob);
        (uint160 sqrtPriceX96Start, int24 tickStart,) = IBattleState(battleAddr).slot0();
        // buy exact out spear
        specific = int(bound(specific, 1e6, 1e24));
        // specific = 50e18;
        TradeParams memory params1 = getTradeParams(defaultBattleKey, TradeType.BUY_SPEAR, specific, bob, 0, 0, 300);
        (uint cAmount1, uint sAmount1, uint160 sqrtPriceX96End1, ) = wrapTrade(params1, battleAddr, spear, shield);

        TradeParams memory params2 = params1;
        params2.tradeType = TradeType.BUY_SHIELD;
        assertGt(sAmount1, cAmount1, "s1 should greater than c1");
        params2.amountSpecified = int(sAmount1 - cAmount1);
        (uint cAmount2, uint sAmount2, uint160 sqrtPriceX96End, int24 tickEnd) = wrapTrade(params2, battleAddr, spear, shield);

        uint128 liqui = Battle(battleAddr).liquidity();

        // sqrtPriceX96Start = TickMath.getSqrtRatioAtTick(-100);
        uint s3 = DiverSqrtPriceMath.getSTokenDelta(sqrtPriceX96Start, sqrtPriceX96End, liqui, false);
        console2.log("s3 %s", s3);
        assertGe(sAmount1, sAmount2+s3, "s1 >= sum of s2 and s3");

        uint c3 = SqrtPriceMath.getAmount1Delta(sqrtPriceX96Start, sqrtPriceX96End, liqui, true);
        console2.log("c3 %s", c3);
        assertGe(cAmount1+cAmount2+c3, sAmount1, "cAmount >= sAmount1");

        // assertEq(sAmount1, sAmount2, "sAmount1 should equal to sAmount2");
        // assertEq(sqrtPriceX96Start, sqrtPriceX96End, "price violated");
        // assertEq(tickStart, tickEnd, "tick violated");
        vm.stopPrank();

    }

    function test_BuyShieldAndSpearToRecoverPriceExactIn(int specific) public virtual {
        delete sqrtStarts;
        delete sqrtEnds;
        delete liquidities;
        address battleAddr = super.addMultiLiquidity();
        (address spear, address shield) = IBattleState(battleAddr).spearAndShield();
        // bob will buy shield
        vm.startPrank(bob);
        (uint160 sqrtPriceX96Start, ,) = IBattleState(battleAddr).slot0();
        // buy exact out spear
        specific = int(bound(specific, 1e6, 1e26));
        TradeParams memory params1 = getTradeParams(defaultBattleKey, TradeType.BUY_SHIELD, specific, bob, 0, 0, 300);
        (uint cAmount1, uint sAmount1, uint160 sqrtPriceX96End1, ) = wrapTrade(params1, battleAddr, spear, shield);

        (sqrtStarts, 
        sqrtEnds,
        liquidities)
        = BattleProcess(battleAddr).getProcess();
        assertGt(sqrtStarts.length, 0);
        assertEq(sqrtStarts.length, sqrtEnds.length);
        assertEq(sqrtStarts.length, liquidities.length);
        uint fakeC2;
        for (uint i; i < sqrtStarts.length; i++) {
            fakeC2 += SqrtPriceMath.getAmount0Delta(sqrtStarts[i], sqrtEnds[i], liquidities[i], true);
        }

        TradeParams memory params2 = params1;
        params2.tradeType = TradeType.BUY_SPEAR;
        params2.amountSpecified = int(fakeC2);
        (uint cAmount2, uint sAmount2,  , ) = wrapTrade(params2, battleAddr, spear, shield);
        console2.log("c1+c2 %s", cAmount1+cAmount2);
        console2.log("s1 %s", sAmount1);
        console2.log("s2 %s", sAmount2);
        uint c12 = cAmount1+cAmount2;
        assertGe(c12, sAmount1 > sAmount2 ? sAmount1:sAmount2, "c1+c2 >= max(s1, s2)");
        // assertEq(sAmount1, sAmount2, "sAmount1 should equal to sAmount2");
        // assertEq(sqrtPriceX96Start, sqrtPriceX96End, "price violated");
        // assertEq(tickStart, tickEnd, "tick violated");
        vm.stopPrank();
    }


    function test_maxLiquidityPerTick() public {
        uint128 liquidity = Tick.tickSpacingToMaxLiquidityPerTick(1);
        uint128 uniMaxLiqui = UniTick.tickSpacingToMaxLiquidityPerTick(1);
        console2.log("uni max Liqui          %s", uniMaxLiqui);
        console2.log("max liquidity per tick %s", liquidity);
        // when tickSpacing == 1
        //191757530477355301479181766273477  uni max liquidity
        //3702464087838124010830237168352445 diver max liquidity
        //520422035044106720910931892293     infinite loop liquidity
    }

}
