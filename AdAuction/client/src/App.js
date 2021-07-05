import React, { Component } from "react";
import IpfsStorage from "./contracts/IpfsStorage.json";
import AdAuction from "./contracts/AdAuction.json";
import getWeb3 from "./getWeb3";
import ipfs from "./ipfs";

import "./App.css";

class App extends Component {
  state = { storageValue: 0, web3: null, accounts: null, contract: null };

  componentDidMount = async () => {
    try {
      const web3 = await getWeb3();
      const accounts = await web3.eth.getAccounts();
      const networkId = await web3.eth.net.getId();

      const deployedNetworkIpfs = IpfsStorage.networks[networkId];
      const ipfsInstance = new web3.eth.Contract(
        IpfsStorage.abi,
        deployedNetworkIpfs && deployedNetworkIpfs.address
      );

      const deployedNetworkAuction = AdAuction.networks[networkId];
      const auctionInstance = new web3.eth.Contract(
        AdAuction.abi,
        deployedNetworkAuction && deployedNetworkAuction.address
      );

      this.setState({
        web3,
        accounts,
        ipfsContract: ipfsInstance,
        auctionContract: auctionInstance,
      });
    } catch (error) {
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`
      );
      console.error(error);
    }
  };

  runExample = async () => {
    const { accounts, ipfsContract, auctionContract } = this.state;

    // Stores a given value, 5 by default.
    // await contract.methods.set(5).send({ from: accounts[0] });

    // Get the value from the contract to prove it worked.
    // const response = await contract.methods.get().call();

    // Update state with the result.
    // this.setState({ storageValue: response });
  };

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <div>The stored value is: {this.state.storageValue}</div>
      </div>
    );
  }
}

export default App;
