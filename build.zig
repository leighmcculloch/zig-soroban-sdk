const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .wasm32,
        .os_tag = .freestanding,
    });
    const optimize = b.standardOptimizeOption(.{});

    // SDK module
    const sdk_module = b.addModule("soroban-sdk", .{
        .root_source_file = b.path("lib/sdk.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Example contracts
    const examples = [_][]const u8{
        "hello",
        "increment",
    };

    const examples_step = b.step("examples", "Build example contracts");

    for (examples) |example_name| {
        const example_path = b.fmt("examples/{s}/contract.zig", .{example_name});
        const example_module = b.createModule(.{
            .root_source_file = b.path(example_path),
            .target = target,
            .optimize = .ReleaseSmall,
        });
        example_module.addImport("soroban-sdk", sdk_module);
        const example = b.addExecutable(.{
            .name = example_name,
            .root_module = example_module,
        });
        example.entry = .disabled;
        example.rdynamic = true;

        const install = b.addInstallArtifact(example, .{
            .dest_dir = .{ .override = .{ .custom = "contracts" } },
        });
        examples_step.dependOn(&install.step);
    }

    // Tests
    const test_step = b.step("test", "Run SDK tests");
    const sdk_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("lib/sdk.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });
    const run_tests = b.addRunArtifact(sdk_tests);
    test_step.dependOn(&run_tests.step);
}
