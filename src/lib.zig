const val = @import("val.zig");
const Val = val.Val;
const Static = val.Static;

export fn add(a: Val, b: Val, c: Val) Val {
    if (a.is_true()) {
        return b;
    } else {
        return c;
    }
}

// export fn clawback(fromIdentifier: u64, amount: u64) void {
// }
// export fn mint(toIdentifier: u64, amount: u64) void {
// }

// /// If "admin" is the administrator, clawback "amount" from "from". "amount" is burned.
// /// Emit event with topics = ["clawback", from: Identifier, to: Identifier], data = [amount: i128]
// fn clawback(
//     env: soroban_sdk::Env,
//     admin: soroban_auth::Signature,
//     nonce: i128,
//     from: soroban_auth::Identifier,
//     amount: i128,
// );

// /// If "admin" is the administrator, mint "amount" to "to".
// /// Emit event with topics = ["mint", admin: Identifier, to: Identifier], data = [amount: i128]
// fn mint(
//     env: soroban_sdk::Env,
//     admin: soroban_auth::Signature,
//     nonce: i128,
//     to: soroban_auth::Identifier,
//     amount: i128,
// );

// /// If "admin" is the administrator, set the administrator to "id".
// /// Emit event with topics = ["set_admin", admin: Identifier], data = [new_admin: Identifier]
// fn set_admin(
//     env: soroban_sdk::Env,
//     admin: soroban_auth::Signature,
//     nonce: i128,
//     new_admin: soroban_auth::Identifier,
// );

// /// If "admin" is the administrator, set the authorize state of "id" to "authorize".
// /// If "authorize" is true, "id" should be able to use its balance.
// /// Emit event with topics = ["set_auth", admin: Identifier, id: Identifier], data = [authorize: bool]
// fn set_auth(
//     env: soroban_sdk::Env,
//     admin: soroban_auth::Signature,
//     nonce: i128,
//     id: soroban_auth::Identifier,
//     authorize: bool,
// );

// // --------------------------------------------------------------------------------
// // Token interface
// // --------------------------------------------------------------------------------

// /// Get the allowance for "spender" to transfer from "from".
// fn allowance(
//     env: soroban_sdk::Env,
//     from: soroban_auth::Identifier,
//     spender: soroban_auth::Identifier,
// ) -> i128;

// /// Increase the allowance by "amount" for "spender" to transfer/burn from "from".
// /// Emit event with topics = ["incr_allow", from: Identifier, spender: Identifier], data = [amount: i128]
// fn incr_allow(
//     env: soroban_sdk::Env,
//     from: soroban_auth::Signature,
//     nonce: i128,
//     spender: soroban_auth::Identifier,
//     amount: i128,
// );

// /// Decrease the allowance by "amount" for "spender" to transfer/burn from "from".
// /// If "amount" is greater than the current allowance, set the allowance to 0.
// /// Emit event with topics = ["decr_allow", from: Identifier, spender: Identifier], data = [amount: i128]
// fn decr_allow(
//     env: soroban_sdk::Env,
//     from: soroban_auth::Signature,
//     nonce: i128,
//     spender: soroban_auth::Identifier,
//     amount: i128,
// );

// /// Get the balance of "id".
// fn balance(env: soroban_sdk::Env, id: soroban_auth::Identifier) -> i128;

// /// Get the spendable balance of "id". This will return the same value as balance()
// /// unless this is called on the Stellar Asset Contract, in which case this can
// /// be less due to reserves/liabilities.
// fn spendable(env: soroban_sdk::Env, id: soroban_auth::Identifier) -> i128;

// /// Transfer "amount" from "from" to "to.
// /// Emit event with topics = ["transfer", from: Identifier, to: Identifier], data = [amount: i128]
// fn xfer(
//     env: soroban_sdk::Env,
//     from: soroban_auth::Signature,
//     nonce: i128,
//     to: soroban_auth::Identifier,
//     amount: i128,
// );

// /// Transfer "amount" from "from" to "to", consuming the allowance of "spender".
// /// Emit event with topics = ["transfer", from: Identifier, to: Identifier], data = [amount: i128]
// fn xfer_from(
//     env: soroban_sdk::Env,
//     spender: soroban_auth::Signature,
//     nonce: i128,
//     from: soroban_auth::Identifier,
//     to: soroban_auth::Identifier,
//     amount: i128,
// );

// /// Burn "amount" from "from".
// /// Emit event with topics = ["burn", from: Identifier], data = [amount: i128]
// fn burn(
//     env: soroban_sdk::Env,
//     from: soroban_auth::Signature,
//     nonce: i128,
//     amount: i128,
// );

// /// Burn "amount" from "from", consuming the allowance of "spender".
// /// Emit event with topics = ["burn", from: Identifier], data = [amount: i128]
// fn burn_from(
//     env: soroban_sdk::Env,
//     spender: soroban_auth::Signature,
//     nonce: i128,
//     from: soroban_auth::Identifier,
//     amount: i128,
// );

// // Returns true if "id" is authorized to use its balance.
// fn authorized(env: soroban_sdk::Env, id: soroban_auth::Identifier) -> bool;

// // Returns the current nonce for "id".
// fn nonce(env: soroban_sdk::Env, id: soroban_auth::Identifier) -> i128;

// // --------------------------------------------------------------------------------
// // Descriptive Interface
// // --------------------------------------------------------------------------------

// // Get the number of decimals used to represent amounts of this token.
// fn decimals(env: soroban_sdk::Env) -> u32;

// // Get the name for this token.
// fn name(env: soroban_sdk::Env) -> soroban_sdk::Bytes;

// // Get the symbol for this token.
// fn symbol(env: soroban_sdk::Env) -> soroban_sdk::Bytes;
