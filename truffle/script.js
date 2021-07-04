const Web3 = require("web3");
const MyContract = require("./build/contracts/MyContract.json");

// get randomly generated account to sign off transaction
const address = "0xF24795E3088d0f990a119416fF748C01D5a637fe";
const privateKey =
  "f7815fdd4fce8c9c8fc5845de7456108b92d25afe241cd09aaf8c3561504f951";

// connect to Rikeby network via Infura
const infuraUrl =
  "https://rinkeby.infura.io/v3/c614036d5aea47689a8c116e97428b73";

//
const init = async () => {
  // set the network provider
  const web3 = new Web3(infuraUrl);
  // get info for the current network
  const networkId = await web3.eth.net.getId();
  // setup a way to interact with the contract
  // wee need to pass the abi and the address of the contract
  const contract = new web3.eth.Contract(
    MyContract.abi,
    MyContract.networks[networkId].address
  );

  // create a transaction object -> not called yet
  const tx = contract.methods.setData(1);
  // try to estimate gas used for the transaction
  const gas = await tx.estimateGas({ from: address });
  // get current gas price
  const gasPrice = await web3.eth.getGasPrice();
  // used to let our contract know what function it needs to call and with what parameters
  const data = tx.encodeABI();
  // basically a counter that knows how many times a transaction was called by an address
  const nonce = await web3.eth.getTransactionCount(address);

  // sign the transaction before it is send
  const signedTx = await web3.eth.accounts.signTransaction(
    {
      to: contract.options.address,
      data,
      gas,
      gasPrice,
      nonce,
      chainId: networkId,
    },
    privateKey
  );

  // log old values before sending the transaction (data is a public var inside the contract)
  console.log(`Old data value: ${await contract.methods.data().call()}`);
  // send transaction to blockchain
  const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
  // check transaction hash once it's finished
  console.log(`Trnasaction hash: ${receipt.transactionHash}`);
  // get new data after the tranaction is mined (data is a public var inside the contract)
  console.log(`New data value: ${await contract.methods.data().call()}`);
};

init();
