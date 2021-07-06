// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

contract AdAuction {
    
    struct Bidder {
        address bidder;
        uint amount;
    }

    struct WinnerData {
        string imageHash;
        string title;
    }
    
    Bidder public lastBidder;
    uint public bidIndex;
    WinnerData public winnerData;

    address public owner;
   
    mapping(uint => Bidder) public bidLog;
    
    event NewHigherBid(address from, uint amount);
    event NewWinningData( string imageHash, string title);

    constructor() {
        owner = msg.sender;
    }
    
    function bid(address _from, uint _amount) external payable {
        require(_amount > lastBidder.amount, "You must make a higher bid!");
        Bidder memory b = Bidder(_from, _amount);
        bidLog[bidIndex] = b;
        lastBidder = b;
        bidIndex ++;
        emit NewHigherBid(_from, _amount);
    }


    function setWinnerData(address _from, string memory _image, string memory _title) public {
        require(_from == lastBidder.bidder, "You are not the owner");
        WinnerData memory wd = WinnerData(_image, _title);
        winnerData = wd;
        emit NewWinningData(_image, _title);
    }
}