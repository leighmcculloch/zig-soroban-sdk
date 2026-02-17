const val = @import("val.zig");
const env = @import("env.zig");

/// Serialize a Val into XDR opaque Bytes.
pub fn toBytes(v: val.Val) val.Bytes {
    return env.buf.serialize_to_bytes(v);
}

/// Deserialize XDR opaque Bytes back into a Val.
pub fn fromBytes(b: val.Bytes) val.Val {
    return env.buf.deserialize_from_bytes(b);
}
