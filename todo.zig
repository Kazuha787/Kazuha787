const std = @import("std");

const Task = struct {
    description: []const u8,
    done: bool,
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var tasks = std.ArrayList(Task).init(allocator);
    defer tasks.deinit();

    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    try stdout.print("\n*** Welcome to Zig To-Do List ***\n", .{});

    while (true) {
        try stdout.print(
            \\n1. Add Task
            \\n2. View Tasks
            \\n3. Mark Task as Done
            \\n4. Exit
            \\nChoose an option: 
        , .{});

        var buffer: [256]u8 = undefined;
        const input = try stdin.readUntilDelimiterOrEof(&buffer, '\n') orelse "";

        if (std.mem.eql(u8, input, "1")) {
            try stdout.print("Enter task description: ", .{});
            const desc = try stdin.readUntilDelimiterOrEof(&buffer, '\n') orelse "";
            try tasks.append(Task{ .description = try allocator.dupe(u8, desc), .done = false });
            try stdout.print("Task added!\n", .{});
        } else if (std.mem.eql(u8, input, "2")) {
            try stdout.print("\nYour Tasks:\n", .{});
            if (tasks.items.len == 0) {
                try stdout.print("  (No tasks yet)\n", .{});
            } else {
                for (tasks.items, 0..) |task, i| {
                    const status = if (task.done) "[Done]" else "[ ]";
                    try stdout.print("{d + 1}) {s} {s}\n", .{ i, status, task.description });
                }
            }
        } else if (std.mem.eql(u8, input, "3")) {
            try stdout.print("Enter task number to mark as done: ", .{});
            const num_input = try stdin.readUntilDelimiterOrEof(&buffer, '\n') orelse "";
            const idx = try std.fmt.parseInt(usize, num_input, 10);

            if (idx > 0 and idx <= tasks.items.len) {
                tasks.items[idx - 1].done = true;
                try stdout.print("Task marked as done!\n", .{});
            } else {
                try stdout.print("Invalid task number.\n", .{});
            }
        } else if (std.mem.eql(u8, input, "4")) {
            try stdout.print("Goodbye!\n", .{});
            break;
        } else {
            try stdout.print("Invalid choice, try again.\n", .{});
        }
    }
}
