// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity ^0.8.0;

import "../lib/forge-std/src/Test.sol";
import "../src/MorphoMarketV1Registry.sol";

contract MorphoMarketV1RegistryTest is Test {
    MorphoMarketV1Registry registry;
    address morphoMarketV1AdapterFactory = address(0x1001);
    address expectedMorphoMarketV1 = address(0x1234);

    function setUp() public {
        registry = new MorphoMarketV1Registry(morphoMarketV1AdapterFactory, expectedMorphoMarketV1);
    }

    function testConstructor() public view {
        assertEq(registry.morphoMarketV1AdapterFactory(), morphoMarketV1AdapterFactory);
        assertEq(registry.morphoMarketV1(), expectedMorphoMarketV1);
    }

    function testIsInRegistry(address adapter, address morphoMarketV1, bool isMorphoMarketV1Adapter) public {
        vm.assume(adapter != address(vm));
        vm.mockCall(
            morphoMarketV1AdapterFactory,
            abi.encodeWithSignature("isMorphoMarketV1Adapter(address)", adapter),
            abi.encode(isMorphoMarketV1Adapter)
        );

        if (isMorphoMarketV1Adapter) {
            vm.mockCall(adapter, abi.encodeWithSignature("morpho()"), abi.encode(morphoMarketV1));
        }

        bool expected = isMorphoMarketV1Adapter && morphoMarketV1 == expectedMorphoMarketV1;
        assertEq(registry.isInRegistry(adapter), expected);
    }

    // Check that if the adapter isn't a market adapter, it doesn't revert (basically checks the order of execution of
    // solidity).
    function testNoObscureRevert(address adapter) public {
        vm.mockCall(
            morphoMarketV1AdapterFactory,
            abi.encodeWithSignature("isMorphoMarketV1Adapter(address)", adapter),
            abi.encode(false)
        );

        registry.isInRegistry(adapter);
    }
}
