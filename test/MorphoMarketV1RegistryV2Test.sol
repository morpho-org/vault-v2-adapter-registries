// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/MorphoMarketV1RegistryV2.sol";

contract MorphoMarketV1RegistryV2Test is Test {
    MorphoMarketV1RegistryV2 registry;
    address morphoMarketV1AdapterV2Factory = address(0x1001);
    address expectedMorphoMarketV1 = address(0x1234);

    function setUp() public {
        registry = new MorphoMarketV1RegistryV2(morphoMarketV1AdapterV2Factory, expectedMorphoMarketV1);
    }

    function testConstructor() public view {
        assertEq(registry.morphoMarketV1AdapterV2Factory(), morphoMarketV1AdapterV2Factory);
        assertEq(registry.morphoMarketV1(), expectedMorphoMarketV1);
    }

    function testIsInRegistry(address adapter, address morphoMarketV1, bool isMorphoMarketV1AdapterV2) public {
        vm.mockCall(
            morphoMarketV1AdapterV2Factory,
            abi.encodeWithSignature("isMorphoMarketV1AdapterV2(address)", adapter),
            abi.encode(isMorphoMarketV1AdapterV2)
        );

        if (isMorphoMarketV1AdapterV2) {
            vm.mockCall(adapter, abi.encodeWithSignature("morpho()"), abi.encode(morphoMarketV1));
        }

        bool expected = isMorphoMarketV1AdapterV2 && morphoMarketV1 == expectedMorphoMarketV1;
        assertEq(registry.isInRegistry(adapter), expected);
    }

    // check that if the adapter isn't a market adapter, it doens't revert (basically checks the order of execution of
    // solidity).
    function testNoObscureRevert(address adapter) public {
        vm.mockCall(
            morphoMarketV1AdapterV2Factory,
            abi.encodeWithSignature("isMorphoMarketV1AdapterV2(address)", adapter),
            abi.encode(false)
        );

        registry.isInRegistry(adapter);
    }
}
