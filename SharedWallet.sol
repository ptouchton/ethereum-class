// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

contract SharedWallet {
    struct Payment {
        uint256 payment;
        uint256 timestamp;
    }

    struct Balance {
        uint256 totalBalance;
        uint256 numPayments;
        mapping(uint256 => Payment) payments;
    }

    mapping(address => Balance) public balanceReceived;

    address payable owner;

    /// The amount of Ether sent was not higher than
    /// the currently highest amount.
    error NotEnoughEther();

    constructor() {
        owner = payable(msg.sender);
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function destroySmartContract() public {
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(owner);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getMyBalance(address _me) public view returns (uint256) {
        return balanceReceived[_me].totalBalance;
    }

    function receiveMoney() public payable {
        require(
            balanceReceived[msg.sender].totalBalance + msg.value >
                balanceReceived[msg.sender].totalBalance,
            "Amount should be greater than zero"
        );
        balanceReceived[msg.sender].totalBalance += msg.value;

        Payment memory payment = Payment(msg.value, block.timestamp);
        balanceReceived[msg.sender].payments[
            balanceReceived[msg.sender].numPayments
        ] = payment;
        balanceReceived[msg.sender].numPayments++;
    }

    function sendMoney(address payable _to, uint256 _amt) public payable{
        require(balanceReceived[msg.sender].totalBalance - _amt < 0, "Not enough ether");
        //balanceReceived[msg.sender].totalBalance -= _amt;

        Payment memory payment = Payment(_amt, block.timestamp);
        balanceReceived[_to].totalBalance += _amt;
        balanceReceived[_to].payments[
            balanceReceived[msg.sender].numPayments
        ] = payment;
        balanceReceived[_to].numPayments++;
    }

    function convertWeiToEth(uint256 _amount) public pure returns (uint256) {
        return _amount / 1 ether;
    }
}
