// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {LegacyProxy} from "../src/LegacyProxy.sol";
import {Legacy} from "../src/Legacy.sol";

contract MyLegacyUpgrade is Script {
    address payable MY_LEGACY_PROXY = payable(0xc615627D0E044E9F8b5eaD860EC9E4a94f7829C1);
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Legacy legacy = new Legacy();
        LegacyProxy legacyProxy = LegacyProxy(MY_LEGACY_PROXY);
        legacyProxy.upgrade(address(legacy));
        vm.stopBroadcast();
    }
}
