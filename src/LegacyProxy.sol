// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import {Clones} from "openzeppelin-contracts/proxy/Clones.sol";
import {ERC1967Upgrade} from "openzeppelin-contracts/proxy/ERC1967/ERC1967Upgrade.sol";
import {Ownable2Step} from "openzeppelin-contracts/access/Ownable2Step.sol";

contract LegacyProxy is Ownable2Step, ERC1967Upgrade {
    function upgradeLegacy(address implemntation)
        external
        onlyOwner
        returns (address)
    {
        address newImplemntation = Clones.cloneDeterministic(
            implemntation,
            _getSalt()
        );
        _upgradeTo(newImplemntation);
        return newImplemntation;
    }

    function _getSalt() internal view returns (bytes32) {
        return
            keccak256(abi.encodePacked(msg.sender, gasleft(), block.timestamp));
    }
}
