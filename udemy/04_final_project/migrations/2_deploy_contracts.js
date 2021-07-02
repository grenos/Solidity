var MyToken = artifacts.require("./MyToken.sol");
var MyTokenSale = artifacts.require("./MyTokenSale.sol");
var KYC = artifacts.require("./KYC.sol");

require("dotenv").config({ path: "../.env" });

module.exports = async function (deployer) {
  let address = await web3.eth.getAccounts();
  await deployer.deploy(MyToken, process.env.INITIAL_TOKENS);
  await deployer.deploy(KYC);
  await deployer.deploy(
    MyTokenSale,
    1,
    address[0],
    MyToken.address,
    KYC.address
  );

  // Transfer all the tokens from the token contract to the token sale contract
  const contract = await MyToken.deployed();
  // const totalTokens = await contract.totalSupply();
  await contract.transfer(MyTokenSale.address, process.env.INITIAL_TOKENS);
};
