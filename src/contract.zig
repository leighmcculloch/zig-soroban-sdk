const val = @import("val.zig");
const Val = val.Val;

const MyType = extern struct {
    address: Val,
    balance: i128,
};

export fn add(a: Val, b: Val, c: Val) Val {
    if (a.isTrue()) {
        return Val.fromU32(b.toU32() + c.toU32());
    } else if (a.isFalse()) {
        return Val.fromU32(0);
    } else {
        while (true) {}
    }
}
