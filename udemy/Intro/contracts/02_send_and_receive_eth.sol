// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;


/*
    solidity offers a global object called "Mesage Object".
    In this object there are available some methods that we can use.

*/


/*
    Every smart contract is deployed with its own address
    If we send ether to a smart contract the ledger sees 
    that in that address there are ether stored.
*/


contract TransferFunds {
    
    uint public balanceReceived;
    
    
    /*
        We add the keyword payable so the compiler knows that 
        this function is receiving money.
    */
    function receiveMoney() public payable {
        // adds the funds received by this address on a local variable
        balanceReceived += msg.value;
    }
    
    
    
    /*
        Using "this" we are refering to the current instance of the contract.
        So in this way we get access to this contract's address and its balance.
    */
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    
    
    /*
        Send money to the address that called this contract.
        We use the keyword "payable" for obvious reasons.
        The address of the person who called this contract is iside the 
        message object on the "sender" key.
    */
    function withdrawMoney() public {
        // inside the "to" variable we save the address
        address payable to = payable(msg.sender);
        // the address has the method .transfer() that we use to transfer ether
        // we transfer the whole amount saved on this contract
        to.transfer(this.getBalance());
    }
    
    
    /*
        Sending money, passing a specified address
    */
    function sendMoneyTo(address payable _to) public {
        _to.transfer(this.getBalance());
    }
}



