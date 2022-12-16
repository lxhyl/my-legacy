// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ILegacy} from "./Interfaces/ILegacy.sol";
contract Legacy is ILegacy {
    function getVersion() external pure returns(uint256){
      return 1;
    }
}
