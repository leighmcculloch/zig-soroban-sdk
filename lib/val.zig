// Soroban Val type system.
//
// A Val is a 64-bit tagged value. The low 8 bits contain the tag,
// and the upper 56 bits contain the body. The body is further split
// into a 24-bit "minor" part (bits 8-31) and a 32-bit "major" part
// (bits 32-63).

const TAG_MASK: u64 = 0xff;
const BODY_BITS: u6 = 8;

const MAJOR_BITS: u6 = 32;
const MAJOR_MASK: u64 = 0xffff_ffff;
const MINOR_BITS: u6 = 24;
const MINOR_MASK: u64 = 0x00ff_ffff;

pub const Tag = enum(u8) {
    false_ = 0,
    true_ = 1,
    void_ = 2,
    error_ = 3,
    u32_val = 4,
    i32_val = 5,
    u64_small = 6,
    i64_small = 7,
    timepoint_small = 8,
    duration_small = 9,
    u128_small = 10,
    i128_small = 11,
    u256_small = 12,
    i256_small = 13,
    symbol_small = 14,
    small_code_upper_bound = 15,

    object_code_lower_bound = 63,
    u64_object = 64,
    i64_object = 65,
    timepoint_object = 66,
    duration_object = 67,
    u128_object = 68,
    i128_object = 69,
    u256_object = 70,
    i256_object = 71,
    bytes_object = 72,
    string_object = 73,
    symbol_object = 74,
    vec_object = 75,
    map_object = 76,
    address_object = 77,
    muxed_address_object = 78,
    object_code_upper_bound = 79,

    bad = 0x7f,
};

fn makeTaggedPayload(tag: Tag, body: u64) u64 {
    return (body << BODY_BITS) | @as(u64, @intFromEnum(tag));
}

fn getTag(payload: u64) Tag {
    const raw: u8 = @truncate(payload & TAG_MASK);
    return @enumFromInt(raw);
}

fn getBody(payload: u64) u64 {
    return payload >> BODY_BITS;
}

fn getMajor(payload: u64) u32 {
    return @truncate(payload >> (BODY_BITS + MINOR_BITS));
}

fn getMinor(payload: u64) u24 {
    return @truncate((payload >> BODY_BITS) & MINOR_MASK);
}

// ---------------------------------------------------------------------
// Val - the base tagged value type
// ---------------------------------------------------------------------

pub const Val = extern struct {
    payload: u64,

    pub fn toU64(self: Val) u64 {
        return self.payload;
    }

    pub fn fromU64(v: u64) Val {
        return .{ .payload = v };
    }

    pub fn getTag(self: Val) Tag {
        return val.getTag(self.payload);
    }

    pub fn getBody(self: Val) u64 {
        return val.getBody(self.payload);
    }

    pub fn getMajor(self: Val) u32 {
        return val.getMajor(self.payload);
    }

    pub fn getMinor(self: Val) u24 {
        return val.getMinor(self.payload);
    }
};

const val = @This();

/// Convert any Val-compatible type to Val. Accepts Val itself (returned as-is)
/// or any extern struct with a `payload: u64` field (Symbol, Vec, Map, Bytes,
/// Address, U32Val, I32Val, etc.).
pub fn asVal(x: anytype) Val {
    const T = @TypeOf(x);
    if (T == Val) return x;
    if (@hasField(T, "payload")) return .{ .payload = x.payload };
    @compileError("asVal: unsupported type " ++ @typeName(T));
}

// ---------------------------------------------------------------------
// Bool
// ---------------------------------------------------------------------

pub const Bool = extern struct {
    payload: u64,

    pub fn toVal(self: Bool) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) Bool {
        return .{ .payload = v.payload };
    }

    pub fn fromBool(b: bool) Bool {
        return .{ .payload = @intFromEnum(if (b) Tag.true_ else Tag.false_) };
    }

    pub fn toBool(self: Bool) bool {
        return getTag(self.payload) == Tag.true_;
    }
};

// ---------------------------------------------------------------------
// Void
// ---------------------------------------------------------------------

pub const Void = extern struct {
    payload: u64,

    pub const VOID: Void = .{ .payload = @intFromEnum(Tag.void_) };

    pub fn toVal(self: Void) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) Void {
        return .{ .payload = v.payload };
    }
};

// ---------------------------------------------------------------------
// Error
// ---------------------------------------------------------------------

pub const Error = extern struct {
    payload: u64,

    pub fn toVal(self: Error) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) Error {
        return .{ .payload = v.payload };
    }

    pub fn fromParts(error_type: u24, error_code: u32) Error {
        const body: u64 = @as(u64, error_type) | (@as(u64, error_code) << MINOR_BITS);
        return .{ .payload = makeTaggedPayload(Tag.error_, body) };
    }

    pub fn getErrorType(self: Error) u24 {
        return getMinor(self.payload);
    }

    pub fn getErrorCode(self: Error) u32 {
        return getMajor(self.payload);
    }

    /// Create a contract error with the given code.
    pub fn contractError(code: u32) Error {
        return fromParts(SCErrorType.Contract, code);
    }
};

pub const SCErrorType = struct {
    pub const WasmVm: u24 = 0;
    pub const Context: u24 = 1;
    pub const Storage: u24 = 2;
    pub const Object: u24 = 3;
    pub const Contract: u24 = 4;
    pub const Crypto: u24 = 5;
    pub const Events: u24 = 6;
    pub const Budget: u24 = 7;
    pub const Auth: u24 = 10;
};

// ---------------------------------------------------------------------
// U32Val
// ---------------------------------------------------------------------

