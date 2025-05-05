const lib = @import("_my_lib");
const std = @import("std");
const ArrayList = std.ArrayList;

// we make the interface very explicit here.
// Might also be possible with less comptime parameters, but could be way more ugly then
fn map(comptime Src: type, comptime Dst: type, comptime len: usize, array: [len]Src, function: fn (Src) Dst) [len]Dst {
    var result: [len]Dst = undefined;
    for (&result, 0..result.len) |*res, index| {
        res.* = function(array[index]);
    }
    return result;
}

fn add(a: f64) f64 {
    return a + 1.0;
}

fn myPrint(thing: anytype) void {
    const T = @TypeOf(thing);
    std.debug.print("T: {s}\n", .{@typeName(T)});
    switch (T) {
        []const u8, [*:0]const u8, *const [15:0]u8 => std.debug.print("type str: {s}", .{thing}),
        else => {},
    }
}

const WordHelper = struct {
    const Self = @This();
    text: []const u8,
    sep: []const u8,
    pub fn to_words(self: *const Self, alloc: std.mem.Allocator) !ArrayList([]const u8) {
        var res = ArrayList([]const u8).init(alloc);
        var iter = std.mem.SplitIterator(u8, .sequence){
            .buffer = self.text,
            .delimiter = self.sep,
            .index = 0,
        };
        while (iter.next()) |thing| {
            try res.append(thing);
        }
        std.debug.print("res has {d} items\n", .{res.items.len});
        return res;
    }
};

fn checkGpa(
    T: type,
    gpa: *T,
) void {
    {
        if (gpa.detectLeaks()) {
            // do stuff
            std.debug.print("Bad", .{});
        }
        _ = gpa.deinit(); // both funcs return values
    }
}

pub fn main() !void {
    const helper = WordHelper{ .text = "I'm a good man.", .sep = " " };

    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    const T = @TypeOf(gpa);
    defer checkGpa(
        T,
        &gpa,
    );
    const allocator = gpa.allocator();

    const words = try helper.to_words(allocator);
    defer words.deinit();
    std.debug.print("{s}", .{words.items});

    std.debug.print("{d}", .{lib.add(1, 2)});
}
