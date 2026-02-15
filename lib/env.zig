// Soroban host function imports.
// Auto-generated from env.json - do not edit manually.
//
// Each module maps to a Wasm import module. Functions are imported
// using @extern with the module's export name as library_name and
// the function's export name as the symbol name.

const val = @import("val.zig");

// =============================================================================
// Module: context (wasm import module: "x")
// =============================================================================

pub const context = struct {
    ///    Emit a diagnostic event containing a message and sequence of `Val`s.
    pub const log_from_linear_memory = @extern(*const fn (val.U32Val, val.U32Val, val.U32Val, val.U32Val) callconv(.c) val.Void, .{ .name = "_", .library_name = "x" });

    ///    Compare two objects, or at least one object to a non-object, structurally. Returns -1 if
    ///    a<b, 1 if a>b, or 0 if a==b.
    pub const obj_cmp = @extern(*const fn (val.Val, val.Val) callconv(.c) i64, .{ .name = "0", .library_name = "x" });

    ///    Records a contract event. `topics` is expected to be a `SCVec` with length <= 4 that cannot
    ///    contain `Vec`, `Map`, or `Bytes` with length > 32.
    pub const contract_event = @extern(*const fn (val.VecObject, val.Val) callconv(.c) val.Void, .{ .name = "1", .library_name = "x" });

    ///    Return the protocol version of the current ledger as a u32.
    pub const get_ledger_version = @extern(*const fn () callconv(.c) val.U32Val, .{ .name = "2", .library_name = "x" });

    ///    Return the sequence number of the current ledger as a u32.
    pub const get_ledger_sequence = @extern(*const fn () callconv(.c) val.U32Val, .{ .name = "3", .library_name = "x" });

    ///    Return the timestamp number of the current ledger as a u64.
    pub const get_ledger_timestamp = @extern(*const fn () callconv(.c) val.U64Val, .{ .name = "4", .library_name = "x" });

    ///    Causes the currently executing contract to fail immediately with a provided error code,
    ///    which must be of error-type `ScErrorType::Contract`. Does not actually return.
    pub const fail_with_error = @extern(*const fn (val.Error) callconv(.c) val.Void, .{ .name = "5", .library_name = "x" });

    ///    Return the network id (sha256 hash of network passphrase) of the current ledger as `Bytes`.
    ///    The value is always 32 bytes in length.
    pub const get_ledger_network_id = @extern(*const fn () callconv(.c) val.BytesObject, .{ .name = "6", .library_name = "x" });

    ///    Get the Address object for the current contract.
    pub const get_current_contract_address = @extern(*const fn () callconv(.c) val.AddressObject, .{ .name = "7", .library_name = "x" });

    ///    Returns the max ledger sequence that an entry can live to (inclusive).
    pub const get_max_live_until_ledger = @extern(*const fn () callconv(.c) val.U32Val, .{ .name = "8", .library_name = "x" });

};

// =============================================================================
// Module: int (wasm import module: "i")
// =============================================================================