pub const U32Val = extern struct {
    payload: u64,

    pub fn toVal(self: U32Val) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) U32Val {
        return .{ .payload = v.payload };
    }

    pub fn fromU32(v: u32) U32Val {
        return .{ .payload = makeTaggedPayload(Tag.u32_val, @as(u64, v) << MINOR_BITS) };
    }

    pub fn toU32(self: U32Val) u32 {
        return getMajor(self.payload);
    }
};

// ---------------------------------------------------------------------
// I32Val
// ---------------------------------------------------------------------

pub const I32Val = extern struct {
    payload: u64,

    pub fn toVal(self: I32Val) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) I32Val {
        return .{ .payload = v.payload };
    }

    pub fn fromI32(v: i32) I32Val {
        const bits: u32 = @bitCast(v);
        return .{ .payload = makeTaggedPayload(Tag.i32_val, @as(u64, bits) << MINOR_BITS) };
    }

    pub fn toI32(self: I32Val) i32 {
        return @bitCast(getMajor(self.payload));
    }
};

// ---------------------------------------------------------------------
// Small value types (body fits in 56 bits)
// ---------------------------------------------------------------------

pub const U64Val = extern struct {
    payload: u64,

    pub fn toVal(self: U64Val) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) U64Val {
        return .{ .payload = v.payload };
    }

    pub fn fromSmall(v: u56) U64Val {
        return .{ .payload = makeTaggedPayload(Tag.u64_small, @as(u64, v)) };
    }

    pub fn toSmall(self: U64Val) u56 {
        return @truncate(getBody(self.payload));
    }
};

pub const I64Val = extern struct {
    payload: u64,

    pub fn toVal(self: I64Val) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) I64Val {
        return .{ .payload = v.payload };
    }
};

pub const TimepointVal = extern struct {
    payload: u64,

    pub fn toVal(self: TimepointVal) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) TimepointVal {
        return .{ .payload = v.payload };
    }

    pub fn fromSmall(v: u56) TimepointVal {
        return .{ .payload = makeTaggedPayload(Tag.timepoint_small, @as(u64, v)) };
    }

    pub fn toSmall(self: TimepointVal) u56 {
        return @truncate(getBody(self.payload));
    }
};

pub const DurationVal = extern struct {
    payload: u64,

    pub fn toVal(self: DurationVal) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) DurationVal {
        return .{ .payload = v.payload };
    }

    pub fn fromSmall(v: u56) DurationVal {
        return .{ .payload = makeTaggedPayload(Tag.duration_small, @as(u64, v)) };
    }

    pub fn toSmall(self: DurationVal) u56 {
        return @truncate(getBody(self.payload));
    }
};

pub const U128Val = extern struct {
    payload: u64,

    pub fn toVal(self: U128Val) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) U128Val {
        return .{ .payload = v.payload };
    }

    pub fn fromSmall(v: u56) U128Val {
        return .{ .payload = makeTaggedPayload(Tag.u128_small, @as(u64, v)) };
    }

    pub fn toSmall(self: U128Val) u56 {
        return @truncate(getBody(self.payload));
    }
};

pub const I128Val = extern struct {
    payload: u64,

    pub fn toVal(self: I128Val) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) I128Val {
        return .{ .payload = v.payload };
    }

    pub fn fromSmall(v: i56) I128Val {
        const bits: u56 = @bitCast(v);
        return .{ .payload = makeTaggedPayload(Tag.i128_small, @as(u64, bits)) };
    }

    pub fn toSmall(self: I128Val) i56 {
        return @bitCast(@as(u56, @truncate(getBody(self.payload))));
    }
};

pub const U256Val = extern struct {
    payload: u64,

    pub fn toVal(self: U256Val) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) U256Val {
        return .{ .payload = v.payload };
    }

    pub fn fromSmall(v: u56) U256Val {
        return .{ .payload = makeTaggedPayload(Tag.u256_small, @as(u64, v)) };
    }

    pub fn toSmall(self: U256Val) u56 {
        return @truncate(getBody(self.payload));
    }
};

pub const I256Val = extern struct {
    payload: u64,

    pub fn toVal(self: I256Val) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) I256Val {
        return .{ .payload = v.payload };
    }
};

// ---------------------------------------------------------------------
// Symbol (small symbol, up to 9 chars of [_0-9A-Za-z], 6 bits each)
// ---------------------------------------------------------------------

pub const Symbol = extern struct {
    payload: u64,

    pub fn toVal(self: Symbol) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) Symbol {
        return .{ .payload = v.payload };
    }

    /// Encode a small symbol from a comptime-known string.
    /// Characters are packed 6 bits each from MSB to LSB into the
    /// body, with unused high bits left as zero. This matches the
    /// Rust SDK's SymbolSmall encoding.
    pub fn fromString(comptime s: []const u8) Symbol {
        if (s.len > 9) @compileError("SymbolSmall can hold at most 9 characters");
        comptime var body: u64 = 0;
        inline for (s) |c| {
            const code: u6 = comptime encodeSymbolChar(c);
            body = (body << 6) | @as(u64, code);
        }
        return .{ .payload = comptime makeTaggedPayload(Tag.symbol_small, body) };
    }

    fn encodeSymbolChar(c: u8) u6 {
        if (c == '_') return 1;
        if (c >= '0' and c <= '9') return @intCast(c - '0' + 2);
        if (c >= 'A' and c <= 'Z') return @intCast(c - 'A' + 12);
        if (c >= 'a' and c <= 'z') return @intCast(c - 'a' + 38);
        @compileError("invalid symbol character");
    }
};

// ---------------------------------------------------------------------
// StorageType (not a Val, marshalled directly as u64)
// ---------------------------------------------------------------------

