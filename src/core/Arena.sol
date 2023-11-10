// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import { IERC20 } from "@oz/token/ERC20/IERC20.sol";
import { Ownable } from "@oz/access/Ownable.sol";
import { Clones } from "@oz/proxy/Clones.sol";
import { IERC20Metadata } from "@oz/token/ERC20/extensions/IERC20Metadata.sol";
import { Strings } from "@oz/utils/Strings.sol";
import { IOracle } from "core/interfaces/IOracle.sol";
import { Errors } from "core/errors/Errors.sol";
import { IArena, Fee, Outcome, BattleKey, CreateAndInitBattleParams } from "core/interfaces/IArena.sol";
import { IBattleInit } from "core/interfaces/battle/IBattleInit.sol";
import { IBattleState } from "core/interfaces/battle/IBattleState.sol";
import { DeploymentParams } from "core/params/coreParams.sol";
import { SToken } from "core/token/SToken.sol";
import { getAdjustPrice } from "core/utils.sol";

/// @notice Deploys battles. Sets pool underlying, collateral, fees and other
/// deployment
/// parameters.
contract Arena is IArena, Ownable {
    address public oracleAddr;
    address public managerAddr;
    address[] private battleList;
    address public immutable battleImpl;
    bool public isPermissionless;
    mapping(bytes32 => address) public battles;
    mapping(string => Fee) public fees;

    mapping(address => bool) public collateralWhitelist;
    mapping(string => bool) public underlyingWhitelist;

    constructor(address _oracleAddr, address _battleImpl) {
        if (_oracleAddr == address(0) || _battleImpl == address(0)) {
            revert Errors.ZeroValue();
        }
        oracleAddr = _oracleAddr;
        battleImpl = _battleImpl;
    }

    function setFeeForUnderlying(string calldata underlying, Fee calldata _fee) external override onlyOwner {
        require(keccak256(abi.encode(underlying)) != keccak256(abi.encode("")), "underlying null");
        fees[underlying] = _fee;
        emit FeeChanged(underlying, _fee);
    }

    function setCollateralWhitelist(address collateral, bool isSupported) external override onlyOwner {
        require(collateralWhitelist[collateral] != isSupported, "LD");
        collateralWhitelist[collateral] = isSupported;
        emit CollateralWhitelistChanged(collateral, isSupported);
    }

    function setUnderlyingWhitelist(string memory underlying, bool isSupported, Fee calldata fee) external override onlyOwner {
        require(underlyingWhitelist[underlying] != isSupported, "LD");
        underlyingWhitelist[underlying] = isSupported;
        fees[underlying] = fee;
        emit UnderlyingWhitelistChanged(underlying, isSupported, fee);
    }

    function setPermissionless() external override onlyOwner {
        isPermissionless = !isPermissionless;
        emit PermissionlessChanged(isPermissionless);
    }

    function setManager(address _manager) external override onlyOwner {
        if (_manager == address(0)) {
            revert Errors.ZeroValue();
        }
        address old = managerAddr;
        managerAddr = _manager;
        emit ManagerChanged(old, _manager);
    }

    function setOracle(address _oracle) external override onlyOwner {
        if (_oracle == address(0)) {
            revert Errors.ZeroValue();
        }
        address old = oracleAddr;
        oracleAddr = _oracle;
        emit OracleChanged(old, _oracle);
    }

    function createBattle(CreateAndInitBattleParams memory params) external override returns (address battle) {
        address ma = managerAddr;
        if (msg.sender != ma) {
            revert Errors.OnlyManager();
        }
        // collaterl address error
        if (params.bk.collateral == address(0)) {
            revert Errors.ZeroValue();
        }

        // not supported
        if (!isPermissionless) {
            if (!collateralWhitelist[params.bk.collateral]) {
                revert Errors.NotSupported();
            }
        }

        if (!underlyingWhitelist[params.bk.underlying]) {
            revert Errors.NotSupported();
        }

        // expiries must at 8am utc
        if ((params.bk.expiries - 28_800) % 86_400 != 0 || block.timestamp >= params.bk.expiries) {
            revert Errors.NotSupportedExpiries();
        }

        params.bk.strikeValue = getAdjustPrice(params.bk.strikeValue);
        if (params.bk.strikeValue == 0) {
            revert Errors.ZeroValue();
        }
        bytes32 battleKeyB32 = keccak256(abi.encode(params.bk.collateral, params.bk.underlying, params.bk.expiries, params.bk.strikeValue));
        if (battles[battleKeyB32] != address(0)) {
            revert Errors.BattleExisted();
        }
        battle = Clones.cloneDeterministic(battleImpl, battleKeyB32);
        uint8 decimals = IERC20Metadata(params.bk.collateral).decimals();
        string memory indexString = Strings.toString(battleList.length);
        address spear = address(new SToken(string.concat("Spear", indexString), string.concat("SPEAR", indexString), decimals, battle));
        address shield = address(new SToken(string.concat("Shield", indexString), string.concat("SHIELD", indexString), decimals, battle));
        DeploymentParams memory deploymentParameters = DeploymentParams({
            arenaAddr: address(this),
            battleKey: params.bk,
            oracleAddr: oracleAddr,
            cOracleAddr: IOracle(oracleAddr).getCOracle(params.bk.underlying),
            fee: fees[params.bk.underlying],
            spear: spear,
            shield: shield,
            manager: ma,
            sqrtPriceX96: params.sqrtPriceX96
        });
        battles[battleKeyB32] = battle;
        battleList.push(battle);
        IBattleInit(battle).init(deploymentParameters);
        emit BattleCreated(params.bk, battle, spear, shield, fees[params.bk.underlying]);
    }

    function getBattle(BattleKey memory battleKey) external view override returns (address battle) {
        battleKey.strikeValue = getAdjustPrice(battleKey.strikeValue);
        bytes32 battleKeyB32 = keccak256(abi.encode(battleKey.collateral, battleKey.underlying, battleKey.expiries, battleKey.strikeValue));
        battle = battles[battleKeyB32];
    }

    function getAllBattles() external view override returns (BattleInfo[] memory) {
        uint256 len = battleList.length;
        BattleInfo[] memory infos = new BattleInfo[](len);
        for (uint256 i; i < len; i++) {
            address battle = battleList[i];
            BattleKey memory bk = IBattleState(battle).battleKey();
            (uint160 sqrtPriceX96, int24 tick,) = IBattleState(battle).slot0();
            (uint256 startTS, uint256 endTS) = IBattleState(battle).startAndEndTS();
            (address spear, address shield) = IBattleState(battle).spearAndShield();
            Outcome result = IBattleState(battle).battleOutcome();
            infos[i] = BattleInfo({
                battle: battle,
                bk: bk,
                sqrtPriceX96: sqrtPriceX96,
                tick: tick,
                startTS: startTS,
                endTS: endTS,
                spear: spear,
                shield: shield,
                result: result
            });
        }
        return infos;
    }
}
