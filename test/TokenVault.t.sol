// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../src/TokenVault.sol";
import "openzeppelin/mocks/ERC20Mock.sol";

contract TokenVaultTest is Test {
    TokenVault vault;
    ERC20Mock erc20;

    function setUp() public {
        erc20 = new ERC20Mock();
        vault = new TokenVault(address(erc20));
    }

    function testDeposit(uint40 _senderNonce, uint256 _amount) public {
        vm.assume(_senderNonce > 0);
        vm.assume(_amount > 0);
        address sender = vm.addr(_senderNonce);

        // mint erc20 balance to sender
        erc20.mint(sender, _amount);

        uint256 previousVaultBalance = vault.balanceOf(sender);
        assert(erc20.balanceOf(sender) == _amount);

        // Increase transfer allowance
        vm.prank(sender);
        erc20.increaseAllowance(address(vault), _amount);

        vm.prank(sender);
        vault.deposit(_amount);

        assert(vault.balanceOf(sender) > previousVaultBalance);
        assert(erc20.balanceOf(sender) == 0);
    }

    function testDepositRevert(uint40 _senderNonce, uint256 _amount) public {
        vm.assume(_senderNonce > 0);
        vm.assume(_amount == 0);
        address sender = vm.addr(_senderNonce);

        // mint erc20 balance to sender
        erc20.mint(sender, _amount);

        assert(erc20.balanceOf(sender) == _amount);

        vm.expectRevert("Deposit needs to be > 0");
        vm.prank(sender);
        vault.deposit(_amount);
    }

    function testWithdraw(uint40 _senderNonce, uint8 _amount) public {
        vm.assume(_senderNonce > 0);
        vm.assume(_amount > 0);
        address sender = vm.addr(_senderNonce);

        // mint erc20 balance to sender
        erc20.mint(sender, _amount);

        // Increase transfer allowance
        vm.prank(sender);
        erc20.increaseAllowance(address(vault), _amount);

        vm.prank(sender);
        vault.deposit(_amount);

        uint256 previousVaultBalance = vault.balanceOf(sender);

        assert(erc20.balanceOf(sender) == 0);

        vm.prank(sender);
        vault.withdraw(previousVaultBalance);

        assert(erc20.balanceOf(sender) > 0);
    }

    function testWithdrawRevert(uint40 _senderNonce, uint256 _amount) public {
        vm.assume(_senderNonce > 0);
        vm.assume(_amount > 0);
        address sender = vm.addr(_senderNonce);

        uint256 previousVaultBalance = vault.balanceOf(sender);

        assert(erc20.balanceOf(sender) == 0);

        vm.expectRevert("Withdrawal request too large");
        vm.prank(sender);
        vault.withdraw(previousVaultBalance + 1);
    }
}
