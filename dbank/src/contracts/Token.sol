// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
// pragma solidity ^0.8.1;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    //add minter variable
    address public minter;

    //add minter changed event
    event MinterChanged(address indexed _from, address _to);

    /*
        ERC20("Name", "Symbol") is the contructor function from the contract e inherit from.
    */
    constructor() payable ERC20("Decentralized Bank Coin", "DBC") {
        //asign initial minter
        minter = msg.sender;
    }


    //Add pass minter role function
    function passMinterRole(address _to) public returns(bool) {
        require(minter == msg.sender, "Only the owner can pass minter role");
        minter == _to;
        emit MinterChanged(msg.sender, _to);
        return true;
    }

    function mint(address account, uint256 amount) public {
        //check if msg.sender have minter role
        require(minter == msg.sender, "You are not allowed");
        /*
            we inherrit _mint() from ERC20
            it creates tokens -- in our case 1:1 to ether
        */
        _mint(account, amount);
	}
}