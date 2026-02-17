// Soroban Bytes type.
//
// A host-managed byte array accessed via a 64-bit tagged handle.
// Includes linear memory copy helpers.

const val = @import("val.zig");
const env = @import("env.zig");

pub const Bytes = extern struct {
    payload: u64,

    pub fn toVal(self: Bytes) val.Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: val.Val) Bytes {
        return .{ .payload = v.payload };
    }

    pub fn getHandle(self: Bytes) u32 {
        return @truncate(self.payload >> 32);
    }

    /// Create a new empty Bytes.
    pub fn new() Bytes {
        return env.buf.bytes_new();
    }

    /// Create a Bytes from a comptime or runtime slice by copying it from
    /// linear memory into the host.
    pub fn fromSlice(data: []const u8) Bytes {
        return env.buf.bytes_new_from_linear_memory(
            val.U32Val.fromU32(@intCast(@intFromPtr(data.ptr))),
            val.U32Val.fromU32(@intCast(data.len)),
        );
    }

    /// Return the number of bytes.
    pub fn len(self: Bytes) u32 {
        return env.buf.bytes_len(self).toU32();
    }

    /// Get the byte at index `i`.
    pub fn get(self: Bytes, i: u32) u8 {
        return @truncate(env.buf.bytes_get(self, val.U32Val.fromU32(i)).toU32());
    }

    /// Set the byte at index `i`.
    pub fn set(self: *Bytes, i: u32, byte: u8) void {
        self.* = env.buf.bytes_put(self.*, val.U32Val.fromU32(i), val.U32Val.fromU32(@as(u32, byte)));
    }

    /// Append a byte to the end.
    pub fn push(self: *Bytes, byte: u8) void {
        self.* = env.buf.bytes_push(self.*, val.U32Val.fromU32(@as(u32, byte)));
    }

    /// Remove and discard the last byte.
    pub fn pop(self: *Bytes) void {
        self.* = env.buf.bytes_pop(self.*);
    }

    /// Delete the byte at index `i`, shifting subsequent bytes left.
    pub fn del(self: *Bytes, i: u32) void {
        self.* = env.buf.bytes_del(self.*, val.U32Val.fromU32(i));
    }

    /// Insert a byte at index `i`, shifting subsequent bytes right.
    pub fn insert(self: *Bytes, i: u32, byte: u8) void {
        self.* = env.buf.bytes_insert(self.*, val.U32Val.fromU32(i), val.U32Val.fromU32(@as(u32, byte)));
    }

    /// Return the first byte. Traps if empty.
    pub fn front(self: Bytes) u8 {
        return @truncate(env.buf.bytes_front(self).toU32());
    }

    /// Return the last byte. Traps if empty.
    pub fn back(self: Bytes) u8 {
        return @truncate(env.buf.bytes_back(self).toU32());
    }

    /// Return a new Bytes containing bytes from `start` (inclusive) to `end` (exclusive).
    pub fn slice(self: Bytes, start: u32, end: u32) Bytes {
        return env.buf.bytes_slice(self, val.U32Val.fromU32(start), val.U32Val.fromU32(end));
    }

    /// Append all bytes from another Bytes.
    pub fn append(self: *Bytes, other: Bytes) void {
        self.* = env.buf.bytes_append(self.*, other);
    }

    /// Copy bytes from this Bytes object into a linear memory buffer.
    pub fn copyToSlice(self: Bytes, dest: []u8, src_offset: u32) void {
        _ = env.buf.bytes_copy_to_linear_memory(
            self,
            val.U32Val.fromU32(src_offset),
            val.U32Val.fromU32(@intCast(@intFromPtr(dest.ptr))),
            val.U32Val.fromU32(@intCast(dest.len)),
        );
    }

    /// Copy bytes from a linear memory buffer into this Bytes object.
    pub fn copyFromSlice(self: *Bytes, src: []const u8, dest_offset: u32) void {
        self.* = env.buf.bytes_copy_from_linear_memory(
            self.*,
            val.U32Val.fromU32(dest_offset),
            val.U32Val.fromU32(@intCast(@intFromPtr(src.ptr))),
            val.U32Val.fromU32(@intCast(src.len)),
        );
    }
};
