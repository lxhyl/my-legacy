// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {TransparentUpgradeableProxy} from "openzeppelin-contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import {ILegacyProxy} from "./Interfaces/ILegacyProxy.sol";
contract LegacyProxy is ILegacyProxy,TransparentUpgradeableProxy {
    uint256 public override version  = 1;
    
    // version => implementation address
    mapping(uint256 => address) public override historyImplementation;
    constructor(address implementationInit,bytes memory initCallData)
        TransparentUpgradeableProxy(implementationInit, msg.sender, initCallData)
    {
       historyImplementation[version] = implementationInit;
    }
    function upgrade(address newImplementation) public ifAdmin {
        version++;
        historyImplementation[version] = newImplementation;
        _upgradeToAndCall(newImplementation, bytes(""), false);
    }

    function rollback() external {
      backToVersion(version - 1);
    }
    function backToVersion(uint256 toVersion) public ifAdmin{
       address implementationByVersion = historyImplementation[toVersion];
       if(implementationByVersion == address(0)) revert ImplementationNotFound(toVersion);
       upgrade(implementationByVersion);
    }
}
