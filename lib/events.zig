// Soroban contract event utilities.
//
// Thin wrapper around the context.contract_event host function.

const val = @import("val.zig");
const env = @import("env.zig");
const Vec = @import("vec.zig").Vec;

/// Emit a contract event with the given topics and data.
/// `topics` must be a Vec with length <= 4.
pub fn contractEvent(topics: val.Vec, data: val.Val) void {
    _ = env.context.contract_event(topics, data);
}

/// Emit a contract event with topics given as a tuple and data as any Val-compatible type.
/// Example: `emit(.{ Symbol.fromString("transfer"), from, to }, amount)`
pub fn emit(topics: anytype, data: anytype) void {
    _ = env.context.contract_event(Vec.from(topics), val.asVal(data));
}
