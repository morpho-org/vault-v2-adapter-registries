// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "./interfaces/IRegistryList.sol";

contract RegistryList is IRegistryList {
    address public owner;

    /// @dev Owner controlled append-only list of registries.
    address[] public subRegistries;

    uint256 public transient startIndex;

    event Constructor(address indexed owner);
    event SetOwner(address indexed newOwner);
    event AddSubRegistry(address indexed subRegistry);

    function setStartIndex(uint256 newStartIndex) external {
        startIndex = newStartIndex;
    }

    function subRegistriesLength() external view returns (uint256) {
        return subRegistries.length;
    }

    constructor() {
        owner = msg.sender;
        emit Constructor(msg.sender);
    }

    function setOwner(address newOwner) external {
        require(msg.sender == owner, "Not owner");
        owner = newOwner;
        emit SetOwner(newOwner);
    }

    function addSubRegistry(address subRegistry) external {
        require(msg.sender == owner, "Not owner");
        subRegistries.push(subRegistry);
        emit AddSubRegistry(subRegistry);
    }

    function isInRegistry(address adapter) public view returns (bool) {
        for (uint256 i = startIndex; i < subRegistries.length; i++) {
            if (IAdapterRegistry(subRegistries[i]).isInRegistry(adapter)) return true;
        }
        return false;
    }
}
