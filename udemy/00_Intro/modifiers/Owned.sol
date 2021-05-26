// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

contract Owned {
    address owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    
    modifier onlyOwner() {
        require(owner == msg.sender, "You must be the owner of this contract.");
        /*
            functions that have the onlyOwner() keyword will work as follows
            the compiler will take the contents of that funciton and copy them 
            in place of this underscore. Then it will copy the entire contents of this function on the 
            function using the onlyOwner modifier. So in this case the "require" guard will run first
            and the the contents of the functions below. (createNewToken, burnToken)
        */
        _;
    }
}