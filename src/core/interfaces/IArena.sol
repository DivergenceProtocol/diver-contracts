// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Fee, BattleKey, Outcome } from "core/types/common.sol";
import { CreateAndInitBattleParams } from "periphery/params/peripheryParams.sol";

interface IArenaAdmin {
    event FeeChanged(string underlying, Fee fee);
    event CollateralWhitelistChanged(address collateral, bool state);
    event UnderlyingWhitelistChanged(string underlying, bool state, Fee fee);
    event PermissionlessChanged(bool state);
    event SupportedChanged(address collateralToken, string underlying, bool isSupported);
    event ManagerChanged(address old, address _new);
    event OracleChanged(address old, address _new);

    function setFeeForUnderlying(string calldata underlying, Fee calldata newFee) external;
    function setCollateralWhitelist(address collateral, bool isSupported) external;
    function setUnderlyingWhitelist(string memory underlying, bool isSupported, Fee calldata fee) external;
    function setPermissionless() external;
    function setManager(address _manager) external;
    function setOracle(address _oracle) external;
}

interface IArenaCreation {
    event BattleCreated(BattleKey bk, address battleAddr, address spear, address shield, Fee fee);

    /// @notice Create a new battle
    /// @param params Params for creating a new battle
    /// @return battleAddr new battle address
    function createBattle(CreateAndInitBattleParams memory params) external returns (address battleAddr);

    /// @notice Get the address of the existing battle or address(0) if not found
    function getBattle(BattleKey memory battleKey) external view returns (address battleAddr);
}

interface IArenaState {
    struct BattleInfo {
        address battle;
        BattleKey bk;
        uint160 sqrtPriceX96;
        int24 tick;
        uint256 startTS;
        uint256 endTS;
        address spear;
        address shield;
        Outcome result;
    }

    function getAllBattles() external view returns (BattleInfo[] memory);
}

interface IArena is IArenaAdmin, IArenaCreation, IArenaState { }
