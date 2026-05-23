// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    // Owner ka address store karne ke liye
    address public owner;
    
    // Total kitna fund collect hua hai
    uint256 public totalCollected;
    
    // Kisne kitna donate kiya (Record rakhne ke liye)
    mapping(address => uint256) public donations;

    // Events: Blockchain par logs create karne ke liye
    event DonationReceived(address indexed donor, uint256 amount);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    // Constructor: Jab contract deploy hoga, tab deploy karne wala hi 'owner' ban jayega
    constructor() {
        owner = msg.sender;
    }

    // Modifier: Ek check lagane ke liye ki function sirf owner hi call kar sake
    modifier onlyOwner() {
        require(msg.sender == owner, "Sirf owner is function ko call kar sakta hai!");
        _;
    }

    // 1. Donate Function: Koi bhi is function ko use karke Ether bhej sakta hai
    function donate() public payable {
        require(msg.value > 0, "Donation amount 0 se zyada hona chahiye");
        
        donations[msg.sender] += msg.value;
        totalCollected += msg.value;
        
        emit DonationReceived(msg.sender, msg.value);
    }

    // 2. Withdraw Function: Sirf owner collected funds nikal sakta hai
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Nikalne ke liye koi balance nahi hai");
        
        (bool success, ) = payable(owner).call{value: balance}("");
require(success, "Transfer failed");
        emit FundsWithdrawn(owner, balance);
    }

    // 3. Get Balance Function: Contract mein kitna Ether pada hai check karne ke liye
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}