pub const int = struct {
    ///    Convert a `u64` to an object containing a `u64`.
    pub const obj_from_u64 = @extern(*const fn (u64) callconv(.c) val.U64Object, .{ .name = "_", .library_name = "i" });

    ///    Convert an object containing a `u64` to a `u64`.
    pub const obj_to_u64 = @extern(*const fn (val.U64Object) callconv(.c) u64, .{ .name = "0", .library_name = "i" });

    ///    Convert an `i64` to an object containing an `i64`.
    pub const obj_from_i64 = @extern(*const fn (i64) callconv(.c) val.I64Object, .{ .name = "1", .library_name = "i" });

    ///    Convert an object containing an `i64` to an `i64`.
    pub const obj_to_i64 = @extern(*const fn (val.I64Object) callconv(.c) i64, .{ .name = "2", .library_name = "i" });

    ///    Convert the high and low 64-bit words of a u128 to an object containing a u128.
    pub const obj_from_u128_pieces = @extern(*const fn (u64, u64) callconv(.c) val.U128Object, .{ .name = "3", .library_name = "i" });

    ///    Extract the low 64 bits from an object containing a u128.
    pub const obj_to_u128_lo64 = @extern(*const fn (val.U128Object) callconv(.c) u64, .{ .name = "4", .library_name = "i" });

    ///    Extract the high 64 bits from an object containing a u128.
    pub const obj_to_u128_hi64 = @extern(*const fn (val.U128Object) callconv(.c) u64, .{ .name = "5", .library_name = "i" });

    ///    Convert the high and low 64-bit words of an i128 to an object containing an i128.
    pub const obj_from_i128_pieces = @extern(*const fn (i64, u64) callconv(.c) val.I128Object, .{ .name = "6", .library_name = "i" });

    ///    Extract the low 64 bits from an object containing an i128.
    pub const obj_to_i128_lo64 = @extern(*const fn (val.I128Object) callconv(.c) u64, .{ .name = "7", .library_name = "i" });

    ///    Extract the high 64 bits from an object containing an i128.
    pub const obj_to_i128_hi64 = @extern(*const fn (val.I128Object) callconv(.c) i64, .{ .name = "8", .library_name = "i" });

    ///    Convert the four 64-bit words of a u256 (big-endian) to an object containing a u256.
    pub const obj_from_u256_pieces = @extern(*const fn (u64, u64, u64, u64) callconv(.c) val.U256Object, .{ .name = "9", .library_name = "i" });

    ///    Create a U256 `Val` from its representation as a byte array in big endian.
    pub const u256_val_from_be_bytes = @extern(*const fn (val.BytesObject) callconv(.c) val.U256Val, .{ .name = "a", .library_name = "i" });

    ///    Return the memory representation of this U256 `Val` as a byte array in big endian byte
    ///    order.
    pub const u256_val_to_be_bytes = @extern(*const fn (val.U256Val) callconv(.c) val.BytesObject, .{ .name = "b", .library_name = "i" });

    ///    Extract the highest 64-bits (bits 192-255) from an object containing a u256.
    pub const obj_to_u256_hi_hi = @extern(*const fn (val.U256Object) callconv(.c) u64, .{ .name = "c", .library_name = "i" });

    ///    Extract bits 128-191 from an object containing a u256.
    pub const obj_to_u256_hi_lo = @extern(*const fn (val.U256Object) callconv(.c) u64, .{ .name = "d", .library_name = "i" });

    ///    Extract bits 64-127 from an object containing a u256.
    pub const obj_to_u256_lo_hi = @extern(*const fn (val.U256Object) callconv(.c) u64, .{ .name = "e", .library_name = "i" });

    ///    Extract the lowest 64-bits (bits 0-63) from an object containing a u256.
    pub const obj_to_u256_lo_lo = @extern(*const fn (val.U256Object) callconv(.c) u64, .{ .name = "f", .library_name = "i" });

    ///    Convert the four 64-bit words of an i256 (big-endian) to an object containing an i256.
    pub const obj_from_i256_pieces = @extern(*const fn (i64, u64, u64, u64) callconv(.c) val.I256Object, .{ .name = "g", .library_name = "i" });

    ///    Create a I256 `Val` from its representation as a byte array in big endian.
    pub const i256_val_from_be_bytes = @extern(*const fn (val.BytesObject) callconv(.c) val.I256Val, .{ .name = "h", .library_name = "i" });

    ///    Return the memory representation of this I256 `Val` as a byte array in big endian byte
    ///    order.
    pub const i256_val_to_be_bytes = @extern(*const fn (val.I256Val) callconv(.c) val.BytesObject, .{ .name = "i", .library_name = "i" });

    ///    Extract the highest 64-bits (bits 192-255) from an object containing an i256.
    pub const obj_to_i256_hi_hi = @extern(*const fn (val.I256Object) callconv(.c) i64, .{ .name = "j", .library_name = "i" });

    ///    Extract bits 128-191 from an object containing an i256.
    pub const obj_to_i256_hi_lo = @extern(*const fn (val.I256Object) callconv(.c) u64, .{ .name = "k", .library_name = "i" });

    ///    Extract bits 64-127 from an object containing an i256.
    pub const obj_to_i256_lo_hi = @extern(*const fn (val.I256Object) callconv(.c) u64, .{ .name = "l", .library_name = "i" });

    ///    Extract the lowest 64-bits (bits 0-63) from an object containing an i256.
    pub const obj_to_i256_lo_lo = @extern(*const fn (val.I256Object) callconv(.c) u64, .{ .name = "m", .library_name = "i" });

    ///    Performs checked integer addition. Computes `lhs + rhs`, returning `ScError` if overflow
    ///    occurred.
    pub const u256_add = @extern(*const fn (val.U256Val, val.U256Val) callconv(.c) val.U256Val, .{ .name = "n", .library_name = "i" });

    ///    Performs checked integer subtraction. Computes `lhs - rhs`, returning `ScError` if overflow
    ///    occurred.
    pub const u256_sub = @extern(*const fn (val.U256Val, val.U256Val) callconv(.c) val.U256Val, .{ .name = "o", .library_name = "i" });

    ///    Performs checked integer multiplication. Computes `lhs * rhs`, returning `ScError` if
    ///    overflow occurred.
    pub const u256_mul = @extern(*const fn (val.U256Val, val.U256Val) callconv(.c) val.U256Val, .{ .name = "p", .library_name = "i" });

    ///    Performs checked integer division. Computes `lhs / rhs`, returning `ScError` if `rhs == 0`
    ///    or overflow occurred.
    pub const u256_div = @extern(*const fn (val.U256Val, val.U256Val) callconv(.c) val.U256Val, .{ .name = "q", .library_name = "i" });

    ///    Performs checked Euclidean modulo. Computes `lhs % rhs`, returning `ScError` if `rhs == 0`
    ///    or overflow occurred.
    pub const u256_rem_euclid = @extern(*const fn (val.U256Val, val.U256Val) callconv(.c) val.U256Val, .{ .name = "r", .library_name = "i" });

    ///    Performs checked exponentiation. Computes `lhs.exp(rhs)`, returning `ScError` if overflow
    ///    occurred.
    pub const u256_pow = @extern(*const fn (val.U256Val, val.U32Val) callconv(.c) val.U256Val, .{ .name = "s", .library_name = "i" });

    ///    Performs checked shift left. Computes `lhs << rhs`, returning `ScError` if `rhs` is larger
    ///    than or equal to the number of bits in `lhs`.
    pub const u256_shl = @extern(*const fn (val.U256Val, val.U32Val) callconv(.c) val.U256Val, .{ .name = "t", .library_name = "i" });

    ///    Performs checked shift right. Computes `lhs >> rhs`, returning `ScError` if `rhs` is larger
    ///    than or equal to the number of bits in `lhs`.
    pub const u256_shr = @extern(*const fn (val.U256Val, val.U32Val) callconv(.c) val.U256Val, .{ .name = "u", .library_name = "i" });

    ///    Performs checked integer addition. Computes `lhs + rhs`, returning `ScError` if overflow
    ///    occurred.
    pub const i256_add = @extern(*const fn (val.I256Val, val.I256Val) callconv(.c) val.I256Val, .{ .name = "v", .library_name = "i" });

    ///    Performs checked integer subtraction. Computes `lhs - rhs`, returning `ScError` if overflow
    ///    occurred.
    pub const i256_sub = @extern(*const fn (val.I256Val, val.I256Val) callconv(.c) val.I256Val, .{ .name = "w", .library_name = "i" });

    ///    Performs checked integer multiplication. Computes `lhs * rhs`, returning `ScError` if
    ///    overflow occurred.
    pub const i256_mul = @extern(*const fn (val.I256Val, val.I256Val) callconv(.c) val.I256Val, .{ .name = "x", .library_name = "i" });

    ///    Performs checked integer division. Computes `lhs / rhs`, returning `ScError` if `rhs == 0`
    ///    or overflow occurred.
    pub const i256_div = @extern(*const fn (val.I256Val, val.I256Val) callconv(.c) val.I256Val, .{ .name = "y", .library_name = "i" });

    ///    Performs checked Euclidean modulo. Computes `lhs % rhs`, returning `ScError` if `rhs == 0`
    ///    or overflow occurred.
    pub const i256_rem_euclid = @extern(*const fn (val.I256Val, val.I256Val) callconv(.c) val.I256Val, .{ .name = "z", .library_name = "i" });

    ///    Performs checked exponentiation. Computes `lhs.exp(rhs)`, returning `ScError` if overflow
    ///    occurred.
    pub const i256_pow = @extern(*const fn (val.I256Val, val.U32Val) callconv(.c) val.I256Val, .{ .name = "A", .library_name = "i" });

    ///    Performs checked shift left. Computes `lhs << rhs`, returning `ScError` if `rhs` is larger
    ///    than or equal to the number of bits in `lhs`.
    pub const i256_shl = @extern(*const fn (val.I256Val, val.U32Val) callconv(.c) val.I256Val, .{ .name = "B", .library_name = "i" });

    ///    Performs checked shift right. Computes `lhs >> rhs`, returning `ScError` if `rhs` is larger
    ///    than or equal to the number of bits in `lhs`.
    pub const i256_shr = @extern(*const fn (val.I256Val, val.U32Val) callconv(.c) val.I256Val, .{ .name = "C", .library_name = "i" });

    ///    Convert a `u64` to a `Timepoint` object.
    pub const timepoint_obj_from_u64 = @extern(*const fn (u64) callconv(.c) val.TimepointObject, .{ .name = "D", .library_name = "i" });

    ///    Convert a `Timepoint` object to a `u64`.
    pub const timepoint_obj_to_u64 = @extern(*const fn (val.TimepointObject) callconv(.c) u64, .{ .name = "E", .library_name = "i" });

    ///    Convert a `u64` to a `Duration` object.
    pub const duration_obj_from_u64 = @extern(*const fn (u64) callconv(.c) val.DurationObject, .{ .name = "F", .library_name = "i" });

    ///    Convert a `Duration` object a `u64`.
    pub const duration_obj_to_u64 = @extern(*const fn (val.DurationObject) callconv(.c) u64, .{ .name = "G", .library_name = "i" });

};

// =============================================================================
// Module: map (wasm import module: "m")
// =============================================================================

pub const map = struct {
    ///    Create an empty new map.
    pub const map_new = @extern(*const fn () callconv(.c) val.MapObject, .{ .name = "_", .library_name = "m" });

    ///    Insert a key/value mapping into an existing map, and return the map object handle. If the
    ///    map already has a mapping for the given key, the previous value is overwritten.
    pub const map_put = @extern(*const fn (val.MapObject, val.Val, val.Val) callconv(.c) val.MapObject, .{ .name = "0", .library_name = "m" });

    ///    Get the value for a key from a map. Traps if key is not found.
    pub const map_get = @extern(*const fn (val.MapObject, val.Val) callconv(.c) val.Val, .{ .name = "1", .library_name = "m" });

    ///    Remove a key/value mapping from a map if it exists, traps if doesn't.
    pub const map_del = @extern(*const fn (val.MapObject, val.Val) callconv(.c) val.MapObject, .{ .name = "2", .library_name = "m" });

    ///    Get the size of a map.
    pub const map_len = @extern(*const fn (val.MapObject) callconv(.c) val.U32Val, .{ .name = "3", .library_name = "m" });

    ///    Test for the presence of a key in a map. Returns Bool.
    pub const map_has = @extern(*const fn (val.MapObject, val.Val) callconv(.c) val.Bool, .{ .name = "4", .library_name = "m" });

    ///    Get the key from a map at position `i`. If `i` is an invalid position, return ScError.
    pub const map_key_by_pos = @extern(*const fn (val.MapObject, val.U32Val) callconv(.c) val.Val, .{ .name = "5", .library_name = "m" });

    ///    Get the value from a map at position `i`. If `i` is an invalid position, return ScError.
    pub const map_val_by_pos = @extern(*const fn (val.MapObject, val.U32Val) callconv(.c) val.Val, .{ .name = "6", .library_name = "m" });

    ///    Return a new vector containing all the keys in a map. The new vector is ordered in the
    ///    original map's key-sorted order.
    pub const map_keys = @extern(*const fn (val.MapObject) callconv(.c) val.VecObject, .{ .name = "7", .library_name = "m" });

    ///    Return a new vector containing all the values in a map. The new vector is ordered in the
    ///    original map's key-sorted order.
    pub const map_values = @extern(*const fn (val.MapObject) callconv(.c) val.VecObject, .{ .name = "8", .library_name = "m" });

    ///    Return a new map initialized from a pair of equal-length arrays, one for keys and one for
    ///    values, given by a pair of linear-memory addresses and a length in Vals.
    pub const map_new_from_linear_memory = @extern(*const fn (val.U32Val, val.U32Val, val.U32Val) callconv(.c) val.MapObject, .{ .name = "9", .library_name = "m" });

    ///    Copy Vals from `map` to the array `vals_pos`, selecting only the keys identified by the
    ///    array `keys_pos`. Both arrays have `len` elements and are identified by linear-memory
    ///    addresses.
    pub const map_unpack_to_linear_memory = @extern(*const fn (val.MapObject, val.U32Val, val.U32Val, val.U32Val) callconv(.c) val.Void, .{ .name = "a", .library_name = "m" });

};

