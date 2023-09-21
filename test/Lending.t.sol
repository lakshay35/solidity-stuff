// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "openzeppelin/mocks/ERC20Mock.sol";
import "openzeppelin/interfaces/IERC20.sol";
import "../src/Lending.sol";

contract LendingTest is Test {
    LendingProtocol private lendingProtocol;
    ERC20Mock private underlyingAsset;

    function setUp() public {
        underlyingAsset = new ERC20Mock();
        lendingProtocol = new LendingProtocol(address(underlyingAsset), 1);
    }

    function testDeposit(uint256 _amount) public {
        vm.assume(_amount > 0);

        // Ensure funds for deposit are available
        underlyingAsset.mint(address(this), _amount);

        // expect lending protocol to make transfer call
        vm.expectCall(
            address(underlyingAsset),
            abi.encodeCall(IERC20.transferFrom, (address(this), address(lendingProtocol), _amount))
        );

        underlyingAsset.increaseAllowance(address(lendingProtocol), _amount);
        // Deposit funds
        lendingProtocol.deposit(_amount);

        assert(lendingProtocol.userLentBalances(address(this)) == _amount);
        assert(lendingProtocol.totalLent() == _amount);
    }

    function testDepositRevertWhenRequestIsZero() public {
        vm.expectRevert("Amount must be greater than zero");
        lendingProtocol.deposit(0);
    }

    function testDepositRevertWhenDepositBalanceDoesNotExist(uint256 _amount) public {
        vm.assume(_amount > 0);

        vm.expectRevert();
        lendingProtocol.deposit(_amount);
    }

    function testBorrow(uint240 _depositAmount) public {
        vm.assume(_depositAmount > 0 && _depositAmount % 2 == 0);

        uint256 balanceBefore = underlyingAsset.balanceOf(address(this));
        // Ensure funds to deposit exist
        underlyingAsset.mint(address(this), _depositAmount);
        // increase allowance to make deposit possible
        underlyingAsset.increaseAllowance(address(lendingProtocol), _depositAmount);
        // deposit balance
        lendingProtocol.deposit(_depositAmount);

        vm.expectCall(address(underlyingAsset), abi.encodeCall(IERC20.transfer, (address(this), _depositAmount / 2)));
        lendingProtocol.borrow(_depositAmount / 2);

        assert(lendingProtocol.userBorrowedBalances(address(this)) == _depositAmount / 2);
        assert(lendingProtocol.totalBorrowed() == _depositAmount / 2);
        assert(underlyingAsset.balanceOf(address(this)) - balanceBefore == _depositAmount / 2);
    }
}
