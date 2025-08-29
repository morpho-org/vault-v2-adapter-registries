// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IAdapterRegistry.sol";
import "../lib/morpho-vault-v2/src/adapters/interfaces/IMorphoMarketV1Adapter.sol";
import "../lib/morpho-vault-v2/src/adapters/interfaces/IMorphoMarketV1AdapterFactory.sol";
import "../lib/morpho-vault-v2/src/adapters/interfaces/IMorphoVaultV1Adapter.sol";
import "../lib/morpho-vault-v2/src/adapters/interfaces/IMorphoVaultV1AdapterFactory.sol";
import "../lib/metamorpho-v1.1/src/interfaces/IMetaMorphoV1_1Factory.sol";

contract AdapterRegistry is IAdapterRegistry {
    address public MORPHO;
    address vaultV1Factory;
    address vaultV11Factory;
    address morphoMarketV1AdapterFactory;
    address morphoVaultV1AdapterFactory;

    constructor(
        address _morpho,
        address _vaultV1Factory,
        address _vaultV11Factory,
        address _morphoMarketV1AdapterFactory,
        address _morphoVaultV1AdapterFactory
    ) {
        MORPHO = _morpho;
        vaultV1Factory = _vaultV1Factory;
        vaultV11Factory = _vaultV11Factory;
        morphoMarketV1AdapterFactory = _morphoMarketV1AdapterFactory;
        morphoVaultV1AdapterFactory = _morphoVaultV1AdapterFactory;
    }

    function isInRegistry(address adapter) public view returns (bool) {
        if (IMorphoMarketV1AdapterFactory(morphoMarketV1AdapterFactory).isMorphoMarketV1Adapter(adapter)) {
            return IMorphoMarketV1Adapter(adapter).morpho() == MORPHO;
        } else if (IMorphoVaultV1AdapterFactory(morphoVaultV1AdapterFactory).isMorphoVaultV1Adapter(adapter)) {
            address vault = IMorphoVaultV1Adapter(adapter).morphoVaultV1();
            return IMetaMorphoV1_1Factory(vaultV1Factory).isMetaMorpho(vault)
                || IMetaMorphoV1_1Factory(vaultV11Factory).isMetaMorpho(vault);
        }
        return false;
    }
}
