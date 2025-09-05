// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "../lib/metamorpho/src/interfaces/IMetaMorphoFactory.sol";
import "../lib/vault-v2/src/adapters/interfaces/IMorphoVaultV1AdapterFactory.sol";
import "../lib/vault-v2/src/adapters/interfaces/IMorphoVaultV1Adapter.sol";
import "../lib/vault-v2/src/interfaces/IAdapterRegistry.sol";

contract MorphoVaultV1Registry is IAdapterRegistry {
    address public immutable morphoVaultV1AdapterFactory;
    address public immutable metaMorphoFactory;

    constructor(address _morphoVaultV1AdapterFactory, address _metaMorphoFactory) {
        morphoVaultV1AdapterFactory = _morphoVaultV1AdapterFactory;
        metaMorphoFactory = _metaMorphoFactory;
    }

    function isInRegistry(address adapter) external view returns (bool) {
        return IMorphoVaultV1AdapterFactory(morphoVaultV1AdapterFactory).isMorphoVaultV1Adapter(adapter)
            && IMetaMorphoFactory(metaMorphoFactory).isMetaMorpho(IMorphoVaultV1Adapter(adapter).morphoVaultV1());
    }
}
