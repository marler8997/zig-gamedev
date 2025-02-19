// Most of below code is ported from DirectXMath: https://github.com/microsoft/DirectXMath
const std = @import("std");
const assert = std.debug.assert;
const math = std.math;

const epsilon: f32 = 0.00001;

pub fn modAngle(in_angle: f32) f32 {
    const angle = in_angle + math.pi;
    var temp: f32 = math.fabs(angle);
    temp = temp - (2.0 * math.pi * @intToFloat(f32, @floatToInt(i32, temp / math.pi)));
    temp = temp - math.pi;
    if (angle < 0.0) {
        temp = -temp;
    }
    return temp;
}

pub const Vec2 = extern struct {
    v: [2]f32,

    pub inline fn init(x: f32, y: f32) Vec2 {
        return .{ .v = [_]f32{ x, y } };
    }

    pub inline fn initZero() Vec2 {
        const static = struct {
            const zero = init(0.0, 0.0);
        };
        return static.zero;
    }

    pub inline fn approxEq(a: Vec2, b: Vec2, eps: f32) bool {
        return math.approxEq(f32, a.v[0], b.v[0], eps) and
            math.approxEq(f32, a.v[1], b.v[1], eps);
    }

    pub inline fn add(a: Vec2, b: Vec2) Vec2 {
        return .{ .v = [_]f32{ a.v[0] + b.v[0], a.v[1] + b.v[1] } };
    }

    pub inline fn sub(a: Vec2, b: Vec2) Vec2 {
        return .{ .v = [_]f32{ a.v[0] - b.v[0], a.v[1] - b.v[1] } };
    }

    pub inline fn mul(a: Vec2, b: Vec2) Vec2 {
        return .{ .v = [_]f32{ a.v[0] * b.v[0], a.v[1] * b.v[1] } };
    }

    pub inline fn div(a: Vec2, b: Vec2) Vec2 {
        assert(!approxEq(b, initZero(), epsilon));
        return .{ .v = [_]f32{ a.v[0] / b.v[0], a.v[1] / b.v[1] } };
    }

    pub inline fn scale(a: Vec2, b: f32) Vec2 {
        return .{ .v = [_]f32{ a.v[0] * b, a.v[1] * b } };
    }

    pub inline fn neg(a: Vec2) Vec2 {
        return .{ .v = [_]f32{ -a.v[0], -a.v[1] } };
    }

    pub inline fn mulAdd(a: Vec2, b: Vec2, c: Vec2) Vec2 {
        return .{ .v = [_]f32{
            a.v[0] * b.v[0] + c.v[0],
            a.v[1] * b.v[1] + c.v[1],
        } };
    }

    pub inline fn negMulAdd(a: Vec2, b: Vec2, c: Vec2) Vec2 {
        return .{ .v = [_]f32{
            -a.v[0] * b.v[0] + c.v[0],
            -a.v[1] * b.v[1] + c.v[1],
        } };
    }

    pub inline fn mulSub(a: Vec2, b: Vec2, c: Vec2) Vec2 {
        return .{ .v = [_]f32{
            a.v[0] * b.v[0] - c.v[0],
            a.v[1] * b.v[1] - c.v[1],
        } };
    }

    pub inline fn negMulSub(a: Vec2, b: Vec2, c: Vec2) Vec2 {
        return .{ .v = [_]f32{
            -a.v[0] * b.v[0] - c.v[0],
            -a.v[1] * b.v[1] - c.v[1],
        } };
    }

    pub inline fn lerp(a: Vec2, b: Vec2, t: f32) Vec2 {
        const s = Vec2.init(t, t);
        const ab = b.sub(a);
        return ab.mulAdd(s, a);
    }

    pub inline fn rcp(a: Vec2) Vec2 {
        assert(!approxEq(a, initZero(), epsilon));
        return .{ .v = [_]f32{ 1.0 / a.v[0], 1.0 / a.v[1] } };
    }

    pub inline fn dot(a: Vec2, b: Vec2) f32 {
        return a.v[0] * b.v[0] + a.v[1] * b.v[1];
    }

    pub inline fn length(a: Vec2) f32 {
        return math.sqrt(dot(a, a));
    }

    pub inline fn lengthSq(a: Vec2) f32 {
        return dot(a, a);
    }

    pub inline fn normalize(a: Vec2) Vec2 {
        const len = length(a);
        assert(!math.approxEq(f32, len, 0.0, epsilon));
        const rcplen = 1.0 / len;
        return .{ .v = [_]f32{ rcplen * a.v[0], rcplen * a.v[1] } };
    }

    pub inline fn transform(a: Vec2, b: Mat4) Vec2 {
        return .{
            .v = [_]f32{
                a.v[0] * b.m[0][0] + a.v[1] * b.m[1][0] + b.m[3][0],
                a.v[0] * b.m[0][1] + a.v[1] * b.m[1][1] + b.m[3][1],
            },
        };
    }

    pub inline fn transformNormal(a: Vec2, b: Mat4) Vec2 {
        return .{
            .v = [_]f32{
                a.v[0] * b.m[0][0] + a.v[1] * b.m[1][0],
                a.v[0] * b.m[0][1] + a.v[1] * b.m[1][1],
            },
        };
    }
};

