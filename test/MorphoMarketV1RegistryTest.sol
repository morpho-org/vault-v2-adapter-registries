// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/MorphoMarketV1Registry.sol";

contract MorphoMarketV1RegistryTest is Test {
    MorphoMarketV1Registry registry;
    address morphoMarketV1AdapterFactory = address(0x1001);
    address expectedMorpho = address(0x1234);

    function setUp() public {
        registry = new MorphoMarketV1Registry(morphoMarketV1AdapterFactory, expectedMorpho);
    }

    function testIsInRegistry(address adapter, address morpho, bool inFactory) public {
        vm.mockCall(
            morphoMarketV1AdapterFactory,
            abi.encodeWithSignature("isMorphoMarketV1Adapter(address)", adapter),
            abi.encode(inFactory)
        );

        if (inFactory) {
            vm.mockCall(adapter, abi.encodeWithSignature("morpho()"), abi.encode(morpho));
        }

        bool expected = inFactory && morpho == expectedMorpho;
        assertEq(registry.isInRegistry(adapter), expected);
    }

    // check that if the adapter isn't a market adapter, it doens't revert (basically checks the order of execution of solidity).
    function testNoObscureRevert(address adapter) public {
        vm.mockCall(
            morphoMarketV1AdapterFactory,
            abi.encodeWithSignature("isMorphoMarketV1Adapter(address)", adapter),
            abi.encode(false)
        );

        registry.isInRegistry(adapter);
    }
}
