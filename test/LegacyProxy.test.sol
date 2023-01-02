// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Base} from "./Base.t.sol";
import {ILegacy} from "../src/Interfaces/ILegacy.sol";
import {Legacy} from "../src/Legacy.sol";
import {LegacyProxy} from "../src/LegacyProxy.sol";
import {ILegacyProxy} from "../src/Interfaces/ILegacyProxy.sol";
contract LegacyProxyTest is Base {
   function upgradeLegacy() internal {
      vm.prank(address(this));
      ILegacyProxy(legacyProxy).upgrade(address(new Legacy()));
      vm.stopPrank();
   }
   function testUpgradeLegacy() public {
    
      vm.prank(alice);
      assertEq(ILegacyProxy(legacyProxy).version(), 1);
    
      upgradeLegacy();
      
      vm.prank(alice);
      assertEq(ILegacyProxy(legacyProxy).version(), 2);
   }
   function testRollback() public {
      vm.prank(alice);
      assertEq(ILegacyProxy(legacyProxy).version(), 1);

      upgradeLegacy();
      upgradeLegacy();

      assertEq(ILegacyProxy(legacyProxy).version(), 3);
       
      vm.prank(address(this));

      ILegacyProxy(legacyProxy).rollback();
      assertEq(ILegacyProxy(legacyProxy).version(), 4);
      assertEq(ILegacyProxy(legacyProxy).historyImplementation(4), ILegacyProxy(legacyProxy).historyImplementation(2));
   }
}