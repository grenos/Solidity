// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

contract EventExample {
    
    mapping(address => uint) tokenBalance;
    
    /*
        We use events to return values after a transaction is finished
        
        We use events to do 3 things
        
        1) return values 
        
            use to return values or basically inform that a transaction was mined (or reverted maybe).
        
        2) trigger functionality externaly
        
            can also b used as listeners. An event can be trigger under some condition inside the contract
            and then an external source that is listening for the event can react to it.

        3) used as a cheap data storage
        
        
        An event can also have indexed params that as the world says will be indexed thus
        searchable later on by their hash 
        
        To index a param we need to add the keyword indexed and we can index up to 3 params on 
        an event 
        event TokenSend(address indexed _from, address indexed _to, uint _amount);
    */
    event TokenSend(address _from, address _to, uint _amount);
    
    constructor() {
        tokenBalance[msg.sender] = 100;
    }
    
    
    function sendToken(address _to, uint _amount) public returns(bool) {
        // check if amount requested to send is not more than what the user actually holds.
        require(tokenBalance[msg.sender] >= _amount, "Not enough tokens");
        // check if the balance of the adress to send tokens plus the amount to send
        // does NOT result in a lower number (that will mean that we have a wrap around of the uint)
        assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);
        // check that the balance of the sender minus the amount to send results in a samller number 
        // (if not means that the number whent to 0 and then wrapped around to a higher number)
        assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);
        
        tokenBalance[msg.sender] -= _amount;
        tokenBalance[_to] += _amount;
        
        // emit (return) the event with the actual values
        emit TokenSend(msg.sender, _to, _amount);
        
        return true;
    }
}