// Soroban String type.
//
// A host-managed string accessed via a 64-bit tagged handle.

const val = @import("val.zig");
const env = @import("env.zig");

pub const String = extern struct {
    payload: u64,

    pub fn toVal(self: String) val.Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: val.Val) String {
        return .{ .payload = v.payload };
    }

    pub fn getHandle(self: String) u32 {
        return @truncate(self.payload >> 32);
    }

    /// Create a String from a slice by copying it from linear memory.
    pub fn fromSlice(data: []const u8) String {
        return env.buf.string_new_from_linear_memory(
            val.U32Val.fromU32(@intCast(@intFromPtr(data.ptr))),
            val.U32Val.fromU32(@intCast(data.len)),
        );
    }

    /// Return the length of the string.
    pub fn len(self: String) u32 {
        return env.buf.string_len(self).toU32();
    }

    /// Convert this String to a Bytes object with the same contents.
    pub fn toBytes(self: String) val.Bytes {
        return env.buf.string_to_bytes(self);
    }

    /// Copy the string contents into a linear memory slice.
    pub fn copyToSlice(self: String, dest: []u8) void {
        _ = env.buf.string_copy_to_linear_memory(
            self,
            val.U32Val.fromU32(0),
            val.U32Val.fromU32(@intCast(@intFromPtr(dest.ptr))),
            val.U32Val.fromU32(@intCast(dest.len)),
        );
    }
};

/// Convert a Bytes object to a String with the same contents.
pub fn bytesToString(b: val.Bytes) String {
    return env.buf.bytes_to_string(b);
}
