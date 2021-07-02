const path = require("path");

module.exports = {
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  // contracts_build_directory: path.join(__dirname, "contracts"),
  // migrations_directory: "./allMyStuff/someStuff/theMigrationsFolder",
  networks: {
    develop: {
      port: 7545,
      host: "127.0.0.1",
      network_id: 5777,
    },
    live: {
      // host: "178.25.19.88", // Random IP for example purposes (do not use)
      // port: 80,
      // network_id: 1,        // Ethereum public network
      // optional config values:
      // gas
      // gasPrice
      // from - default address to use for any transaction Truffle makes during migrations
      // provider - web3 provider instance Truffle should use to talk to the Ethereum network.
      //          - function that returns a web3 provider instance (see below.)
      //          - if specified, host and port are ignored.
      // skipDryRun: - true if you don't want to test run the migration locally before the actual migration (default is false)
      // confirmations: - number of confirmations to wait between deployments (default: 0)
      // timeoutBlocks: - if a transaction is not mined, keep waiting for this number of blocks (default is 50)
      // deploymentPollingInterval: - duration between checks for completion of deployment transactions
      // disableConfirmationListener: - true to disable web3's confirmation listener
    },
  },
  // Check for Providers!
  // https://www.trufflesuite.com/docs/truffle/reference/configuration#providers
  compilers: {
    solc: {
      version: "^0.8.0",
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};