// Soroban SEP-41 Token Interface.
//
// Provides a TokenClient for cross-contract calls to token contracts,
// and helpers for emitting standard token events.

const val = @import("val.zig");
const env = @import("env.zig");

/// Create a Symbol from a string slice by copying it from linear memory
/// into the host as a SymbolObject. Used for symbol names longer than 9
/// characters that don't fit in the small inline representation.
fn symbolObjectFromSlice(comptime s: []const u8) val.Symbol {
    const obj = env.buf.symbol_new_from_linear_memory(
        val.U32Val.fromU32(@intCast(@intFromPtr(s.ptr))),
        val.U32Val.fromU32(@intCast(s.len)),
    );
    return val.Symbol.fromVal(obj.toVal());
}

// -----------------------------------------------------------------------
// TokenClient - cross-contract calls to a token contract
// -----------------------------------------------------------------------

pub const TokenClient = struct {
    contract: val.AddressObject,

    pub fn init(contract_address: val.AddressObject) TokenClient {
        return .{ .contract = contract_address };
    }

    /// Get the allowance that `spender` can spend from `from`.
    pub fn allowance(self: TokenClient, from: val.AddressObject, spender: val.AddressObject) val.Val {
        var args = env.vec.vec_new();
        args = env.vec.vec_push_back(args, from.toVal());
        args = env.vec.vec_push_back(args, spender.toVal());
        return env.call.call(self.contract, val.Symbol.fromString("allowance"), args);
    }

    /// Approve `spender` to spend `amount` from `from` until `expiration_ledger`.
    pub fn approve(self: TokenClient, from: val.AddressObject, spender: val.AddressObject, amount: val.I128Val, expiration_ledger: val.U32Val) void {
        var args = env.vec.vec_new();
        args = env.vec.vec_push_back(args, from.toVal());
        args = env.vec.vec_push_back(args, spender.toVal());
        args = env.vec.vec_push_back(args, amount.toVal());
        args = env.vec.vec_push_back(args, expiration_ledger.toVal());
        _ = env.call.call(self.contract, val.Symbol.fromString("approve"), args);
    }

    /// Get the token balance of `id`.
    pub fn balance(self: TokenClient, id: val.AddressObject) val.Val {
        var args = env.vec.vec_new();
        args = env.vec.vec_push_back(args, id.toVal());
        return env.call.call(self.contract, val.Symbol.fromString("balance"), args);
    }

    /// Transfer `amount` from `from` to `to`.
    pub fn transfer(self: TokenClient, from: val.AddressObject, to: val.AddressObject, amount: val.I128Val) void {
        var args = env.vec.vec_new();
        args = env.vec.vec_push_back(args, from.toVal());
        args = env.vec.vec_push_back(args, to.toVal());
        args = env.vec.vec_push_back(args, amount.toVal());
        _ = env.call.call(self.contract, val.Symbol.fromString("transfer"), args);
    }

    /// Transfer `amount` from `from` to `to` on behalf of `spender`.
    pub fn transferFrom(self: TokenClient, spender: val.AddressObject, from: val.AddressObject, to: val.AddressObject, amount: val.I128Val) void {
        var args = env.vec.vec_new();
        args = env.vec.vec_push_back(args, spender.toVal());
        args = env.vec.vec_push_back(args, from.toVal());
        args = env.vec.vec_push_back(args, to.toVal());
        args = env.vec.vec_push_back(args, amount.toVal());
        _ = env.call.call(self.contract, symbolObjectFromSlice("transfer_from"), args);
    }

    /// Burn `amount` from `from`.
    pub fn burn(self: TokenClient, from: val.AddressObject, amount: val.I128Val) void {
        var args = env.vec.vec_new();
        args = env.vec.vec_push_back(args, from.toVal());
        args = env.vec.vec_push_back(args, amount.toVal());
        _ = env.call.call(self.contract, val.Symbol.fromString("burn"), args);
    }

    /// Burn `amount` from `from` on behalf of `spender`.
    pub fn burnFrom(self: TokenClient, spender: val.AddressObject, from: val.AddressObject, amount: val.I128Val) void {
        var args = env.vec.vec_new();
        args = env.vec.vec_push_back(args, spender.toVal());
        args = env.vec.vec_push_back(args, from.toVal());
        args = env.vec.vec_push_back(args, amount.toVal());
        _ = env.call.call(self.contract, val.Symbol.fromString("burn_from"), args);
    }

    /// Get the number of decimals.
    pub fn decimals(self: TokenClient) val.Val {
        const args = env.vec.vec_new();
        return env.call.call(self.contract, val.Symbol.fromString("decimals"), args);
    }

    /// Get the token name.
    pub fn name(self: TokenClient) val.Val {
        const args = env.vec.vec_new();
        return env.call.call(self.contract, val.Symbol.fromString("name"), args);
    }

    /// Get the token symbol.
    pub fn symbol(self: TokenClient) val.Val {
        const args = env.vec.vec_new();
        return env.call.call(self.contract, val.Symbol.fromString("symbol"), args);
    }
};

