// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {EnumerableSet} from "openzeppelin-contracts/utils/structs/EnumerableSet.sol";
interface ILegacy {
    struct LegacyData {
       address testator;
       address beneficiary;
       address executor;
       uint256 writeWillsTime;
       uint256 executableWillsDelay;
       EnumerableSet.AddressSet coins;
    }
    
    // error 
    error ZeroAddress();
    error WillNotExist();

    error NotLegalExecutableWillsDelay(uint256 nowExecutableWillsDelay);

    function getApprovaledMaxCoins(address[] calldata coins) external returns(address[] memory approvaledCoins);
    // user functions
    function writeCoinsWills(address beneficiary,uint256 executableWillsDelay, address[] calldata coins) external;
    // function writeArbitraryExecutionWills(bytes[] calldata executeData) external;
    // function proofTestatorDead(address testator) external;
    // function proofTestatorNotDead() external;
    
}
