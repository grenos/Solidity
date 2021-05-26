// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;


/*
    Mappings is like a dynamically created object.
    when it's first created it looks something like this.
    
    myMappings = {
        "..." : false,
    }
    
    If we don't set any value in it, checking its getter function (for any possible key)
    will always return false. Basically saying that none of these requested values is 
    in that object.
    
    myMappings[123] == false
    myMappings[0] == false
    myMappings[90] == false
    
    Once we create a setter function and add a key in the object it will automatically 
    map this key with a value of true (or the value that we specified in its declaration)
    
*/

contract Mappings {
    mapping(uint => bool) public myMappings;
    mapping(address => bool) public myAddressMapping;
    
    function setValue(uint _key) public {
        myMappings[_key] = true;
    }
    
    function setMyAddressToTrue() public {
        myAddressMapping[msg.sender] = true;
    }
}