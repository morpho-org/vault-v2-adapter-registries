// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "../../lib/vault-v2/src/interfaces/IAdapterRegistry.sol";

interface IMorphoAdapterRegistry is IAdapterRegistry {
    event Constructor(address indexed owner);
    event SetOwner(address indexed newOwner);
    event AddRegistryModule(address indexed registryModule);

    function owner() external view returns (address);
    function registryModules(uint256 index) external view returns (address);
    function registryModulesLength() external view returns (uint256);
    function setOwner(address newOwner) external;
    function addRegistryModule(address registryModule) external;
}
