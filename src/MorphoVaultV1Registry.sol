// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import {IMetaMorphoFactory} from "../lib/metamorpho/src/interfaces/IMetaMorphoFactory.sol";
import {IMorphoVaultV1AdapterFactory} from "../lib/vault-v2/src/adapters/interfaces/IMorphoVaultV1AdapterFactory.sol";
import {IMorphoVaultV1Adapter} from "../lib/vault-v2/src/adapters/interfaces/IMorphoVaultV1Adapter.sol";
import {IAdapterRegistry} from "../lib/vault-v2/src/interfaces/IAdapterRegistry.sol";

contract MorphoVaultV1Registry is IAdapterRegistry {
    address public immutable morphoVaultV1AdapterFactory;
    address public immutable morphoVaultV1Factory;

    constructor(address _morphoVaultV1AdapterFactory, address _morphoVaultV1Factory) {
        morphoVaultV1AdapterFactory = _morphoVaultV1AdapterFactory;
        morphoVaultV1Factory = _morphoVaultV1Factory;
    }

    function isInRegistry(address adapter) external view returns (bool) {
        return IMorphoVaultV1AdapterFactory(morphoVaultV1AdapterFactory).isMorphoVaultV1Adapter(adapter)
            && IMetaMorphoFactory(morphoVaultV1Factory).isMetaMorpho(IMorphoVaultV1Adapter(adapter).morphoVaultV1());
    }
}
