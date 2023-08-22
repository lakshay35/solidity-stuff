// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;

import "openzeppelin/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    uint256 public totalSupply;

    constructor() ERC721("Fun NFT", "FNFT") {
        totalSupply = 0;
    }

    function tokenURI() public pure returns (string memory tokenUri) {
        return
        "https://images.unsplash.com/photo-1608848461950-0fe51dfc41cb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8fA%3D%3D&w=1000&q=80";
    }

    function mint() external {
        _mint(msg.sender, totalSupply + 1);
        totalSupply++;
    }
}
