# Gas and attack surface notes

Gas is not just a fee. It is a resource limit that shapes design.

Things to observe:

- Storage writes are expensive, especially zero-to-nonzero `SSTORE`.
- Emitting events is cheaper than storing data, but logs are not readable by contracts.
- Calldata size costs gas. Large arrays and strings can become expensive.
- Loops over dynamic arrays can make functions unusable if the array grows too much.
- External calls expand the attack surface. Update internal accounting before sending ETH.

Use these commands:

```bash
forge test --gas-report
forge test -vvv
forge snapshot
```

Questions to answer in your notes:

1. Which function costs most gas and why?
2. What storage writes happen in `Counter.increment()`?
3. Why does `EducationalPaymentSplitter.release()` update state before calling `account.call`?
4. What happens to remainders when ETH is split with integer division?
5. Which public functions should worry you if the payee list became very large?
