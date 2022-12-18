// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "forge-std/console.sol";

import {Base} from "./Base.t.sol";
import {ILegacy} from "../src/Interfaces/ILegacy.sol";
contract LegactTest is Base{ 
   function testGetApprovaledMaxCoins() public {
      vm.startPrank(alice);
      coin1.approve(legacyProxy, type(uint256).max);
      address[] memory coins = new address[](2);
      coins[0] = address(coin1);
      coins[1] = address(coin2);
      address[] memory approvedCoin = ILegacy(legacyProxy).getApprovedMaxCoins(coins);
      assertEq(approvedCoin[0],coins[0]);
      assertEq(approvedCoin.length,1);
   }

   function testProofNotDead() public {
      skip(27 weeks);
      bob.call{value:1 ether}("");
      vm.startPrank(bob);
      ILegacy(legacyProxy).proofTestatorDead{value:1 ether}(alice);
      assertEq(bob.balance, 0);
      vm.stopPrank();

      vm.startPrank(alice);
      skip(1 weeks);
      ILegacy(legacyProxy).proofTestatorNotDead();
      assertEq(bob.balance, 1 ether);
   }
   
   function testExcuteWill() public {
      skip(block.timestamp + 26 weeks);
      
      bob.call{value:1 ether}("");
      vm.startPrank(bob);
      ILegacy(legacyProxy).proofTestatorDead{value:1 ether}(alice);
      
      skip(5 weeks);
      
      uint256 bobETHBalanceBefore = bob.balance;
      uint256 bobBalanceBefore = coin1.balanceOf(bob);
      uint256 carlBalanceBefore = coin1.balanceOf(carl);
   
      ILegacy(legacyProxy).executeCoinsWill(alice);
      
      assertEq(bob.balance, bobETHBalanceBefore + 1 ether);
      assertEq(coin1.balanceOf(bob), 10 + bobBalanceBefore);
      assertEq(coin1.balanceOf(carl), 990 + carlBalanceBefore);
    
   }
}