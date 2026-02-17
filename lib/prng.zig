const val = @import("val.zig");
const env = @import("env.zig");

/// Reseed the frame-local PRNG with the given 32-byte seed.
pub fn reseed(seed: val.Bytes) void {
    _ = env.prng.prng_reseed(seed);
}

/// Generate a new Bytes object of the given length filled with random bytes.
pub fn bytesNew(length: u32) val.Bytes {
    return env.prng.prng_bytes_new(val.U32Val.fromU32(length));
}

/// Return a u64 uniformly sampled from the inclusive range [lo, hi].
pub fn u64InRange(lo: u64, hi: u64) u64 {
    return env.prng.prng_u64_in_inclusive_range(lo, hi);
}

/// Return a Fisher-Yates shuffled clone of the given vector.
pub fn vecShuffle(v: val.Vec) val.Vec {
    return env.prng.prng_vec_shuffle(v);
}
