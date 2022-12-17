// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {LegacyProxy} from "../src/LegacyProxy.sol";
import {Legacy} from "../src/Legacy.sol";
contract MyLegacy is Script {

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Legacy legacy = new Legacy();
        LegacyProxy legacyProxy = new LegacyProxy(address(legacy));
        console.log("legacyProxy",address(legacyProxy));
        vm.stopBroadcast();
    }
}
