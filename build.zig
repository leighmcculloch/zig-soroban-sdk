const std = @import("std");
const CrossTarget = std.zig.CrossTarget;
const Mode = std.builtin.Mode;

pub fn build(b: *std.build.Builder) !void {
    const lib = b.addSharedLibrary("adder", "src/lib.zig", .unversioned);
    lib.rdynamic = true; // Pickup exported functions automatically.
    lib.setTarget(.{ .cpu_arch = .wasm32, .os_tag = .freestanding });
    lib.setBuildMode(Mode.ReleaseSmall);
    lib.install();
}