pub const StorageType = extern struct {
    payload: u64,

    pub const temporary: StorageType = .{ .payload = 0 };
    pub const persistent: StorageType = .{ .payload = 1 };
    pub const instance: StorageType = .{ .payload = 2 };

    pub fn toVal(self: StorageType) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) StorageType {
        return .{ .payload = v.payload };
    }
};

// ---------------------------------------------------------------------
// ContractTTLExtension
// (used by ledger v2 TTL functions, marshalled as u64)
// ---------------------------------------------------------------------

pub const ContractTTLExtension = extern struct {
    payload: u64,

    pub fn toVal(self: ContractTTLExtension) Val {
        return .{ .payload = self.payload };
    }

    pub fn fromVal(v: Val) ContractTTLExtension {
        return .{ .payload = v.payload };
    }
};

// ---------------------------------------------------------------------
// Object types (tags 64-78)
//
// All objects use the major part (bits 32-63) as the object handle.
// The minor part (bits 8-31) is reserved (zero in current usage).
// ---------------------------------------------------------------------

fn makeObjectPayload(tag: Tag, handle: u32) u64 {
    return makeTaggedPayload(tag, @as(u64, handle) << MINOR_BITS);
}

fn objectHandle(payload: u64) u32 {
    return getMajor(payload);
}

pub const U64Object = extern struct {
    payload: u64,

    pub fn toVal(self: U64Object) Val {
        return .{ .payload = self.payload };
    }
    pub fn fromVal(v: Val) U64Object {
        return .{ .payload = v.payload };
    }
    pub fn toU64Val(self: U64Object) U64Val {
        return .{ .payload = self.payload };
    }
    pub fn getHandle(self: U64Object) u32 {
        return objectHandle(self.payload);
    }
};

pub const I64Object = extern struct {
    payload: u64,

    pub fn toVal(self: I64Object) Val {
        return .{ .payload = self.payload };
    }
    pub fn fromVal(v: Val) I64Object {
        return .{ .payload = v.payload };
    }
    pub fn toI64Val(self: I64Object) I64Val {
        return .{ .payload = self.payload };
    }
    pub fn getHandle(self: I64Object) u32 {
        return objectHandle(self.payload);
    }
};

pub const TimepointObject = extern struct {
    payload: u64,

    pub fn toVal(self: TimepointObject) Val {
        return .{ .payload = self.payload };
    }
    pub fn fromVal(v: Val) TimepointObject {
        return .{ .payload = v.payload };
    }
    pub fn toTimepointVal(self: TimepointObject) TimepointVal {
        return .{ .payload = self.payload };
    }
    pub fn getHandle(self: TimepointObject) u32 {
        return objectHandle(self.payload);
    }
};

pub const DurationObject = extern struct {
    payload: u64,

    pub fn toVal(self: DurationObject) Val {
        return .{ .payload = self.payload };
    }
    pub fn fromVal(v: Val) DurationObject {
        return .{ .payload = v.payload };
    }
    pub fn toDurationVal(self: DurationObject) DurationVal {
        return .{ .payload = self.payload };
    }
    pub fn getHandle(self: DurationObject) u32 {
        return objectHandle(self.payload);
    }
};

pub const U128Object = extern struct {
    payload: u64,

    pub fn toVal(self: U128Object) Val {
        return .{ .payload = self.payload };
    }
    pub fn fromVal(v: Val) U128Object {
        return .{ .payload = v.payload };
    }
    pub fn toU128Val(self: U128Object) U128Val {
        return .{ .payload = self.payload };
    }
    pub fn getHandle(self: U128Object) u32 {
        return objectHandle(self.payload);
    }
};

pub const I128Object = extern struct {
    payload: u64,

    pub fn toVal(self: I128Object) Val {
        return .{ .payload = self.payload };
    }
    pub fn fromVal(v: Val) I128Object {
        return .{ .payload = v.payload };
    }
    pub fn toI128Val(self: I128Object) I128Val {
        return .{ .payload = self.payload };
    }
    pub fn getHandle(self: I128Object) u32 {
        return objectHandle(self.payload);
    }
};

pub const U256Object = extern struct {
    payload: u64,

    pub fn toVal(self: U256Object) Val {
        return .{ .payload = self.payload };
    }
    pub fn fromVal(v: Val) U256Object {
        return .{ .payload = v.payload };
    }
    pub fn toU256Val(self: U256Object) U256Val {
        return .{ .payload = self.payload };
    }
    pub fn getHandle(self: U256Object) u32 {
        return objectHandle(self.payload);
    }
};

pub const I256Object = extern struct {
    payload: u64,

    pub fn toVal(self: I256Object) Val {
        return .{ .payload = self.payload };
    }
    pub fn fromVal(v: Val) I256Object {
        return .{ .payload = v.payload };
    }
    pub fn toI256Val(self: I256Object) I256Val {
        return .{ .payload = self.payload };
    }
    pub fn getHandle(self: I256Object) u32 {
        return objectHandle(self.payload);
    }
};

pub const Bytes = @import("bytes.zig").Bytes;

pub const StringObject = extern struct {
    payload: u64,

    pub fn toVal(self: StringObject) Val {
        return .{ .payload = self.payload };
    }
    pub fn fromVal(v: Val) StringObject {
        return .{ .payload = v.payload };
    }
    pub fn getHandle(self: StringObject) u32 {
        return objectHandle(self.payload);
    }
};

pub const SymbolObject = extern struct {
    payload: u64,

    pub fn toVal(self: SymbolObject) Val {
        return .{ .payload = self.payload };
    }
    pub fn fromVal(v: Val) SymbolObject {
        return .{ .payload = v.payload };
    }
    pub fn getHandle(self: SymbolObject) u32 {
        return objectHandle(self.payload);
    }
};