pub const Vec3 = extern struct {
    v: [3]f32,

    pub inline fn init(x: f32, y: f32, z: f32) Vec3 {
        return .{ .v = [_]f32{ x, y, z } };
    }

    pub inline fn initZero() Vec3 {
        const static = struct {
            const zero = init(0.0, 0.0, 0.0);
        };
        return static.zero;
    }

    pub inline fn approxEq(a: Vec3, b: Vec3, eps: f32) bool {
        return math.approxEq(f32, a.v[0], b.v[0], eps) and
            math.approxEq(f32, a.v[1], b.v[1], eps) and
            math.approxEq(f32, a.v[2], b.v[2], eps);
    }

    pub inline fn dot(a: Vec3, b: Vec3) f32 {
        return a.v[0] * b.v[0] + a.v[1] * b.v[1] + a.v[2] * b.v[2];
    }

    pub inline fn cross(a: Vec3, b: Vec3) Vec3 {
        return .{
            .v = [_]f32{
                a.v[1] * b.v[2] - a.v[2] * b.v[1],
                a.v[2] * b.v[0] - a.v[0] * b.v[2],
                a.v[0] * b.v[1] - a.v[1] * b.v[0],
            },
        };
    }

    pub inline fn add(a: Vec3, b: Vec3) Vec3 {
        return .{ .v = [_]f32{ a.v[0] + b.v[0], a.v[1] + b.v[1], a.v[2] + b.v[2] } };
    }

    pub inline fn sub(a: Vec3, b: Vec3) Vec3 {
        return .{ .v = [_]f32{ a.v[0] - b.v[0], a.v[1] - b.v[1], a.v[2] - b.v[2] } };
    }

    pub inline fn mul(a: Vec3, b: Vec3) Vec3 {
        return .{ .v = [_]f32{ a.v[0] * b.v[0], a.v[1] * b.v[1], a.v[2] * b.v[2] } };
    }

    pub inline fn div(a: Vec3, b: Vec3) Vec3 {
        assert(!approxEq(b, initZero(), epsilon));
        return .{ .v = [_]f32{ a.v[0] / b.v[0], a.v[1] / b.v[1], a.v[2] / b.v[2] } };
    }

    pub inline fn scale(a: Vec3, b: f32) Vec3 {
        return .{ .v = [_]f32{ a.v[0] * b, a.v[1] * b, a.v[2] * b } };
    }

    pub inline fn neg(a: Vec3) Vec3 {
        return .{ .v = [_]f32{ -a.v[0], -a.v[1], -a.v[2] } };
    }

    pub inline fn mulAdd(a: Vec3, b: Vec3, c: Vec3) Vec3 {
        return .{ .v = [_]f32{
            a.v[0] * b.v[0] + c.v[0],
            a.v[1] * b.v[1] + c.v[1],
            a.v[2] * b.v[2] + c.v[2],
        } };
    }

    pub inline fn negMulAdd(a: Vec3, b: Vec3, c: Vec3) Vec3 {
        return .{ .v = [_]f32{
            -a.v[0] * b.v[0] + c.v[0],
            -a.v[1] * b.v[1] + c.v[1],
            -a.v[2] * b.v[2] + c.v[2],
        } };
    }

    pub inline fn mulSub(a: Vec3, b: Vec3, c: Vec3) Vec3 {
        return .{ .v = [_]f32{
            a.v[0] * b.v[0] - c.v[0],
            a.v[1] * b.v[1] - c.v[1],
            a.v[2] * b.v[2] - c.v[2],
        } };
    }

    pub inline fn negMulSub(a: Vec3, b: Vec3, c: Vec3) Vec3 {
        return .{ .v = [_]f32{
            -a.v[0] * b.v[0] - c.v[0],
            -a.v[1] * b.v[1] - c.v[1],
            -a.v[2] * b.v[2] - c.v[2],
        } };
    }

    pub inline fn lerp(a: Vec3, b: Vec3, t: f32) Vec3 {
        const s = Vec3.init(t, t, t);
        const ab = b.sub(a);
        return ab.mulAdd(s, a);
    }

    pub inline fn rcp(a: Vec3) Vec3 {
        assert(!approxEq(a, initZero(), epsilon));
        return .{ .v = [_]f32{ 1.0 / a.v[0], 1.0 / a.v[1], 1.0 / a.v[2] } };
    }

    pub inline fn length(a: Vec3) f32 {
        return math.sqrt(dot(a, a));
    }

    pub inline fn lengthSq(a: Vec3) f32 {
        return dot(a, a);
    }

    pub inline fn normalize(a: Vec3) Vec3 {
        const len = length(a);
        assert(!math.approxEq(f32, len, 0.0, epsilon));
        const rcplen = 1.0 / len;
        return .{ .v = [_]f32{ rcplen * a.v[0], rcplen * a.v[1], rcplen * a.v[2] } };
    }

    pub inline fn transform(a: Vec3, b: Mat4) Vec3 {
        return .{
            .v = [_]f32{
                a.v[0] * b.m[0][0] + a.v[1] * b.m[1][0] + a.v[2] * b.m[2][0] + b.m[3][0],
                a.v[0] * b.m[0][1] + a.v[1] * b.m[1][1] + a.v[2] * b.m[2][1] + b.m[3][1],
                a.v[0] * b.m[0][2] + a.v[1] * b.m[1][2] + a.v[2] * b.m[2][2] + b.m[3][2],
            },
        };
    }

    pub inline fn transformNormal(a: Vec3, b: Mat4) Vec3 {
        return .{
            .v = [_]f32{
                a.v[0] * b.m[0][0] + a.v[1] * b.m[1][0] + a.v[2] * b.m[2][0],
                a.v[0] * b.m[0][1] + a.v[1] * b.m[1][1] + a.v[2] * b.m[2][1],
                a.v[0] * b.m[0][2] + a.v[1] * b.m[1][2] + a.v[2] * b.m[2][2],
            },
        };
    }
};

pub const Vec4 = extern struct {
    v: [4]f32,

    pub inline fn init(x: f32, y: f32, z: f32, w: f32) Vec4 {
        return .{ .v = [_]f32{ x, y, z, w } };
    }

    pub inline fn initZero() Vec4 {
        const static = struct {
            const zero = init(0.0, 0.0, 0.0, 0.0);
        };
        return static.zero;
    }

    pub inline fn approxEq(a: Vec4, b: Vec4, eps: f32) bool {
        return math.approxEq(f32, a.v[0], b.v[0], eps) and
            math.approxEq(f32, a.v[1], b.v[1], eps) and
            math.approxEq(f32, a.v[2], b.v[2], eps) and
            math.approxEq(f32, a.v[3], b.v[3], eps);
    }

    pub inline fn add(a: Vec4, b: Vec4) Vec4 {
        return .{ .v = [_]f32{ a.v[0] + b.v[0], a.v[1] + b.v[1], a.v[2] + b.v[2], a.v[3] + b.v[3] } };
    }

    pub inline fn sub(a: Vec4, b: Vec4) Vec4 {
        return .{ .v = [_]f32{ a.v[0] - b.v[0], a.v[1] - b.v[1], a.v[2] - b.v[2], a.v[3] - b.v[3] } };
    }

    pub inline fn mul(a: Vec4, b: Vec4) Vec4 {
        return .{ .v = [_]f32{ a.v[0] * b.v[0], a.v[1] * b.v[1], a.v[2] * b.v[2], a.v[3] * b.v[3] } };
    }

    pub inline fn div(a: Vec4, b: Vec4) Vec4 {
        assert(!approxEq(b, initZero(), epsilon));
        return .{ .v = [_]f32{ a.v[0] / b.v[0], a.v[1] / b.v[1], a.v[2] / b.v[2], a.v[3] / b.v[3] } };
    }

    pub inline fn scale(a: Vec4, b: f32) Vec4 {
        return .{ .v = [_]f32{ a.v[0] * b, a.v[1] * b, a.v[2] * b, a.v[3] * b } };
    }

    pub inline fn neg(a: Vec4) Vec4 {
        return .{ .v = [_]f32{ -a.v[0], -a.v[1], -a.v[2], -a.v[3] } };
    }

    pub inline fn mulAdd(a: Vec4, b: Vec4, c: Vec4) Vec4 {
        return .{ .v = [_]f32{
            a.v[0] * b.v[0] + c.v[0],
            a.v[1] * b.v[1] + c.v[1],
            a.v[2] * b.v[2] + c.v[2],
            a.v[3] * b.v[3] + c.v[3],
        } };
    }

    pub inline fn negMulAdd(a: Vec4, b: Vec4, c: Vec4) Vec4 {
        return .{ .v = [_]f32{
            -a.v[0] * b.v[0] + c.v[0],
            -a.v[1] * b.v[1] + c.v[1],
            -a.v[2] * b.v[2] + c.v[2],
            -a.v[3] * b.v[3] + c.v[3],
        } };
    }

    pub inline fn mulSub(a: Vec4, b: Vec4, c: Vec4) Vec4 {
        return .{ .v = [_]f32{
            a.v[0] * b.v[0] - c.v[0],
            a.v[1] * b.v[1] - c.v[1],
            a.v[2] * b.v[2] - c.v[2],
            a.v[3] * b.v[3] - c.v[3],
        } };
    }

    pub inline fn negMulSub(a: Vec4, b: Vec4, c: Vec4) Vec4 {
        return .{ .v = [_]f32{
            -a.v[0] * b.v[0] - c.v[0],
            -a.v[1] * b.v[1] - c.v[1],
            -a.v[2] * b.v[2] - c.v[2],
            -a.v[3] * b.v[3] - c.v[3],
        } };
    }

    pub inline fn lerp(a: Vec4, b: Vec4, t: f32) Vec4 {
        const s = Vec4.init(t, t, t, t);
        const ab = b.sub(a);
        return ab.mulAdd(s, a);
    }

    pub inline fn rcp(a: Vec4) Vec4 {
        assert(!approxEq(a, initZero(), epsilon));
        return .{ .v = [_]f32{ 1.0 / a.v[0], 1.0 / a.v[1], 1.0 / a.v[2], 1.0 / a.v[3] } };
    }

    pub inline fn dot(a: Vec4, b: Vec4) f32 {
        return a.v[0] * b.v[0] + a.v[1] * b.v[1] + a.v[2] * b.v[2] + a.v[3] * b.v[3];
    }

    pub inline fn length(a: Vec4) f32 {
        return math.sqrt(dot(a, a));
    }

    pub inline fn lengthSq(a: Vec4) f32 {
        return dot(a, a);
    }

    pub inline fn normalize(a: Vec4) Vec4 {
        const len = length(a);
        assert(!math.approxEq(f32, len, 0.0, epsilon));
        const rcplen = 1.0 / len;
        return .{ .v = [_]f32{ rcplen * a.v[0], rcplen * a.v[1], rcplen * a.v[2], rcplen * a.v[3] } };
    }

    pub inline fn transform(a: Vec4, b: Mat4) Vec4 {
        return .{
            .v = [_]f32{
                a.v[0] * b.m[0][0] + a.v[1] * b.m[1][0] + a.v[2] * b.m[2][0] + a.v[3] * b.m[3][0],
                a.v[0] * b.m[0][1] + a.v[1] * b.m[1][1] + a.v[2] * b.m[2][1] + a.v[3] * b.m[3][1],
                a.v[0] * b.m[0][2] + a.v[1] * b.m[1][2] + a.v[2] * b.m[2][2] + a.v[3] * b.m[3][2],
                a.v[0] * b.m[0][3] + a.v[1] * b.m[1][3] + a.v[2] * b.m[2][3] + a.v[3] * b.m[3][3],
            },
        };
    }
};

