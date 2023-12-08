// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "core/types/common.sol";

interface IBattleState {
    /// @notice Retrieves position info for a given position key
    /// @param pk positon key
    /// @param info Information about the position
    function positions(bytes32 pk) external view returns (PositionInfo memory info);

    /// @notice The result of battle.
    /// @return result check different battle result type in enums.sol
    function battleOutcome() external view returns (Outcome);

    /// @notice Returns the BattleKey that uniquely identifies a battle
    function battleKey() external view returns (BattleKey memory key);

    /// @notice Get Manager address in this battle
    function manager() external view returns (address);

    /// @notice BaseInfo includes current sqrtPriceX96, current tick
    function slot0() external view returns (uint160 sqrtPriceX96, int24 tick, bool unlocked);

    function spearAndShield() external view returns (address, address);

    function startAndEndTS() external view returns (uint256, uint256);

    function spearBalanceOf(address account) external view returns (uint256 amount);

    function shieldBalanceOf(address account) external view returns (uint256 amount);

    function spear() external view returns (address);

    function shield() external view returns (address);

    function getInsideLast(int24 tickLower, int24 tickUpper) external view returns (GrowthX128 memory);

    function fee() external view returns (uint256, uint256, uint256);
}
