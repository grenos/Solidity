// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract KYC is Ownable{
  mapping(address => bool) allowed;

  function setKYCCompleted(address _address) public onlyOwner {
    allowed[_address] = true;
  }

  function setKYCRevoked(address _address) public onlyOwner {
    allowed[_address] = false;
  }

  function KYCCompleted(address _address) public view returns(bool) {
    return allowed[_address];
  }

}