(assert_invalid
  (module
    (func (param i32) (result i32) (i32.swap_bytes (local.get 0)))
  )
  "alex's private proposal support is not enabled")

(assert_invalid
  (module
    (func (param i64) (result i64) (i64.swap_bytes (local.get 0)))
  )
  "alex's private proposal support is not enabled")

(assert_invalid
  (module
    (func (param i64 i64) (result i64)
      (i64.mul_wide_s (local.get 0) (local.get 1))
      i64.mul
    )
  )
  "alex's private proposal support is not enabled")

(assert_invalid
  (module
    (func (param i64 i64) (result i64)
      (i64.mul_wide_u (local.get 0) (local.get 1))
      i64.mul
    )
  )
  "alex's private proposal support is not enabled")
