// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title ISToken
 *
 * @notice Mints or burns Spear or Shield tokens
 */
interface ISToken {
    /**
     * @notice Mint an amount of sToken to account
     */
    function mint(address account, uint256 amount) external;
    /**
     * @notice Burn an amount of sToken from account
     */
    function burn(address account, uint256 amount) external;
}
