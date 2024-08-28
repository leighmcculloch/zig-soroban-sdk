const Val = @import("val.zig").Val;

export fn id() u64 {
    return context_get_current_contract_address();
}

const context_get_current_contract_address = @extern(*const fn () callconv(.C) u64, .{
    .library_name = "x",
    .name = "7",
});
