// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "../../lib/vault-v2/src/adapters/interfaces/IMorphoMarketV1AdapterFactory.sol";
import "../../lib/vault-v2/src/adapters/interfaces/IMorphoMarketV1Adapter.sol";
import "../../lib/vault-v2/src/interfaces/IAdapterRegistry.sol";

contract MorphoMarketV1Module is IAdapterRegistry {
    address public immutable morphoMarketV1AdapterFactory;
    address public immutable morpho;

    constructor(address _morphoMarketV1AdapterFactory, address _morpho) {
        morphoMarketV1AdapterFactory = _morphoMarketV1AdapterFactory;
        morpho = _morpho;
    }

    function isInRegistry(address adapter) external view returns (bool) {
        return IMorphoMarketV1AdapterFactory(morphoMarketV1AdapterFactory).isMorphoMarketV1Adapter(adapter)
            && IMorphoMarketV1Adapter(adapter).morpho() == morpho;
    }
}
