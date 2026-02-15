// Soroban Ledger and Storage API.
//
// Thin wrappers around the ledger and context host functions for
// contract data storage and ledger info queries.

const val = @import("val.zig");
const env = @import("env.zig");

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

/// Return the network id (sha256 hash of network passphrase) as BytesObject.
pub fn getLedgerNetworkId() val.BytesObject {
    return env.context.get_ledger_network_id();
}

/// Get the Address object for the current contract.
pub fn getCurrentContractAddress() val.AddressObject {
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
pub fn createContract(deployer: val.AddressObject, wasm_hash: val.BytesObject, salt: val.BytesObject) val.AddressObject {
    return env.ledger.create_contract(deployer, wasm_hash, salt);
}

/// Deploy a new contract with constructor arguments.
pub fn createContractWithConstructor(deployer: val.AddressObject, wasm_hash: val.BytesObject, salt: val.BytesObject, constructor_args: val.VecObject) val.AddressObject {
    return env.ledger.create_contract_with_constructor(deployer, wasm_hash, salt, constructor_args);
}

/// Deploy a Stellar Asset Contract.
pub fn createAssetContract(serialized_asset: val.BytesObject) val.AddressObject {
    return env.ledger.create_asset_contract(serialized_asset);
}

/// Upload contract Wasm code, returning its hash.
pub fn uploadWasm(wasm: val.BytesObject) val.BytesObject {
    return env.ledger.upload_wasm(wasm);
}

/// Update the current contract's Wasm code.
pub fn updateCurrentContractWasm(hash: val.BytesObject) void {
    _ = env.ledger.update_current_contract_wasm(hash);
}

/// Get the contract address for a deployer and salt.
pub fn getContractId(deployer: val.AddressObject, salt: val.BytesObject) val.AddressObject {
    return env.ledger.get_contract_id(deployer, salt);
}

/// Get the Stellar Asset Contract address for a serialized asset.
pub fn getAssetContractId(serialized_asset: val.BytesObject) val.AddressObject {
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
