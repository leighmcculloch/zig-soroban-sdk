// Hello World Soroban Contract
//
// A minimal contract that takes a name (Symbol) and returns a Vec
// containing the strings "Hello" and the provided name.
//
// Build: zig build examples
// Usage: soroban contract invoke --id <id> -- --fn hello --to friend

const sdk = @import("soroban-sdk");

const HelloContract = struct {
    /// Greet the given name. Returns a Vec containing ["Hello", to].
    pub fn hello(to: sdk.Symbol) sdk.Vec {
        var greeting = sdk.Vec.new();
        greeting.pushBack(sdk.Symbol.fromString("Hello").toVal());
        greeting.pushBack(to.toVal());
        return greeting;
    }
};

comptime {
    _ = sdk.contract.exportContract(HelloContract);
}
