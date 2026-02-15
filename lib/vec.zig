// Soroban Vec type.
//
// A thin wrapper around VecObject providing typed access to the
// host-managed vector.

const val = @import("val.zig");
const env = @import("env.zig");

pub const Vec = struct {
    obj: val.VecObject,

    /// Create a new empty Vec.
    pub fn new() Vec {
        return .{ .obj = env.vec.vec_new() };
    }

    /// Wrap a raw VecObject.
    pub fn fromObject(obj: val.VecObject) Vec {
        return .{ .obj = obj };
    }

    /// Get the underlying VecObject.
    pub fn toObject(self: Vec) val.VecObject {
        return self.obj;
    }

    /// Return the number of elements.
    pub fn len(self: Vec) u32 {
        return env.vec.vec_len(self.obj).toU32();
    }

    /// Get the element at index `i`.
    pub fn get(self: Vec, i: u32) val.Val {
        return env.vec.vec_get(self.obj, val.U32Val.fromU32(i));
    }

    /// Set the element at index `i`, returning the updated Vec.
    pub fn set(self: *Vec, i: u32, x: val.Val) void {
        self.obj = env.vec.vec_put(self.obj, val.U32Val.fromU32(i), x);
    }

    /// Append an element to the back.
    pub fn pushBack(self: *Vec, x: val.Val) void {
        self.obj = env.vec.vec_push_back(self.obj, x);
    }

    /// Prepend an element to the front.
    pub fn pushFront(self: *Vec, x: val.Val) void {
        self.obj = env.vec.vec_push_front(self.obj, x);
    }

    /// Remove and discard the last element.
    pub fn popBack(self: *Vec) void {
        self.obj = env.vec.vec_pop_back(self.obj);
    }

    /// Remove and discard the first element.
    pub fn popFront(self: *Vec) void {
        self.obj = env.vec.vec_pop_front(self.obj);
    }

    /// Return the first element.
    pub fn front(self: Vec) val.Val {
        return env.vec.vec_front(self.obj);
    }

    /// Return the last element.
    pub fn back(self: Vec) val.Val {
        return env.vec.vec_back(self.obj);
    }

    /// Insert an element at index `i`, shifting subsequent elements right.
    pub fn insert(self: *Vec, i: u32, x: val.Val) void {
        self.obj = env.vec.vec_insert(self.obj, val.U32Val.fromU32(i), x);
    }

    /// Delete the element at index `i`, shifting subsequent elements left.
    pub fn del(self: *Vec, i: u32) void {
        self.obj = env.vec.vec_del(self.obj, val.U32Val.fromU32(i));
    }

    /// Append all elements from another Vec.
    pub fn append(self: *Vec, other: Vec) void {
        self.obj = env.vec.vec_append(self.obj, other.obj);
    }

    /// Return a new Vec containing elements from `start` (inclusive) to `end` (exclusive).
    pub fn slice(self: Vec, start: u32, end: u32) Vec {
        return .{ .obj = env.vec.vec_slice(self.obj, val.U32Val.fromU32(start), val.U32Val.fromU32(end)) };
    }
};
