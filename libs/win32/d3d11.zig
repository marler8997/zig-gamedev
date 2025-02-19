const windows = @import("windows.zig");
const IUnknown = windows.IUnknown;
const UINT = windows.UINT;
const WINAPI = windows.WINAPI;
const GUID = windows.GUID;

pub const CREATE_DEVICE_FLAG = UINT;
pub const CREATE_DEVICE_SINGLETHREADED = 0x1;
pub const CREATE_DEVICE_DEBUG = 0x2;
pub const CREATE_DEVICE_SWITCH_TO_REF = 0x4;
pub const CREATE_DEVICE_PREVENT_INTERNAL_THREADING_OPTIMIZATIONS = 0x8;
pub const CREATE_DEVICE_BGRA_SUPPORT = 0x20;
pub const CREATE_DEVICE_DEBUGGABLE = 0x40;
pub const CREATE_DEVICE_PREVENT_ALTERING_LAYER_SETTINGS_FROM_REGISTRY = 0x80;
pub const CREATE_DEVICE_DISABLE_GPU_TIMEOUT = 0x100;
pub const CREATE_DEVICE_VIDEO_SUPPORT = 0x800;

pub const BIND_FLAG = UINT;
pub const BIND_VERTEX_BUFFER = 0x1;
pub const BIND_INDEX_BUFFER = 0x2;
pub const BIND_CONSTANT_BUFFER = 0x4;
pub const BIND_SHADER_RESOURCE = 0x8;
pub const BIND_STREAM_OUTPUT = 0x10;
pub const BIND_RENDER_TARGET = 0x20;
pub const BIND_DEPTH_STENCIL = 0x40;
pub const BIND_UNORDERED_ACCESS = 0x80;
pub const BIND_DECODER = 0x200;
pub const BIND_VIDEO_ENCODER = 0x400;

pub const IDeviceChild = extern struct {
    const Self = @This();
    v: *const extern struct {
        unknown: IUnknown.VTable(Self),
        devchild: VTable(Self),
    },
    usingnamespace IUnknown.Methods(Self);
    usingnamespace Methods(Self);

    pub fn Methods(comptime T: type) type {
        _ = T;
        return extern struct {};
    }

    pub fn VTable(comptime T: type) type {
        _ = T;
        return extern struct {
            GetDevice: *c_void,
            GetPrivateData: *c_void,
            SetPrivateData: *c_void,
            SetPrivateDataInterface: *c_void,
        };
    }
};

pub const IResource = extern struct {
    const Self = @This();
    v: *const extern struct {
        unknown: IUnknown.VTable(Self),
        devchild: IDeviceChild.VTable(Self),
        resource: VTable(Self),
    },
    usingnamespace IUnknown.Methods(Self);
    usingnamespace IDeviceChild.Methods(Self);
    usingnamespace Methods(Self);

    pub fn Methods(comptime T: type) type {
        _ = T;
        return extern struct {};
    }

    pub fn VTable(comptime T: type) type {
        _ = T;
        return extern struct {
            GetType: *c_void,
            SetEvictionPriority: *c_void,
            GetEvictionPriority: *c_void,
        };
    }
};

