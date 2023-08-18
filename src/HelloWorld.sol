// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract HelloWorld {
    bytes32 public message;
    address public owner;

    constructor(bytes32 _message, address _owner) {
        message = _message;
        owner = _owner;
    }

    // The "external" function modifier saves gas because it exclusively permits
    // the be called from outisde the contract
    function setMessage(bytes32 _message) external {
        message = _message;
    }

    // The "public" function modifier consumes more gas because is permits
    // calls from both inside and outside the contract
    function setMsg(bytes32 _message) public {
        message = _message;
    }
}
