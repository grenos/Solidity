import React, { Component } from "react";
import ItemManagerContract from "./contracts/ItemManager.json";
import ItemContract from "./contracts/Item.json";
import getWeb3 from "./getWeb3";
import "./App.css";

class App extends Component {
  state = { loaded: false, cost: 0, itemId: "" };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      this.web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      this.accounts = await this.web3.eth.getAccounts();

      // Get the contract instance.
      this.networkId = await this.web3.eth.net.getId();

      this.itemManager = new this.web3.eth.Contract(
        ItemManagerContract.abi,
        ItemManagerContract.networks[this.networkId] &&
          ItemManagerContract.networks[this.networkId].address
      );

      this.item = new this.web3.eth.Contract(
        ItemContract.abi,
        ItemContract.networks[this.networkId] &&
          ItemContract.networks[this.networkId].address
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.listenToPaymentEvent();
      this.setState({ loaded: true });
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`
      );
      console.error(error);
    }
  };

  listenToPaymentEvent = () => {
    this.itemManager.events.SupplyChainStep().on("data", async (evt) => {
      let obj = await this.itemManager.methods
        .items(evt.returnValues.itemIndex)
        .call();
      console.log(obj);
    });
  };

  handleInputChangeItemName = (e) => {
    const value = e.target.value;
    this.setState({
      itemId: value,
    });
  };

  handleInputChangeItemCost = (e) => {
    const value = e.target.value;
    this.setState({
      cost: value,
    });
  };

  handleSubmit = async () => {
    const { itemId, cost } = this.state;
    try {
      const resutls = await this.itemManager.methods
        .createItem(itemId, cost)
        .send({ from: this.accounts[0] });
      alert(
        `Send ${cost} Wei to this address: ${resutls.events.SupplyChainStep.returnValues.itemAddress} for item: ${itemId}`
      );
    } catch (error) {
      console.log(error);
    }
  };

  render() {
    if (!this.state.loaded) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Supply Chain Example</h1>
        <h2>Items</h2>
        <h2>Add Items</h2>
        Cost in wei:{" "}
        <input
          type="text"
          name="cost"
          value={this.state.cost}
          onChange={this.handleInputChangeItemCost}
        />
        Item id:{" "}
        <input
          type="text"
          name="itemName"
          value={this.state.itemId}
          onChange={this.handleInputChangeItemName}
        />
        <button type="button" onClick={this.handleSubmit}>
          Create new item
        </button>
      </div>
    );
  }
}

export default App;
