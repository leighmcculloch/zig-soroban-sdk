const Val = @import("val.zig").Val;

const MyType = extern struct {
    address: Val,
    balance: i128,
};

export fn add(ia: Val, ib: Val, ic: Val) Val {
    const a = ia.toBool();
    const b = ib.toU32();
    const c = ic.toU32();
    const r = _add(a, b, c);
    return Val.fromU32(r);
}

fn _add(a: bool, b: u32, c: u32) u32 {
    if (a) {
        return b + c;
    } else {
        return 0;
    }
}
