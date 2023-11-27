// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Owed, LiquidityType, TradeType } from "core/types/common.sol";
import { ITradeCallback } from "core/interfaces/callback/ITradeCallback.sol";
import { AddLiqParams, TradeParams } from "periphery/params/peripheryParams.sol";

interface IManagerLiquidity {
    /// @notice Emitted when liquidity is added
    /// @param battleAddress The address of the battle
    /// @param owner The owner of the position and nft
    /// @param tokenId The id of the nft
    /// @param liquidity The amount of liquidity added to nft
    /// @param liquidityType Specifies the type of liquidity seeded to the position is collateral, spear, or shield
    /// @param seedAmount The token amount provided for the position, of the collateral, spear or shield liquidity type
    event LiquidityAdded(
        address indexed battleAddress, address indexed owner, uint256 tokenId, uint128 liquidity, LiquidityType liquidityType, uint256 seedAmount
    );

    /// @notice Emitted when liquidity is removed
    /// @param tokenId The id of the nft
    /// @param collateralAmount The amount of collateral that lp got
    /// @param stokenAmount The amount of spear/shield that lp got
    event LiquidityRemoved(uint256 tokenId, uint256 collateralAmount, uint256 stokenAmount);

    event ObligationWithdrawn(address battle, uint256 tokenId, uint256 amount);

    event ObligationRedeemed(address battle, uint256 tokenId, uint256 amount);

    /// @notice Adds liquidity to the protocol.
    /// @param params The params for adding liquidity
    /// @return tokenId The id of the nft
    /// @return liquidity The amount of added liquidity
    function addLiquidity(AddLiqParams calldata params) external returns (uint256 tokenId, uint128 liquidity);

    /// @notice Removes liquidity from the pool, given the tokenId of a position. Only to be called once by the liquidity provider.
    /// @param tokenId The ID of the NFT that represents the liquidity position
    /// @return collateral The amount of collateral to be received by the liqudity provider
    /// @return spear The amount of Spear to be received by the liquidity provider
    /// @return shield The amount of Shield to be received by the liquidity provider
    /// @return spearObligation The obligatory reserve of collateral amount for settling spear tokens sold by the position
    /// @return shieldObligation The obligatory reserve of collateral amount for settling shield tokens sold by the position
    function removeLiquidity(uint256 tokenId)
        external
        returns (uint256 collateral, uint256 spear, uint256 shield, uint256 spearObligation, uint256 shieldObligation);

    /// @notice Returns the amount of collateral reserved for options that settle out-of-money.
    /// Can be called once after expiry by the liquidity provider and must be called after liquidity has been removed.
    /// @param tokenId The ID of the NFT that represents the liquidity position
    function withdrawObligation(uint256 tokenId) external;

    /// @notice Returns the amount of collateral reserved for the liquidity providers' open short interest.
    /// The LP gets one collateral for sending one spear or shield token back to the pool to close the net amount of short options exposure.
    /// Can be called once before expiry by the LP and must be called after liquidity has been removed.
    /// @param tokenId The ID of the NFT that represents the liquidity position
    function redeemObligation(uint256 tokenId) external;
}

interface IManagerTrade is ITradeCallback {
    event Traded(address recipient, TradeType tradeType, uint256 amountIn, uint256 amountOut);

    /// @notice Calls the battle contract to execute a trade
    /// @param mtp The params of trade in manager contract
    /// @return amountIn The collateral amount to be swapped in based on the direction of the swap
    /// @return amountOut The amount to be received, of either spear or shield token, based on the direction of the swap
    /// @return amountFee The amount of fee in collateral token to be spent for the trade
    function trade(TradeParams calldata mtp) external returns (uint256, uint256, uint256);
}

interface IManagerActions is IManagerLiquidity, IManagerTrade { }
