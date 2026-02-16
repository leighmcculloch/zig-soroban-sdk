// Contract spec generation and export.
//
// This module provides `exportContract`, a comptime function that takes a
// contract struct type and:
//   1. Generates wasm export wrappers for each public function.
//   2. Encodes XDR ScSpecEntry bytes for each function at comptime.
//   3. Embeds the spec in a "contractspecv0" wasm custom section.
//   4. Embeds environment metadata in a "contractenvmetav0" section.
//
// Usage:
//   const sdk = @import("soroban-sdk");
//   const MyContract = struct {
//       pub fn hello(to: sdk.Symbol) sdk.VecObject {
//           // ...
//       }
//   };
//   comptime {
//       _ = sdk.contract.exportContract(MyContract);
//   }

const val = @import("val.zig");
const Val = val.Val;

// =====================================================================
// XDR binary encoding helpers (comptime only)
// =====================================================================

// XDR uses big-endian, 4-byte aligned encoding.

const XdrWriter = struct {
    buf: []u8,
    pos: usize,

    fn init(buf: []u8) XdrWriter {
        return .{ .buf = buf, .pos = 0 };
    }

    fn writeU32(self: *XdrWriter, v: u32) void {
        self.buf[self.pos] = @truncate(v >> 24);
        self.buf[self.pos + 1] = @truncate(v >> 16);
        self.buf[self.pos + 2] = @truncate(v >> 8);
        self.buf[self.pos + 3] = @truncate(v);
        self.pos += 4;
    }

    fn writeI32(self: *XdrWriter, v: i32) void {
        self.writeU32(@bitCast(v));
    }

    // XDR variable-length opaque / string: 4-byte length prefix, then
    // data padded to a 4-byte boundary.
    fn writeString(self: *XdrWriter, s: []const u8) void {
        self.writeU32(@intCast(s.len));
        for (s) |c| {
            self.buf[self.pos] = c;
            self.pos += 1;
        }
        // Pad to 4-byte boundary
        const pad = (4 - (s.len % 4)) % 4;
        for (0..pad) |_| {
            self.buf[self.pos] = 0;
            self.pos += 1;
        }
    }
};

// Calculate the XDR-encoded size of a string (length prefix + data + padding).
fn xdrStringSize(len: usize) usize {
    const pad = (4 - (len % 4)) % 4;
    return 4 + len + pad;
}

// =====================================================================
// XDR ScSpecTypeDef encoding
// =====================================================================

// SCSpecType discriminant values (from Stellar-contract-spec.x)
const SC_SPEC_TYPE_VAL: u32 = 0;
const SC_SPEC_TYPE_BOOL: u32 = 1;
const SC_SPEC_TYPE_VOID: u32 = 2;
const SC_SPEC_TYPE_ERROR: u32 = 3;
const SC_SPEC_TYPE_U32: u32 = 4;
const SC_SPEC_TYPE_I32: u32 = 5;
const SC_SPEC_TYPE_U64: u32 = 6;
const SC_SPEC_TYPE_I64: u32 = 7;
const SC_SPEC_TYPE_TIMEPOINT: u32 = 8;
const SC_SPEC_TYPE_DURATION: u32 = 9;
const SC_SPEC_TYPE_U128: u32 = 10;
const SC_SPEC_TYPE_I128: u32 = 11;
const SC_SPEC_TYPE_U256: u32 = 12;
const SC_SPEC_TYPE_I256: u32 = 13;
const SC_SPEC_TYPE_BYTES: u32 = 14;
const SC_SPEC_TYPE_STRING: u32 = 16;
const SC_SPEC_TYPE_SYMBOL: u32 = 17;
const SC_SPEC_TYPE_ADDRESS: u32 = 19;

// SCSpecEntryKind discriminant values
const SC_SPEC_ENTRY_FUNCTION_V0: u32 = 0;

// SCEnvMetaKind
const SC_ENV_META_KIND_INTERFACE_VERSION: u32 = 0;

// Map a Zig Val type to its XDR SCSpecType discriminant.
// Returns null if the type is not a recognized spec type.
fn specTypeForValType(comptime T: type) ?u32 {
    if (T == val.Val) return SC_SPEC_TYPE_VAL;
    if (T == val.Bool) return SC_SPEC_TYPE_BOOL;
    if (T == val.Void) return SC_SPEC_TYPE_VOID;
    if (T == val.Error) return SC_SPEC_TYPE_ERROR;
    if (T == val.U32Val) return SC_SPEC_TYPE_U32;
    if (T == val.I32Val) return SC_SPEC_TYPE_I32;
    if (T == val.U64Val or T == val.U64Object) return SC_SPEC_TYPE_U64;
    if (T == val.I64Val or T == val.I64Object) return SC_SPEC_TYPE_I64;
    if (T == val.TimepointVal or T == val.TimepointObject) return SC_SPEC_TYPE_TIMEPOINT;
    if (T == val.DurationVal or T == val.DurationObject) return SC_SPEC_TYPE_DURATION;
    if (T == val.U128Val or T == val.U128Object) return SC_SPEC_TYPE_U128;
    if (T == val.I128Val or T == val.I128Object) return SC_SPEC_TYPE_I128;
    if (T == val.U256Val or T == val.U256Object) return SC_SPEC_TYPE_U256;
    if (T == val.I256Val or T == val.I256Object) return SC_SPEC_TYPE_I256;
    if (T == val.BytesObject) return SC_SPEC_TYPE_BYTES;
    if (T == val.StringObject) return SC_SPEC_TYPE_STRING;
    if (T == val.Symbol or T == val.SymbolObject) return SC_SPEC_TYPE_SYMBOL;
    if (T == val.AddressObject or T == val.MuxedAddressObject) return SC_SPEC_TYPE_ADDRESS;
    if (T == val.VecObject) return SC_SPEC_TYPE_VAL; // Vec<Val> - generic
    if (T == val.MapObject) return SC_SPEC_TYPE_VAL; // Map<Val,Val> - generic
    return null;
}

