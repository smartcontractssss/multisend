// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./contracts/token/ERC20/IERC20.sol";

contract MultiSend {
    IERC20 public token;  // Khai báo token ERC-20

    constructor(IERC20 _token) {
        token = _token;  // Gán token được truyền vào
    }

    event TransferFailed(address indexed recipient, uint256 amount);
    event TransferSucceeded(address indexed recipient, uint256 amount);

    function multiSend(address[] calldata recipients, uint256[] calldata amounts) external {
        require(recipients.length == amounts.length, "Recipients and amounts arrays must have the same length");

        uint256 totalAmount = 0;

        for (uint256 i = 0; i < recipients.length; i++) {
            totalAmount += amounts[i];
        }

        require(token.allowance(msg.sender, address(this)) >= totalAmount, "Insufficient token allowance");

        for (uint256 i = 0; i < recipients.length; i++) {
            bool success = token.transferFrom(msg.sender, recipients[i], amounts[i]);
            if (success) {
                emit TransferSucceeded(recipients[i], amounts[i]);
            } else {
                emit TransferFailed(recipients[i], amounts[i]);
            }
        }
    }
}
