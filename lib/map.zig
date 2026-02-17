// Soroban Map type.
//
// A host-managed sorted map accessed via a 64-bit tagged handle.

const val = @import("val.zig");
const env = @import("env.zig");
const Vec = @import("vec.zig").Vec;

pub const Map = extern struct {
    payload: u64,

    pub fn toVal(self: Map) val.Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: val.Val) Map {
        return .{ .payload = v.payload };
    }

    pub fn getHandle(self: Map) u32 {
        return @truncate(self.payload >> 32);
    }

    /// Create a new empty Map.
    pub fn new() Map {
        return env.map.map_new();
    }

    /// Get the value for a key. Traps if the key is not found.
    pub fn get(self: Map, key: anytype) val.Val {
        return env.map.map_get(self, val.asVal(key));
    }

    /// Insert or update a key/value pair.
    pub fn set(self: *Map, key: anytype, value: anytype) void {
        self.* = env.map.map_put(self.*, val.asVal(key), val.asVal(value));
    }

    /// Check whether a key exists.
    pub fn has(self: Map, key: anytype) bool {
        return env.map.map_has(self, val.asVal(key)).toBool();
    }

    /// Remove a key/value pair. Traps if the key is not found.
    pub fn del(self: *Map, key: anytype) void {
        self.* = env.map.map_del(self.*, val.asVal(key));
    }

    /// Return the number of entries.
    pub fn len(self: Map) u32 {
        return env.map.map_len(self).toU32();
    }

    /// Return a Vec of all keys in sorted order.
    pub fn keys(self: Map) Vec {
        return env.map.map_keys(self);
    }

    /// Return a Vec of all values in key-sorted order.
    pub fn values(self: Map) Vec {
        return env.map.map_values(self);
    }
};
