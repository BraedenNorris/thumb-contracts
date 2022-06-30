// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ThumbPortal.sol";

contract MyScript is Script {
    function setUp() public {}

    function run() external {
        vm.startBroadcast();

        ThumbPortal thumbPortal = new ThumbPortal();

        vm.stopBroadcast();
    }
}
