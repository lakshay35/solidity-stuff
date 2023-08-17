// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import "../src/HelloWorld.sol";

contract HelloWorldTest is Test {
    HelloWorld public helloWorld;

    function setUp() public {
        helloWorld = new HelloWorld(bytes32("Hello World"), address(0));
    }

    function testSetMessage() public {
        helloWorld.setMessage(bytes32("New Message"));
        assert(bytes32("New Message") == helloWorld.message());
    }

    function testSetMsg() public {
        helloWorld.setMsg(bytes32("New Message"));
        assert(bytes32("New Message") == helloWorld.message());
    }

    function testGetOwner() public view {
        assert(address(0) == helloWorld.owner());
    }
}
