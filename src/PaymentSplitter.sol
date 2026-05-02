// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Educational ETH splitter for learning accounting, storage, gas, and attack surface.
contract EducationalPaymentSplitter {
    uint256 public totalShares;
    uint256 public totalReleased;

    address[] private _payees;

    mapping(address account => uint256 shares) public shares;
    mapping(address account => uint256 amount) public released;

    event PayeeAdded(address indexed account, uint256 shares);
    event PaymentReceived(address indexed from, uint256 amount);
    event PaymentReleased(address indexed to, uint256 amount);

    error InvalidPayee(address account);
    error InvalidShares();
    error DuplicatePayee(address account);
    error NothingToRelease(address account);

    constructor(address[] memory payees, uint256[] memory payeeShares) payable {
        if (payees.length == 0 || payees.length != payeeShares.length) {
            revert InvalidShares();
        }

        for (uint256 i = 0; i < payees.length; i++) {
            _addPayee(payees[i], payeeShares[i]);
        }

        if (msg.value > 0) {
            emit PaymentReceived(msg.sender, msg.value);
        }
    }

    receive() external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }

    function payee(uint256 index) external view returns (address) {
        return _payees[index];
    }

    function payeeCount() external view returns (uint256) {
        return _payees.length;
    }

    function releasable(address account) public view returns (uint256) {
        uint256 accountShares = shares[account];
        if (accountShares == 0) {
            return 0;
        }

        uint256 totalReceived = address(this).balance + totalReleased;
        return
            (totalReceived * accountShares) / totalShares - released[account];
    }

    function release(address payable account) external {
        uint256 payment = releasable(account);
        if (payment == 0) {
            revert NothingToRelease(account);
        }

        released[account] += payment;
        totalReleased += payment;

        (bool success, ) = account.call{value: payment}("");
        require(success, "ETH_TRANSFER_FAILED");

        emit PaymentReleased(account, payment);
    }

    function _addPayee(address account, uint256 accountShares) private {
        if (account == address(0)) {
            revert InvalidPayee(account);
        }
        if (accountShares == 0) {
            revert InvalidShares();
        }
        if (shares[account] != 0) {
            revert DuplicatePayee(account);
        }

        _payees.push(account);
        shares[account] = accountShares;
        totalShares += accountShares;

        emit PayeeAdded(account, accountShares);
    }
}
