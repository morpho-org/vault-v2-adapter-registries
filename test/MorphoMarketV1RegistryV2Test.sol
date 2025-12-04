// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association
pragma solidity ^0.8.0;

import "../lib/forge-std/src/Test.sol";
import "../src/MorphoMarketV1RegistryV2.sol";

contract MorphoMarketV1RegistryV2Test is Test {
    MorphoMarketV1RegistryV2 registry;
    address morphoMarketV1AdapterV2Factory = address(0x1001);

    function setUp() public {
        registry = new MorphoMarketV1RegistryV2(morphoMarketV1AdapterV2Factory);
    }

    function testConstructor() public view {
        assertEq(registry.morphoMarketV1AdapterV2Factory(), morphoMarketV1AdapterV2Factory);
    }

    function testIsInRegistry(address adapter, bool isMorphoMarketV1AdapterV2) public {
        vm.assume(adapter != address(vm));
        vm.mockCall(
            morphoMarketV1AdapterV2Factory,
            abi.encodeWithSignature("isMorphoMarketV1AdapterV2(address)", adapter),
            abi.encode(isMorphoMarketV1AdapterV2)
        );

        assertEq(registry.isInRegistry(adapter), isMorphoMarketV1AdapterV2);
    }

    // check that if the adapter isn't a market adapter, it doesn't revert (basically checks the order of execution of
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
