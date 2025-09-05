// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/RegistryList.sol";

contract RegistryListTest is Test {
    RegistryList registry;
    address user = address(0x1);

    function setUp() public {
        registry = new RegistryList();
    }

    function testConstructor() public view {
        assertEq(registry.owner(), address(this));
        assertEq(registry.subRegistriesLength(), 0);
    }

    function testConstructorEvent() public {
        vm.expectEmit(true, false, false, false);
        emit RegistryList.Constructor(address(this));
        new RegistryList();
    }

    function testSetOwner(address newOwner) public {
        vm.expectEmit(true, false, false, false);
        emit RegistryList.SetOwner(newOwner);

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
        emit RegistryList.AddSubRegistry(module);

        registry.addSubRegistry(module);

        assertEq(registry.subRegistriesLength(), 1);
        assertEq(registry.subRegistries(0), module);
    }

    function testAddRegistryModuleOnlyOwner() public {
        vm.prank(user);
        vm.expectRevert("Not owner");
        registry.addSubRegistry(address(0x1002));
    }

    function testIsInRegistryWithModules(address adapter, bool module1Result, bool module2Result) public {
        address module1 = address(0x1001);
        address module2 = address(0x1002);

        registry.addSubRegistry(module1);
        registry.addSubRegistry(module2);

        vm.mockCall(module1, abi.encodeWithSignature("isInRegistry(address)", adapter), abi.encode(module1Result));
        vm.mockCall(module2, abi.encodeWithSignature("isInRegistry(address)", adapter), abi.encode(module2Result));

        bool expected = module1Result || module2Result;
        assertEq(registry.isInRegistry(adapter), expected);
    }

    function testIsInRegistryNoModules(address adapter) public view {
        assertFalse(registry.isInRegistry(adapter));
    }
}
