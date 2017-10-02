/** D wrapper around hashx4, here https://github.com/cleeus/hashx4.

    Provides wrappers for C implementations of :

    - SipHash
    - DJBX33A: by Daniel Bernstein (h_i+1 = h_i * 33 + c_i+1, h_0 = 5381)

    TODO reverse order of pointer and length to for better performance when
    called from D wrappers.
 */
module bhashx4;

// TODO implement
struct SipHash24
{
    void put(scope const(ubyte)[] data...)
    {
    }

    void start()
    {
    }

    ubyte[16] finish()
    {
        return typeof(return).init;
    }
}

ubyte[8] gethash_SipHash24_64(scope const(ubyte)[] data...)
{
    typeof(return) sum;
    const ubyte[cookie_nbits/8] cookie = 10;
    hx4_siphash24_64_copt(data.ptr, data.length,
                          cookie.ptr, cookie.length,
                          sum.ptr, sum.length);
    return sum;
}

version = HX4_HAS_MMX;
version = HX4_HAS_SSE2;
version = HX4_HAS_SSE3;

// See also: http://forum.dlang.org/post/slkijfrqmhnlaayxtyif@forum.dlang.org
extern(C)
{
    /** DJBX33A 32-bit reference implementation. */
    int hx4_djbx33a_32_ref     (in ubyte *data_ptr, size_t data_sz,
                                in ubyte *cookie, size_t cookie_sz,
                                scope ubyte *sum, size_t sum_sz);

    /** DJBX33A 32-bit optimized implementation. */
    int hx4_djbx33a_32_copt    (in ubyte *data_ptr, size_t data_sz,
                                in ubyte *cookie, size_t cookie_sz,
                                scope ubyte *sum, size_t sum_sz);

    /** DJBX33A 128-bit reference implementation. */
    int hx4_x4djbx33a_128_ref  (in ubyte *data_ptr, size_t data_sz,
                                in ubyte *cookie, size_t cookie_sz,
                                scope ubyte *sum, size_t sum_sz);

    /** DJBX33A 128-bit optimized implementation. */
    int hx4_x4djbx33a_128_copt (in ubyte *data_ptr, size_t data_sz,
                                in ubyte *cookie, size_t cookie_sz,
                                scope ubyte *sum, size_t sum_sz);

    version(HX4_HAS_MMX)
    {
        int hx4_x4djbx33a_128_mmx  (in ubyte *data_ptr, size_t data_sz,
                                    in ubyte *cookie, size_t cookie_sz,
                                    scope ubyte *sum, size_t sum_sz);
    }

    version(HX4_HAS_SSE2)
    {
        int hx4_x4djbx33a_128_sse2 (in ubyte *data_ptr, size_t data_sz,
                                    in ubyte *cookie, size_t cookie_sz,
                                    scope ubyte *sum, size_t sum_sz);
    }

    version(HX4_HAS_SSE3)
    {
        int hx4_x4djbx33a_128_ssse3(in ubyte *data_ptr, size_t data_sz,
                                    in ubyte *cookie, size_t cookie_sz,
                                    scope ubyte *sum, size_t sum_sz);
    }
}

// version = show;

enum cookie_nbits = 128;

/// DJBX33A
unittest
{
    const nbits = 128;

    const ubyte[nbits/8] data = 42;
    const ubyte[cookie_nbits/8] cookie = 10;

    version(show) writeln(`data:`, data);
    version(show) writeln(`cookie`, cookie);

    ubyte[nbits/8] sum_ref;
    assert(hx4_x4djbx33a_128_ref(data.ptr, data.length,
                                 cookie.ptr, cookie.length,
                                 sum_ref.ptr, sum_ref.length) == 0);
    version(show) writeln(`sum_ref: `, sum_ref);

    ubyte[nbits/8] sum_copt;
    assert(hx4_x4djbx33a_128_copt(data.ptr, data.length,
                                  cookie.ptr, cookie.length,
                                  sum_copt.ptr, sum_copt.length) == 0);
    assert(sum_ref == sum_copt);
    version(show) writeln(`sum_copt: `, sum_copt);

    ubyte[nbits/8] sum_mmx;
    assert(hx4_x4djbx33a_128_mmx(data.ptr, data.length,
                                 cookie.ptr, cookie.length,
                                 sum_mmx.ptr, sum_mmx.length) == 0);
    assert(sum_ref == sum_mmx);
    version(show) writeln(`sum_mmx: `, sum_mmx);

    ubyte[nbits/8] sum_sse2;
    assert(hx4_x4djbx33a_128_sse2(data.ptr, data.length,
                                  cookie.ptr, cookie.length,
                                  sum_sse2.ptr, sum_sse2.length) == 0);
    assert(sum_ref == sum_sse2);
    version(show) writeln(`sum_sse2:`, sum_sse2);

    ubyte[nbits/8] sum_sse3;
    assert(hx4_x4djbx33a_128_ssse3(data.ptr, data.length,
                                   cookie.ptr, cookie.length,
                                   sum_sse3.ptr, sum_sse3.length) == 0);
    assert(sum_ref == sum_sse3);

    version(show) writeln(`sum_sse3:`, sum_sse3);
}

extern(C)
{
    /** SipHash 24 reference implementation.
        See also: https://131002.net/siphash/
     */
    int hx4_siphash24_64_ref(in ubyte *data_ptr, size_t data_sz,
                             in ubyte *cookie, size_t cookie_sz,
                             scope ubyte *sum, size_t sum_sz);

    /** SipHash 24 optimized implementation.
        See also: https://131002.net/siphash/
     */
    int hx4_siphash24_64_copt(in ubyte *data_ptr, size_t data_sz,
                              in ubyte *cookie, size_t cookie_sz,
                              scope ubyte *sum, size_t sum_sz);
}

/// SipHash 24
unittest
{
    const siphash_nbits = 64;

    const ubyte[siphash_nbits/8] data = 42;
    const ubyte[cookie_nbits/8] cookie = 10;

    ubyte[siphash_nbits/8] sum_ref;
    assert(hx4_siphash24_64_ref(data.ptr, data.length,
                                cookie.ptr, cookie.length,
                                sum_ref.ptr, sum_ref.length) == 0);
    version(show) writeln(`sum_ref:`, sum_ref);

    ubyte[siphash_nbits/8] sum_copt;
    assert(hx4_siphash24_64_copt(data.ptr, data.length,
                                 cookie.ptr, cookie.length,
                                 sum_copt.ptr, sum_copt.length) == 0);
    version(show) writeln(`sum_copt:`, sum_copt);
    assert(sum_ref == sum_copt);
}

version(show)
{
    import std.stdio : writeln;
}
