;; RUN: wast --assert default --snapshot tests/snapshots % -f=-fp16

(assert_invalid
  (module
    (memory 1)
    (func (param i32) (result f32) (f32.load_f16 (local.get 0))))
  "fp16 support is not enabled")

(assert_invalid
  (module
    (memory 1)
    (func (param i32 f32) (f32.store_f16 (local.get 0) (local.get 1))))
  "fp16 support is not enabled")

(assert_invalid
  (module
    (func (param f32) (result v128) (f16x8.splat (local.get 0))))
  "fp16 support is not enabled")

(assert_invalid
  (module
    (func (param v128 v128) (result v128) (f16x8.add (local.get 0) (local.get 1))))
  "fp16 support is not enabled")