pub const Vec = @import("vec.zig").Vec;
pub const Map = @import("map.zig").Map;
pub const Address = @import("address.zig").Address;

pub const MuxedAddressObject = extern struct {
    payload: u64,

    pub fn toVal(self: MuxedAddressObject) Val {
        return .{ .payload = self.payload };
    }
    pub fn fromVal(v: Val) MuxedAddressObject {
        return .{ .payload = v.payload };
    }
    pub fn getHandle(self: MuxedAddressObject) u32 {
        return objectHandle(self.payload);
    }
};

// ---------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------

const testing = @import("std").testing;

// ----- Comptime assertions -----

comptime {
    // Val must be exactly 8 bytes (64 bits) for ABI compatibility.
    if (@sizeOf(Val) != 8) @compileError("Val must be 8 bytes");
    if (@sizeOf(Bool) != 8) @compileError("Bool must be 8 bytes");
    if (@sizeOf(Void) != 8) @compileError("Void must be 8 bytes");
    if (@sizeOf(Error) != 8) @compileError("Error must be 8 bytes");
    if (@sizeOf(U32Val) != 8) @compileError("U32Val must be 8 bytes");
    if (@sizeOf(I32Val) != 8) @compileError("I32Val must be 8 bytes");
    if (@sizeOf(U64Val) != 8) @compileError("U64Val must be 8 bytes");
    if (@sizeOf(I64Val) != 8) @compileError("I64Val must be 8 bytes");
    if (@sizeOf(Symbol) != 8) @compileError("Symbol must be 8 bytes");
    if (@sizeOf(U64Object) != 8) @compileError("U64Object must be 8 bytes");
    if (@sizeOf(Bytes) != 8) @compileError("Bytes must be 8 bytes");
    if (@sizeOf(Vec) != 8) @compileError("Vec must be 8 bytes");
    if (@sizeOf(Map) != 8) @compileError("Map must be 8 bytes");
    if (@sizeOf(Address) != 8) @compileError("Address must be 8 bytes");
    if (@sizeOf(StorageType) != 8) @compileError("StorageType must be 8 bytes");
}

// ----- Val basic operations -----

test "Val fromU64/toU64 round-trip" {
    const raw: u64 = 0xDEAD_BEEF_CAFE_BABE;
    const v = Val.fromU64(raw);
    try testing.expectEqual(raw, v.toU64());
}

test "Val tag extraction" {
    const u32v = U32Val.fromU32(0);
    try testing.expectEqual(Tag.u32_val, u32v.toVal().getTag());

    const i32v = I32Val.fromI32(0);
    try testing.expectEqual(Tag.i32_val, i32v.toVal().getTag());

    const t = Bool.fromBool(true);
    try testing.expectEqual(Tag.true_, t.toVal().getTag());

    const f = Bool.fromBool(false);
    try testing.expectEqual(Tag.false_, f.toVal().getTag());

    const void_val = Void.VOID;
    try testing.expectEqual(Tag.void_, void_val.toVal().getTag());

    const err = Error.fromParts(0, 0);
    try testing.expectEqual(Tag.error_, err.toVal().getTag());

    const u64v = U64Val.fromSmall(0);
    try testing.expectEqual(Tag.u64_small, u64v.toVal().getTag());

    const tp = TimepointVal.fromSmall(0);
    try testing.expectEqual(Tag.timepoint_small, tp.toVal().getTag());

    const dur = DurationVal.fromSmall(0);
    try testing.expectEqual(Tag.duration_small, dur.toVal().getTag());

    const u128v = U128Val.fromSmall(0);
    try testing.expectEqual(Tag.u128_small, u128v.toVal().getTag());

    const u256v = U256Val.fromSmall(0);
    try testing.expectEqual(Tag.u256_small, u256v.toVal().getTag());

    const sym = Symbol.fromString("");
    try testing.expectEqual(Tag.symbol_small, sym.toVal().getTag());
}

test "Val getMajor and getMinor" {
    const v = U32Val.fromU32(0xABCD_1234);
    try testing.expectEqual(@as(u32, 0xABCD_1234), v.toVal().getMajor());
    try testing.expectEqual(@as(u24, 0), v.toVal().getMinor());
}

// ----- U32Val -----

test "U32Val round-trip zero" {
    const v = U32Val.fromU32(0);
    try testing.expectEqual(@as(u32, 0), v.toU32());
    try testing.expectEqual(Tag.u32_val, v.toVal().getTag());
}

test "U32Val round-trip one" {
    const v = U32Val.fromU32(1);
    try testing.expectEqual(@as(u32, 1), v.toU32());
    try testing.expectEqual(Tag.u32_val, v.toVal().getTag());
}

test "U32Val round-trip max" {
    const v = U32Val.fromU32(0xFFFF_FFFF);
    try testing.expectEqual(@as(u32, 0xFFFF_FFFF), v.toU32());
    try testing.expectEqual(Tag.u32_val, v.toVal().getTag());
}

test "U32Val round-trip 42" {
    const v = U32Val.fromU32(42);
    try testing.expectEqual(@as(u32, 42), v.toU32());
    try testing.expectEqual(Tag.u32_val, v.toVal().getTag());
}

test "U32Val Val conversion round-trip" {
    const original = U32Val.fromU32(999);
    const as_val = original.toVal();
    const back = U32Val.fromVal(as_val);
    try testing.expectEqual(@as(u32, 999), back.toU32());
}

// ----- I32Val -----

