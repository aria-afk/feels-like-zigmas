const std = @import("std");
const data = @embedFile("data/day01.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    var map = std.AutoHashMap(i64, i64).init(allocator);
    defer map.deinit();

    var list = std.ArrayList(i64).init(allocator);
    defer list.deinit();

    var lines = std.mem.tokenizeScalar(u8, data, '\n');
    while (lines.next()) |line| {
        var args = std.mem.tokenizeSequence(u8, line, "   ");
        var x: i32 = 0;
        while (args.next()) |arg| {
            const num = parseInt(arg);
            if (x == 0) {
                x = 1;
                try list.append(num);
            } else {
                x = 0;
                if (map.get(num)) |existingCount| {
                    try map.put(num, existingCount + 1);
                } else {
                    try map.put(num, 1);
                }
            }
        }
    }

    var result: i64 = 0;

    for (list.items) |item| {
        if (map.get(item)) |count| {
            result += (count * item);
        }
    }

    std.debug.print("result: {d}", .{result});
}

fn parseInt(val: []const u8) i64 {
    return std.fmt.parseInt(i64, val, 10) catch |err| {
        std.debug.print("Parse error: '{s}' ({})\n", .{ val, err });
        unreachable;
    };
}
