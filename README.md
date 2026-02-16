# zig-soroban-sdk

> [!CAUTION]
> This is experimental and should not be used for anything other than toy experiments.

A Zig SDK for writing [Soroban] smart contracts on the [Stellar] network.

## Requirements

- [Zig](https://ziglang.org) 0.15+
- [Stellar CLI](https://github.com/stellar/stellar-cli) (for deploying and invoking contracts)

## Build

Build the SDK library and examples:

```
zig build examples
```

Run tests:

```
zig build test
```

## Examples

| Example | Description |
|---------|-------------|
| [hello](examples/hello) | Hello world contract |
| [increment](examples/increment) | Counter stored in contract data |
| [token](examples/token) | SEP-41 fungible token |

## Usage

Add the SDK as a dependency in your `build.zig.zon`, then import it in your contract:

```zig
const sdk = @import("soroban-sdk");

const MyContract = struct {
    pub fn hello(to: sdk.Symbol) sdk.VecObject {
        // ...
    }
};

comptime {
    _ = sdk.contract.exportContract(MyContract);
}
```

[Soroban]: https://soroban.stellar.org
[Stellar]: https://stellar.org
