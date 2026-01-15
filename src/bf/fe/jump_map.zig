const std = @import("std");
const CoreTypes = @import("../core/types.zig");

const Instr = CoreTypes.Instr;
const JumpMap = CoreTypes.JumpMap;

pub fn build(allocator: std.mem.Allocator, instrs: []Instr) !JumpMap {
    var jz_stack = std.ArrayList(usize).empty;
    defer jz_stack.deinit(allocator);

    const jump = try allocator.alloc(?usize, instrs.len);
    errdefer allocator.free(jump);

    @memset(jump, null);

    for (instrs, 0..) |instr, i| {
        switch (instr) {
            .Jz => {
                try jz_stack.append(allocator, i);
            },
            .Jnz => {
                if (jz_stack.pop()) |j| {
                    jump[i] = j;
                    jump[j] = i;
                } else {
                    return error.UnmatchedClosingBracket;
                }
            },
            else => {},
        }
    }

    if (jz_stack.items.len > 0) {
        return error.UnmatchedClosingBracket;
    }

    return jump;
}
