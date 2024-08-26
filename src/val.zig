pub const Val = packed struct {
    const Self = @This();

    isTagged: bool,
    body: packed union {
        u63: u63,
        tagged: packed struct {
            tags: enum(u3) {
                u32 = 0,
                i32 = 1,
                static = 2,
                object = 3,
                symbol = 4,
                bitSet = 5,
                status = 6,
            },
            body: packed union {
                u32: packed struct {
                    value: u32,
                    _: u28,
                },
                static: enum(u60) {
                    void = 0,
                    true = 1,
                    false = 2,
                },
            },
        },
    },

    pub fn isTrue(self: Self) bool {
        return self.isTagged and self.body.tagged.tags == .static and self.body.tagged.body.static == .true;
    }

    pub fn isU63(self: Self) bool {
        return !self.isTagged;
    }

    pub fn toU63(self: Self) u63 {
        return self.body.u63;
    }

    pub fn fromU63(v: u63) Val {
        return Val{ .isTagged = false, .body = v };
    }

    pub fn isU32(self: Self) bool {
        return self.isTagged and self.body.tagged.tags == .u32;
    }

    pub fn toU32(self: Self) u32 {
        return self.body.tagged.body.u32.value;
    }

    pub fn fromU32(v: u32) Val {
        return Val{ .isTagged = true, .body = .{ .tagged = .{ .tags = .u32, .body = .{ .u32 = .{ .value = v, ._ = 0 } } } } };
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
    print("v: {b}", .{v});
}
