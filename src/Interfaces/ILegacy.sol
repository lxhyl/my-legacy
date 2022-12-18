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
    
    event WriteWill(address indexed testator, address beneficiary, uint256 lastActiveTime, uint256 executableWillDelay);
    event AddCoinToWill(address indexed testator, address indexed coin);
    event ProofTestatorDead(address indexed testator, address submitor);
    event ProofTestatorNotDead(address indexed testator);
    event ExecuteCoinSuccess(address indexed testator, address coin);
    event ExecuteCoinFail(address indexed testator, address coin);

    // error 
    error ZeroAddress();
    error WillNotExist();
    error WillAlreadyExist();
    error NotLegalETHAmount(uint256 nowAmount);
    error NotLegalExecutableWillDelay(uint256 nowExecutableWillDelay);
    error NotYetSubmitableWill();
    error NotYetExecuteableWill();
    error WillExecuteAlreadySubmit();
    error WillAlreadyExecute();
    error WillAlreadyExecutable();
    error NotExecutor();
    error NotApproveMax(address coin);
    error OnlyLegacy();
    /**
    *
    * user functions
    *
    */
    function writeCoinsWill(address beneficiary,uint256 executableWillDelay, address[] calldata coins) external;
    function addCoinsToWill(address[] calldata coins) external;
    // function writeArbitraryExecutionWills(bytes[] calldata executeData) external;
    function proofTestatorDead(address testator) payable external;
    function proofTestatorNotDead() external;
    function executeCoinsWill(address testator) external;


    /**
    *
    *    view helper functions
    *
    */
    function getApprovedMaxCoins(address[] calldata coins) external returns(address[] memory approvedCoins);
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
}
