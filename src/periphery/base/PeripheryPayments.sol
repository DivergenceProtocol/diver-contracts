// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import { IERC20 } from "@oz/token/ERC20/IERC20.sol";
import { TransferHelper } from "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import { Errors } from "core/errors/Errors.sol";
import { IWETH9 } from "../interfaces/external/IWETH9.sol";
import { PeripheryImmutableState } from "./PeripheryImmutableState.sol";

abstract contract PeripheryPayments is PeripheryImmutableState {
    receive() external payable {
        if (msg.sender != WETH9) {
            revert Errors.NotWETH9();
        }
    }

    function pay(address tokenAddr, address payer, address recipient, uint256 value) internal {
        if (tokenAddr == WETH9 && address(this).balance >= value) {
            IWETH9(WETH9).deposit{ value: value }();
            IWETH9(WETH9).transfer(recipient, value);
        } else {
            TransferHelper.safeTransferFrom(tokenAddr, payer, recipient, value);
        }
    }
}
