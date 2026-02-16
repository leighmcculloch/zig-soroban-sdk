# Token Example

> [!CAUTION]
> This is experimental and should not be used for anything other than toy experiments.

A basic fungible token implementing the [SEP-41] token interface.

## Build

```
zig build examples
```

## Usage

```
stellar contract deploy --wasm zig-out/contracts/token.wasm --alias tok --source me --network local \
  -- --admin me --decimal 7 --name '"My Token"' --symbol '"MTK"'
stellar contract invoke --id tok --source me --network local -- mint --to me --amount 1000000000
stellar contract invoke --id tok --source me --network local -- balance --id me
stellar contract invoke --id tok --source me --network local -- decimals
stellar contract invoke --id tok --source me --network local -- name
stellar contract invoke --id tok --source me --network local -- symbol
```

[SEP-41]: https://stellar.org/protocol/sep-41
