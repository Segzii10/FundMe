// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperNetworkConfig} from "../script/HelperNetworkConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperNetworkConfig helperNetworkConfig = new HelperNetworkConfig();
        address ethpriceUsd = helperNetworkConfig.activeNetworkConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethpriceUsd);
        vm.stopBroadcast();
        return fundMe;
    }
}
