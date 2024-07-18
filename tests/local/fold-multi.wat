;; WABT's fold-multi.txt
(module
  (func $dup (result i32 i32)
    i32.const 0
    i32.const 1
  )

  (func $fold-two (result i32)
    call $dup
    i32.add
  )

  (func $cant-fold (result i32)
    call $dup
    i32.const 1
    i32.add
    drop
  )

  (func $partial-fold (result i32)
    call $dup
    call $dup
    i32.add
    i32.sub
    drop
  )
)
