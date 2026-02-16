// Integer conversion utilities.
// Wrappers around the "i" (int) module host functions for converting
// between native Zig integer types and Soroban object representations.

const env = @import("env.zig");
const val = @import("val.zig");

const U64Object = val.U64Object;
const I64Object = val.I64Object;
const U128Object = val.U128Object;
const I128Object = val.I128Object;
const U256Object = val.U256Object;
const I256Object = val.I256Object;
const U256Val = val.U256Val;
const I256Val = val.I256Val;
const U32Val = val.U32Val;
const BytesObject = val.BytesObject;
const TimepointObject = val.TimepointObject;
const DurationObject = val.DurationObject;

// ---- u64 ----

pub fn u64FromObj(obj: U64Object) u64 {
    return env.int.obj_to_u64(obj);
}

pub fn u64ToObj(v: u64) U64Object {
    return env.int.obj_from_u64(v);
}

// ---- i64 ----

pub fn i64FromObj(obj: I64Object) i64 {
    return env.int.obj_to_i64(obj);
}

pub fn i64ToObj(v: i64) I64Object {
    return env.int.obj_from_i64(v);
}

// ---- u128 ----

pub fn u128FromObj(obj: U128Object) u128 {
    const lo: u64 = env.int.obj_to_u128_lo64(obj);
    const hi: u64 = env.int.obj_to_u128_hi64(obj);
    return @as(u128, hi) << 64 | @as(u128, lo);
}

pub fn u128ToObj(v: u128) U128Object {
    const lo: u64 = @truncate(v);
    const hi: u64 = @truncate(v >> 64);
    return env.int.obj_from_u128_pieces(hi, lo);
}

// ---- i128 ----

pub fn i128FromObj(obj: I128Object) i128 {
    const lo: u64 = env.int.obj_to_i128_lo64(obj);
    const hi: i64 = env.int.obj_to_i128_hi64(obj);
    return @as(i128, hi) << 64 | @as(i128, lo);
}

pub fn i128ToObj(v: i128) I128Object {
    const bits: u128 = @bitCast(v);
    const lo: u64 = @truncate(bits);
    const hi: i64 = @bitCast(@as(u64, @truncate(bits >> 64)));
    return env.int.obj_from_i128_pieces(hi, lo);
}

// ---- i128 Val (small or object) ----

pub fn i128FromVal(v: val.I128Val) i128 {
    if (v.toVal().getTag() == val.Tag.i128_small) {
        return @as(i128, v.toSmall());
    }
    return i128FromObj(val.I128Object.fromVal(v.toVal()));
}

pub fn i128ToVal(v: i128) val.I128Val {
    const min_small: i128 = -(1 << 55);
    const max_small: i128 = (1 << 55) - 1;
    if (v >= min_small and v <= max_small) {
        return val.I128Val.fromSmall(@intCast(v));
    }
    return i128ToObj(v).toI128Val();
}

// ---- u256 (4x u64, big-endian order: hi_hi, hi_lo, lo_hi, lo_lo) ----

pub const U256Pieces = struct {
    hi_hi: u64,
    hi_lo: u64,
    lo_hi: u64,
    lo_lo: u64,
};

pub fn u256FromObj(obj: U256Object) U256Pieces {
    return .{
        .hi_hi = env.int.obj_to_u256_hi_hi(obj),
        .hi_lo = env.int.obj_to_u256_hi_lo(obj),
        .lo_hi = env.int.obj_to_u256_lo_hi(obj),
        .lo_lo = env.int.obj_to_u256_lo_lo(obj),
    };
}

pub fn u256ToObj(hi_hi: u64, hi_lo: u64, lo_hi: u64, lo_lo: u64) U256Object {
    return env.int.obj_from_u256_pieces(hi_hi, hi_lo, lo_hi, lo_lo);
}

pub fn u256ValFromBeBytes(bytes: BytesObject) U256Val {
    return env.int.u256_val_from_be_bytes(bytes);
}

