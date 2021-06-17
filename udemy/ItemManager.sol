
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;


contract Ownable {
    address payable owner;
    
    constructor() {
        owner = payable(msg.sender);
    }
    
    modifier onlyOwner() {
        require(isOwner(), "Error, not the onwer");
        _;
    }

    function isOwner() public view returns(bool) {
        return msg.sender == owner;
    }
}



contract Item {
    uint public priceInWei;
    uint public index;
    uint public pricePaid;
    
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) {
        parentContract = _parentContract;
        priceInWei     = _priceInWei;
        index          = _index;
    }
    
    
    receive() external payable {
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei == msg.value, "Only full payments allowed");
        pricePaid += msg.value;
        // We use a low level "call()" so we can send more gas and trigger payment transactions 
        // in parent contract. Low level methods don't revert automatically in case we need to throw an exception.
        
        // here we call the function from the parent contract passing the msg value and the index of the current item
        //  (bool, success) --> this is how we get the return values from the "call()" method. It return two. One is the boolean in case of success
        // and the other would be a return value from the "triggerPayment" function (if it return something)
        (bool success,) = address(parentContract).call{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "The transaction wasn't successful, cancelling");
    }
}


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

