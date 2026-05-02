// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {EducationalPaymentSplitter} from "../src/PaymentSplitter.sol";

contract PaymentReceiver {
    receive() external payable {}
}

contract PaymentSplitterTest {
    function testCreatesPayeesAndShares() public {
        PaymentReceiver alice = new PaymentReceiver();
        PaymentReceiver bob = new PaymentReceiver();
        EducationalPaymentSplitter splitter = _newSplitter(
            address(alice),
            address(bob)
        );

        assert(splitter.payeeCount() == 2);
        assert(splitter.payee(0) == address(alice));
        assert(splitter.payee(1) == address(bob));
        assert(splitter.shares(address(alice)) == 1);
        assert(splitter.shares(address(bob)) == 3);
        assert(splitter.totalShares() == 4);
    }

    function testReleasesProRataPayments() public {
        PaymentReceiver alice = new PaymentReceiver();
        PaymentReceiver bob = new PaymentReceiver();
        EducationalPaymentSplitter splitter = _newSplitter(
            address(alice),
            address(bob)
        );

        (bool funded, ) = address(splitter).call{value: 4 ether}("");
        assert(funded);

        assert(splitter.releasable(address(alice)) == 1 ether);
        assert(splitter.releasable(address(bob)) == 3 ether);

        uint256 aliceBefore = address(alice).balance;
        uint256 bobBefore = address(bob).balance;

        splitter.release(payable(address(alice)));
        splitter.release(payable(address(bob)));

        assert(address(alice).balance - aliceBefore == 1 ether);
        assert(address(bob).balance - bobBefore == 3 ether);
        assert(splitter.totalReleased() == 4 ether);
    }

    function testReleaseRevertsForUnknownAccount() public {
        PaymentReceiver alice = new PaymentReceiver();
        PaymentReceiver bob = new PaymentReceiver();
        EducationalPaymentSplitter splitter = _newSplitter(
            address(alice),
            address(bob)
        );

        (bool success, bytes memory data) = address(splitter).call(
            abi.encodeWithSelector(
                EducationalPaymentSplitter.release.selector,
                payable(address(99))
            )
        );

        assert(!success);
        assert(
            _revertSelector(data) ==
                EducationalPaymentSplitter.NothingToRelease.selector
        );
    }

    function _newSplitter(
        address alice,
        address bob
    ) private returns (EducationalPaymentSplitter splitter) {
        address[] memory payees = new address[](2);
        payees[0] = alice;
        payees[1] = bob;

        uint256[] memory shares = new uint256[](2);
        shares[0] = 1;
        shares[1] = 3;

        splitter = new EducationalPaymentSplitter(payees, shares);
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
