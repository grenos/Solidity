// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;


contract Variables {
    /*
        All variables without a declared value are intialized with default values (NOT Null)
    */
    
    /*
    Unsigned integer UINT
    an unsigned integer ca only have values of zero or positive.
    */
    uint256 public myUInt; // default -> 0
    bool public myBool; // default -> false
    
    /*
        String are of type byte array
    */
    string public myString = "Hello World"; // default -> ""
    address public myAdress; // default -> 0x0000000000000000000000000000000000000000
    
    


    /*
        Public setter functions
    */
    function setMyUInt(uint _myUInt) public {
        /*
            _myUInt is a the parameter -- underscore is just a syntax thing 
            (not in the solidity style guide tho) to say its "localy scoped"
        */
        myUInt = _myUInt;
    }
    
    function setAdress(address _adsress) public {
        myAdress = _adsress;
    }
    
    // the view kwyword is like "read only in JS"
    // returns a uint
    function getBalance() public view returns(uint) {
        // an address always has a balance property
        return myAdress.balance; // returns balance in wei (1 wei == 1) 
    }
  
    /*
        DATA LOCATIONS
    
        With string you have to be specific in which data location
        that string will be stored. 
        It can be memory or calldata
        
        String don't work as on other languages. They're not a alue type 
        so they don't have helper function es. (concat, search etc). They also cost alot of gas!
        If you need to work with strings it's better to store them outside of the blockchain and 
        maybe hash them and just save the hash value on the blockchain.
    */
    function setString(string memory _myString) public {
        myString = _myString;
    }
    



    
    /*
        UInts wraparound !!!!!!
        incrementing or decrementing a uint can cause the number to restart or go at the end if we go bellow zero 
        since uints don't do negative nambers.
        
        version > 0.8 have an automatic control that reverts the transaction if the uint
        is going to underflow or overflow.
    */
    uint8 public myUInt8;
    
    function increment() public {
        myUInt8++;
    }
    
    
    function decrement() public {
        myUInt8--;
    }
}





