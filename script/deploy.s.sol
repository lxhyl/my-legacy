// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {LegacyProxy} from "../src/LegacyProxy.sol";
import {Legacy} from "../src/Legacy.sol";
import {ILegacy} from "../src/Interfaces/ILegacy.sol";
contract MyLegacy is Script {

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        address legacy = address(new Legacy());

        bytes memory initCalldata = abi.encodeWithSelector(Legacy.init.selector, address(0x366858498Eb1834b4a194B7d1454a92B28c6bf7e), 4 weeks, 520 weeks, 4 weeks);

        address legacyProxy = address(new LegacyProxy(legacy, initCalldata));
        
        vm.stopBroadcast();
    }
}
