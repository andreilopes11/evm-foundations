// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {SimpleStorage} from "../src/SimpleStorage.sol";

contract SimpleStorageTest {
    bytes32 private constant GENESIS_WORD =
        hex"67656e6573697300000000000000000000000000000000000000000000000000";
    bytes32 private constant EVM_WORD =
        hex"65766d0000000000000000000000000000000000000000000000000000000000";

    function testStorageSlotSummaryAndWrites() public {
        SimpleStorage store = new SimpleStorage(GENESIS_WORD);

        (
            uint256 valueSlot,
            uint256 wordSlot,
            uint256 lastWriterSlot,
            uint256 valuesLengthSlot,
            uint256 recordsSeedSlot
        ) = store.storageSlotSummary();

        assert(valueSlot == 0);
        assert(wordSlot == 1);
        assert(lastWriterSlot == 2);
        assert(valuesLengthSlot == 3);
        assert(recordsSeedSlot == 4);

        store.setValue(123);
        store.setWord(EVM_WORD);

        assert(store.value() == 123);
        assert(store.word() == EVM_WORD);
        assert(store.lastWriter() == address(this));
    }

    function testArrayMappingAndDataLocations() public {
        SimpleStorage store = new SimpleStorage(GENESIS_WORD);

        store.pushValue(11);
        store.pushValue(22);
        assert(store.values(0) == 11);
        assert(store.readFromStorage(1) == 22);

        bytes32 key = keccak256("account:a");
        store.writeRecord(key, 99);
        assert(store.records(key) == 99);

        uint256[] memory input = new uint256[](2);
        input[0] = 5;
        input[1] = 6;

        (
            uint256 calldataFirst,
            uint256 memoryFirstAfterMutation,
            uint256 length
        ) = store.compareCalldataAndMemory(input);

        assert(calldataFirst == 5);
        assert(memoryFirstAfterMutation == 6);
        assert(length == 2);
        assert(store.sumFromCalldata(input) == 11);
    }
}
