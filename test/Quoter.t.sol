// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Quoter } from "../src/periphery/lens/Quoter.sol";
import { ManagerTrade } from "./ManagerTrade.t.sol";
import { getTradeParams } from "./shared/Actions.sol";
import { TradeParams } from "periphery/params/peripheryParams.sol";
import { BattleTradeParams } from "core/params/BattleTradeParams.sol";
import "core/types/common.sol";

contract QuoterTest is ManagerTrade {
    function setUp() public virtual override {
        super.setUp();
    }

    function test_Quoter() public {
        address battleAddr = super.test_AddLiquidity();
        Quoter quoter = new Quoter(address(0), address(0));
        TradeParams memory params1 = getTradeParams(defaultBattleKey, TradeType.BUY_SHIELD, 10e18, bob, 0, 0, 300);
        BattleTradeParams memory battleParams = BattleTradeParams({
            recipient: params1.recipient,
            tradeType: params1.tradeType,
            amountSpecified: params1.amountSpecified,
            sqrtPriceLimitX96: params1.sqrtPriceLimitX96,
            data: bytes("")
        });
        (uint256 spend, uint256 get) = quoter.quoteExactInput(battleParams, battleAddr);
        assertGt(spend, 0);
        assertGt(get, 0);
    }
}
