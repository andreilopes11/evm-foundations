// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Contract shaped for simple storage-slot reads and data-location experiments.
contract SimpleStorage {
    // slot 0
    uint256 public value;

    // slot 1
    bytes32 public word;

    // slot 2
    address public lastWriter;

    // slot 3 stores the array length. Array values start at keccak256(slot 3).
    uint256[] public values;

    // slot 4 is the mapping seed. Values are at keccak256(abi.encode(key, slot 4)).
    mapping(bytes32 key => uint256 amount) public records;

    event ValueStored(address indexed writer, uint256 value, bytes32 word);
    event ArrayValuePushed(uint256 indexed index, uint256 value);
    event RecordWritten(bytes32 indexed key, uint256 amount);

    constructor(bytes32 initialWord) {
        word = initialWord;
        lastWriter = msg.sender;
    }

    function setValue(uint256 newValue) external {
        value = newValue;
        lastWriter = msg.sender;

        emit ValueStored(msg.sender, newValue, word);
    }

    function setWord(bytes32 newWord) external {
        word = newWord;
        lastWriter = msg.sender;

        emit ValueStored(msg.sender, value, newWord);
    }

    function pushValue(uint256 newValue) external {
        values.push(newValue);

        emit ArrayValuePushed(values.length - 1, newValue);
    }

    function writeRecord(bytes32 key, uint256 amount) external {
        records[key] = amount;

        emit RecordWritten(key, amount);
    }

    function compareCalldataAndMemory(
        uint256[] calldata input
    )
        external
        pure
        returns (
            uint256 calldataFirst,
            uint256 memoryFirstAfterMutation,
            uint256 length
        )
    {
        if (input.length == 0) {
            return (0, 0, 0);
        }

        uint256[] memory copy = new uint256[](input.length);
        for (uint256 i = 0; i < input.length; i++) {
            copy[i] = input[i];
        }

        copy[0] = copy[0] + 1;

        return (input[0], copy[0], input.length);
    }

    function sumFromCalldata(
        uint256[] calldata input
    ) external pure returns (uint256 sum) {
        for (uint256 i = 0; i < input.length; i++) {
            sum += input[i];
        }
    }

    function readFromStorage(uint256 index) external view returns (uint256) {
        return values[index];
    }

    function storageSlotSummary()
        external
        pure
        returns (
            uint256 valueSlot,
            uint256 wordSlot,
            uint256 lastWriterSlot,
            uint256 valuesLengthSlot,
            uint256 recordsSeedSlot
        )
    {
        return (0, 1, 2, 3, 4);
    }
}
