// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SavingsBank - Decentralized Savings Contract
 * @notice Allows users to deposit ETH and tracks donations
 * @dev Implements owner-only withdrawals and donation tracking
 */
contract SavingsBank {
    /// @notice Contract owner address
    address private immutable _owner;

    /// @notice Track total deposits count
    uint256 private _totalDeposits;

    /// @notice Emitted when ETH is deposited
    /// @param sender Address of the depositor
    /// @param amount Amount deposited in wei
    event Deposited(address indexed sender, uint256 amount);

    /// @notice Emitted when ETH is withdrawn
    /// @param receiver Address that received the funds
    /// @param amount Amount withdrawn in wei
    event Withdrawn(address indexed receiver, uint256 amount);

    /// @notice Donation structure
    struct Donation {
        address sender;
        uint256 amount;
        uint256 timestamp;
    }

    /// @notice Array of all donations
    Donation[] private _donations;

    /// @notice Ensures caller is the owner
    modifier onlyOwner() {
        require(msg.sender == _owner, "Caller is not owner");
        _;
    }

    /// @notice Initializes contract with deploying address as owner
    constructor() {
        _owner = msg.sender;
    }

    /**
     * @notice Accepts ETH deposits
     * @dev Records donation with timestamp
     * Emits a {Deposited} event
     */
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be positive");
        _donations.push(Donation(msg.sender, msg.value, block.timestamp));
        _totalDeposits++;
        emit Deposited(msg.sender, msg.value);
    }

    /**
     * @notice Withdraws all contract ETH to owner
     * @dev Only callable by owner
     * Emits a {Withdrawn} event
     */
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds available");

        (bool success, ) = payable(_owner).call{value: balance}("");
        require(success, "Transfer failed");

        emit Withdrawn(_owner, balance);
    }

    // =========== VIEW FUNCTIONS =========== //

    /**
     * @notice Returns current contract balance
     * @return Current ETH balance in wei
     */
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @notice Returns total donation count
     * @return Number of donations received
     */
    function getDonationCount() external view returns (uint256) {
        return _donations.length;
    }

    /**
     * @notice Returns donation details by index
     * @param index Donation index to query
     * @return sender Donor address
     * @return amount Donation amount in wei
     * @return timestamp Block timestamp of donation
     */
    function getDonation(uint256 index) 
        external 
        view 
        returns (address sender, uint256 amount, uint256 timestamp) 
    {
        require(index < _donations.length, "Invalid index");
        Donation memory d = _donations[index];
        return (d.sender, d.amount, d.timestamp);
    }

    /**
     * @notice Returns contract owner address
     * @return Address of contract owner
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @notice Returns total deposits count
     * @return Number of successful deposits
     */
    function totalDeposits() external view returns (uint256) {
        return _totalDeposits;
    }
}
