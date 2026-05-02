# Foundry and Cast lab

Install Foundry from the official instructions, then run:

```bash
forge build
forge test
```

Start a local chain:

```bash
anvil
```

In a second terminal:

```bash
export RPC_URL=http://127.0.0.1:8545
export PRIVATE_KEY=<ANVIL_PRIVATE_KEY>
export PAYEE_ONE=<ANVIL_ACCOUNT_ONE>
export PAYEE_TWO=<ANVIL_ACCOUNT_TWO>

forge script script/Deploy.s.sol:Deploy --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

Copy the deployed addresses from the script output:

```bash
export COUNTER=<DEPLOYED_COUNTER_ADDRESS>
export SIMPLE_STORAGE=<DEPLOYED_SIMPLE_STORAGE_ADDRESS>
export LOGGER=<DEPLOYED_EVENT_LOGGER_ADDRESS>
export SPLITTER=<DEPLOYED_SPLITTER_ADDRESS>
```

Core exercises:

```bash
forge inspect Counter abi
cast sig "increment()"
cast sig "setNumber(uint256)"
cast calldata "setNumber(uint256)" 123

cast call $COUNTER "number()(uint256)" --rpc-url $RPC_URL
cast send $COUNTER "setNumber(uint256)" 123 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast send $COUNTER "increment()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast call $COUNTER "number()(uint256)" --rpc-url $RPC_URL

cast send $SIMPLE_STORAGE "setValue(uint256)" 777 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
cast storage $SIMPLE_STORAGE 0 --rpc-url $RPC_URL

cast send $LOGGER "log(bytes32,string)" \
  $(cast keccak "topic:demo") \
  "hello logs" \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY
```

Opcode practice:

1. Run `forge build`.
2. Open the bytecode in `out/Counter.sol/Counter.json`.
3. Compare opcodes with https://www.evm.codes/.
4. Search for `SLOAD`, `SSTORE`, `LOG`, `CALLDATALOAD`, and `JUMPI`.