// Size of an SCSpecTypeDef encoding: just the 4-byte discriminant for
// simple types (no parameters).
fn specTypeDefSize(comptime spec_type: u32) usize {
    _ = spec_type;
    return 4; // discriminant only for simple types
}

fn writeSpecTypeDef(w: *XdrWriter, spec_type: u32) void {
    w.writeU32(spec_type);
}

// =====================================================================
// Contract function spec sizing and encoding
// =====================================================================

// Calculate the XDR-encoded size for a single SCSpecEntry::FunctionV0.
//
// Layout:
//   SCSpecEntryKind discriminant: 4 bytes
//   SCSpecFunctionV0:
//     doc: string (empty)    = xdrStringSize(0) = 4
//     name: SCSymbol (string) = xdrStringSize(name.len)
//     inputs: array<SCSpecFunctionInputV0>
//       length prefix: 4
//       per input:
//         doc: string (empty) = 4
//         name: string        = xdrStringSize(param_name.len)
//         type: SCSpecTypeDef = 4
//     outputs: array<SCSpecTypeDef>
//       length prefix: 4
//       per output: SCSpecTypeDef = 4
fn functionSpecSize(comptime name: []const u8, comptime Fn: type, comptime param_names: []const []const u8) usize {
    const fn_info = @typeInfo(Fn).@"fn";
    const params = fn_info.params;
    const return_type = fn_info.return_type orelse val.Void;

    var size: usize = 0;
    size += 4; // SCSpecEntryKind
    size += xdrStringSize(0); // doc (empty)
    size += xdrStringSize(name.len); // function name
    size += 4; // inputs array length
    inline for (params, 0..) |param, i| {
        _ = param;
        size += xdrStringSize(0); // input doc (empty)
        size += xdrStringSize(param_names[i].len); // input name
        size += 4; // input type
    }
    size += 4; // outputs array length
    // Output type
    const ret_spec = specTypeForValType(return_type);
    if (ret_spec != null and ret_spec.? != SC_SPEC_TYPE_VOID) {
        size += 4; // output type
    }
    return size;
}

fn writeFunctionSpec(w: *XdrWriter, comptime name: []const u8, comptime Fn: type, comptime param_names: []const []const u8) void {
    const fn_info = @typeInfo(Fn).@"fn";
    const params = fn_info.params;
    const return_type = fn_info.return_type orelse val.Void;

    w.writeU32(SC_SPEC_ENTRY_FUNCTION_V0);
    w.writeString(""); // doc
    w.writeString(name); // function name (SCSymbol)

    // Inputs
    w.writeU32(@intCast(params.len));
    inline for (params, 0..) |param, i| {
        w.writeString(""); // input doc
        w.writeString(param_names[i]); // input name
        const T = param.type orelse val.Val;
        const spec = specTypeForValType(T) orelse SC_SPEC_TYPE_VAL;
        writeSpecTypeDef(w, spec);
    }

    // Outputs
    const ret_spec = specTypeForValType(return_type);
    if (ret_spec != null and ret_spec.? != SC_SPEC_TYPE_VOID) {
        w.writeU32(1);
        writeSpecTypeDef(w, ret_spec.?);
    } else {
        w.writeU32(0);
    }
}

// =====================================================================
// SCEnvMetaEntry encoding for contractenvmetav0
// =====================================================================

// Current Soroban protocol version. This should be kept in sync with
// the version of the Soroban host environment this SDK targets.
pub const PROTOCOL_VERSION: u32 = 25;
pub const PRE_RELEASE_VERSION: u32 = 0;

// SCEnvMetaEntry size:
//   kind discriminant: 4
//   interfaceVersion.protocol: 4
//   interfaceVersion.preRelease: 4
const ENV_META_SIZE: usize = 12;

fn writeEnvMeta(buf: *[ENV_META_SIZE]u8) void {
    var w = XdrWriter.init(buf);
    w.writeU32(SC_ENV_META_KIND_INTERFACE_VERSION);
    w.writeU32(PROTOCOL_VERSION);
    w.writeU32(PRE_RELEASE_VERSION);
}

// =====================================================================
// exportContract - the main entry point
// =====================================================================

