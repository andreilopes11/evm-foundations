// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {EventLogger} from "../src/EventLogger.sol";

contract EventLoggerTest {
    function testLogStoresLastMessageMetadata() public {
        EventLogger logger = new EventLogger();
        bytes32 topic = keccak256("topic:learning");

        uint256 logId = logger.log(topic, "hello evm");

        assert(logId == 1);
        assert(logger.totalLogs() == 1);
        assert(logger.lastTopic() == topic);
        assert(
            keccak256(bytes(logger.lastMessage())) ==
                keccak256(bytes("hello evm"))
        );
    }

    function testReceiveAndFallbackIncrementLogCounter() public {
        EventLogger logger = new EventLogger();

        (bool received, ) = address(logger).call{value: 1 ether}("");
        assert(received);
        assert(logger.totalLogs() == 1);

        (bool fellBack, ) = address(logger).call(hex"deadbeef");
        assert(fellBack);
        assert(logger.totalLogs() == 2);
    }
}
