const windows = @import("windows.zig");
const UINT = windows.UINT;
const IUnknown = windows.IUnknown;
const GUID = windows.GUID;
const HRESULT = windows.HRESULT;
const WINAPI = windows.WINAPI;
const LPCWSTR = windows.LPCWSTR;
const FLOAT = windows.FLOAT;

pub const MEASURING_MODE = enum(UINT) {
    NATURAL = 0,
    GDI_CLASSIC = 1,
    GDI_NATURAL = 2,
};

pub const FONT_WEIGHT = enum(UINT) {
    THIN = 100,
    EXTRA_LIGHT = 200,
    LIGHT = 300,
    SEMI_LIGHT = 350,
    NORMAL = 400,
    MEDIUM = 500,
    SEMI_BOLD = 600,
    BOLD = 700,
    EXTRA_BOLD = 800,
    HEAVY = 900,
    ULTRA_BLACK = 950,
};

pub const FONT_STRETCH = enum(UINT) {
    UNDEFINED = 0,
    ULTRA_CONDENSED = 1,
    EXTRA_CONDENSED = 2,
    CONDENSED = 3,
    SEMI_CONDENSED = 4,
    NORMAL = 5,
    SEMI_EXPANDED = 6,
    EXPANDED = 7,
    EXTRA_EXPANDED = 8,
    ULTRA_EXPANDED = 9,
};

pub const FONT_STYLE = enum(UINT) {
    NORMAL = 0,
    OBLIQUE = 1,
    ITALIC = 2,
};

pub const FACTORY_TYPE = enum(UINT) {
    SHARED = 0,
    ISOLATED = 1,
};

pub const TEXT_ALIGNMENT = enum(UINT) {
    LEADING = 0,
    TRAILING = 1,
    CENTER = 2,
    JUSTIFIED = 3,
};

pub const PARAGRAPH_ALIGNMENT = enum(UINT) {
    NEAR = 0,
    FAR = 1,
    CENTER = 2,
};

pub const IFontCollection = extern struct {
    const Self = @This();
    v: *const extern struct {
        unknown: IUnknown.VTable(Self),
        fontcollect: VTable(Self),
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
            GetFontFamilyCount: *c_void,
            GetFontFamily: *c_void,
            FindFamilyName: *c_void,
            GetFontFromFontFace: *c_void,
        };
    }
};

pub const ITextFormat = extern struct {
    const Self = @This();
    v: *const extern struct {
        unknown: IUnknown.VTable(Self),
        textformat: VTable(Self),
    },
    usingnamespace IUnknown.Methods(Self);
    usingnamespace Methods(Self);

    pub fn Methods(comptime T: type) type {
        return extern struct {
            pub inline fn SetTextAlignment(self: *T, alignment: TEXT_ALIGNMENT) HRESULT {
                return self.v.textformat.SetTextAlignment(self, alignment);
            }
            pub inline fn SetParagraphAlignment(self: *T, alignment: PARAGRAPH_ALIGNMENT) HRESULT {
                return self.v.textformat.SetParagraphAlignment(self, alignment);
            }
        };
    }

    pub fn VTable(comptime T: type) type {
        return extern struct {
            SetTextAlignment: fn (*T, TEXT_ALIGNMENT) callconv(WINAPI) HRESULT,
            SetParagraphAlignment: fn (*T, PARAGRAPH_ALIGNMENT) callconv(WINAPI) HRESULT,
            SetWordWrapping: *c_void,
            SetReadingDirection: *c_void,
            SetFlowDirection: *c_void,
            SetIncrementalTabStop: *c_void,
            SetTrimming: *c_void,
            SetLineSpacing: *c_void,
            GetTextAlignment: *c_void,
            GetParagraphAlignment: *c_void,
            GetWordWrapping: *c_void,
            GetReadingDirection: *c_void,
            GetFlowDirection: *c_void,
            GetIncrementalTabStop: *c_void,
            GetTrimming: *c_void,
            GetLineSpacing: *c_void,
            GetFontCollection: *c_void,
            GetFontFamilyNameLength: *c_void,
            GetFontFamilyName: *c_void,
            GetFontWeight: *c_void,
            GetFontStyle: *c_void,
            GetFontStretch: *c_void,
            GetFontSize: *c_void,
            GetLocaleNameLength: *c_void,
            GetLocaleName: *c_void,
        };
    }
};

pub const IFactory = extern struct {
    const Self = @This();
    v: *const extern struct {
        unknown: IUnknown.VTable(Self),
        factory: VTable(Self),
    },
    usingnamespace IUnknown.Methods(Self);
    usingnamespace Methods(Self);

    pub fn Methods(comptime T: type) type {
        return extern struct {
            pub inline fn CreateTextFormat(
                self: *T,
                font_family_name: LPCWSTR,
                font_collection: ?*IFontCollection,
                font_weight: FONT_WEIGHT,
                font_style: FONT_STYLE,
                font_stretch: FONT_STRETCH,
                font_size: FLOAT,
                locale_name: LPCWSTR,
                text_format: *?*ITextFormat,
            ) HRESULT {
                return self.v.factory.CreateTextFormat(
                    self,
                    font_family_name,
                    font_collection,
                    font_weight,
                    font_style,
                    font_stretch,
                    font_size,
                    locale_name,
                    text_format,
                );
            }
        };
    }

    pub fn VTable(comptime T: type) type {
        return extern struct {
            GetSystemFontCollection: *c_void,
            CreateCustomFontCollection: *c_void,
            RegisterFontCollectionLoader: *c_void,
            UnregisterFontCollectionLoader: *c_void,
            CreateFontFileReference: *c_void,
            CreateCustomFontFileReference: *c_void,
            CreateFontFace: *c_void,
            CreateRenderingParams: *c_void,
            CreateMonitorRenderingParams: *c_void,
            CreateCustomRenderingParams: *c_void,
            RegisterFontFileLoader: *c_void,
            UnregisterFontFileLoader: *c_void,
            CreateTextFormat: fn (
                *T,
                LPCWSTR,
                ?*IFontCollection,
                FONT_WEIGHT,
                FONT_STYLE,
                FONT_STRETCH,
                FLOAT,
                LPCWSTR,
                *?*ITextFormat,
            ) callconv(WINAPI) HRESULT,
            CreateTypography: *c_void,
            GetGdiInterop: *c_void,
            CreateTextLayout: *c_void,
            CreateGdiCompatibleTextLayout: *c_void,
            CreateEllipsisTrimmingSign: *c_void,
            CreateTextAnalyzer: *c_void,
            CreateNumberSubstitution: *c_void,
            CreateGlyphRunAnalysis: *c_void,
        };
    }
};

pub const IID_IFactory = GUID{
    .Data1 = 0xb859ee5a,
    .Data2 = 0xd838,
    .Data3 = 0x4b5b,
    .Data4 = .{ 0xa2, 0xe8, 0x1a, 0xdc, 0x7d, 0x93, 0xdb, 0x48 },
};

pub extern "dwrite" fn DWriteCreateFactory(
    factory_type: FACTORY_TYPE,
    guid: *const GUID,
    factory: *?*c_void,
) callconv(WINAPI) HRESULT;
