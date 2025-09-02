// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "../../lib/vault-v2/src/interfaces/IVaultV2.sol";
import "../../lib/vault-v2/src/interfaces/IAdapterRegistry.sol";

contract MorphoVaultV2Registry is IAdapterRegistry {
    address public immutable morphoRegistry;

    constructor(address _morphoRegistry) {
        morphoRegistry = _morphoRegistry;
    }

    function isInRegistry(address vault) external view returns (bool) {
        IVaultV2 vaultV2 = IVaultV2(vault);
        bytes4 selector = bytes4(keccak256("setAdapterRegistry(address)"));
        return vaultV2.adapterRegistry() == morphoRegistry && vaultV2.timelock(selector) == type(uint256).max;
    }
}