// -----------------------------------------------------------------------
// Token events
// -----------------------------------------------------------------------

/// Emit a transfer event.
pub fn emitTransfer(from: val.AddressObject, to: val.AddressObject, amount: val.I128Val) void {
    var topics = env.vec.vec_new();
    topics = env.vec.vec_push_back(topics, val.Symbol.fromString("transfer").toVal());
    topics = env.vec.vec_push_back(topics, from.toVal());
    topics = env.vec.vec_push_back(topics, to.toVal());
    _ = env.context.contract_event(topics, amount.toVal());
}

/// Emit a mint event per SEP-41: topics are ["mint", to], data is amount.
pub fn emitMint(to: val.AddressObject, amount: val.I128Val) void {
    var topics = env.vec.vec_new();
    topics = env.vec.vec_push_back(topics, val.Symbol.fromString("mint").toVal());
    topics = env.vec.vec_push_back(topics, to.toVal());
    _ = env.context.contract_event(topics, amount.toVal());
}

/// Emit a burn event.
pub fn emitBurn(from: val.AddressObject, amount: val.I128Val) void {
    var topics = env.vec.vec_new();
    topics = env.vec.vec_push_back(topics, val.Symbol.fromString("burn").toVal());
    topics = env.vec.vec_push_back(topics, from.toVal());
    _ = env.context.contract_event(topics, amount.toVal());
}

/// Emit a clawback event per SEP-41: topics are ["clawback", from], data is amount.
pub fn emitClawback(from: val.AddressObject, amount: val.I128Val) void {
    var topics = env.vec.vec_new();
    topics = env.vec.vec_push_back(topics, val.Symbol.fromString("clawback").toVal());
    topics = env.vec.vec_push_back(topics, from.toVal());
    _ = env.context.contract_event(topics, amount.toVal());
}

/// Emit an approve event.
pub fn emitApprove(from: val.AddressObject, spender: val.AddressObject, amount: val.I128Val, expiration_ledger: val.U32Val) void {
    var topics = env.vec.vec_new();
    topics = env.vec.vec_push_back(topics, val.Symbol.fromString("approve").toVal());
    topics = env.vec.vec_push_back(topics, from.toVal());
    topics = env.vec.vec_push_back(topics, spender.toVal());

    // Data is (amount, expiration_ledger) packed in a Vec per SEP-41.
    var data = env.vec.vec_new();
    data = env.vec.vec_push_back(data, amount.toVal());
    data = env.vec.vec_push_back(data, expiration_ledger.toVal());
    _ = env.context.contract_event(topics, data.toVal());
}

/// Emit a set_authorized event: topics are ["set_authorized", id], data is authorize flag.
pub fn emitSetAuthorized(id: val.AddressObject, authorize: val.Bool) void {
    var topics = env.vec.vec_new();
    topics = env.vec.vec_push_back(topics, symbolObjectFromSlice("set_authorized").toVal());
    topics = env.vec.vec_push_back(topics, id.toVal());
    _ = env.context.contract_event(topics, authorize.toVal());
}

/// Emit a set_admin event.
pub fn emitSetAdmin(admin: val.AddressObject, new_admin: val.AddressObject) void {
    var topics = env.vec.vec_new();
    topics = env.vec.vec_push_back(topics, val.Symbol.fromString("set_admin").toVal());
    topics = env.vec.vec_push_back(topics, admin.toVal());
    _ = env.context.contract_event(topics, new_admin.toVal());
}