/// Takes a contract struct type at comptime, introspects its public
/// function declarations, and returns a struct type that:
///   - Exports wasm functions for each public fn in ContractType
///   - Embeds XDR contract spec in "contractspecv0" custom section
///   - Embeds env metadata in "contractenvmetav0" custom section
pub fn exportContract(comptime ContractType: type) type {
    const decls = comptime getContractFunctions(ContractType);

    return struct {
        // -- Contract spec (contractspecv0) --
        const _spec_data = blk: {
            var buf: [totalSpecSize(decls)]u8 = undefined;
            writeAllSpecs(&buf, decls);
            break :blk buf;
        };

        comptime {
            @export(&_spec_data, .{
                .name = "_contract_spec",
                .section = "contractspecv0",
            });
        }

        // -- Environment metadata (contractenvmetav0) --
        const _env_meta_data = blk: {
            var buf: [ENV_META_SIZE]u8 = undefined;
            writeEnvMeta(&buf);
            break :blk buf;
        };

        comptime {
            @export(&_env_meta_data, .{
                .name = "_contract_env_meta",
                .section = "contractenvmetav0",
            });
        }

        // -- Wasm export wrappers --
        comptime {
            for (decls) |d| {
                exportFunction(ContractType, d.name);
            }
        }
    };
}

const FnDecl = struct {
    name: []const u8,
    fn_type: type,
    param_names: []const []const u8,
};

fn getContractFunctions(comptime ContractType: type) []const FnDecl {
    const info = @typeInfo(ContractType);
    const decls = switch (info) {
        .@"struct" => |s| s.decls,
        else => @compileError("exportContract requires a struct type"),
    };

    var result: []const FnDecl = &.{};
    for (decls) |d| {
        const field = @field(ContractType, d.name);
        const T = @TypeOf(field);
        if (@typeInfo(T) == .@"fn") {
            result = result ++ &[_]FnDecl{.{
                .name = d.name,
                .fn_type = T,
                .param_names = getParamNames(ContractType, d.name, T),
            }};
        }
    }
    return result;
}

/// Check if `decl_name` equals `fn_name` + "_params".
fn isParamsDecl(comptime decl_name: []const u8, comptime fn_name: []const u8) bool {
    const suffix = "_params";
    if (decl_name.len != fn_name.len + suffix.len) return false;
    return std.mem.eql(u8, decl_name[0..fn_name.len], fn_name) and
        std.mem.eql(u8, decl_name[fn_name.len..], suffix);
}

/// Look for a `<fn_name>_params` declaration in ContractType and return its
/// name, or null if none exists.
fn findParamsDecl(comptime ContractType: type, comptime fn_name: []const u8) ?[:0]const u8 {
    const struct_decls = @typeInfo(ContractType).@"struct".decls;
    inline for (struct_decls) |d| {
        if (comptime isParamsDecl(d.name, fn_name)) {
            return d.name;
        }
    }
    return null;
}

/// Resolve parameter names for a contract function.
///
/// If the contract struct declares a companion `<fn_name>_params` array, those
/// names are used in the XDR spec (and therefore visible in the Stellar CLI).
/// Otherwise, positional names "0", "1", … are generated as a fallback.
///
/// Example:
///   pub const mint_params = [_][]const u8{ "to", "amount" };
///   pub fn mint(to: sdk.AddressObject, amount: sdk.I128Val) sdk.Void { … }
fn getParamNames(comptime ContractType: type, comptime fn_name: []const u8, comptime FnType: type) []const []const u8 {
    const fn_info = @typeInfo(FnType).@"fn";
    const param_count = fn_info.params.len;

    if (comptime findParamsDecl(ContractType, fn_name)) |params_decl_name| {
        const user = @field(ContractType, params_decl_name);
        if (user.len != param_count) {
            @compileError("_params declaration must have the same number of elements as function parameters");
        }
        var names: [param_count][]const u8 = undefined;
        inline for (0..param_count) |i| {
            names[i] = user[i];
        }
        const result = names;
        return &result;
    }

    // Default to positional names ("0", "1", …)
    var defaults: [param_count][]const u8 = undefined;
    inline for (0..param_count) |i| {
        defaults[i] = &[1]u8{'0' + @as(u8, @intCast(i))};
    }
    const result = defaults;
    return &result;
}

fn totalSpecSize(comptime decls: []const FnDecl) usize {
    var size: usize = 0;
    for (decls) |d| {
        size += functionSpecSize(d.name, d.fn_type, d.param_names);
    }
    return size;
}

fn writeAllSpecs(buf: []u8, comptime decls: []const FnDecl) void {
    var w = XdrWriter.init(buf);
    for (decls) |d| {
        writeFunctionSpec(&w, d.name, d.fn_type, d.param_names);
    }
}

// Convert a u64 (wasm ABI) to the target Val-derived type.
// All Val types are `extern struct { payload: u64 }`, so we
// can construct them directly.
fn fromU64(comptime T: type, v: u64) T {
    return .{ .payload = v };
}

// Convert a Val-derived result type back to u64 for wasm ABI.
fn resultToU64(comptime T: type, result: T) u64 {
    if (T == Val) return result.toU64();
    if (@hasDecl(T, "toVal")) return result.toVal().toU64();
    if (T == u64) return result;
    return result.payload;
}

