// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// Rounds down price input to two significant digits to adjust it for strike price. Assumes 18 decimal places (e.g., ETH price 1500 as 1500 * 10**18).
/// @param price Price of the underlying asset in 18 decimal format.
function getAdjustPrice(uint256 price) pure returns (uint256 adjustedPrice) {
    require(price >= 1e12, "price too small");
    uint256 i = 12;
    while (price / 10 ** i >= 10) {
        i += 1;
    }
    uint256 max = i - 1;
    uint256 denominator = 10 ** max;
    adjustedPrice = (price / denominator) * denominator;
}
