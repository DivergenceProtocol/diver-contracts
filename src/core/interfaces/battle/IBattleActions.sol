// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { BattleMintParams, BattleBurnParams, BattleTradeParams } from "core/params/coreParams.sol";
import { PositionInfo, TradeType, Outcome, LiquidityType } from "core/types/common.sol";

interface IBattleMintBurn {
    /// @param sender The address used for minting liquidity
    /// @param liquidityType The type of token used as liquidity
    /// @param tickLower The lower tick of the position
    /// @param tickUpper The upper tick of the position
    /// @param liquidity The amount of liquidity minted
    /// @param seedAmount The amount of tokens used for minting liquidity, per collateral, spear or shield liquidityType
    event Minted(address indexed sender, LiquidityType liquidityType, int24 tickLower, int24 tickUpper, uint128 liquidity, uint256 seedAmount);

    /// @param tickLower The lower tick of the position
    /// @param tickUpper The upper tick of the position
    /// @param liquidityType The type of token used as liquidity
    /// @param liquidityAmount The amount of liquidity burned
    event Burned(int24 tickLower, int24 tickUpper, LiquidityType liquidityType, uint128 liquidityAmount);

    /// @notice Mint liquidity
    /// @param mp The params for minting liquidity
    function mint(BattleMintParams memory mp) external;

    /// @notice Burn liquidity
    /// @param BurnParams The params for burning liquidity
    function burn(BattleBurnParams memory BurnParams) external;

    /// @notice Transfers collateral/spear/shield tokens to the liquidity provider. Only called by the manager contract
    /// @param recipient The address who receive collateral/spear/shield tokens
    /// @param cAmount The amount of collateral to be transfered
    /// @param spAmount The amount of spear to be transfered
    /// @param shAmount The amount of shield to be transfered
    function collect(address recipient, uint256 cAmount, uint256 spAmount, uint256 shAmount) external;
}

/// @title IBattleTrade
interface IBattleTrade {
    /// @notice Swap collateral for spear or shield tokens
    /// @param recipient The address who receive spear or shield tokens
    /// @param liquidity liquity in battle after trade
    /// @param amountIn The amount of token input
    /// @param amountOut The amount of token output
    /// @param tradeType BUY_SPEAR or BUY_SHIELD
    /// @param sqrtPriceX96 The sqrt price of the battle after the trade
    /// @param tick The tick of the battle after the trade
    event Traded(
        address indexed recipient, uint128 liquidity, uint256 amountIn, uint256 amountOut, TradeType tradeType, uint160 sqrtPriceX96, int24 tick
    );

    /// @notice Swap collateral for spear or shield tokens
    /// @param tp The params for the trade
    /// @return cAmount The amount of collateral paid by the trader
    /// @return sAmount The amount of spear or shield tokens received by the trader
    function trade(BattleTradeParams memory tp) external returns (uint256 cAmount, uint256 sAmount, uint256 fAmount);
}

interface IBattleBase {
    event ObligationWithdrawed(address recipient, uint256 amount);

    event InternalInitialized(address indexed battleInternal, int24 tick, uint160 sqrtPriceX96, uint256 startTS, uint256 endTS);

    event Settled(address indexed sender, Outcome battleResult, uint256 ts, uint256 price);

    event Exercised(address indexed sender, bool spearWin, uint256 amount);

    event ProtocolFeeCollected(address recipient, uint256 amount);

    /// @notice Settles the battle and determines the outcome.
    /// The Battle contract will fetch the price of underlying asset, and determines the outcome.
    /// Once settled, a pool's address is not reused for new battles
    function settle() external;

    /// @notice After settlement, an in-the-money spear or shield token is exercised for one collateral.
    /// eg. Alice bought 100 spear. If the outcome is spear_win, she can
    /// claim 100 collateral minus an exercise fee by calling this function.
    function exercise() external;

    /// @notice Enables the liquidity provider to withdraw the collateral amount reserved for settlement. Only called by the manager contract.
    /// @param recipient The liquidity provider address to receive collateral
    /// @param amount the amount of collateral to be received
    function withdrawObligation(address recipient, uint256 amount) external;

    /// @notice Allows the accumulated protocol fee to be collected. Can only be called by the owner.
    function collectProtocolFee(address recipient) external;
}

interface IBattleActions is IBattleMintBurn, IBattleTrade, IBattleBase { }