fn exportFunction(comptime ContractType: type, comptime name: []const u8) void {
    const func = @field(ContractType, name);
    const FnType = @TypeOf(func);
    const fn_info = @typeInfo(FnType).@"fn";
    const params = fn_info.params;
    const ReturnType = fn_info.return_type orelse val.Void;

    // Generate the appropriate export based on parameter count.
    // Zig comptime can't generate functions with dynamic signatures,
    // so we handle common arities explicitly.
    switch (params.len) {
        0 => {
            const f = struct {
                fn exported() callconv(.c) u64 {
                    const result = func();
                    return resultToU64(ReturnType, result);
                }
            };
            @export(&f.exported, .{ .name = name, .linkage = .strong });
        },
        1 => {
            const f = struct {
                fn exported(a0: u64) callconv(.c) u64 {
                    const P0 = params[0].type orelse Val;
                    const result = func(fromU64(P0, a0));
                    return resultToU64(ReturnType, result);
                }
            };
            @export(&f.exported, .{ .name = name, .linkage = .strong });
        },
        2 => {
            const f = struct {
                fn exported(a0: u64, a1: u64) callconv(.c) u64 {
                    const P0 = params[0].type orelse Val;
                    const P1 = params[1].type orelse Val;
                    const result = func(fromU64(P0, a0), fromU64(P1, a1));
                    return resultToU64(ReturnType, result);
                }
            };
            @export(&f.exported, .{ .name = name, .linkage = .strong });
        },
        3 => {
            const f = struct {
                fn exported(a0: u64, a1: u64, a2: u64) callconv(.c) u64 {
                    const P0 = params[0].type orelse Val;
                    const P1 = params[1].type orelse Val;
                    const P2 = params[2].type orelse Val;
                    const result = func(fromU64(P0, a0), fromU64(P1, a1), fromU64(P2, a2));
                    return resultToU64(ReturnType, result);
                }
            };
            @export(&f.exported, .{ .name = name, .linkage = .strong });
        },
        4 => {
            const f = struct {
                fn exported(a0: u64, a1: u64, a2: u64, a3: u64) callconv(.c) u64 {
                    const P0 = params[0].type orelse Val;
                    const P1 = params[1].type orelse Val;
                    const P2 = params[2].type orelse Val;
                    const P3 = params[3].type orelse Val;
                    const result = func(fromU64(P0, a0), fromU64(P1, a1), fromU64(P2, a2), fromU64(P3, a3));
                    return resultToU64(ReturnType, result);
                }
            };
            @export(&f.exported, .{ .name = name, .linkage = .strong });
        },
        5 => {
            const f = struct {
                fn exported(a0: u64, a1: u64, a2: u64, a3: u64, a4: u64) callconv(.c) u64 {
                    const P0 = params[0].type orelse Val;
                    const P1 = params[1].type orelse Val;
                    const P2 = params[2].type orelse Val;
                    const P3 = params[3].type orelse Val;
                    const P4 = params[4].type orelse Val;
                    const result = func(fromU64(P0, a0), fromU64(P1, a1), fromU64(P2, a2), fromU64(P3, a3), fromU64(P4, a4));
                    return resultToU64(ReturnType, result);
                }
            };
            @export(&f.exported, .{ .name = name, .linkage = .strong });
        },
        else => @compileError("contract functions with more than 5 parameters are not yet supported"),
    }
}

const std = @import("std");

// =====================================================================
// Tests
// =====================================================================

const testing = std.testing;

test "specTypeForValType maps known types" {
    try testing.expectEqual(SC_SPEC_TYPE_U32, specTypeForValType(val.U32Val).?);
    try testing.expectEqual(SC_SPEC_TYPE_I32, specTypeForValType(val.I32Val).?);
    try testing.expectEqual(SC_SPEC_TYPE_BOOL, specTypeForValType(val.Bool).?);
    try testing.expectEqual(SC_SPEC_TYPE_VOID, specTypeForValType(val.Void).?);
    try testing.expectEqual(SC_SPEC_TYPE_SYMBOL, specTypeForValType(val.Symbol).?);
    try testing.expectEqual(SC_SPEC_TYPE_ADDRESS, specTypeForValType(val.AddressObject).?);
    try testing.expectEqual(SC_SPEC_TYPE_BYTES, specTypeForValType(val.BytesObject).?);
    try testing.expectEqual(SC_SPEC_TYPE_STRING, specTypeForValType(val.StringObject).?);
    try testing.expectEqual(SC_SPEC_TYPE_U64, specTypeForValType(val.U64Val).?);
    try testing.expectEqual(SC_SPEC_TYPE_I64, specTypeForValType(val.I64Val).?);
    try testing.expectEqual(SC_SPEC_TYPE_U128, specTypeForValType(val.U128Val).?);
    try testing.expectEqual(SC_SPEC_TYPE_I128, specTypeForValType(val.I128Val).?);
    try testing.expectEqual(SC_SPEC_TYPE_U256, specTypeForValType(val.U256Val).?);
    try testing.expectEqual(SC_SPEC_TYPE_I256, specTypeForValType(val.I256Val).?);
    try testing.expectEqual(SC_SPEC_TYPE_TIMEPOINT, specTypeForValType(val.TimepointVal).?);
    try testing.expectEqual(SC_SPEC_TYPE_DURATION, specTypeForValType(val.DurationVal).?);
}

