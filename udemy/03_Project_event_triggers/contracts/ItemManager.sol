// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable {
    
    enum SupplyChainState { Created, Paid, Delivered }
    
    struct S_Item {
        Item item;
        string id;
        uint priceInWei;
        ItemManager.SupplyChainState state;
    }
    
    mapping(uint => S_Item) public items;
    uint itemIndex;
    
    event SupplyChainStep(uint itemIndex, uint currentStep, address itemAddress);
    
    
    function createItem(string memory _id, uint _priceInWei) public onlyOwner {
        // create an item and init the Item contract
        Item _item                  = new Item(this, _priceInWei, itemIndex);
        items[itemIndex].item       = _item;
        items[itemIndex].id         = _id;
        items[itemIndex].priceInWei = _priceInWei;
        items[itemIndex].state      = SupplyChainState.Created;
        
        // emit completion event
        emit SupplyChainStep(itemIndex, uint(items[itemIndex].state), address(_item));
        
        // update current index
        itemIndex++;
    }
    
    
    function triggerPayment(uint _itemIndex) public payable {
        // controll that item price is payed in full AND that item is created but not yet paied for.
        require(items[_itemIndex].priceInWei == msg.value, "The item must be paid first.");
        require(items[_itemIndex].state == SupplyChainState.Created, "Item doesn't exist or it's already paid");
        
        // set item status to paid
        items[_itemIndex].state = SupplyChainState.Paid;
        
        // emit completion event
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex].state), address(items[itemIndex].item));
    }
    
    
    function triggerDelivery(uint _itemIndex) public onlyOwner {
        // controll that item price is payed in full AND that item is created but not yet paied for.
        require(items[_itemIndex].state == SupplyChainState.Paid, "Item doesn't exist or it's not paid yet");
        
        // set item status to delivered
        items[_itemIndex].state = SupplyChainState.Delivered;
        
        // emit completion event
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex].state), address(items[itemIndex].item));
    }
}

