// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Fee, BattleKey, Outcome } from "../types/common.sol";
import { CreateAndInitBattleParams } from "../../periphery/params/Params.sol";

interface IArenaAdmin {
    event SupportedChanged(address collateralToken, string underlying, bool isSupported);
    event FeeChanged(string underlying, Fee fee);
    event ManagerChanged(address old, address _new);

    function setFeeForUnderlying(string calldata underlying, Fee calldata newFee) external;
}

interface IArenaCreation {
    event BattleCreated(BattleKey bk, address battleAddr, address spear, address shield, Fee fee);

    /// @notice create new battle
    /// @param params Params for creating new battle
    /// @return battleAddr new battle address
    function createBattle(CreateAndInitBattleParams memory params) external returns (address battleAddr);

    /// @notice Get existed battle address by battleKey. If not exist, will
    /// return address(0)
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
