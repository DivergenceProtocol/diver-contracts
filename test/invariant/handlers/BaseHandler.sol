// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { ReadyFixture } from "../../fixtures/Ready.sol";
import { removeLiquidity, getBattleKey, getCreateBattleParams, createBattle, TradeParams, trade, getTradeParams } from "../../shared/Actions.sol";
import { TickMath } from "../../../src/core/libs/TickMath.sol";
import { CreateAndInitBattleParams } from "../../../src/periphery/params/Params.sol";
import "../../../src/core/types/enums.sol";
import "../../../src/core/types/common.sol";
import { EnumerableSet } from "@oz/utils/structs/EnumerableSet.sol";
import { getAddLiquidityParams, addLiquidity, AddLiqParams } from "../../shared/Actions.sol";
import { console2 } from "@std/console2.sol";
import { CommonBase } from "forge-std/Base.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { StdUtils } from "forge-std/StdUtils.sol";
import { deploy, DeployAddrs } from "../../../script/shared/DeployUtils.sol";
import { TestERC20 } from "../../shared/TestERC20.sol";
import { IERC721 } from "@oz/token/ERC721/IERC721.sol";
import { IManager } from "../../../src/periphery/interfaces/IManager.sol";
import { OracleForTest } from "../../oracle/OracleForTest.sol";
import { IBattle } from "../../../src/core/interfaces/battle/IBattle.sol";
import { ISToken } from "../../../src/core/interfaces/ISToken.sol";
import { IERC20 } from "@oz/token/ERC20/IERC20.sol";
import { Multicall } from "@oz/utils/Multicall.sol";
import { ERC721Enumerable } from "@oz/token/ERC721/extensions/ERC721Enumerable.sol";
// import { Position, PositionState } from "../../../src/periphery/types/common.sol";
import { IQuoter, Position, PositionState } from "../../../src/periphery/interfaces/IQuoter.sol";
import { getTS, Period } from "../../shared/utils.sol";

