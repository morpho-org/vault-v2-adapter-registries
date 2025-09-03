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

rule subRegistryAppendOnly(uint256 i) {
    address valueBefore = subRegistries(i);
    uint256 lengthBefore = subRegistriesLength();

    assert i < lengthBefore => subRegistries(i) == valueBefore;
    assert subRegistriesLength() >= lengthBefore && subRegistriesLength() <= lengthBefore + 1;
}