// Soroban cross-contract call utilities.
//
// Thin wrappers around the call host functions.

const val = @import("val.zig");
const env = @import("env.zig");

/// Call a function on another contract. Traps on failure.
pub fn call(contract: val.Address, func: val.Symbol, args: val.Vec) val.Val {
    return env.call.call(contract, func, args);
}

/// Call a function on another contract. Returns an Error val on failure
/// instead of trapping.
pub fn tryCall(contract: val.Address, func: val.Symbol, args: val.Vec) val.Val {
    return env.call.try_call(contract, func, args);
}
