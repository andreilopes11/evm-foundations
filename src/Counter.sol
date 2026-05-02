// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Small counter used to inspect ABI, selectors, calldata, events, and gas.
contract Counter {
    uint256 public number;

    event NumberChanged(
        address indexed caller,
        uint256 oldNumber,
        uint256 newNumber
    );

    error CounterUnderflow();

    constructor(uint256 initialNumber) {
        number = initialNumber;
    }

    function setNumber(uint256 newNumber) external {
        uint256 oldNumber = number;
        number = newNumber;

        emit NumberChanged(msg.sender, oldNumber, newNumber);
    }

    function increment() external {
        uint256 oldNumber = number;
        number = oldNumber + 1;

        emit NumberChanged(msg.sender, oldNumber, number);
    }

    function decrement() external {
        uint256 oldNumber = number;
        if (oldNumber == 0) {
            revert CounterUnderflow();
        }

        number = oldNumber - 1;

        emit NumberChanged(msg.sender, oldNumber, number);
    }

    function reset() external {
        uint256 oldNumber = number;
        number = 0;

        emit NumberChanged(msg.sender, oldNumber, 0);
    }

    function incrementSelector() external pure returns (bytes4) {
        return this.increment.selector;
    }

    function calldataEcho(
        uint256 value,
        bytes calldata payload
    )
        external
        pure
        returns (
            uint256 echoedValue,
            bytes32 payloadHash,
            uint256 payloadLength
        )
    {
        return (value, keccak256(payload), payload.length);
    }
}
