// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "./ItemManager.sol";

contract Item {
    uint public priceInWei;
    uint public index;
    uint public pricePaid;
    
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) {
        parentContract = _parentContract;
        priceInWei     = _priceInWei;
        index          = _index;
    }
    
    
    receive() external payable {
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei == msg.value, "Only full payments allowed");
        pricePaid += msg.value;
        // We use a low level "call()" so we can send more gas and trigger payment transactions 
        // in parent contract. Low level methods don't revert automatically in case we need to throw an exception.
        
        // here we call the function from the parent contract passing the msg value and the index of the current item
        //  (bool, success) --> this is how we get the return values from the "call()" method. It return two. One is the boolean in case of success
        // and the other would be a return value from the "triggerPayment" function (if it return something)
        (bool success,) = address(parentContract).call{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "The transaction wasn't successful, cancelling");
    }
}