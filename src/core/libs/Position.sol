// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { SafeCast } from "@oz/utils/math/SafeCast.sol";
import { FullMath } from "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import { FixedPoint128 } from "@uniswap/v3-core/contracts/libraries/FixedPoint128.sol";
import { PositionInfo, GrowthX128, Owed } from "core/types/common.sol";

library Position {
    using SafeCast for uint256;

    function get(
        mapping(bytes32 => PositionInfo) storage self,
        address owner,
        int24 tickLower,
        int24 tickUpper
    )
        internal
        view
        returns (PositionInfo storage position)
    {
        position = self[keccak256(abi.encodePacked(owner, tickLower, tickUpper))];
    }

    function update(PositionInfo storage self, int128 liquidityDelta, GrowthX128 memory insideLast) internal {
        PositionInfo memory _self = self;
        uint128 liquidityNext = liquidityDelta < 0 ? _self.liquidity - uint128(-liquidityDelta) : _self.liquidity + uint128(liquidityDelta);
        if (liquidityDelta != 0) {
            self.liquidity = liquidityNext;
        }
        self.insideLast = insideLast;
    }
}
