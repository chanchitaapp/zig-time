const std = @import("std");

pub const pkg = std.build.Pkg{
    .name = "time",
    .path = .{ .source = thisDir() ++ "/src/main.zig" },
};

pub fn build(b: *std.Build) void {
    const t = b.addTest(.{
        .root_source_file = b.path("main.zig"),
    });

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("time", .{ .root_source_file = b.path("time.zig"), .target = target, .optimize = optimize});

    const extras = b.dependency("extras", .{
        .target = target,
        .optimize = optimize,
    });

    t.root_module.addImport("extras", extras.module("extras"));

    const lib = b.addStaticLibrary(.{
        .name = "time",
        .root_source_file = b.path("time.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(lib);

    const run_t = b.addRunArtifact(t);

    const t_step = b.step("test", "Run all the tests.");
    t_step.dependOn(&run_t.step);
}

fn thisDir() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}
