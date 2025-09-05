// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "./interfaces/IRegistryList.sol";

contract RegistryList is IRegistryList {
    address public owner;

    /// @dev Owner controlled append-only list of registries.
    address[] public subRegistries;

    event Constructor(address indexed owner);
    event SetOwner(address indexed newOwner);
    event AddSubRegistry(address indexed subRegistry);

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

    /// @dev If the loop is too gas consuming, vaults will not be able to validate adapters that would be validated by registries that are too "far" in the list.
    function addSubRegistry(address subRegistry) external {
        require(msg.sender == owner, "Not owner");
        subRegistries.push(subRegistry);
        emit AddSubRegistry(subRegistry);
    }

    function isInRegistry(address adapter) public view returns (bool) {
        for (uint256 i = 0; i < subRegistries.length; i++) {
            if (IAdapterRegistry(subRegistries[i]).isInRegistry(adapter)) return true;
        }
        return false;
    }
}
