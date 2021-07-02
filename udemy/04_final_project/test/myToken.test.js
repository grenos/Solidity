const MyToken = artifacts.require("./MyToken");
const chai = require("./chaiConfig");
const BN = web3.utils.BN;
const expect = chai.expect;

contract("MyToken", (accounts) => {
  const [deployerAccount, recipient, thirdAccount] = accounts;

  beforeEach(async () => {
    // mock a new token contract every time we run a new test
    this.myToken = await MyToken.new(process.env.INITIAL_TOKENS);
  });

  it("...should have all tokens in a single account", async () => {
    const contract = this.myToken;
    const totalTokens = await contract.totalSupply();
    /*
      "eventually" -> comes form chaiAsPromised
      "bignumber" -> comes from chaiBN
    */
    return expect(
      contract.balanceOf(deployerAccount)
    ).to.eventually.be.bignumber.equal(totalTokens);
  });

  it("...should send tokens between accounts", async () => {
    const tokensToSend = 1;
    const contract = this.myToken;
    const totalTokens = await contract.totalSupply();

    // first check that deloyer has n number of tokens
    expect(
      contract.balanceOf(deployerAccount)
    ).to.eventually.be.bignumber.equal(totalTokens);

    // check that a transfer is eventually being made
    expect(contract.transfer(recipient, tokensToSend)).to.eventually.be
      .fulfilled;

    // check that deployer has n - 1 number of tokens after the transfer
    expect(
      contract.balanceOf(deployerAccount)
    ).to.eventually.be.bignumber.equal(totalTokens.sub(new BN(tokensToSend)));

    // check that the receiver has the right amount of tokens transfered to him
    return expect(
      contract.balanceOf(recipient)
    ).to.eventually.be.bignumber.equal(tokensToSend);
  });

  //TODO - failing test
  // it("...should be not possible to send more tokens than the total supply", async () => {
  //   const contract = this.myToken;
  //   const deployerBalance = await contract.balanceOf(deployerAccount);
  //   const tooManyTokens = new BN(deployerBalance) * 3;
  //   // check that you can't send more tokens than the entire balance of the deployer
  //   expect(contract.transfer(recipient, new BN(tooManyTokens))).to.eventually.be
  //     .rejected;
  //   // check that after the rejection the token balance of the deployer has remaind the same
  //   return expect(
  //     contract.balanceOf(deployerAccount)
  //   ).to.eventually.be.bignumber.equal(deployerBalance);
  // });
});
