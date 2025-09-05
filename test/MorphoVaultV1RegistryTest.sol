// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/MorphoVaultV1Registry.sol";

contract MorphoVaultV1RegistryTest is Test {
    MorphoVaultV1Registry registry;
    address morphoVaultV1Factory = address(0x1001);
    address morphoVaultV1AdapterFactory = address(0x1002);

    function setUp() public {
        registry = new MorphoVaultV1Registry(morphoVaultV1AdapterFactory, morphoVaultV1Factory);
    }

    function testConstructor() public view {
        assertEq(registry.morphoVaultV1AdapterFactory(), morphoVaultV1AdapterFactory);
        assertEq(registry.morphoVaultV1Factory(), morphoVaultV1Factory);
    }

    function testIsInRegistry(address adapter, address adapterVault, bool inFactory, bool vaultInMetaMorpho) public {
        vm.mockCall(
            morphoVaultV1AdapterFactory,
            abi.encodeWithSignature("isMorphoVaultV1Adapter(address)", adapter),
            abi.encode(inFactory)
        );

        if (inFactory) {
            vm.mockCall(adapter, abi.encodeWithSignature("morphoVaultV1()"), abi.encode(adapterVault));
            vm.mockCall(
                morphoVaultV1Factory,
                abi.encodeWithSignature("isMetaMorpho(address)", adapterVault),
                abi.encode(vaultInMetaMorpho)
            );
        }

        bool expected = inFactory && vaultInMetaMorpho;
        assertEq(registry.isInRegistry(adapter), expected);
    }
}
