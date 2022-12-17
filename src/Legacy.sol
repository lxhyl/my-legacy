// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {ILegacy} from "./Interfaces/ILegacy.sol";
import {EnumerableSet} from "openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import {IERC20} from "openzeppelin-contracts/interfaces/IERC20.sol";
contract Legacy is ILegacy {
    using EnumerableSet for EnumerableSet.AddressSet;
    
    uint16 public constant version = 2;
    
    mapping(address => LegacyData) legacyDatas;
    function writeCoinsWills(address beneficiary, uint256 executableWillsDelay, address[] calldata coins) external {
       LegacyData storage legacyData = legacyDatas[msg.sender];
    }
    function addCoinsToWills(address[] calldata coins) internal {
       LegacyData storage legacyData = legacyDatas[msg.sender];
       if(legacyData.testator == address(0)) revert WillNotExist();

    }

    function getApprovedMaxCoins(address[] calldata coins) public view returns(address[] memory approvedCoins){
       address[] memory approvedCoinsWithZeroAddress = new address[](coins.length);
       uint256 approvedCount;
       for(uint256 i; i < coins.length; i++){
         if(isApprovedMax(coins[i], msg.sender)){
           approvedCoinsWithZeroAddress[approvedCount++] = coins[i];
         }
      }
      
      approvedCoins = new address[](approvedCount);
      for(uint256 i; i < approvedCount; i++){
        approvedCoins[i] = approvedCoinsWithZeroAddress[i];
      }
      return approvedCoins;
    }

    function isApprovedMax(address coin,address owner) public view returns(bool) {
       if(coin == address(0)) return false;
       return IERC20(coin).allowance(owner,address(this)) == type(uint256).max;
    }
}
