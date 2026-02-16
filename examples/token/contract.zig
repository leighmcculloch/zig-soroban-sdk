// SEP-41 Token Soroban Contract
//
// A basic fungible token implementing the SEP-41 token interface with
// 10 standard functions plus initialize and mint admin functions.
//
// Build: zig build examples
// Usage:
//   stellar contract deploy --wasm zig-out/contracts/token.wasm --alias tok --source me --network local \
//     -- --admin me --decimal 7 --name '"My Token"' --symbol '"MTK"'
//   stellar contract invoke --id tok --source me --network local -- mint --to me --amount 1000000000
//   stellar contract invoke --id tok --source me --network local -- balance --id me

const sdk = @import("soroban-sdk");

// ---------------------------------------------------------------------------
// Contract
// ---------------------------------------------------------------------------

const TokenContract = struct {

    // -- Admin functions --

    pub const @"__constructor_params" = [_][]const u8{ "admin", "decimal", "name", "symbol" };
    pub fn @"__constructor"(admin: sdk.AddressObject, decimal: sdk.U32Val, token_name: sdk.StringObject, token_symbol: sdk.StringObject) sdk.Void {
        sdk.ledger.putContractData(ADMIN_KEY.toVal(), admin.toVal(), sdk.StorageType.instance);
        sdk.ledger.putContractData(DEC_KEY.toVal(), decimal.toVal(), sdk.StorageType.instance);
        sdk.ledger.putContractData(NAME_KEY.toVal(), token_name.toVal(), sdk.StorageType.instance);
        sdk.ledger.putContractData(SYM_KEY.toVal(), token_symbol.toVal(), sdk.StorageType.instance);
        return sdk.Void.VOID;
    }

    pub const mint_params = [_][]const u8{ "to", "amount" };
    pub fn mint(to: sdk.AddressObject, amount: sdk.I128Val) sdk.Void {
        const admin = getAdmin();
        sdk.Address.fromObject(admin).requireAuth();

        const amt = sdk.int.i128FromVal(amount);
        requirePositive(amt);

        const bal = readBalance(to);
        writeBalance(to, bal + amt);
        sdk.token.emitMint(to, amount);
        return sdk.Void.VOID;
    }

    // -- SEP-41 token interface --

    pub const allowance_params = [_][]const u8{ "from", "spender" };
    pub fn allowance(from: sdk.AddressObject, spender: sdk.AddressObject) sdk.I128Val {
        const data = readAllowance(from, spender);
        return sdk.int.i128ToVal(data.amount);
    }

    pub const approve_params = [_][]const u8{ "from", "spender", "amount", "expiration_ledger" };
    pub fn approve(from: sdk.AddressObject, spender: sdk.AddressObject, amount: sdk.I128Val, exp_ledger: sdk.U32Val) sdk.Void {
        sdk.Address.fromObject(from).requireAuth();

        const amt = sdk.int.i128FromVal(amount);
        if (amt < 0) {
            sdk.ledger.failWithError(sdk.Error.fromParts(4, 2));
        }

        writeAllowance(from, spender, amt, exp_ledger.toU32());
        sdk.token.emitApprove(from, spender, amount, exp_ledger);
        return sdk.Void.VOID;
    }

    pub const balance_params = [_][]const u8{"id"};
    pub fn balance(id: sdk.AddressObject) sdk.I128Val {
        return sdk.int.i128ToVal(readBalance(id));
    }

    pub const transfer_params = [_][]const u8{ "from", "to", "amount" };
    pub fn transfer(from: sdk.AddressObject, to: sdk.AddressObject, amount: sdk.I128Val) sdk.Void {
        sdk.Address.fromObject(from).requireAuth();

        const amt = sdk.int.i128FromVal(amount);
        requirePositive(amt);

        const from_bal = readBalance(from);
        if (from_bal < amt) {
            sdk.ledger.failWithError(sdk.Error.fromParts(4, 4));
        }
        writeBalance(from, from_bal - amt);

        const to_bal = readBalance(to);
        writeBalance(to, to_bal + amt);

        sdk.token.emitTransfer(from, to, amount);
        return sdk.Void.VOID;
    }

    pub const transfer_from_params = [_][]const u8{ "spender", "from", "to", "amount" };
    pub fn transfer_from(spender: sdk.AddressObject, from: sdk.AddressObject, to: sdk.AddressObject, amount: sdk.I128Val) sdk.Void {
        sdk.Address.fromObject(spender).requireAuth();

        const amt = sdk.int.i128FromVal(amount);
        requirePositive(amt);

        spendAllowance(from, spender, amt);

        const from_bal = readBalance(from);
        if (from_bal < amt) {
            sdk.ledger.failWithError(sdk.Error.fromParts(4, 4));
        }
        writeBalance(from, from_bal - amt);

        const to_bal = readBalance(to);
        writeBalance(to, to_bal + amt);

        sdk.token.emitTransfer(from, to, amount);
        return sdk.Void.VOID;
    }

    pub const burn_params = [_][]const u8{ "from", "amount" };
    pub fn burn(from: sdk.AddressObject, amount: sdk.I128Val) sdk.Void {
        sdk.Address.fromObject(from).requireAuth();

        const amt = sdk.int.i128FromVal(amount);
        requirePositive(amt);

        const bal = readBalance(from);
        if (bal < amt) {
            sdk.ledger.failWithError(sdk.Error.fromParts(4, 4));
        }
        writeBalance(from, bal - amt);

        sdk.token.emitBurn(from, amount);
        return sdk.Void.VOID;
    }

    pub const burn_from_params = [_][]const u8{ "spender", "from", "amount" };
    pub fn burn_from(spender: sdk.AddressObject, from: sdk.AddressObject, amount: sdk.I128Val) sdk.Void {
        sdk.Address.fromObject(spender).requireAuth();

        const amt = sdk.int.i128FromVal(amount);
        requirePositive(amt);

        spendAllowance(from, spender, amt);

        const from_bal = readBalance(from);
        if (from_bal < amt) {
            sdk.ledger.failWithError(sdk.Error.fromParts(4, 4));
        }
        writeBalance(from, from_bal - amt);

        sdk.token.emitBurn(from, amount);
        return sdk.Void.VOID;
    }

    // -- Metadata --

    pub fn decimals() sdk.U32Val {
        return sdk.U32Val.fromVal(sdk.ledger.getContractData(DEC_KEY.toVal(), sdk.StorageType.instance));
    }

    pub fn name() sdk.StringObject {
        return sdk.StringObject.fromVal(sdk.ledger.getContractData(NAME_KEY.toVal(), sdk.StorageType.instance));
    }

    pub fn symbol() sdk.StringObject {
        return sdk.StringObject.fromVal(sdk.ledger.getContractData(SYM_KEY.toVal(), sdk.StorageType.instance));
    }
};

