// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { ERC20Burnable } from "@oz/token/ERC20/extensions/ERC20Burnable.sol";
import { ERC20 } from "@oz/token/ERC20/ERC20.sol";
import { Ownable } from "@oz/access/Ownable.sol";
import { ISToken } from "core/interfaces/ISToken.sol";

/**
 * @notice Implements digital call (Spear) and put (Shield) options as ERC-20 tokens (STokens).
 *     @dev Only the battle contract (owner) can mint or burn SToken
 */
contract SToken is ERC20Burnable, Ownable, ISToken {
    uint8 private immutable _decimals;

    constructor(string memory name_, string memory symbol_, uint8 decimals_, address battle) ERC20(name_, symbol_) {
        _decimals = decimals_;
        _transferOwnership(battle);
    }

    function mint(address account, uint256 amount) external override onlyOwner {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external override onlyOwner {
        _burn(account, amount);
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }
}