pub const Quat = extern struct {
    q: [4]f32,

    pub inline fn init(x: f32, y: f32, z: f32, w: f32) Quat {
        return .{ .q = [_]f32{ x, y, z, w } };
    }

    pub inline fn initZero() Quat {
        const static = struct {
            const zero = init(0.0, 0.0, 0.0, 0.0);
        };
        return static.zero;
    }

    pub inline fn initIdentity() Quat {
        const static = struct {
            const identity = init(0.0, 0.0, 0.0, 1.0);
        };
        return static.identity;
    }

    pub inline fn approxEq(a: Quat, b: Quat, eps: f32) bool {
        return math.approxEq(f32, a.q[0], b.q[0], eps) and
            math.approxEq(f32, a.q[1], b.q[1], eps) and
            math.approxEq(f32, a.q[2], b.q[2], eps) and
            math.approxEq(f32, a.q[3], b.q[3], eps);
    }

    pub inline fn add(a: Quat, b: Quat) Quat {
        return .{ .q = [_]f32{ a.q[0] + b.q[0], a.q[1] + b.q[1], a.q[2] + b.q[2], a.q[3] + b.q[3] } };
    }

    pub inline fn mul(a: Quat, b: Quat) Quat {
        // Returns the product b * a (which is the concatenation of a rotation 'a' followed by the rotation 'b').
        return .{ .q = [_]f32{
            (b.q[3] * a.q[0]) + (b.q[0] * a.q[3]) + (b.q[1] * a.q[2]) - (b.q[2] * a.q[1]),
            (b.q[3] * a.q[1]) - (b.q[0] * a.q[2]) + (b.q[1] * a.q[3]) + (b.q[2] * a.q[0]),
            (b.q[3] * a.q[2]) + (b.q[0] * a.q[1]) - (b.q[1] * a.q[0]) + (b.q[2] * a.q[3]),
            (b.q[3] * a.q[3]) - (b.q[0] * a.q[0]) - (b.q[1] * a.q[1]) - (b.q[2] * a.q[2]),
        } };
    }

    pub inline fn scale(a: Quat, b: f32) Quat {
        return .{ .q = [_]f32{ a.q[0] * b, a.q[1] * b, a.q[2] * b, a.q[3] * b } };
    }

    pub inline fn dot(a: Quat, b: Quat) f32 {
        return a.q[0] * b.q[0] + a.q[1] * b.q[1] + a.q[2] * b.q[2] + a.q[3] * b.q[3];
    }

    pub inline fn length(a: Quat) f32 {
        return math.sqrt(dot(a, a));
    }

    pub inline fn lengthSq(a: Quat) f32 {
        return dot(a, a);
    }

    pub inline fn normalize(a: Quat) Quat {
        const len = length(a);
        assert(!math.approxEq(f32, len, 0.0, epsilon));
        const rcplen = 1.0 / len;
        return .{ .q = [_]f32{ rcplen * a.q[0], rcplen * a.q[1], rcplen * a.q[2], rcplen * a.q[3] } };
    }

    pub inline fn conj(a: Quat) Quat {
        return .{ .q = [_]f32{ -a.q[0], -a.q[1], -a.q[2], a.q[3] } };
    }

    pub inline fn inv(a: Quat) Quat {
        const lensq = lengthSq(a);
        const con = conj(a);
        assert(!math.approxEq(f32, lensq, 0.0, epsilon));
        const rcp_lensq = 1.0 / lensq;
        return con.scale(rcp_lensq);
    }

    pub inline fn slerp(a: Quat, b: Quat, t: f32) Quat {
        const cos_angle = dot(a, b);
        const angle = math.acos(cos_angle);

        const fa = math.sin((1.0 - t) * angle);
        const fb = math.sin(t * angle);

        const sin_angle = math.sin(angle);
        assert(!math.approxEq(f32, sin_angle, 0.0, epsilon));
        const rcp_sin_angle = 1.0 / sin_angle;

        const ra = a.scale(fa);
        const rb = b.scale(fb);
        return ra.add(rb).scale(rcp_sin_angle);
    }

    pub fn initRotationMat4(m: Mat4) Quat {
        var q: Quat = undefined;
        const r22 = m.m[2][2];
        if (r22 <= 0.0) // x^2 + y^2 >= z^2 + w^2
        {
            const dif10 = m.m[1][1] - m.m[0][0];
            const omr22 = 1.0 - r22;
            if (dif10 <= 0.0) // x^2 >= y^2
            {
                const fourXSqr = omr22 - dif10;
                const inv4x = 0.5 / math.sqrt(fourXSqr);
                q.q[0] = fourXSqr * inv4x;
                q.q[1] = (m.m[0][1] + m.m[1][0]) * inv4x;
                q.q[2] = (m.m[0][2] + m.m[2][0]) * inv4x;
                q.q[3] = (m.m[1][2] - m.m[2][1]) * inv4x;
            } else // y^2 >= x^2
            {
                const fourYSqr = omr22 + dif10;
                const inv4y = 0.5 / math.sqrt(fourYSqr);
                q.q[0] = (m.m[0][1] + m.m[1][0]) * inv4y;
                q.q[1] = fourYSqr * inv4y;
                q.q[2] = (m.m[1][2] + m.m[2][1]) * inv4y;
                q.q[3] = (m.m[2][0] - m.m[0][2]) * inv4y;
            }
        } else // z^2 + w^2 >= x^2 + y^2
        {
            const sum10 = m.m[1][1] + m.m[0][0];
            const opr22 = 1.0 + r22;
            if (sum10 <= 0.0) // z^2 >= w^2
            {
                const fourZSqr = opr22 - sum10;
                const inv4z = 0.5 / math.sqrt(fourZSqr);
                q.q[0] = (m.m[0][2] + m.m[2][0]) * inv4z;
                q.q[1] = (m.m[1][2] + m.m[2][1]) * inv4z;
                q.q[2] = fourZSqr * inv4z;
                q.q[3] = (m.m[0][1] - m.m[1][0]) * inv4z;
            } else // w^2 >= z^2
            {
                const fourWSqr = opr22 + sum10;
                const inv4w = 0.5 / math.sqrt(fourWSqr);
                q.q[0] = (m.m[1][2] - m.m[2][1]) * inv4w;
                q.q[1] = (m.m[2][0] - m.m[0][2]) * inv4w;
                q.q[2] = (m.m[0][1] - m.m[1][0]) * inv4w;
                q.q[3] = fourWSqr * inv4w;
            }
        }
        return q;
    }

    pub fn initRotationNormal(normal_axis: Vec3, angle: f32) Quat {
        const half_angle = 0.5 * angle;
        const sinv = math.sin(half_angle);
        const cosv = math.cos(half_angle);

        return .{ .q = [_]f32{
            normal_axis.v[0] * sinv,
            normal_axis.v[1] * sinv,
            normal_axis.v[2] * sinv,
            cosv,
        } };
    }

    pub fn initRotationAxis(axis: Vec3, angle: f32) Quat {
        assert(!axis.approxEq(Vec3.initZero(), epsilon));
        const n = axis.normalize();
        return initRotationNormal(n, angle);
    }
};

