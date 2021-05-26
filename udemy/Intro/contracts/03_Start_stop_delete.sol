// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;


contract StartStopUpdateExample {
    
    // store the address of the creator/caller of this contract
    address public owner;
    
    // default value is always false
    bool public paused;
    
    /*  the constructor as to any JS class is called once during initialization of the class.
        in this case it will be called only once during the first deployment of the contract.
        So in this case the first caller of the contract will always be the owner of the contract.
    */
    constructor() {
        owner = msg.sender;
    }
    
    
    function setPaused(bool _paused) public {
        require(owner == msg.sender, "You are not the owner");
        paused = _paused;
    }
    
    
    // this contract receives ETH here
    function sendMoney() public payable {
        
    }
    
    
    // passing ann address as an argument, this contract will send 
    // all the money that has been sent to it to the address passed as param.
    function sendAllMoneyTo(address payable _to) public {
        
        /*
            REQUIRE KEYWORD
            
            require basically checks if a statement is true and if so 
            it executes the code i.e.
            
            if msg.sender === owner {
                _to.transfer(address(this).balance);
            }
        */
        
        // require works like guard let in swift, if the condition is met the code
        // goes forward else it throws exeption/error and everything that happend in this contract so far is rolled back.
        require(owner == msg.sender, "You are not authorised to operate here");
        require(!paused, "Contract is paused for the time being");
        _to.transfer(address(this).balance);
    }
    
    
    
    // https://ethereum-blockchain-developer.com/022-pausing-destroying-smart-contracts/04-destroy-smart-contracts/
    function destroySmartContract(address payable _to) public {
        require(owner == msg.sender, "NOPE!!!");
        selfdestruct(_to);
    }
}