test "I32Val round-trip zero" {
    const v = I32Val.fromI32(0);
    try testing.expectEqual(@as(i32, 0), v.toI32());
    try testing.expectEqual(Tag.i32_val, v.toVal().getTag());
}

test "I32Val round-trip negative one" {
    const v = I32Val.fromI32(-1);
    try testing.expectEqual(@as(i32, -1), v.toI32());
    try testing.expectEqual(Tag.i32_val, v.toVal().getTag());
}

test "I32Val round-trip positive one" {
    const v = I32Val.fromI32(1);
    try testing.expectEqual(@as(i32, 1), v.toI32());
    try testing.expectEqual(Tag.i32_val, v.toVal().getTag());
}

test "I32Val round-trip min" {
    const v = I32Val.fromI32(-2147483648); // std.math.minInt(i32)
    try testing.expectEqual(@as(i32, -2147483648), v.toI32());
    try testing.expectEqual(Tag.i32_val, v.toVal().getTag());
}

test "I32Val round-trip max" {
    const v = I32Val.fromI32(2147483647); // std.math.maxInt(i32)
    try testing.expectEqual(@as(i32, 2147483647), v.toI32());
    try testing.expectEqual(Tag.i32_val, v.toVal().getTag());
}

test "I32Val round-trip negative" {
    const v = I32Val.fromI32(-7);
    try testing.expectEqual(@as(i32, -7), v.toI32());
    try testing.expectEqual(Tag.i32_val, v.toVal().getTag());
}

test "I32Val round-trip positive" {
    const v = I32Val.fromI32(100);
    try testing.expectEqual(@as(i32, 100), v.toI32());
}

test "I32Val Val conversion round-trip" {
    const original = I32Val.fromI32(-42);
    const as_val = original.toVal();
    const back = I32Val.fromVal(as_val);
    try testing.expectEqual(@as(i32, -42), back.toI32());
}

// ----- Bool -----

test "Bool round-trip true" {
    const t = Bool.fromBool(true);
    try testing.expect(t.toBool());
    try testing.expectEqual(Tag.true_, t.toVal().getTag());
}

test "Bool round-trip false" {
    const f = Bool.fromBool(false);
    try testing.expect(!f.toBool());
    try testing.expectEqual(Tag.false_, f.toVal().getTag());
}

test "Bool true and false have different payloads" {
    const t = Bool.fromBool(true);
    const f = Bool.fromBool(false);
    try testing.expect(t.payload != f.payload);
}

test "Bool Val conversion round-trip" {
    const original = Bool.fromBool(true);
    const as_val = original.toVal();
    const back = Bool.fromVal(as_val);
    try testing.expect(back.toBool());
}

// ----- Void -----

test "Void tag" {
    const v = Void.VOID;
    try testing.expectEqual(Tag.void_, v.toVal().getTag());
}

test "Void Val conversion" {
    const v = Void.VOID;
    const as_val = v.toVal();
    const back = Void.fromVal(as_val);
    try testing.expectEqual(Tag.void_, back.toVal().getTag());
    try testing.expectEqual(v.payload, back.payload);
}

// ----- Error -----

test "Error parts round-trip" {
    const e = Error.fromParts(1, 42);
    try testing.expectEqual(@as(u24, 1), e.getErrorType());
    try testing.expectEqual(@as(u32, 42), e.getErrorCode());
    try testing.expectEqual(Tag.error_, e.toVal().getTag());
}

test "Error zero parts" {
    const e = Error.fromParts(0, 0);
    try testing.expectEqual(@as(u24, 0), e.getErrorType());
    try testing.expectEqual(@as(u32, 0), e.getErrorCode());
    try testing.expectEqual(Tag.error_, e.toVal().getTag());
}

test "Error max error code" {
    const e = Error.fromParts(0, 0xFFFF_FFFF);
    try testing.expectEqual(@as(u32, 0xFFFF_FFFF), e.getErrorCode());
    try testing.expectEqual(@as(u24, 0), e.getErrorType());
}

test "Error Val conversion round-trip" {
    const original = Error.fromParts(5, 100);
    const as_val = original.toVal();
    const back = Error.fromVal(as_val);
    try testing.expectEqual(@as(u24, 5), back.getErrorType());
    try testing.expectEqual(@as(u32, 100), back.getErrorCode());
}

// ----- U64Val small -----

test "U64Val small round-trip zero" {
    const v = U64Val.fromSmall(0);
    try testing.expectEqual(@as(u56, 0), v.toSmall());
    try testing.expectEqual(Tag.u64_small, v.toVal().getTag());
}

test "U64Val small round-trip" {
    const v = U64Val.fromSmall(12345);
    try testing.expectEqual(@as(u56, 12345), v.toSmall());
    try testing.expectEqual(Tag.u64_small, v.toVal().getTag());
}

test "U64Val small round-trip large value" {
    const max: u56 = @as(u56, 0x00FF_FFFF_FFFF_FFFF);
    const v = U64Val.fromSmall(max);
    try testing.expectEqual(max, v.toSmall());
    try testing.expectEqual(Tag.u64_small, v.toVal().getTag());
}

test "U64Val Val conversion round-trip" {
    const original = U64Val.fromSmall(9999);
    const as_val = original.toVal();
    const back = U64Val.fromVal(as_val);
    try testing.expectEqual(@as(u56, 9999), back.toSmall());
}

// ----- TimepointVal small -----

test "TimepointVal small round-trip" {
    const v = TimepointVal.fromSmall(1000);
    try testing.expectEqual(@as(u56, 1000), v.toSmall());
    try testing.expectEqual(Tag.timepoint_small, v.toVal().getTag());
}

