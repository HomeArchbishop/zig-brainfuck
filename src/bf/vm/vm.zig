const std = @import("std");
const CoreTypes = @import("../core/types.zig");

const Vm = CoreTypes.Vm;

pub fn init(allocator: std.mem.Allocator, cap: u64) !Vm {
    const init_dp = cap / 2;

    const cells = try allocator.alloc(u8, cap);
    errdefer allocator.free(cells);

    @memset(cells, 0);

    return Vm{ .allocator = allocator, .cells = cells, .dp = init_dp, .cap = cap };
}

pub fn grow(vm: *Vm) !void {
    const old_cap = vm.cap;
    const new_cap = old_cap * 2;
    const new_cells = try vm.allocator.realloc(vm.cells, new_cap);

    const grow_direct: u8 = if (vm.dp < old_cap / 2) 'l' else 'r';
    switch (grow_direct) {
        'l' => {
            const shift = old_cap;
            @memcpy(new_cells[shift .. shift + old_cap], vm.cells[0..old_cap]);
            @memset(new_cells[0..shift], 0);
            vm.*.dp += shift;
        },
        'r' => {
            @memset(new_cells[old_cap..], 0);
        },
        else => {},
    }
    vm.cells = new_cells;
    vm.cap = new_cap;
}
