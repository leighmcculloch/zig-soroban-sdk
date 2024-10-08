const std = @import("std");

const Val = @import("soroban-sdk").Val;

export fn add(x: Val, y: Val) Val {
    return Val.fromU32(_add(
        x.toU32(),
        y.toU32(),
    ));
}

fn _add(x: u32, y: u32) u32 {
    return std.math.add(u32, x, y) catch @trap();
}

export fn sub(x: Val, y: Val) Val {
    return Val.fromU32(_sub(
        x.toU32(),
        y.toU32(),
    ));
}

fn _sub(x: u32, y: u32) u32 {
    return std.math.sub(u32, x, y) catch @trap();
}
