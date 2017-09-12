/** D wrapper around hashx4, here https://github.com/cleeus/hashx4.

    Provides wrappers for C implementations of :

    - DJBX33A hash function by Daniel Bernstein (h_i+1 = h_i * 33 + c_i+1, h_0 = 5381)
 */
module bhashx4;

version = HX4_HAS_MMX;
version = HX4_HAS_SSE2;
version = HX4_HAS_SSE3;

// See also: http://forum.dlang.org/post/slkijfrqmhnlaayxtyif@forum.dlang.org
extern(C)
{
    int hx4_djbx33a_32_ref     (in ubyte *in_, size_t in_sz,
                                in ubyte *cookie, size_t cookie_sz,
                                scope ubyte *out_, size_t out_sz);
    int hx4_djbx33a_32_copt    (in ubyte *in_, size_t in_sz,
                                in ubyte *cookie, size_t cookie_sz,
                                scope ubyte *out_, size_t out_sz);

    /** DJBX33A
     */

    /// reference implementation
    int hx4_x4djbx33a_128_ref  (in ubyte *in_, size_t in_sz,
                                in ubyte *cookie, size_t cookie_sz,
                                scope ubyte *out_, size_t out_sz);

    /// optimized implementation
    int hx4_x4djbx33a_128_copt (in ubyte *in_, size_t in_sz,
                                in ubyte *cookie, size_t cookie_sz,
                                scope ubyte *out_, size_t out_sz);

    version(HX4_HAS_MMX)
    {
        int hx4_x4djbx33a_128_mmx  (in ubyte *in_, size_t in_sz,
                                    in ubyte *cookie, size_t cookie_sz,
                                    scope ubyte *out_, size_t out_sz);
    }

    version(HX4_HAS_SSE2)
    {
        int hx4_x4djbx33a_128_sse2 (in ubyte *in_, size_t in_sz,
                                    in ubyte *cookie, size_t cookie_sz,
                                    scope ubyte *out_, size_t out_sz);
    }

    version(HX4_HAS_SSE3)
    {
        int hx4_x4djbx33a_128_ssse3(in ubyte *in_, size_t in_sz,
                                    in ubyte *cookie, size_t cookie_sz,
                                    scope ubyte *out_, size_t out_sz);
    }

    int hx4_siphash24_64_ref   (in ubyte *in_, size_t in_sz,
                                in ubyte *cookie, size_t cookie_sz,
                                scope ubyte *out_, size_t out_sz);

    int hx4_siphash24_64_copt  (in ubyte *in_, size_t in_sz,
                                in ubyte *cookie, size_t cookie_sz,
                                scope ubyte *out_, size_t out_sz);
}

// version = show;

///
unittest
{

    const nbits = 128;

    const ubyte[nbits/8] in_ = 42;
    const ubyte[nbits/8] cookie = 10;

    version(show) writeln(`in_:`, in_);
    version(show) writeln(`cookie`, cookie);

    ubyte[nbits/8] out_ref;
    assert(hx4_x4djbx33a_128_ref(in_.ptr, in_.length,
                                 cookie.ptr, cookie.length,
                                 out_ref.ptr, out_ref.length) == 0);
    version(show) writeln(`out_ref: `, out_ref);

    ubyte[nbits/8] out_copt;
    assert(hx4_x4djbx33a_128_copt(in_.ptr, in_.length,
                                  cookie.ptr, cookie.length,
                                  out_copt.ptr, out_copt.length) == 0);
    assert(out_ref == out_copt);
    version(show) writeln(`out_opt: `, out_copt);

    ubyte[nbits/8] out_mmx;
    assert(hx4_x4djbx33a_128_mmx(in_.ptr, in_.length,
                                 cookie.ptr, cookie.length,
                                 out_mmx.ptr, out_mmx.length) == 0);
    assert(out_ref == out_mmx);
    version(show) writeln(`out_mmx: `, out_mmx);

    ubyte[nbits/8] out_sse2;
    assert(hx4_x4djbx33a_128_sse2(in_.ptr, in_.length,
                                  cookie.ptr, cookie.length,
                                  out_sse2.ptr, out_sse2.length) == 0);
    assert(out_ref == out_sse2);
    version(show) writeln(`out_sse2:`, out_sse2);

    ubyte[nbits/8] out_sse3;
    assert(hx4_x4djbx33a_128_ssse3(in_.ptr, in_.length,
                                   cookie.ptr, cookie.length,
                                   out_sse3.ptr, out_sse3.length) == 0);
    assert(out_ref == out_sse3);

    version(show) writeln(`out_sse3:`, out_sse3);
}

version(show)
{
    import std.stdio : writeln;
}
