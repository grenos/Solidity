// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// needs to import this library to work
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    
     event AllowanceChanged(address indexed _for, uint _oldAmount, uint _newAmount);
     event AllowanceSet(address indexed _for, uint _amount);
    
    mapping(address => uint) public allowance;
    
    function setAllowance(uint _allowance, address _for) public onlyOwner {
        allowance[_for] = _allowance;
        emit AllowanceSet(_for, _allowance);
    }
    
    function reduceAllowance(address _for, uint _amount) internal {
        uint oldAmount = allowance[_for];
        allowance[_for] -= _amount;
        emit AllowanceChanged(_for, oldAmount, _amount);
    }
    
    // "owner() method is called from the Ownable contract"
    modifier ownerOrAllowed(uint _amount) {
        require(owner() == msg.sender || allowance[msg.sender] >= _amount, "You are not the owner or you don't have enough funds");
        _;
    }
}

