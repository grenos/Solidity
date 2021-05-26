// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

contract Exeptions {
    
    mapping(address => uint64) public balanceReceived;
    
    
    function receiveFunds() public payable {
        /*
            It's better to use asert for internal state validation
            
            We use assert here to control that the amount sent + the amount in a user's balance 
            is not too big and it won't  cause the variable to wrap-around 
            (exceed it full limiy of 64bit and restart from zero)
            
            When assert fails it will revert all high level functions 
            done up to this point BUT will not return any remaining GAS
            
            --NOTE -- on solidity 0.8 and above this example is handled automatically 
            and doesn't need an assert to handle wrap-around problems.
        */
        assert(balanceReceived[msg.sender] + uint64(msg.value) >= balanceReceived[msg.sender]);
        
        // uint64() converts a uint to another uint (uint64, uint216, etc)
        balanceReceived[msg.sender] += uint64(msg.value);
    }
    
    
    function withdrawFunds(address payable _to, uint64 _amount) public {
        /*
            It's better to use require for input validation. 
            When a equire fails it will revert all high level functions 
            done up to this point and will also return any remain GAS
            
            can also be use as so for cases where you want to do more things??
            if (_amount <= balanceReceived[msg.sender]) {
                revert("Not enough ETH")
            }
        */
        require(_amount <= balanceReceived[msg.sender], "Not enough ETH");
        
        // same as receiveFunds function
        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
        
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);

    }
}