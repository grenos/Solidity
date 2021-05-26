// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

// importing library locally for now
// https://openzeppelin.com/contracts/
import "../Libraries//SafeMath.sol";

contract Libraries {
    
    /*
        declare the use of a library for specific set of values in the contract
        
        if you are using the keyword "for" and the library has a funciton that takes two params 
        the first arg will always be the the variable itsekf on which you attach the function.
        
        For example:
        
        function add(uint256 a, uint256 b) internal pure returns (uint256) {
            return a + b;
        }
        
        this function above without the "for" keyword it has to be used like so:
        
        add(5, 10)
        
        but if using the "for" keyword:
        
        uint num1 = 5
        uint num2 = 10
        
        num1.add(num2)
    */
    using SafeMath for uint;
    
    mapping(address => uint) public tokenBalance;
     
    constructor() {
        tokenBalance[msg.sender] = 10;
    }
     
     
    function sendToken(address _to, uint _amount) public returns(bool) {
        /*
            This eventhough it makes sense to directly mutate the state of the contract 
            it doesn't work. it doesn't mutate the state at all.
        
            tokenBalance[msg.sender].sub(_amount);
            tokenBalance[_to].add(_amount);
        */
        
        tokenBalance[msg.sender] = tokenBalance[msg.sender].sub(_amount);
        tokenBalance[_to] = tokenBalance[_to].add(_amount);
         
        return true;
    }
}





