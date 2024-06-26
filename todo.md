# Byte/bit manipulation

* byteswap - https://godbolt.org/z/Pj33EjrTq
    * no architecture has 16-bit, only do 32/64
    * risc-v requires `zbb`
    * `i{32,64}.swap_bytes`
    * uses
        * networking
        * object files
        * https://github.com/tkaitchuck/aHash/issues/222

# Overflowing arithmetic

* wide multiplication - https://godbolt.org/z/hq77Mc4x8
    * `i64.mul_wide_{s,u} : [i64 i64] -> [i64 i64]`

* overflow flag - https://godbolt.org/z/cj7dY8PbP
