// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/MorphoAdapterRegistry.sol";

contract MorphoAdapterRegistryTest is Test {
    MorphoAdapterRegistry registry;
    address user = address(0x1);
    address adapter = address(0x2);

    function setUp() public {
        registry = new MorphoAdapterRegistry();
    }

    function testConstructor() public view {
        assertEq(registry.owner(), address(this));
        assertEq(registry.registryModulesLength(), 0);
    }

    function testConstructorEvent() public {
        vm.expectEmit(true, false, false, false);
        emit MorphoAdapterRegistry.Constructor(address(this));
        new MorphoAdapterRegistry();
    }

    function testSetOwner(address newOwner) public {
        vm.expectEmit(true, false, false, false);
        emit MorphoAdapterRegistry.SetOwner(newOwner);

        registry.setOwner(newOwner);
        assertEq(registry.owner(), newOwner);
    }

    function testSetOwnerOnlyOwner() public {
        vm.prank(user);
        vm.expectRevert("Not owner");
        registry.setOwner(address(0x123));
    }

    function testAddRegistryModule(address module) public {
        vm.expectEmit(true, false, false, false);
        emit MorphoAdapterRegistry.AddRegistryModule(module);

        registry.addRegistryModule(module);

        assertEq(registry.registryModulesLength(), 1);
        assertEq(registry.registryModules(0), module);
    }

    function testAddRegistryModuleOnlyOwner() public {
        vm.prank(user);
        vm.expectRevert("Not owner");
        registry.addRegistryModule(address(0x1001));
    }

    function testIsInRegistryWithModules(address adapter, bool module1Result, bool module2Result) public {
        address module1 = address(0x1001);
        address module2 = address(0x1002);

        registry.addRegistryModule(module1);
        registry.addRegistryModule(module2);

        vm.mockCall(module1, abi.encodeWithSignature("isInRegistry(address)", adapter), abi.encode(module1Result));
        vm.mockCall(module2, abi.encodeWithSignature("isInRegistry(address)", adapter), abi.encode(module2Result));

        bool expected = module1Result || module2Result;
        assertEq(registry.isInRegistry(adapter), expected);
    }

    function testIsInRegistryNoModules() public view {
        assertFalse(registry.isInRegistry(adapter));
    }
}
