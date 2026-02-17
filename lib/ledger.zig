// Soroban Ledger and Storage API.
//
// Thin wrappers around the ledger and context host functions for
// contract data storage and ledger info queries.

const val = @import("val.zig");
const env = @import("env.zig");
const int = @import("int.zig");

pub const StorageType = val.StorageType;

// -----------------------------------------------------------------------
// Storage operations
// -----------------------------------------------------------------------

/// Store a value under a key in contract storage.
pub fn putContractData(key: val.Val, value: val.Val, storage_type: StorageType) void {
    _ = env.ledger.put_contract_data(key, value, storage_type);
}

/// Check whether a key exists in contract storage.
pub fn hasContractData(key: val.Val, storage_type: StorageType) bool {
    return env.ledger.has_contract_data(key, storage_type).toBool();
}

/// Get a value by key from contract storage.
pub fn getContractData(key: val.Val, storage_type: StorageType) val.Val {
    return env.ledger.get_contract_data(key, storage_type);
}

/// Delete a key from contract storage.
pub fn delContractData(key: val.Val, storage_type: StorageType) void {
    _ = env.ledger.del_contract_data(key, storage_type);
}

// -----------------------------------------------------------------------
// Typed storage helpers
// -----------------------------------------------------------------------

/// Get a Val by key, returning null if the key doesn't exist.
pub fn getVal(key: anytype, storage_type: StorageType) ?val.Val {
    const k = val.asVal(key);
    if (!hasContractData(k, storage_type)) return null;
    return getContractData(k, storage_type);
}

/// Get a u32 by key, returning null if the key doesn't exist.
pub fn getU32(key: anytype, storage_type: StorageType) ?u32 {
    const v = getVal(key, storage_type) orelse return null;
    return val.U32Val.fromVal(v).toU32();
}

/// Store a u32 under a key.
pub fn putU32(key: anytype, v: u32, storage_type: StorageType) void {
    putContractData(val.asVal(key), val.U32Val.fromU32(v).toVal(), storage_type);
}

/// Get an i128 by key, returning null if the key doesn't exist.
pub fn getI128(key: anytype, storage_type: StorageType) ?i128 {
    const v = getVal(key, storage_type) orelse return null;
    return int.i128FromVal(val.I128Val.fromVal(v));
}

/// Store an i128 under a key.
pub fn putI128(key: anytype, v: i128, storage_type: StorageType) void {
    putContractData(val.asVal(key), int.i128ToVal(v).toVal(), storage_type);
}

/// Extend the TTL of a contract data entry.
pub fn extendContractDataTtl(key: val.Val, storage_type: StorageType, threshold: u32, extend_to: u32) void {
    _ = env.ledger.extend_contract_data_ttl(key, storage_type, val.U32Val.fromU32(threshold), val.U32Val.fromU32(extend_to));
}

/// Extend the TTL of the current contract's instance and code.
pub fn extendCurrentContractInstanceAndCodeTtl(threshold: u32, extend_to: u32) void {
    _ = env.ledger.extend_current_contract_instance_and_code_ttl(val.U32Val.fromU32(threshold), val.U32Val.fromU32(extend_to));
}

// -----------------------------------------------------------------------
// Ledger info queries
// -----------------------------------------------------------------------

/// Return the protocol version of the current ledger.
pub fn getLedgerVersion() u32 {
    return env.context.get_ledger_version().toU32();
}

/// Return the sequence number of the current ledger.
pub fn getLedgerSequence() u32 {
    return env.context.get_ledger_sequence().toU32();
}

/// Return the timestamp of the current ledger as a U64Val.
pub fn getLedgerTimestamp() val.U64Val {
    return env.context.get_ledger_timestamp();
}

/// Return the network id (sha256 hash of network passphrase) as Bytes.
pub fn getLedgerNetworkId() val.Bytes {
    return env.context.get_ledger_network_id();
}

/// Get the Address object for the current contract.
pub fn getCurrentContractAddress() val.Address {
    return env.context.get_current_contract_address();
}

/// Returns the max ledger sequence that an entry can live to (inclusive).
pub fn getMaxLiveUntilLedger() u32 {
    return env.context.get_max_live_until_ledger().toU32();
}

// -----------------------------------------------------------------------
// Contract deployment
// -----------------------------------------------------------------------

/// Deploy a new contract.
pub fn createContract(deployer: val.Address, wasm_hash: val.Bytes, salt: val.Bytes) val.Address {
    return env.ledger.create_contract(deployer, wasm_hash, salt);
}

/// Deploy a new contract with constructor arguments.
pub fn createContractWithConstructor(deployer: val.Address, wasm_hash: val.Bytes, salt: val.Bytes, constructor_args: val.Vec) val.Address {
    return env.ledger.create_contract_with_constructor(deployer, wasm_hash, salt, constructor_args);
}

/// Deploy a Stellar Asset Contract.
pub fn createAssetContract(serialized_asset: val.Bytes) val.Address {
    return env.ledger.create_asset_contract(serialized_asset);
}

/// Upload contract Wasm code, returning its hash.
pub fn uploadWasm(wasm: val.Bytes) val.Bytes {
    return env.ledger.upload_wasm(wasm);
}

/// Update the current contract's Wasm code.
pub fn updateCurrentContractWasm(hash: val.Bytes) void {
    _ = env.ledger.update_current_contract_wasm(hash);
}

/// Get the contract address for a deployer and salt.
pub fn getContractId(deployer: val.Address, salt: val.Bytes) val.Address {
    return env.ledger.get_contract_id(deployer, salt);
}

/// Get the Stellar Asset Contract address for a serialized asset.
pub fn getAssetContractId(serialized_asset: val.Bytes) val.Address {
    return env.ledger.get_asset_contract_id(serialized_asset);
}

// -----------------------------------------------------------------------
// Context utilities
// -----------------------------------------------------------------------

/// Cause the contract to fail immediately with an error code.
pub fn failWithError(err: val.Error) noreturn {
    _ = env.context.fail_with_error(err);
    unreachable;
}

/// Cause the contract to fail immediately with a contract error code.
pub fn failContract(code: u32) noreturn {
    failWithError(val.Error.contractError(code));
}
