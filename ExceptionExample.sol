//SPDX-License-Identifier: MIT

pragma solidity 0.6.1;

contract ExceptionExample {
    mapping(address => uint64) public balanceReceived;

    function receiveMoney() public payable {
        assert(msg.value == uint64(msg.value));
        balanceReceived[msg.sender] += uint64(msg.value);
        assert(balanceReceived[msg.sender] >= uint64(msg.value));
    }

    function withdrawMoney(address payable _to, uint64 _amt) public {
        require(
            _amt <= balanceReceived[msg.sender],
            "You don't have enough funds"
        );
        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amt);
        balanceReceived[msg.sender] -= _amt;
        _to.transfer(_amt);
    }
}
