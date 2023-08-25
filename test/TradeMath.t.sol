// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { DiverLiquidityAmounts, LiquidityAmounts } from "../src/periphery/libs/DiverLiquidityAmounts.sol";
import { DiverSqrtPriceMath } from "../src/core/libs/DiverSqrtPriceMath.sol";
import { SqrtPriceMath } from "@uniswap/v3-core/contracts/libraries/SqrtPriceMath.sol";
import { TickMath } from "../src/core/libs/TickMath.sol";
import { Test } from "@std/Test.sol";
import { console2 } from "@std/console2.sol";
import { SafeCast } from "@oz/utils/math/SafeCast.sol";
import { FullMath } from "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import { SqrtPriceMath } from "@uniswap/v3-core/contracts/libraries/SqrtPriceMath.sol";
import { ComputeTradeStepParams } from "../src/core/params/ComputeTradeStepParams.sol";
import { TradeType } from "../src/core/types/enums.sol";

contract TradeMathTest is Test {
    function testComputeTradeStep1() public { }
}
