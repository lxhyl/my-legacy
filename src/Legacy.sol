// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {ILegacy} from "./Interfaces/ILegacy.sol";
import {EnumerableSet} from "openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import {IERC20} from "openzeppelin-contracts/interfaces/IERC20.sol";
contract Legacy is ILegacy {
    using EnumerableSet for EnumerableSet.AddressSet;
    
    uint16 public constant version = 1;
    
    mapping(address => LegacyData) legacyDatas;

    function writeCoinsWill(address beneficiary, uint256 executableWillDelay, address[] calldata coins) external {
       if(beneficiary == address(0)) revert ZeroAddress();
       if(executableWillDelay < 10 weeks || executableWillDelay > 52 weeks) revert NotLegalExecutableWillDelay(executableWillDelay);
       LegacyData storage legacyData = legacyDatas[msg.sender];
       if(legacyData.testator != address(0)) revert WillAlreadyExist();
       legacyData.testator = msg.sender;
       legacyData.beneficiary = beneficiary;
       legacyData.writeWillTime = block.timestamp;
       legacyData.executableWillDelay = executableWillDelay;
       emit WriteWill(msg.sender, beneficiary, block.timestamp, executableWillDelay);
       addCoinsToWills(coins);
    }


    function addCoinsToWills(address[] calldata coins) public {
       LegacyData storage legacyData = legacyDatas[msg.sender];
       if(legacyData.testator == address(0)) revert WillNotExist();
       for(uint256 i; i < coins.length; i++){
          if(legacyData.coins.contains(coins[i])) continue;
          if(isApprovedMax(coins[i],msg.sender)){
             legacyData.coins.add(coins[i]);
             emit AddCoinToWill(msg.sender, coins[i]);
          }
       }
    }
    
    function isApprovedMax(address coin,address owner) public view returns(bool) {
       if(coin == address(0)) return false;
       return IERC20(coin).allowance(owner,address(this)) == type(uint256).max;
    }
    function getApprovedMaxCoins(address[] memory coins) public view returns(address[] memory approvedCoins){
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
    
    function getWill() external view returns(
       address testator,
       address beneficiary,
       address executor,
       uint256 writeWillTime,
       uint256 executableWillDelay,
       address[] memory coins
   )  {
      return getWillByAddress(msg.sender);
    }

    function getWillByAddress(address _testator) public view 
     returns(
       address testator,
       address beneficiary,
       address executor,
       uint256 writeWillTime,
       uint256 executableWillDelay,
       address[] memory coins
   ) {
      LegacyData storage legacyData = legacyDatas[_testator];
      testator = legacyData.testator;
      beneficiary = legacyData.beneficiary;
      executor = legacyData.executor;
      writeWillTime = legacyData.writeWillTime;
      executableWillDelay = legacyData.executableWillDelay;
      coins = legacyData.coins.values();
    }
}
