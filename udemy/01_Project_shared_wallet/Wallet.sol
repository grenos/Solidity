// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Allowance.sol";


contract Wallet is Allowance {
    
    /*
        Override an existing function from another contract. (the Owned library in this case)
    */
    function renounceOwnership() public override pure {
        revert("This is not alowed");
    }
    
    event MoneyReceived(uint _amount, uint _newBalance);
    event MoneySpent(uint _amount, address _from);
    
    uint public totalDeposits;
    
    
    function receiveFunds() public payable {
        totalDeposits += msg.value;
        emit MoneyReceived(msg.value, totalDeposits);
    }
    
    receive() external payable {
       receiveFunds();
    }
    
    
    function reduceTotalDeposits(uint _amount) internal {
        totalDeposits -= _amount;
    }
    
    // you can pass a param to a modifier from the inheriting function
    function withdrawFunds(uint _amount, address payable _to) public ownerOrAllowed(_amount) {
        require(_amount <= totalDeposits, "Not enough funds!");
        if (owner() != msg.sender) {
            reduceAllowance(msg.sender, _amount);
        }
        
        reduceTotalDeposits(_amount);
        emit MoneySpent(_amount, msg.sender);
        _to.transfer(_amount);
    }
}
