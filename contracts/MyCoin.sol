// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contract -> DeFiOrganizational
contract MyCoin {
    // Estructura para almacenar la información de cada usuario
    struct User {
        uint256 balance;
        uint256 stakedAmount;
        bool isBorrowing;
        uint256 borrowedAmount;
    }

    mapping(address => User) public users;
    uint256 public totalSupply;
    uint256 public stakingPool;
    
    // Tasa de interés fija para préstamos
    uint256 public interestRate = 5; // 5%

    // Eventos
    event Deposit(address indexed user, uint256 amount);
    event Stake(address indexed user, uint256 amount);
    event Unstake(address indexed user, uint256 amount);
    event Borrow(address indexed user, uint256 amount);
    event Repay(address indexed user, uint256 amount);

    // Depósito de fondos
    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than 0");
        users[msg.sender].balance += msg.value;
        totalSupply += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Staking de tokens
    function stake(uint256 amount) external {
        require(users[msg.sender].balance >= amount, "Insufficient balance");
        users[msg.sender].balance -= amount;
        users[msg.sender].stakedAmount += amount;
        stakingPool += amount;
        emit Stake(msg.sender, amount);
    }

    // Unstake de tokens
    function unstake(uint256 amount) external {
        require(users[msg.sender].stakedAmount >= amount, "Insufficient staked amount");
        users[msg.sender].stakedAmount -= amount;
        users[msg.sender].balance += amount;
        stakingPool -= amount;
        emit Unstake(msg.sender, amount);
    }

    // Préstamo de fondos
    function borrow(uint256 amount) external {
        require(users[msg.sender].stakedAmount >= amount, "Insufficient collateral");
        require(!users[msg.sender].isBorrowing, "Already borrowing");
        users[msg.sender].isBorrowing = true;
        users[msg.sender].borrowedAmount = amount;
        users[msg.sender].balance += amount;
        stakingPool -= amount;
        emit Borrow(msg.sender, amount);
    }

    // Repago de préstamos
    function repay() external payable {
        require(users[msg.sender].isBorrowing, "Not borrowing");
        require(msg.value >= users[msg.sender].borrowedAmount + (users[msg.sender].borrowedAmount * interestRate / 100), "Insufficient repayment");
        users[msg.sender].balance -= users[msg.sender].borrowedAmount;
        users[msg.sender].isBorrowing = false;
        users[msg.sender].borrowedAmount = 0;
        stakingPool += msg.value;
        emit Repay(msg.sender, msg.value);
    }
}
