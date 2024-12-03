const std = @import("std");
const data = @embedFile("data/day01.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    var l1 = std.ArrayList(i64).init(allocator);
    defer l1.deinit();
    var l2 = std.ArrayList(i64).init(allocator);
    defer l2.deinit();

    var lines = std.mem.tokenizeScalar(u8, data, '\n');
    while (lines.next()) |line| {
        var args = std.mem.tokenizeSequence(u8, line, "   ");
        var x: i32 = 0;
        while (args.next()) |arg| {
            const num = parseInt(arg);
            if (x == 0) {
                x = 1;
                try l1.append(num);
            } else {
                x = 0;
                try l2.append(num);
            }
        }
    }

    std.mem.sort(i64, l1.items, {}, comptime std.sort.asc(i64));
    std.mem.sort(i64, l2.items, {}, comptime std.sort.asc(i64));

    var result: u64 = 0;

    for (l1.items, 0..) |item, i| {
        const distance = @abs(item - l2.items[i]);
        result += distance;
    }

    std.debug.print("result: {}\n", .{result});
}

fn parseInt(val: []const u8) i64 {
    return std.fmt.parseInt(i64, val, 10) catch |err| {
        std.debug.print("Parse error: '{s}' ({})\n", .{ val, err });
        unreachable;
    };
}
