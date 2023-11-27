// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import { ERC721Enumerable, ERC721 } from "@oz/token/ERC721/extensions/ERC721Enumerable.sol";
import { ERC20Burnable } from "@oz/token/ERC20/extensions/ERC20Burnable.sol";
import { Multicall } from "@oz/utils/Multicall.sol";
import { FullMath } from "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import { FixedPoint128 } from "@uniswap/v3-core/contracts/libraries/FixedPoint128.sol";
import { BattleInitializer } from "./base/BattleInitializer.sol";
import { LiquidityManagement } from "./base/LiquidityManagement.sol";
import { PeripheryImmutableState } from "./base/PeripheryImmutableState.sol";
import { IBattleActions } from "core/interfaces/battle/IBattleActions.sol";
import { BattleTradeParams, BattleBurnParams } from "core/params/coreParams.sol";
import { TradeType } from "core/types/enums.sol";
import { TickMath } from "core/libs/TickMath.sol";
import { Errors } from "core/errors/Errors.sol";
import { IArenaCreation } from "core/interfaces/IArena.sol";
import { IBattleState } from "core/interfaces/battle/IBattleState.sol";
import { IManagerState } from "./interfaces/IManagerState.sol";
import { IManager } from "./interfaces/IManager.sol";
import { IManagerLiquidity } from "./interfaces/IManagerActions.sol";
import { AddLiqParams, TradeParams } from "periphery/params/peripheryParams.sol";
import { PositionState, Position } from "./types/common.sol";
import { CallbackValidation } from "./libs/CallbackValidation.sol";
import { PositionInfo, BattleKey, GrowthX128, Owed, LiquidityType, Outcome } from "core/types/common.sol";

/// @title Manager
/// @notice Sets up the necessary state variables, mappings, and inheritance
/// to handle position NFTs, manage liquidity, and interact with the battle contracts

