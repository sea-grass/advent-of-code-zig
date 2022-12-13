// The problem:
// The elves are all carrying one or more food items and we need to know which
// elf is carrying the most calories.
//
// In the input, each line is either an item's calory count or a blank line.
// A blank line divides each elf's inventory.
// When we read a line with a calory count on it, we need to add that number to
// the total calory count for the current elf. When we see a blank line, it means
// we've reached the end of that elf's inventory, so when we next see a calory
// count line we need to start counting from 0 again.
//
// The approach:
// We'll use Zig's std.mem.split on two successive newlines ("\n\n") to get an iterator
// of each elf's inventory lines. We can use std.mem.split again for each elf's
// inventory on a single newline ("\n") to get an iterator of each of item the elf is
// carrying. Then, we parse each integer and sum them together. We take the sum
// and then set our `max_sum` to `@max(sum, max_sum)`. At the end, we print the
// maximum sum.
const std = @import("std");

const name = "01_calorie_counting";
const sample_input = @embedFile(name ++ "/sample-input.txt");
const sample_output = @embedFile(name ++ "/sample-output.txt");
const input = @embedFile(name ++ "/input.txt");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const sample_calory_count = get_max_calory_count(sample_input);
    const expected_calory_count = std.fmt.parseInt(u32, std.mem.trimRight(u8, sample_output, "\n"), 10) catch unreachable;
    if (sample_calory_count != expected_calory_count) unreachable;

    const max_calory_count = get_max_calory_count(input);
    stdout.print("{d}\n", .{max_calory_count});
}

fn get_max_calory_count(elf_inventory: []const u8) u32 {
    var elves = std.mem.split(u8, elf_inventory, "\n\n");

    var max_calory_count: u32 = 0;
    while (elves.next()) |elf| {
        var items = std.mem.split(u8, elf, "\n");
        var total_calory_count: u32 = 0;
        var saw_end = false;
        while (items.next()) |item| {
            if (std.mem.eql(u8, item, "")) {
                // The only blank line we expect is at the end of the file.
                saw_end = true;
                continue;
            }
            // If we continue to see tokens after the expected end, it's a problem.
            if (saw_end) unreachable;

            const calory_count = std.fmt.parseInt(u32, item, 10) catch unreachable;
            total_calory_count += calory_count;
        }
        max_calory_count = @max(max_calory_count, total_calory_count);
    }

    return max_calory_count;
}