comptime {
    _ = sdk.contract.exportContract(TokenContract);
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

fn getAdmin() sdk.AddressObject {
    return sdk.AddressObject.fromVal(sdk.ledger.getContractData(ADMIN_KEY.toVal(), sdk.StorageType.instance));
}

fn requirePositive(amount: i128) void {
    if (amount <= 0) {
        sdk.ledger.failWithError(sdk.Error.fromParts(4, 2));
    }
}

// -- Balance storage --

fn readBalance(addr: sdk.AddressObject) i128 {
    const key = makeBalanceKey(addr);
    if (sdk.ledger.hasContractData(key, sdk.StorageType.persistent)) {
        return sdk.int.i128FromVal(sdk.I128Val.fromVal(sdk.ledger.getContractData(key, sdk.StorageType.persistent)));
    }
    return 0;
}

fn writeBalance(addr: sdk.AddressObject, amount: i128) void {
    const key = makeBalanceKey(addr);
    sdk.ledger.putContractData(key, sdk.int.i128ToVal(amount).toVal(), sdk.StorageType.persistent);
}

fn makeBalanceKey(addr: sdk.AddressObject) sdk.Val {
    var v = sdk.vec.Vec.new();
    v.pushBack(BAL_TAG.toVal());
    v.pushBack(addr.toVal());
    return v.toObject().toVal();
}

// -- Allowance storage --

fn readAllowance(from: sdk.AddressObject, spender: sdk.AddressObject) struct { amount: i128, expiration_ledger: u32 } {
    const key = makeAllowanceKey(from, spender);
    if (sdk.ledger.hasContractData(key, sdk.StorageType.temporary)) {
        const data = sdk.vec.Vec.fromObject(sdk.VecObject.fromVal(sdk.ledger.getContractData(key, sdk.StorageType.temporary)));
        const amount = sdk.int.i128FromVal(sdk.I128Val.fromVal(data.get(0)));
        const exp_ledger = sdk.U32Val.fromVal(data.get(1)).toU32();
        if (exp_ledger < sdk.ledger.getLedgerSequence()) {
            return .{ .amount = 0, .expiration_ledger = exp_ledger };
        }
        return .{ .amount = amount, .expiration_ledger = exp_ledger };
    }
    return .{ .amount = 0, .expiration_ledger = 0 };
}

fn writeAllowance(from: sdk.AddressObject, spender: sdk.AddressObject, amount: i128, expiration_ledger: u32) void {
    const key = makeAllowanceKey(from, spender);
    if (amount > 0 and expiration_ledger >= sdk.ledger.getLedgerSequence()) {
        var data = sdk.vec.Vec.new();
        data.pushBack(sdk.int.i128ToVal(amount).toVal());
        data.pushBack(sdk.U32Val.fromU32(expiration_ledger).toVal());
        sdk.ledger.putContractData(key, data.toObject().toVal(), sdk.StorageType.temporary);
        sdk.ledger.extendContractDataTtl(key, sdk.StorageType.temporary, expiration_ledger - sdk.ledger.getLedgerSequence(), expiration_ledger - sdk.ledger.getLedgerSequence());
    } else if (sdk.ledger.hasContractData(key, sdk.StorageType.temporary)) {
        sdk.ledger.delContractData(key, sdk.StorageType.temporary);
    }
}

fn spendAllowance(from: sdk.AddressObject, spender: sdk.AddressObject, amount: i128) void {
    const allowance_data = readAllowance(from, spender);
    if (allowance_data.amount < amount) {
        sdk.ledger.failWithError(sdk.Error.fromParts(4, 1));
    }
    writeAllowance(from, spender, allowance_data.amount - amount, allowance_data.expiration_ledger);
}

fn makeAllowanceKey(from: sdk.AddressObject, spender: sdk.AddressObject) sdk.Val {
    var v = sdk.vec.Vec.new();
    v.pushBack(ALLOW_TAG.toVal());
    v.pushBack(from.toVal());
    v.pushBack(spender.toVal());
    return v.toObject().toVal();
}

// ---------------------------------------------------------------------------
// Storage keys
// ---------------------------------------------------------------------------

const ADMIN_KEY = sdk.Symbol.fromString("ADMIN");
const DEC_KEY = sdk.Symbol.fromString("DEC");
const NAME_KEY = sdk.Symbol.fromString("NAME");
const SYM_KEY = sdk.Symbol.fromString("SYM");
const BAL_TAG = sdk.Symbol.fromString("BAL");
const ALLOW_TAG = sdk.Symbol.fromString("ALLOW");
