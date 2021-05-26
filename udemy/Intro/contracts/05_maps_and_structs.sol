// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;


/*
    Using structs to define your own data types
    https://ethereum-blockchain-developer.com/026-mappings-and-structs/01-basic-smart-contract/
*/


contract Structs {
    
    struct Payment {
        uint amount;
        uint timestamp;
    }
    
    struct Balance {
        uint totalBalance; // default -> 0
        uint paymentsIndexKey; // default -> 0
        
        /*
            because mappings don't have a .length / .count property
            we keep a counter "paymentsIndexKey". This way we always know 
            the count of payments made + we can use it as keys on the payments map
            
            There are also iterable mappings we can use from external libraries
        */
        mapping(uint => Payment) payments;
    }
    
    
    // mappings can have: 
    // for keys any Solodity "primitive" value (bool, uint, string, address, etc)
    // anything else for value
    mapping(address => Balance) public balanceReceived;
    
    
    function getBalance() public view returns(uint) {
        // gets the balance stored in this contract
        // keyword this points to the address of this instance of the contract
        return address(this).balance;
    }
    
    
    function sendFunds() public payable {
        // store the amount of funds each address is sending to this contract
        balanceReceived[msg.sender].totalBalance += msg.value;
        
        // structs are reference types so we need to spcify where they will be stored
        Payment memory payment = Payment(msg.value, block.timestamp);
        
        /*
            here we keep an index to use as a key for every payment made 
            (because there isn't an automatic way to add a incremented key on every payment)
            
            es.
            
            payments = {
                0: Payment,
                1: Payment
                ...
            }
        */
        uint keyToUse = balanceReceived[msg.sender].paymentsIndexKey;
        balanceReceived[msg.sender].payments[keyToUse] = payment;
        balanceReceived[msg.sender].paymentsIndexKey++;
    }
    
    
    function withdrawAllFunds(address payable _to) public {
        /*
            Security concern -- Re-Entrancy and Checks-Effects-Interaction Pattern
            https://fravoll.github.io/solidity-patterns/checks_effects_interactions.html
            
            We could have sent the funds directly from the balanceReceived map
            but this poses a security threat.
            
            _to.transfer(balanceReceived[msg.sender]);
            balanceReceived[msg.sender] = 0;
            
            if we write it as it is above a hacker could re-call the contract 
            before we manage to set his new balance to 0. So in this case we would 
            re send him the amount that he already has withrawed.
            
             As a rule of thumb: You interact with outside addresses last, no matter what.
             --  _to.transfer(fundsToWithdraw); --
        
        */
        
        // get the amount of balance the sender has sent to this contract
        uint fundsToWithdraw = balanceReceived[msg.sender].totalBalance;
        balanceReceived[msg.sender].totalBalance = 0;
        _to.transfer(fundsToWithdraw);
    }
    
    
    
    function withdrawFunds(address payable _to, uint _amount) public {
        require(balanceReceived[msg.sender].totalBalance >= _amount, "You don't have enough funds in your account");
        balanceReceived[msg.sender].totalBalance -= _amount;
        _to.transfer(_amount);
    }
}


