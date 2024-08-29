// const Val = @import("val.zig").Val;
const sdk = @import("soroban-sdk");

export fn id() sdk.Val {
    return sdk.env.context.get_current_contract_address();
}