contract Manager is IManager, Multicall, ERC721Enumerable, PeripheryImmutableState, BattleInitializer, LiquidityManagement {
    uint256 public override nextId;
    mapping(uint256 => Position) private _positions;

    modifier isAuthorizedForToken(uint256 tokenId) {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not approved");
        _;
    }

    constructor(address _arena, address _weth) ERC721("Divergence Protocol Positions NFT", "DIVER-POS") PeripheryImmutableState(_arena, _weth) { }

    /// @notice Adds liquidity to a battle contract, mints a new token representing the liquidity position
    /// records the position information for later reference.
    /// @return tokenId The ID of the NFT that represents the liquidity position
    /// @return liquidity The amount of liquidity for this position
    function addLiquidity(AddLiqParams calldata params) external override returns (uint256 tokenId, uint128 liquidity) {
        if (block.timestamp > params.deadline) {
            revert Errors.Deadline();
        }
        address battleAddr;
        (liquidity, battleAddr) = _addLiquidity(params);
        tokenId = nextId;
        bytes32 pk = keccak256(abi.encodePacked(address(this), params.tickLower, params.tickUpper));
        _positions[tokenId] = Position({
            tokenId: tokenId,
            battleAddr: battleAddr,
            tickLower: params.tickLower,
            tickUpper: params.tickUpper,
            liquidity: liquidity,
            liquidityType: params.liquidityType,
            seed: params.amount,
            insideLast: IBattleState(battleAddr).positions(pk).insideLast,
            owed: Owed(0, 0, 0, 0),
            state: PositionState.LiquidityAdded,
            spearObligation: 0,
            shieldObligation: 0
        });
        nextId++;
        emit LiquidityAdded(battleAddr, params.recipient, tokenId, liquidity, params.liquidityType, params.amount);
        _safeMint(params.recipient, tokenId);
    }

    /// @notice Updates the growth of fees and token deltas as of the last action on the individual position
    function updateInsideLast(PositionInfo memory pb, Position storage pm) private {
        unchecked {
            pm.owed.fee += uint128(FullMath.mulDiv(pb.insideLast.fee - pm.insideLast.fee, pm.liquidity, FixedPoint128.Q128));
            pm.owed.collateralIn +=
                uint128(FullMath.mulDiv(pb.insideLast.collateralIn - pm.insideLast.collateralIn, pm.liquidity, FixedPoint128.Q128));
            pm.owed.spearOut += uint128(FullMath.mulDiv(pb.insideLast.spearOut - pm.insideLast.spearOut, pm.liquidity, FixedPoint128.Q128));
            pm.owed.shieldOut += uint128(FullMath.mulDiv(pb.insideLast.shieldOut - pm.insideLast.shieldOut, pm.liquidity, FixedPoint128.Q128));
            pm.insideLast = pb.insideLast;
        }
    }

    /// @notice Removes liquidity from the pool, given the tokenId of a position. Only to be called once by the liquidity provider.
    /// @param tokenId The ID of the NFT that represents the liquidity position
    /// @return collateral The amount of collateral to be received by the liqudity provider
    /// @return spear The amount of Spear to be received by the liquidity provider
    /// @return shield The amount of Shield to be received by the liquidity provider
    /// @return spearObligation The obligatory reserve of collateral amount for settling spear tokens sold by the position
    /// @return shieldObligation The obligatory reserve of collateral amount for settling shield tokens sold by the position
    function removeLiquidity(uint256 tokenId)
        external
        override
        isAuthorizedForToken(tokenId)
        returns (uint256 collateral, uint256 spear, uint256 shield, uint256 spearObligation, uint256 shieldObligation)
    {
        // pm => position in manager
        Position memory pmMemory = _positions[tokenId];
        if (pmMemory.state != PositionState.LiquidityAdded) {
            revert Errors.LiquidityNotAdded();
        }

        BattleBurnParams memory bp;
        bp.tickLower = pmMemory.tickLower;
        bp.tickUpper = pmMemory.tickUpper;
        bp.liquidityType = pmMemory.liquidityType;
        bp.liquidityAmount = pmMemory.liquidity;

        IBattleActions(pmMemory.battleAddr).burn(bp);

        // pb => position in battle
        PositionInfo memory pb =
            IBattleState(pmMemory.battleAddr).positions(keccak256(abi.encodePacked(address(this), pmMemory.tickLower, pmMemory.tickUpper)));

        Position storage pmStorage = _positions[tokenId];
        updateInsideLast(pb, pmStorage);
        (collateral, spear, shield, spearObligation, shieldObligation) = getObligation(pmStorage);
        collateral += pmStorage.owed.fee;
        pmStorage.state = PositionState.LiquidityRemoved;
        pmStorage.spearObligation = spearObligation;
        pmStorage.shieldObligation = shieldObligation;

        IBattleActions(pmMemory.battleAddr).collect(ownerOf(tokenId), collateral, spear, shield);

        emit LiquidityRemoved(tokenId, collateral, spear > shield ? spear : shield);
    }

    /// @notice Calculates the obligatory reserve of collateral amounts for settling sold spear and shield amounts
    /// The remaining collateral/spear/shield token amounts receivable for a given position.
    /// @param pm The position for which to calculate the obligation amounts and receivable token amounts
    /// @return collateral The amount of collateral that can be received by the liqudity provider
    /// @return spear The remaining spear amount that can be received by the liqudity provider, after adjusting for obligations
    /// @return shield The remaining shield amount that can be received by the liqudity provider, after adjusting for obligations
    /// @return spearObligation The obligatory reserve of collateral amount for settling spear tokens sold by the position
    /// @return shieldObligation The obligatory reserve of collateral amount for settling shield tokens sold by the position
    function getObligation(Position memory pm)
        private
        pure
        returns (uint256 collateral, uint256 spear, uint256 shield, uint256 spearObligation, uint256 shieldObligation)
    {
        if (pm.liquidityType == LiquidityType.COLLATERAL) {
            spearObligation = pm.owed.spearOut;
            shieldObligation = pm.owed.shieldOut;
            uint256 obligation = spearObligation > shieldObligation ? spearObligation : shieldObligation;
            // minus 1 to avoid rounding error, ensuring the reserved collateral is enough to pay the obligation
            collateral = pm.owed.collateralIn + pm.seed == obligation ? 0 : pm.owed.collateralIn + pm.seed - obligation - 1;
        } else if (pm.liquidityType == LiquidityType.SPEAR) {
            spearObligation = pm.owed.spearOut > pm.seed ? pm.owed.spearOut - pm.seed : 0;
            shieldObligation = pm.owed.shieldOut;
            uint256 obligation = spearObligation > shieldObligation ? spearObligation : shieldObligation;
            // minus 1 to avoid rounding error, ensuring the reserved collateral is enough to pay the obligation
            collateral = pm.owed.collateralIn == obligation ? 0 : pm.owed.collateralIn - obligation - 1;
            if (pm.seed > pm.owed.spearOut) {
                spear = pm.seed - pm.owed.spearOut;
            }
        } else {
            spearObligation = pm.owed.spearOut;
            shieldObligation = pm.owed.shieldOut > pm.seed ? pm.owed.shieldOut - pm.seed : 0;
            uint256 obligation = spearObligation > shieldObligation ? spearObligation : shieldObligation;
            // minus 1 to avoid rounding error, ensuring the reserved collateral is enough to pay the obligation
            collateral = pm.owed.collateralIn == obligation ? 0 : pm.owed.collateralIn - obligation - 1;
            if (pm.seed > pm.owed.shieldOut) {
                shield = pm.seed - pm.owed.shieldOut;
            }
        }
    }

    /// @notice Returns the amount of collateral reserved for options that settle out-of-money.
    /// Can be called once after expiry by the liquidity provider and must be called after liquidity has been removed.
    /// @param tokenId The ID of the NFT that represents the liquidity position
    function withdrawObligation(uint256 tokenId) external override isAuthorizedForToken(tokenId) {
        Position memory pm = _positions[tokenId];

        if (pm.state != PositionState.LiquidityRemoved) {
            revert Errors.LiquidityNotRemoved();
        }
        Outcome rr = IBattleState(pm.battleAddr).battleOutcome();
        bool isSpearLess = pm.spearObligation < pm.shieldObligation;
        uint256 toLp;
        if (rr == Outcome.ONGOING) {
            revert Errors.BattleNotEnd();
        } else if (rr == Outcome.SPEAR_WIN) {
            if (isSpearLess) {
                toLp = pm.shieldObligation - pm.spearObligation;
            }
        } else {
            if (!isSpearLess) {
                toLp = pm.spearObligation - pm.shieldObligation;
            }
        }
        if (toLp > 0) {
            IBattleActions(pm.battleAddr).withdrawObligation(ownerOf(tokenId), toLp);
        }
        _positions[tokenId].state = PositionState.ObligationWithdrawn;
        emit ObligationWithdrawn(pm.battleAddr, tokenId, toLp);
    }

    /// @notice Returns the amount of collateral reserved for the liquidity providers' open short interest.
    /// The LP gets one collateral for sending one spear or shield token back to the pool to close the net amount of short options exposure.
    /// Can be called once before expiry by the LP and must be called after liquidity has been removed.
    /// @param tokenId The ID of the NFT that represents the liquidity position
    function redeemObligation(uint256 tokenId) external override isAuthorizedForToken(tokenId) {
        Position memory pm = _positions[tokenId];
        if (pm.state != PositionState.LiquidityRemoved) {
            revert Errors.LiquidityNotRemoved();
        }
        Outcome rr = IBattleState(pm.battleAddr).battleOutcome();
        if (rr != Outcome.ONGOING) {
            revert Errors.BattleEnd();
        }
        if (pm.spearObligation != pm.shieldObligation) {
            (uint256 diff, address stoken) = pm.spearObligation > pm.shieldObligation
                ? (pm.spearObligation - pm.shieldObligation, IBattleState(pm.battleAddr).spear())
                : (pm.shieldObligation - pm.spearObligation, IBattleState(pm.battleAddr).shield());
            ERC20Burnable(stoken).burnFrom(msg.sender, diff);
            IBattleActions(pm.battleAddr).withdrawObligation(ownerOf(tokenId), diff);
            _positions[tokenId].state = PositionState.ObligationRedeemed;
            emit ObligationRedeemed(pm.battleAddr, tokenId, diff);
        }
    }

    /// @notice Calls the battle contract to execute a trade
    /// @return amountIn The collateral amount to be swapped in based on the direction of the swap
    /// @return amountOut The amount to be received, of either spear or shield token, based on the direction of the swap
    /// @return amountFee The amount of fee in collateral token to be spent for the trade
    function trade(TradeParams calldata p) external override returns (uint256 amountIn, uint256 amountOut, uint256 amountFee) {
        if (block.timestamp > p.deadline) {
            revert Errors.Deadline();
        }

        address battle = IArenaCreation(arena).getBattle(p.battleKey);
        if (battle == address(0)) {
            revert Errors.BattleNotExist();
        }

        BattleTradeParams memory tps;
        tps.recipient = p.recipient;
        tps.tradeType = p.tradeType;
        tps.amountSpecified = p.amountSpecified;
        tps.data = abi.encode(TradeCallbackData({battleKey: p.battleKey, payer: msg.sender}));
        if (p.sqrtPriceLimitX96 == 0) {
            if (p.tradeType == TradeType.BUY_SPEAR) {
                tps.sqrtPriceLimitX96 = TickMath.MIN_SQRT_RATIO + 1;
            } else {
                tps.sqrtPriceLimitX96 = TickMath.MAX_SQRT_RATIO - 1;
            }
        } else {
            tps.sqrtPriceLimitX96 = p.sqrtPriceLimitX96;
        }

        // call battle
        (amountIn, amountOut, amountFee) = IBattleActions(battle).trade(tps);
        if (amountOut < p.amountOutMin) {
            revert Errors.Slippage();
        }
        emit Traded(p.recipient, p.tradeType, amountIn, amountOut);
    }

    /// @notice Called to msg.sender after executing a swap via Manager.
    /// @param cAmount The amount of collateral transferred in the trade
    /// @param sAmount The amount of spear or shield transferred in the trade
    /// @param _data Data passed through by the caller
    function tradeCallback(uint256 cAmount, uint256 sAmount, bytes calldata _data) external override {
        TradeCallbackData memory data = abi.decode(_data, (TradeCallbackData));
        CallbackValidation.verifyCallback(arena, data.battleKey);
        pay(data.battleKey.collateral, data.payer, msg.sender, cAmount);
    }

    /// @notice Retrieves the position data for the given TokenId
    /// @param tokenId The ID of the NFT that represents the liquidity position
    function positions(uint256 tokenId) external view override returns (Position memory) {
        return _positions[tokenId];
    }
}
