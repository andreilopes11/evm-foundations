# Storage, memory, and calldata

Data locations matter:

- `storage`: persistent contract state. Expensive, survives transactions.
- `memory`: temporary mutable data during execution. Cleared after the call.
- `calldata`: read-only external call input. Cheap to read compared with copying.

`SimpleStorage` is arranged for simple slot inspection:

```text
slot 0: value
slot 1: word
slot 2: lastWriter
slot 3: values.length
slot 4: records mapping seed
```

Read simple slots:

```bash
export RPC_URL=http://127.0.0.1:8545
export SIMPLE_STORAGE=<DEPLOYED_SIMPLE_STORAGE_ADDRESS>

cast storage $SIMPLE_STORAGE 0 --rpc-url $RPC_URL
cast storage $SIMPLE_STORAGE 1 --rpc-url $RPC_URL
cast storage $SIMPLE_STORAGE 2 --rpc-url $RPC_URL
cast storage $SIMPLE_STORAGE 3 --rpc-url $RPC_URL
```

Dynamic array element slot:

```bash
cast keccak 0x0000000000000000000000000000000000000000000000000000000000000003
```

The first value in `values` is stored at `keccak256(abi.encode(uint256(3)))`.

Mapping value slot:

```bash
cast index bytes32 <KEY> 4
```

The mapping value is stored at `keccak256(abi.encode(key, uint256(4)))`.
