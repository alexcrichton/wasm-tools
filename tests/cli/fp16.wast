;; RUN: wast --assert default --snapshot tests/snapshots % -f fp16

(module
  (memory 1)

  ;; scalar loads and stores
  (func (param i32) (result f32) (f32.load_f16 (local.get 0)))
  (func (param i32) (result f32)
    local.get 0
    f32.load_f16 offset=2 align=1)
  (func (param i32 f32) (f32.store_f16 (local.get 0) (local.get 1)))
  (func (param i32 f32)
    local.get 0
    local.get 1
    f32.store_f16 offset=4)

  ;; lane operations
  (func (param f32) (result v128) (f16x8.splat (local.get 0)))
  (func (param v128) (result f32) (f16x8.extract_lane 7 (local.get 0)))
  (func (param v128 f32) (result v128) (f16x8.replace_lane 0 (local.get 0) (local.get 1)))

  ;; unary
  (func (param v128) (result v128) (f16x8.abs (local.get 0)))
  (func (param v128) (result v128) (f16x8.neg (local.get 0)))
  (func (param v128) (result v128) (f16x8.sqrt (local.get 0)))
  (func (param v128) (result v128) (f16x8.ceil (local.get 0)))
  (func (param v128) (result v128) (f16x8.floor (local.get 0)))
  (func (param v128) (result v128) (f16x8.trunc (local.get 0)))
  (func (param v128) (result v128) (f16x8.nearest (local.get 0)))

  ;; comparisons and arithmetic
  (func (param v128 v128) (result v128) (f16x8.eq (local.get 0) (local.get 1)))
  (func (param v128 v128) (result v128) (f16x8.ne (local.get 0) (local.get 1)))
  (func (param v128 v128) (result v128) (f16x8.lt (local.get 0) (local.get 1)))
  (func (param v128 v128) (result v128) (f16x8.gt (local.get 0) (local.get 1)))
  (func (param v128 v128) (result v128) (f16x8.le (local.get 0) (local.get 1)))
  (func (param v128 v128) (result v128) (f16x8.ge (local.get 0) (local.get 1)))
  (func (param v128 v128) (result v128) (f16x8.add (local.get 0) (local.get 1)))
  (func (param v128 v128) (result v128) (f16x8.sub (local.get 0) (local.get 1)))
  (func (param v128 v128) (result v128) (f16x8.mul (local.get 0) (local.get 1)))
  (func (param v128 v128) (result v128) (f16x8.div (local.get 0) (local.get 1)))
  (func (param v128 v128) (result v128) (f16x8.min (local.get 0) (local.get 1)))
  (func (param v128 v128) (result v128) (f16x8.max (local.get 0) (local.get 1)))
  (func (param v128 v128) (result v128) (f16x8.pmin (local.get 0) (local.get 1)))
  (func (param v128 v128) (result v128) (f16x8.pmax (local.get 0) (local.get 1)))

  ;; conversions
  (func (param v128) (result v128) (i16x8.trunc_sat_f16x8_s (local.get 0)))
  (func (param v128) (result v128) (i16x8.trunc_sat_f16x8_u (local.get 0)))
  (func (param v128) (result v128) (f16x8.convert_i16x8_s (local.get 0)))
  (func (param v128) (result v128) (f16x8.convert_i16x8_u (local.get 0)))
  (func (param v128) (result v128) (f16x8.demote_f32x4_zero (local.get 0)))
  (func (param v128) (result v128) (f16x8.demote_f64x2_zero (local.get 0)))
  (func (param v128) (result v128) (f32x4.promote_low_f16x8 (local.get 0)))
  (func (param v128) (result v128) (i16x8.trunc_f16x8_s (local.get 0)))
  (func (param v128) (result v128) (i16x8.trunc_f16x8_u (local.get 0)))

  ;; fused multiply-add
  (func (param v128 v128 v128) (result v128)
    (f16x8.madd (local.get 0) (local.get 1) (local.get 2)))
  (func (param v128 v128 v128) (result v128)
    (f16x8.nmadd (local.get 0) (local.get 1) (local.get 2)))
)

(assert_invalid
  (module
    (memory 1)
    (func (param i32) (result f32) (f32.load_f16 align=4 (local.get 0))))
  "alignment must not be larger than natural")

(assert_invalid
  (module
    (func (param i32) (result f32) (f32.load_f16 (local.get 0))))
  "unknown memory 0")

(assert_invalid
  (module
    (memory 1)
    (func (param i32 i64) (f32.store_f16 (local.get 0) (local.get 1))))
  "type mismatch")

(assert_invalid
  (module
    (func (param v128) (result f32) (f16x8.extract_lane 8 (local.get 0))))
  "SIMD index out of bounds")

(assert_invalid
  (module
    (func (param v128 i32) (result v128) (f16x8.replace_lane 0 (local.get 0) (local.get 1))))
  "type mismatch")

(assert_invalid
  (module
    (func (param i32) (result v128) (f16x8.splat (local.get 0))))
  "type mismatch")

(assert_invalid
  (module
    (func (param v128 v128) (result v128) (f16x8.madd (local.get 0) (local.get 1))))
  "type mismatch")
