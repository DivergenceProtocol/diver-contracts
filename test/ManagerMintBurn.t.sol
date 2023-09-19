// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { CreateAndInit } from "./ManagerBase.t.sol";
import { IManagerActions } from "../src/periphery/interfaces/IManagerActions.sol";
import { AddLiqParams } from "../src/periphery/params/Params.sol";
import { addLiquidity, getAddLiquidityParams } from "./shared/Actions.sol";
import { IManagerState } from "../src/periphery/interfaces/IManagerState.sol";
import { IQuoter } from "../src/periphery/interfaces/IQuoter.sol";
import { console2 } from "@std/console2.sol";
import "../src/core/types/common.sol";
import "../src/core/types/enums.sol";
import { IBattle } from "../src/core/interfaces/battle/IBattle.sol";
import { IManager } from "../src/periphery/interfaces/IManager.sol";
import { Position } from "../src/periphery/types/common.sol";

contract Mint is CreateAndInit {
    AddLiqParams public defaultAddLiqParams;

    function setUp() public virtual override {
        super.setUp();
        defaultAddLiqParams = getAddLiquidityParams(defaultBattleKey, alice, -2500, 2500, LiquidityType.COLLATERAL, 10_000_000e18, 300);
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    function test() public virtual override returns (address) {
        address battleAddr = super.test();
        assertGt(uint160(battleAddr), 0);
        vm.startPrank(alice);
        IManagerActions(manager).addLiquidity(defaultAddLiqParams);
        vm.stopPrank();
        Position[] memory lis = IQuoter(quoter).accountPositions(alice);
        console2.log("lis %s", lis.length);
        return battleAddr;
    }

    function addOneLiquidity() public virtual returns(address) {
        address battleAddr = super.test();
        assertGt(uint160(battleAddr), 0);
        vm.startPrank(alice);
        AddLiqParams memory p = getAddLiquidityParams(defaultBattleKey, alice, -30, 0, LiquidityType.COLLATERAL, 1000e18, 300);
        IManagerActions(manager).addLiquidity(p);
        vm.stopPrank();
        return battleAddr;
    }

    function addMultiLiquidity() public virtual returns(address) {
        address battleAddr = super.test();
        assertGt(uint160(battleAddr), 0);
        vm.startPrank(alice);
        AddLiqParams memory up1 = getAddLiquidityParams(defaultBattleKey, alice, 100, 200, LiquidityType.COLLATERAL, 10000e18, 300);
        AddLiqParams memory up2 = getAddLiquidityParams(defaultBattleKey, alice, 300, 400, LiquidityType.COLLATERAL, 10000e18, 300);
        AddLiqParams memory up3 = getAddLiquidityParams(defaultBattleKey, alice, 400, 500, LiquidityType.COLLATERAL, 10000e18, 300);
        AddLiqParams memory up4 = getAddLiquidityParams(defaultBattleKey, alice, 600, 1000, LiquidityType.COLLATERAL, 1_000_000_000e18, 300);
        AddLiqParams memory up5 = getAddLiquidityParams(defaultBattleKey, alice, 200, 800, LiquidityType.COLLATERAL, 100e18, 300);
        AddLiqParams memory up6 = getAddLiquidityParams(defaultBattleKey, alice, 0, 100, LiquidityType.COLLATERAL, 100e18, 300);
        // AddLiqParams memory up7 = getAddLiquidityParams(defaultBattleKey, alice, 0, 1000, LiquidityType.COLLATERAL, 10000000e18, 300);
        AddLiqParams memory down1 = getAddLiquidityParams(defaultBattleKey, alice, -200, -100, LiquidityType.COLLATERAL, 10000e18, 300);
        AddLiqParams memory down2 = getAddLiquidityParams(defaultBattleKey, alice, -400, -300, LiquidityType.COLLATERAL, 10000e18, 300);
        AddLiqParams memory down3 = getAddLiquidityParams(defaultBattleKey, alice, -500, -400, LiquidityType.COLLATERAL, 10000e18, 300);
        AddLiqParams memory down4 = getAddLiquidityParams(defaultBattleKey, alice, -1000, -600, LiquidityType.COLLATERAL, 1_000_000_000e18, 300);
        AddLiqParams memory down5 = getAddLiquidityParams(defaultBattleKey, alice, -800, -200, LiquidityType.COLLATERAL, 10000e18, 300);
        AddLiqParams memory down6 = getAddLiquidityParams(defaultBattleKey, alice, -100, 0, LiquidityType.COLLATERAL, 100e18, 300);
        // AddLiqParams memory down7 = getAddLiquidityParams(defaultBattleKey, alice, -1000, 0, LiquidityType.COLLATERAL, 100000000e18, 300);
        IManagerActions(manager).addLiquidity(up1);
        IManagerActions(manager).addLiquidity(up2);
        IManagerActions(manager).addLiquidity(up3);
        IManagerActions(manager).addLiquidity(up4);
        IManagerActions(manager).addLiquidity(up5);
        IManagerActions(manager).addLiquidity(up6);
        // IManagerActions(manager).addLiquidity(up7);
        IManagerActions(manager).addLiquidity(down1);
        IManagerActions(manager).addLiquidity(down2);
        IManagerActions(manager).addLiquidity(down3);
        IManagerActions(manager).addLiquidity(down4);
        IManagerActions(manager).addLiquidity(down5);
        IManagerActions(manager).addLiquidity(down6);
        // IManagerActions(manager).addLiquidity(down7);
        vm.stopPrank();
        return battleAddr;
    }
}

contract Burn is Mint {
    function setUp() public virtual override {
        super.setUp();
    }

    function test_BurnAfterMint() public virtual {
        super.test();
        vm.startPrank(alice);
        IManagerActions(manager).removeLiquidity(0);
        // IManagerActions(manager).burn(1);
        vm.stopPrank();
    }

    function testFail_RevertWhen_BurnNotExistNFT() public virtual {
        super.test();
        vm.startPrank(alice);
        IManagerActions(manager).removeLiquidity(900_000);
        vm.stopPrank();
    }

    function testFail_RevertWhen_BurnNFTNotOnce() public virtual {
        super.test();
        vm.startPrank(alice);
        IManagerActions(manager).removeLiquidity(0);
        IManagerActions(manager).removeLiquidity(0);
        vm.stopPrank();
    }
}