test "TimepointVal small round-trip zero" {
    const v = TimepointVal.fromSmall(0);
    try testing.expectEqual(@as(u56, 0), v.toSmall());
    try testing.expectEqual(Tag.timepoint_small, v.toVal().getTag());
}

// ----- DurationVal small -----

test "DurationVal small round-trip" {
    const v = DurationVal.fromSmall(5000);
    try testing.expectEqual(@as(u56, 5000), v.toSmall());
    try testing.expectEqual(Tag.duration_small, v.toVal().getTag());
}

test "DurationVal small round-trip zero" {
    const v = DurationVal.fromSmall(0);
    try testing.expectEqual(@as(u56, 0), v.toSmall());
    try testing.expectEqual(Tag.duration_small, v.toVal().getTag());
}

// ----- U128Val small -----

test "U128Val small round-trip" {
    const v = U128Val.fromSmall(777);
    try testing.expectEqual(@as(u56, 777), v.toSmall());
    try testing.expectEqual(Tag.u128_small, v.toVal().getTag());
}

test "U128Val small round-trip zero" {
    const v = U128Val.fromSmall(0);
    try testing.expectEqual(@as(u56, 0), v.toSmall());
    try testing.expectEqual(Tag.u128_small, v.toVal().getTag());
}

// ----- I128Val small -----

test "I128Val small round-trip zero" {
    const v = I128Val.fromSmall(0);
    try testing.expectEqual(@as(i56, 0), v.toSmall());
    try testing.expectEqual(Tag.i128_small, v.toVal().getTag());
}

test "I128Val small round-trip positive" {
    const v = I128Val.fromSmall(12345);
    try testing.expectEqual(@as(i56, 12345), v.toSmall());
    try testing.expectEqual(Tag.i128_small, v.toVal().getTag());
}

test "I128Val small round-trip negative" {
    const v = I128Val.fromSmall(-1);
    try testing.expectEqual(@as(i56, -1), v.toSmall());
    try testing.expectEqual(Tag.i128_small, v.toVal().getTag());
}

test "I128Val small round-trip negative large" {
    const v = I128Val.fromSmall(-99999);
    try testing.expectEqual(@as(i56, -99999), v.toSmall());
    try testing.expectEqual(Tag.i128_small, v.toVal().getTag());
}

// ----- U256Val small -----

test "U256Val small round-trip" {
    const v = U256Val.fromSmall(256);
    try testing.expectEqual(@as(u56, 256), v.toSmall());
    try testing.expectEqual(Tag.u256_small, v.toVal().getTag());
}

test "U256Val small round-trip zero" {
    const v = U256Val.fromSmall(0);
    try testing.expectEqual(@as(u56, 0), v.toSmall());
    try testing.expectEqual(Tag.u256_small, v.toVal().getTag());
}

// ----- Symbol -----

test "Symbol empty string" {
    const sym = Symbol.fromString("");
    try testing.expectEqual(Tag.symbol_small, sym.toVal().getTag());
}

test "Symbol 1 char" {
    const sym = Symbol.fromString("a");
    try testing.expectEqual(Tag.symbol_small, sym.toVal().getTag());
}

test "Symbol 2 chars" {
    const sym = Symbol.fromString("ab");
    try testing.expectEqual(Tag.symbol_small, sym.toVal().getTag());
}

test "Symbol 3 chars" {
    const sym = Symbol.fromString("abc");
    try testing.expectEqual(Tag.symbol_small, sym.toVal().getTag());
}

test "Symbol 5 chars" {
    const sym = Symbol.fromString("hello");
    try testing.expectEqual(Tag.symbol_small, sym.toVal().getTag());
}

test "Symbol 9 chars (max)" {
    const sym = Symbol.fromString("abcdefghi");
    try testing.expectEqual(Tag.symbol_small, sym.toVal().getTag());
}

test "Symbol encoding matches Rust SDK test vectors" {
    // These test vectors are from rs-soroban-env symbol.rs test_enc
    // "a" -> body = 0b100110 = 38
    const sym_a = Symbol.fromString("a");
    try testing.expectEqual(@as(u64, 38), getBody(sym_a.payload));
    // "ab" -> body = (38 << 6) | 39 = 2471
    const sym_ab = Symbol.fromString("ab");
    try testing.expectEqual(@as(u64, (38 << 6) | 39), getBody(sym_ab.payload));
    // "abc" -> body = (38 << 12) | (39 << 6) | 40
    const sym_abc = Symbol.fromString("abc");
    try testing.expectEqual(@as(u64, (38 << 12) | (39 << 6) | 40), getBody(sym_abc.payload));
    // "ABC" -> body = (12 << 12) | (13 << 6) | 14
    const sym_ABC = Symbol.fromString("ABC");
    try testing.expectEqual(@as(u64, (12 << 12) | (13 << 6) | 14), getBody(sym_ABC.payload));
}

test "Symbol different strings produce different payloads" {
    const a = Symbol.fromString("a");
    const b = Symbol.fromString("b");
    try testing.expect(a.payload != b.payload);
}

test "Symbol underscore" {
    const sym = Symbol.fromString("_");
    try testing.expectEqual(Tag.symbol_small, sym.toVal().getTag());
}

test "Symbol digits" {
    const sym = Symbol.fromString("012345678");
    try testing.expectEqual(Tag.symbol_small, sym.toVal().getTag());
}

test "Symbol uppercase" {
    const sym = Symbol.fromString("ABCDEFGHI");
    try testing.expectEqual(Tag.symbol_small, sym.toVal().getTag());
}

