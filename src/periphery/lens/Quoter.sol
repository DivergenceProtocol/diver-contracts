// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import { SafeCast } from "@oz/utils/math/SafeCast.sol";
import { Multicall } from "@oz/utils/Multicall.sol";
import { IERC721Enumerable } from "@oz/token/ERC721/extensions/IERC721Enumerable.sol";
import { FullMath } from "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import { FixedPoint128 } from "@uniswap/v3-core/contracts/libraries/FixedPoint128.sol";
import { ITradeCallback } from "../../core/interfaces/callback/ITradeCallback.sol";
import { IBattleActions } from "../../core/interfaces/battle/IBattleActions.sol";
import { IBattleState } from "../../core/interfaces/battle/IBattleState.sol";
import { TickMath } from "../../core/libs/TickMath.sol";
import { TradeType } from "../../core/types/common.sol";
import { BattleTradeParams } from "../../core/params/BattleTradeParams.sol";
import { IArenaCreation } from "../../core/interfaces/IArena.sol";
import { Errors } from "../../core/errors/Errors.sol";
import { AddLiqParams } from "../params/Params.sol";
import { LiquidityType } from "../../core/types/enums.sol";
import { DiverLiquidityAmounts } from "../libs/DiverLiquidityAmounts.sol";
import { DiverSqrtPriceMath } from "../../core/libs/DiverSqrtPriceMath.sol";
import { IQuoter, Position, PositionState } from "../interfaces/IQuoter.sol";
import {IManagerState} from "../interfaces/IManagerState.sol";
import { PositionInfo, BattleKey, GrowthX128, Owed, LiquidityType, Outcome } from "../../core/types/common.sol";

contract Quoter is Multicall, ITradeCallback, IQuoter {
    using SafeCast for int256;
    using SafeCast for uint256;

    address public arena;
    address public manager;

    constructor(address _arena, address _manager) {
        arena = _arena;
        manager = _manager;
    }

    function tradeCallback(uint256 cAmount, uint256 sAmount, bytes calldata data) external pure override {
        uint256 spend = cAmount;
        uint256 get = sAmount;
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, spend)
            mstore(add(ptr, 0x20), get)
            revert(ptr, 64)
        }
    }

    function parseRevertReason(bytes memory reason) private pure returns (uint256, uint256) {
        if (reason.length != 64) {
            if (reason.length < 68) {
                revert("what");
            }
            assembly {
                reason := add(reason, 0x04)
            }
            revert(abi.decode(reason, (string)));
        }
        return abi.decode(reason, (uint256, uint256));
    }

    function quoteExactInput(BattleTradeParams memory params, address battleAddr) public override returns (uint256 spend, uint256 get) {
        (uint160 p,,) = IBattleState(battleAddr).slot0();
        if (params.tradeType == TradeType.BUY_SPEAR && p == TickMath.MIN_SQRT_RATIO + 1) {
            return (0, 0);
        }
        if (params.tradeType == TradeType.BUY_SHIELD && p == TickMath.MAX_SQRT_RATIO - 1) {
            return (0, 0);
        }
        params.recipient = address(this);
        if (params.sqrtPriceLimitX96 == 0) {
            if (params.tradeType == TradeType.BUY_SPEAR) {
                params.sqrtPriceLimitX96 = TickMath.MIN_SQRT_RATIO + 1;
            } else {
                params.sqrtPriceLimitX96 = TickMath.MAX_SQRT_RATIO - 1;
            }
        }
        try IBattleActions(battleAddr).trade(params) { }
        catch (bytes memory reason) {
            (spend, get) = parseRevertReason(reason);
        }
    }

    function getSTokenByLiquidity(AddLiqParams calldata params) external view returns (uint256) {
        address battleAddr = IArenaCreation(arena).getBattle(params.battleKey);
        if (battleAddr == address(0)) {
            revert Errors.BattleNotExist();
        }
        (uint160 sqrtPriceX96,,) = IBattleState(battleAddr).slot0();
        if (params.liquidityType == LiquidityType.COLLATERAL) {
            return getSTokenByLiquidityWhenCreate(sqrtPriceX96, params.tickLower, params.tickUpper, params.amount);
        } else {
            revert("error type");
        }
    }

    function getSTokenByLiquidityWhenCreate(uint160 sqrtPriceX96, int24 tickLower, int24 tickUpper, uint256 amount) public pure returns (uint256) {
        uint160 priceLower = TickMath.getSqrtRatioAtTick(tickLower);
        uint160 priceUpper = TickMath.getSqrtRatioAtTick(tickUpper);
        uint128 liquidityAmount = DiverLiquidityAmounts.getLiquidityFromCs(sqrtPriceX96, priceLower, priceUpper, amount);
        return DiverSqrtPriceMath.getSTokenDelta(priceLower, priceUpper, liquidityAmount, false);
    }

    function positions(uint256 tokenId) external view override returns (Position memory) {
        return handlePosition(tokenId);
    }

    function handlePosition(uint256 tokenId) private view returns (Position memory p) {
        p = IManagerState(manager).positions(tokenId);
        // p = _positions[tokenId];
        if (p.state == PositionState.LiquidityAdded) {
            unchecked {
                GrowthX128 memory insideLast = IBattleState(p.battleAddr).getInsideLast(p.tickLower, p.tickUpper);
                p.owed.fee += uint128(FullMath.mulDiv(insideLast.fee - p.insideLast.fee, p.liquidity, FixedPoint128.Q128));
                p.owed.collateralIn += uint128(FullMath.mulDiv(insideLast.collateralIn - p.insideLast.collateralIn, p.liquidity, FixedPoint128.Q128));
                p.owed.spearOut += uint128(FullMath.mulDiv(insideLast.spearOut - p.insideLast.spearOut, p.liquidity, FixedPoint128.Q128));
                p.owed.shieldOut += uint128(FullMath.mulDiv(insideLast.shieldOut - p.insideLast.shieldOut, p.liquidity, FixedPoint128.Q128));
                p.insideLast = insideLast;
            }
        }
    }

    function accountPositions(address account) external view override returns (Position[] memory) {
        uint256 balance = IERC721Enumerable(manager).balanceOf(account);
        Position[] memory p = new Position[](balance);
        for (uint256 i = 0; i < balance; i++) {
            p[i] = handlePosition(IERC721Enumerable(manager).tokenOfOwnerByIndex(account, i));
        }
        return p;
    }
}
