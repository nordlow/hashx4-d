module hashx4;

extern(C)
{
    int hx4_djbx33a_32_ref     (const void *in_, size_t in_sz, const void *cookie, size_t cookie_sz, void *out_, size_t out_sz);
    int hx4_djbx33a_32_copt    (const void *in_, size_t in_sz, const void *cookie, size_t cookie_sz, void *out_, size_t out_sz);
    int hx4_x4djbx33a_128_ref  (const void *in_, size_t in_sz, const void *cookie, size_t cookie_sz, void *out_, size_t out_sz);
    int hx4_x4djbx33a_128_copt (const void *in_, size_t in_sz, const void *cookie, size_t cookie_sz, void *out_, size_t out_sz);

    version(HX4_HAS_MMX)
    int hx4_x4djbx33a_128_mmx  (const void *in_, size_t in_sz, const void *cookie, size_t cookie_sz, void *out_, size_t out_sz);

    version(HX4_HAS_SSE2)
    int hx4_x4djbx33a_128_sse2 (const void *in_, size_t in_sz, const void *cookie, size_t cookie_sz, void *out_, size_t out_sz);

    version(HX4_HAS_SSE3)
    int hx4_x4djbx33a_128_ssse3(const void *in_, size_t in_sz,
                                const void *cookie, size_t cookie_sz,
                                void *out_, size_t out_sz);

    int hx4_siphash24_64_ref   (const void *in_, size_t in_sz, const void *cookie, size_t cookie_sz, void *out_, size_t out_sz);
    int hx4_siphash24_64_copt  (const void *in_, size_t in_sz, const void *cookie, size_t cookie_sz, void *out_, size_t out_sz);
}

@safe pure nothrow @nogc unittest
{
}
