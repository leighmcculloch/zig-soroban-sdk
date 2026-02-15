// Post-processes a wasm binary to convert global exports into proper wasm
// custom sections. Zig's wasm backend emits @export'd data with .section as
// wasm globals + data segments rather than custom sections (section type 0x00).
// Soroban requires the contract metadata to be in actual wasm custom sections.
//
// This tool:
// 1. Parses the wasm binary to find exported globals and their data
// 2. Appends proper wasm custom sections

const std = @import("std");

const SectionMapping = struct {
    export_name: []const u8,
    section_name: []const u8,
};

const section_mappings = [_]SectionMapping{
    .{ .export_name = "_contract_spec", .section_name = "contractspecv0" },
    .{ .export_name = "_contract_env_meta", .section_name = "contractenvmetav0" },
};

pub fn main() !void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 3) {
        std.debug.print("Usage: postprocess_wasm <input.wasm> <output.wasm>\n", .{});
        std.process.exit(1);
    }

    const input_path = args[1];
    const output_path = args[2];

    const wasm = try std.fs.cwd().readFileAlloc(allocator, input_path, 10 * 1024 * 1024);
    defer allocator.free(wasm);

    const result = try processWasm(allocator, wasm);
    defer allocator.free(result);

    const out_file = try std.fs.cwd().createFile(output_path, .{});
    defer out_file.close();
    try out_file.writeAll(result);
}