// =============================================================================
// Module: vec (wasm import module: "v")
// =============================================================================

pub const vec = struct {
    ///    Creates an empty new vector.
    pub const vec_new = @extern(*const fn () callconv(.c) val.VecObject, .{ .name = "_", .library_name = "v" });

    ///    Update the value at index `i` in the vector. Return the new vector. Trap if the index is
    ///    out of bounds.
    pub const vec_put = @extern(*const fn (val.VecObject, val.U32Val, val.Val) callconv(.c) val.VecObject, .{ .name = "0", .library_name = "v" });

    ///    Returns the element at index `i` of the vector. Traps if the index is out of bound.
    pub const vec_get = @extern(*const fn (val.VecObject, val.U32Val) callconv(.c) val.Val, .{ .name = "1", .library_name = "v" });

    ///    Delete an element in a vector at index `i`, shifting all elements after it to the left.
    ///    Return the new vector. Traps if the index is out of bound.
    pub const vec_del = @extern(*const fn (val.VecObject, val.U32Val) callconv(.c) val.VecObject, .{ .name = "2", .library_name = "v" });

    ///    Returns length of the vector.
    pub const vec_len = @extern(*const fn (val.VecObject) callconv(.c) val.U32Val, .{ .name = "3", .library_name = "v" });

    ///    Push a value to the front of a vector.
    pub const vec_push_front = @extern(*const fn (val.VecObject, val.Val) callconv(.c) val.VecObject, .{ .name = "4", .library_name = "v" });

    ///    Removes the first element from the vector and returns the new vector. Traps if original
    ///    vector is empty.
    pub const vec_pop_front = @extern(*const fn (val.VecObject) callconv(.c) val.VecObject, .{ .name = "5", .library_name = "v" });

    ///    Appends an element to the back of the vector.
    pub const vec_push_back = @extern(*const fn (val.VecObject, val.Val) callconv(.c) val.VecObject, .{ .name = "6", .library_name = "v" });

    ///    Removes the last element from the vector and returns the new vector. Traps if original
    ///    vector is empty.
    pub const vec_pop_back = @extern(*const fn (val.VecObject) callconv(.c) val.VecObject, .{ .name = "7", .library_name = "v" });

    ///    Return the first element in the vector. Traps if the vector is empty
    pub const vec_front = @extern(*const fn (val.VecObject) callconv(.c) val.Val, .{ .name = "8", .library_name = "v" });

    ///    Return the last element in the vector. Traps if the vector is empty
    pub const vec_back = @extern(*const fn (val.VecObject) callconv(.c) val.Val, .{ .name = "9", .library_name = "v" });

    ///    Inserts an element at index `i` within the vector, shifting all elements after it to the
    ///    right. Traps if the index is out of bound
    pub const vec_insert = @extern(*const fn (val.VecObject, val.U32Val, val.Val) callconv(.c) val.VecObject, .{ .name = "a", .library_name = "v" });

    ///    Clone the vector `v1`, then moves all the elements of vector `v2` into it. Return the new
    ///    vector. Traps if number of elements in the vector overflows a u32.
    pub const vec_append = @extern(*const fn (val.VecObject, val.VecObject) callconv(.c) val.VecObject, .{ .name = "b", .library_name = "v" });

    ///    Copy the elements from `start` index until `end` index, exclusive, in the vector and create
    ///    a new vector from it. Return the new vector. Traps if the index is out of bound.
    pub const vec_slice = @extern(*const fn (val.VecObject, val.U32Val, val.U32Val) callconv(.c) val.VecObject, .{ .name = "c", .library_name = "v" });

    ///    Get the index of the first occurrence of a given element in the vector. Returns the u32
    ///    index of the value if it's there. Otherwise, it returns `Void`.
    pub const vec_first_index_of = @extern(*const fn (val.VecObject, val.Val) callconv(.c) val.Val, .{ .name = "d", .library_name = "v" });

    ///    Get the index of the last occurrence of a given element in the vector. Returns the u32
    ///    index of the value if it's there. Otherwise, it returns `Void`.
    pub const vec_last_index_of = @extern(*const fn (val.VecObject, val.Val) callconv(.c) val.Val, .{ .name = "e", .library_name = "v" });

    ///    Binary search a sorted vector for a given element. If it exists, the high 32 bits of the
    ///    return value is 0x0000_0001 and the low 32 bits contain the u32 index of the element. If it
    ///    does not exist, the high 32 bits of the return value is 0x0000_0000 and the low-32 bits
    ///    contain the u32 index at which the element would need to be inserted into the vector to
    ///    maintain sorted order.
    pub const vec_binary_search = @extern(*const fn (val.VecObject, val.Val) callconv(.c) u64, .{ .name = "f", .library_name = "v" });

    ///    Return a new vec initialized from an input slice of Vals given by a linear-memory address
    ///    and length in Vals.
    pub const vec_new_from_linear_memory = @extern(*const fn (val.U32Val, val.U32Val) callconv(.c) val.VecObject, .{ .name = "g", .library_name = "v" });

    ///    Copy the Vals of a vec into an array at a given linear-memory address and length in Vals.
    pub const vec_unpack_to_linear_memory = @extern(*const fn (val.VecObject, val.U32Val, val.U32Val) callconv(.c) val.Void, .{ .name = "h", .library_name = "v" });

};

// =============================================================================
// Module: ledger (wasm import module: "l")
// =============================================================================

