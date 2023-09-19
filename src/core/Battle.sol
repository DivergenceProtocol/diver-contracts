// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { SafeERC20 } from "@oz/token/ERC20/utils/SafeERC20.sol";
import { IERC20 } from "@oz/token/ERC20/IERC20.sol";
import { IERC20Metadata } from "@oz/token/ERC20/extensions/IERC20Metadata.sol";
import { SafeCast } from "@oz/utils/math/SafeCast.sol";
import { FullMath } from "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import { TickBitmap } from "@uniswap/v3-core/contracts/libraries/TickBitmap.sol";
import { SqrtPriceMath } from "@uniswap/v3-core/contracts/libraries/SqrtPriceMath.sol";
import { FixedPoint128 } from "@uniswap/v3-core/contracts/libraries/FixedPoint128.sol";
import { Errors } from "./errors/Errors.sol";
import { IBattle } from "./interfaces/battle/IBattle.sol";
import { IOracle } from "./interfaces/IOracle.sol";
import { IBattleBase } from "./interfaces/battle/IBattleActions.sol";
import { IBattleState } from "./interfaces/battle/IBattleState.sol";
import { IBattleInit } from "./interfaces/battle/IBattleInit.sol";
import { IMintCallback } from "./interfaces/callback/IMintCallback.sol";
import { IBattleMintBurn } from "./interfaces/battle/IBattleActions.sol";
import { ISToken } from "./interfaces/ISToken.sol";
import { IOwner } from "./interfaces/IOwner.sol";
import { ITradeCallback } from "./interfaces/callback/ITradeCallback.sol";
import { IArenaState } from "./interfaces/IArena.sol";
import { TickMath } from "./libs/TickMath.sol";
import { Tick } from "./libs/Tick.sol";
import { UpdatePositionParams } from "./params/UpdatePositionParams.sol";
import { Position } from "./libs/Position.sol";
import { DiverSqrtPriceMath } from "./libs/DiverSqrtPriceMath.sol";
import { TradeMath } from "./libs/TradeMath.sol";
import { ModifyPositionParams } from "./params/ModifyPositionParams.sol";
import { BattleMintParams } from "./params/BattleMintParams.sol";
import { BattleBurnParams } from "./params/BattleBurnParams.sol";
import { BattleTradeParams } from "./params/BattleTradeParams.sol";
import { ComputeTradeStepParams } from "./params/ComputeTradeStepParams.sol";
import { DeploymentParams } from "./params/DeploymentParams.sol";
import { TradeCache, TradeState, StepComputations } from "./types/TradeTypes.sol";
import { LiquidityType, BattleKey, Outcome, GrowthX128, TickInfo, PositionInfo, Fee, TradeType } from "./types/common.sol";

import { console2 } from "@std/console2.sol";

