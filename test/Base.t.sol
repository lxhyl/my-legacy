// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {LegacyProxy} from "../src/LegacyProxy.sol";

contract Base is Test {
    LegacyProxy legacyProxy;

    function setUp() external {
        legacyProxy = new LegacyProxy();
    }
}
