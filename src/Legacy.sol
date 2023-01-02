// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {ILegacy} from "./Interfaces/ILegacy.sol";
import {EnumerableSet} from "openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import {IERC20} from "openzeppelin-contracts/interfaces/IERC20.sol";
import {Address} from "openzeppelin-contracts/utils/Address.sol";

contract Legacy is ILegacy{
   using EnumerableSet for EnumerableSet.AddressSet;

   mapping(address => LegacyData) legacyDatas;
   
   Config config;


   modifier onlyAdmin() {
      if(config.admin != msg.sender) revert OnlyAdmin();
      _;
   }

   modifier onlyTestator() {
     if(legacyDatas[msg.sender].testator != msg.sender) revert OnlyTestator();
     _;
   }
   modifier onlyThisLegacy() {
     if(msg.sender != address(this)) revert OnlyThisLegacy();
     _;
   }
   modifier onlyExecutor(address testator) {
      if(legacyDatas[testator].executor != msg.sender) revert OnlyExecutor();
      _;
   }
   

   function init(
      address admin,
      uint256 minExecutableWillDelay,
      uint256 maxExecutableWillDelay,
      uint256 waitExecuteDelay
   ) external {
     if(config.admin != address(0)) revert LegacyAlreadyInit();
     config = Config(admin,minExecutableWillDelay,maxExecutableWillDelay,waitExecuteDelay);
   }
   
   function writeCoinsWill(address beneficiary, uint256 executableWillDelay, address[] calldata coins) external {
      if(beneficiary == address(0)) revert ZeroAddress();
      if(executableWillDelay < config.minExecutableWillDelay || executableWillDelay > config.maxExecutableWillDelay) revert NotLegalExecutableWillDelay(executableWillDelay);
     
      LegacyData storage legacyData = legacyDatas[msg.sender];

      if(legacyData.testator != address(0)) revert WillAlreadyExist();

      legacyData.testator = msg.sender;
      legacyData.beneficiary = beneficiary;
      legacyData.lastActiveTime = block.timestamp;
      legacyData.executableWillDelay = executableWillDelay;
      emit WriteWill(msg.sender, beneficiary, block.timestamp, executableWillDelay);
      addCoinsToWill(coins);
   }


   function addCoinsToWill(address[] calldata coins) onlyTestator  public {
      LegacyData storage legacyData = legacyDatas[msg.sender];
      if(legacyData.testator == address(0)) revert WillNotExist();
      uint256 coinLength = coins.length;
      if(coinLength > 100) revert CoinsTooMuch();
      for(uint256 i; i < coinLength; i++){
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
      if(legacyData.lastActiveTime + legacyData.executableWillDelay >= block.timestamp) revert NotYetSubmitableWill();
      if(legacyData.executor != address(0)) revert WillAlreadyExecuteSubmit();

      legacyData.executor = msg.sender;
      legacyData.executeSubmitTime = block.timestamp;
   } 

   function proofTestatorNotDead() payable onlyTestator external {
      LegacyData storage legacyData = legacyDatas[msg.sender];
      if(legacyData.executeTime != 0) revert WillAlreadyExecute();
      if(block.timestamp > legacyData.lastActiveTime + legacyData.executableWillDelay + 4 weeks) revert WillAlreadyExecutable();
      
      // update last active time
      legacyData.lastActiveTime = block.timestamp;
      address executor = legacyData.executor;
      // already have an executor.
      if(executor != address(0)){
         legacyData.executor = address(0);
         legacyData.executeSubmitTime = 0;
         Address.sendValue(payable(executor),1 ether);
      }
   }


   function executeCoinsWill(address testator) external onlyExecutor(testator){
      if(testator == address(0)) revert ZeroAddress();
      LegacyData storage legacyData = legacyDatas[testator];
      if(legacyData.executeTime != 0) revert WillAlreadyExecute();
      if(legacyData.lastActiveTime + legacyData.executableWillDelay + 4 weeks > block.timestamp) revert NotYetExecuteableWill(); 
   

      legacyData.executeTime = block.timestamp;
      for(uint256 i; i < legacyData.coins.length(); i++){
         address coin = legacyData.coins.at(i);
         try this.sendCoinToBeneficiaryExecutor(coin,testator,legacyData.beneficiary,msg.sender) {
            emit ExecuteCoinSuccess(testator, coin);
         }catch {
            emit ExecuteCoinFail(testator, coin);
         }
      }
      // executor's staked 1 ether
      Address.sendValue(payable(msg.sender), 1 ether);

   }

   function sendCoinToBeneficiaryExecutor(address coin,address testator, address beneficiary,address executor) onlyThisLegacy public {
      uint256 approvedAmount = IERC20(coin).allowance(testator,address(this));
      uint256 balance = IERC20(coin).balanceOf(testator);
      if(approvedAmount < balance) return;
      uint256 beneficiaryAmount = balance * 99 / 100;
      uint256 executorAmount = balance - beneficiaryAmount;
   
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
      uint256 executeSubmitTime,
      uint256 executeTime,
      address[] memory coins
   )  {
      return getWillByTestator(msg.sender);
   }

   function getWillByTestator(address _testator) public view 
     returns(
      address testator,
      address beneficiary,
      address executor,
      uint256 lastActiveTime,
      uint256 executableWillDelay,
      uint256 executeSubmitTime,
      uint256 executeTime,
      address[] memory coins
   ) {
      LegacyData storage legacyData = legacyDatas[_testator];
      testator = legacyData.testator;
      beneficiary = legacyData.beneficiary;
      executor = legacyData.executor;
      lastActiveTime = legacyData.lastActiveTime;
      executableWillDelay = legacyData.executableWillDelay;
      executeSubmitTime = legacyData.executeSubmitTime;
      executeTime = legacyData.executeTime;
      coins = legacyData.coins.values();
   }
   function getConfig() external view returns (Config memory) {
      return config;
   }
   /**
   * 
   *  ADMIN 
   *
   */
   function setOwner(address newAdmin) external onlyAdmin {
     if(newAdmin == address(0)) revert ZeroAddress();
     config.admin = newAdmin;
   }
}
