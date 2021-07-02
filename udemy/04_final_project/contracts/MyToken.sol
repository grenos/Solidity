// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("StarDucks Capu-Token", "SCT") {

      _mint(msg.sender, initialSupply);
      
      // override ERC20 decimals function to set the decimals to 0
      decimals();
    }

    function decimals() public pure override returns (uint8) {
		  return 0;
	  }
}