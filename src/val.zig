pub const Val = packed struct {
    const Self = @This();

    // 8 bits
    tag: enum(u8) {
        false = 0,
        true = 1,
        u32 = 4,
    },

    // 56 bits
    body: packed union {
        major_minor: packed struct {
            major: u32,
            minor: u24,
        },
    },

    pub fn isBool(self: Self) bool {
        return self.isTrue() || self.isFalse();
    }

    pub fn isTrue(self: Self) bool {
        return self.tag == .true;
    }

    pub fn isFalse(self: Self) bool {
        return self.tag == .false;
    }

    pub fn toBool(self: Self) bool {
        return self.isTrue();
    }

    pub fn isU32(self: Self) bool {
        return self.tag == .u32;
    }

    pub fn toU32(self: Self) u32 {
        return self.body.major_minor.major;
    }

    pub fn fromU32(v: u32) Val {
        return Val{ .tag = .u32, .body = .{ .major_minor = .{ .major = v, .minor = 0 } } };
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