pub const Mat4 = extern struct {
    m: [4][4]f32,

    pub fn init(
        // zig fmt: off
        r0x: f32, r0y: f32, r0z: f32, r0w: f32,
        r1x: f32, r1y: f32, r1z: f32, r1w: f32,
        r2x: f32, r2y: f32, r2z: f32, r2w: f32,
        r3x: f32, r3y: f32, r3z: f32, r3w: f32,
        // zig fmt: on
    ) Mat4 {
        return .{
            .m = [_][4]f32{
                [_]f32{ r0x, r0y, r0z, r0w },
                [_]f32{ r1x, r1y, r1z, r1w },
                [_]f32{ r2x, r2y, r2z, r2w },
                [_]f32{ r3x, r3y, r3z, r3w },
            },
        };
    }

    pub fn initVec4(r0: Vec4, r1: Vec4, r2: Vec4, r3: Vec4) Mat4 {
        return .{
            .m = [_][4]f32{
                [_]f32{ r0.v[0], r0.v[1], r0.v[2], r0.v[3] },
                [_]f32{ r1.v[0], r1.v[1], r1.v[2], r1.v[3] },
                [_]f32{ r2.v[0], r2.v[1], r2.v[2], r2.v[3] },
                [_]f32{ r3.v[0], r3.v[1], r3.v[2], r3.v[3] },
            },
        };
    }

    pub inline fn approxEq(a: Mat4, b: Mat4, eps: f32) bool {
        return math.approxEq(f32, a.m[0][0], b.m[0][0], eps) and
            math.approxEq(f32, a.m[0][1], b.m[0][1], eps) and
            math.approxEq(f32, a.m[0][2], b.m[0][2], eps) and
            math.approxEq(f32, a.m[0][3], b.m[0][3], eps) and
            math.approxEq(f32, a.m[1][0], b.m[1][0], eps) and
            math.approxEq(f32, a.m[1][1], b.m[1][1], eps) and
            math.approxEq(f32, a.m[1][2], b.m[1][2], eps) and
            math.approxEq(f32, a.m[1][3], b.m[1][3], eps) and
            math.approxEq(f32, a.m[2][0], b.m[2][0], eps) and
            math.approxEq(f32, a.m[2][1], b.m[2][1], eps) and
            math.approxEq(f32, a.m[2][2], b.m[2][2], eps) and
            math.approxEq(f32, a.m[2][3], b.m[2][3], eps) and
            math.approxEq(f32, a.m[3][0], b.m[3][0], eps) and
            math.approxEq(f32, a.m[3][1], b.m[3][1], eps) and
            math.approxEq(f32, a.m[3][2], b.m[3][2], eps) and
            math.approxEq(f32, a.m[3][3], b.m[3][3], eps);
    }

    pub fn transpose(a: Mat4) Mat4 {
        return .{
            .m = [_][4]f32{
                [_]f32{ a.m[0][0], a.m[1][0], a.m[2][0], a.m[3][0] },
                [_]f32{ a.m[0][1], a.m[1][1], a.m[2][1], a.m[3][1] },
                [_]f32{ a.m[0][2], a.m[1][2], a.m[2][2], a.m[3][2] },
                [_]f32{ a.m[0][3], a.m[1][3], a.m[2][3], a.m[3][3] },
            },
        };
    }

    pub fn mul(a: Mat4, b: Mat4) Mat4 {
        return .{
            .m = [_][4]f32{
                [_]f32{
                    a.m[0][0] * b.m[0][0] + a.m[0][1] * b.m[1][0] + a.m[0][2] * b.m[2][0] + a.m[0][3] * b.m[3][0],
                    a.m[0][0] * b.m[0][1] + a.m[0][1] * b.m[1][1] + a.m[0][2] * b.m[2][1] + a.m[0][3] * b.m[3][1],
                    a.m[0][0] * b.m[0][2] + a.m[0][1] * b.m[1][2] + a.m[0][2] * b.m[2][2] + a.m[0][3] * b.m[3][2],
                    a.m[0][0] * b.m[0][3] + a.m[0][1] * b.m[1][3] + a.m[0][2] * b.m[2][3] + a.m[0][3] * b.m[3][3],
                },
                [_]f32{
                    a.m[1][0] * b.m[0][0] + a.m[1][1] * b.m[1][0] + a.m[1][2] * b.m[2][0] + a.m[1][3] * b.m[3][0],
                    a.m[1][0] * b.m[0][1] + a.m[1][1] * b.m[1][1] + a.m[1][2] * b.m[2][1] + a.m[1][3] * b.m[3][1],
                    a.m[1][0] * b.m[0][2] + a.m[1][1] * b.m[1][2] + a.m[1][2] * b.m[2][2] + a.m[1][3] * b.m[3][2],
                    a.m[1][0] * b.m[0][3] + a.m[1][1] * b.m[1][3] + a.m[1][2] * b.m[2][3] + a.m[1][3] * b.m[3][3],
                },
                [_]f32{
                    a.m[2][0] * b.m[0][0] + a.m[2][1] * b.m[1][0] + a.m[2][2] * b.m[2][0] + a.m[2][3] * b.m[3][0],
                    a.m[2][0] * b.m[0][1] + a.m[2][1] * b.m[1][1] + a.m[2][2] * b.m[2][1] + a.m[2][3] * b.m[3][1],
                    a.m[2][0] * b.m[0][2] + a.m[2][1] * b.m[1][2] + a.m[2][2] * b.m[2][2] + a.m[2][3] * b.m[3][2],
                    a.m[2][0] * b.m[0][3] + a.m[2][1] * b.m[1][3] + a.m[2][2] * b.m[2][3] + a.m[2][3] * b.m[3][3],
                },
                [_]f32{
                    a.m[3][0] * b.m[0][0] + a.m[3][1] * b.m[1][0] + a.m[3][2] * b.m[2][0] + a.m[3][3] * b.m[3][0],
                    a.m[3][0] * b.m[0][1] + a.m[3][1] * b.m[1][1] + a.m[3][2] * b.m[2][1] + a.m[3][3] * b.m[3][1],
                    a.m[3][0] * b.m[0][2] + a.m[3][1] * b.m[1][2] + a.m[3][2] * b.m[2][2] + a.m[3][3] * b.m[3][2],
                    a.m[3][0] * b.m[0][3] + a.m[3][1] * b.m[1][3] + a.m[3][2] * b.m[2][3] + a.m[3][3] * b.m[3][3],
                },
            },
        };
    }

    pub fn inv(a: Mat4, out_det: ?*f32) Mat4 {
        const mt = a.transpose();
        var v0: [4]Vec4 = undefined;
        var v1: [4]Vec4 = undefined;

        v0[0] = Vec4.init(mt.m[2][0], mt.m[2][0], mt.m[2][1], mt.m[2][1]);
        v1[0] = Vec4.init(mt.m[3][2], mt.m[3][3], mt.m[3][2], mt.m[3][3]);
        v0[1] = Vec4.init(mt.m[0][0], mt.m[0][0], mt.m[0][1], mt.m[0][1]);
        v1[1] = Vec4.init(mt.m[1][2], mt.m[1][3], mt.m[1][2], mt.m[1][3]);
        v0[2] = Vec4.init(mt.m[2][0], mt.m[2][2], mt.m[0][0], mt.m[0][2]);
        v1[2] = Vec4.init(mt.m[3][1], mt.m[3][3], mt.m[1][1], mt.m[1][3]);

        var d0 = v0[0].mul(v1[0]);
        var d1 = v0[1].mul(v1[1]);
        var d2 = v0[2].mul(v1[2]);

        v0[0] = Vec4.init(mt.m[2][2], mt.m[2][3], mt.m[2][2], mt.m[2][3]);
        v1[0] = Vec4.init(mt.m[3][0], mt.m[3][0], mt.m[3][1], mt.m[3][1]);
        v0[1] = Vec4.init(mt.m[0][2], mt.m[0][3], mt.m[0][2], mt.m[0][3]);
        v1[1] = Vec4.init(mt.m[1][0], mt.m[1][0], mt.m[1][1], mt.m[1][1]);
        v0[2] = Vec4.init(mt.m[2][1], mt.m[2][3], mt.m[0][1], mt.m[0][3]);
        v1[2] = Vec4.init(mt.m[3][0], mt.m[3][2], mt.m[1][0], mt.m[1][2]);

        d0 = v0[0].negMulAdd(v1[0], d0);
        d1 = v0[1].negMulAdd(v1[1], d1);
        d2 = v0[2].negMulAdd(v1[2], d2);

        v0[0] = Vec4.init(mt.m[1][1], mt.m[1][2], mt.m[1][0], mt.m[1][1]);
        v1[0] = Vec4.init(d2.v[1], d0.v[1], d0.v[3], d0.v[0]);
        v0[1] = Vec4.init(mt.m[0][2], mt.m[0][0], mt.m[0][1], mt.m[0][0]);
        v1[1] = Vec4.init(d0.v[3], d2.v[1], d0.v[1], d0.v[2]);
        v0[2] = Vec4.init(mt.m[3][1], mt.m[3][2], mt.m[3][0], mt.m[3][1]);
        v1[2] = Vec4.init(d2.v[3], d1.v[1], d1.v[3], d1.v[0]);
        v0[3] = Vec4.init(mt.m[2][2], mt.m[2][0], mt.m[2][1], mt.m[2][0]);
        v1[3] = Vec4.init(d1.v[3], d2.v[3], d1.v[1], d1.v[2]);

        var c0 = v0[0].mul(v1[0]);
        var c2 = v0[1].mul(v1[1]);
        var c4 = v0[2].mul(v1[2]);
        var c6 = v0[3].mul(v1[3]);

        v0[0] = Vec4.init(mt.m[1][2], mt.m[1][3], mt.m[1][1], mt.m[1][2]);
        v1[0] = Vec4.init(d0.v[3], d0.v[0], d0.v[1], d2.v[0]);
        v0[1] = Vec4.init(mt.m[0][3], mt.m[0][2], mt.m[0][3], mt.m[0][1]);
        v1[1] = Vec4.init(d0.v[2], d0.v[1], d2.v[0], d0.v[0]);
        v0[2] = Vec4.init(mt.m[3][2], mt.m[3][3], mt.m[3][1], mt.m[3][2]);
        v1[2] = Vec4.init(d1.v[3], d1.v[0], d1.v[1], d2.v[2]);
        v0[3] = Vec4.init(mt.m[2][3], mt.m[2][2], mt.m[2][3], mt.m[2][1]);
        v1[3] = Vec4.init(d1.v[2], d1.v[1], d2.v[2], d1.v[0]);

        c0 = v0[0].negMulAdd(v1[0], c0);
        c2 = v0[1].negMulAdd(v1[1], c2);
        c4 = v0[2].negMulAdd(v1[2], c4);
        c6 = v0[3].negMulAdd(v1[3], c6);

        v0[0] = Vec4.init(mt.m[1][3], mt.m[1][0], mt.m[1][3], mt.m[1][0]);
        v1[0] = Vec4.init(d0.v[2], d2.v[1], d2.v[0], d0.v[2]);
        v0[1] = Vec4.init(mt.m[0][1], mt.m[0][3], mt.m[0][0], mt.m[0][2]);
        v1[1] = Vec4.init(d2.v[1], d0.v[0], d0.v[3], d2.v[0]);
        v0[2] = Vec4.init(mt.m[3][3], mt.m[3][0], mt.m[3][3], mt.m[3][0]);
        v1[2] = Vec4.init(d1.v[2], d2.v[3], d2.v[2], d1.v[2]);
        v0[3] = Vec4.init(mt.m[2][1], mt.m[2][3], mt.m[2][0], mt.m[2][2]);
        v1[3] = Vec4.init(d2.v[3], d1.v[0], d1.v[3], d2.v[2]);

        const c1 = v0[0].negMulAdd(v1[0], c0);
        c0 = v0[0].mulAdd(v1[0], c0);

        const c3 = v0[1].mulAdd(v1[1], c2);
        c2 = v0[1].negMulAdd(v1[1], c2);

        const c5 = v0[2].negMulAdd(v1[2], c4);
        c4 = v0[2].mulAdd(v1[2], c4);

        const c7 = v0[3].mulAdd(v1[3], c6);
        c6 = v0[3].negMulAdd(v1[3], c6);

        var r = Mat4.initVec4(
            Vec4.init(c0.v[0], c1.v[1], c0.v[2], c1.v[3]),
            Vec4.init(c2.v[0], c3.v[1], c2.v[2], c3.v[3]),
            Vec4.init(c4.v[0], c5.v[1], c4.v[2], c5.v[3]),
            Vec4.init(c6.v[0], c7.v[1], c6.v[2], c7.v[3]),
        );

        const d = r.m[0][0] * mt.m[0][0] + r.m[0][1] * mt.m[0][1] + r.m[0][2] * mt.m[0][2] + r.m[0][3] * mt.m[0][3];
        if (out_det != null) {
            out_det.?.* = d;
        }

        if (math.approxEq(f32, d, 0.0, epsilon)) {
            return initZero();
        }

        const rcp_d = 1.0 / d;

        r.m[0][0] *= rcp_d;
        r.m[0][1] *= rcp_d;
        r.m[0][2] *= rcp_d;
        r.m[0][3] *= rcp_d;
        r.m[1][0] *= rcp_d;
        r.m[1][1] *= rcp_d;
        r.m[1][2] *= rcp_d;
        r.m[1][3] *= rcp_d;
        r.m[2][0] *= rcp_d;
        r.m[2][1] *= rcp_d;
        r.m[2][2] *= rcp_d;
        r.m[2][3] *= rcp_d;
        r.m[3][0] *= rcp_d;
        r.m[3][1] *= rcp_d;
        r.m[3][2] *= rcp_d;
        r.m[3][3] *= rcp_d;

        return r;
    }

    pub fn det(a: Mat4) f32 {
        const static = struct {
            const sign = Vec4.init(1.0, -1.0, 1.0, -1.0);
        };

        var v0 = Vec4.init(a.m[2][1], a.m[2][0], a.m[2][0], a.m[2][0]);
        var v1 = Vec4.init(a.m[3][2], a.m[3][2], a.m[3][1], a.m[3][1]);
        var v2 = Vec4.init(a.m[2][1], a.m[2][0], a.m[2][0], a.m[2][0]);
        var v3 = Vec4.init(a.m[3][3], a.m[3][3], a.m[3][3], a.m[3][2]);
        var v4 = Vec4.init(a.m[2][2], a.m[2][2], a.m[2][1], a.m[2][1]);
        var v5 = Vec4.init(a.m[3][3], a.m[3][3], a.m[3][3], a.m[3][2]);

        var p0 = v0.mul(v1);
        var p1 = v2.mul(v3);
        var p2 = v4.mul(v5);

        v0 = Vec4.init(a.m[2][2], a.m[2][2], a.m[2][1], a.m[2][1]);
        v1 = Vec4.init(a.m[3][1], a.m[3][0], a.m[3][0], a.m[3][0]);
        v2 = Vec4.init(a.m[2][3], a.m[2][3], a.m[2][3], a.m[2][2]);
        v3 = Vec4.init(a.m[3][1], a.m[3][0], a.m[3][0], a.m[3][0]);
        v4 = Vec4.init(a.m[2][3], a.m[2][3], a.m[2][3], a.m[2][2]);
        v5 = Vec4.init(a.m[3][2], a.m[3][2], a.m[3][1], a.m[3][1]);

        p0 = v0.negMulAdd(v1, p0);
        p1 = v2.negMulAdd(v3, p1);
        p2 = v4.negMulAdd(v5, p2);

        v0 = Vec4.init(a.m[1][3], a.m[1][3], a.m[1][3], a.m[1][2]);
        v1 = Vec4.init(a.m[1][2], a.m[1][2], a.m[1][1], a.m[1][1]);
        v2 = Vec4.init(a.m[1][1], a.m[1][0], a.m[1][0], a.m[1][0]);

        var s = Vec4.init(a.m[0][0], a.m[0][1], a.m[0][2], a.m[0][3]).mul(static.sign);
        var r = v0.mul(p0);
        r = v1.negMulAdd(p1, r);
        r = v2.mulAdd(p2, r);

        return s.dot(r);
    }

    pub fn initRotationX(angle: f32) Mat4 {
        const sinv = math.sin(angle);
        const cosv = math.cos(angle);
        return .{
            .m = [_][4]f32{
                [_]f32{ 1.0, 0.0, 0.0, 0.0 },
                [_]f32{ 0.0, cosv, sinv, 0.0 },
                [_]f32{ 0.0, -sinv, cosv, 0.0 },
                [_]f32{ 0.0, 0.0, 0.0, 1.0 },
            },
        };
    }

    pub fn initRotationY(angle: f32) Mat4 {
        const sinv = math.sin(angle);
        const cosv = math.cos(angle);
        return .{
            .m = [_][4]f32{
                [_]f32{ cosv, 0.0, -sinv, 0.0 },
                [_]f32{ 0.0, 1.0, 0.0, 0.0 },
                [_]f32{ sinv, 0.0, cosv, 0.0 },
                [_]f32{ 0.0, 0.0, 0.0, 1.0 },
            },
        };
    }

    pub fn initRotationZ(angle: f32) Mat4 {
        const sinv = math.sin(angle);
        const cosv = math.cos(angle);
        return .{
            .m = [_][4]f32{
                [_]f32{ cosv, sinv, 0.0, 0.0 },
                [_]f32{ -sinv, cosv, 0.0, 0.0 },
                [_]f32{ 0.0, 0.0, 1.0, 0.0 },
                [_]f32{ 0.0, 0.0, 0.0, 1.0 },
            },
        };
    }

    pub fn initRotationQuat(q: Quat) Mat4 {
        const static = struct {
            const const1110 = Vec4.init(1.0, 1.0, 1.0, 0.0);
        };
        const vin = Vec4.init(q.q[0], q.q[1], q.q[2], q.q[3]);

        const q0 = vin.add(vin);
        const q1 = vin.mul(q0);

        var v0 = Vec4.init(q1.v[1], q1.v[0], q1.v[0], static.const1110.v[3]);
        var v1 = Vec4.init(q1.v[2], q1.v[2], q1.v[1], static.const1110.v[3]);
        var r0 = static.const1110.sub(v0);
        r0 = r0.sub(v1);

        v0 = Vec4.init(vin.v[0], vin.v[0], vin.v[1], vin.v[3]);
        v1 = Vec4.init(q0.v[2], q0.v[1], q0.v[2], q0.v[3]);
        v0 = v0.mul(v1);

        v1 = Vec4.init(vin.v[3], vin.v[3], vin.v[3], vin.v[3]);
        var v2 = Vec4.init(q0.v[1], q0.v[2], q0.v[0], q0.v[3]);
        v1 = v1.mul(v2);

        var r1 = v0.add(v1);
        var r2 = v0.sub(v1);

        v0 = Vec4.init(r1.v[1], r2.v[0], r2.v[1], r1.v[2]);
        v1 = Vec4.init(r1.v[0], r2.v[2], r1.v[0], r2.v[2]);

        return Mat4.initVec4(
            Vec4.init(r0.v[0], v0.v[0], v0.v[1], r0.v[3]),
            Vec4.init(v0.v[2], r0.v[1], v0.v[3], r0.v[3]),
            Vec4.init(v1.v[0], v1.v[1], r0.v[2], r0.v[3]),
            Vec4.init(0.0, 0.0, 0.0, 1.0),
        );
    }

    pub fn initPerspectiveFovLh(fovy: f32, aspect: f32, near: f32, far: f32) Mat4 {
        const sinfov = math.sin(0.5 * fovy);
        const cosfov = math.cos(0.5 * fovy);

        assert(near > 0.0 and far > 0.0 and far > near);
        assert(!math.approxEq(f32, sinfov, 0.0, 0.001));
        assert(!math.approxEq(f32, far, near, 0.001));
        assert(!math.approxEq(f32, aspect, 0.0, 0.01));

        const h = cosfov / sinfov;
        const w = h / aspect;
        const r = far / (far - near);
        return .{
            .m = [_][4]f32{
                [_]f32{ w, 0.0, 0.0, 0.0 },
                [_]f32{ 0.0, h, 0.0, 0.0 },
                [_]f32{ 0.0, 0.0, r, 1.0 },
                [_]f32{ 0.0, 0.0, -r * near, 0.0 },
            },
        };
    }

    pub inline fn initZero() Mat4 {
        const static = struct {
            const zero = Mat4{
                .m = [_][4]f32{
                    [_]f32{ 0.0, 0.0, 0.0, 0.0 },
                    [_]f32{ 0.0, 0.0, 0.0, 0.0 },
                    [_]f32{ 0.0, 0.0, 0.0, 0.0 },
                    [_]f32{ 0.0, 0.0, 0.0, 0.0 },
                },
            };
        };
        return static.zero;
    }

    pub inline fn initIdentity() Mat4 {
        const static = struct {
            const identity = Mat4{
                .m = [_][4]f32{
                    [_]f32{ 1.0, 0.0, 0.0, 0.0 },
                    [_]f32{ 0.0, 1.0, 0.0, 0.0 },
                    [_]f32{ 0.0, 0.0, 1.0, 0.0 },
                    [_]f32{ 0.0, 0.0, 0.0, 1.0 },
                },
            };
        };
        return static.identity;
    }

    pub fn initTranslation(a: Vec3) Mat4 {
        return .{
            .m = [_][4]f32{
                [_]f32{ 1.0, 0.0, 0.0, 0.0 },
                [_]f32{ 0.0, 1.0, 0.0, 0.0 },
                [_]f32{ 0.0, 0.0, 1.0, 0.0 },
                [_]f32{ a.v[0], a.v[1], a.v[2], 1.0 },
            },
        };
    }

    pub fn initScaling(a: Vec3) Mat4 {
        return .{
            .m = [_][4]f32{
                [_]f32{ a.v[0], 0.0, 0.0, 0.0 },
                [_]f32{ 0.0, a.v[1], 0.0, 0.0 },
                [_]f32{ 0.0, 0.0, a.v[2], 0.0 },
                [_]f32{ 0.0, 0.0, 0.0, 1.0 },
            },
        };
    }

    pub fn initLookToLh(eye_pos: Vec3, eye_dir: Vec3, up_dir: Vec3) Mat4 {
        const az = Vec3.normalize(eye_dir);
        const ax = Vec3.normalize(Vec3.cross(up_dir, az));
        const ay = Vec3.normalize(Vec3.cross(az, ax));
        return .{
            .m = [_][4]f32{
                [_]f32{ ax.v[0], ay.v[0], az.v[0], 0.0 },
                [_]f32{ ax.v[1], ay.v[1], az.v[1], 0.0 },
                [_]f32{ ax.v[2], ay.v[2], az.v[2], 0.0 },
                [_]f32{ -Vec3.dot(ax, eye_pos), -Vec3.dot(ay, eye_pos), -Vec3.dot(az, eye_pos), 1.0 },
            },
        };
    }

    pub inline fn initLookAtLh(eye_pos: Vec3, focus_pos: Vec3, up_dir: Vec3) Mat4 {
        return initLookToLh(eye_pos, focus_pos.sub(eye_pos), up_dir);
    }

    pub fn initOrthoOffCenterLh(
        view_left: f32,
        view_right: f32,
        view_bottom: f32,
        view_top: f32,
        near_z: f32,
        far_z: f32,
    ) Mat4 {
        assert(!math.approxEq(f32, view_right, view_left, 0.001));
        assert(!math.approxEq(f32, view_top, view_bottom, 0.001));
        assert(!math.approxEq(f32, far_z, near_z, 0.001));

        const rcp_w = 1.0 / (view_right - view_left);
        const rcp_h = 1.0 / (view_top - view_bottom);
        const range = 1.0 / (far_z - near_z);

        return .{
            .m = [_][4]f32{
                [_]f32{ rcp_w + rcp_w, 0.0, 0.0, 0.0 },
                [_]f32{ 0.0, rcp_h + rcp_h, 0.0, 0.0 },
                [_]f32{ 0.0, 0.0, range, 0.0 },
                [_]f32{ -(view_left + view_right) * rcp_w, -(view_top + view_bottom) * rcp_h, -range * near_z, 1.0 },
            },
        };
    }
};

