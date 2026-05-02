# Ethereum transaction lifecycle

Mental model:

1. A user signs a transaction with nonce, gas fields, destination, value, and calldata.
2. The transaction is sent to an RPC node with `eth_sendRawTransaction`.
3. The node validates basic fields and gossips the transaction through the mempool.
4. A block builder includes the transaction in a block candidate.
5. The EVM executes the message call or contract creation against current state.
6. Execution changes account balances, nonces, storage, and logs.
7. Gas is charged for computation, storage, calldata bytes, and memory expansion.
8. The block is finalized by consensus. Receipts expose status, gas used, and logs.

Important fields to inspect:

- `from`: recovered from the signature.
- `to`: contract/account receiving the call. Empty means contract creation.
- `value`: wei transferred with the call.
- `input`: calldata. Usually `selector || abi_encoded_args`.
- `nonce`: per-account transaction counter.
- `gasLimit`: max gas the sender allows.
- `maxFeePerGas` and `maxPriorityFeePerGas`: EIP-1559 fee fields.

Practice with Anvil:

```bash
anvil
cast block latest --rpc-url http://127.0.0.1:8545
cast nonce <ANVIL_ACCOUNT> --rpc-url http://127.0.0.1:8545
cast gas-price --rpc-url http://127.0.0.1:8545
```
