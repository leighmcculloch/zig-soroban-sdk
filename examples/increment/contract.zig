// Increment Soroban Contract
//
// A counter contract that stores a persistent counter value. Each call
// to `increment` increases the counter by 1 and returns the new value.
//
// Build: zig build examples
// Usage: soroban contract invoke --id <id> -- --fn increment

const sdk = @import("soroban-sdk");

const COUNTER_KEY = sdk.Symbol.fromString("COUNTER");

const IncrementContract = struct {
    /// Increment the counter by 1 and return the new value.
    pub fn increment() sdk.U32Val {
        // Read the current count from persistent storage, defaulting to 0.
        const count: u32 = sdk.ledger.getU32(COUNTER_KEY, sdk.StorageType.persistent) orelse 0;

        const new_count = count + 1;

        // Store the new count in persistent storage.
        sdk.ledger.putU32(COUNTER_KEY, new_count, sdk.StorageType.persistent);

        // Extend the TTL of the data entry so it persists.
        sdk.ledger.extendContractDataTtl(
            COUNTER_KEY.toVal(),
            sdk.StorageType.persistent,
            100,
            1000,
        );

        return sdk.U32Val.fromU32(new_count);
    }
};

comptime {
    _ = sdk.contract.exportContract(IncrementContract);
}
