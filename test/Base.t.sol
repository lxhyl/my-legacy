// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {LegacyProxy} from "../src/LegacyProxy.sol";
import {Legacy} from "../src/Legacy.sol";
import {ILegacy} from "../src/Interfaces/ILegacy.sol";
contract Base is Test {
    address payable legacyProxy;

    function setUp() external {
        legacyProxy = payable(address(new LegacyProxy(address(new Legacy()))));
    }
}
