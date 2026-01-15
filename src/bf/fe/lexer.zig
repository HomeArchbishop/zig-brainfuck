const CoreTypes = @import("../core/types.zig");
const std = @import("std");

const Instr = CoreTypes.Instr;

pub fn buildInstrs(allocator: std.mem.Allocator, raw: []const u8) ![]Instr {
    var list = std.ArrayList(Instr).empty;
    defer list.deinit(allocator);

    for (raw) |char| {
        if (Instr.fromByte(char)) |instr| {
            try list.append(allocator, instr);
        }
    }

    return try list.toOwnedSlice(allocator);
}
