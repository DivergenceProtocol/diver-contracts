// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test } from "@std/Test.sol";
import { DeploymentFixture } from "../fixtures/Ready.sol";
import { TestERC20 } from "../shared/TestERC20.sol";
import { Handler } from "../invariant/handlers/Handler.sol";
import { IERC721Enumerable, IERC721 } from "@oz/token/ERC721/extensions/IERC721Enumerable.sol";
import { LiquidityType, Outcome } from "../../src/core/types/common.sol";
import { IManagerState } from "../../src/periphery/interfaces/IManagerState.sol";
import { IERC20 } from "@oz/token/ERC20/IERC20.sol";
import { IBattleState } from "../../src/core/interfaces/battle/IBattleState.sol";
import { console2 } from "@std/console2.sol";
import { Multicall } from "@oz/utils/Multicall.sol";
import { Position, PositionState } from "../../src/periphery/types/common.sol";
import { IBattleTrade } from "../../src/core/interfaces/battle/IBattleActions.sol";
import { IQuoter } from "../../src/periphery/interfaces/IQuoter.sol";

// contract DivergenceInvariant is DeploymentFixture {
contract DivergenceTradeInvariant is Test {
    Handler public handler;
    bytes4[] public selectors;

    function setUp() public virtual {
        // targetContract(manager);
        handler = new Handler(18, 50, 150, 150);

        // handler.getManager();

        selectors.push(Handler.addLiq.selector);
        // selectors.push(Handler.addLiq1.selector);
        // selectors.push(Handler.addLiq2.selector);
        // selectors.push(Handler.addLiq3.selector);
        // selectors.push(Handler.addLiq4.selector);
        // selectors.push(Handler.addLiqBySpear.selector);
        // selectors.push(Handler.addLiqByShield.selector);
        // selectors.push(Handler.addLiq1.selector);
        // selectors.push(Handler.removeLiq.selector);
        selectors.push(Handler.buySpear.selector);
        // selectors.push(Handler.buySpear1.selector);
        // selectors.push(Handler.buySpear2.selector);
        selectors.push(Handler.buyShield.selector);
        // selectors.push(Handler.buyShield1.selector);
        // selectors.push(Handler.buyShield3.selector);
        // selectors.push(Handler.settleBattle.selector);
        // selectors.push(Handler.withdrawAndExercise.selector);

        // selectors.push(Handler.withdraw.selector);
        // selectors.push(Handler.execriseSpear.selector);
        // selectors.push(Handler.execriseShield.selector);
        // selectors.push(Handler.exerciseAll.selector);

        targetSelector(FuzzSelector({ addr: address(handler), selectors: selectors }));

        targetContract(address(handler));
    }

    /// forge-config: default.invariant.runs = 2
    /// forge-config: default.invariant.depth = 1000
    function invariant_TradeAmount() public {
        handler.callSummary();
        address manager = handler.manager();
        address battle = handler.battle();
        address collateral = handler.collateral();
        uint256 totalSpear = IERC20(handler.spear()).totalSupply();
        uint256 totalShield = IERC20(handler.shield()).totalSupply();
        // It will check something to prove trades are ok.
        uint cAmount = handler.ghost_total_camount();
        uint spearAmount = handler.ghost_total_samount_spear();
        uint shieldAmount = handler.ghost_total_samount_shield();
        uint col = handler.ghost_collateral();
        uint sAmount = spearAmount > shieldAmount ? spearAmount : shieldAmount;
        assertGe(cAmount+col, sAmount);
        console2.log("**************************");
    }

}
