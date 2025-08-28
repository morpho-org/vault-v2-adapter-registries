// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IRegistry {
    function canAddAdapter(address adapter) external view returns (bool);
}
