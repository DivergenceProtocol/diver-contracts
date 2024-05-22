// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { ERC20 } from "@oz/token/ERC20/ERC20.sol";

contract DitanicNaive is ERC20 {
    constructor() ERC20("Ditanic Token", "DITANIC") { }

    function mint() external {
        _mint(msg.sender, 10000e18);
    }
}
