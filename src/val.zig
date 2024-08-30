// Val is a 64-bit value that contains the tagged type, or holds a handle to the
// type within the environment.
pub const Val = packed struct {
    const Self = @This();

    // 8 bits
    tag: enum(u8) {
        false = 0,
        true = 1,
        void = 2,
        @"error" = 3,
        u32_val = 4,
        i32_val = 5,
        u64_small = 6,
        i64_small = 7,
        timepoint_small = 8,
        duration_small = 9,
        u128_small = 10,
        i128_small = 11,
        u256_small = 12,
        i256_small = 13,
        symbol_small = 14,
        small_code_upper_bound = 15,
        object_code_lower_bound = 63,
        u64_object = 64,
        i64_object = 65,
        timepoint_object = 66,
        duration_object = 67,
        u128_object = 68,
        i128_object = 69,
        u256_object = 70,
        i256_object = 71,
        bytes_object = 72,
        string_object = 73,
        symbol_object = 74,
        vec_object = 75,
        map_object = 76,
        address_object = 77,
        object_code_upper_bound = 78,
    },

    // 56 bits
    body: packed union {
        _: u56,
        u32_val: u32,
    },

    pub fn toBool(self: Self) bool {
        if (self.tag == .true) {
            return true;
        } else if (self.tag == .false) {
            return false;
        } else {
            @trap();
        }
    }

    pub fn toU32(self: Self) u32 {
        if (self.tag != .u32_val) {
            @trap();
        }
        return self.body.u32_val;
    }

    pub fn fromU32(v: u32) Val {
        return Val{ .tag = .u32_val, .body = .{ .u32_val = v } };
    }
};

comptime {
    if (@bitSizeOf(Val) != 64) {
        @compileError("Val is not 64-bits");
    }
}

test {
    const print = @import("std").debug.print;
    const v: Val = @bitCast(@as(u64, 0));
    print("v: {}\n", .{v});
}
