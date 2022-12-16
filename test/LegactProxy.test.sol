// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";

import {Base} from "./Base.t.sol";
import {ILegacy} from "../src/Interfaces/ILegacy.sol";
import {LegacyProxy} from "../src/LegacyProxy.sol";
contract LegacyV2 is ILegacy {
    function  getVersion() external pure returns(uint256){
      return 2;
    }
}


contract LegacyProxyTest is Base {
    function testUpgradeLegacy() public {
        vm.prank(address(0));
        console.log("1", ILegacy(legacyProxy).getVersion());
        vm.prank(address(this));
        LegacyProxy(payable(legacyProxy)).upgradeTo(address(new LegacyV2()));
        vm.prank(address(0));
        console.log("2", ILegacy(address(legacyProxy)).getVersion());
    }
}
