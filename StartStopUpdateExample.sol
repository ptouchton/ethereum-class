// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

contract StartStopUpdateExample {

    address owner;

    constructor() {
        owner = msg.sender;
    }

    function sendMoney() public payable {

    }

    function withdrawAllMoney(address payable _to) public {
        require(_to == owner, "You are not the owner");
        _to.transfer(address(this).balance);
    }
}