test "dot" {
    {
        const a = Vec2.init(1.0, 2.0);
        const b = Vec2.init(3.0, 4.0);
        assert(math.approxEq(f32, a.dot(b), 11.0, epsilon));
    }
    {
        const a = Vec3.init(1.0, 2.0, 3.0);
        const b = Vec3.init(4.0, 5.0, 6.0);
        assert(math.approxEq(f32, a.dot(b), 32.0, epsilon));
    }
    {
        const a = Vec4.init(1.0, 2.0, 3.0, 4.0);
        const b = Vec4.init(5.0, 6.0, 7.0, 8.0);
        assert(math.approxEq(f32, a.dot(b), 70.0, epsilon));
    }
}

test "cross" {
    {
        const a = Vec3.init(1.0, 0.0, 0.0);
        const b = Vec3.init(0.0, 1.0, 0.0);
        assert(a.cross(b).approxEq(Vec3.init(0.0, 0.0, 1.0), epsilon));
    }
    {
        const a = Vec3.init(0.0, 0.0, -1.0);
        const b = Vec3.init(1.0, 0.0, 0.0);
        assert(a.cross(b).approxEq(Vec3.init(0.0, -1.0, 0.0), epsilon));
    }
}

test "VecN add, sub, scale" {
    {
        const a = Vec2.init(1.0, 2.0);
        const b = Vec2.init(3.0, 4.0);
        assert(a.add(b).approxEq(Vec2.init(4.0, 6.0), epsilon));
    }
    {
        const a = Vec3.init(1.0, 2.0, 3.0);
        const b = Vec3.init(3.0, 4.0, 5.0);
        assert(a.add(b).approxEq(Vec3.init(4.0, 6.0, 8.0), epsilon));
    }
    {
        const a = Vec4.init(1.0, 2.0, 3.0, -1.0);
        const b = Vec4.init(3.0, 4.0, 5.0, 2.0);
        assert(a.add(b).approxEq(Vec4.init(4.0, 6.0, 8.0, 1.0), epsilon));
    }
    {
        const a = Vec2.init(1.0, 2.0);
        const b = Vec2.init(3.0, 4.0);
        assert(a.sub(b).approxEq(Vec2.init(-2.0, -2.0), epsilon));
    }
    {
        const a = Vec3.init(1.0, 2.0, 3.0);
        const b = Vec3.init(3.0, 4.0, 5.0);
        assert(a.sub(b).approxEq(Vec3.init(-2.0, -2.0, -2.0), epsilon));
    }
    {
        const a = Vec4.init(1.0, 2.0, 3.0, -1.0);
        const b = Vec4.init(3.0, 4.0, 5.0, 2.0);
        assert(a.sub(b).approxEq(Vec4.init(-2.0, -2.0, -2.0, -3.0), epsilon));
    }
    {
        const a = Vec2.init(1.0, 2.0);
        assert(a.scale(2.0).approxEq(Vec2.init(2.0, 4.0), epsilon));
    }
    {
        const a = Vec3.init(1.0, 2.0, 3.0);
        assert(a.scale(-1.0).approxEq(Vec3.init(-1.0, -2.0, -3.0), epsilon));
    }
    {
        const a = Vec4.init(1.0, 2.0, 3.0, -1.0);
        assert(a.scale(3.0).approxEq(Vec4.init(3.0, 6.0, 9.0, -3.0), epsilon));
    }
}

