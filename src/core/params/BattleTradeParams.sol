// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { TradeType } from "core/types/enums.sol";

struct BattleTradeParams {
    address recipient; //The address to receive the output of the swap
    TradeType tradeType; //whether to buy spear or buy shield
    int256 amountSpecified; //The amount of the swap, which implicitly configures the swap as exact input of collateral or exact output of spear or shield token delta
    uint160 sqrtPriceLimitX96; // The Q64.96 sqrtPrice limit
    bytes data;
}
