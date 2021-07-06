const AdAuction = artifacts.require("./AdAuction.sol");

contract("AdAuction", (accounts) => {
  beforeEach(async () => {
    this.myContract = await AdAuction.new();
  });

  it("...should be able to bid", async () => {
    const contract = this.myContract;
    const lastBidder = await contract.lastBidder.call();

    assert.equal(lastBidder.amount, "0", "The value is not 0");
    await contract.bid(accounts[0], 1000);

    const latestBidder = await contract.lastBidder.call();
    assert.equal(latestBidder.amount, "1000", "The value is not 1000");
  });

  it("...should be able to make a higher bid than the last one", async () => {
    const contract = this.myContract;
    const lastBidder = await contract.lastBidder.call();

    assert.equal(lastBidder.amount, "0", "The value is not 0");
    await contract.bid(accounts[0], 1000);

    const latestBidder = await contract.lastBidder.call();
    assert.equal(latestBidder.amount, "1000", "The value is not 1000");

    await contract.bid(accounts[1], 2000);
    const ultimateBidder = await contract.lastBidder.call();
    assert.equal(ultimateBidder.amount, "2000", "The value is not 2000");
  });

  it("...shouldn't be able to make a bid lower than the last one", async () => {
    const contract = this.myContract;
    const lastBidder = await contract.lastBidder.call();

    assert.equal(lastBidder.amount, "0", "The value is not 0");
    await contract.bid(accounts[0], 1000);

    const latestBidder = await contract.lastBidder.call();
    assert.equal(latestBidder.amount, "1000", "The value is not 1000");

    await contract.bid(accounts[1], 500);
  });
});
