pub const Val = packed struct {
    const Self = @This();

    isTagged: bool,
    body: packed union {
        u63: u63,
        tagged: packed union {
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
                static: enum(u60) {
                    void = 0,
                    true = 1,
                    false = 2,
                },
            },
        },
    },

    pub fn is_true(self: Self) bool {
        return self.isTagged and self.body.tagged.tags == .static and self.body.tagged.body.static == .true;
    }
};

comptime {
    if (@bitSizeOf(Val) != 64) {
        @compileError("Val is not 64-bits");
    }
}