fn processWasm(allocator: std.mem.Allocator, wasm: []const u8) ![]u8 {
    if (wasm.len < 8) return error.InvalidWasm;
    if (!std.mem.eql(u8, wasm[0..4], "\x00asm")) return error.InvalidWasm;

    // First pass: parse sections to find export, global, and data sections
    var export_section: ?SectionInfo = null;
    var global_section: ?SectionInfo = null;
    var data_section: ?SectionInfo = null;

    var pos: usize = 8; // skip header
    while (pos < wasm.len) {
        const section_id = wasm[pos];
        pos += 1;
        const section_size = readLeb128(wasm, &pos);
        const section_start = pos;

        switch (section_id) {
            6 => global_section = .{ .start = section_start, .size = section_size },
            7 => export_section = .{ .start = section_start, .size = section_size },
            11 => data_section = .{ .start = section_start, .size = section_size },
            else => {},
        }

        pos = section_start + section_size;
    }

    if (export_section == null) return error.NoExportSection;
    if (global_section == null) return error.NoGlobalSection;
    if (data_section == null) return error.NoDataSection;

    // Parse exports to find the global indices for our target exports
    const GlobalMapping = struct {
        global_index: u32,
        section_name: []const u8,
    };

    var global_mappings: std.ArrayListUnmanaged(GlobalMapping) = .{};
    defer global_mappings.deinit(allocator);

    {
        var epos = export_section.?.start;
        const num_exports = readLeb128(wasm, &epos);
        for (0..num_exports) |_| {
            const name_len = readLeb128(wasm, &epos);
            const name = wasm[epos .. epos + name_len];
            epos += name_len;
            const kind = wasm[epos];
            epos += 1;
            const index = readLeb128(wasm, &epos);

            if (kind == 0x03) { // global export
                for (section_mappings) |mapping| {
                    if (std.mem.eql(u8, name, mapping.export_name)) {
                        try global_mappings.append(allocator, .{
                            .global_index = index,
                            .section_name = mapping.section_name,
                        });
                    }
                }
            }
        }
    }

    if (global_mappings.items.len == 0) return error.NoMatchingExports;

    // Parse globals to get i32.const init values (memory offsets)
    const DataLocation = struct {
        memory_offset: u32,
        section_name: []const u8,
    };

    var data_locations: std.ArrayListUnmanaged(DataLocation) = .{};
    defer data_locations.deinit(allocator);

    {
        var gpos = global_section.?.start;
        const num_globals = readLeb128(wasm, &gpos);
        for (0..num_globals) |i| {
            // Global type: valtype (1 byte) + mutability (1 byte)
            gpos += 2; // skip type and mutability

            // Init expression: should be i32.const <value> end
            if (wasm[gpos] != 0x41) { // i32.const
                // Skip non-i32.const init expressions
                while (wasm[gpos] != 0x0b) : (gpos += 1) {} // find end
                gpos += 1;
                continue;
            }
            gpos += 1; // skip i32.const opcode
            const offset = readLeb128(wasm, &gpos);
            if (wasm[gpos] != 0x0b) return error.InvalidInitExpr;
            gpos += 1; // skip end

            for (global_mappings.items) |mapping| {
                if (mapping.global_index == @as(u32, @intCast(i))) {
                    try data_locations.append(allocator, .{
                        .memory_offset = offset,
                        .section_name = mapping.section_name,
                    });
                }
            }
        }
    }

    // Parse data section to find segments at the target offsets
    const CustomSectionData = struct {
        section_name: []const u8,
        data: []const u8,
    };

    var custom_sections: std.ArrayListUnmanaged(CustomSectionData) = .{};
    defer custom_sections.deinit(allocator);

    {
        var dpos = data_section.?.start;
        const num_segments = readLeb128(wasm, &dpos);
        for (0..num_segments) |_| {
            const flags = readLeb128(wasm, &dpos);
            _ = flags;

            // Active segment: i32.const <offset> end
            if (wasm[dpos] != 0x41) return error.UnsupportedDataSegment;
            dpos += 1;
            const seg_offset = readLeb128(wasm, &dpos);
            if (wasm[dpos] != 0x0b) return error.InvalidDataSegment;
            dpos += 1;

            const data_len = readLeb128(wasm, &dpos);
            const seg_data = wasm[dpos .. dpos + data_len];
            dpos += data_len;

            for (data_locations.items) |loc| {
                if (loc.memory_offset == seg_offset) {
                    try custom_sections.append(allocator, .{
                        .section_name = loc.section_name,
                        .data = seg_data,
                    });
                }
            }
        }
    }

    if (custom_sections.items.len == 0) return error.NoDataFound;

    // Build output: original wasm + custom sections appended
    var output: std.ArrayListUnmanaged(u8) = .{};
    defer output.deinit(allocator);

    // Copy original wasm as-is
    try output.appendSlice(allocator, wasm);

    // Append custom sections
    for (custom_sections.items) |cs| {
        // Custom section format:
        // section_id: 0x00 (1 byte)
        // section_size: LEB128 (name_len_leb + name_bytes + payload_bytes)
        // name_len: LEB128
        // name: UTF-8 bytes
        // payload: raw bytes

        var name_len_buf: [5]u8 = undefined;
        const name_len_size = writeLeb128(&name_len_buf, @intCast(cs.section_name.len));

        const section_payload_size = name_len_size + cs.section_name.len + cs.data.len;

        var section_size_buf: [5]u8 = undefined;
        const section_size_size = writeLeb128(&section_size_buf, @intCast(section_payload_size));

        try output.append(allocator, 0x00); // custom section ID
        try output.appendSlice(allocator, section_size_buf[0..section_size_size]);
        try output.appendSlice(allocator, name_len_buf[0..name_len_size]);
        try output.appendSlice(allocator, cs.section_name);
        try output.appendSlice(allocator, cs.data);
    }

    return try output.toOwnedSlice(allocator);
}

const SectionInfo = struct {
    start: usize,
    size: u32,
};

fn readLeb128(data: []const u8, p: *usize) u32 {
    var result: u32 = 0;
    var shift: u5 = 0;
    while (true) {
        const byte = data[p.*];
        p.* += 1;
        result |= @as(u32, byte & 0x7f) << shift;
        if (byte & 0x80 == 0) break;
        shift += 7;
    }
    return result;
}

fn writeLeb128(buf: []u8, value: u32) usize {
    var v = value;
    var i: usize = 0;
    while (true) {
        const byte: u8 = @truncate(v & 0x7f);
        v >>= 7;
        if (v == 0) {
            buf[i] = byte;
            return i + 1;
        }
        buf[i] = byte | 0x80;
        i += 1;
    }
}

