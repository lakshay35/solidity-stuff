// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

//TODO: Make collateral based stablecoin system that liquidates when collateral falls below loan amount
//TODO: Implement the aforementioned system in solana using rust/anchor

import "openzeppelin/token/ERC20/ERC20.sol";
import "openzeppelin/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    constructor(uint256 initialCap) ERC20("MyToken", "MTKN") {
        _mint(msg.sender, initialCap * (10 ** decimals()));
    }

    /**
     * Mints specified amount of tokens to specified address
     * function is restricted to owner of the token
     * @param amount - amount to mint
     * @param to - address to mint to
     */
    function mint(uint256 amount, address to) external onlyOwner {
        _mint(to, amount);
    }
}
