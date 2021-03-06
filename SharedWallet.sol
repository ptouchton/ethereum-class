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

    uint256 public lockedUntil;

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
        lockedUntil = block.timestamp + 1 minutes;
    }

    function sendMoney(address payable _to, uint256 _amt) public payable {
        require(
            _amt < balanceReceived[msg.sender].totalBalance,
            "Not enough ether"
        );
        assert(
            balanceReceived[msg.sender].totalBalance >=
                balanceReceived[msg.sender].totalBalance - _amt
        );

        balanceReceived[msg.sender].totalBalance -= _amt;

        Payment memory payment = Payment(_amt, block.timestamp);
        balanceReceived[_to].totalBalance += _amt;
        balanceReceived[_to].payments[
            balanceReceived[msg.sender].numPayments
        ] = payment;
        balanceReceived[_to].numPayments++;
        lockedUntil = block.timestamp + 1 minutes;
    }


    function withdrawMoney() public {
        if (lockedUntil < block.timestamp) {
            uint256 bal = balanceReceived[msg.sender].totalBalance;
            assert(bal > 0 );
            balanceReceived[msg.sender].totalBalance = 0;

            address payable to = payable(msg.sender);
            to.transfer(bal);
        }
    }

    function convertWeiToEth(uint256 _amount) public pure returns (uint256) {
        return _amount / 1 ether;
    }
}
