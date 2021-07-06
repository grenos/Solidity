import React, { Component } from "react";
import IpfsStorage from "./contracts/IpfsStorage.json";
import AdAuction from "./contracts/AdAuction.json";
import getWeb3 from "./getWeb3";
import ipfs from "./ipfs";

import "./App.css";

class App extends Component {
  state = {
    web3: {},
    accounts: [],
    currentAddress: "",
    imageBuffer: {},
    ipfsImageHash: "",
    ipfsTextHash: "",
    isLoading: false,
    title: "Buy your ad space here",
    newTitle: "",
    lastBidder: null,
    winnerData: null,
    bid: 0,
    isBidComplete: false,
  };

  componentDidMount = async () => {
    this.setState({ isLoading: true });
    try {
      const web3 = await getWeb3();
      this.BN = web3.utils.BN;
      const accounts = await web3.eth.getAccounts();
      const networkId = await web3.eth.net.getId();

      const deployedNetworkIpfs = IpfsStorage.networks[networkId];
      this.ipfsInstance = new web3.eth.Contract(
        IpfsStorage.abi,
        deployedNetworkIpfs && deployedNetworkIpfs.address
      );

      const deployedNetworkAuction = AdAuction.networks[networkId];
      this.auctionInstance = new web3.eth.Contract(
        AdAuction.abi,
        deployedNetworkAuction && deployedNetworkAuction.address
      );

      this.setState({
        web3,
        accounts,
        currentAddress: web3.currentProvider.selectedAddress,
        isLoading: false,
      });
      this.auctionInstance && this.listenToBidEvent();
      this.auctionInstance && this.listenToWinningDataEvent();
      this.auctionInstance && this.getInitialAuctionValues();
    } catch (error) {
      this.setState({ isLoading: false });
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`
      );
      console.error(error);
    }
  };

  listenToBidEvent = () => {
    this.auctionInstance.events.NewHigherBid().on("data", async (event) => {
      const lastBidder = {
        address: event.returnValues.from,
        amount: event.returnValues.amount,
      };

      this.setState({
        lastBidder,
        isBidComplete: true,
      });
    });
  };

  listenToWinningDataEvent = () => {
    this.auctionInstance.events.NewWinningData().on("data", async (event) => {
      this.setState({
        title: event.returnValues.title,
        ipfsImageHash: event.returnValues.imageHash,
        isBidComplete: true,
      });
    });
  };

  getInitialAuctionValues = async () => {
    const lastBidder = await this.auctionInstance.methods.lastBidder().call();
    const winnerData = await this.auctionInstance.methods.winnerData().call();

    if (lastBidder && lastBidder.bidder) {
      const lbObj = {
        address: lastBidder.bidder,
        amount: lastBidder.amount,
      };
      this.setState({
        lastBidder: lbObj,
      });
    }

    if (winnerData && winnerData.title) {
      this.setState({
        title: winnerData.title,
        ipfsImageHash: winnerData.imageHash,
      });
    }
  };

  handleBid = async () => {
    const { currentAddress } = this.state;
    this.setState({ isLoading: true });
    try {
      await this.auctionInstance.methods
        .bid(currentAddress, this.state.bid.toString())
        .send({ from: currentAddress, value: this.state.bid.toString() });
      this.setState({ isLoading: false });
    } catch (error) {
      console.log(error);
      this.setState({ isLoading: false });
    }
  };

  handleAddPhoto = async (event) => {
    // convert foto into bytes
    const file = event.target.files[0];
    const reader = new window.FileReader();
    reader.readAsArrayBuffer(file);
    reader.onloadend = () => {
      this.setState({ imageBuffer: Buffer(reader.result) });
    };
  };

  //! IPFS + BC
  handleOnSubmit = async (event) => {
    event.preventDefault();
    const { currentAddress, newTitle } = this.state;
    this.setState({ isLoading: true });
    try {
      const imageResult = await ipfs.add(this.state.imageBuffer);
      const ipfsImageHash = imageResult.path;

      await this.auctionInstance.methods
        .setWinnerData(currentAddress, ipfsImageHash, newTitle)
        .send({ from: currentAddress });

      this.setState({
        ipfsImageHash,
        isLoading: false,
        isBidComplete: false,
        title: newTitle,
      });
    } catch (error) {
      console.log(error);
      this.setState({ isLoading: false });
    }
  };

  render() {
    if (!this.state.web3) {
      return (
        <div className="flex centered loading">
          Loading Web3, accounts, and contract...
        </div>
      );
    }

    if (this.state.isLoading) {
      return (
        <div className="flex centered loading">
          Loading Web3, accounts, and contract...
        </div>
      );
    }

    return (
      <div className="flex split-equal">
        <div className="flex column max-width-50 col1">
          {this.state.ipfsImageHash && (
            <div style={{ width: "600px" }}>
              <img
                src={`https://ipfs.io/ipfs/${this.state.ipfsImageHash}`}
                alt=""
                style={{ width: "100%", height: "auto" }}
              />
            </div>
          )}
          <h1>{this.state.title}</h1>
          <h3>
            Place your bid and set it on a price higher than the last bidder and
            you automatically win!
          </h3>

          {!this.state.isBidComplete && (
            <>
              <div className="flex column max-width-50 col1">
                <p>Place your bid in wei</p>
                <input
                  type="number"
                  onChange={(e) =>
                    this.setState({ bid: new this.BN(e.target.value) })
                  }
                  style={{ marginBottom: "40px" }}
                />
              </div>
              <button
                style={{ marginBottom: "240px" }}
                onClick={this.handleBid}
              >
                Bid now!
              </button>
            </>
          )}

          {this.state.isBidComplete && (
            <form onSubmit={this.handleOnSubmit} className="flex column">
              <input
                type="file"
                onChange={this.handleAddPhoto}
                style={{ marginBottom: "40px" }}
              />

              <input
                type="text"
                onChange={(e) => this.setState({ newTitle: e.target.value })}
                style={{ marginBottom: "40px" }}
              />
              <input type="submit" />
            </form>
          )}
        </div>

        <div className="flex column max-width-50 col2">
          <div className="flex">
            <h1>The last bid was:</h1>
            <h1>
              {this.state.lastBidder
                ? this.state.web3.utils.fromWei(this.state.lastBidder.amount)
                : "0"}
              ETH
            </h1>
          </div>
          {this.state.lastBidder && (
            <>
              <h3>from:</h3>
              <h3>{this.state.lastBidder.address}</h3>
            </>
          )}
          <h3>Last 10 winners</h3>
        </div>
      </div>
    );
  }
}

export default App;