pub const ledger = struct {
    pub const put_contract_data = @extern(*const fn (val.Val, val.Val, val.StorageType) callconv(.c) val.Void, .{ .name = "_", .library_name = "l" });

    pub const has_contract_data = @extern(*const fn (val.Val, val.StorageType) callconv(.c) val.Bool, .{ .name = "0", .library_name = "l" });

    pub const get_contract_data = @extern(*const fn (val.Val, val.StorageType) callconv(.c) val.Val, .{ .name = "1", .library_name = "l" });

    pub const del_contract_data = @extern(*const fn (val.Val, val.StorageType) callconv(.c) val.Void, .{ .name = "2", .library_name = "l" });

    ///    Creates the contract instance on behalf of `deployer`. `deployer` must authorize this call
    ///    via Soroban auth framework, i.e. this calls `deployer.require_auth` with respective
    ///    arguments. `wasm_hash` must be a hash of the contract code that has already been uploaded
    ///    on this network. `salt` is used to create a unique contract id. Returns the address of the
    ///    created contract.
    pub const create_contract = @extern(*const fn (val.AddressObject, val.BytesObject, val.BytesObject) callconv(.c) val.AddressObject, .{ .name = "3", .library_name = "l" });

    ///    Creates the instance of Stellar Asset contract corresponding to the provided asset.
    ///    `serialized_asset` is `stellar::Asset` XDR serialized to bytes format. Returns the address
    ///    of the created contract.
    pub const create_asset_contract = @extern(*const fn (val.BytesObject) callconv(.c) val.AddressObject, .{ .name = "4", .library_name = "l" });

    ///    Uploads provided `wasm` bytecode to the network and returns its identifier (SHA-256 hash).
    ///    No-op in case if the same Wasm object already exists.
    pub const upload_wasm = @extern(*const fn (val.BytesObject) callconv(.c) val.BytesObject, .{ .name = "5", .library_name = "l" });

    ///    Replaces the executable of the current contract with the provided Wasm code identified by a
    ///    hash. Wasm entry corresponding to the hash has to already be present in the ledger. The
    ///    update happens only after the current contract invocation has successfully finished, so
    ///    this can be safely called in the middle of a function.
    pub const update_current_contract_wasm = @extern(*const fn (val.BytesObject) callconv(.c) val.Void, .{ .name = "6", .library_name = "l" });

    ///    If the entry's TTL is below `threshold` ledgers, extend `live_until_ledger_seq` such that
    ///    TTL == `extend_to`, where TTL is defined as live_until_ledger_seq - current ledger. If
    ///    attempting to extend the entry past the maximum allowed value (defined as the current
    ///    ledger + `max_entry_ttl` - 1), and the entry is `Persistent`, its new
    ///    `live_until_ledger_seq` will be clamped to the max; if the entry is `Temporary`, the
    ///    function traps.
    pub const extend_contract_data_ttl = @extern(*const fn (val.Val, val.StorageType, val.U32Val, val.U32Val) callconv(.c) val.Void, .{ .name = "7", .library_name = "l" });

    ///    If the TTL for the current contract instance and code (if applicable) is below `threshold`
    ///    ledgers, extend `live_until_ledger_seq` such that TTL == `extend_to`, where TTL is defined
    ///    as live_until_ledger_seq - current ledger. If attempting to extend past the maximum allowed
    ///    value (defined as the current ledger + `max_entry_ttl` - 1), the new
    ///    `live_until_ledger_seq` will be clamped to the max.
    pub const extend_current_contract_instance_and_code_ttl = @extern(*const fn (val.U32Val, val.U32Val) callconv(.c) val.Void, .{ .name = "8", .library_name = "l" });

    ///    If the TTL for the provided contract instance and code (if applicable) is below `threshold`
    ///    ledgers, extend `live_until_ledger_seq` such that TTL == `extend_to`, where TTL is defined
    ///    as live_until_ledger_seq - current ledger. If attempting to extend past the maximum allowed
    ///    value (defined as the current ledger + `max_entry_ttl` - 1), the new
    ///    `live_until_ledger_seq` will be clamped to the max.
    pub const extend_contract_instance_and_code_ttl = @extern(*const fn (val.AddressObject, val.U32Val, val.U32Val) callconv(.c) val.Void, .{ .name = "9", .library_name = "l" });

    ///    Get the id of a contract without creating it. `deployer` is address of the contract
    ///    deployer. `salt` is used to create a unique contract id. Returns the address of the
    ///    would-be contract.
    pub const get_contract_id = @extern(*const fn (val.AddressObject, val.BytesObject) callconv(.c) val.AddressObject, .{ .name = "a", .library_name = "l" });

    ///    Get the id of the Stellar Asset contract corresponding to the provided asset without
    ///    creating the instance. `serialized_asset` is `stellar::Asset` XDR serialized to bytes
    ///    format. Returns the address of the would-be asset contract.
    pub const get_asset_contract_id = @extern(*const fn (val.BytesObject) callconv(.c) val.AddressObject, .{ .name = "b", .library_name = "l" });

    ///    If the TTL for the provided contract instance is below `threshold` ledgers, extend
    ///    `live_until_ledger_seq` such that TTL == `extend_to`, where TTL is defined as
    ///    live_until_ledger_seq - current ledger. If attempting to extend past the maximum allowed
    ///    value (defined as the current ledger + `max_entry_ttl` - 1), the new
    ///    `live_until_ledger_seq` will be clamped to the max.
    /// Min protocol: 21
    pub const extend_contract_instance_ttl = @extern(*const fn (val.AddressObject, val.U32Val, val.U32Val) callconv(.c) val.Void, .{ .name = "c", .library_name = "l" });

    ///    If the TTL for the provided contract's code (if applicable) is below `threshold` ledgers,
    ///    extend `live_until_ledger_seq` such that TTL == `extend_to`, where TTL is defined as
    ///    live_until_ledger_seq - current ledger. If attempting to extend past the maximum allowed
    ///    value (defined as the current ledger + `max_entry_ttl` - 1), the new
    ///    `live_until_ledger_seq` will be clamped to the max.
    /// Min protocol: 21
    pub const extend_contract_code_ttl = @extern(*const fn (val.AddressObject, val.U32Val, val.U32Val) callconv(.c) val.Void, .{ .name = "d", .library_name = "l" });

    ///    Creates the contract instance on behalf of `deployer`. Created contract must be created
    ///    from a Wasm that has a constructor. `deployer` must authorize this call via Soroban auth
    ///    framework, i.e. this calls `deployer.require_auth` with respective arguments. `wasm_hash`
    ///    must be a hash of the contract code that has already been uploaded on this network. `salt`
    ///    is used to create a unique contract id. `constructor_args` are forwarded into created
    ///    contract's constructor (`__constructor`) function. Returns the address of the created
    ///    contract.
    /// Min protocol: 22
    pub const create_contract_with_constructor = @extern(*const fn (val.AddressObject, val.BytesObject, val.BytesObject, val.VecObject) callconv(.c) val.AddressObject, .{ .name = "e", .library_name = "l" });

    ///    Extend the contract data entry's TTL to be up to `extend_to` ledgers, where TTL is defined
    ///    as `entry_live_until_ledger_seq - current_ledger_seq`. The TTL extension only actually
    ///    happens if it is at least `min_extension`, otherwise this function is a no-op. The amount
    ///    of extension ledgers will not exceed `max_extension` ledgers. If attempting to extend the
    ///    entry past the maximum allowed value (defined as the current ledger + `max_entry_ttl` - 1),
    ///    and the entry is `Persistent`, its new `live_until_ledger_seq` will be clamped to the max;
    ///    if the entry is `Temporary`, the function traps.
    /// Min protocol: 26
    pub const extend_contract_data_ttl_v2 = @extern(*const fn (val.Val, val.StorageType, val.U32Val, val.U32Val, val.U32Val) callconv(.c) val.Void, .{ .name = "f", .library_name = "l" });

    ///    Extend the contract instance and/or corresponding code entry TTL to be up to `extend_to`
    ///    ledgers, where TTL is defined as `entry_live_until_ledger_seq - current_ledger_seq`.
    ///    `extension_scope` defines whether contract instance, code, or both will be extended. The
    ///    TTL extension only actually happens if it is at least `min_extension`, otherwise this
    ///    function is a no-op. The amount of extension ledgers will not exceed `max_extension`
    ///    ledgers. If attempting to extend an entry past the maximum allowed value (defined as the
    ///    current ledger + `max_entry_ttl` - 1), its new `live_until_ledger_seq` will be clamped to
    ///    the max.
    /// Min protocol: 26
    pub const extend_contract_instance_and_code_ttl_v2 = @extern(*const fn (val.AddressObject, val.ContractTTLExtension, val.U32Val, val.U32Val, val.U32Val) callconv(.c) val.Void, .{ .name = "g", .library_name = "l" });

};

// =============================================================================
// Module: call (wasm import module: "d")
// =============================================================================

pub const call = struct {
    ///    Calls a function in another contract with arguments contained in vector `args`. If the call
    ///    is successful, returns the result of the called function. Traps otherwise.
    pub const @"call" = @extern(*const fn (val.AddressObject, val.Symbol, val.VecObject) callconv(.c) val.Val, .{ .name = "_", .library_name = "d" });

    ///    Calls a function in another contract with arguments contained in vector `args`, returning
    ///    either the result of the called function or an `Error` if the called function failed. The
    ///    returned error is either a custom `ContractError` that the called contract returns
    ///    explicitly, or an error with type `Context` and code `InvalidAction` in case of any other
    ///    error in the called contract (such as a host function failure that caused a trap).
    ///    `try_call` might trap in a few scenarios where the error can't be meaningfully recovered
    ///    from, such as running out of budget.
    pub const try_call = @extern(*const fn (val.AddressObject, val.Symbol, val.VecObject) callconv(.c) val.Val, .{ .name = "0", .library_name = "d" });

};

