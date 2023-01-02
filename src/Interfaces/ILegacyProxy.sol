// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ILegacyProxy {
   error ImplementationNotFound(uint256 version);
   
   function version() view external virtual returns(uint256);
   function historyImplementation(uint256 version) view external virtual returns(address);

   function upgrade(address newImplementation) external;
   function rollback() external;
   function backToVersion(uint256 toVersion) external;
}