// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity >=0.5.0;

import "../../lib/vault-v2/src/interfaces/IAdapterRegistry.sol";

interface IRegistryList is IAdapterRegistry {
    function owner() external view returns (address);
    function subRegistries(uint256 index) external view returns (address);
    function subRegistriesLength() external view returns (uint256);
    function setOwner(address newOwner) external;
    function addSubRegistry(address subRegistry) external;
}
