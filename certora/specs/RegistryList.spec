// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association

methods {
    function owner() external returns address envfree;
    function subRegistriesLength() external returns uint256 envfree;
    function subRegistries(uint256) external returns address envfree;
}

rule setOwner(env e, address newOwner) {
    address currentOwner = owner();
    
    setOwner(e, newOwner);
    
    assert e.msg.sender == currentOwner;
    assert owner() == newOwner;
}

rule addSubRegistry(env e, address subRegistry) {
    address currentOwner = owner();
    uint256 lengthBefore = subRegistriesLength();
    require lengthBefore < max_uint256;
    
    addSubRegistry(e, subRegistry);
    
    assert e.msg.sender == currentOwner;
    assert subRegistriesLength() == lengthBefore + 1;
    assert subRegistries(lengthBefore) == subRegistry;
}

// Entries already in the list are never modified nor removed, whatever the call.
rule subRegistryAppendOnly(uint256 i, method f, env e, calldataarg args) {
    uint256 lengthBefore = subRegistriesLength();
    require i < lengthBefore;
    address valueBefore = subRegistries(i);
    
    f(e, args);
    
    assert subRegistriesLength() >= lengthBefore;
    assert subRegistries(i) == valueBefore;
}

rule subRegistriesLengthIncreasesByAtMostOne(method f, env e, calldataarg args) {
    uint256 lengthBefore = subRegistriesLength();
    
    f(e, args);
    
    assert subRegistriesLength() <= lengthBefore + 1;
}