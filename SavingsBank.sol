// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SavingsBank {
    address private owner;

    event Deposited(address sender, uint256 amount);
    event Withdrawn(address receiver, uint256 amount);

    // Adding constructor
    constructor() {
        // Here - address of the account that deployed the contract
        owner = msg.sender;
    }

    // Access control check
    modifier onlyOwner() {
        // Error if caller is not the owner
        require(msg.sender == owner, "Only the owner can do this.");
        _;
        // _; means "if everything is fine, continue executing the function"
    }

    // Allows depositing funds into the contract
    function deposit() external payable {
        // Checking if any funds were sent
        require(msg.value > 0, "You must send some Ether.");

        // Emitting event to show that someone sent funds
        emit Deposited(msg.sender, msg.value);
    }

    // Allows the owner to withdraw funds
    function withdraw() external onlyOwner {
        // Saving the current balance
        uint256 balance = address(this).balance;

        // Checking if there are funds to withdraw
        require(balance > 0, "No funds to withdraw.");

        // Sending all the funds to the contract owner
        payable(owner).transfer(balance);

        // Emitting event that funds were withdrawn
        emit Withdrawn(owner, balance);
    }

    // Returns the current contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

    // Request total number of donations
    function getDonationCount() external view returns (uint256) {
        return donations.length;
    }

    // Receiving a specific donation by index
    function getDonation(uint256 index) external view returns (address, uint256) {
        require(index < donations.length, "Invalid index");
        Donation memory d = donations[index];
        return (d.sender, d.amount);
    }
