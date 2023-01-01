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
   function testUpgradeLegacy() public {
    
      vm.prank(alice);
      console.log("version",ILegacyProxy(legacyProxy).version());
      ILegacy legacyV2 = new Legacy();

      vm.prank(address(this));
      ILegacyProxy(legacyProxy).upgrade(address(legacyV2));

      vm.prank(alice);
      console.log("version",ILegacyProxy(legacyProxy).version());
   }
}