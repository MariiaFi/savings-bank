// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SavingsBank {
    address private owner;

    event Deposited(address sender, uint256 amount);
    event Withdrawn(address receiver, uint256 amount);

    struct Donation {
        address sender;
        uint256 amount;
    }

    Donation[] public donations;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this.");
        _;
    }

    function deposit() external payable {
        require(msg.value > 0, "You must send some Ether.");
        donations.push(Donation(msg.sender, msg.value));
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw.");
        payable(owner).transfer(balance);
        emit Withdrawn(owner, balance);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getDonationCount() external view returns (uint256) {
        return donations.length;
    }

    function getDonation(uint256 index) external view returns (address sender, uint256 amount) {
        require(index < donations.length, "Invalid index");
        Donation memory d = donations[index];
        return (d.sender, d.amount);
    }
}