test "specTypeForValType returns null for unknown types" {
    try testing.expect(specTypeForValType(u32) == null);
    try testing.expect(specTypeForValType(bool) == null);
}

test "XdrWriter writeU32 big-endian" {
    var buf: [4]u8 = undefined;
    var w = XdrWriter.init(&buf);
    w.writeU32(0x01020304);
    try testing.expectEqualSlices(u8, &[_]u8{ 0x01, 0x02, 0x03, 0x04 }, &buf);
}

test "XdrWriter writeString with padding" {
    // "hi" = length 2: 4 bytes length + 2 bytes data + 2 bytes pad = 8 bytes
    var buf: [8]u8 = undefined;
    var w = XdrWriter.init(&buf);
    w.writeString("hi");
    try testing.expectEqualSlices(u8, &[_]u8{
        0, 0, 0, 2, // length = 2
        'h', 'i', 0, 0, // data + pad
    }, &buf);
}

test "XdrWriter writeString 4-byte aligned" {
    // "test" = length 4: 4 bytes length + 4 bytes data + 0 pad = 8 bytes
    var buf: [8]u8 = undefined;
    var w = XdrWriter.init(&buf);
    w.writeString("test");
    try testing.expectEqualSlices(u8, &[_]u8{
        0, 0, 0, 4, // length = 4
        't', 'e', 's', 't', // data, no padding needed
    }, &buf);
}

test "env meta encoding" {
    var buf: [ENV_META_SIZE]u8 = undefined;
    writeEnvMeta(&buf);
    // kind = 0 (INTERFACE_VERSION)
    try testing.expectEqual(@as(u8, 0), buf[3]);
    // protocol version
    try testing.expectEqual(PROTOCOL_VERSION, std.mem.readInt(u32, buf[4..8], .big));
    // pre-release version
    try testing.expectEqual(PRE_RELEASE_VERSION, std.mem.readInt(u32, buf[8..12], .big));
}

test "functionSpecSize basic" {
    // A function with no params returning Void
    const NoArgsFn = fn () val.Void;
    const size = comptime functionSpecSize("test_fn", NoArgsFn, &[_][]const u8{});
    // 4 (kind) + 4 (empty doc) + xdrStringSize("test_fn"=7) + 4 (inputs len) + 4 (outputs len=0)
    // xdrStringSize(7) = 4 + 7 + 1(pad) = 12
    try testing.expectEqual(@as(usize, 4 + 4 + 12 + 4 + 4), size);
}

test "functionSpecSize with params" {
    // A function with 2 params returning U32Val
    const TwoArgsFn = fn (val.Symbol, val.U32Val) val.U32Val;
    const param_names = [_][]const u8{ "0", "1" };
    const size = comptime functionSpecSize("add", TwoArgsFn, &param_names);
    // 4 (kind) + 4 (doc) + xdrStringSize("add"=3) + 4 (inputs len)
    // + 2 inputs: each 4(doc) + xdrStringSize("0"=1) + 4(type)
    // + 4 (outputs len) + 4 (output type)
    // xdrStringSize(3) = 4 + 3 + 1 = 8
    // xdrStringSize(1) = 4 + 1 + 3 = 8
    // = 4 + 4 + 8 + 4 + 2*(4 + 8 + 4) + 4 + 4 = 60
    try testing.expectEqual(@as(usize, 60), size);
}

test "getContractFunctions finds pub fns" {
    const TestContract = struct {
        pub fn hello(_: val.Symbol) val.VecObject {
            return val.VecObject.fromVal(Val.fromU64(0));
        }
        pub fn goodbye() val.Void {
            return val.Void.VOID;
        }
    };
    const fns = comptime getContractFunctions(TestContract);
    try testing.expectEqual(@as(usize, 2), fns.len);
}

test "write function spec produces valid XDR" {
    const Fn = fn (val.U32Val) val.U32Val;
    const param_names = [_][]const u8{"0"};
    const size = comptime functionSpecSize("inc", Fn, &param_names);
    var buf: [size]u8 = undefined;
    var w = XdrWriter.init(&buf);
    writeFunctionSpec(&w, "inc", Fn, &param_names);
    try testing.expectEqual(size, w.pos);

    // Verify the kind discriminant
    try testing.expectEqual(SC_SPEC_ENTRY_FUNCTION_V0, std.mem.readInt(u32, buf[0..4], .big));
}

