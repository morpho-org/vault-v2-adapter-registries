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
        bytes4 selector = bytes4(keccak256("setAdapterRegistry(address)"));
        return IVaultV2(vault).adapterRegistry() == morphoRegistry
            && IVaultV2(vault).timelock(selector) == type(uint256).max;
    }
}
