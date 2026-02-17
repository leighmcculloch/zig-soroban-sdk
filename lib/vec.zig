// Soroban Vec type.
//
// A host-managed vector accessed via a 64-bit tagged handle.

const val = @import("val.zig");
const env = @import("env.zig");

pub const Vec = extern struct {
    payload: u64,

    pub fn toVal(self: Vec) val.Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: val.Val) Vec {
        return .{ .payload = v.payload };
    }

    pub fn getHandle(self: Vec) u32 {
        return @truncate(self.payload >> 32);
    }

    /// Create a new empty Vec.
    pub fn new() Vec {
        return env.vec.vec_new();
    }

    /// Create a Vec from a tuple of Val-compatible elements.
    /// Example: `Vec.from(.{ symbol, addr, amount })`
    pub fn from(args: anytype) Vec {
        var v = Vec.new();
        const fields = @typeInfo(@TypeOf(args)).@"struct".fields;
        inline for (fields) |f| {
            v.pushBack(@field(args, f.name));
        }
        return v;
    }

    /// Return the number of elements.
    pub fn len(self: Vec) u32 {
        return env.vec.vec_len(self).toU32();
    }

    /// Get the element at index `i`.
    pub fn get(self: Vec, i: u32) val.Val {
        return env.vec.vec_get(self, val.U32Val.fromU32(i));
    }

    /// Set the element at index `i`, returning the updated Vec.
    pub fn set(self: *Vec, i: u32, x: anytype) void {
        self.* = env.vec.vec_put(self.*, val.U32Val.fromU32(i), val.asVal(x));
    }

    /// Append an element to the back.
    pub fn pushBack(self: *Vec, x: anytype) void {
        self.* = env.vec.vec_push_back(self.*, val.asVal(x));
    }

    /// Prepend an element to the front.
    pub fn pushFront(self: *Vec, x: anytype) void {
        self.* = env.vec.vec_push_front(self.*, val.asVal(x));
    }

    /// Remove and discard the last element.
    pub fn popBack(self: *Vec) void {
        self.* = env.vec.vec_pop_back(self.*);
    }

    /// Remove and discard the first element.
    pub fn popFront(self: *Vec) void {
        self.* = env.vec.vec_pop_front(self.*);
    }

    /// Return the first element.
    pub fn front(self: Vec) val.Val {
        return env.vec.vec_front(self);
    }

    /// Return the last element.
    pub fn back(self: Vec) val.Val {
        return env.vec.vec_back(self);
    }

    /// Insert an element at index `i`, shifting subsequent elements right.
    pub fn insert(self: *Vec, i: u32, x: anytype) void {
        self.* = env.vec.vec_insert(self.*, val.U32Val.fromU32(i), val.asVal(x));
    }

    /// Delete the element at index `i`, shifting subsequent elements left.
    pub fn del(self: *Vec, i: u32) void {
        self.* = env.vec.vec_del(self.*, val.U32Val.fromU32(i));
    }

    /// Append all elements from another Vec.
    pub fn append(self: *Vec, other: Vec) void {
        self.* = env.vec.vec_append(self.*, other);
    }

    /// Return a new Vec containing elements from `start` (inclusive) to `end` (exclusive).
    pub fn slice(self: Vec, start: u32, end: u32) Vec {
        return env.vec.vec_slice(self, val.U32Val.fromU32(start), val.U32Val.fromU32(end));
    }
};
