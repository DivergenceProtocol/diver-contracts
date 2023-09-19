// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { ReadyFixture } from "../../fixtures/Ready.sol";
import { removeLiquidity, getBattleKey, getCreateBattleParams, createBattle, TradeParams, trade, getTradeParams } from "../../shared/Actions.sol";
import { TickMath } from "../../../src/core/libs/TickMath.sol";
import { CreateAndInitBattleParams } from "../../../src/periphery/params/Params.sol";
import "../../../src/core/types/enums.sol";
import "../../../src/core/types/common.sol";
import { EnumerableSet } from "@oz/utils/structs/EnumerableSet.sol";
import { getAddLiquidityParams, addLiquidity, AddLiqParams, redeemObligation } from "../../shared/Actions.sol";
import { console2 } from "@std/console2.sol";
import { CommonBase } from "forge-std/Base.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { StdUtils } from "forge-std/StdUtils.sol";
import { StdAssertions } from "forge-std/StdAssertions.sol";
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

contract Handler is CommonBase, StdCheats, StdUtils, StdAssertions {
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
    uint256 public ghost_seed_collateral;
    uint256 public ghost_collatealIn;
    uint256 public ghost_tradeAmount;
    uint256 public ghost_totalFee;
    bool public battleSettled;
    bool public ghost_run_end;

    bool public end;

    address[] public users;
    // uint256 public cAmount = 100_000;

    EnumerableSet.UintSet private _tokenIds;
    EnumerableSet.UintSet private _liquidityRemovedTokenIds;
    EnumerableSet.AddressSet private _spearUsers;
    EnumerableSet.AddressSet private _shieldUsers;

    uint256 public minAddLiqCount = 5;
    uint256 public minBuySpearCount = 5;
    uint256 public minBuyShieldCount = 5;

    uint256 public ghost_depth;

    uint8 public decimal;
    uint256 public unit;

    constructor(uint8 decimal_, uint256 minAddLiqCount_, uint256 minBuySpearCount_, uint256 minBuyShieldCount_, bool hasFee) {
        decimal = decimal_;
        unit = 10 ** decimal_;
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
        DeployAddrs memory das = DeployAddrs({
            owner: owner,
            arenaAddr: arenaAddr,
            collateralToken: collateralToken,
            wethAddr: wethAddr,
            quoter: quoter,
            oracle: _oracle,
            decimal: decimal,
            hasFee: hasFee
        });
        (manager, arena, oracle, collateral, quoter) = deploy(das);

        // cAmount = cAmount * 10 ** TestERC20(collateral).decimals();
        for (uint256 i; i < users.length; i++) {
            deal(collateral, users[i], 1e16 * unit);
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
        for (uint256 i; i < users.length; i++) {
            vm.prank(users[i]);
            TestERC20(spear).approve(manager, type(uint256).max);
            vm.prank(users[i]);
            TestERC20(shield).approve(manager, type(uint256).max);
        }
    }

    modifier notSettled() {
        // require(!battleSettled, "battle settled");
        if (battleSettled) {
            withdrawAndExercise();
            return;
        }
        _;
    }

    modifier useActor(uint256 actorIndexSeed) {
        currentActor = users[bound(actorIndexSeed, 0, users.length - 1)];
        vm.startPrank(currentActor);
        _;
        vm.stopPrank();
    }

    function getActor(uint256 actorIndexSeed) internal returns (address) {
        currentActor = users[bound(actorIndexSeed, 0, users.length - 1)];
        vm.startPrank(currentActor);
        return currentActor;
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

    function adjustTickForTickSpacing(int24 tick, int24 _tickSpacing) internal pure returns (int24) {
        return (tick / _tickSpacing) * _tickSpacing;
    }

    function adjustTickForAddLiquiditySToken(
        int24 tickLower,
        int24 tickUpper,
        int256 cTick,
        LiquidityType lt
    )
        internal
        view
        returns (int24 tl, int24 tu)
    {
        tl = adjustTickForTickSpacing(tickLower, tickSpacing);
        tu = adjustTickForTickSpacing(tickUpper, tickSpacing);
        int24 maxTick = TickMath.MAX_TICK / tickSpacing * tickSpacing;
        int24 minTick = TickMath.MIN_TICK / tickSpacing * tickSpacing;
        if (tl == maxTick) {
            tl = maxTick - tickSpacing;
            tu = maxTick;
        }
        if (tu == minTick) {
            tl = minTick;
            tu = minTick + tickSpacing;
        }
        if (tl == tu) {
            tu += tickSpacing;
        }
        if (lt == LiquidityType.SPEAR) {
            if (!(cTick >= tu)) {
                int24 diff = int24(((tu - cTick) / tickSpacing + 1) * tickSpacing);
                tl -= diff;
                tu -= diff;
            }
        } else if (lt == LiquidityType.SHIELD) {
            if (!(cTick <= tl)) {
                int24 diff = int24(((cTick - tl) / tickSpacing + 1) * tickSpacing);
                tl += diff;
                tu += diff;
            }
        }
    }

    function adjustTickForAddLiquidity(int24 tickLower, int24 tickUpper) internal view returns (int24 tl, int24 tu) {
        tl = adjustTickForTickSpacing(tickLower, tickSpacing);
        tu = adjustTickForTickSpacing(tickUpper, tickSpacing);
        int24 maxTick = TickMath.MAX_TICK / tickSpacing * tickSpacing;
        int24 minTick = TickMath.MIN_TICK / tickSpacing * tickSpacing;
        if (tl == maxTick) {
            tl = maxTick - tickSpacing;
            tu = maxTick;
        }
        if (tu == minTick) {
            tl = minTick;
            tu = minTick + tickSpacing;
        }
        if (tl == tu) {
            tu += tickSpacing;
        }
    }

    int24 public tickSpacing = 30;

    function addLiq(uint256 actorIndexSeed, int24 tickLower, int24 tickUpper, uint128 amount) public notSettled addActor(actorIndexSeed) {
        console2.log("Action: Add Liquidity by Col");
        tickLower = int24(bound(tickLower, TickMath.MIN_TICK, TickMath.MAX_TICK - 1));
        tickUpper = int24(bound(tickUpper, tickLower + 1, TickMath.MAX_TICK));
        (tickLower, tickUpper) = adjustTickForAddLiquidity(tickLower, tickUpper);
        amount = uint128(bound(uint256(amount), 1000 * unit, 1_000_000 * unit));
        console2.log("user col balance %s", TestERC20(collateral).balanceOf(currentActor));
        AddLiqParams memory param = getAddLiquidityParams(bk, currentActor, tickLower, tickUpper, LiquidityType.COLLATERAL, amount, 300);
        uint256 tokenId = addLiquidity(currentActor, manager, param, quoter);
        // (uint256 tokenId,,) = IManager(manager).addLiquidity(param);
        ghost_seed_collateral += amount;
        _tokenIds.add(tokenId);
        ghost_nft_count++;
        calls["addLiq"] += 1;
        ghost_depth += 1;
    }

    function addLiq1(uint256 actorIndexSeed, int24 tickLower, int24 tickUpper, uint128 amount) public {
        addLiq(actorIndexSeed, tickLower, tickUpper, amount);
    }

    function addLiq2(uint256 actorIndexSeed, int24 tickLower, int24 tickUpper, uint128 amount) public {
        addLiq(actorIndexSeed, tickLower, tickUpper, amount);
    }

    function addLiq3(uint256 actorIndexSeed, int24 tickLower, int24 tickUpper, uint128 amount) public {
        addLiq(actorIndexSeed, tickLower, tickUpper, amount);
    }

    function addLiq4(uint256 actorIndexSeed, int24 tickLower, int24 tickUpper, uint128 amount) public {
        addLiq(actorIndexSeed, tickLower, tickUpper, amount);
    }

    function addLiqBySpear(uint256 actorIndexSeed, int24 tickLower, int24 tickUpper, uint128 amount) public notSettled {
        if (_spearUsers.length() == 0) {
            return;
        }
        // current tick
        (, int24 tick,) = IBattle(battle).slot0();
        if (tick < -45_914 || tick > 45_914) {
            return;
        }
        // bound tickLower and tickUpper
        tickUpper = int24(bound(tickUpper, TickMath.MIN_TICK + 1, tick - 1));
        tickLower = int24(bound(tickLower, TickMath.MIN_TICK, tickUpper - 1));
        (tickLower, tickUpper) = adjustTickForAddLiquiditySToken(tickLower, tickUpper, tick, LiquidityType.SPEAR);
        if (tickLower < TickMath.MIN_TICK || tickUpper > TickMath.MAX_TICK || tick == tickUpper) {
            return;
        }
        // bound amount
        currentActor = _spearUsers.at(bound(actorIndexSeed, 0, _spearUsers.length() - 1));
        vm.startPrank(currentActor);
        amount = uint128(IERC20(spear).balanceOf(currentActor));
        if (amount < 1 * unit) {
            return;
        }
        console2.log("addLiqBySpear", currentActor, amount);
        // compose params
        AddLiqParams memory param = getAddLiquidityParams(bk, currentActor, tickLower, tickUpper, LiquidityType.SPEAR, amount, 300);
        // call addLiquidity
        uint256 tokenId = addLiquidity(currentActor, manager, param, quoter);
        // (uint256 tokenId,,) = IManager(manager).addLiquidity(param);
        _tokenIds.add(tokenId);
        _spearUsers.remove(currentActor);
        ghost_nft_count++;
        calls["addLiqBySpear"] += 1;
        ghost_depth += 1;
        vm.stopPrank();
    }

    function addLiqByShield(uint256 actorIndexSeed, int24 tickLower, int24 tickUpper, uint128 amount) public notSettled {
        if (_shieldUsers.length() == 0) {
            return;
        }
        // current tick
        (, int24 tick,) = IBattle(battle).slot0();
        if (tick < -45_914 || tick > 45_914) {
            return;
        }
        // bound tickLower and tickUpper
        tickLower = int24(bound(tickLower, tick + 1, TickMath.MAX_TICK - 1));
        tickUpper = int24(bound(tickUpper, tickLower + 1, TickMath.MAX_TICK));
        // (tickLower, tickUpper) = adjustTickForAddLiquidity(tickLower, tickUpper);
        (tickLower, tickUpper) = adjustTickForAddLiquiditySToken(tickLower, tickUpper, tick, LiquidityType.SHIELD);
        if (tickLower < TickMath.MIN_TICK || tickUpper > TickMath.MAX_TICK || tick == tickLower) {
            return;
        }
        // bound amount
        currentActor = _shieldUsers.at(bound(actorIndexSeed, 0, _shieldUsers.length() - 1));
        vm.startPrank(currentActor);
        amount = uint128(IERC20(shield).balanceOf(currentActor));
        if (amount < 1 * unit) {
            return;
        }
        console2.log("addLiqByShield", currentActor, amount);
        // approve spear
        IERC20(shield).approve(manager, type(uint256).max);
        // compose params
        AddLiqParams memory param = getAddLiquidityParams(bk, currentActor, tickLower, tickUpper, LiquidityType.SHIELD, amount, 300);
        // call addLiquidity
        uint256 tokenId = addLiquidity(currentActor, manager, param, quoter);
        // (uint256 tokenId,,) = IManager(manager).addLiquidity(param);
        _tokenIds.add(tokenId);
        _shieldUsers.remove(currentActor);
        ghost_nft_count++;
        calls["addLiqByShield"] += 1;
        ghost_depth += 1;
        vm.stopPrank();
    }

    function removeLiq(uint256 tokenIdIndexSeed) public {
        if (_tokenIds.length() == 0) {
            return;
        }
        uint256 tokenId = _tokenIds.at(bound(tokenIdIndexSeed, 0, _tokenIds.length() - 1));
        currentActor = IERC721(manager).ownerOf(tokenId);
        vm.startPrank(currentActor);
        removeLiquidity(currentActor, manager, tokenId);
        if (tokenIdIndexSeed % 3 == 0 && !battleSettled) {
            // redeem obligation
            Position memory pm = IManager(manager).positions(tokenId);
            (uint256 diff, bool isSpear) = pm.spearObligation > pm.shieldObligation
                ? (pm.spearObligation - pm.shieldObligation, true)
                : (pm.shieldObligation - pm.spearObligation, false);
            uint256 sBalance = TestERC20(isSpear ? spear : shield).balanceOf(currentActor);
            TradeType tt = isSpear ? TradeType.BUY_SPEAR : TradeType.BUY_SHIELD;
            if (sBalance < diff && !shouldSkipTrade(tt)) {
                // need buy stoken
                TradeParams memory params =
                    getTradeParams(bk, isSpear ? TradeType.BUY_SPEAR : TradeType.BUY_SHIELD, -int256(diff), currentActor, 0, 0, 300);
                console2.log("current actor %s", currentActor);
                trade(currentActor, manager, params, quoter);
                sBalance = TestERC20(isSpear ? spear : shield).balanceOf(currentActor);
                // assertGe(sBalance, diff, "not enough stoken");
            }
            if (sBalance >= diff) {
                redeemObligation(currentActor, manager, tokenId);
                calls["redeemObli"] += 1;
                ghost_depth++;
            } else {
                // nothing to do
            }
        } else {
            calls["removeLiq"] += 1;
            _liquidityRemovedTokenIds.add(tokenId);
        }
        _tokenIds.remove(tokenId);
        ghost_depth++;
        vm.stopPrank();
    }

    uint256 public ghost_total_camount;
    uint256 public ghost_total_samount_spear;
    uint256 public ghost_total_samount_shield;

    function adjustAmount(int256 amount) internal view returns (int256) {
        if (amount < 0) {
            return bound(amount, -1e9 * int256(unit), -1);
        } else {
            return bound(amount, 1, 1e9 * int256(unit));
        }
    }

    function shouldSkipTrade(TradeType tt) internal returns (bool) {
        (uint160 p,,) = IBattle(battle).slot0();
        if (tt == TradeType.BUY_SPEAR) {
            if (p == TickMath.MIN_SQRT_RATIO + 1) {
                return true;
            } else {
                return false;
            }
        } else {
            if (p == TickMath.MAX_SQRT_RATIO - 1) {
                return true;
            } else {
                return false;
            }
        }
    }

    function buySpear(uint256 actorIndexSeed, int256 amount, int24 tickLower, int24 tickUpper, uint128 amountColLiqui) public notSettled {
        if (ghost_nft_count <= 5) {
            addLiq(actorIndexSeed, tickLower, tickUpper, amountColLiqui);
            return;
        }
        getActor(actorIndexSeed);
        console2.log("Action: Buy Spear");
        // (uint160 p,,) = IBattle(battle).slot0();
        // if (p == TickMath.MIN_SQRT_RATIO + 1) {
        //     return;
        // }
        if (shouldSkipTrade(TradeType.BUY_SPEAR)) {
            return;
        }
        amount = adjustAmount(amount);

        TradeParams memory param = getTradeParams(bk, TradeType.BUY_SPEAR, amount, currentActor, 0, 0, 300);
        (uint256 amountIn, uint256 amountOut, uint256 amountFee) = trade(currentActor, manager, param, quoter);
        ghost_tradeAmount += amountIn;
        ghost_collatealIn += amountIn;
        ghost_totalFee += amountFee;
        ghost_total_camount += amountIn;
        ghost_total_samount_spear += amountOut;
        uint256 balance = IERC20(spear).balanceOf(currentActor);
        if (balance > 0) {
            _spearUsers.add(currentActor);
        }
        calls["buySpear"] += 1;
        checkBalance();
        vm.stopPrank();
        ghost_depth += 1;
    }

    function buySpear1(uint256 actorIndexSeed, int256 amount, int24 tickLower, int24 tickUpper, uint128 amountColLiqui) public {
        buySpear(actorIndexSeed, amount, tickLower, tickUpper, amountColLiqui);
    }

    function buySpear2(uint256 actorIndexSeed, int256 amount, int24 tickLower, int24 tickUpper, uint128 amountColLiqui) public {
        buySpear(actorIndexSeed, amount, tickLower, tickUpper, amountColLiqui);
    }

    function buySpear3(uint256 actorIndexSeed, int256 amount, int24 tickLower, int24 tickUpper, uint128 amountColLiqui) public {
        buySpear(actorIndexSeed, amount, tickLower, tickUpper, amountColLiqui);
    }

    function buyShield(uint256 actorIndexSeed, int256 amount, int24 tickLower, int24 tickUpper, uint128 amountColLiqui) public notSettled {
        if (ghost_nft_count <= 5) {
            addLiq(actorIndexSeed, tickLower, tickUpper, amountColLiqui);
            return;
        }
        console2.log("Action: Buy Shield");
        getActor(actorIndexSeed);
        // (uint160 p,,) = IBattle(battle).slot0();
        // if (p == TickMath.MAX_SQRT_RATIO - 1) {
        //     return;
        // }
        if (shouldSkipTrade(TradeType.BUY_SHIELD)) {
            return;
        }
        amount = adjustAmount(amount);
        console2.log("user collateral balance: %s", TestERC20(collateral).balanceOf(currentActor));
        TradeParams memory param = getTradeParams(bk, TradeType.BUY_SHIELD, amount, currentActor, 0, 0, 300);
        (uint256 amountIn, uint256 amountOut, uint256 amountFee) = trade(currentActor, manager, param, quoter);
        ghost_tradeAmount += amountIn;
        ghost_collatealIn += amountIn;
        ghost_totalFee += amountFee;
        ghost_total_camount += amountIn;
        ghost_total_samount_shield += amountOut;
        uint256 balance = IERC20(shield).balanceOf(currentActor);
        if (balance > 0) {
            _shieldUsers.add(currentActor);
        }
        calls["buyShield"] += 1;
        checkBalance();
        vm.stopPrank();

        ghost_depth += 1;
    }

    function buyShield1(uint256 actorIndexSeed, int256 amount, int24 tickLower, int24 tickUpper, uint128 amountColLiqui) public {
        buyShield(actorIndexSeed, amount, tickLower, tickUpper, amountColLiqui);
    }

    function buyShield2(uint256 actorIndexSeed, int256 amount, int24 tickLower, int24 tickUpper, uint128 amountColLiqui) public {
        buyShield(actorIndexSeed, amount, tickLower, tickUpper, amountColLiqui);
    }

    function buyShield3(uint256 actorIndexSeed, int256 amount, int24 tickLower, int24 tickUpper, uint128 amountColLiqui) public {
        buyShield(actorIndexSeed, amount, tickLower, tickUpper, amountColLiqui);
    }

    function settleBattle(
        uint256 actorIndexSeed,
        int256 amount,
        int24 tickLower,
        int24 tickUpper,
        uint128 amountColLiqui,
        uint128 amountC
    )
        public
        notSettled
    {
        if (calls["addLiq"] < minAddLiqCount) {
            if (actorIndexSeed % 3 == 0) {
                addLiq(actorIndexSeed, tickLower, tickUpper, amountC);
            }
            return;
        }
        if (calls["buySpear"] < minBuySpearCount) {
            buySpear(actorIndexSeed, amount, tickLower, tickUpper, amountColLiqui);
            return;
        }
        if (calls["buyShield"] < minBuyShieldCount) {
            buyShield(actorIndexSeed, amount, tickLower, tickUpper, amountColLiqui);
            return;
        }
        if (battleSettled) {
            withdrawAndExercise();
            return;
        }

        currentActor = users[bound(actorIndexSeed, 0, users.length - 1)];
        vm.startPrank(currentActor);
        (, uint256 endTS) = IBattle(battle).startAndEndTS();
        vm.warp(endTS + 1);
        assert(oracle != address(0));
        if (actorIndexSeed % 2 == 0) {
            OracleForTest(oracle).setPrice("BTC", endTS, 30_000e18);
        } else {
            OracleForTest(oracle).setPrice("BTC", endTS, 10_000e18);
        }
        IBattle(battle).settle();
        battleSettled = true;
        calls["settleBattle"] += 1;
        vm.stopPrank();
    }

    function execriseSpear(uint256 userIdIndexSeed) public {
        if (!battleSettled) {
            return;
        }

        if (_spearUsers.length() == 0) {
            return;
        }

        address user = _spearUsers.at(bound(userIdIndexSeed, 0, _spearUsers.length() - 1));
        if (IERC20(spear).balanceOf(user) == 0) {
            return;
        }

        currentActor = user;
        vm.startPrank(currentActor);
        IBattle(battle).exercise();
        vm.stopPrank();
        _spearUsers.remove(user);
        calls["execriseSpear"] += 1;
        ghost_depth++;
    }

    function execriseShield(uint256 userIdIndexSeed) public {
        if (!battleSettled) {
            return;
        }

        if (_shieldUsers.length() == 0) {
            return;
        }

        address user = _shieldUsers.at(bound(userIdIndexSeed, 0, _shieldUsers.length() - 1));
        if (IERC20(shield).balanceOf(user) == 0) {
            return;
        }

        currentActor = user;
        vm.startPrank(currentActor);
        IBattle(battle).exercise();
        vm.stopPrank();
        _shieldUsers.remove(user);
        calls["execriseShield"] += 1;
        ghost_depth++;
    }

    function withdraw(uint256 tokenIdIndexSeed) public {
        if (_liquidityRemovedTokenIds.length() == 0) {
            return;
        }

        if (!battleSettled) {
            return;
        }

        uint256 tokenId = _liquidityRemovedTokenIds.at(bound(tokenIdIndexSeed, 0, _liquidityRemovedTokenIds.length() - 1));
        currentActor = IERC721(manager).ownerOf(tokenId);
        vm.startPrank(currentActor);
        IManager(manager).withdrawObligation(tokenId);
        vm.stopPrank();
        _liquidityRemovedTokenIds.remove(tokenId);
        calls["withdrawObligation"] += 1;
    }

    function exerciseAll() internal {
        if (!battleSettled) {
            return;
        }
        for (uint256 i; i < users.length; i++) {
            if (IERC20(spear).balanceOf(users[i]) != 0 || IERC20(shield).balanceOf(users[i]) != 0) {
                currentActor = users[i];
                vm.startPrank(currentActor);
                uint256 balance = IERC20(collateral).balanceOf(battle);
                console2.log("battle balance: ", balance);
                IBattle(battle).exercise();
                ghost_depth++;
                vm.stopPrank();
            }
        }
        calls["execriseAll"] += 1;
    }

    bytes[] public callData;

    function withdrawAll() internal {
        if (!battleSettled) {
            return;
        }
        // remove liquidity
        console2.log("tokenIds length: ", _tokenIds.length());

        // get all token and their state by multicall
        uint256 total = ERC721Enumerable(manager).totalSupply();
        // for (uint256 i; i < total; i++) {
        //     callData.push(abi.encodeWithSelector(IManager(manager).positions.selector,
        // i));
        // }
        // bytes[] memory results = Multicall(manager).multicall(callData);
        // delete callData;
        // for (uint256 i; i < results.length; i++) {
        for (uint256 i; i < total; i++) {
            Position memory p = IQuoter(quoter).positions(i);
            // (Position memory p) = abi.decode(results[i], (Position));
            if (p.state == PositionState.LiquidityAdded) {
                currentActor = IERC721(manager).ownerOf(i);
                vm.startPrank(currentActor);
                // remove liquidity
                // multicall
                bytes[] memory data = new bytes[](2);
                callData.push(abi.encodeWithSelector(IManager(manager).removeLiquidity.selector, i, currentActor));
                callData.push(abi.encodeWithSelector(IManager(manager).withdrawObligation.selector, i, currentActor));
                Multicall(manager).multicall(callData);
                delete callData;
                // single call
                // removeLiquidity(manager, i);
                // // withdraw obligation
                // IManager(manager).withdrawObligation(i);
                vm.stopPrank();
            } else if (p.state == PositionState.LiquidityRemoved) {
                // withdraw collateral
                currentActor = IERC721(manager).ownerOf(i);
                vm.startPrank(currentActor);
                IManager(manager).withdrawObligation(i);
                vm.stopPrank();
            }
            _tokenIds.remove(i);
            _liquidityRemovedTokenIds.remove(i);
        }
        calls["withdrawAll"] += 1;
    }

    bool public withdrawAndExerciseCalled = false;

    function withdrawAndExercise() public {
        if (!battleSettled) {
            return;
        }
        if (withdrawAndExerciseCalled) {
            return;
        }
        // remove liquidity
        // withdraw obligation
        withdrawAll();
        // exercise
        exerciseAll();
        withdrawAndExerciseCalled = true;
        ghost_run_end = true;
        calls["withdrawAndExerciseAll"] += 1;
    }

    function reedemObli() public { }

    function callSummary() public view {
        console2.log("Call summary:");
        console2.log("depth: %s", ghost_depth);
        console2.log("addLiq        :", calls["addLiq"]);
        console2.log("addLiqBySpear :", calls["addLiqBySpear"]);
        console2.log("addLiqByShield:", calls["addLiqByShield"]);
        console2.log("removeLiq     :", calls["removeLiq"]);
        console2.log("redeemObli    :", calls["redeemObli"]);
        console2.log("buySpear      :", calls["buySpear"]);
        console2.log("buyShield     :", calls["buyShield"]);
        console2.log("settleBattle", calls["settleBattle"]);
        // console2.log("withdrawObligation", calls["withdrawObligation"]);
        // console2.log("execriseSpear", calls["execriseSpear"]);
        // console2.log("execriseShield", calls["execriseShield"]);
        console2.log("execriseAll", calls["execriseAll"]);
        console2.log("withdrawAndExerciseAll", calls["withdrawAndExerciseAll"]);
        console2.log("ghost_seed_collateral   %s", ghost_seed_collateral);
        console2.log("ghost_tradeAmount:      %s", ghost_tradeAmount);
        console2.log("ghost_totalFee:         %s", ghost_totalFee);

    }

    function checkBalance() public view returns (uint256 spearAmount, uint256 shieldAmount, uint256 balanceAmount) {
        console2.log("total of spear:       ", spearAmount = IERC20(spear).totalSupply());
        console2.log("total of shield:      ", shieldAmount = IERC20(shield).totalSupply());
        console2.log("collateral of battle: ", balanceAmount = IERC20(collateral).balanceOf(battle));
    }
}
