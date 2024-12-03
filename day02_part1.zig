const std = @import("std");
const data = @embedFile("data/day02.txt");

pub fn main() !void {
    var lines = std.mem.tokenizeScalar(u8, data, '\n');

    var result: i64 = 0;
    while (lines.next()) |line| {
        if (reportIsSafe(line)) {
            result += 1;
        }
    }

    std.debug.print("result: {}\n", .{result});
}

fn reportIsSafe(line: []const u8) bool {
    var i: i8 = 0;
    var last: i64 = 0;
    var dir: i8 = 0; //0=null, 1=asc, 2=desc

    var levels = std.mem.tokenizeScalar(u8, line, ' ');
    while (levels.next()) |level| {
        const l = parseInt(level);
        if (i == 0) {
            i = 1;
            last = l;
            continue;
        }

        const distance = @abs(last - l);
        if (distance < 1 or distance > 3) {
            return false;
        }

        std.debug.print("curr: {d}, last: {d}\n", .{ l, last });

        if (dir == 0) {
            if (l > last) {
                dir = 1;
            } else {
                dir = 2;
            }
        }

        if (dir == 1 and l < last) {
            return false;
        }
        if (dir == 2 and l > last) {
            return false;
        }

        last = l;
    }
    return true;
}

fn parseInt(val: []const u8) i64 {
    return std.fmt.parseInt(i64, val, 10) catch |err| {
        std.debug.print("Parse error: '{s}' ({})\n", .{ val, err });
        unreachable;
    };
}