test "write function spec complete encoding" {
    // Test a function: fn(val.U32Val) val.U32Val named "inc"
    const Fn = fn (val.U32Val) val.U32Val;
    const param_names = [_][]const u8{"0"};
    const size = comptime functionSpecSize("inc", Fn, &param_names);
    var buf: [size]u8 = undefined;
    var w = XdrWriter.init(&buf);
    writeFunctionSpec(&w, "inc", Fn, &param_names);

    var pos: usize = 0;
    // kind = FUNCTION_V0 = 0
    try testing.expectEqual(@as(u32, 0), std.mem.readInt(u32, buf[pos..][0..4], .big));
    pos += 4;
    // doc = empty string (len=0)
    try testing.expectEqual(@as(u32, 0), std.mem.readInt(u32, buf[pos..][0..4], .big));
    pos += 4;
    // name = "inc" (len=3)
    try testing.expectEqual(@as(u32, 3), std.mem.readInt(u32, buf[pos..][0..4], .big));
    pos += 4;
    try testing.expectEqualSlices(u8, "inc", buf[pos..][0..3]);
    pos += 4; // 3 bytes + 1 pad
    // inputs array length = 1
    try testing.expectEqual(@as(u32, 1), std.mem.readInt(u32, buf[pos..][0..4], .big));
    pos += 4;
    // input[0] doc = empty
    try testing.expectEqual(@as(u32, 0), std.mem.readInt(u32, buf[pos..][0..4], .big));
    pos += 4;
    // input[0] name = "0"
    try testing.expectEqual(@as(u32, 1), std.mem.readInt(u32, buf[pos..][0..4], .big));
    pos += 4;
    try testing.expectEqual(@as(u8, '0'), buf[pos]);
    pos += 4; // 1 byte + 3 pad
    // input[0] type = SC_SPEC_TYPE_U32 = 4
    try testing.expectEqual(@as(u32, 4), std.mem.readInt(u32, buf[pos..][0..4], .big));
    pos += 4;
    // outputs array length = 1
    try testing.expectEqual(@as(u32, 1), std.mem.readInt(u32, buf[pos..][0..4], .big));
    pos += 4;
    // output type = SC_SPEC_TYPE_U32 = 4
    try testing.expectEqual(@as(u32, 4), std.mem.readInt(u32, buf[pos..][0..4], .big));
    pos += 4;

    try testing.expectEqual(size, pos);
}

test "specTypeForValType maps object types" {
    try testing.expectEqual(SC_SPEC_TYPE_U64, specTypeForValType(val.U64Object).?);
    try testing.expectEqual(SC_SPEC_TYPE_I64, specTypeForValType(val.I64Object).?);
    try testing.expectEqual(SC_SPEC_TYPE_TIMEPOINT, specTypeForValType(val.TimepointObject).?);
    try testing.expectEqual(SC_SPEC_TYPE_DURATION, specTypeForValType(val.DurationObject).?);
    try testing.expectEqual(SC_SPEC_TYPE_U128, specTypeForValType(val.U128Object).?);
    try testing.expectEqual(SC_SPEC_TYPE_I128, specTypeForValType(val.I128Object).?);
    try testing.expectEqual(SC_SPEC_TYPE_U256, specTypeForValType(val.U256Object).?);
    try testing.expectEqual(SC_SPEC_TYPE_I256, specTypeForValType(val.I256Object).?);
    try testing.expectEqual(SC_SPEC_TYPE_SYMBOL, specTypeForValType(val.SymbolObject).?);
    try testing.expectEqual(SC_SPEC_TYPE_ADDRESS, specTypeForValType(val.MuxedAddressObject).?);
    try testing.expectEqual(SC_SPEC_TYPE_VAL, specTypeForValType(val.VecObject).?);
    try testing.expectEqual(SC_SPEC_TYPE_VAL, specTypeForValType(val.MapObject).?);
}

test "specTypeForValType maps Val to SC_SPEC_TYPE_VAL" {
    try testing.expectEqual(SC_SPEC_TYPE_VAL, specTypeForValType(val.Val).?);
}

test "specTypeForValType maps Error to SC_SPEC_TYPE_ERROR" {
    try testing.expectEqual(SC_SPEC_TYPE_ERROR, specTypeForValType(val.Error).?);
}

test "xdrStringSize empty string" {
    try testing.expectEqual(@as(usize, 4), xdrStringSize(0));
}

test "xdrStringSize 1 byte" {
    try testing.expectEqual(@as(usize, 8), xdrStringSize(1));
}

test "xdrStringSize 2 bytes" {
    try testing.expectEqual(@as(usize, 8), xdrStringSize(2));
}

test "xdrStringSize 3 bytes" {
    try testing.expectEqual(@as(usize, 8), xdrStringSize(3));
}

test "xdrStringSize 4 bytes aligned" {
    try testing.expectEqual(@as(usize, 8), xdrStringSize(4));
}

test "xdrStringSize 5 bytes" {
    try testing.expectEqual(@as(usize, 12), xdrStringSize(5));
}

test "XdrWriter writeI32 negative" {
    var buf: [4]u8 = undefined;
    var w = XdrWriter.init(&buf);
    w.writeI32(-1);
    try testing.expectEqualSlices(u8, &[_]u8{ 0xFF, 0xFF, 0xFF, 0xFF }, &buf);
}

test "XdrWriter writeI32 zero" {
    var buf: [4]u8 = undefined;
    var w = XdrWriter.init(&buf);
    w.writeI32(0);
    try testing.expectEqualSlices(u8, &[_]u8{ 0, 0, 0, 0 }, &buf);
}

