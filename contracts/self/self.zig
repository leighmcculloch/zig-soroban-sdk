const Val = @import("val.zig").Val;

export fn id() Val {
    return context_get_current_contract_address();
}

const context_get_current_contract_address = @extern(*const fn () callconv(.C) Val, .{
    .library_name = "x",
    .name = "7",
});
