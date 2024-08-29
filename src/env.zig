// Generated from https://raw.githubusercontent.com/stellar/rs-soroban-env/v21.0.0/soroban-env-common/env.json.
pub const Val = u64;
pub const Void = Val;
pub const Error = Val;
pub const U32Val = Val;
pub const I32Val = Val;
pub const U64Val = Val;
pub const I64Val = Val;
pub const BytesObject = Val;
pub const AddressObject = Val;
pub const U64Object = Val;
pub const I64Object = Val;
pub const U128Object = Val;
pub const I128Object = Val;
pub const U128Val = Val;
pub const I128Val = Val;
pub const U256Object = Val;
pub const I256Object = Val;
pub const U256Val = Val;
pub const I256Val = Val;
pub const TimepointObject = Val;
pub const DurationObject = Val;
pub const MapObject = Val;
pub const Bool = Val;
pub const VecObject = Val;
pub const StringObject = Val;
pub const SymbolObject = Val;
pub const Symbol = Val;
pub const StorageType = Val;
pub const context = struct {
    pub const log_from_linear_memory = @extern(*const fn (
        msg_pos: U32Val,
        msg_len: U32Val,
        vals_pos: U32Val,
        vals_len: U32Val,
    ) callconv(.C) Void, .{ .library_name = "x", .name = "_" });
    pub const obj_cmp = @extern(*const fn (
        a: Val,
        b: Val,
    ) callconv(.C) i64, .{ .library_name = "x", .name = "0" });
    pub const contract_event = @extern(*const fn (
        topics: VecObject,
        data: Val,
    ) callconv(.C) Void, .{ .library_name = "x", .name = "1" });
    pub const get_ledger_version = @extern(*const fn () callconv(.C) U32Val, .{ .library_name = "x", .name = "2" });
    pub const get_ledger_sequence = @extern(*const fn () callconv(.C) U32Val, .{ .library_name = "x", .name = "3" });
    pub const get_ledger_timestamp = @extern(*const fn () callconv(.C) U64Val, .{ .library_name = "x", .name = "4" });
    pub const fail_with_error = @extern(*const fn (
        @"error": Error,
    ) callconv(.C) Void, .{ .library_name = "x", .name = "5" });
    pub const get_ledger_network_id = @extern(*const fn () callconv(.C) BytesObject, .{ .library_name = "x", .name = "6" });
    pub const get_current_contract_address = @extern(*const fn () callconv(.C) AddressObject, .{ .library_name = "x", .name = "7" });
    pub const get_max_live_until_ledger = @extern(*const fn () callconv(.C) U32Val, .{ .library_name = "x", .name = "8" });
};
pub const int = struct {
    pub const obj_from_u64 = @extern(*const fn (
        v: u64,
    ) callconv(.C) U64Object, .{ .library_name = "i", .name = "_" });
    pub const obj_to_u64 = @extern(*const fn (
        obj: U64Object,
    ) callconv(.C) u64, .{ .library_name = "i", .name = "0" });
    pub const obj_from_i64 = @extern(*const fn (
        v: i64,
    ) callconv(.C) I64Object, .{ .library_name = "i", .name = "1" });
    pub const obj_to_i64 = @extern(*const fn (
        obj: I64Object,
    ) callconv(.C) i64, .{ .library_name = "i", .name = "2" });
    pub const obj_from_u128_pieces = @extern(*const fn (
        hi: u64,
        lo: u64,
    ) callconv(.C) U128Object, .{ .library_name = "i", .name = "3" });
    pub const obj_to_u128_lo64 = @extern(*const fn (
        obj: U128Object,
    ) callconv(.C) u64, .{ .library_name = "i", .name = "4" });
    pub const obj_to_u128_hi64 = @extern(*const fn (
        obj: U128Object,
    ) callconv(.C) u64, .{ .library_name = "i", .name = "5" });
    pub const obj_from_i128_pieces = @extern(*const fn (
        hi: i64,
        lo: u64,
    ) callconv(.C) I128Object, .{ .library_name = "i", .name = "6" });
    pub const obj_to_i128_lo64 = @extern(*const fn (
        obj: I128Object,
    ) callconv(.C) u64, .{ .library_name = "i", .name = "7" });
    pub const obj_to_i128_hi64 = @extern(*const fn (
        obj: I128Object,
    ) callconv(.C) i64, .{ .library_name = "i", .name = "8" });
    pub const obj_from_u256_pieces = @extern(*const fn (
        hi_hi: u64,
        hi_lo: u64,
        lo_hi: u64,
        lo_lo: u64,
    ) callconv(.C) U256Object, .{ .library_name = "i", .name = "9" });
    pub const u256_val_from_be_bytes = @extern(*const fn (
        bytes: BytesObject,
    ) callconv(.C) U256Val, .{ .library_name = "i", .name = "a" });
    pub const u256_val_to_be_bytes = @extern(*const fn (
        val: U256Val,
    ) callconv(.C) BytesObject, .{ .library_name = "i", .name = "b" });
    pub const obj_to_u256_hi_hi = @extern(*const fn (
        obj: U256Object,
    ) callconv(.C) u64, .{ .library_name = "i", .name = "c" });
    pub const obj_to_u256_hi_lo = @extern(*const fn (
        obj: U256Object,
    ) callconv(.C) u64, .{ .library_name = "i", .name = "d" });
    pub const obj_to_u256_lo_hi = @extern(*const fn (
        obj: U256Object,
    ) callconv(.C) u64, .{ .library_name = "i", .name = "e" });
    pub const obj_to_u256_lo_lo = @extern(*const fn (
        obj: U256Object,
    ) callconv(.C) u64, .{ .library_name = "i", .name = "f" });
    pub const obj_from_i256_pieces = @extern(*const fn (
        hi_hi: i64,
        hi_lo: u64,
        lo_hi: u64,
        lo_lo: u64,
    ) callconv(.C) I256Object, .{ .library_name = "i", .name = "g" });
    pub const i256_val_from_be_bytes = @extern(*const fn (
        bytes: BytesObject,
    ) callconv(.C) I256Val, .{ .library_name = "i", .name = "h" });
    pub const i256_val_to_be_bytes = @extern(*const fn (
        val: I256Val,
    ) callconv(.C) BytesObject, .{ .library_name = "i", .name = "i" });
    pub const obj_to_i256_hi_hi = @extern(*const fn (
        obj: I256Object,
    ) callconv(.C) i64, .{ .library_name = "i", .name = "j" });
    pub const obj_to_i256_hi_lo = @extern(*const fn (
        obj: I256Object,
    ) callconv(.C) u64, .{ .library_name = "i", .name = "k" });
    pub const obj_to_i256_lo_hi = @extern(*const fn (
        obj: I256Object,
    ) callconv(.C) u64, .{ .library_name = "i", .name = "l" });
    pub const obj_to_i256_lo_lo = @extern(*const fn (
        obj: I256Object,
    ) callconv(.C) u64, .{ .library_name = "i", .name = "m" });
    pub const u256_add = @extern(*const fn (
        lhs: U256Val,
        rhs: U256Val,
    ) callconv(.C) U256Val, .{ .library_name = "i", .name = "n" });
    pub const u256_sub = @extern(*const fn (
        lhs: U256Val,
        rhs: U256Val,
    ) callconv(.C) U256Val, .{ .library_name = "i", .name = "o" });
    pub const u256_mul = @extern(*const fn (
        lhs: U256Val,
        rhs: U256Val,
    ) callconv(.C) U256Val, .{ .library_name = "i", .name = "p" });
    pub const u256_div = @extern(*const fn (
        lhs: U256Val,
        rhs: U256Val,
    ) callconv(.C) U256Val, .{ .library_name = "i", .name = "q" });
    pub const u256_rem_euclid = @extern(*const fn (
        lhs: U256Val,
        rhs: U256Val,
    ) callconv(.C) U256Val, .{ .library_name = "i", .name = "r" });
    pub const u256_pow = @extern(*const fn (
        lhs: U256Val,
        rhs: U32Val,
    ) callconv(.C) U256Val, .{ .library_name = "i", .name = "s" });
    pub const u256_shl = @extern(*const fn (
        lhs: U256Val,
        rhs: U32Val,
    ) callconv(.C) U256Val, .{ .library_name = "i", .name = "t" });
    pub const u256_shr = @extern(*const fn (
        lhs: U256Val,
        rhs: U32Val,
    ) callconv(.C) U256Val, .{ .library_name = "i", .name = "u" });
    pub const i256_add = @extern(*const fn (
        lhs: I256Val,
        rhs: I256Val,
    ) callconv(.C) I256Val, .{ .library_name = "i", .name = "v" });
    pub const i256_sub = @extern(*const fn (
        lhs: I256Val,
        rhs: I256Val,
    ) callconv(.C) I256Val, .{ .library_name = "i", .name = "w" });
    pub const i256_mul = @extern(*const fn (
        lhs: I256Val,
        rhs: I256Val,
    ) callconv(.C) I256Val, .{ .library_name = "i", .name = "x" });
    pub const i256_div = @extern(*const fn (
        lhs: I256Val,
        rhs: I256Val,
    ) callconv(.C) I256Val, .{ .library_name = "i", .name = "y" });
    pub const i256_rem_euclid = @extern(*const fn (
        lhs: I256Val,
        rhs: I256Val,
    ) callconv(.C) I256Val, .{ .library_name = "i", .name = "z" });
    pub const i256_pow = @extern(*const fn (
        lhs: I256Val,
        rhs: U32Val,
    ) callconv(.C) I256Val, .{ .library_name = "i", .name = "A" });
    pub const i256_shl = @extern(*const fn (
        lhs: I256Val,
        rhs: U32Val,
    ) callconv(.C) I256Val, .{ .library_name = "i", .name = "B" });
    pub const i256_shr = @extern(*const fn (
        lhs: I256Val,
        rhs: U32Val,
    ) callconv(.C) I256Val, .{ .library_name = "i", .name = "C" });
    pub const timepoint_obj_from_u64 = @extern(*const fn (
        v: u64,
    ) callconv(.C) TimepointObject, .{ .library_name = "i", .name = "D" });
    pub const timepoint_obj_to_u64 = @extern(*const fn (
        obj: TimepointObject,
    ) callconv(.C) u64, .{ .library_name = "i", .name = "E" });
    pub const duration_obj_from_u64 = @extern(*const fn (
        v: u64,
    ) callconv(.C) DurationObject, .{ .library_name = "i", .name = "F" });
    pub const duration_obj_to_u64 = @extern(*const fn (
        obj: DurationObject,
    ) callconv(.C) u64, .{ .library_name = "i", .name = "G" });
};
pub const map = struct {
    pub const map_new = @extern(*const fn () callconv(.C) MapObject, .{ .library_name = "m", .name = "_" });
    pub const map_put = @extern(*const fn (
        m: MapObject,
        k: Val,
        v: Val,
    ) callconv(.C) MapObject, .{ .library_name = "m", .name = "0" });
    pub const map_get = @extern(*const fn (
        m: MapObject,
        k: Val,
    ) callconv(.C) Val, .{ .library_name = "m", .name = "1" });
    pub const map_del = @extern(*const fn (
        m: MapObject,
        k: Val,
    ) callconv(.C) MapObject, .{ .library_name = "m", .name = "2" });
    pub const map_len = @extern(*const fn (
        m: MapObject,
    ) callconv(.C) U32Val, .{ .library_name = "m", .name = "3" });
    pub const map_has = @extern(*const fn (
        m: MapObject,
        k: Val,
    ) callconv(.C) Bool, .{ .library_name = "m", .name = "4" });
    pub const map_key_by_pos = @extern(*const fn (
        m: MapObject,
        i: U32Val,
    ) callconv(.C) Val, .{ .library_name = "m", .name = "5" });
    pub const map_val_by_pos = @extern(*const fn (
        m: MapObject,
        i: U32Val,
    ) callconv(.C) Val, .{ .library_name = "m", .name = "6" });
    pub const map_keys = @extern(*const fn (
        m: MapObject,
    ) callconv(.C) VecObject, .{ .library_name = "m", .name = "7" });
    pub const map_values = @extern(*const fn (
        m: MapObject,
    ) callconv(.C) VecObject, .{ .library_name = "m", .name = "8" });
    pub const map_new_from_linear_memory = @extern(*const fn (
        keys_pos: U32Val,
        vals_pos: U32Val,
        len: U32Val,
    ) callconv(.C) MapObject, .{ .library_name = "m", .name = "9" });
    pub const map_unpack_to_linear_memory = @extern(*const fn (
        map: MapObject,
        keys_pos: U32Val,
        vals_pos: U32Val,
        len: U32Val,
    ) callconv(.C) Void, .{ .library_name = "m", .name = "a" });
};
pub const vec = struct {
    pub const vec_new = @extern(*const fn () callconv(.C) VecObject, .{ .library_name = "v", .name = "_" });
    pub const vec_put = @extern(*const fn (
        v: VecObject,
        i: U32Val,
        x: Val,
    ) callconv(.C) VecObject, .{ .library_name = "v", .name = "0" });
    pub const vec_get = @extern(*const fn (
        v: VecObject,
        i: U32Val,
    ) callconv(.C) Val, .{ .library_name = "v", .name = "1" });
    pub const vec_del = @extern(*const fn (
        v: VecObject,
        i: U32Val,
    ) callconv(.C) VecObject, .{ .library_name = "v", .name = "2" });
    pub const vec_len = @extern(*const fn (
        v: VecObject,
    ) callconv(.C) U32Val, .{ .library_name = "v", .name = "3" });
    pub const vec_push_front = @extern(*const fn (
        v: VecObject,
        x: Val,
    ) callconv(.C) VecObject, .{ .library_name = "v", .name = "4" });
    pub const vec_pop_front = @extern(*const fn (
        v: VecObject,
    ) callconv(.C) VecObject, .{ .library_name = "v", .name = "5" });
    pub const vec_push_back = @extern(*const fn (
        v: VecObject,
        x: Val,
    ) callconv(.C) VecObject, .{ .library_name = "v", .name = "6" });
    pub const vec_pop_back = @extern(*const fn (
        v: VecObject,
    ) callconv(.C) VecObject, .{ .library_name = "v", .name = "7" });
    pub const vec_front = @extern(*const fn (
        v: VecObject,
    ) callconv(.C) Val, .{ .library_name = "v", .name = "8" });
    pub const vec_back = @extern(*const fn (
        v: VecObject,
    ) callconv(.C) Val, .{ .library_name = "v", .name = "9" });
    pub const vec_insert = @extern(*const fn (
        v: VecObject,
        i: U32Val,
        x: Val,
    ) callconv(.C) VecObject, .{ .library_name = "v", .name = "a" });
    pub const vec_append = @extern(*const fn (
        v1: VecObject,
        v2: VecObject,
    ) callconv(.C) VecObject, .{ .library_name = "v", .name = "b" });
    pub const vec_slice = @extern(*const fn (
        v: VecObject,
        start: U32Val,
        end: U32Val,
    ) callconv(.C) VecObject, .{ .library_name = "v", .name = "c" });
    pub const vec_first_index_of = @extern(*const fn (
        v: VecObject,
        x: Val,
    ) callconv(.C) Val, .{ .library_name = "v", .name = "d" });
    pub const vec_last_index_of = @extern(*const fn (
        v: VecObject,
        x: Val,
    ) callconv(.C) Val, .{ .library_name = "v", .name = "e" });
    pub const vec_binary_search = @extern(*const fn (
        v: VecObject,
        x: Val,
    ) callconv(.C) u64, .{ .library_name = "v", .name = "f" });
    pub const vec_new_from_linear_memory = @extern(*const fn (
        vals_pos: U32Val,
        len: U32Val,
    ) callconv(.C) VecObject, .{ .library_name = "v", .name = "g" });
    pub const vec_unpack_to_linear_memory = @extern(*const fn (
        vec: VecObject,
        vals_pos: U32Val,
        len: U32Val,
    ) callconv(.C) Void, .{ .library_name = "v", .name = "h" });
};
pub const ledger = struct {
    pub const put_contract_data = @extern(*const fn (
        k: Val,
        v: Val,
        t: StorageType,
    ) callconv(.C) Void, .{ .library_name = "l", .name = "_" });
    pub const has_contract_data = @extern(*const fn (
        k: Val,
        t: StorageType,
    ) callconv(.C) Bool, .{ .library_name = "l", .name = "0" });
    pub const get_contract_data = @extern(*const fn (
        k: Val,
        t: StorageType,
    ) callconv(.C) Val, .{ .library_name = "l", .name = "1" });
    pub const del_contract_data = @extern(*const fn (
        k: Val,
        t: StorageType,
    ) callconv(.C) Void, .{ .library_name = "l", .name = "2" });
    pub const create_contract = @extern(*const fn (
        deployer: AddressObject,
        wasm_hash: BytesObject,
        salt: BytesObject,
    ) callconv(.C) AddressObject, .{ .library_name = "l", .name = "3" });
    pub const create_asset_contract = @extern(*const fn (
        serialized_asset: BytesObject,
    ) callconv(.C) AddressObject, .{ .library_name = "l", .name = "4" });
    pub const upload_wasm = @extern(*const fn (
        wasm: BytesObject,
    ) callconv(.C) BytesObject, .{ .library_name = "l", .name = "5" });
    pub const update_current_contract_wasm = @extern(*const fn (
        hash: BytesObject,
    ) callconv(.C) Void, .{ .library_name = "l", .name = "6" });
    pub const extend_contract_data_ttl = @extern(*const fn (
        k: Val,
        t: StorageType,
        threshold: U32Val,
        extend_to: U32Val,
    ) callconv(.C) Void, .{ .library_name = "l", .name = "7" });
    pub const extend_current_contract_instance_and_code_ttl = @extern(*const fn (
        threshold: U32Val,
        extend_to: U32Val,
    ) callconv(.C) Void, .{ .library_name = "l", .name = "8" });
    pub const extend_contract_instance_and_code_ttl = @extern(*const fn (
        contract: AddressObject,
        threshold: U32Val,
        extend_to: U32Val,
    ) callconv(.C) Void, .{ .library_name = "l", .name = "9" });
    pub const get_contract_id = @extern(*const fn (
        deployer: AddressObject,
        salt: BytesObject,
    ) callconv(.C) AddressObject, .{ .library_name = "l", .name = "a" });
    pub const get_asset_contract_id = @extern(*const fn (
        serialized_asset: BytesObject,
    ) callconv(.C) AddressObject, .{ .library_name = "l", .name = "b" });
    pub const extend_contract_instance_ttl = @extern(*const fn (
        contract: AddressObject,
        threshold: U32Val,
        extend_to: U32Val,
    ) callconv(.C) Void, .{ .library_name = "l", .name = "c" });
    pub const extend_contract_code_ttl = @extern(*const fn (
        contract: AddressObject,
        threshold: U32Val,
        extend_to: U32Val,
    ) callconv(.C) Void, .{ .library_name = "l", .name = "d" });
};
pub const call = struct {
    pub const call = @extern(*const fn (
        contract: AddressObject,
        func: Symbol,
        args: VecObject,
    ) callconv(.C) Val, .{ .library_name = "d", .name = "_" });
    pub const try_call = @extern(*const fn (
        contract: AddressObject,
        func: Symbol,
        args: VecObject,
    ) callconv(.C) Val, .{ .library_name = "d", .name = "0" });
};
pub const buf = struct {
    pub const serialize_to_bytes = @extern(*const fn (
        v: Val,
    ) callconv(.C) BytesObject, .{ .library_name = "b", .name = "_" });
    pub const deserialize_from_bytes = @extern(*const fn (
        b: BytesObject,
    ) callconv(.C) Val, .{ .library_name = "b", .name = "0" });
    pub const bytes_copy_to_linear_memory = @extern(*const fn (
        b: BytesObject,
        b_pos: U32Val,
        lm_pos: U32Val,
        len: U32Val,
    ) callconv(.C) Void, .{ .library_name = "b", .name = "1" });
    pub const bytes_copy_from_linear_memory = @extern(*const fn (
        b: BytesObject,
        b_pos: U32Val,
        lm_pos: U32Val,
        len: U32Val,
    ) callconv(.C) BytesObject, .{ .library_name = "b", .name = "2" });
    pub const bytes_new_from_linear_memory = @extern(*const fn (
        lm_pos: U32Val,
        len: U32Val,
    ) callconv(.C) BytesObject, .{ .library_name = "b", .name = "3" });
    pub const bytes_new = @extern(*const fn () callconv(.C) BytesObject, .{ .library_name = "b", .name = "4" });
    pub const bytes_put = @extern(*const fn (
        b: BytesObject,
        i: U32Val,
        u: U32Val,
    ) callconv(.C) BytesObject, .{ .library_name = "b", .name = "5" });
    pub const bytes_get = @extern(*const fn (
        b: BytesObject,
        i: U32Val,
    ) callconv(.C) U32Val, .{ .library_name = "b", .name = "6" });
    pub const bytes_del = @extern(*const fn (
        b: BytesObject,
        i: U32Val,
    ) callconv(.C) BytesObject, .{ .library_name = "b", .name = "7" });
    pub const bytes_len = @extern(*const fn (
        b: BytesObject,
    ) callconv(.C) U32Val, .{ .library_name = "b", .name = "8" });
    pub const bytes_push = @extern(*const fn (
        b: BytesObject,
        u: U32Val,
    ) callconv(.C) BytesObject, .{ .library_name = "b", .name = "9" });
    pub const bytes_pop = @extern(*const fn (
        b: BytesObject,
    ) callconv(.C) BytesObject, .{ .library_name = "b", .name = "a" });
    pub const bytes_front = @extern(*const fn (
        b: BytesObject,
    ) callconv(.C) U32Val, .{ .library_name = "b", .name = "b" });
    pub const bytes_back = @extern(*const fn (
        b: BytesObject,
    ) callconv(.C) U32Val, .{ .library_name = "b", .name = "c" });
    pub const bytes_insert = @extern(*const fn (
        b: BytesObject,
        i: U32Val,
        u: U32Val,
    ) callconv(.C) BytesObject, .{ .library_name = "b", .name = "d" });
    pub const bytes_append = @extern(*const fn (
        b1: BytesObject,
        b2: BytesObject,
    ) callconv(.C) BytesObject, .{ .library_name = "b", .name = "e" });
    pub const bytes_slice = @extern(*const fn (
        b: BytesObject,
        start: U32Val,
        end: U32Val,
    ) callconv(.C) BytesObject, .{ .library_name = "b", .name = "f" });
    pub const string_copy_to_linear_memory = @extern(*const fn (
        s: StringObject,
        s_pos: U32Val,
        lm_pos: U32Val,
        len: U32Val,
    ) callconv(.C) Void, .{ .library_name = "b", .name = "g" });
    pub const symbol_copy_to_linear_memory = @extern(*const fn (
        s: SymbolObject,
        s_pos: U32Val,
        lm_pos: U32Val,
        len: U32Val,
    ) callconv(.C) Void, .{ .library_name = "b", .name = "h" });
    pub const string_new_from_linear_memory = @extern(*const fn (
        lm_pos: U32Val,
        len: U32Val,
    ) callconv(.C) StringObject, .{ .library_name = "b", .name = "i" });
    pub const symbol_new_from_linear_memory = @extern(*const fn (
        lm_pos: U32Val,
        len: U32Val,
    ) callconv(.C) SymbolObject, .{ .library_name = "b", .name = "j" });
    pub const string_len = @extern(*const fn (
        s: StringObject,
    ) callconv(.C) U32Val, .{ .library_name = "b", .name = "k" });
    pub const symbol_len = @extern(*const fn (
        s: SymbolObject,
    ) callconv(.C) U32Val, .{ .library_name = "b", .name = "l" });
    pub const symbol_index_in_linear_memory = @extern(*const fn (
        sym: Symbol,
        slices_pos: U32Val,
        len: U32Val,
    ) callconv(.C) U32Val, .{ .library_name = "b", .name = "m" });
};
pub const crypto = struct {
    pub const compute_hash_sha256 = @extern(*const fn (
        x: BytesObject,
    ) callconv(.C) BytesObject, .{ .library_name = "c", .name = "_" });
    pub const verify_sig_ed25519 = @extern(*const fn (
        k: BytesObject,
        x: BytesObject,
        s: BytesObject,
    ) callconv(.C) Void, .{ .library_name = "c", .name = "0" });
    pub const compute_hash_keccak256 = @extern(*const fn (
        x: BytesObject,
    ) callconv(.C) BytesObject, .{ .library_name = "c", .name = "1" });
    pub const recover_key_ecdsa_secp256k1 = @extern(*const fn (
        msg_digest: BytesObject,
        signature: BytesObject,
        recovery_id: U32Val,
    ) callconv(.C) BytesObject, .{ .library_name = "c", .name = "2" });
    pub const verify_sig_ecdsa_secp256r1 = @extern(*const fn (
        public_key: BytesObject,
        msg_digest: BytesObject,
        signature: BytesObject,
    ) callconv(.C) Void, .{ .library_name = "c", .name = "3" });
};
pub const address = struct {
    pub const require_auth_for_args = @extern(*const fn (
        address: AddressObject,
        args: VecObject,
    ) callconv(.C) Void, .{ .library_name = "a", .name = "_" });
    pub const require_auth = @extern(*const fn (
        address: AddressObject,
    ) callconv(.C) Void, .{ .library_name = "a", .name = "0" });
    pub const strkey_to_address = @extern(*const fn (
        strkey: Val,
    ) callconv(.C) AddressObject, .{ .library_name = "a", .name = "1" });
    pub const address_to_strkey = @extern(*const fn (
        address: AddressObject,
    ) callconv(.C) StringObject, .{ .library_name = "a", .name = "2" });
    pub const authorize_as_curr_contract = @extern(*const fn (
        auth_entires: VecObject,
    ) callconv(.C) Void, .{ .library_name = "a", .name = "3" });
};
pub const @"test" = struct {
    pub const dummy0 = @extern(*const fn () callconv(.C) Val, .{ .library_name = "t", .name = "_" });
    pub const protocol_gated_dummy = @extern(*const fn () callconv(.C) Val, .{ .library_name = "t", .name = "0" });
};
pub const prng = struct {
    pub const prng_reseed = @extern(*const fn (
        seed: BytesObject,
    ) callconv(.C) Void, .{ .library_name = "p", .name = "_" });
    pub const prng_bytes_new = @extern(*const fn (
        length: U32Val,
    ) callconv(.C) BytesObject, .{ .library_name = "p", .name = "0" });
    pub const prng_u64_in_inclusive_range = @extern(*const fn (
        lo: u64,
        hi: u64,
    ) callconv(.C) u64, .{ .library_name = "p", .name = "1" });
    pub const prng_vec_shuffle = @extern(*const fn (
        vec: VecObject,
    ) callconv(.C) VecObject, .{ .library_name = "p", .name = "2" });
};