test "Symbol mixed characters" {
    const sym = Symbol.fromString("a_B1");
    try testing.expectEqual(Tag.symbol_small, sym.toVal().getTag());
}

test "Symbol Val conversion round-trip" {
    const original = Symbol.fromString("test");
    const as_val = original.toVal();
    const back = Symbol.fromVal(as_val);
    try testing.expectEqual(original.payload, back.payload);
}

// ----- Object types -----

test "U64Object creation and handle" {
    const obj = U64Object{ .payload = makeObjectPayload(Tag.u64_object, 7) };
    try testing.expectEqual(@as(u32, 7), obj.getHandle());
    try testing.expectEqual(Tag.u64_object, obj.toVal().getTag());
}

test "I64Object creation and handle" {
    const obj = I64Object{ .payload = makeObjectPayload(Tag.i64_object, 3) };
    try testing.expectEqual(@as(u32, 3), obj.getHandle());
    try testing.expectEqual(Tag.i64_object, obj.toVal().getTag());
}

test "TimepointObject creation and handle" {
    const obj = TimepointObject{ .payload = makeObjectPayload(Tag.timepoint_object, 10) };
    try testing.expectEqual(@as(u32, 10), obj.getHandle());
    try testing.expectEqual(Tag.timepoint_object, obj.toVal().getTag());
}

test "DurationObject creation and handle" {
    const obj = DurationObject{ .payload = makeObjectPayload(Tag.duration_object, 20) };
    try testing.expectEqual(@as(u32, 20), obj.getHandle());
    try testing.expectEqual(Tag.duration_object, obj.toVal().getTag());
}

test "U128Object creation and handle" {
    const obj = U128Object{ .payload = makeObjectPayload(Tag.u128_object, 15) };
    try testing.expectEqual(@as(u32, 15), obj.getHandle());
    try testing.expectEqual(Tag.u128_object, obj.toVal().getTag());
}

test "I128Object creation and handle" {
    const obj = I128Object{ .payload = makeObjectPayload(Tag.i128_object, 25) };
    try testing.expectEqual(@as(u32, 25), obj.getHandle());
    try testing.expectEqual(Tag.i128_object, obj.toVal().getTag());
}

test "U256Object creation and handle" {
    const obj = U256Object{ .payload = makeObjectPayload(Tag.u256_object, 30) };
    try testing.expectEqual(@as(u32, 30), obj.getHandle());
    try testing.expectEqual(Tag.u256_object, obj.toVal().getTag());
}

test "I256Object creation and handle" {
    const obj = I256Object{ .payload = makeObjectPayload(Tag.i256_object, 35) };
    try testing.expectEqual(@as(u32, 35), obj.getHandle());
    try testing.expectEqual(Tag.i256_object, obj.toVal().getTag());
}

test "Bytes creation and handle" {
    const obj = Bytes{ .payload = makeObjectPayload(Tag.bytes_object, 100) };
    try testing.expectEqual(@as(u32, 100), obj.getHandle());
    try testing.expectEqual(Tag.bytes_object, obj.toVal().getTag());
}

test "StringObject creation and handle" {
    const obj = StringObject{ .payload = makeObjectPayload(Tag.string_object, 200) };
    try testing.expectEqual(@as(u32, 200), obj.getHandle());
    try testing.expectEqual(Tag.string_object, obj.toVal().getTag());
}

test "SymbolObject creation and handle" {
    const obj = SymbolObject{ .payload = makeObjectPayload(Tag.symbol_object, 50) };
    try testing.expectEqual(@as(u32, 50), obj.getHandle());
    try testing.expectEqual(Tag.symbol_object, obj.toVal().getTag());
}

test "Vec creation and handle" {
    const obj = Vec{ .payload = makeObjectPayload(Tag.vec_object, 0) };
    try testing.expectEqual(@as(u32, 0), obj.getHandle());
    try testing.expectEqual(Tag.vec_object, obj.toVal().getTag());
}

test "Map creation and handle" {
    const obj = Map{ .payload = makeObjectPayload(Tag.map_object, 0xFFFF_FFFF) };
    try testing.expectEqual(@as(u32, 0xFFFF_FFFF), obj.getHandle());
    try testing.expectEqual(Tag.map_object, obj.toVal().getTag());
}

test "Address creation and handle" {
    const obj = Address{ .payload = makeObjectPayload(Tag.address_object, 42) };
    try testing.expectEqual(@as(u32, 42), obj.getHandle());
    try testing.expectEqual(Tag.address_object, obj.toVal().getTag());
}

test "MuxedAddressObject creation and handle" {
    const obj = MuxedAddressObject{ .payload = makeObjectPayload(Tag.muxed_address_object, 99) };
    try testing.expectEqual(@as(u32, 99), obj.getHandle());
    try testing.expectEqual(Tag.muxed_address_object, obj.toVal().getTag());
}

test "Object handle zero" {
    const obj = U64Object{ .payload = makeObjectPayload(Tag.u64_object, 0) };
    try testing.expectEqual(@as(u32, 0), obj.getHandle());
}

test "Object handle max" {
    const obj = Bytes{ .payload = makeObjectPayload(Tag.bytes_object, 0xFFFF_FFFF) };
    try testing.expectEqual(@as(u32, 0xFFFF_FFFF), obj.getHandle());
}

test "U64Object toU64Val conversion" {
    const obj = U64Object{ .payload = makeObjectPayload(Tag.u64_object, 5) };
    const u64val = obj.toU64Val();
    try testing.expectEqual(obj.payload, u64val.payload);
}

test "I64Object toI64Val conversion" {
    const obj = I64Object{ .payload = makeObjectPayload(Tag.i64_object, 5) };
    const i64val = obj.toI64Val();
    try testing.expectEqual(obj.payload, i64val.payload);
}

