// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Emits logs for event-topic and transaction-receipt inspection.
contract EventLogger {
    uint256 public totalLogs;
    bytes32 public lastTopic;
    string public lastMessage;

    event MessageLogged(
        address indexed sender,
        bytes32 indexed topic,
        string message,
        uint256 value,
        uint256 logId
    );
    event PaymentObserved(
        address indexed sender,
        uint256 amount,
        bytes data,
        uint256 logId
    );

    function log(
        bytes32 topic,
        string calldata message
    ) external returns (uint256 logId) {
        logId = _remember(topic, message);

        emit MessageLogged(msg.sender, topic, message, 0, logId);
    }

    function logWithValue(
        bytes32 topic,
        string calldata message
    ) external payable returns (uint256 logId) {
        logId = _remember(topic, message);

        emit MessageLogged(msg.sender, topic, message, msg.value, logId);
    }

    receive() external payable {
        totalLogs += 1;

        emit PaymentObserved(msg.sender, msg.value, "", totalLogs);
    }

    fallback() external payable {
        totalLogs += 1;

        emit PaymentObserved(msg.sender, msg.value, msg.data, totalLogs);
    }

    function _remember(
        bytes32 topic,
        string calldata message
    ) private returns (uint256 logId) {
        totalLogs += 1;
        lastTopic = topic;
        lastMessage = message;

        return totalLogs;
    }
}
