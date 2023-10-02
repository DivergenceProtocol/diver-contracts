// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// round down to two significant digits.
/// @param price price of underlying. price has decimal 18, eg. eth price 1500 will be 1500 * 10**18
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