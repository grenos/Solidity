var IpfsStorage = artifacts.require("./IpfsStorage.sol");
var AdAuction = artifacts.require("./AdAuction");

module.exports = function (deployer) {
  deployer.deploy(IpfsStorage);
  deployer.deploy(AdAuction);
};
