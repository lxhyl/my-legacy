// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {ILegacy} from "./Interfaces/ILegacy.sol";
import {EnumerableSet} from "openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import {IERC20} from "openzeppelin-contracts/interfaces/IERC20.sol";
import {Address} from "openzeppelin-contracts/utils/Address.sol";

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
      legacyData.lastActiveTime = block.timestamp;
      legacyData.executableWillDelay = executableWillDelay;
      emit WriteWill(msg.sender, beneficiary, block.timestamp, executableWillDelay);
      addCoinsToWill(coins);
   }


   function addCoinsToWill(address[] calldata coins) public {
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

   function proofTestatorDead(address testator) payable external {
      if(testator == address(0)) revert ZeroAddress();
      if(msg.value != 1 ether) revert NotLegalETHAmount(msg.value);

      LegacyData storage legacyData = legacyDatas[testator];

      if(legacyData.testator != testator) revert WillNotExist();
      if(legacyData.lastActiveTime + legacyData.executableWillDelay <= block.timestamp) revert NotYetSubmitableWill();
      if(legacyData.executor != address(0)) revert WillExecuteAlreadySubmit();

      legacyData.executor = msg.sender;
      legacyData.executeSubmitTime = block.timestamp;
   } 

   function proofTestatorNotDead() external {
      LegacyData storage legacyData = legacyDatas[msg.sender];
      if(legacyData.testator == address(0)) revert WillNotExist();
      if(legacyData.executeTime != 0) revert WillAlreadyExecute();
      if(block.timestamp > legacyData.lastActiveTime + legacyData.executableWillDelay + 4 weeks) revert WillAlreadyExecutable();
      legacyData.lastActiveTime = block.timestamp;
      address executor = legacyData.executor;
      if(executor != address(0)){
         legacyData.executor = address(0);
         legacyData.executeSubmitTime = 0;
         Address.sendValue(payable(executor),1 ether);
      }
   }


   function executeCoinsWill(address testator) external {
      if(testator == address(0)) revert ZeroAddress();
      LegacyData storage legacyData = legacyDatas[testator];
      if(legacyData.executor != msg.sender) revert NotExecutor();
      if(legacyData.lastActiveTime + legacyData.executableWillDelay + 4 weeks <= block.timestamp) revert NotYetExecuteableWill(); 
   
      for(uint256 i; i < legacyData.coins.length(); i++){
         address coin = legacyData.coins.at(i);
         try this.sendCoinToBeneficiaryExecutor(coin,testator,legacyData.beneficiary,msg.sender) {
            emit ExecuteCoinSuccess(testator, coin);
         }catch {
            emit ExecuteCoinFail(testator, coin);
         }
      }
   }

   function sendCoinToBeneficiaryExecutor(address coin,address testator, address beneficiary,address executor) public {
       if(msg.sender != address(this)) revert OnlyLegacy();
       uint256 approvedAmount = IERC20(coin).allowance(testator,address(this));
       uint256 balance = IERC20(coin).balanceOf(testator);
       uint256 beneficiaryAmount = balance * 99 / 100;
       uint256 executorAmount = balance - beneficiaryAmount;
       if(approvedAmount < balance) return;
       IERC20(coin).transferFrom(testator,address(this),balance);  
       IERC20(coin).transfer(beneficiary, beneficiaryAmount);
       IERC20(coin).transfer(executor, executorAmount);
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
       uint256 lastActiveTime,
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
       uint256 lastActiveTime,
       uint256 executableWillDelay,
       address[] memory coins
   ) {
      LegacyData storage legacyData = legacyDatas[_testator];
      testator = legacyData.testator;
      beneficiary = legacyData.beneficiary;
      executor = legacyData.executor;
      lastActiveTime = legacyData.lastActiveTime;
      executableWillDelay = legacyData.executableWillDelay;
      coins = legacyData.coins.values();
   }
}