// =============================================================================
// Module: buf (wasm import module: "b")
// =============================================================================

pub const buf = struct {
    ///    Serializes an (SC)Val into XDR opaque `Bytes` object.
    pub const serialize_to_bytes = @extern(*const fn (val.Val) callconv(.c) val.BytesObject, .{ .name = "_", .library_name = "b" });

    ///    Deserialize a `Bytes` object to get back the (SC)Val.
    pub const deserialize_from_bytes = @extern(*const fn (val.BytesObject) callconv(.c) val.Val, .{ .name = "0", .library_name = "b" });

    ///    Copies a slice of bytes from a `Bytes` object specified at offset `b_pos` with length `len`
    ///    into the linear memory at position `lm_pos`. Traps if either the `Bytes` object or the
    ///    linear memory doesn't have enough bytes.
    pub const bytes_copy_to_linear_memory = @extern(*const fn (val.BytesObject, val.U32Val, val.U32Val, val.U32Val) callconv(.c) val.Void, .{ .name = "1", .library_name = "b" });

    ///    Copies a segment of the linear memory specified at position `lm_pos` with length `len`,
    ///    into a `Bytes` object at offset `b_pos`. The `Bytes` object may grow in size to accommodate
    ///    the new bytes. Traps if the linear memory doesn't have enough bytes.
    pub const bytes_copy_from_linear_memory = @extern(*const fn (val.BytesObject, val.U32Val, val.U32Val, val.U32Val) callconv(.c) val.BytesObject, .{ .name = "2", .library_name = "b" });

    ///    Constructs a new `Bytes` object initialized with bytes copied from a linear memory slice
    ///    specified at position `lm_pos` with length `len`.
    pub const bytes_new_from_linear_memory = @extern(*const fn (val.U32Val, val.U32Val) callconv(.c) val.BytesObject, .{ .name = "3", .library_name = "b" });

    ///    Create an empty new `Bytes` object.
    pub const bytes_new = @extern(*const fn () callconv(.c) val.BytesObject, .{ .name = "4", .library_name = "b" });

    ///    Update the value at index `i` in the `Bytes` object. Return the new `Bytes`. Trap if the
    ///    index is out of bounds.
    pub const bytes_put = @extern(*const fn (val.BytesObject, val.U32Val, val.U32Val) callconv(.c) val.BytesObject, .{ .name = "5", .library_name = "b" });

    ///    Returns the element at index `i` of the `Bytes` object. Traps if the index is out of bound.
    pub const bytes_get = @extern(*const fn (val.BytesObject, val.U32Val) callconv(.c) val.U32Val, .{ .name = "6", .library_name = "b" });

    ///    Delete an element in a `Bytes` object at index `i`, shifting all elements after it to the
    ///    left. Return the new `Bytes`. Traps if the index is out of bound.
    pub const bytes_del = @extern(*const fn (val.BytesObject, val.U32Val) callconv(.c) val.BytesObject, .{ .name = "7", .library_name = "b" });

    ///    Returns length of the `Bytes` object.
    pub const bytes_len = @extern(*const fn (val.BytesObject) callconv(.c) val.U32Val, .{ .name = "8", .library_name = "b" });

    ///    Appends an element to the back of the `Bytes` object.
    pub const bytes_push = @extern(*const fn (val.BytesObject, val.U32Val) callconv(.c) val.BytesObject, .{ .name = "9", .library_name = "b" });

    ///    Removes the last element from the `Bytes` object and returns the new `Bytes`. Traps if
    ///    original `Bytes` is empty.
    pub const bytes_pop = @extern(*const fn (val.BytesObject) callconv(.c) val.BytesObject, .{ .name = "a", .library_name = "b" });

    ///    Return the first element in the `Bytes` object. Traps if the `Bytes` is empty
    pub const bytes_front = @extern(*const fn (val.BytesObject) callconv(.c) val.U32Val, .{ .name = "b", .library_name = "b" });

    ///    Return the last element in the `Bytes` object. Traps if the `Bytes` is empty
    pub const bytes_back = @extern(*const fn (val.BytesObject) callconv(.c) val.U32Val, .{ .name = "c", .library_name = "b" });

    ///    Inserts an element at index `i` within the `Bytes` object, shifting all elements after it
    ///    to the right. Traps if the index is out of bound
    pub const bytes_insert = @extern(*const fn (val.BytesObject, val.U32Val, val.U32Val) callconv(.c) val.BytesObject, .{ .name = "d", .library_name = "b" });

    ///    Clone the `Bytes` object `b1`, then moves all the elements of `Bytes` object `b2` into it.
    ///    Return the new `Bytes`. Traps if its length overflows a u32.
    pub const bytes_append = @extern(*const fn (val.BytesObject, val.BytesObject) callconv(.c) val.BytesObject, .{ .name = "e", .library_name = "b" });

    ///    Copies the elements from `start` index until `end` index, exclusive, in the `Bytes` object
    ///    and creates a new `Bytes` from it. Returns the new `Bytes`. Traps if the index is out of
    ///    bound.
    pub const bytes_slice = @extern(*const fn (val.BytesObject, val.U32Val, val.U32Val) callconv(.c) val.BytesObject, .{ .name = "f", .library_name = "b" });

    ///    Copies a slice of bytes from a `String` object specified at offset `s_pos` with length
    ///    `len` into the linear memory at position `lm_pos`. Traps if either the `String` object or
    ///    the linear memory doesn't have enough bytes.
    pub const string_copy_to_linear_memory = @extern(*const fn (val.StringObject, val.U32Val, val.U32Val, val.U32Val) callconv(.c) val.Void, .{ .name = "g", .library_name = "b" });

    ///    Copies a slice of bytes from a `Symbol` object specified at offset `s_pos` with length
    ///    `len` into the linear memory at position `lm_pos`. Traps if either the `String` object or
    ///    the linear memory doesn't have enough bytes.
    pub const symbol_copy_to_linear_memory = @extern(*const fn (val.SymbolObject, val.U32Val, val.U32Val, val.U32Val) callconv(.c) val.Void, .{ .name = "h", .library_name = "b" });

    ///    Constructs a new `String` object initialized with bytes copied from a linear memory slice
    ///    specified at position `lm_pos` with length `len`.
    pub const string_new_from_linear_memory = @extern(*const fn (val.U32Val, val.U32Val) callconv(.c) val.StringObject, .{ .name = "i", .library_name = "b" });

    ///    Constructs a new `Symbol` object initialized with bytes copied from a linear memory slice
    ///    specified at position `lm_pos` with length `len`.
    pub const symbol_new_from_linear_memory = @extern(*const fn (val.U32Val, val.U32Val) callconv(.c) val.SymbolObject, .{ .name = "j", .library_name = "b" });

    ///    Returns length of the `String` object.
    pub const string_len = @extern(*const fn (val.StringObject) callconv(.c) val.U32Val, .{ .name = "k", .library_name = "b" });

    ///    Returns length of the `Symbol` object.
    pub const symbol_len = @extern(*const fn (val.SymbolObject) callconv(.c) val.U32Val, .{ .name = "l", .library_name = "b" });

    ///    Return the index of a Symbol in an array of linear-memory byte-slices, or trap if not
    ///    found.
    pub const symbol_index_in_linear_memory = @extern(*const fn (val.Symbol, val.U32Val, val.U32Val) callconv(.c) val.U32Val, .{ .name = "m", .library_name = "b" });

    ///    Converts the provided string to bytes with exactly the same contents.
    /// Min protocol: 23
    pub const string_to_bytes = @extern(*const fn (val.StringObject) callconv(.c) val.BytesObject, .{ .name = "n", .library_name = "b" });

    ///    Converts the provided bytes array to string with exactly the same contents. No encoding
    ///    checks are performed and thus the output string's encoding should be interpreted by the
    ///    consumer of the string.
    /// Min protocol: 23
    pub const bytes_to_string = @extern(*const fn (val.BytesObject) callconv(.c) val.StringObject, .{ .name = "o", .library_name = "b" });

};