test "length, normalize" {
    {
        const a = Vec2.init(2.0, 3.0).length();
        assert(math.approxEq(f32, a, 3.60555, epsilon));
    }
    {
        const a = Vec3.init(1.0, 1.0, 1.0).length();
        assert(math.approxEq(f32, a, 1.73205, epsilon));
    }
    {
        const a = Vec4.init(1.0, 1.0, 1.0, 1.0).length();
        assert(math.approxEq(f32, a, 2.0, epsilon));
    }
    {
        const a = Vec2.init(2.0, 4.0).normalize();
        assert(Vec2.approxEq(a, Vec2.init(0.447214, 0.894427), epsilon));
    }
    {
        const a = Vec3.init(2.0, -5.0, 4.0).normalize();
        assert(Vec3.approxEq(a, Vec3.init(0.298142, -0.745356, 0.596285), epsilon));
    }
    {
        const a = Vec4.init(-1.0, 2.0, -5.0, 4.0).normalize();
        assert(Vec4.approxEq(a, Vec4.init(-0.147442, 0.294884, -0.73721, 0.589768), epsilon));
    }
    {
        const a = Quat.init(-1.0, 2.0, -5.0, 4.0).normalize();
        assert(Quat.approxEq(a, Quat.init(-0.147442, 0.294884, -0.73721, 0.589768), epsilon));
    }
}

