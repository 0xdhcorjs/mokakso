// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Mycontract.sol";

contract CounterScript is Script {
    address public addr;
    function run() external {
        vm.startBroadcast();
        
        vm.stopBroadcast();
    }
}
