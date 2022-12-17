// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {ILegacy} from "./Interfaces/ILegacy.sol";
import {EnumerableSet} from "openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import {IERC20} from "openzeppelin-contracts/interfaces/IERC20.sol";
contract Legacy is ILegacy {
    uint16 public constant version = 1;
    
    mapping(address => LegacyData) legacyDatas;
    function writeCoinsWills(address beneficiary, uint256 executableWillsDelay, address[] calldata coins) external {
       LegacyData storage legacyData = legacyDatas[msg.sender];
    }
    function addCoinsToWills(address[] calldata coins) internal {
       LegacyData storage legacyData = legacyDatas[msg.sender];
       if(legacyData.testator == address(0)) revert WillNotExist();

    }

    function getApprovaledMaxCoins(address[] calldata coins) public returns(address[] memory approvaledCoins){
       approvaledCoins = new address[](coins.length);
       for(uint256 i; i < coins.length; i++){
         if(isApprovedMax(coins[i], msg.sender)){
           approvaledCoins[i] = coins[i];
         }
      }
      return approvaledCoins;
    }

    function isApprovedMax(address coin,address owner) internal view returns(bool) {
       if(coin == address(0)) return false;
       return IERC20(coin).allowance(owner,address(this)) == type(uint256).max;
    }   
}
