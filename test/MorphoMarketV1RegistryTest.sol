// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/MorphoMarketV1Registry.sol";

contract MorphoMarketV1RegistryTest is Test {
    MorphoMarketV1Registry registry;
    address adapterFactory = address(0x1001);
    address expectedMorpho = address(0x1234);

    function setUp() public {
        registry = new MorphoMarketV1Registry(adapterFactory, expectedMorpho);
    }

    function testIsInRegistry(address adapter, address adapterMorpho, bool inFactory) public {
        vm.mockCall(
            adapterFactory, abi.encodeWithSignature("isMorphoMarketV1Adapter(address)", adapter), abi.encode(inFactory)
        );

        if (inFactory) {
            vm.mockCall(adapter, abi.encodeWithSignature("morpho()"), abi.encode(adapterMorpho));
        }

        bool expected = inFactory && adapterMorpho == expectedMorpho;
        assertEq(registry.isInRegistry(adapter), expected);
    }
}
