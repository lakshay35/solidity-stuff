// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public myToken;
    uint256 public constant initialSupply = 1000000;
    address public constant owner = address(7);

    event Transfer(address indexed from, address indexed to, uint256 value);

    function setUp() public {
        vm.prank(owner);
        myToken = new MyToken(initialSupply);
    }

    function testInitialSupply() public view {
        assert(myToken.totalSupply() == initialSupply * (10 ** myToken.decimals()));
    }

    function testBalanceOfOwner() public view {
        assert(myToken.balanceOf(owner) == initialSupply * (10 ** myToken.decimals()));
    }

    function testMint() public {
        vm.expectEmit(true, true, true, true);
        emit Transfer(address(0), address(1), 50000 * (10 ** myToken.decimals()));

        vm.startPrank(owner);
        myToken.mint(50000 * (10 ** myToken.decimals()), address(1));

        assert(myToken.balanceOf(address(1)) == 50000 * (10 ** myToken.decimals()));
        assert(myToken.totalSupply() == (initialSupply + 50000) * (10 ** myToken.decimals()));
        vm.stopPrank();
    }
}
