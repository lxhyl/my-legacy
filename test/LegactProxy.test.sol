// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";

import {Base} from "./Base.t.sol";

contract Implementation1 {
    function getData() external pure returns (uint256) {
        return 1;
    }
}

contract Implementation2 {
    function getData() external pure returns (uint256) {
        return 2;
    }
}

contract LegacyProxyTest is Base {
    function testUpgradeLegacy() public {
        Implementation1 implementation1 = new Implementation1();
        Implementation2 implementation2 = new Implementation2();
        legacyProxy.upgradeLegacy(address(implementation1));
        console.log("1", Implementation2(address(legacyProxy)).getData());

        legacyProxy.upgradeLegacy(address(implementation2));
        console.log("2", Implementation2(address(legacyProxy)).getData());
    }
}
