// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (c) 2025 Morpho Association

methods {
    function isInRegistry(address) external returns bool envfree;
    function _.morphoVaultV1() external => PER_CALLEE_CONSTANT;
}

rule sanity(env e, method f, calldataarg args) {
    f(e, args);

    assert true;
}

rule cannotBeRemoved(env e, method f, calldataarg args, address adapter) {
    require isInRegistry(adapter);

    f(e, args);

    assert isInRegistry(adapter);
}