// =============================================================================
// Module: crypto (wasm import module: "c")
// =============================================================================

pub const crypto = struct {
    pub const compute_hash_sha256 = @extern(*const fn (val.BytesObject) callconv(.c) val.BytesObject, .{ .name = "_", .library_name = "c" });

    pub const verify_sig_ed25519 = @extern(*const fn (val.BytesObject, val.BytesObject, val.BytesObject) callconv(.c) val.Void, .{ .name = "0", .library_name = "c" });

    ///    Returns the keccak256 hash of given input bytes.
    pub const compute_hash_keccak256 = @extern(*const fn (val.BytesObject) callconv(.c) val.BytesObject, .{ .name = "1", .library_name = "c" });

    ///    Recovers the SEC-1-encoded ECDSA secp256k1 public key that produced a given 64-byte
    ///    `signature` over a given 32-byte `msg_digest` for a given `recovery_id` byte. Warning: The
    ///    `msg_digest` must be produced by a secure cryptographic hash function on the message,
    ///    otherwise the attacker can potentially forge signatures. The `signature` is the ECDSA
    ///    signature `(r, s)` serialized as fixed-size big endian scalar values, both `r`, `s` must be
    ///    non-zero and `s` must be in the lower range. Returns a `BytesObject` containing 65-bytes
    ///    representing SEC-1 encoded point in uncompressed format. The `recovery_id` is an integer
    ///    value `0`, `1`, `2`, or `3`, the low bit (0/1) indicates the parity of the y-coordinate of
    ///    the `public_key` (even/odd) and the high bit (3/4) indicate if the `r` (x-coordinate of `k
    ///    x G`) has overflown during its computation.
    pub const recover_key_ecdsa_secp256k1 = @extern(*const fn (val.BytesObject, val.BytesObject, val.U32Val) callconv(.c) val.BytesObject, .{ .name = "2", .library_name = "c" });

    ///    Verifies the `signature` using an ECDSA secp256r1 `public_key` on a 32-byte `msg_digest`.
    ///    Warning: The `msg_digest` must be produced by a secure cryptographic hash function on the
    ///    message, otherwise the attacker can potentially forge signatures. The `public_key` is
    ///    expected to be 65 bytes in length, representing a SEC-1 encoded point in uncompressed
    ///    format. The `signature` is the ECDSA signature `(r, s)` serialized as fixed-size big endian
    ///    scalar values, both `r`, `s` must be non-zero and `s` must be in the lower range.
    /// Min protocol: 21
    pub const verify_sig_ecdsa_secp256r1 = @extern(*const fn (val.BytesObject, val.BytesObject, val.BytesObject) callconv(.c) val.Void, .{ .name = "3", .library_name = "c" });

    ///    Checks if the input G1 point is in the correct subgroup. This function will error if
    ///    `point` is not on the curve
    /// Min protocol: 22
    pub const bls12_381_check_g1_is_in_subgroup = @extern(*const fn (val.BytesObject) callconv(.c) val.Bool, .{ .name = "4", .library_name = "c" });

    ///    Adds two BLS12-381 G1 points given in bytes format and returns the resulting G1 point in
    ///    bytes format. G1 serialization format: `concat(be_bytes(X), be_bytes(Y))` and the most
    ///    significant three bits of X encodes flags, i.e. bits(X) = [compression_flag, infinity_flag,
    ///    sort_flag, bit_3, .. bit_383]. This function does NOT perform subgroup check on the inputs.
    /// Min protocol: 22
    pub const bls12_381_g1_add = @extern(*const fn (val.BytesObject, val.BytesObject) callconv(.c) val.BytesObject, .{ .name = "5", .library_name = "c" });

    ///    Multiplies a BLS12-381 G1 point by a scalar (Fr), and returns the resulting G1 point in
    ///    bytes format.
    /// Min protocol: 22
    pub const bls12_381_g1_mul = @extern(*const fn (val.BytesObject, val.U256Val) callconv(.c) val.BytesObject, .{ .name = "6", .library_name = "c" });

    ///    Performs multi-scalar-multiplication (inner product) on a vector of BLS12-381 G1 points
    ///    (`Vec<BytesObject>`) by a vector of scalars (`Vec<U256Val>`), and returns the resulting G1
    ///    point in bytes format.
    /// Min protocol: 22
    pub const bls12_381_g1_msm = @extern(*const fn (val.VecObject, val.VecObject) callconv(.c) val.BytesObject, .{ .name = "7", .library_name = "c" });

    ///    Maps a BLS12-381 field element (Fp) to G1 point. The input is a BytesObject containing Fp
    ///    serialized in big-endian order
    /// Min protocol: 22
    pub const bls12_381_map_fp_to_g1 = @extern(*const fn (val.BytesObject) callconv(.c) val.BytesObject, .{ .name = "8", .library_name = "c" });

    ///    Hashes a message to a BLS12-381 G1 point, with implementation following the specification
    ///    in [Hashing to Elliptic Curves](https://datatracker.ietf.org/doc/html/rfc9380) (ciphersuite
    ///    'BLS12381G1_XMD:SHA-256_SSWU_RO_'). `dst` is the domain separation tag that will be
    ///    concatenated with the `msg` during hashing, it is intended to keep hashing inputs of
    ///    different applications separate. It is required `0 < len(dst_bytes) < 256`. DST **must** be
    ///    chosen with care to avoid compromising the application's security properties. Refer to
    ///    section 3.1 in the RFC on requirements of DST.
    /// Min protocol: 22
    pub const bls12_381_hash_to_g1 = @extern(*const fn (val.BytesObject, val.BytesObject) callconv(.c) val.BytesObject, .{ .name = "9", .library_name = "c" });

    ///    Checks if the input G2 point is in the correct subgroup. This function will error if
    ///    `point` is not on the curve
    /// Min protocol: 22
    pub const bls12_381_check_g2_is_in_subgroup = @extern(*const fn (val.BytesObject) callconv(.c) val.Bool, .{ .name = "a", .library_name = "c" });

    ///    Adds two BLS12-381 G2 points given in bytes format and returns the resulting G2 point in
    ///    bytes format. G2 serialization format: concat(be_bytes(X_c1), be_bytes(X_c0),
    ///    be_bytes(Y_c1), be_bytes(Y_c0)), and the most significant three bits of X_c1 are flags i.e.
    ///    bits(X_c1) = [compression_flag, infinity_flag, sort_flag, bit_3, .. bit_383]. This function
    ///    does NOT perform subgroup check on the inputs.
    /// Min protocol: 22
    pub const bls12_381_g2_add = @extern(*const fn (val.BytesObject, val.BytesObject) callconv(.c) val.BytesObject, .{ .name = "b", .library_name = "c" });

    ///    Multiplies a BLS12-381 G2 point by a scalar (Fr), and returns the resulting G2 point in
    ///    bytes format.
    /// Min protocol: 22
    pub const bls12_381_g2_mul = @extern(*const fn (val.BytesObject, val.U256Val) callconv(.c) val.BytesObject, .{ .name = "c", .library_name = "c" });

    ///    Performs multi-scalar-multiplication (inner product) on a vector of BLS12-381 G2 points
    ///    (`Vec<BytesObject>`) by a vector of scalars (`Vec<U256Val>`) , and returns the resulting G2
    ///    point in bytes format.
    /// Min protocol: 22
    pub const bls12_381_g2_msm = @extern(*const fn (val.VecObject, val.VecObject) callconv(.c) val.BytesObject, .{ .name = "d", .library_name = "c" });

    ///    Maps a BLS12-381 quadratic extension field element (Fp2) to G2 point. Fp2 serialization
    ///    format: concat(be_bytes(c1), be_bytes(c0))
    /// Min protocol: 22
    pub const bls12_381_map_fp2_to_g2 = @extern(*const fn (val.BytesObject) callconv(.c) val.BytesObject, .{ .name = "e", .library_name = "c" });

    ///    Hashes a message to a BLS12-381 G2 point, with implementation following the specification
    ///    in [Hashing to Elliptic Curves](https://datatracker.ietf.org/doc/html/rfc9380) (ciphersuite
    ///    'BLS12381G2_XMD:SHA-256_SSWU_RO_'). `dst` is the domain separation tag that will be
    ///    concatenated with the `msg` during hashing, it is intended to keep hashing inputs of
    ///    different applications separate. It is required `0 < len(dst_bytes) < 256`. DST **must** be
    ///    chosen with care to avoid compromising the application's security properties. Refer to
    ///    section 3.1 in the RFC on requirements of DST.
    /// Min protocol: 22
    pub const bls12_381_hash_to_g2 = @extern(*const fn (val.BytesObject, val.BytesObject) callconv(.c) val.BytesObject, .{ .name = "f", .library_name = "c" });

    ///    performs pairing operation on a vector of `G1` (`Vec<BytesObject>`) and a vector of `G2`
    ///    points (`Vec<BytesObject>`) , return true if the result equals `1_fp12`
    /// Min protocol: 22
    pub const bls12_381_multi_pairing_check = @extern(*const fn (val.VecObject, val.VecObject) callconv(.c) val.Bool, .{ .name = "g", .library_name = "c" });

    ///    performs addition `(lhs + rhs) mod r` between two BLS12-381 scalar elements (Fr), where r
    ///    is the subgroup order
    /// Min protocol: 22
    pub const bls12_381_fr_add = @extern(*const fn (val.U256Val, val.U256Val) callconv(.c) val.U256Val, .{ .name = "h", .library_name = "c" });

    ///    performs subtraction `(lhs - rhs) mod r` between two BLS12-381 scalar elements (Fr), where
    ///    r is the subgroup order
    /// Min protocol: 22
    pub const bls12_381_fr_sub = @extern(*const fn (val.U256Val, val.U256Val) callconv(.c) val.U256Val, .{ .name = "i", .library_name = "c" });

    ///    performs multiplication `(lhs * rhs) mod r` between two BLS12-381 scalar elements (Fr),
    ///    where r is the subgroup order
    /// Min protocol: 22
    pub const bls12_381_fr_mul = @extern(*const fn (val.U256Val, val.U256Val) callconv(.c) val.U256Val, .{ .name = "j", .library_name = "c" });

    ///    performs exponentiation of a BLS12-381 scalar element (Fr) with a u64 exponent i.e.
    ///    `lhs.exp(rhs) mod r`, where r is the subgroup order
    /// Min protocol: 22
    pub const bls12_381_fr_pow = @extern(*const fn (val.U256Val, val.U64Val) callconv(.c) val.U256Val, .{ .name = "k", .library_name = "c" });

    ///    performs inversion of a BLS12-381 scalar element (Fr) modulo r (the subgroup order)
    /// Min protocol: 22
    pub const bls12_381_fr_inv = @extern(*const fn (val.U256Val) callconv(.c) val.U256Val, .{ .name = "l", .library_name = "c" });

    ///    Adds two BN254 G1 points. G1 encoding: 64-byte uncompressed format:
    ///    be_bytes(X)||be_bytes(Y), where X and Y are 32-byte big-endian Fp field elements. The two
    ///    flag bits (0x80 and 0x40) of the first byte must be unset -- infinity is represented as 64
    ///    zero bytes. Points must be on curve with no subgroup check needed (always in subgroup)
    /// Min protocol: 25
    pub const bn254_g1_add = @extern(*const fn (val.BytesObject, val.BytesObject) callconv(.c) val.BytesObject, .{ .name = "m", .library_name = "c" });

    ///    Multiplies a BN254 G1 point by a scalar from the scalar field Fr. The point uses the same
    ///    64-byte encoding as bn254_g1_add. The scalar is a U256Val representing a 256-bit integer
    ///    that is reduced modulo the Fr field order.
    /// Min protocol: 25
    pub const bn254_g1_mul = @extern(*const fn (val.BytesObject, val.U256Val) callconv(.c) val.BytesObject, .{ .name = "n", .library_name = "c" });

    ///    Performs BN254 multi-pairing check over equal-length non-empty vectors of G1 and G2 points.
    ///    Returns true iff the product of pairings e(G1[0],G2[0])*...*e(G1[n-1],G2[n-1]) equals 1 in
    ///    Fq12. G1 encoding: 64 bytes as in bn254_g1_add. G2 encoding: 128-byte uncompressed format:
    ///    be_bytes(X)||be_bytes(Y), where X and Y are Fp2 elements (64 bytes each). Fp2 element
    ///    encoding: be_bytes(c1)||be_bytes(c0) where c0 is the real part and c1 is the imaginary part
    ///    (each 32-byte big-endian Fp). The two flag bits (0x80 and 0x40) of the first byte must be
    ///    unset -- G2 infinity is 128 zero bytes. G2 points must be on curve AND in the correct
    ///    subgroup.
    /// Min protocol: 25
    pub const bn254_multi_pairing_check = @extern(*const fn (val.VecObject, val.VecObject) callconv(.c) val.Bool, .{ .name = "o", .library_name = "c" });

    ///    Performs Poseidon permutation on input vector. input: vector of field elements (length t).
    ///    field: 'BLS12_381' or 'BN254'. t: state size. d: S-box degree (5 for BLS12_381/BN254).
    ///    rounds_f: number of full rounds (must be even). rounds_p: number of partial rounds. mds:
    ///    t-by-t MDS matrix as Vec<Vec<Scalar>>. round_constants: (rounds_f+rounds_p)-by-t round
    ///    constants matrix as Vec<Vec<Scalar>>. Returns output vector after permutation.
    /// Min protocol: 25
    pub const poseidon_permutation = @extern(*const fn (val.VecObject, val.Symbol, val.U32Val, val.U32Val, val.U32Val, val.U32Val, val.VecObject, val.VecObject) callconv(.c) val.VecObject, .{ .name = "p", .library_name = "c" });

    ///    Performs Poseidon2 permutation on input vector. input: vector of field elements (length t).
    ///    field: 'BLS12_381' or 'BN254'. t: state size. d: S-box degree (5 for BLS12_381/BN254).
    ///    rounds_f: number of full rounds (must be even). rounds_p: number of partial rounds.
    ///    mat_internal_diag_m_1: internal matrix diagonal minus 1 as Vec<Scalar> (length t).
    ///    round_constants: (rounds_f+rounds_p)-by-t round constants matrix as Vec<Vec<Scalar>>.
    ///    Returns output vector after permutation.
    /// Min protocol: 25
    pub const poseidon2_permutation = @extern(*const fn (val.VecObject, val.Symbol, val.U32Val, val.U32Val, val.U32Val, val.U32Val, val.VecObject, val.VecObject) callconv(.c) val.VecObject, .{ .name = "q", .library_name = "c" });

    ///    Performs multi-scalar-multiplication (inner product) on a vector of BN254 G1 points
    ///    (`Vec<BytesObject>`) by a vector of scalars (`Vec<U256Val>`), and returns the resulting G1
    ///    point in 64-byte uncompressed format.
    /// Min protocol: 26
    pub const bn254_g1_msm = @extern(*const fn (val.VecObject, val.VecObject) callconv(.c) val.BytesObject, .{ .name = "r", .library_name = "c" });

    ///    Performs addition `(lhs + rhs) mod r` between two BN254 scalar elements (Fr), where r is
    ///    the subgroup order
    /// Min protocol: 26
    pub const bn254_fr_add = @extern(*const fn (val.U256Val, val.U256Val) callconv(.c) val.U256Val, .{ .name = "s", .library_name = "c" });

    ///    Performs subtraction `(lhs - rhs) mod r` between two BN254 scalar elements (Fr), where r is
    ///    the subgroup order
    /// Min protocol: 26
    pub const bn254_fr_sub = @extern(*const fn (val.U256Val, val.U256Val) callconv(.c) val.U256Val, .{ .name = "t", .library_name = "c" });

    ///    Performs multiplication `(lhs * rhs) mod r` between two BN254 scalar elements (Fr), where r
    ///    is the subgroup order
    /// Min protocol: 26
    pub const bn254_fr_mul = @extern(*const fn (val.U256Val, val.U256Val) callconv(.c) val.U256Val, .{ .name = "u", .library_name = "c" });

    ///    Performs exponentiation of a BN254 scalar element (Fr) with a u64 exponent i.e.
    ///    `lhs.exp(rhs) mod r`, where r is the subgroup order
    /// Min protocol: 26
    pub const bn254_fr_pow = @extern(*const fn (val.U256Val, val.U64Val) callconv(.c) val.U256Val, .{ .name = "v", .library_name = "c" });

    ///    Performs inversion of a BN254 scalar element (Fr) modulo r (the subgroup order)
    /// Min protocol: 26
    pub const bn254_fr_inv = @extern(*const fn (val.U256Val) callconv(.c) val.U256Val, .{ .name = "w", .library_name = "c" });

    ///    Checks if a BLS12-381 G1 point is on the curve (does not check subgroup membership).
    ///    Returns true if the point is on the curve, false otherwise.
    /// Min protocol: 26
    pub const bls12_381_g1_is_on_curve = @extern(*const fn (val.BytesObject) callconv(.c) val.Bool, .{ .name = "x", .library_name = "c" });

    ///    Checks if a BLS12-381 G2 point is on the curve (does not check subgroup membership).
    ///    Returns true if the point is on the curve, false otherwise.
    /// Min protocol: 26
    pub const bls12_381_g2_is_on_curve = @extern(*const fn (val.BytesObject) callconv(.c) val.Bool, .{ .name = "y", .library_name = "c" });

    ///    Checks if a BN254 G1 point is on the curve. Returns true if the point is on the curve,
    ///    false otherwise.
    /// Min protocol: 26
    pub const bn254_g1_is_on_curve = @extern(*const fn (val.BytesObject) callconv(.c) val.Bool, .{ .name = "z", .library_name = "c" });

};

