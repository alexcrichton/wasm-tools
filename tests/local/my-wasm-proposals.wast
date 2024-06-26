(module
  (func (param i32) (result i32) (i32.swap_bytes (local.get 0)))
)
(module
  (func (param i64) (result i64) (i64.swap_bytes (local.get 0)))
)
(module
  (func (param i64 i64) (result i64 i64) (i64.mul_wide_s (local.get 0) (local.get 1)))
)
(module
  (func (param i64 i64) (result i64 i64) (i64.mul_wide_u (local.get 0) (local.get 1)))
)

(assert_invalid
  (module (func (param i64) (result i32) (i32.swap_bytes (local.get 0))))
  "type mismatch")
(assert_invalid
  (module (func (param i32) (result i64) (i32.swap_bytes (local.get 0))))
  "type mismatch")
(assert_invalid
  (module (func (param i64) (result i32) (i64.swap_bytes (local.get 0))))
  "type mismatch")
(assert_invalid
  (module (func (param i32) (result i64) (i64.swap_bytes (local.get 0))))
  "type mismatch")

(assert_invalid
  (module (func (param i64 i32) (result i64 i64) (i64.mul_wide_s (local.get 0) (local.get 1))))
  "type mismatch")
(assert_invalid
  (module (func (param i32 i64) (result i64 i64) (i64.mul_wide_s (local.get 0) (local.get 1))))
  "type mismatch")
(assert_invalid
  (module (func (param i64 i64) (result i32 i64) (i64.mul_wide_s (local.get 0) (local.get 1))))
  "type mismatch")
(assert_invalid
  (module (func (param i64 i64) (result i64 i32) (i64.mul_wide_s (local.get 0) (local.get 1))))
  "type mismatch")
(assert_invalid
  (module (func (param i64 i32) (result i64 i64) (i64.mul_wide_u (local.get 0) (local.get 1))))
  "type mismatch")
(assert_invalid
  (module (func (param i32 i64) (result i64 i64) (i64.mul_wide_u (local.get 0) (local.get 1))))
  "type mismatch")
(assert_invalid
  (module (func (param i64 i64) (result i32 i64) (i64.mul_wide_u (local.get 0) (local.get 1))))
  "type mismatch")
(assert_invalid
  (module (func (param i64 i64) (result i64 i32) (i64.mul_wide_u (local.get 0) (local.get 1))))
  "type mismatch")

(module
  (func (param i32 i32) (result i32 i32) (i32.add_overflow_s (local.get 0) (local.get 1)))
  (func (param i32 i32) (result i32 i32) (i32.add_overflow_u (local.get 0) (local.get 1)))
  (func (param i32 i32) (result i32 i32) (i32.sub_overflow_s (local.get 0) (local.get 1)))
  (func (param i32 i32) (result i32 i32) (i32.sub_overflow_u (local.get 0) (local.get 1)))
  (func (param i32 i32) (result i32 i32) (i32.mul_overflow_s (local.get 0) (local.get 1)))
  (func (param i32 i32) (result i32 i32) (i32.mul_overflow_u (local.get 0) (local.get 1)))
)

(module
  (func (param i64 i64) (result i64 i32) (i64.add_overflow_s (local.get 0) (local.get 1)))
  (func (param i64 i64) (result i64 i32) (i64.add_overflow_u (local.get 0) (local.get 1)))
  (func (param i64 i64) (result i64 i32) (i64.sub_overflow_s (local.get 0) (local.get 1)))
  (func (param i64 i64) (result i64 i32) (i64.sub_overflow_u (local.get 0) (local.get 1)))
  (func (param i64 i64) (result i64 i32) (i64.mul_overflow_s (local.get 0) (local.get 1)))
  (func (param i64 i64) (result i64 i32) (i64.mul_overflow_u (local.get 0) (local.get 1)))
)

(module
  (func (param i64 i64) (result i64) (i64.mul_high_u (local.get 0) (local.get 1)))
  (func (param i64 i64) (result i64) (i64.mul_high_s (local.get 0) (local.get 1)))
)

(module
  (func (param i32 i32 i32) (result i32 i32)
    (i32.add_with_carry_s (local.get 0) (local.get 1) (local.get 2)))
  (func (param i32 i32 i32) (result i32 i32)
    (i32.add_with_carry_u (local.get 0) (local.get 1) (local.get 2)))
  (func (param i32 i32 i32) (result i32 i32)
    (i32.sub_with_carry_s (local.get 0) (local.get 1) (local.get 2)))
  (func (param i32 i32 i32) (result i32 i32)
    (i32.sub_with_carry_u (local.get 0) (local.get 1) (local.get 2)))

  (func (param i64 i64 i32) (result i64 i32)
    (i64.add_with_carry_s (local.get 0) (local.get 1) (local.get 2)))
  (func (param i64 i64 i32) (result i64 i32)
    (i64.add_with_carry_u (local.get 0) (local.get 1) (local.get 2)))
  (func (param i64 i64 i32) (result i64 i32)
    (i64.sub_with_carry_s (local.get 0) (local.get 1) (local.get 2)))
  (func (param i64 i64 i32) (result i64 i32)
    (i64.sub_with_carry_u (local.get 0) (local.get 1) (local.get 2)))
)

(module
  (func (param i64 i64 i64 i64) (result i64 i64)
    (i64.add128 (local.get 0) (local.get 1) (local.get 2) (local.get 3)))
  (func (param i64 i64 i64 i64) (result i64 i64)
    (i64.sub128 (local.get 0) (local.get 1) (local.get 2) (local.get 3)))
  (func (param i64 i64 i64 i64) (result i64 i64)
    (i64.mul128 (local.get 0) (local.get 1) (local.get 2) (local.get 3)))
)

(module
  (func (param i64 i64 i64 i64) (result i32)
    (i64.lt128_s (local.get 0) (local.get 1) (local.get 2) (local.get 3)))
  (func (param i64 i64 i64 i64) (result i32)
    (i64.lt128_u (local.get 0) (local.get 1) (local.get 2) (local.get 3)))
  (func (param i64 i64 i64 i64) (result i32)
    (i64.gt128_s (local.get 0) (local.get 1) (local.get 2) (local.get 3)))
  (func (param i64 i64 i64 i64) (result i32)
    (i64.gt128_u (local.get 0) (local.get 1) (local.get 2) (local.get 3)))
  (func (param i64 i64 i64 i64) (result i32)
    (i64.le128_s (local.get 0) (local.get 1) (local.get 2) (local.get 3)))
  (func (param i64 i64 i64 i64) (result i32)
    (i64.le128_u (local.get 0) (local.get 1) (local.get 2) (local.get 3)))
  (func (param i64 i64 i64 i64) (result i32)
    (i64.ge128_s (local.get 0) (local.get 1) (local.get 2) (local.get 3)))
  (func (param i64 i64 i64 i64) (result i32)
    (i64.ge128_u (local.get 0) (local.get 1) (local.get 2) (local.get 3)))
)
