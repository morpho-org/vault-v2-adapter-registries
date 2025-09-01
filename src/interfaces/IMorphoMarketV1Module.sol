// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "../../lib/vault-v2/src/interfaces/IAdapterRegistry.sol";

interface IMorphoMarketV1Module is IAdapterRegistry {
    function morphoMarketV1AdapterFactory() external view returns (address);
    function morpho() external view returns (address);
}
