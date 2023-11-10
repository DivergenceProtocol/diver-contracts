// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { ERC20 } from "@oz/token/ERC20/ERC20.sol";
import { AccessControl } from "@oz/access/AccessControl.sol";
import { IArenaState } from "core/interfaces/IArena.sol";

contract Ditanic is ERC20, AccessControl {
    bytes32 public constant MINER_ROLE = keccak256("MINER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    address public arena;
    mapping(address => bool) public issued;

    constructor() ERC20("Ditanic Token", "DITANIC") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
    }

    function setArena(address _arena) external {
        arena = _arena;
    }

    function isBattle(address addr) public view returns (bool _isBattle) {
        IArenaState.BattleInfo[] memory infos = IArenaState(arena).getAllBattles();
        uint256 length = infos.length;
        for (uint256 i = 0; i < length; i++) {
            if (infos[i].battle == addr) {
                return true;
            }
        }
    }

    function mint(address account, uint256 amount) external onlyRole(MINER_ROLE) {
        require(!issued[account], "issued");
        issued[account] = true;
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external onlyRole(BURNER_ROLE) {
        _burn(account, amount);
    }

    function burn() external {
        _burn(msg.sender, balanceOf(msg.sender));
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        if (from != address(0) && to != address(0)) {
            require(isBattle(from) || isBattle(to), "from or to must be battle");
        }
    }
}
