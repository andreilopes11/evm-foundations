RPC_URL ?= http://127.0.0.1:8545
PRIVATE_KEY ?=
COUNTER ?=
SIMPLE_STORAGE ?=

.PHONY: build test gas abi selectors block counter-number counter-increment storage-value

build:
	forge build

test:
	forge test

gas:
	forge test --gas-report

abi:
	forge inspect Counter abi
	forge inspect SimpleStorage abi
	forge inspect EventLogger abi
	forge inspect EducationalPaymentSplitter abi

selectors:
	cast sig "increment()"
	cast sig "setNumber(uint256)"
	cast sig "log(bytes32,string)"
	cast sig "release(address)"

block:
	cast block latest --rpc-url $(RPC_URL)

counter-number:
	cast call $(COUNTER) "number()(uint256)" --rpc-url $(RPC_URL)

counter-increment:
	cast send $(COUNTER) "increment()" --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY)

storage-value:
	cast storage $(SIMPLE_STORAGE) 0 --rpc-url $(RPC_URL)
