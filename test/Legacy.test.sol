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

   function testWriteCoinsWill() public {
      vm.startPrank(alice);
      coin1.approve(legacyProxy, type(uint256).max);

      address testator = alice;
      address beneficiary = bob;
      uint256 executableWillDelay = 26 weeks;
      address[] memory coins = new address[](2);
      coins[0] = address(coin1);
      coins[1] = address(coin2);
      ILegacy(legacyProxy).writeCoinsWill(beneficiary, executableWillDelay, coins);
      (
       address _testator,
       address _beneficiary,
       address _executor,
       uint256 _writeWillTime,
       uint256 _executableWillDelay,
       address[] memory _coins
      ) = ILegacy(legacyProxy).getWill();
      
      assertEq(testator, _testator);
      assertEq(beneficiary, _beneficiary);
      assertEq(executableWillDelay, _executableWillDelay);
      assertEq(coins[0], address(coin1));
      console.log("_writeWillTime",_writeWillTime);
   }
}