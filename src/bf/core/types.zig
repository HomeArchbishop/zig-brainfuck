const std = @import("std");

pub const Instr = enum(u8) {
    Right, // '>'
    Left, // '<'
    Inc, // '+'
    Dec, // '-'
    Out, // '.'
    In, // ','
    Jz, // '['  jump if zero
    Jnz, // ']'  jump if non-zero

    pub fn fromByte(b: u8) ?Instr {
        return switch (b) {
            '>' => .Right,
            '<' => .Left,
            '+' => .Inc,
            '-' => .Dec,
            '.' => .Out,
            ',' => .In,
            '[' => .Jz,
            ']' => .Jnz,
            else => null,
        };
    }

    pub fn toByte(i: Instr) u8 {
        return switch (i) {
            .Right => '>',
            .Left => '<',
            .Inc => '+',
            .Dec => '-',
            .Out => '.',
            .In => ',',
            .Jz => '[',
            .Jnz => ']',
        };
    }
};

pub const JumpMap = []?usize;

pub const Program = struct {
    instrs: []Instr,
    jump: JumpMap,

    allocator: std.mem.Allocator,

    pub fn deinit(self: *const Program) void {
        self.allocator.free(self.instrs);
        self.allocator.free(self.jump);
    }
};

pub const Vm = struct {
    cells: []u8,
    cap: u64,
    dp: u64,

    allocator: std.mem.Allocator,

    pub fn deinit(self: *const Vm) void {
        self.allocator.free(self.cells);
    }
};

pub const Io = struct {
    const Self = @This();

    readFn: *const fn (ctx: *anyopaque) anyerror!?u8,
    writeFn: *const fn (ctx: *anyopaque, byte: u8) anyerror!void,
    ctx: *anyopaque,

    pub fn read(self: *const Self) !?u8 {
        return self.readFn(self.ctx);
    }

    pub fn write(self: *const Self, byte: u8) !void {
        return self.writeFn(self.ctx, byte);
    }
};
