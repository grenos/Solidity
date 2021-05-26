// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;


/*
    FUNCTION GETTERS AND SETTERS
    
    a writting function (transaction) requires a transaction to be mind on the blockchain
    a read function (call) is done against the local blockchain node and doesn't need a transaction
    
    a call is virtally free - even though you pay some gas to do a call - 
    reading from your own node means that you pay the gas to your self.
    
    
    FUNCTION VISIBILITY
    
    public -- can be called internally and externalyly --
    private -- only for the contract. Not externally reachable and not via derived contracts --
    external -- can be called from other contracts and can be called externally --
    internal -- only from the contract itself or from derive contracts. Can't be invoked by a transaction.
*/


contract Functions {
        
    mapping(address => uint64) public balanceReceived;
    
    address payable owner;
    
    constructor() {
        owner = payable(msg.sender);
    }
    
    
    // Functions with keyword "view" are only reading the state of the contract
    function getOwner() public view returns(address) {
        return owner;
    }
    
    
    // pure functions do not interact with internal state -- so do NOT produce any side effects.
    // a pure function can call another pure function but can not call another nomal function 
    // or even a view function.
    function convertWeiToEther(uint _amountToWei) public pure returns(uint) {
        // the "ether" keyword is -> 10000000000000000000 -- convinence keyword
        return _amountToWei / 1 ether;
    }
    
    
    function destroyContract() public {
        require(owner == msg.sender, "You are not the owner");
        selfdestruct(owner);
    }
    
    function receiveFunds() public payable {
        assert(balanceReceived[msg.sender] + uint64(msg.value) >= balanceReceived[msg.sender]);
        balanceReceived[msg.sender] += uint64(msg.value);
    }
    
    
    function withdrawFunds(address payable _to, uint64 _amount) public {
        require(_amount <= balanceReceived[msg.sender], "Not enough ETH");
        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
    
    
    
    // https://docs.soliditylang.org/en/latest/contracts.html#receive-ether-function
    receive() external payable {
        receiveFunds();
    }
}