// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {LegacyProxy} from "../src/LegacyProxy.sol";
import {Legacy} from "../src/Legacy.sol";

import {MockERC20} from "./Mock/ERC20.sol";
contract Base is Test {
    address payable legacyProxy;
    
    MockERC20 coin1;
    MockERC20 coin2;

    address constant alice = address(1);
    address constant bob = address(2);
    function setUp() external {
        legacyProxy = payable(address(new LegacyProxy(address(new Legacy()))));
        coin1 = new MockERC20("coin1","coin1");
        coin1.mint(alice,1000);
        coin1.mint(bob,3333);

        coin2 = new MockERC20("coin2","coin2");
        coin2.mint(alice,1000);
    }
}