/// @title Battle
contract Battle is IBattle {
    using Tick for mapping(int24 => TickInfo);
    using TickBitmap for mapping(int16 => uint256);
    using Position for mapping(bytes32 => PositionInfo);
    using Position for PositionInfo;
    using SafeERC20 for IERC20;
    using SafeCast for uint256;
    using SafeCast for int256;

    struct Slot0 {
        uint160 sqrtPriceX96;
        int24 tick;
        bool unlocked;
    }

    address public override manager;
    address public arena;
    address public oracle;
    address public override spear;
    address public override shield;
    address public cOracle;

    uint256 public unit;
    uint256 public startTS;
    uint128 public liquidity;
    uint128 public maxLiquidityPerTick;
    uint128 public protocolFeeAmount;

    Fee public override fee;

    BattleKey private _bk;
    GrowthX128 public global;
    Slot0 public override slot0;
    Outcome public override battleOutcome;

    mapping(int24 => TickInfo) public ticks;
    mapping(int16 => uint256) public tickBitmap;
    mapping(bytes32 => PositionInfo) private _positions;

    // just for testing
    uint160[] public sqrtStarts;
    uint160[] public sqrtEnds;
    uint128[] public liquidities;

    function getProcess() external view returns (uint160[] memory, uint160[] memory, uint128[] memory) {
        return (sqrtStarts, sqrtEnds, liquidities);
    }

    modifier lock() {
        if (!slot0.unlocked) {
            revert Errors.Locked();
        }
        slot0.unlocked = false;
        _;
        slot0.unlocked = true;
    }

    modifier onlyManager() {
        if (msg.sender != manager) {
            revert Errors.CallerNotManager();
        }
        _;
    }

    /// @notice init storage state variable, only be caled once
    function init(DeploymentParams memory params) external override {
        if (_bk.expiries != 0) {
            revert Errors.InitTwice();
        }
        if (slot0.sqrtPriceX96 != 0) {
            revert Errors.InitTwice();
        }
        _bk = params.battleKey;
        unit = 10 ** IERC20Metadata(_bk.collateral).decimals();
        oracle = params.oracleAddr;
        cOracle = params.cOracleAddr;
        startTS = block.timestamp;
        fee = params.fee;
        spear = params.spear;
        shield = params.shield;
        manager = params.manager;
        arena = address(msg.sender);
        slot0 = Slot0({ sqrtPriceX96: params.sqrtPriceX96, tick: TickMath.getTickAtSqrtRatio(params.sqrtPriceX96), unlocked: true });
        maxLiquidityPerTick = Tick.tickSpacingToMaxLiquidityPerTick(30);
    }

    function _updatePosition(UpdatePositionParams memory params) internal returns (PositionInfo storage position) {
        position = _positions.get(msg.sender, params.mpParams.tickLower, params.mpParams.tickUpper);
        GrowthX128 memory _global = global;

        bool flippedLower;
        bool flippedUpper;
        if (params.mpParams.liquidityDelta != 0) {
            flippedLower = ticks.update(params.mpParams.tickLower, params.tick, params.mpParams.liquidityDelta, _global, maxLiquidityPerTick, false);

            flippedUpper = ticks.update(params.mpParams.tickUpper, params.tick, params.mpParams.liquidityDelta, _global, maxLiquidityPerTick, true);

            if (flippedLower) {
                tickBitmap.flipTick(params.mpParams.tickLower, 30);
            }
            if (flippedUpper) {
                tickBitmap.flipTick(params.mpParams.tickUpper, 30);
            }
        }
        GrowthX128 memory insideLast = ticks.getGrowthInside(params.mpParams.tickLower, params.mpParams.tickUpper, params.tick, _global);
        position.update(params.mpParams.liquidityDelta, insideLast);
        if (params.mpParams.liquidityDelta < 0) {
            if (flippedLower) {
                ticks.clear(params.mpParams.tickLower);
            }
            if (flippedUpper) {
                ticks.clear(params.mpParams.tickUpper);
            }
        }
    }

    function checkTicks(int24 tickLower, int24 tickUpper) private pure {
        if (tickLower >= tickUpper) revert Errors.TickInvalid();
        if (tickLower < TickMath.MIN_TICK) revert Errors.TickInvalid();
        if (tickUpper > TickMath.MAX_TICK) revert Errors.TickInvalid();
    }

    function _modifyPosition(ModifyPositionParams memory params) internal returns (PositionInfo storage position) {
        checkTicks(params.tickLower, params.tickUpper);
        position = _updatePosition(UpdatePositionParams(params, slot0.tick));
        if (params.liquidityDelta > 0) {
            if (slot0.tick >= params.tickLower && slot0.tick < params.tickUpper) {
                liquidity += uint128(params.liquidityDelta);
            }
        } else if (params.liquidityDelta < 0) {
            if (slot0.tick >= params.tickLower && slot0.tick < params.tickUpper) {
                liquidity -= uint128(-params.liquidityDelta);
            }
        }
    }

    /// @inheritdoc IBattleMintBurn
    function mint(BattleMintParams memory params) external override lock onlyManager {
        if (block.timestamp >= _bk.expiries) {
            revert Errors.BattleEnd();
        }

        if (params.liquidityType == LiquidityType.SPEAR && !(slot0.tick > params.tickUpper)) {
            revert Errors.TickInvalid();
        }

        if (params.liquidityType == LiquidityType.SHIELD && !(slot0.tick < params.tickLower)) {
            revert Errors.TickInvalid();
        }
        if (params.amount == 0) {
            revert Errors.ZeroAmount();
        }

        PositionInfo storage positionInfo;
        positionInfo = _modifyPosition(
            ModifyPositionParams({
                tickLower: params.tickLower,
                tickUpper: params.tickUpper,
                liquidityType: params.liquidityType,
                liquidityDelta: int128(params.amount)
            })
        );

        if (params.liquidityType == LiquidityType.COLLATERAL) {
            uint256 balanceBefore = IERC20(_bk.collateral).balanceOf(address(this));
            IMintCallback(msg.sender).mintCallback(params.seed, params.data);
            if (IERC20(_bk.collateral).balanceOf(address(this)) < balanceBefore + params.seed) {
                revert Errors.InsufficientCollateral();
            }
        } else if (params.liquidityType == LiquidityType.SPEAR) {
            uint256 balanceBefore = IERC20(spear).balanceOf(address(this));
            IMintCallback(msg.sender).mintCallback(params.seed, params.data);
            if (IERC20(spear).balanceOf(address(this)) < balanceBefore + params.seed) {
                revert Errors.InsufficientSpear();
            }
            ISToken(spear).burn(address(this), params.seed);
        } else {
            uint256 balanceBefore = IERC20(shield).balanceOf(address(this));
            IMintCallback(msg.sender).mintCallback(params.seed, params.data);
            if (IERC20(shield).balanceOf(address(this)) < balanceBefore + params.seed) {
                revert Errors.InsufficientShield();
            }
            ISToken(shield).burn(address(this), params.seed);
        }

        emit Minted(msg.sender, params.liquidityType, params.tickLower, params.tickUpper, params.amount, params.seed);
    }

    /// @inheritdoc IBattleMintBurn
    function burn(BattleBurnParams memory params) external override lock onlyManager {
        if (params.tickLower >= params.tickUpper) {
            revert Errors.TickOrderInvalid();
        }
        _modifyPosition(
            ModifyPositionParams({
                tickLower: params.tickLower,
                tickUpper: params.tickUpper,
                liquidityType: params.liquidityType,
                liquidityDelta: -int128(params.liquidityAmount)
            })
        );
        emit Burned(params.tickLower, params.tickUpper, params.liquidityType, params.liquidityAmount);
    }

    /// comments see IBattleTrade
    function collect(address recipient, uint256 cAmount, uint256 spAmount, uint256 shAmount) external override onlyManager {
        if (cAmount > 0) {
            IERC20(_bk.collateral).safeTransfer(recipient, cAmount);
        }
        if (spAmount > 0) {
            ISToken(spear).mint(recipient, spAmount);
        }
        if (shAmount > 0) {
            ISToken(shield).mint(recipient, shAmount);
        }
    }


    function trade(BattleTradeParams memory params) external returns (uint256 cAmount, uint256 sAmount, uint256 fAmount) {
        uint256 index;
        if (block.timestamp >= _bk.expiries) {
            revert Errors.BattleEnd();
        }
        // manager or quoter need call this function
        // if (msg.sender != s.manager) {
        //     revert Errors.CallerNotManager();
        // }
        if (params.amountSpecified == 0) {
            revert Errors.ZeroAmount();
        }

        Slot0 memory slot0Start = slot0;

        if (!slot0Start.unlocked) {
            revert Errors.Locked();
        }

        bool isPriceDown = params.tradeType == TradeType.BUY_SPEAR;
        bool exactIn = params.amountSpecified > 0;
        require(
            isPriceDown
                ? params.sqrtPriceLimitX96 < slot0Start.sqrtPriceX96 && params.sqrtPriceLimitX96 > TickMath.MIN_SQRT_RATIO
                : params.sqrtPriceLimitX96 > slot0Start.sqrtPriceX96 && params.sqrtPriceLimitX96 < TickMath.MAX_SQRT_RATIO,
            "PriceInvalid"
        );
        slot0.unlocked = false;

        TradeCache memory cache = TradeCache({ feeProtocol: fee.protocolFee });
        TradeState memory state = TradeState({
            amountSpecifiedRemaining: params.amountSpecified,
            amountCalculated: 0,
            sqrtPriceX96: slot0Start.sqrtPriceX96,
            tick: slot0Start.tick,
            global: global,
            protocolFee: 0,
            liquidity: liquidity,
            transactionFee: 0
        });
        while (state.amountSpecifiedRemaining != 0 && state.sqrtPriceX96 != params.sqrtPriceLimitX96) {
            console2.log("index: %s", index++);
            console2.log("remain: %s", state.amountSpecifiedRemaining);
            // if (index >= 100) {
            //     revert("escape loop");
            // }
            StepComputations memory step;
            step.sqrtPriceStartX96 = state.sqrtPriceX96;

            (step.tickNext, step.initialized) = tickBitmap.nextInitializedTickWithinOneWord(state.tick, 30, isPriceDown);
            console2.log("next tick: %s", step.tickNext);
            if (step.tickNext < TickMath.MIN_TICK) {
                step.tickNext = TickMath.MIN_TICK;
            }
            if (step.tickNext > TickMath.MAX_TICK) {
                step.tickNext = TickMath.MAX_TICK;
            }
            sqrtStarts.push(state.sqrtPriceX96);
            liquidities.push(state.liquidity);
            step.sqrtPriceNextX96 = TickMath.getSqrtRatioAtTick(step.tickNext);
            (state.sqrtPriceX96, step.amountIn, step.amountOut) = TradeMath.computeTradeStep(
                ComputeTradeStepParams({
                    tradeType: params.tradeType,
                    sqrtRatioCurrentX96: state.sqrtPriceX96,
                    sqrtRatioTargetX96: (
                        isPriceDown ? step.sqrtPriceNextX96 < params.sqrtPriceLimitX96 : step.sqrtPriceNextX96 > params.sqrtPriceLimitX96
                        ) ? params.sqrtPriceLimitX96 : step.sqrtPriceNextX96,
                    liquidity: state.liquidity,
                    amountRemaining: state.amountSpecifiedRemaining,
                    unit: unit
                })
            );
            sqrtEnds.push(state.sqrtPriceX96);
            console2.log("step.amountIn  %s", step.amountIn);
            console2.log("step.amountOut %s", step.amountOut);
            if (exactIn) {
                state.amountSpecifiedRemaining -= (step.amountIn).toInt256();
                state.amountCalculated += (step.amountOut).toInt256();
            } else {
                state.amountSpecifiedRemaining += (step.amountOut).toInt256();
                state.amountCalculated += (step.amountIn).toInt256();
            }

            step.feeAmount = FullMath.mulDiv(step.amountOut, fee.transactionFee, 1e6);
            if (cache.feeProtocol > 0) {
                uint256 delta = FullMath.mulDiv(step.feeAmount, cache.feeProtocol, 1e6);
                step.feeAmount -= delta;
                state.protocolFee += uint128(delta);
            }

            if (state.liquidity > 0) {
                unchecked {
                    state.global.fee += FullMath.mulDiv(step.feeAmount, FixedPoint128.Q128, state.liquidity);
                    state.transactionFee += step.feeAmount;
                    state.global.collateralIn += FullMath.mulDiv(step.amountIn, FixedPoint128.Q128, state.liquidity);

                    if (params.tradeType == TradeType.BUY_SPEAR) {
                        // buy spear => spearBought and shieldBankOut need be
                        // considered
                        // spear bought
                        state.global.spearOut += FullMath.mulDiv(step.amountOut, FixedPoint128.Q128, state.liquidity);
                    } else {
                        // buy shield => shieldBought and spearBankOut need be
                        // considered
                        state.global.shieldOut += FullMath.mulDiv(step.amountOut, FixedPoint128.Q128, state.liquidity);
                    }
                }
            }

            if (state.sqrtPriceX96 == step.sqrtPriceNextX96) {
                if (step.initialized) {
                    int128 liquidityNet = ticks.cross(step.tickNext, state.global);
                    if (isPriceDown) {
                        liquidityNet = -liquidityNet;
                    }
                    console2.log("liquidityNet %s   ", liquidityNet);
                    console2.log("state.liquidity %s", state.liquidity);
                    state.liquidity = liquidityNet < 0 ? state.liquidity - uint128(-liquidityNet) : state.liquidity + uint128(liquidityNet);
                }
                state.tick = isPriceDown ? step.tickNext - 1 : step.tickNext;
            } else if (state.sqrtPriceX96 != step.sqrtPriceStartX96) {
                state.tick = TickMath.getTickAtSqrtRatio(state.sqrtPriceX96);
            }
        }

        if (state.tick != slot0Start.tick) {
            (slot0.sqrtPriceX96, slot0.tick) = (state.sqrtPriceX96, state.tick);
        } else {
            slot0.sqrtPriceX96 = state.sqrtPriceX96;
        }
        liquidity = state.liquidity;
        global = state.global;
        if (exactIn) {
            cAmount = uint256(params.amountSpecified) - uint256(state.amountSpecifiedRemaining) + state.transactionFee + state.protocolFee;
            sAmount = uint256(state.amountCalculated);
        } else {
            cAmount = uint256(state.amountCalculated) + state.transactionFee + state.protocolFee;
            sAmount = uint256(-(params.amountSpecified - state.amountSpecifiedRemaining));
        }
        if (state.protocolFee > 0) {
            protocolFeeAmount += state.protocolFee;
        }
        fAmount = state.transactionFee + state.protocolFee;

        uint256 colBalanceBefore = collateralBalance();
        ITradeCallback(msg.sender).tradeCallback(cAmount, sAmount, params.data);
        if (colBalanceBefore + cAmount > collateralBalance()) {
            revert Errors.InsufficientCollateral();
        }

        if (params.tradeType == TradeType.BUY_SPEAR) {
            // mint spear to user
            ISToken(spear).mint(params.recipient, sAmount);
        } else {
            // mint shield to user
            ISToken(shield).mint(params.recipient, sAmount);
        }
        console2.log("cAmount %s.%s", cAmount / unit, cAmount % unit);
        console2.log("sAmount %s.%s", sAmount / unit, sAmount % unit);
        emit Traded(params.recipient, state.liquidity, cAmount, sAmount, params.tradeType, state.sqrtPriceX96, state.tick);
        slot0.unlocked = true;
    }

    /// @inheritdoc IBattleBase
    function settle() external override {
        if (block.timestamp < _bk.expiries) {
            revert Errors.BattleNotEnd();
        }
        if (battleOutcome != Outcome.ONGOING) {
            revert Errors.BattleSettled();
        }
        (uint256 price,) = IOracle(oracle).getPriceByExternal(cOracle, _bk.expiries);
        if (price == 0) {
            revert Errors.OraclePriceError();
        }
        if (price >= _bk.strikeValue) {
            battleOutcome = Outcome.SPEAR_WIN;
        } else {
            battleOutcome = Outcome.SHIELD_WIN;
        }
        emit Settled(msg.sender, battleOutcome);
    }

    /// @inheritdoc IBattleBase
    function exercise() external override lock {
        if (battleOutcome == Outcome.ONGOING) {
            revert Errors.BattleNotEnd();
        }
        uint256 amount;
        bool wasSpearWon = battleOutcome == Outcome.SPEAR_WIN;
        if (wasSpearWon) {
            amount = IERC20(spear).balanceOf(msg.sender);
        } else {
            amount = IERC20(shield).balanceOf(msg.sender);
        }
        if (amount > 0) {
            if (wasSpearWon) {
                ISToken(spear).burn(msg.sender, amount);
            } else {
                ISToken(shield).burn(msg.sender, amount);
            }
            uint256 exerciseFeeAmount = FullMath.mulDiv(amount, fee.exerciseFee, 1e6);
            if (exerciseFeeAmount > 0) {
                amount -= exerciseFeeAmount;
                protocolFeeAmount += uint128(exerciseFeeAmount);
            }
            IERC20(_bk.collateral).safeTransfer(msg.sender, amount);
            emit Exercised(msg.sender, wasSpearWon, amount);
        }
    }

    /// @inheritdoc IBattleBase
    function withdrawObligation(address recipient, uint256 amount) external override onlyManager lock {
        IERC20(_bk.collateral).safeTransfer(recipient, amount);
        emit ObligationWithdrawed(recipient, amount);
    }

    /// comments see IBattleTrade
    function collectProtocolFee(address recipient) external override lock {
        require(IOwner(arena).owner() == msg.sender, "only owner");
        uint256 _fee = protocolFeeAmount;
        protocolFeeAmount = 0;
        IERC20(_bk.collateral).safeTransfer(recipient, _fee);
        emit ProtocolFeeCollected(recipient, _fee);
    }

    function collateralBalance() private view returns (uint256) {
        return IERC20(_bk.collateral).balanceOf(address(this));
    }

    function positions(bytes32 positionKeyB32) external view override returns (PositionInfo memory info) {
        info = _positions[positionKeyB32];
    }

    function battleKey() external view override returns (BattleKey memory) {
        return _bk;
    }

    function startAndEndTS() external view override returns (uint256, uint256) {
        return (startTS, _bk.expiries);
    }

    function spearBalanceOf(address account) external view override returns (uint256 amount) {
        amount = IERC20(spear).balanceOf(account);
    }

    function shieldBalanceOf(address account) external view override returns (uint256 amount) {
        amount = IERC20(shield).balanceOf(account);
    }

    function spearAndShield() external view override returns (address, address) {
        return (spear, shield);
    }

    function getInsideLast(int24 tickLower, int24 tickUpper) external view override returns (GrowthX128 memory) {
        return ticks.getGrowthInside(tickLower, tickUpper, slot0.tick, global);
    }
}