test "XdrWriter writeU32 zero" {
    var buf: [4]u8 = undefined;
    var w = XdrWriter.init(&buf);
    w.writeU32(0);
    try testing.expectEqualSlices(u8, &[_]u8{ 0, 0, 0, 0 }, &buf);
}

test "XdrWriter writeU32 max" {
    var buf: [4]u8 = undefined;
    var w = XdrWriter.init(&buf);
    w.writeU32(0xFFFFFFFF);
    try testing.expectEqualSlices(u8, &[_]u8{ 0xFF, 0xFF, 0xFF, 0xFF }, &buf);
}

test "XdrWriter writeString empty" {
    var buf: [4]u8 = undefined;
    var w = XdrWriter.init(&buf);
    w.writeString("");
    try testing.expectEqualSlices(u8, &[_]u8{ 0, 0, 0, 0 }, &buf);
}

test "XdrWriter writeString 3-byte pad" {
    var buf: [8]u8 = undefined;
    var w = XdrWriter.init(&buf);
    w.writeString("a");
    try testing.expectEqualSlices(u8, &[_]u8{
        0, 0, 0, 1,
        'a', 0, 0, 0,
    }, &buf);
}

test "XdrWriter writeString 1-byte pad" {
    var buf: [8]u8 = undefined;
    var w = XdrWriter.init(&buf);
    w.writeString("abc");
    try testing.expectEqualSlices(u8, &[_]u8{
        0, 0, 0, 3,
        'a', 'b', 'c', 0,
    }, &buf);
}

test "XdrWriter sequential writes" {
    var buf: [8]u8 = undefined;
    var w = XdrWriter.init(&buf);
    w.writeU32(0xAABBCCDD);
    w.writeU32(0x11223344);
    try testing.expectEqualSlices(u8, &[_]u8{
        0xAA, 0xBB, 0xCC, 0xDD,
        0x11, 0x22, 0x33, 0x44,
    }, &buf);
    try testing.expectEqual(@as(usize, 8), w.pos);
}

test "env meta size is 12 bytes" {
    try testing.expectEqual(@as(usize, 12), ENV_META_SIZE);
}

test "env meta kind is INTERFACE_VERSION" {
    var buf: [ENV_META_SIZE]u8 = undefined;
    writeEnvMeta(&buf);
    try testing.expectEqual(@as(u32, 0), std.mem.readInt(u32, buf[0..4], .big));
}

test "functionSpecSize no-arg void return" {
    const Fn = fn () val.Void;
    const size = comptime functionSpecSize("f", Fn, &[_][]const u8{});
    // 4 (kind) + 4 (doc) + xdrStringSize(1) + 4 (inputs len) + 4 (outputs len, void=0)
    try testing.expectEqual(@as(usize, 4 + 4 + 8 + 4 + 4), size);
}

test "functionSpecSize with non-void return" {
    const Fn = fn () val.U32Val;
    const size = comptime functionSpecSize("g", Fn, &[_][]const u8{});
    // 4 (kind) + 4 (doc) + xdrStringSize(1) + 4 (inputs) + 4 (outputs len) + 4 (output type)
    try testing.expectEqual(@as(usize, 4 + 4 + 8 + 4 + 4 + 4), size);
}

test "totalSpecSize with empty decls" {
    const decls: []const FnDecl = &.{};
    try testing.expectEqual(@as(usize, 0), comptime totalSpecSize(decls));
}

test "getContractFunctions empty struct" {
    const EmptyContract = struct {};
    const fns = comptime getContractFunctions(EmptyContract);
    try testing.expectEqual(@as(usize, 0), fns.len);
}

test "getContractFunctions single function" {
    const OneFunc = struct {
        pub fn do_something() val.Void {
            return val.Void.VOID;
        }
    };
    const fns = comptime getContractFunctions(OneFunc);
    try testing.expectEqual(@as(usize, 1), fns.len);
}

test "fromU64 creates correct Val" {
    const v = fromU64(Val, 0xCAFE);
    try testing.expectEqual(@as(u64, 0xCAFE), v.payload);
}

test "fromU64 creates correct typed val" {
    const v = fromU64(val.U32Val, 0x1234);
    try testing.expectEqual(@as(u64, 0x1234), v.payload);
}

test "resultToU64 extracts payload" {
    const v = Val{ .payload = 0xBEEF };
    try testing.expectEqual(@as(u64, 0xBEEF), resultToU64(Val, v));
}

test "resultToU64 with typed val" {
    const v = val.U32Val.fromU32(42);
    try testing.expectEqual(v.payload, resultToU64(val.U32Val, v));
}

test "resultToU64 with Void type" {
    const v = val.Void.VOID;
    try testing.expectEqual(v.payload, resultToU64(val.Void, v));
}

