const std = @import("std");
const bf = @import("bf");

pub fn main() !void {
    try bf.runSource("++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.");
}
