// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "openzeppelin/utils/Strings.sol";
import "../src/MyNFT.sol";

contract HelloWorldTest is Test {
    MyNFT public myNFT;

    function setUp() public {
        myNFT = new MyNFT();
    }

    function testTotalSupply() public {
        assert(myNFT.totalSupply() == 0);
        vm.prank(address(7));
        myNFT.mint();
        assert(myNFT.totalSupply() == 1);
        assert(myNFT.balanceOf(address(7)) == 1);
    }

    function testMint() public {
        myNFT.mint();
        assert(myNFT.totalSupply() == 1);
    }

    function testTokenUri() public view {
        assert(
            Strings.equal(
                "https://images.unsplash.com/photo-1608848461950-0fe51dfc41cb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8fA%3D%3D&w=1000&q=80",
                myNFT.tokenURI()
            )
        );
    }
}
