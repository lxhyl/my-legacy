// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "forge-std/console.sol";

import {Base} from "./Base.t.sol";
import {ILegacy} from "../src/Interfaces/ILegacy.sol";
contract LegactTest is Base{ 
   function testGetApprovaledMaxCoins() public {
      vm.prank(alice);
      coin1.approve(legacyProxy, type(uint256).max);
      address[] memory coins = new address[](2);
      coins[0] = address(coin1);
      coins[1] = address(coin2);
      vm.prank(alice);
      address[] memory approvedCoin = ILegacy(legacyProxy).getApprovedMaxCoins(coins);
      assertEq(approvedCoin[0],coins[0]);
      assertEq(approvedCoin.length,1);
   }
}