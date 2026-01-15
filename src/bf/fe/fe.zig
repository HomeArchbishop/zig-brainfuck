const std = @import("std");
const CoreTypes = @import("../core/types.zig");
const lexer = @import("./lexer.zig");
const jump_map = @import("./jump_map.zig");

const JumpMap = CoreTypes.JumpMap;
const Program = CoreTypes.Program;

pub fn compile(allocator: std.mem.Allocator, raw: []const u8) !Program {
    const instrs = try lexer.buildInstrs(allocator, raw);
    const jump = try jump_map.build(allocator, instrs);

    return Program{
        .instrs = instrs, // move to Program
        .jump = jump, // move to Program
        .allocator = allocator,
    };
}
