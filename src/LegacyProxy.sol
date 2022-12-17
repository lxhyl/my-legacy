// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {TransparentUpgradeableProxy} from "openzeppelin-contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract LegacyProxy is TransparentUpgradeableProxy {
    constructor(address _implemntation)
        TransparentUpgradeableProxy(_implemntation, msg.sender, "")
    {}
}
