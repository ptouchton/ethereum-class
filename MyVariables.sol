// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;


contract MyVariables {

    uint256 public myUint;

    function setMyUint(uint _myUint) public {
        myUint = _myUint;
    }

    bool public myBool;

    function setMyBool(bool _myBool) public {
        myBool = _myBool;
    }

    uint8 public myUint8;

    function incrementMyuint8() public {
        myUint8++;
    }

    function decrementMyUint8() public {
        myUint8--;
    }

    address public myAddress;

    function setMyAddress(address _myAddress) public {
        myAddress = _myAddress;
    }

    string public myString = 'hello world!';

    function setMyString(string memory _myString) public {
        myString = _myString;
    }
}