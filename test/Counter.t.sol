// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Counter} from "../src/Counter.sol";

contract CounterTest {
    function testInitialNumberAndSelector() public {
        Counter counter = new Counter(41);

        assert(counter.number() == 41);
        assert(counter.incrementSelector() == bytes4(keccak256("increment()")));
    }

    function testSetIncrementDecrementAndReset() public {
        Counter counter = new Counter(0);

        counter.setNumber(10);
        assert(counter.number() == 10);

        counter.increment();
        assert(counter.number() == 11);

        counter.decrement();
        assert(counter.number() == 10);

        counter.reset();
        assert(counter.number() == 0);
    }

    function testDecrementRevertsAtZero() public {
        Counter counter = new Counter(0);

        (bool success, bytes memory data) = address(counter).call(
            abi.encodeWithSelector(Counter.decrement.selector)
        );

        assert(!success);
        assert(_revertSelector(data) == Counter.CounterUnderflow.selector);
    }

    function testCalldataEcho() public {
        Counter counter = new Counter(0);
        bytes memory payload = hex"12345678";

        (
            uint256 echoedValue,
            bytes32 payloadHash,
            uint256 payloadLength
        ) = counter.calldataEcho(7, payload);

        assert(echoedValue == 7);
        assert(payloadHash == keccak256(payload));
        assert(payloadLength == payload.length);
    }

    function _revertSelector(
        bytes memory data
    ) private pure returns (bytes4 selector) {
        assert(data.length >= 4);

        assembly ("memory-safe") {
            selector := mload(add(data, 0x20))
        }
    }
}
