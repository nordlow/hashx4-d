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
    int hx4_x4djbx33a_128_ref  (in ubyte *in_, size_t in_sz,
                                in ubyte *cookie, size_t cookie_sz,
                                scope ubyte *out_, size_t out_sz);
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

    int hx4_siphash24_64_ref   (in ubyte *in_, size_t in_sz, in ubyte *cookie, size_t cookie_sz, scope ubyte *out_, size_t out_sz);
    int hx4_siphash24_64_copt  (in ubyte *in_, size_t in_sz, in ubyte *cookie, size_t cookie_sz, scope ubyte *out_, size_t out_sz);
}

unittest
{
    import std.stdio : writeln;

    const nbits = 128;

    const ubyte[nbits/8] in_ = 42;
    const ubyte[nbits/8] cookie = 10;
    ubyte[nbits/8] out_;

    writeln(`in_:`, in_);
    writeln(`cookie`, cookie);
    writeln(`out_:`, out_);

    pragma(msg, typeof(out_.ptr));
    const ret = hx4_x4djbx33a_128_ssse3(in_.ptr, in_.length,
                                        cookie.ptr, cookie.length,
                                        out_.ptr, out_.length);

    writeln(`ret:`, ret);
    writeln(`out_:`, out_);
}
