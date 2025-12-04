// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "../lib/vault-v2/src/adapters/interfaces/IMorphoMarketV1AdapterV2Factory.sol";
import "../lib/vault-v2/src/adapters/interfaces/IMorphoMarketV1AdapterV2.sol";
import "../lib/vault-v2/src/interfaces/IAdapterRegistry.sol";

contract MorphoMarketV1RegistryV2 is IAdapterRegistry {
    address public immutable morphoMarketV1AdapterV2Factory;

    constructor(address _morphoMarketV1AdapterV2Factory) {
        morphoMarketV1AdapterV2Factory = _morphoMarketV1AdapterV2Factory;
    }

    function isInRegistry(address adapter) external view returns (bool) {
        return IMorphoMarketV1AdapterV2Factory(morphoMarketV1AdapterV2Factory).isMorphoMarketV1AdapterV2(adapter);
    }
}
