// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    uint256 constant SEND_VALUE = 0.1 ether;
    address USER = makeAddr("USER");
    uint256 constant BALANCE = 10e18;

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, BALANCE);
    }

    function testMinimumUsdisFive() external view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
        console.log("Hello World");
    }

    function testMsgsenderistheOwner() external view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionisAccurate() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testNotEnoughEthFails() external {
        vm.expectRevert();
        fundMe.fund{value: 3}();
    }

    function testAmountFundedandUpdateTheSender() external funded {
        uint256 amountFundedbyUser = fundMe.getAmountFundedbyUser(USER);
        assertEq(amountFundedbyUser, SEND_VALUE);
    }

    function testAddressAtParticularIndex() external funded {
        address funder = fundMe.getAddressThatFunded(0);
        assertEq(funder, USER);
    }

    function testIfOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testOnlyOwnerWillWithdraw() public funded {
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 EndingOwnerBalance = startingOwnerBalance + SEND_VALUE;
        uint256 EndingContractBalance = startingFundMeBalance - SEND_VALUE;

        assertEq(EndingContractBalance, 0);
        assertEq(EndingOwnerBalance, startingFundMeBalance + startingOwnerBalance);
    }

    function testAfterWithdrawalbalance() public funded {
        vm.prank(msg.sender);
        fundMe.withdraw();
        assertEq(0, address(fundMe).balance);
    }

    function testAmountReceivedThroughFund() public {
        uint256 startingFundMeBalance = address(fundMe).balance;
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        uint256 NewFundMeBalance = startingFundMeBalance + SEND_VALUE;
        assertEq(NewFundMeBalance, address(fundMe).balance);
    }

    function testWithdrawalbyMultipleFunders() public funded {
        uint160 numberofaddressfunded = 10;
        uint160 startingnumberofaddressfunded = 1;

        for (uint160 i = startingnumberofaddressfunded; i < numberofaddressfunded; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        assertEq(startingOwnerBalance + startingFundMeBalance, fundMe.getOwner().balance);
    }

    function testcheaperWithdrawalbyMultipleFunders() public funded {
        uint160 numberofaddressfunded = 10;
        uint160 startingnumberofaddressfunded = 1;

        for (uint160 i = startingnumberofaddressfunded; i < numberofaddressfunded; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.Cheaperwithdraw();

        assertEq(startingOwnerBalance + startingFundMeBalance, fundMe.getOwner().balance);
    }
}
