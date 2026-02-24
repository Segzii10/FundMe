// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function fundfundMe(address mostrecentlydeployed) public {
        FundMe(payable(mostrecentlydeployed)).fund{value: SEND_VALUE}();
        console.log("FundMe contract has been funded with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        fundfundMe(mostRecentDeployed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function WithdrawfundfundMe(address mostrecentlydeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostrecentlydeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        WithdrawfundfundMe(mostRecentDeployed);
        vm.stopBroadcast();
    }
}
