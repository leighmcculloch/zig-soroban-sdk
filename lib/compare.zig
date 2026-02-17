const val = @import("val.zig");
const env = @import("env.zig");

/// Structurally compare two Val values.
/// Returns -1 if a < b, 0 if a == b, 1 if a > b.
pub fn cmp(a: val.Val, b: val.Val) i32 {
    const result = env.context.obj_cmp(a, b);
    return @intCast(result);
}
