// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ILegacyProxy {
   error ImplementationNotLegal(address implementation);

   function version() external virtual returns(uint16);
   function upgrade(address newImplementation) external;
}