const std = @import("std");
const CoreTypes = @import("../core/types.zig");
const vm_module = @import("../vm/vm.zig");

const Program = CoreTypes.Program;
const JumpMap = CoreTypes.JumpMap;
const Instr = CoreTypes.Instr;
const Vm = CoreTypes.Vm;

pub fn step(vm: *Vm, program: *const Program, ip: usize) !?usize {
    if (ip >= program.instrs.len) {
        return null;
    }

    var next_ip = ip + 1;

    const instr = program.instrs[ip];
    switch (instr) {
        Instr.Left => {
            if (vm.dp == 0) {
                try vm_module.grow(vm);
            }
            vm.dp -= 1;
        },
        Instr.Right => {
            vm.dp += 1;
            if (vm.dp >= vm.cap) {
                try vm_module.grow(vm);
            }
        },
        Instr.Inc => {
            vm.cells[vm.dp] +%= 1;
        },
        Instr.Dec => {
            vm.cells[vm.dp] -%= 1;
        },
        Instr.Out => {
            std.debug.print("{c}", .{vm.cells[vm.dp]});
        },
        Instr.In => {},
        Instr.Jz => {
            if (vm.cells[vm.dp] == 0) {
                if (program.jump[ip]) |target| {
                    next_ip = target + 1;
                }
            }
        },
        Instr.Jnz => {
            if (vm.cells[vm.dp] != 0) {
                if (program.jump[ip]) |target| {
                    next_ip = target + 1;
                }
            }
        },
    }

    return next_ip;
}