test "TimepointObject toTimepointVal conversion" {
    const obj = TimepointObject{ .payload = makeObjectPayload(Tag.timepoint_object, 5) };
    const tpval = obj.toTimepointVal();
    try testing.expectEqual(obj.payload, tpval.payload);
}

test "DurationObject toDurationVal conversion" {
    const obj = DurationObject{ .payload = makeObjectPayload(Tag.duration_object, 5) };
    const durval = obj.toDurationVal();
    try testing.expectEqual(obj.payload, durval.payload);
}

test "U128Object toU128Val conversion" {
    const obj = U128Object{ .payload = makeObjectPayload(Tag.u128_object, 5) };
    const u128val = obj.toU128Val();
    try testing.expectEqual(obj.payload, u128val.payload);
}

test "I128Object toI128Val conversion" {
    const obj = I128Object{ .payload = makeObjectPayload(Tag.i128_object, 5) };
    const i128val = obj.toI128Val();
    try testing.expectEqual(obj.payload, i128val.payload);
}

test "U256Object toU256Val conversion" {
    const obj = U256Object{ .payload = makeObjectPayload(Tag.u256_object, 5) };
    const u256val = obj.toU256Val();
    try testing.expectEqual(obj.payload, u256val.payload);
}

test "I256Object toI256Val conversion" {
    const obj = I256Object{ .payload = makeObjectPayload(Tag.i256_object, 5) };
    const i256val = obj.toI256Val();
    try testing.expectEqual(obj.payload, i256val.payload);
}

// ----- StorageType -----

test "StorageType constants are raw u64 values" {
    // StorageType is NOT a Val type - it's marshalled directly as u64
    // per rs-soroban-env storage_type.rs: #[repr(u64)] with raw values
    try testing.expectEqual(@as(u64, 0), StorageType.temporary.payload);
    try testing.expectEqual(@as(u64, 1), StorageType.persistent.payload);
    try testing.expectEqual(@as(u64, 2), StorageType.instance.payload);
}

test "StorageType Val conversion" {
    const st = StorageType.persistent;
    const as_val = st.toVal();
    const back = StorageType.fromVal(as_val);
    try testing.expectEqual(st.payload, back.payload);
}

// ----- ContractTTLExtension -----

test "ContractTTLExtension Val conversion round-trip" {
    const ext = ContractTTLExtension{ .payload = 12345 };
    const as_val = ext.toVal();
    const back = ContractTTLExtension.fromVal(as_val);
    try testing.expectEqual(ext.payload, back.payload);
}

// ----- Tag enum -----

test "Tag values match Soroban spec" {
    try testing.expectEqual(@as(u8, 0), @intFromEnum(Tag.false_));
    try testing.expectEqual(@as(u8, 1), @intFromEnum(Tag.true_));
    try testing.expectEqual(@as(u8, 2), @intFromEnum(Tag.void_));
    try testing.expectEqual(@as(u8, 3), @intFromEnum(Tag.error_));
    try testing.expectEqual(@as(u8, 4), @intFromEnum(Tag.u32_val));
    try testing.expectEqual(@as(u8, 5), @intFromEnum(Tag.i32_val));
    try testing.expectEqual(@as(u8, 6), @intFromEnum(Tag.u64_small));
    try testing.expectEqual(@as(u8, 7), @intFromEnum(Tag.i64_small));
    try testing.expectEqual(@as(u8, 8), @intFromEnum(Tag.timepoint_small));
    try testing.expectEqual(@as(u8, 9), @intFromEnum(Tag.duration_small));
    try testing.expectEqual(@as(u8, 10), @intFromEnum(Tag.u128_small));
    try testing.expectEqual(@as(u8, 11), @intFromEnum(Tag.i128_small));
    try testing.expectEqual(@as(u8, 12), @intFromEnum(Tag.u256_small));
    try testing.expectEqual(@as(u8, 13), @intFromEnum(Tag.i256_small));
    try testing.expectEqual(@as(u8, 14), @intFromEnum(Tag.symbol_small));
    try testing.expectEqual(@as(u8, 64), @intFromEnum(Tag.u64_object));
    try testing.expectEqual(@as(u8, 65), @intFromEnum(Tag.i64_object));
    try testing.expectEqual(@as(u8, 66), @intFromEnum(Tag.timepoint_object));
    try testing.expectEqual(@as(u8, 67), @intFromEnum(Tag.duration_object));
    try testing.expectEqual(@as(u8, 68), @intFromEnum(Tag.u128_object));
    try testing.expectEqual(@as(u8, 69), @intFromEnum(Tag.i128_object));
    try testing.expectEqual(@as(u8, 70), @intFromEnum(Tag.u256_object));
    try testing.expectEqual(@as(u8, 71), @intFromEnum(Tag.i256_object));
    try testing.expectEqual(@as(u8, 72), @intFromEnum(Tag.bytes_object));
    try testing.expectEqual(@as(u8, 73), @intFromEnum(Tag.string_object));
    try testing.expectEqual(@as(u8, 74), @intFromEnum(Tag.symbol_object));
    try testing.expectEqual(@as(u8, 75), @intFromEnum(Tag.vec_object));
    try testing.expectEqual(@as(u8, 76), @intFromEnum(Tag.map_object));
    try testing.expectEqual(@as(u8, 77), @intFromEnum(Tag.address_object));
    try testing.expectEqual(@as(u8, 78), @intFromEnum(Tag.muxed_address_object));
    try testing.expectEqual(@as(u8, 0x7f), @intFromEnum(Tag.bad));
}
