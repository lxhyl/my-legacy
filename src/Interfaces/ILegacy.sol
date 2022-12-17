// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {EnumerableSet} from "openzeppelin-contracts/utils/structs/EnumerableSet.sol";
interface ILegacy {
    struct LegacyData {
       address testator;
       address beneficiary;
       address executor;
       uint256 writeWillTime;
       uint256 executableWillDelay;
       EnumerableSet.AddressSet coins;
    }
    
    event WriteWill(address indexed testator, address beneficiary, uint256 writeWillTime, uint256 executableWillDelay);
    event AddCoinToWill(address indexed testator, address indexed coin);

    // error 
    error ZeroAddress();
    error WillNotExist();
    error WillAlreadyExist();
    error NotLegalExecutableWillDelay(uint256 nowExecutableWillDelay);


    /**
    *
    * user functions
    *
    */
    function writeCoinsWill(address beneficiary,uint256 executableWillDelay, address[] calldata coins) external;
    function addCoinsToWills(address[] calldata coins) external;
    // function writeArbitraryExecutionWills(bytes[] calldata executeData) external;
    // function proofTestatorDead(address testator) external;
    // function proofTestatorNotDead() external;



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
       address[] memory coins
   );
   function getWillByAddress(address _testator) external view 
     returns(
       address testator,
       address beneficiary,
       address executor,
       uint256 writeWillTime,
       uint256 executableWillDelay,
       address[] memory coins
   );
}