test "processWasm adds custom sections" {
    const allocator = std.testing.allocator;

    // Build a minimal wasm module with:
    // - 2 globals (i32 immutable, pointing to data offsets)
    // - 2 exports (_contract_spec -> global 0, _contract_env_meta -> global 1)
    // - 2 data segments with test payloads

    var wasm_buf: std.ArrayListUnmanaged(u8) = .{};
    defer wasm_buf.deinit(allocator);

    // Header
    try wasm_buf.appendSlice(allocator, "\x00asm\x01\x00\x00\x00");

    // Global section (id=6): 2 globals
    const global_payload = [_]u8{
        0x02, // 2 globals
        0x7f, 0x00, 0x41, 0x00, 0x0b, // i32, immut, i32.const(0), end
        0x7f, 0x00, 0x41, 0x04, 0x0b, // i32, immut, i32.const(4), end
    };
    try wasm_buf.append(allocator, 0x06); // global section
    try wasm_buf.append(allocator, @intCast(global_payload.len));
    try wasm_buf.appendSlice(allocator, &global_payload);

    // Export section (id=7): 2 exports
    var export_payload: std.ArrayListUnmanaged(u8) = .{};
    defer export_payload.deinit(allocator);
    try export_payload.append(allocator, 0x02); // 2 exports
    try export_payload.append(allocator, 14); // name len
    try export_payload.appendSlice(allocator, "_contract_spec");
    try export_payload.append(allocator, 0x03); // global
    try export_payload.append(allocator, 0x00); // index 0
    try export_payload.append(allocator, 18); // name len
    try export_payload.appendSlice(allocator, "_contract_env_meta");
    try export_payload.append(allocator, 0x03); // global
    try export_payload.append(allocator, 0x01); // index 1

    try wasm_buf.append(allocator, 0x07); // export section
    try wasm_buf.append(allocator, @intCast(export_payload.items.len));
    try wasm_buf.appendSlice(allocator, export_payload.items);

    // Data section (id=11): 2 segments
    var data_payload: std.ArrayListUnmanaged(u8) = .{};
    defer data_payload.deinit(allocator);
    try data_payload.append(allocator, 0x02); // 2 segments
    // Segment 0: active, memory 0, offset=0, 4 bytes "SPEC"
    try data_payload.append(allocator, 0x00); // flags (active, memory 0)
    try data_payload.append(allocator, 0x41); // i32.const
    try data_payload.append(allocator, 0x00); // offset 0
    try data_payload.append(allocator, 0x0b); // end
    try data_payload.append(allocator, 0x04); // 4 bytes
    try data_payload.appendSlice(allocator, "SPEC");
    // Segment 1: active, memory 0, offset=4, 4 bytes "META"
    try data_payload.append(allocator, 0x00); // flags
    try data_payload.append(allocator, 0x41); // i32.const
    try data_payload.append(allocator, 0x04); // offset 4
    try data_payload.append(allocator, 0x0b); // end
    try data_payload.append(allocator, 0x04); // 4 bytes
    try data_payload.appendSlice(allocator, "META");

    try wasm_buf.append(allocator, 0x0b); // data section
    try wasm_buf.append(allocator, @intCast(data_payload.items.len));
    try wasm_buf.appendSlice(allocator, data_payload.items);

    const result = try processWasm(allocator, wasm_buf.items);
    defer allocator.free(result);

    // Verify the result contains the original wasm plus two custom sections
    try std.testing.expect(result.len > wasm_buf.items.len);

    // Scan from after original wasm to find appended custom sections
    var scan_pos = wasm_buf.items.len;
    var found_spec = false;
    var found_meta = false;

    while (scan_pos < result.len) {
        const section_id = result[scan_pos];
        scan_pos += 1;
        try std.testing.expectEqual(@as(u8, 0x00), section_id); // custom section
        const section_size = readLeb128(result, &scan_pos);
        const section_end = scan_pos + section_size;
        const name_len = readLeb128(result, &scan_pos);
        const name = result[scan_pos .. scan_pos + name_len];
        scan_pos += name_len;
        const payload = result[scan_pos..section_end];
        scan_pos = section_end;

        if (std.mem.eql(u8, name, "contractspecv0")) {
            try std.testing.expectEqualSlices(u8, "SPEC", payload);
            found_spec = true;
        } else if (std.mem.eql(u8, name, "contractenvmetav0")) {
            try std.testing.expectEqualSlices(u8, "META", payload);
            found_meta = true;
        }
    }

    try std.testing.expect(found_spec);
    try std.testing.expect(found_meta);
}
