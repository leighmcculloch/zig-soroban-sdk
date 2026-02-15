// Soroban contract event utilities.
//
// Thin wrapper around the context.contract_event host function.

const val = @import("val.zig");
const env = @import("env.zig");

/// Emit a contract event with the given topics and data.
/// `topics` must be a VecObject with length <= 4.
pub fn contractEvent(topics: val.VecObject, data: val.Val) void {
    _ = env.context.contract_event(topics, data);
}
