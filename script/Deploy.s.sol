// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Counter} from "../src/Counter.sol";
import {EventLogger} from "../src/EventLogger.sol";
import {EducationalPaymentSplitter} from "../src/PaymentSplitter.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

interface Vm {
    function envOr(
        string calldata key,
        address defaultValue
    ) external returns (address value);
    function startBroadcast() external;
    function stopBroadcast() external;
}

contract Deploy {
    bytes32 private constant FOUNDRY_WORD =
        hex"666f756e64727900000000000000000000000000000000000000000000000000";
    Vm private constant VM =
        Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function run()
        external
        returns (
            Counter counter,
            SimpleStorage simpleStorage,
            EventLogger eventLogger,
            EducationalPaymentSplitter splitter
        )
    {
        address payeeOne = VM.envOr("PAYEE_ONE", msg.sender);
        address payeeTwo = VM.envOr(
            "PAYEE_TWO",
            address(uint160(0xBEEF))
        );

        VM.startBroadcast();

        counter = new Counter(0);
        simpleStorage = new SimpleStorage(FOUNDRY_WORD);
        eventLogger = new EventLogger();

        address[] memory payees = new address[](2);
        payees[0] = payeeOne;
        payees[1] = payeeTwo;

        uint256[] memory shares = new uint256[](2);
        shares[0] = 1;
        shares[1] = 1;

        splitter = new EducationalPaymentSplitter(payees, shares);

        VM.stopBroadcast();
    }
}