test "SC_SPEC_TYPE constants match XDR spec" {
    try testing.expectEqual(@as(u32, 0), SC_SPEC_TYPE_VAL);
    try testing.expectEqual(@as(u32, 1), SC_SPEC_TYPE_BOOL);
    try testing.expectEqual(@as(u32, 2), SC_SPEC_TYPE_VOID);
    try testing.expectEqual(@as(u32, 3), SC_SPEC_TYPE_ERROR);
    try testing.expectEqual(@as(u32, 4), SC_SPEC_TYPE_U32);
    try testing.expectEqual(@as(u32, 5), SC_SPEC_TYPE_I32);
    try testing.expectEqual(@as(u32, 6), SC_SPEC_TYPE_U64);
    try testing.expectEqual(@as(u32, 7), SC_SPEC_TYPE_I64);
    try testing.expectEqual(@as(u32, 8), SC_SPEC_TYPE_TIMEPOINT);
    try testing.expectEqual(@as(u32, 9), SC_SPEC_TYPE_DURATION);
    try testing.expectEqual(@as(u32, 10), SC_SPEC_TYPE_U128);
    try testing.expectEqual(@as(u32, 11), SC_SPEC_TYPE_I128);
    try testing.expectEqual(@as(u32, 12), SC_SPEC_TYPE_U256);
    try testing.expectEqual(@as(u32, 13), SC_SPEC_TYPE_I256);
    try testing.expectEqual(@as(u32, 14), SC_SPEC_TYPE_BYTES);
    try testing.expectEqual(@as(u32, 16), SC_SPEC_TYPE_STRING);
    try testing.expectEqual(@as(u32, 17), SC_SPEC_TYPE_SYMBOL);
    try testing.expectEqual(@as(u32, 19), SC_SPEC_TYPE_ADDRESS);
}

test "write function spec no params void return" {
    const Fn = fn () val.Void;
    const size = comptime functionSpecSize("noop", Fn, &[_][]const u8{});
    var buf: [size]u8 = undefined;
    var w = XdrWriter.init(&buf);
    writeFunctionSpec(&w, "noop", Fn, &[_][]const u8{});
    try testing.expectEqual(size, w.pos);
    try testing.expectEqual(SC_SPEC_ENTRY_FUNCTION_V0, std.mem.readInt(u32, buf[0..4], .big));
}

test "write function spec consumes exact buffer" {
    const Fn = fn (val.Symbol, val.U32Val) val.Bool;
    const param_names = [_][]const u8{ "0", "1" };
    const size = comptime functionSpecSize("check", Fn, &param_names);
    var buf: [size]u8 = undefined;
    var w = XdrWriter.init(&buf);
    writeFunctionSpec(&w, "check", Fn, &param_names);
    try testing.expectEqual(size, w.pos);
}

test "functionSpecSize all params included" {
    // Verify that Val as first param is NOT skipped - it's a real parameter
    const Fn = fn (val.Val, val.Symbol) val.U32Val;
    const param_names = [_][]const u8{ "0", "1" };
    const size = comptime functionSpecSize("f", Fn, &param_names);
    // 4 (kind) + 4 (doc) + xdrStringSize("f"=1) + 4 (inputs len)
    // + 2 inputs: each 4(doc) + xdrStringSize(1) + 4(type)
    // + 4 (outputs len) + 4 (output type)
    // = 4 + 4 + 8 + 4 + 2*(4 + 8 + 4) + 4 + 4 = 60
    try testing.expectEqual(@as(usize, 60), size);
}

test "functionSpecSize with named params" {
    const Fn = fn (val.AddressObject, val.I128Val) val.Void;
    const param_names = [_][]const u8{ "to", "amount" };
    const size = comptime functionSpecSize("mint", Fn, &param_names);
    // 4 (kind) + 4 (doc) + xdrStringSize("mint"=4) + 4 (inputs len)
    // + input "to": 4(doc) + xdrStringSize(2) + 4(type) = 4 + 8 + 4 = 16
    // + input "amount": 4(doc) + xdrStringSize(6) + 4(type) = 4 + 12 + 4 = 20
    // + 4 (outputs len, void=0)
    // xdrStringSize(4) = 4 + 4 = 8
    // = 4 + 4 + 8 + 4 + 16 + 20 + 4 = 60
    try testing.expectEqual(@as(usize, 60), size);
}

test "getContractFunctions picks up _params decl" {
    const TestContract = struct {
        pub const greet_params = [_][]const u8{ "name", "count" };
        pub fn greet(_: val.StringObject, _: val.U32Val) val.Void {
            return val.Void.VOID;
        }
    };
    const fns = comptime getContractFunctions(TestContract);
    try testing.expectEqual(@as(usize, 1), fns.len);
    try testing.expectEqualStrings("name", fns[0].param_names[0]);
    try testing.expectEqualStrings("count", fns[0].param_names[1]);
}

test "getContractFunctions defaults to positional names" {
    const TestContract = struct {
        pub fn add(_: val.U32Val, _: val.U32Val) val.U32Val {
            return val.U32Val.fromU32(0);
        }
    };
    const fns = comptime getContractFunctions(TestContract);
    try testing.expectEqual(@as(usize, 1), fns.len);
    try testing.expectEqualStrings("0", fns[0].param_names[0]);
    try testing.expectEqualStrings("1", fns[0].param_names[1]);
}
