// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;


/*
  importing is same as in JS
  import "../modifiers//Owned";
  import * as Example from "../modifiers//Owned";
  import {Example1 as Alias, Exmple2} from "../modifiers//Owned";
*/
import "../modifiers/Owned.sol";

/*
  "is" keywod is when we want to inherit from another contract
  multi inheritence is suported -> a is c,d,f
  if all c d f contracts have the same funciton we would call the one from the last inherited contract (f).

  using super you gain access and can call the functions of the parent contract.

  *** 
    inherited contracts are deployed as a single contract. So we dont really deploy 2 contracts in this case. 
    The compiler will compile those two contracts into one -- same goes for imports.
  ***
*/

contract InheritenceModifier is Owned {
    
    mapping(address => uint) public tokenBalance;

    uint tokenPrice = 1 ether;
    
    constructor() {
        // owner gets 100 token on creation to sell
        tokenBalance[owner] = 100;
    }
    

    /*
        If the tokens finish up the owner of the contract can create 
        new tokens (out of thin air)
    */
    function createNewToken() public onlyOwner {
        tokenBalance[owner]++;
    }
    
    // or burn tokens
    function burnToken() public onlyOwner {
        tokenBalance[owner]--;
    }
    

    /*
        You can purchase tokens
    */
    function prchaseToken() payable public {
        require((tokenBalance[owner] * tokenPrice) / msg.value > 0, "Not enough tokens to buy");
        tokenBalance[owner] -= msg.value / tokenPrice;
        tokenBalance[msg.sender] += msg.value / tokenPrice;
    }
    
    
    function sendTokens(address _to, uint _amount) public {

        require(tokenBalance[msg.sender] >= _amount, "Not enough tokens to send");

        assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);

        assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);
        
        tokenBalance[msg.sender] -= _amount;
        
        tokenBalance[_to] += _amount;
    }
    
    
}