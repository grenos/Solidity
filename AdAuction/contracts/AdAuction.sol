// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;


contract AdAuction {
    
    struct Bidder {
        address bidder;
        uint amount;
    }
    
    Bidder public lastBidder;
    uint public bidIndex;
   
    mapping(uint => Bidder) public bidLog;
    
    event NewHigherBid(address from, uint amount);
    
    function bid(address _from, uint _amount) external payable {
        require(_amount > lastBidder.amount, "You must make a higher bid!");
        Bidder memory b = Bidder(_from, _amount);
        bidLog[bidIndex] = b;
        lastBidder = b;
        bidIndex ++;
        emit NewHigherBid(_from, _amount);
    }
}