test "Mat4 transpose" {
    const m = Mat4.initVec4(
        Vec4.init(1.0, 2.0, 3.0, 4.0),
        Vec4.init(5.0, 6.0, 7.0, 8.0),
        Vec4.init(9.0, 10.0, 11.0, 12.0),
        Vec4.init(13.0, 14.0, 15.0, 16.0),
    );
    const mt = m.transpose();
    assert(
        mt.approxEq(
            Mat4.init(1.0, 5.0, 9.0, 13.0, 2.0, 6.0, 10.0, 14.0, 3.0, 7.0, 11.0, 15.0, 4.0, 8.0, 12.0, 16.0),
            epsilon,
        ),
    );
}

test "Mat4 mul" {
    const a = Mat4.initVec4(
        Vec4.init(0.1, 0.2, 0.3, 0.4),
        Vec4.init(0.5, 0.6, 0.7, 0.8),
        Vec4.init(0.9, 1.0, 1.1, 1.2),
        Vec4.init(1.3, 1.4, 1.5, 1.6),
    );
    const b = Mat4.initVec4(
        Vec4.init(1.7, 1.8, 1.9, 2.0),
        Vec4.init(2.1, 2.2, 2.3, 2.4),
        Vec4.init(2.5, 2.6, 2.7, 2.8),
        Vec4.init(2.9, 3.0, 3.1, 3.2),
    );
    const c = a.mul(b);
    assert(c.approxEq(
        Mat4.initVec4(
            Vec4.init(2.5, 2.6, 2.7, 2.8),
            Vec4.init(6.18, 6.44, 6.7, 6.96),
            Vec4.init(9.86, 10.28, 10.7, 11.12),
            Vec4.init(13.54, 14.12, 14.7, 15.28),
        ),
        epsilon,
    ));
}

