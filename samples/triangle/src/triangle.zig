const builtin = @import("builtin");
const std = @import("std");
const win32 = @import("win32");
const w = win32.base;
const d3d12 = win32.d3d12;
const common = @import("common");
const gr = common.graphics;
const lib = common.library;
const c = common.c;
const vm = common.vectormath;
const hrPanic = lib.hrPanic;
const hrPanicOnFail = lib.hrPanicOnFail;

pub export var D3D12SDKVersion: u32 = 4;
pub export var D3D12SDKPath: [*:0]const u8 = ".\\d3d12\\";

pub fn main() !void {
    const window_name = "zig-gamedev: triangle";
    const window_width = 900;
    const window_height = 900;

    lib.init();
    defer lib.deinit();

    var gpa_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const leaked = gpa_allocator.deinit();
        std.debug.assert(leaked == false);
    }
    const gpa = &gpa_allocator.allocator;

    var arena_allocator = std.heap.ArenaAllocator.init(gpa);
    defer arena_allocator.deinit();

    const window = lib.initWindow(gpa, window_name, window_width, window_height) catch unreachable;
    defer lib.deinitWindow(gpa);

    var grfx = gr.GraphicsContext.init(window);
    defer grfx.deinit();

    const pipeline = blk: {
        const input_layout_desc = [_]d3d12.INPUT_ELEMENT_DESC{
            d3d12.INPUT_ELEMENT_DESC.init("POSITION", 0, .R32G32B32_FLOAT, 0, 0, .PER_VERTEX_DATA, 0),
        };
        var pso_desc = d3d12.GRAPHICS_PIPELINE_STATE_DESC.initDefault();
        pso_desc.DepthStencilState.DepthEnable = w.FALSE;
        pso_desc.InputLayout = .{
            .pInputElementDescs = &input_layout_desc,
            .NumElements = input_layout_desc.len,
        };
        pso_desc.RTVFormats[0] = .R8G8B8A8_UNORM;
        pso_desc.NumRenderTargets = 1;
        pso_desc.BlendState.RenderTarget[0].RenderTargetWriteMask = 0xf;
        pso_desc.PrimitiveTopologyType = .TRIANGLE;

        break :blk grfx.createGraphicsShaderPipeline(
            &arena_allocator.allocator,
            &pso_desc,
            "content/shaders/triangle.vs.cso",
            "content/shaders/triangle.ps.cso",
        );
    };
    defer {
        _ = grfx.releasePipeline(pipeline);
    }

    const vertex_buffer = grfx.createCommittedResource(
        .DEFAULT,
        d3d12.HEAP_FLAG_NONE,
        &d3d12.RESOURCE_DESC.initBuffer(3 * @sizeOf(vm.Vec3)),
        d3d12.RESOURCE_STATE_COPY_DEST,
        null,
    ) catch |err| hrPanic(err);
    defer _ = grfx.releaseResource(vertex_buffer);

    const index_buffer = grfx.createCommittedResource(
        .DEFAULT,
        d3d12.HEAP_FLAG_NONE,
        &d3d12.RESOURCE_DESC.initBuffer(3 * @sizeOf(u32)),
        d3d12.RESOURCE_STATE_COPY_DEST,
        null,
    ) catch |err| hrPanic(err);
    defer _ = grfx.releaseResource(index_buffer);

    grfx.beginFrame();

    var gui = gr.GuiContext.init(&arena_allocator.allocator, &grfx);
    defer gui.deinit(&grfx);

    const upload_verts = grfx.allocateUploadBufferRegion(vm.Vec3, 3);
    upload_verts.cpu_slice[0] = vm.Vec3.init(-0.7, -0.7, 0.0);
    upload_verts.cpu_slice[1] = vm.Vec3.init(0.0, 0.7, 0.0);
    upload_verts.cpu_slice[2] = vm.Vec3.init(0.7, -0.7, 0.0);

    grfx.cmdlist.CopyBufferRegion(
        grfx.getResource(vertex_buffer),
        0,
        upload_verts.buffer,
        upload_verts.buffer_offset,
        upload_verts.cpu_slice.len * @sizeOf(vm.Vec3),
    );

    const upload_indices = grfx.allocateUploadBufferRegion(u32, 3);
    upload_indices.cpu_slice[0] = 0;
    upload_indices.cpu_slice[1] = 1;
    upload_indices.cpu_slice[2] = 2;

    grfx.cmdlist.CopyBufferRegion(
        grfx.getResource(index_buffer),
        0,
        upload_indices.buffer,
        upload_indices.buffer_offset,
        upload_indices.cpu_slice.len * @sizeOf(u32),
    );

    grfx.addTransitionBarrier(vertex_buffer, d3d12.RESOURCE_STATE_VERTEX_AND_CONSTANT_BUFFER);
    grfx.addTransitionBarrier(index_buffer, d3d12.RESOURCE_STATE_INDEX_BUFFER);
    grfx.flushResourceBarriers();

    grfx.finishGpuCommands();

    var triangle_color = vm.Vec3.init(0.0, 1.0, 0.0);

    var stats = lib.FrameStats.init();

    while (true) {
        var message = std.mem.zeroes(w.user32.MSG);
        const has_message = w.user32.peekMessageA(&message, null, 0, 0, w.user32.PM_REMOVE) catch unreachable;
        if (has_message) {
            _ = w.user32.translateMessage(&message);
            _ = w.user32.dispatchMessageA(&message);
            if (message.message == w.user32.WM_QUIT) {
                break;
            }
        } else {
            stats.update();
            {
                var buffer = [_]u8{0} ** 64;
                const text = std.fmt.bufPrint(
                    buffer[0..],
                    "FPS: {d:.1}  CPU time: {d:.3} ms | {s}",
                    .{ stats.fps, stats.average_cpu_time, window_name },
                ) catch unreachable;
                _ = w.SetWindowTextA(window, @ptrCast([*:0]const u8, text.ptr));
            }
            lib.newImGuiFrame(stats.delta_time);

            c.igSetNextWindowPos(c.ImVec2{ .x = 10.0, .y = 10.0 }, c.ImGuiCond_FirstUseEver, c.ImVec2{ .x = 0.0, .y = 0.0 });
            c.igSetNextWindowSize(c.ImVec2{ .x = 600.0, .y = 0.0 }, c.ImGuiCond_FirstUseEver);
            _ = c.igBegin(
                "Demo Settings",
                null,
                c.ImGuiWindowFlags_NoMove | c.ImGuiWindowFlags_NoResize | c.ImGuiWindowFlags_NoSavedSettings,
            );
            _ = c.igColorEdit3("Triangle color", &triangle_color.v, c.ImGuiColorEditFlags_None);
            c.igEnd();

            grfx.beginFrame();

            const back_buffer = grfx.getBackBuffer();

            grfx.addTransitionBarrier(back_buffer.resource_handle, d3d12.RESOURCE_STATE_RENDER_TARGET);
            grfx.flushResourceBarriers();

            grfx.cmdlist.OMSetRenderTargets(
                1,
                &[_]d3d12.CPU_DESCRIPTOR_HANDLE{back_buffer.descriptor_handle},
                w.TRUE,
                null,
            );
            grfx.cmdlist.ClearRenderTargetView(
                back_buffer.descriptor_handle,
                &[4]f32{ 0.2, 0.4, 0.8, 1.0 },
                0,
                null,
            );
            grfx.setCurrentPipeline(pipeline);
            grfx.cmdlist.IASetPrimitiveTopology(.TRIANGLELIST);
            grfx.cmdlist.IASetVertexBuffers(0, 1, &[_]d3d12.VERTEX_BUFFER_VIEW{.{
                .BufferLocation = grfx.getResource(vertex_buffer).GetGPUVirtualAddress(),
                .SizeInBytes = 3 * @sizeOf(vm.Vec3),
                .StrideInBytes = @sizeOf(vm.Vec3),
            }});
            grfx.cmdlist.IASetIndexBuffer(&.{
                .BufferLocation = grfx.getResource(index_buffer).GetGPUVirtualAddress(),
                .SizeInBytes = 3 * @sizeOf(u32),
                .Format = .R32_UINT,
            });
            grfx.cmdlist.SetGraphicsRoot32BitConstant(
                0,
                c.igColorConvertFloat4ToU32(
                    c.ImVec4{ .x = triangle_color.v[0], .y = triangle_color.v[1], .z = triangle_color.v[2], .w = 1.0 },
                ),
                0,
            );
            grfx.cmdlist.DrawIndexedInstanced(3, 1, 0, 0, 0);

            gui.draw(&grfx);

            grfx.addTransitionBarrier(back_buffer.resource_handle, d3d12.RESOURCE_STATE_PRESENT);
            grfx.flushResourceBarriers();

            grfx.endFrame();
        }
    }

    grfx.finishGpuCommands();
}
