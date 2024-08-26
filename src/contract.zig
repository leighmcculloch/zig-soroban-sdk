const val = @import("val.zig");
const Val = val.Val;

const MyType = extern struct {
    address: Val,
    balance: i128,
};

export fn add(ia: Val, ib: Val, ic: Val) Val {
    const a = ia.toBool();
    const b = ib.toU32();
    const c = ic.toU32();
    if (a) {
        return Val.fromU32(b + c);
    } else {
        return Val.fromU32(0);
    }
}
