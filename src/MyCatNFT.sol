// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;

import "openzeppelin/token/ERC1155/ERC1155.sol";

contract MyCatNFT is ERC1155 {
    constructor() ERC1155("https://www.rover.com/blog/wp-content/uploads/2019/12/adorable-fluffy-cat.jpg") {}

    function mint() external returns (uint256 tokenId) {
        _mint(msg.sender, 1, 1, "");

        return 1;
    }
}
