// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {LegacyProxy} from "../src/LegacyProxy.sol";
import {Legacy} from "../src/Legacy.sol";

// LegacyProxy 0x94022093264FaD8f5c6134f40Ed9674C26b98601
contract MyLegacyUpgrade is Script {

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Legacy legacy = new Legacy();
        LegacyProxy legacyProxy = LegacyProxy(payable(address(0x94022093264FaD8f5c6134f40Ed9674C26b98601)));
        legacyProxy.upgradeTo(address(legacy));
        vm.stopBroadcast();
    }
}