pub const IDeviceContext = extern struct {
    const Self = @This();
    v: *const extern struct {
        unknown: IUnknown.VTable(Self),
        devchild: IDeviceChild.VTable(Self),
        devctx: VTable(Self),
    },
    usingnamespace IUnknown.Methods(Self);
    usingnamespace IDeviceChild.Methods(Self);
    usingnamespace Methods(Self);

    pub fn Methods(comptime T: type) type {
        return extern struct {
            pub inline fn Flush(self: *T) void {
                self.v.devctx.Flush(self);
            }
        };
    }

    pub fn VTable(comptime T: type) type {
        return extern struct {
            VSSetConstantBuffers: *c_void,
            PSSetShaderResources: *c_void,
            PSSetShader: *c_void,
            PSSetSamplers: *c_void,
            VSSetShader: *c_void,
            DrawIndexed: *c_void,
            Draw: *c_void,
            Map: *c_void,
            Unmap: *c_void,
            PSSetConstantBuffers: *c_void,
            IASetInputLayout: *c_void,
            IASetVertexBuffers: *c_void,
            IASetIndexBuffer: *c_void,
            DrawIndexedInstanced: *c_void,
            DrawInstanced: *c_void,
            GSSetConstantBuffers: *c_void,
            GSSetShader: *c_void,
            IASetPrimitiveTopology: *c_void,
            VSSetShaderResources: *c_void,
            VSSetSamplers: *c_void,
            Begin: *c_void,
            End: *c_void,
            GetData: *c_void,
            SetPredication: *c_void,
            GSSetShaderResources: *c_void,
            GSSetSamplers: *c_void,
            OMSetRenderTargets: *c_void,
            OMSetRenderTargetsAndUnorderedAccessViews: *c_void,
            OMSetBlendState: *c_void,
            OMSetDepthStencilState: *c_void,
            SOSetTargets: *c_void,
            DrawAuto: *c_void,
            DrawIndexedInstancedIndirect: *c_void,
            DrawInstancedIndirect: *c_void,
            Dispatch: *c_void,
            DispatchIndirect: *c_void,
            RSSetState: *c_void,
            RSSetViewports: *c_void,
            RSSetScissorRects: *c_void,
            CopySubresourceRegion: *c_void,
            CopyResource: *c_void,
            UpdateSubresource: *c_void,
            CopyStructureCount: *c_void,
            ClearRenderTargetView: *c_void,
            ClearUnorderedAccessViewUint: *c_void,
            ClearUnorderedAccessViewFloat: *c_void,
            ClearDepthStencilView: *c_void,
            GenerateMips: *c_void,
            SetResourceMinLOD: *c_void,
            GetResourceMinLOD: *c_void,
            ResolveSubresource: *c_void,
            ExecuteCommandList: *c_void,
            HSSetShaderResources: *c_void,
            HSSetShader: *c_void,
            HSSetSamplers: *c_void,
            HSSetConstantBuffers: *c_void,
            DSSetShaderResources: *c_void,
            DSSetShader: *c_void,
            DSSetSamplers: *c_void,
            DSSetConstantBuffers: *c_void,
            CSSetShaderResources: *c_void,
            CSSetUnorderedAccessViews: *c_void,
            CSSetShader: *c_void,
            CSSetSamplers: *c_void,
            CSSetConstantBuffers: *c_void,
            VSGetConstantBuffers: *c_void,
            PSGetShaderResources: *c_void,
            PSGetShader: *c_void,
            PSGetSamplers: *c_void,
            VSGetShader: *c_void,
            PSGetConstantBuffers: *c_void,
            IAGetInputLayout: *c_void,
            IAGetVertexBuffers: *c_void,
            IAGetIndexBuffer: *c_void,
            GSGetConstantBuffers: *c_void,
            GSGetShader: *c_void,
            IAGetPrimitiveTopology: *c_void,
            VSGetShaderResources: *c_void,
            VSGetSamplers: *c_void,
            GetPredication: *c_void,
            GSGetShaderResources: *c_void,
            GSGetSamplers: *c_void,
            OMGetRenderTargets: *c_void,
            OMGetRenderTargetsAndUnorderedAccessViews: *c_void,
            OMGetBlendState: *c_void,
            OMGetDepthStencilState: *c_void,
            SOGetTargets: *c_void,
            RSGetState: *c_void,
            RSGetViewports: *c_void,
            RSGetScissorRects: *c_void,
            HSGetShaderResources: *c_void,
            HSGetShader: *c_void,
            HSGetSamplers: *c_void,
            HSGetConstantBuffers: *c_void,
            DSGetShaderResources: *c_void,
            DSGetShader: *c_void,
            DSGetSamplers: *c_void,
            DSGetConstantBuffers: *c_void,
            CSGetShaderResources: *c_void,
            CSGetUnorderedAccessViews: *c_void,
            CSGetShader: *c_void,
            CSGetSamplers: *c_void,
            CSGetConstantBuffers: *c_void,
            ClearState: *c_void,
            Flush: fn (*T) callconv(WINAPI) void,
            GetType: *c_void,
            GetContextFlags: *c_void,
            FinishCommandList: *c_void,
        };
    }
};

pub const IDevice = extern struct {
    const Self = @This();
    v: *const extern struct {
        unknown: IUnknown.VTable(Self),
        device: VTable(Self),
    },
    usingnamespace IUnknown.Methods(Self);
    usingnamespace Methods(Self);

    pub fn Methods(comptime T: type) type {
        _ = T;
        return extern struct {};
    }

    pub fn VTable(comptime T: type) type {
        _ = T;
        return extern struct {
            CreateBuffer: *c_void,
            CreateTexture1D: *c_void,
            CreateTexture2D: *c_void,
            CreateTexture3D: *c_void,
            CreateShaderResourceView: *c_void,
            CreateUnorderedAccessView: *c_void,
            CreateRenderTargetView: *c_void,
            CreateDepthStencilView: *c_void,
            CreateInputLayout: *c_void,
            CreateVertexShader: *c_void,
            CreateGeometryShader: *c_void,
            CreateGeometryShaderWithStreamOutput: *c_void,
            CreatePixelShader: *c_void,
            CreateHullShader: *c_void,
            CreateDomainShader: *c_void,
            CreateComputeShader: *c_void,
            CreateClassLinkage: *c_void,
            CreateBlendState: *c_void,
            CreateDepthStencilState: *c_void,
            CreateRasterizerState: *c_void,
            CreateSamplerState: *c_void,
            CreateQuery: *c_void,
            CreatePredicate: *c_void,
            CreateCounter: *c_void,
            CreateDeferredContext: *c_void,
            OpenSharedResource: *c_void,
            CheckFormatSupport: *c_void,
            CheckMultisampleQualityLevels: *c_void,
            CheckCounterInfo: *c_void,
            CheckCounter: *c_void,
            CheckFeatureSupport: *c_void,
            GetPrivateData: *c_void,
            SetPrivateData: *c_void,
            SetPrivateDataInterface: *c_void,
            GetFeatureLevel: *c_void,
            GetCreationFlags: *c_void,
            GetDeviceRemovedReason: *c_void,
            GetImmediateContext: *c_void,
            SetExceptionMode: *c_void,
            GetExceptionMode: *c_void,
        };
    }
};

pub const IID_IResource = GUID{
    .Data1 = 0xdc8e63f3,
    .Data2 = 0xd12b,
    .Data3 = 0x4952,
    .Data4 = .{ 0xb4, 0x7b, 0x5e, 0x45, 0x02, 0x6a, 0x86, 0x2d },
};
