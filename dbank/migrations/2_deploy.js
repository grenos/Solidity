// Import cotracts from the ABI folder
const Token = artifacts.require("Token");
const dBank = artifacts.require("dBank");

module.exports = async function (deployer) {
  //deploy Token with truffle
  await deployer.deploy(Token);
  // get the token from the blockhain -- assign token into variable to get it's address
  const token = await Token.deployed();
  // deploy dbank contract -- pass token address for dBank contract constructor (so the banker can become the minter)
  await deployer.deploy(dBank, token.address);
  //assign dBank contract into variable to get it's address
  const dbank = await dBank.deployed();
  //change token's owner/minter from deployer to dBank
  await token.passMinterRole(dbank.address);
};
