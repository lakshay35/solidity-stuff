// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import "../src/MyCatNFT.sol";
import "openzeppelin/utils/Address.sol";

contract MyCatNFTTest is Test {
    function testMint(address receiver) public {
        vm.assume(receiver != address(0) && !Address.isContract(receiver));
        MyCatNFT nft = new MyCatNFT();

        vm.prank(receiver);
        uint256 tokenId = nft.mint();

        assert(nft.balanceOf(receiver, tokenId) == 1);
    }

    function testMultipleMints(address receiver) public {
        vm.assume(receiver != address(0) && !Address.isContract(receiver));

        MyCatNFT nft = new MyCatNFT();

        vm.startPrank(receiver);
        uint256 tokenId = nft.mint();
        nft.mint();
        nft.mint();
        nft.mint();
        nft.mint();
        vm.stopPrank();

        assert(nft.balanceOf(receiver, tokenId) == 5);
    }

    function testInvalidAddressMint() public {
        MyCatNFT nft = new MyCatNFT();

        vm.expectRevert("ERC1155: mint to the zero address");
        vm.prank(address(0));
        nft.mint();
    }

    function testNFTUri(address receiver) public {
        vm.assume(receiver != address(0) && !Address.isContract(receiver));

        MyCatNFT nft = new MyCatNFT();

        vm.prank(receiver);
        uint256 tokenId = nft.mint();

        assertEq(nft.uri(tokenId), "https://www.rover.com/blog/wp-content/uploads/2019/12/adorable-fluffy-cat.jpg");
    }
}