// =============================================================================
// Module: address (wasm import module: "a")
// =============================================================================

pub const address = struct {
    ///    Checks if the address has authorized the invocation of the current contract function with
    ///    the provided arguments. Traps if the invocation hasn't been authorized.
    pub const require_auth_for_args = @extern(*const fn (val.AddressObject, val.VecObject) callconv(.c) val.Void, .{ .name = "_", .library_name = "a" });

    ///    Checks if the address has authorized the invocation of the current contract function with
    ///    all the arguments of the invocation. Traps if the invocation hasn't been authorized.
    pub const require_auth = @extern(*const fn (val.AddressObject) callconv(.c) val.Void, .{ .name = "0", .library_name = "a" });

    ///    Converts a provided Stellar strkey address of an account or a contract ('G...' or 'C...'
    ///    respectively) to an address object. `strkey` can be either `BytesObject` or `StringObject`
    ///    (the contents should represent the `G.../C...` string in both cases). Any other valid or
    ///    invalid strkey (e.g. 'S...') will trigger an error. Prefer directly using the Address
    ///    objects whenever possible. This is only useful in the context of custom messaging protocols
    ///    (e.g. cross-chain).
    pub const strkey_to_address = @extern(*const fn (val.Val) callconv(.c) val.AddressObject, .{ .name = "1", .library_name = "a" });

    ///    Converts a provided address to Stellar strkey format ('G...' for account or 'C...' for
    ///    contract). Prefer directly using the Address objects whenever possible. This is only useful
    ///    in the context of custom messaging protocols (e.g. cross-chain).
    pub const address_to_strkey = @extern(*const fn (val.AddressObject) callconv(.c) val.StringObject, .{ .name = "2", .library_name = "a" });

    ///    Authorizes sub-contract calls for the next contract call on behalf of the current contract.
    ///    Every entry in the argument vector corresponds to `InvokerContractAuthEntry` contract type
    ///    that authorizes a tree of `require_auth` calls on behalf of the current contract. The
    ///    entries must not contain any authorizations for the direct contract call, i.e. if current
    ///    contract needs to call contract function F1 that calls function F2 both of which require
    ///    auth, only F2 should be present in `auth_entries`.
    pub const authorize_as_curr_contract = @extern(*const fn (val.VecObject) callconv(.c) val.Void, .{ .name = "3", .library_name = "a" });

    ///    Returns the address corresponding to the provided MuxedAddressObject as a new
    ///    AddressObject. Note, that MuxedAddressObject consists of the address and multiplexing id,
    ///    so this conversion just strips the multiplexing id from the input muxed address.
    /// Min protocol: 23
    pub const get_address_from_muxed_address = @extern(*const fn (val.MuxedAddressObject) callconv(.c) val.AddressObject, .{ .name = "4", .library_name = "a" });

    ///    Returns the multiplexing id corresponding to the provided MuxedAddressObject as a U64Val.
    /// Min protocol: 23
    pub const get_id_from_muxed_address = @extern(*const fn (val.MuxedAddressObject) callconv(.c) val.U64Val, .{ .name = "5", .library_name = "a" });

    ///    Returns the executable corresponding to the provided address. When the address does not
    ///    exist on-chain, returns `Void` value. When it does exist, returns a value of
    ///    `AddressExecutable` contract type. It is an enum with `Wasm` value and the corresponding
    ///    Wasm hash for the Wasm contracts, `StellarAsset` value for Stellar Asset contract
    ///    instances, and `Account` value for the 'classic' (G-) accounts.
    /// Min protocol: 23
    pub const get_address_executable = @extern(*const fn (val.AddressObject) callconv(.c) val.Val, .{ .name = "6", .library_name = "a" });

};