test "Mat4 inv, det" {
    var m = Mat4.initVec4(
        Vec4.init(10.0, -9.0, -12.0, 1.0),
        Vec4.init(7.0, -12.0, 11.0, 1.0),
        Vec4.init(-10.0, 10.0, 3.0, 1.0),
        Vec4.init(1.0, 2.0, 3.0, 4.0),
    );
    assert(math.approxEq(f32, m.det(), 2939.0, epsilon));

    var det: f32 = 0.0;
    m = m.inv(&det);
    assert(math.approxEq(f32, det, 2939.0, epsilon));
    assert(m.approxEq(
        Mat4.initVec4(
            Vec4.init(-0.170806, -0.13576, -0.349439, 0.164001),
            Vec4.init(-0.163661, -0.14801, -0.253147, 0.141204),
            Vec4.init(-0.0871045, 0.00646478, -0.0785982, 0.0398095),
            Vec4.init(0.18986, 0.103096, 0.272882, 0.10854),
        ),
        epsilon,
    ));
}

test "Quat mul, inv" {
    {
        const a = Quat.init(2.0, 3.0, 4.0, 1.0);
        const b = Quat.init(6.0, 7.0, 8.0, 5.0);
        assert(a.mul(b).approxEq(Quat.init(20.0, 14.0, 32.0, -60.0), epsilon));
        assert(b.mul(a).approxEq(Quat.init(12.0, 30.0, 24.0, -60.0), epsilon));
    }
    {
        const a = Quat.init(2.0, 3.0, 4.0, 1.0);
        const b = a.inv();
        assert(a.approxEq(Quat.init(2.0, 3.0, 4.0, 1.0), epsilon));
        assert(b.approxEq(Quat.init(-0.0666667, -0.1, -0.133333, 0.0333333), epsilon));
    }
}

test "Mat4 transforms" {
    const a = Mat4.initTranslation(Vec3.init(1.0, 0.0, 0.0));
    const b = Mat4.initRotationY(math.pi * 0.5);
    const c = Vec3.init(1.0, 0.0, 0.0);
    const e = Mat4.initTranslation(Vec3.init(0.0, 1.0, 0.0));
    const d = c.transform(a.mul(b).mul(e));
    assert(d.approxEq(Vec3.init(0.0, 1.0, -2.0), epsilon));
}

test "Mat4 <-> Quat" {
    {
        const a = Quat.initRotationMat4(Mat4.initIdentity());
        assert(a.approxEq(Quat.initIdentity(), epsilon));
        const b = Mat4.initRotationQuat(a);
        assert(b.approxEq(Mat4.initIdentity(), epsilon));
    }
    {
        const a = Quat.initRotationMat4(Mat4.initTranslation(Vec3.init(1.0, 2.0, 3.0)));
        assert(a.approxEq(Quat.initIdentity(), epsilon));
        const b = Mat4.initRotationQuat(a);
        assert(b.approxEq(Mat4.initIdentity(), epsilon));
    }
    {
        const a = Quat.initRotationMat4(Mat4.initRotationY(math.pi * 0.5));
        const b = Mat4.initRotationQuat(a);
        assert(b.approxEq(Mat4.initRotationY(math.pi * 0.5), epsilon));
    }
    {
        const a = Quat.initRotationMat4(Mat4.initRotationY(math.pi * 0.25));
        const b = Quat.initRotationAxis(Vec3.init(0.0, 1.0, 0.0), math.pi * 0.25);
        assert(a.approxEq(b, epsilon));
    }
    {
        const m0 = Mat4.initRotationX(math.pi * 0.125);
        const m1 = Mat4.initRotationY(math.pi * 0.25);
        const m2 = Mat4.initRotationZ(math.pi * 0.5);

        const q0 = Quat.initRotationMat4(m0);
        const q1 = Quat.initRotationMat4(m1);
        const q2 = Quat.initRotationMat4(m2);

        const mr = m0.mul(m1).mul(m2);
        const qr = q0.mul(q1).mul(q2);

        assert(mr.approxEq(Mat4.initRotationQuat(qr), epsilon));
        assert(qr.approxEq(Quat.initRotationMat4(mr), epsilon));
    }
}

test "slerp" {
    const from = Quat.init(0.0, 0.0, 0.0, 1.0);
    const to = Quat.init(0.5, 0.5, -0.5, 0.5);
    const result = from.slerp(to, 0.5);
    assert(result.approxEq(Quat.init(0.28867513, 0.28867513, -0.28867513, 0.86602540), epsilon));
}
