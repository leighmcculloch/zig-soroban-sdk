const val = @import("val.zig");
const env = @import("env.zig");

/// Log a diagnostic message with optional Val arguments.
///
/// `msg` is a comptime string literal. `vals` is a tuple of Val-compatible
/// values (anything accepted by `val.asVal`). If `vals` is empty, no values
/// array is passed to the host.
///
/// Example:
///   log.log("balance is {}", .{balance});
///   log.log("hello", .{});
pub fn log(comptime msg: []const u8, vals: anytype) void {
    const fields = @typeInfo(@TypeOf(vals)).@"struct".fields;
    if (fields.len == 0) {
        _ = env.context.log_from_linear_memory(
            val.U32Val.fromU32(@intFromPtr(msg.ptr)),
            val.U32Val.fromU32(msg.len),
            val.U32Val.fromU32(0),
            val.U32Val.fromU32(0),
        );
    } else {
        var arr: [fields.len]u64 = undefined;
        inline for (fields, 0..) |f, i| {
            arr[i] = val.asVal(@field(vals, f.name)).payload;
        }
        _ = env.context.log_from_linear_memory(
            val.U32Val.fromU32(@intFromPtr(msg.ptr)),
            val.U32Val.fromU32(msg.len),
            val.U32Val.fromU32(@intFromPtr(&arr)),
            val.U32Val.fromU32(fields.len),
        );
    }
}