pub fn u256ValToBeBytes(v: U256Val) BytesObject {
    return env.int.u256_val_to_be_bytes(v);
}

// ---- i256 (4x u64/i64, big-endian order) ----

pub const I256Pieces = struct {
    hi_hi: i64,
    hi_lo: u64,
    lo_hi: u64,
    lo_lo: u64,
};

pub fn i256FromObj(obj: I256Object) I256Pieces {
    return .{
        .hi_hi = env.int.obj_to_i256_hi_hi(obj),
        .hi_lo = env.int.obj_to_i256_hi_lo(obj),
        .lo_hi = env.int.obj_to_i256_lo_hi(obj),
        .lo_lo = env.int.obj_to_i256_lo_lo(obj),
    };
}

pub fn i256ToObj(hi_hi: i64, hi_lo: u64, lo_hi: u64, lo_lo: u64) I256Object {
    return env.int.obj_from_i256_pieces(hi_hi, hi_lo, lo_hi, lo_lo);
}

pub fn i256ValFromBeBytes(bytes: BytesObject) I256Val {
    return env.int.i256_val_from_be_bytes(bytes);
}

pub fn i256ValToBeBytes(v: I256Val) BytesObject {
    return env.int.i256_val_to_be_bytes(v);
}

// ---- u256 arithmetic ----

pub fn u256Add(lhs: U256Val, rhs: U256Val) U256Val {
    return env.int.u256_add(lhs, rhs);
}

pub fn u256Sub(lhs: U256Val, rhs: U256Val) U256Val {
    return env.int.u256_sub(lhs, rhs);
}

pub fn u256Mul(lhs: U256Val, rhs: U256Val) U256Val {
    return env.int.u256_mul(lhs, rhs);
}

pub fn u256Div(lhs: U256Val, rhs: U256Val) U256Val {
    return env.int.u256_div(lhs, rhs);
}

pub fn u256RemEuclid(lhs: U256Val, rhs: U256Val) U256Val {
    return env.int.u256_rem_euclid(lhs, rhs);
}

pub fn u256Pow(lhs: U256Val, rhs: U32Val) U256Val {
    return env.int.u256_pow(lhs, rhs);
}

pub fn u256Shl(lhs: U256Val, rhs: U32Val) U256Val {
    return env.int.u256_shl(lhs, rhs);
}

pub fn u256Shr(lhs: U256Val, rhs: U32Val) U256Val {
    return env.int.u256_shr(lhs, rhs);
}

// ---- i256 arithmetic ----

pub fn i256Add(lhs: I256Val, rhs: I256Val) I256Val {
    return env.int.i256_add(lhs, rhs);
}

pub fn i256Sub(lhs: I256Val, rhs: I256Val) I256Val {
    return env.int.i256_sub(lhs, rhs);
}

pub fn i256Mul(lhs: I256Val, rhs: I256Val) I256Val {
    return env.int.i256_mul(lhs, rhs);
}

pub fn i256Div(lhs: I256Val, rhs: I256Val) I256Val {
    return env.int.i256_div(lhs, rhs);
}

pub fn i256RemEuclid(lhs: I256Val, rhs: I256Val) I256Val {
    return env.int.i256_rem_euclid(lhs, rhs);
}

pub fn i256Pow(lhs: I256Val, rhs: U32Val) I256Val {
    return env.int.i256_pow(lhs, rhs);
}

pub fn i256Shl(lhs: I256Val, rhs: U32Val) I256Val {
    return env.int.i256_shl(lhs, rhs);
}

pub fn i256Shr(lhs: I256Val, rhs: U32Val) I256Val {
    return env.int.i256_shr(lhs, rhs);
}

// ---- Timepoint / Duration ----

pub fn timepointObjFromU64(v: u64) TimepointObject {
    return env.int.timepoint_obj_from_u64(v);
}

pub fn timepointObjToU64(obj: TimepointObject) u64 {
    return env.int.timepoint_obj_to_u64(obj);
}

