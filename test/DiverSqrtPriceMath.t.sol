// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { DiverLiquidityAmounts, LiquidityAmounts } from "../src/periphery/libs/DiverLiquidityAmounts.sol";
import { DiverSqrtPriceMath } from "core/libs/DiverSqrtPriceMath.sol";
import { SqrtPriceMath } from "@uniswap/v3-core/contracts/libraries/SqrtPriceMath.sol";
import { TickMath } from "core/libs/TickMath.sol";
import { Test } from "@std/Test.sol";
import { console2 } from "@std/console2.sol";

contract DiverSqrtPriceMathTest is Test {
    function testGetSTokenDelta() public {
        int24 tickLower = -25_853;
        int24 tickUpper = -20_453;
        uint160 lowerPrice = TickMath.getSqrtRatioAtTick(tickLower);
        uint160 upperPrice = TickMath.getSqrtRatioAtTick(tickUpper);
        uint256 spearAmount = 316_991_053_886_069_327_121;
        uint128 liquidity = DiverLiquidityAmounts.getLiquidityFromSToken(lowerPrice, upperPrice, spearAmount);
        console2.log("liquidity: %s", liquidity);
        uint256 amount = DiverSqrtPriceMath.getSTokenDelta(lowerPrice, upperPrice, liquidity, true);
        console2.log("amount: %s", amount);
        assertGt(amount, 0);
    }

    function testGetAmount0Delta() public {
        int24 tickLower = -25_853;
        int24 tickUpper = -20_453;
        uint160 lowerPrice = TickMath.getSqrtRatioAtTick(tickLower);
        uint160 upperPrice = TickMath.getSqrtRatioAtTick(tickUpper);
        uint256 spearAmount = 316_991_053_886_069_327_121;
        // uint128 liquidity =  DiverLiquidityAmounts.getLiquidityFromSToken(lowerPrice,
        // upperPrice, spearAmount);
        uint128 liquidity = LiquidityAmounts.getLiquidityForAmount0(lowerPrice, upperPrice, spearAmount);
        console2.log("liquidity: %s", liquidity);
        uint256 amount = SqrtPriceMath.getAmount0Delta(lowerPrice, upperPrice, liquidity, true);
        console2.log("amount: %s", amount);
        assertGt(amount, 0);
    }

    function testTick() public {
        uint160 p = 58_137_576_983_530_239_198_007_442_646;
        int24 tick = TickMath.getTickAtSqrtRatio(p);
        console2.log("tick: %s", tick);
        assertTrue(tick != 0, "get tick error");
    }

    function testFuzz_GetNextSqrtPriceFromSpear(int24 tickLower, int24 tickUpper, uint256 spearAmount) public view {
        uint256 decimal = 18;
        // vm.assume(decimal <=18 );

        //  ticks diff
        tickLower = int24(bound(tickLower, TickMath.MIN_TICK, TickMath.MAX_TICK - 1));
        tickUpper = int24(bound(tickUpper, tickLower + 1, TickMath.MAX_TICK));
        spearAmount = (bound(spearAmount, 1e6, 6e27));

        // tickLower = TickMath.MIN_TICK;
        // tickUpper = TickMath.MAX_TICK;
        // spearAmount = 0.000000000001e18;
        // spearAmount = 1000000;

        // spearAmount diff
        // tickLower = 200;
        // tickUpper = tickLower + 1;
        // spearAmount = (bound(spearAmount, 1e29, 1e12*1e18));
        // spearAmount = 6e27;

        // vm.assume(spearAmount > 1);
        // spearAmount = 1000000e18;
        console2.log("decimal %s", decimal);
        console2.log("tickLower %s", tickLower);
        console2.log("tickUpper %s", tickUpper);
        console2.log("spearAmount %s", spearAmount);
        uint160 lowerPrice = TickMath.getSqrtRatioAtTick(tickLower);
        console2.log("lowerPrice: %s", lowerPrice);
        console2.log("Q96:        %s", uint256(2 ** 96));
        uint160 upperPrice = TickMath.getSqrtRatioAtTick(tickUpper);
        console2.log("upperPrice: %s", upperPrice);
        uint128 liquidity = DiverLiquidityAmounts.getLiquidityFromSToken(lowerPrice, upperPrice, spearAmount);
        console2.log("liquidity   %s", liquidity);
        console2.log("spearAmount %s", spearAmount);
        console2.log("upper price %s", upperPrice);
        uint160 nextPrice = DiverSqrtPriceMath.getNextSqrtPriceFromSpear(upperPrice, liquidity, spearAmount, 10 ** decimal);
        console2.log("lowerPrice %s", lowerPrice);
        console2.log("nextPrice  %s", nextPrice);
        int24 nextTick = TickMath.getTickAtSqrtRatio(nextPrice);
        console2.log("lower tick %s", tickLower);
        console2.log("next tick  %s", nextTick);
        assert(tickLower - nextTick <= 1 && tickLower >= nextTick);
    }

    function testFuzz_GetNextSqrtPriceFromShield(int24 tickLower, int24 tickUpper, uint256 shieldAmount) public view {
        uint256 decimal = 18;
        // vm.assume(decimal <=18 );

        //  ticks diff
        tickLower = int24(bound(tickLower, TickMath.MIN_TICK, TickMath.MAX_TICK - 1));
        tickUpper = int24(bound(tickUpper, tickLower + 1, TickMath.MAX_TICK - 1));
        shieldAmount = (bound(shieldAmount, 1e6, 6e27));

        // tickLower = TickMath.MIN_TICK;
        // tickUpper = TickMath.MAX_TICK;
        // spearAmount = 0.000000000001e18;
        // spearAmount = 1000000;

        // spearAmount diff
        // tickLower = 200;
        // tickUpper = tickLower + 1;
        // spearAmount = (bound(spearAmount, 1e29, 1e12*1e18));
        // spearAmount = 6e27;

        // vm.assume(spearAmount > 1);
        // spearAmount = 1000000e18;
        console2.log("decimal %s", decimal);
        console2.log("tickLower %s", tickLower);
        console2.log("tickUpper %s", tickUpper);
        console2.log("shieldAmount %s", shieldAmount);
        uint160 lowerPrice = TickMath.getSqrtRatioAtTick(tickLower);
        console2.log("lowerPrice: %s", lowerPrice);
        console2.log("Q96:        %s", uint256(2 ** 96));
        uint160 upperPrice = TickMath.getSqrtRatioAtTick(tickUpper);
        console2.log("upperPrice: %s", upperPrice);
        uint128 liquidity = DiverLiquidityAmounts.getLiquidityFromSToken(lowerPrice, upperPrice, shieldAmount);
        // uint128 liquidity = DiverLiquidityAmounts.getLiquidityFromSToken(lowerPrice, upperPrice, shieldAmount);
        console2.log("liquidity   %s", liquidity);
        console2.log("shieldAmount %s", shieldAmount);
        console2.log("upper price %s", upperPrice);
        uint160 nextPrice = DiverSqrtPriceMath.getNextSqrtPriceFromShield(lowerPrice, liquidity, shieldAmount, 10 ** decimal);
        // console2.log("lowerPrice  %s", lowerPrice);
        console2.log("nextPrice   %s", nextPrice);
        int24 nextTick = TickMath.getTickAtSqrtRatio(nextPrice);
        // console2.log("lower tick %s", tickLower);
        console2.log("upper tick %s", tickUpper);
        console2.log("next tick  %s", nextTick);
        assert(tickUpper - nextTick <= 1 && tickUpper >= nextTick);
    }
}
