// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
// pragma solidity ^0.8.1;

import "./Token.sol";

contract dBank {

  Token private token;

  mapping(address => uint) public etherBalanceOf;
  mapping(address => uint) public depositStart;
  mapping(address => bool) public isDeposited;

  //add events
  event Deposit(address indexed _from, uint _amount, uint _timestart);
  event Withdraw(address indexed _to, uint balance, uint _depositTime, uint intrestInTokens);

  // we pass the contract here and its location on the blockchain (address)
  constructor(Token _token) {
    //assign token deployed contract to variable
    token = _token;
  }

  function deposit() payable public {
    //check if msg.sender didn't already deposited funds -- we don't let user deposit more money
    // if they haven't withdrawn any money first (arbitrary decision to support lending and borrowing for this example app)
    require(isDeposited[msg.sender] == false, "Error, deposit already active");
    //check if msg.value is >= than 0.01 ETH
    require(msg.value>=1e16, "Error, deposit must be bigger or equal to 0.1ETH");

    //increase msg.sender ether deposit balance
    etherBalanceOf[msg.sender] += msg.value;
    //start msg.sender hodling time
    depositStart[msg.sender] += block.timestamp;
    //set msg.sender deposit status to true
    isDeposited[msg.sender] = true;
    //emit Deposit event
    emit Deposit(msg.sender, msg.value, block.timestamp);
  }


  function withdraw() public {
    //check if msg.sender deposit status is true
    require(isDeposited[msg.sender] == true, "You need to make a deposit first!");

    //assign msg.sender ether deposit balance to variable for event
    uint userBalance = etherBalanceOf[msg.sender];

    //check user's hodl time by subtracting the deposti transaction timestamp with the timestamp
    // of the current transaction for the withdrawl
    uint depositTime = block.timestamp - depositStart[msg.sender];

    //31668017 - interest(10% APY) per second for min. deposit amount (0.01 ETH), cuz:
    //1e15(10% of 0.01 ETH) / 31577600 (seconds in 365.25 days)
    //(etherBalanceOf[msg.sender] / 1e16) - calc. how much higher interest will be (based on deposit), e.g.:
    //for min. deposit (0.01 ETH), (etherBalanceOf[msg.sender] / 1e16) = 1 (the same, 31668017/s)
    //for deposit 0.02 ETH, (etherBalanceOf[msg.sender] / 1e16) = 2 (doubled, (2*31668017)/s)
    //calc interest per second - the number 31668017 is annual 10% interest oer second?
    uint interestPerSecond = 31668017 * (etherBalanceOf[msg.sender] / 1e16);

    //calc accrued interest
    uint interest = interestPerSecond * depositTime;

    //send all eth to user
    msg.sender.transfer(userBalance);
   
    //send interest in tokens to user
    token.mint(msg.sender, interest);

    //reset depositer data
    etherBalanceOf[msg.sender] = 0;
    depositStart[msg.sender] = 0;
    isDeposited[msg.sender] = false;

    //emit event
    emit Withdraw(msg.sender, userBalance, depositTime, interest);
  }


  function borrow() payable public {
    //check if collateral is >= than 0.01 ETH
    //check if user doesn't have active loan

    //add msg.value to ether collateral

    //calc tokens amount to mint, 50% of msg.value

    //mint&send tokens to user

    //activate borrower's loan status

    //emit event
  }

  function payOff() public {
    //check if loan is active
    //transfer tokens from user back to the contract

    //calc fee

    //send user's collateral minus fee

    //reset borrower's data

    //emit event
  }
}