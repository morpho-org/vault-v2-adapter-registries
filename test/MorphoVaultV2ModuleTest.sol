// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/modules/MorphoVaultV2Module.sol";

contract MorphoVaultV2ModuleTest is Test {
    MorphoVaultV2Module module;
    address expectedRegistry = address(0x1234);

    function setUp() public {
        module = new MorphoVaultV2Module(expectedRegistry);
    }

    function testConstructor() public view {
        assertEq(module.morphoRegistry(), expectedRegistry);
    }

    function testIsInRegistry(address vault, address registry, uint256 timelock) public {
        bytes4 setAdapterRegistrySelector = bytes4(keccak256("setAdapterRegistry(address)"));

        vm.mockCall(vault, abi.encodeWithSignature("adapterRegistry()"), abi.encode(registry));
        vm.mockCall(
            vault, abi.encodeWithSignature("timelock(bytes4)", setAdapterRegistrySelector), abi.encode(timelock)
        );

        bool expected = registry == expectedRegistry && timelock == type(uint256).max;
        assertEq(module.isInRegistry(vault), expected);
    }
}
