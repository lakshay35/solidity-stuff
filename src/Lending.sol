pragma solidity 0.8.17;

import "openzeppelin/interfaces/IERC20.sol";

contract LendingProtocol {
    // The address of the underlying asset that can be lent and borrowed
    address public underlyingAsset;

    // The interest rate for lending and borrowing
    uint256 public interestRate;

    // The total amount of assets lent to the protocol
    uint256 public totalLent;

    // The total amount of assets borrowed from the protocol
    uint256 public totalBorrowed;

    // A mapping of user addresses to their lent and borrowed balances
    mapping(address => uint256) public userLentBalances;
    mapping(address => uint256) public userBorrowedBalances;

    constructor(address _underlyingAsset, uint256 _interestRate) {
        underlyingAsset = _underlyingAsset;
        interestRate = _interestRate;
    }

    // Function to deposit assets into the protocol
    function deposit(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");

        // Transfer the underlying assets to the protocol contract
        IERC20(underlyingAsset).transferFrom(msg.sender, address(this), amount);

        // Update the user's lent balance
        userLentBalances[msg.sender] += amount;

        // Update the total amount of assets lent to the protocol
        totalLent += amount;
    }

    // Function to borrow assets from the protocol
    function borrow(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");

        // Make sure the user has enough collateral
        require(userLentBalances[msg.sender] >= (amount * (100 + interestRate)) / 100, "Not enough collateral");

        // Update the user's borrowed balance
        userBorrowedBalances[msg.sender] += amount;

        // Update the total amount of assets borrowed from the protocol
        totalBorrowed += amount;

        // Transfer the underlying assets to the user
        IERC20(underlyingAsset).transfer(msg.sender, amount);
    }

    // Function to repay borrowed assets
    function repay(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");

        // Make sure the user has enough borrowed assets to repay
        require(userBorrowedBalances[msg.sender] >= amount, "Not enough borrowed assets to repay");

        // Update the user's borrowed balance
        userBorrowedBalances[msg.sender] -= amount;

        // Update the total amount of assets borrowed from the protocol
        totalBorrowed -= amount;

        // Transfer the underlying assets from the user to the protocol contract
        IERC20(underlyingAsset).transferFrom(msg.sender, address(this), amount);
    }

    // Function to withdraw lent assets
    function withdraw(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");

        // Make sure the user has enough lent assets to withdraw
        require(userLentBalances[msg.sender] >= amount, "Not enough lent assets to withdraw");

        // Update the user's lent balance
        userLentBalances[msg.sender] -= amount;

        // Update the total amount of assets lent to the protocol
        totalLent -= amount;

        // Transfer the underlying assets from the protocol contract to the user
        IERC20(underlyingAsset).transfer(msg.sender, amount);
    }
}
