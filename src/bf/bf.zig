const std = @import("std");
const fe = @import("./fe/fe.zig");
const vm_module = @import("./vm/vm.zig");
const interpreter = @import("./interpreter/interpreter.zig");

pub fn runSource(raw: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const program = try fe.compile(allocator, raw);
    defer program.deinit();

    var vm = try vm_module.init(allocator, 10);
    defer vm.deinit();

    var ip: usize = 0;
    while (true) {
        if (try interpreter.step(&vm, &program, ip)) |next_ip| {
            if (next_ip >= program.instrs.len) {
                break;
            }
            ip = next_ip;
        } else {
            break;
        }
    }
}
