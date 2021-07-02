const MyToken = artifacts.require("./MyToken");
const MyTokenSale = artifacts.require("./MyTokenSale");
const kycContract = artifacts.require("./KYC");
const chai = require("./chaiConfig");
const BN = web3.utils.BN;
const expect = chai.expect;

contract("MyTokenSale", (accounts) => {
  const [deployerAccount, recipient, thirdAccount] = accounts;

  it("...should not have any tokens on deployerAccount", async () => {
    const contract = await MyToken.deployed();
    return expect(
      contract.balanceOf(deployerAccount)
    ).to.eventually.be.bignumber.equal(new BN(0));
  });

  it("...should have all coins in the token sale smart contract", async () => {
    const contract = await MyToken.deployed();
    const tokenBalance = await contract.balanceOf.call(MyTokenSale.address);
    const totalSupply = await contract.totalSupply.call();
    return expect(tokenBalance).to.eventually.be.bignumber.equal(totalSupply);
  });
});