pub fn durationObjFromU64(v: u64) DurationObject {
    return env.int.duration_obj_from_u64(v);
}

pub fn durationObjToU64(obj: DurationObject) u64 {
    return env.int.duration_obj_to_u64(obj);
}

// =====================================================================
// Tests
// =====================================================================

const testing = @import("std").testing;

// Comptime assertions for struct layout
comptime {
    if (@sizeOf(U256Pieces) != 32) @compileError("U256Pieces must be 32 bytes (4 x u64)");
    if (@sizeOf(I256Pieces) != 32) @compileError("I256Pieces must be 32 bytes (4 x u64/i64)");
}

test "U256Pieces field layout" {
    const p = U256Pieces{
        .hi_hi = 0xAAAA_BBBB_CCCC_DDDD,
        .hi_lo = 0x1111_2222_3333_4444,
        .lo_hi = 0x5555_6666_7777_8888,
        .lo_lo = 0x9999_0000_AAAA_BBBB,
    };
    try testing.expectEqual(@as(u64, 0xAAAA_BBBB_CCCC_DDDD), p.hi_hi);
    try testing.expectEqual(@as(u64, 0x1111_2222_3333_4444), p.hi_lo);
    try testing.expectEqual(@as(u64, 0x5555_6666_7777_8888), p.lo_hi);
    try testing.expectEqual(@as(u64, 0x9999_0000_AAAA_BBBB), p.lo_lo);
}

test "U256Pieces all zeros" {
    const p = U256Pieces{ .hi_hi = 0, .hi_lo = 0, .lo_hi = 0, .lo_lo = 0 };
    try testing.expectEqual(@as(u64, 0), p.hi_hi);
    try testing.expectEqual(@as(u64, 0), p.hi_lo);
    try testing.expectEqual(@as(u64, 0), p.lo_hi);
    try testing.expectEqual(@as(u64, 0), p.lo_lo);
}

test "I256Pieces field layout" {
    const p = I256Pieces{
        .hi_hi = -1,
        .hi_lo = 0xFFFF_FFFF_FFFF_FFFF,
        .lo_hi = 0xFFFF_FFFF_FFFF_FFFF,
        .lo_lo = 0xFFFF_FFFF_FFFF_FFFF,
    };
    try testing.expectEqual(@as(i64, -1), p.hi_hi);
    try testing.expectEqual(@as(u64, 0xFFFF_FFFF_FFFF_FFFF), p.hi_lo);
    try testing.expectEqual(@as(u64, 0xFFFF_FFFF_FFFF_FFFF), p.lo_hi);
    try testing.expectEqual(@as(u64, 0xFFFF_FFFF_FFFF_FFFF), p.lo_lo);
}

test "I256Pieces all zeros" {
    const p = I256Pieces{ .hi_hi = 0, .hi_lo = 0, .lo_hi = 0, .lo_lo = 0 };
    try testing.expectEqual(@as(i64, 0), p.hi_hi);
    try testing.expectEqual(@as(u64, 0), p.hi_lo);
    try testing.expectEqual(@as(u64, 0), p.lo_hi);
    try testing.expectEqual(@as(u64, 0), p.lo_lo);
}

test "I256Pieces negative hi_hi" {
    const p = I256Pieces{
        .hi_hi = -9223372036854775808, // min i64
        .hi_lo = 0,
        .lo_hi = 0,
        .lo_lo = 0,
    };
    try testing.expectEqual(@as(i64, -9223372036854775808), p.hi_hi);
}

test "I256Pieces max positive hi_hi" {
    const p = I256Pieces{
        .hi_hi = 9223372036854775807, // max i64
        .hi_lo = 0xFFFF_FFFF_FFFF_FFFF,
        .lo_hi = 0xFFFF_FFFF_FFFF_FFFF,
        .lo_lo = 0xFFFF_FFFF_FFFF_FFFF,
    };
    try testing.expectEqual(@as(i64, 9223372036854775807), p.hi_hi);
}