contract BaseHandler is CommonBase, StdCheats, StdUtils {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.UintSet;

    mapping(string => uint256) public calls;

    EnumerableSet.AddressSet private _actors;
    address internal currentActor;
    BattleKey public bk;
    address public battle;

    address public manager;
    address public arena;
    address public oracle;
    address public collateral;
    address public quoter;
    address public spear;
    address public shield;

    uint256 public ghost_nft_count;
    uint256 public ghost_collateral;
    uint256 public ghost_tradeAmount;
    bool public battleSettled;
    bool public ghost_run_end;

    address[] public users;
    uint256 public cAmount = 100_000_000;

    EnumerableSet.UintSet private _tokenIds;
    EnumerableSet.UintSet private _liquidityRemovedTokenIds;
    EnumerableSet.AddressSet private _spearUsers;
    EnumerableSet.AddressSet private _shieldUsers;

    uint256 public minAddLiqCount = 5;
    uint256 public minBuySpearCount = 5;
    uint256 public minBuyShieldCount = 5;

    constructor(uint256 minAddLiqCount_, uint256 minBuySpearCount_, uint256 minBuyShieldCount_) {
        minAddLiqCount = minAddLiqCount_;
        minBuySpearCount = minBuySpearCount_;
        minBuyShieldCount = minBuyShieldCount_;
        // vm.("localhost");
        vm.warp(1_681_978_412);
        for (uint256 i = 1; i < 31; i++) {
            users.push(vm.addr(i));
        }
        address owner = address(this);
        address arenaAddr = address(0);
        address collateralToken = address(0);
        address wethAddr = address(0);
        address _oracle = address(new OracleForTest());
        DeployAddrs memory das =
            DeployAddrs({ owner: owner, arenaAddr: arenaAddr, collateralToken: collateralToken, wethAddr: wethAddr, quoter: quoter, oracle: _oracle });
        (manager, arena, oracle, collateral, quoter) = deploy(das);

        cAmount = cAmount * 10 ** TestERC20(collateral).decimals();
        for (uint256 i; i < users.length; i++) {
            deal(collateral, users[i], cAmount);
            vm.prank(users[i]);
            TestERC20(collateral).approve(manager, type(uint256).max);
        }
        (, uint256 expiries) = getTS(Period.WEEKLY);
        bk = getBattleKey(collateral, "BTC", expiries, 26_000e18);
        CreateAndInitBattleParams memory params = getCreateBattleParams(bk, oracle, TickMath.getSqrtRatioAtTick(0));
        vm.prank(users[0]);
        battle = createBattle(manager, params);
        spear = IBattle(battle).spear();
        shield = IBattle(battle).shield();
    }

    modifier useActor(uint256 actorIndexSeed) {
        currentActor = users[bound(actorIndexSeed, 0, users.length - 1)];
        vm.startPrank(currentActor);
        _;
        vm.stopPrank();
    }

    modifier addActor(uint256 actorIndexSeed) {
        currentActor = users[bound(actorIndexSeed, 0, users.length - 1)];
        _actors.add(currentActor);
        vm.startPrank(currentActor);
        _;
        vm.stopPrank();
    }

    modifier removeActor(uint256 actorIndexSeed) {
        currentActor = _actors.at(bound(actorIndexSeed, 0, _actors.length() - 1));
        _actors.remove(currentActor);
        vm.startPrank(currentActor);
        _;
        vm.stopPrank();
    }

    function callSummary() public view {
        console2.log("Call summary:");
        console2.log("addLiq        :", calls["addLiq"]);
        console2.log("addLiqBySpear :", calls["addLiqBySpear"]);
        console2.log("addLiqByShield:", calls["addLiqByShield"]);
        console2.log("removeLiq     :", calls["removeLiq"]);
        console2.log("buySpear      :", calls["buySpear"]);
        console2.log("buyShield     :", calls["buyShield"]);
        console2.log("settleBattle", calls["settleBattle"]);
        // console2.log("withdrawObligation", calls["withdrawObligation"]);
        // console2.log("execriseSpear", calls["execriseSpear"]);
        // console2.log("execriseShield", calls["execriseShield"]);
        // console2.log("execriseAll", calls["execriseAll"]);
        console2.log("withdrawAndExerciseAll", calls["withdrawAndExerciseAll"]);
    }

    function addLiquidityByCol(
        uint256 actorIndexSeed,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount
    )
        public
        virtual
        addActor(actorIndexSeed)
        returns (uint256, uint256)
    {
        tickLower = int24(bound(tickLower, TickMath.MIN_TICK, TickMath.MAX_TICK - 1));
        tickUpper = int24(bound(tickUpper, tickLower + 1, TickMath.MAX_TICK));
        amount = uint128(bound(uint256(amount), 1e6, 100_000e18));
        AddLiqParams memory param = getAddLiquidityParams(bk, currentActor, tickLower, tickUpper, LiquidityType.COLLATERAL, amount, 300);
        (uint256 tokenId,,) = IManager(manager).addLiquidity(param);
        return (amount, tokenId);
    }

    function addLiquidityBySpear() public virtual { }

    // function addLiquidityByShield() public virtual { }

    // function buySpearExactIn() public virtual { }

    uint public ghost_cAmount;
    uint public ghost_spearAmount;
    uint public ghost_shieldAmount;
    function buySpear(uint256 actorIndexSeed, int256 amount) public useActor(actorIndexSeed) {
        if (ghost_nft_count == 0) {
            return;
        }
        (uint160 p,,) = IBattle(battle).slot0();
        if (p == TickMath.MIN_SQRT_RATIO + 1) {
            return;
        }
        amount = bound(amount, -1e6*1e18, 1e6*1e18);
        // deal(collateral, currentActor, amount);
        // TestERC20(collateral).approve(manager, type(uint256).max);
        TradeParams memory param = getTradeParams(bk, TradeType.BUY_SPEAR, amount, currentActor, 0, 0, 300);
        (uint cAmount, uint sAmount) = trade(currentActor, manager, param, quoter);
        ghost_cAmount += cAmount;
        ghost_spearAmount += sAmount;
        // ghost_tradeAmount += amount;
        // uint256 balance = IERC20(spear).balanceOf(currentActor);
        // if (balance > 0) {
        //     _spearUsers.add(currentActor);
        // }
        // calls["buySpear"] += 1;
        // checkBalance();
    }

    // function buySpearExactOut() public virtual { }

    // function buyShieldExactIn() public virtual { }

    // function buyShieldExactOut() public virtual { }
}
