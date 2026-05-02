# ABI, selectors, and calldata

The ABI is the contract interface that off-chain tools use to encode calls and decode returns.

Function calldata starts with 4 bytes:

```text
bytes4(keccak256("functionName(type1,type2,...)"))
```

For example:

```bash
cast sig "increment()"
cast sig "setNumber(uint256)"
cast sig "log(bytes32,string)"
cast calldata "setNumber(uint256)" 42
```

Inspect generated ABI after compiling:

```bash
forge build
forge inspect Counter abi
forge inspect SimpleStorage abi
forge inspect EventLogger abi
forge inspect EducationalPaymentSplitter abi
```

Call versus transaction:

- `cast call` runs a read-only simulation and does not change chain state.
- `cast send` signs and broadcasts a transaction that can change state.

Local examples:

```bash
export RPC_URL=http://127.0.0.1:8545
export PRIVATE_KEY=<ANVIL_PRIVATE_KEY>
export COUNTER=<DEPLOYED_COUNTER_ADDRESS>

cast call $COUNTER "number()(uint256)" --rpc-url $RPC_URL
cast send $COUNTER "increment()" --private-key $PRIVATE_KEY --rpc-url $RPC_URL
cast call $COUNTER "number()(uint256)" --rpc-url $RPC_URL
```
