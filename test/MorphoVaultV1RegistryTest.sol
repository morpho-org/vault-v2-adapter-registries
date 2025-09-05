// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/MorphoVaultV1Registry.sol";

contract MorphoVaultV1RegistryTest is Test {
    MorphoVaultV1Registry module;
    address metaMorphoFactory = address(0x1001);
    address adapterFactory = address(0x1002);

    function setUp() public {
        module = new MorphoVaultV1Registry(adapterFactory, metaMorphoFactory);
    }

    function testConstructor() public view {
        assertEq(module.morphoVaultV1AdapterFactory(), adapterFactory);
        assertEq(module.metaMorphoFactory(), metaMorphoFactory);
    }

    function testIsInRegistry(address adapter, address adapterVault, bool inFactory, bool vaultInMetaMorpho) public {
        vm.mockCall(
            adapterFactory, abi.encodeWithSignature("isMorphoVaultV1Adapter(address)", adapter), abi.encode(inFactory)
        );

        if (inFactory) {
            vm.mockCall(adapter, abi.encodeWithSignature("morphoVaultV1()"), abi.encode(adapterVault));
            vm.mockCall(
                metaMorphoFactory,
                abi.encodeWithSignature("isMetaMorpho(address)", adapterVault),
                abi.encode(vaultInMetaMorpho)
            );
        }

        bool expected = inFactory && vaultInMetaMorpho;
        assertEq(module.isInRegistry(adapter), expected);
    }
}
