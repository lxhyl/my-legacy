// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {EnumerableSet} from "openzeppelin-contracts/utils/structs/EnumerableSet.sol";
interface ILegacy {
   struct LegacyData {
      address testator;
      address beneficiary;
      address executor;
      uint256 lastActiveTime;
      uint256 executableWillDelay;
      uint256 executeSubmitTime;
      uint256 executeTime;
      EnumerableSet.AddressSet coins;
   }
   struct Config {
      address admin;
      uint256 minExecutableWillDelay;
      uint256 maxExecutableWillDelay;
      uint256 waitExecuteDelay;
   }


   event WriteWill(address indexed testator, address beneficiary, uint256 lastActiveTime, uint256 executableWillDelay);
   event AddCoinToWill(address indexed testator, address indexed coin);
   event ProofTestatorDead(address indexed testator, address submitor);
   event ProofTestatorNotDead(address indexed testator);
   event ExecuteCoinSuccess(address indexed testator, address coin);
   event ExecuteCoinFail(address indexed testator, address coin);
    
   event AdminChange(address o, address n);
   // error 
   error ZeroAddress();
   error WillNotExist();
 
   error NotLegalETHAmount(uint256 nowAmount);
   error NotLegalExecutableWillDelay(uint256 nowExecutableWillDelay);
   error NotYetSubmitableWill();
   error NotYetExecuteableWill();

   error WillAlreadyExecuteSubmit();
   error WillAlreadyExist();
   error WillAlreadyExecute();
   error WillAlreadyExecutable();
   
   error LegacyAlreadyInit();

   error OnlyThisLegacy();
   error OnlyTestator();
   error OnlyExecutor();
   error OnlyAdmin();

   error NotApproveMax(address coin);
   error CoinsTooMuch();


   // admin
   function init(
      address owner,
      uint256 minExecutableWillDelay,
      uint256 maxExecutableWillDelay,
      uint256 waitExecuteDelay
   ) external;

   // user
   function writeCoinsWill(address beneficiary,uint256 executableWillDelay, address[] calldata coins) external;
   function addCoinsToWill(address[] calldata coins) external;
   function proofTestatorDead(address testator) payable external;
   function proofTestatorNotDead() payable external;
   function executeCoinsWill(address testator) external;
   function getApprovedMaxCoins(address[] calldata coins) external returns(address[] memory approvedCoins);

   // view
   function isApprovedMax(address coin,address owner) external view returns(bool);
   function getWill() external view returns(
      address testator,
      address beneficiary,
      address executor,
      uint256 writeWillTime,
      uint256 executableWillDelay,
      uint256 executeSubmitTime,
      uint256 executeTime,
      address[] memory coins
   ); 
   function getWillByTestator(address _testator) external view 
     returns(
      address testator,
      address beneficiary,
      address executor,
      uint256 writeWillTime,
      uint256 executableWillDelay,
      uint256 executeSubmitTime,
      uint256 executeTime,
      address[] memory coins
   );
   function getConfig() external view returns(Config memory);
}
