// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {LegacyProxy} from "../src/LegacyProxy.sol";
import {ILegacyProxy} from "../src/Interfaces/ILegacyProxy.sol";
import {Legacy} from "../src/Legacy.sol";
import {ILegacy} from "../src/Interfaces/ILegacy.sol";
import {MockERC20} from "./Mock/ERC20.sol";
contract Base is Test {
    address payable legacyProxy;
    
    MockERC20 coin1;
    MockERC20 coin2;

    address alice;
    address bob;
    address carl;
    function setUp() external {
        alice = vm.addr(1);
        bob = vm.addr(2);
        carl = vm.addr(3);

        legacyProxy = payable(address(new LegacyProxy(address(new Legacy()))));
        coin1 = new MockERC20("coin1","coin1");
        coin1.mint(alice,1000);
        coin1.mint(bob,3333);

        coin2 = new MockERC20("coin2","coin2");
        coin2.mint(alice,1000);

        // alice create will. With coin1;
        vm.startPrank(alice);
        vm.warp(1);
        coin1.approve(legacyProxy, type(uint256).max);
        address beneficiary = carl;
        uint256 executableWillDelay = 26 weeks;
        address[] memory coins = new address[](2);
        coins[0] = address(coin1);
        coins[1] = address(coin2);
        ILegacy(legacyProxy).writeCoinsWill(beneficiary, executableWillDelay, coins);
        vm.stopPrank();
    }
}
