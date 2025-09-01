// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "../lib/vault-v2/src/interfaces/IAdapterRegistry.sol";

contract MorphoAdapterRegistry is IAdapterRegistry {
    address public owner;
    address[] public registryModules;

    event Constructor(address indexed owner);
    event SetOwner(address indexed newOwner);
    event AddRegistryModule(address indexed registryModule);

    function registryModulesLength() external view returns (uint256) {
        return registryModules.length;
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

    function addRegistryModule(address registryModule) external {
        require(msg.sender == owner, "Not owner");
        registryModules.push(registryModule);
        emit AddRegistryModule(registryModule);
    }

    function isInRegistry(address adapter) public view returns (bool) {
        for (uint256 i = 0; i < registryModules.length; i++) {
            if (IAdapterRegistry(registryModules[i]).isInRegistry(adapter)) return true;
        }
        return false;
    }
}