// =============================================================================
// Module: test (wasm import module: "t")
// =============================================================================

pub const @"test" = struct {
    ///    A dummy function taking 0 arguments and performs no-op. This function is for test purpose
    ///    only, for measuring the roundtrip cost of invoking a host function, i.e. host->Vm->host.
    pub const dummy0 = @extern(*const fn () callconv(.c) val.Val, .{ .name = "_", .library_name = "t" });

    ///    A dummy function for testing the protocol gating. Takes 0 arguments and performs no-op.
    ///    Essentially this function is always protocol-gated out since it has `min_supported_protocol
    ///    == max_supported_protocol == 19`, thus having no effect on any protocol (Soroban starts at
    ///    protocol 20). This is required for testing the scenario where ledger protocol version >
    ///    host function max supported version, and the ledger protocol version must be <= the `env`
    ///    version (which starts at 20, and is a compile-time, non-overridable constant).
    /// Min protocol: 19
    pub const protocol_gated_dummy = @extern(*const fn () callconv(.c) val.Val, .{ .name = "0", .library_name = "t" });

};

// =============================================================================
// Module: prng (wasm import module: "p")
// =============================================================================

pub const prng = struct {
    ///    Reseed the frame-local PRNG with a given BytesObject, which should be 32 bytes long.
    pub const prng_reseed = @extern(*const fn (val.BytesObject) callconv(.c) val.Void, .{ .name = "_", .library_name = "p" });

    ///    Construct a new BytesObject of the given length filled with bytes drawn from the
    ///    frame-local PRNG.
    pub const prng_bytes_new = @extern(*const fn (val.U32Val) callconv(.c) val.BytesObject, .{ .name = "0", .library_name = "p" });

    ///    Return a u64 uniformly sampled from the inclusive range [lo,hi] by the frame-local PRNG.
    pub const prng_u64_in_inclusive_range = @extern(*const fn (u64, u64) callconv(.c) u64, .{ .name = "1", .library_name = "p" });

    ///    Return a (Fisher-Yates) shuffled clone of a given vector, using the frame-local PRNG.
    pub const prng_vec_shuffle = @extern(*const fn (val.VecObject) callconv(.c) val.VecObject, .{ .name = "2", .library_name = "p" });

};
