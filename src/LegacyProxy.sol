// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {TransparentUpgradeableProxy} from "openzeppelin-contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import {ILegacyProxy} from "./Interfaces/ILegacyProxy.sol";
contract LegacyProxy is ILegacyProxy,TransparentUpgradeableProxy {
    uint16 public override version  = 1;
    constructor(address _implemntation)
        TransparentUpgradeableProxy(_implemntation, msg.sender, "")
    {}
    function upgrade(address newImplementation) external ifAdmin {
        if(newImplementation == address(0) || newImplementation.code.length == 0) revert ImplementationNotLegal(newImplementation);
        _upgradeToAndCall(newImplementation, bytes(""), false);
        version++;
    }
}
