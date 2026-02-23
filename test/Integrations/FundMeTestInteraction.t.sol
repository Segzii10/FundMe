// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundFundMe} from "../../script/Interactions.s.sol";

contract FundMeTestIntegration is Test {
    FundMe fundMe;
    uint256 constant SEND_VALUE = 0.1 ether;
    address USER = makeAddr("USER");
    uint256 constant BALANCE = 10e18;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(address(fundFundMe), SEND_VALUE);
        fundFundMe.fundfundMe(address(fundMe));
        address funder = fundMe.getAddressThatFunded(0);
        assertEq(funder, address(fundFundMe));
    }

    function testOwnerCanWithdrawInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(address(fundFundMe), SEND_VALUE);
        fundFundMe.fundfundMe(address(fundMe));

        WithdrawFundFundMe withdrawFundFundMe = new WithdrawFundFundMe();
        withdrawFundFundMe.WithdrawfundfundMe(address(fundMe));
        assert(address(fundMe).balance == 0);
    }
}
