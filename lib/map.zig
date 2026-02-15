// Soroban Map type.
//
// A thin wrapper around MapObject providing typed access to the
// host-managed sorted map.

const val = @import("val.zig");
const env = @import("env.zig");

pub const Map = struct {
    obj: val.MapObject,

    /// Create a new empty Map.
    pub fn new() Map {
        return .{ .obj = env.map.map_new() };
    }

    /// Wrap a raw MapObject.
    pub fn fromObject(obj: val.MapObject) Map {
        return .{ .obj = obj };
    }

    /// Get the underlying MapObject.
    pub fn toObject(self: Map) val.MapObject {
        return self.obj;
    }

    /// Get the value for a key. Traps if the key is not found.
    pub fn get(self: Map, key: val.Val) val.Val {
        return env.map.map_get(self.obj, key);
    }

    /// Insert or update a key/value pair.
    pub fn set(self: *Map, key: val.Val, value: val.Val) void {
        self.obj = env.map.map_put(self.obj, key, value);
    }

    /// Check whether a key exists.
    pub fn has(self: Map, key: val.Val) bool {
        return env.map.map_has(self.obj, key).toBool();
    }

    /// Remove a key/value pair. Traps if the key is not found.
    pub fn del(self: *Map, key: val.Val) void {
        self.obj = env.map.map_del(self.obj, key);
    }

    /// Return the number of entries.
    pub fn len(self: Map) u32 {
        return env.map.map_len(self.obj).toU32();
    }

    /// Return a VecObject of all keys in sorted order.
    pub fn keys(self: Map) val.VecObject {
        return env.map.map_keys(self.obj);
    }

    /// Return a VecObject of all values in key-sorted order.
    pub fn values(self: Map) val.VecObject {
        return env.map.map_values(self.obj);
    }
};
