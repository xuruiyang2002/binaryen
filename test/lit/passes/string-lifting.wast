;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt -all --string-lifting -S -o - | filecheck %s

(module
  ;; CHECK:      (type $0 (func (param externref) (result i32)))

  ;; CHECK:      (type $array16 (array (mut i16)))
  (type $array16 (array (mut i16)))

  ;; CHECK:      (type $2 (func (param externref externref) (result i32)))

  ;; CHECK:      (type $3 (func (param externref i32 i32) (result (ref extern))))

  ;; CHECK:      (type $4 (func (param externref externref) (result (ref extern))))

  ;; CHECK:      (type $5 (func (param (ref null $array16) i32 i32) (result (ref extern))))

  ;; CHECK:      (type $6 (func (param i32) (result (ref extern))))

  ;; CHECK:      (type $7 (func (param externref (ref null $array16) i32) (result i32)))

  ;; CHECK:      (type $8 (func (param externref i32) (result i32)))

  ;; CHECK:      (type $9 (func))

  ;; CHECK:      (type $10 (func (param (ref $array16))))

  ;; CHECK:      (type $11 (func (result externref)))

  ;; CHECK:      (type $12 (func (param externref (ref $array16)) (result i32)))

  ;; CHECK:      (type $13 (func (param externref) (result externref)))

  ;; CHECK:      (type $14 (func (param externref)))

  ;; CHECK:      (import "\'" "foo" (global $string_foo (ref extern)))
  (import "\'" "foo" (global $string_foo (ref extern)))
  ;; CHECK:      (import "\'" "bar" (global $string_bar (ref extern)))
  (import "\'" "bar" (global $string_bar (ref extern)))

  ;; CHECK:      (import "wasm:js-string" "fromCharCodeArray" (func $fromCharCodeArray (type $5) (param (ref null $array16) i32 i32) (result (ref extern))))
  (import "wasm:js-string" "fromCharCodeArray" (func $fromCharCodeArray (param (ref null $array16) i32 i32) (result (ref extern))))
  ;; CHECK:      (import "wasm:js-string" "fromCodePoint" (func $fromCodePoint (type $6) (param i32) (result (ref extern))))
  (import "wasm:js-string" "fromCodePoint" (func $fromCodePoint (param i32) (result (ref extern))))
  ;; CHECK:      (import "wasm:js-string" "concat" (func $concat (type $4) (param externref externref) (result (ref extern))))
  (import "wasm:js-string" "concat" (func $concat (param externref externref) (result (ref extern))))
  ;; CHECK:      (import "wasm:js-string" "intoCharCodeArray" (func $intoCharCodeArray (type $7) (param externref (ref null $array16) i32) (result i32)))
  (import "wasm:js-string" "intoCharCodeArray" (func $intoCharCodeArray (param externref (ref null $array16) i32) (result i32)))
  ;; CHECK:      (import "wasm:js-string" "equals" (func $equals (type $2) (param externref externref) (result i32)))
  (import "wasm:js-string" "equals" (func $equals (param externref externref) (result i32)))
  ;; CHECK:      (import "wasm:js-string" "compare" (func $compare (type $2) (param externref externref) (result i32)))
  (import "wasm:js-string" "compare" (func $compare (param externref externref) (result i32)))
  ;; CHECK:      (import "wasm:js-string" "test" (func $test (type $0) (param externref) (result i32)))
  (import "wasm:js-string" "test" (func $test (param externref) (result i32)))
  ;; CHECK:      (import "wasm:js-string" "length" (func $length (type $0) (param externref) (result i32)))
  (import "wasm:js-string" "length" (func $length (param externref) (result i32)))
  ;; CHECK:      (import "wasm:js-string" "charCodeAt" (func $charCodeAt (type $8) (param externref i32) (result i32)))
  (import "wasm:js-string" "charCodeAt" (func $charCodeAt (param externref i32) (result i32)))
  ;; CHECK:      (import "wasm:js-string" "substring" (func $substring_foo (type $3) (param externref i32 i32) (result (ref extern))))
  (import "wasm:js-string" "substring" (func $substring_foo (param externref i32 i32) (result (ref extern))))

  ;; A function from the right module, but an unsupported name.
  ;; CHECK:      (import "wasm:js-string" "wrong-name" (func $wrong-base (type $3) (param externref i32 i32) (result (ref extern))))
  (import "wasm:js-string" "wrong-name" (func $wrong-base (param externref i32 i32) (result (ref extern))))

  ;; A function that is right in all ways but the module.
  ;; CHECK:      (import "oops" "substring" (func $wrong-module (type $3) (param externref i32 i32) (result (ref extern))))
  (import "oops" "substring" (func $wrong-module (param externref i32 i32) (result (ref extern))))

  ;; CHECK:      (func $func (type $9)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (string.const "foo")
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select (result (ref string))
  ;; CHECK-NEXT:    (string.const "bar")
  ;; CHECK-NEXT:    (string.const "bar")
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func
    (drop
      (global.get $string_foo)
    )
    ;; Test multiple uses of the same constant, and that we update types.
    (drop
      (select (result externref)
        (global.get $string_bar)
        (global.get $string_bar)
        (i32.const 1)
      )
    )
  )

  ;; CHECK:      (func $string.new.gc (type $10) (param $ref (ref $array16))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (string.new_wtf16_array
  ;; CHECK-NEXT:    (local.get $ref)
  ;; CHECK-NEXT:    (i32.const 7)
  ;; CHECK-NEXT:    (i32.const 8)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.new.gc (param $ref (ref $array16))
    (drop
      (call $fromCharCodeArray
        (local.get $ref)
          (i32.const 7)
          (i32.const 8)
      )
    )
  )

  ;; CHECK:      (func $string.from_code_point (type $11) (result externref)
  ;; CHECK-NEXT:  (string.from_code_point
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.from_code_point (result externref)
    (call $fromCodePoint
      (i32.const 1)
    )
  )

  ;; CHECK:      (func $string.concat (type $4) (param $a externref) (param $b externref) (result (ref extern))
  ;; CHECK-NEXT:  (string.concat
  ;; CHECK-NEXT:   (local.get $a)
  ;; CHECK-NEXT:   (local.get $b)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.concat (param $a externref) (param $b externref) (result (ref extern))
    (call $concat
      (local.get $a)
      (local.get $b)
    )
  )

  ;; CHECK:      (func $string.encode (type $12) (param $ref externref) (param $array16 (ref $array16)) (result i32)
  ;; CHECK-NEXT:  (string.encode_wtf16_array
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:   (local.get $array16)
  ;; CHECK-NEXT:   (i32.const 10)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.encode (param $ref externref) (param $array16 (ref $array16)) (result i32)
    (call $intoCharCodeArray
      (local.get $ref)
      (local.get $array16)
      (i32.const 10)
    )
  )

  ;; CHECK:      (func $string.eq (type $2) (param $a externref) (param $b externref) (result i32)
  ;; CHECK-NEXT:  (string.eq
  ;; CHECK-NEXT:   (local.get $a)
  ;; CHECK-NEXT:   (local.get $b)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.eq (param $a externref) (param $b externref) (result i32)
    (call $equals
      (local.get $a)
      (local.get $b)
    )
  )

  ;; CHECK:      (func $string.compare (type $2) (param $a externref) (param $b externref) (result i32)
  ;; CHECK-NEXT:  (string.compare
  ;; CHECK-NEXT:   (local.get $a)
  ;; CHECK-NEXT:   (local.get $b)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.compare (param $a externref) (param $b externref) (result i32)
    (call $compare
      (local.get $a)
      (local.get $b)
    )
  )

  ;; CHECK:      (func $string.test (type $0) (param $a externref) (result i32)
  ;; CHECK-NEXT:  (string.test
  ;; CHECK-NEXT:   (local.get $a)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.test (param $a externref) (result i32)
    (call $test
      (local.get $a)
    )
  )

  ;; CHECK:      (func $string.length (type $0) (param $ref externref) (result i32)
  ;; CHECK-NEXT:  (string.measure_wtf16
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.length (param $ref externref) (result i32)
    (call $length
      (local.get $ref)
    )
  )

  ;; CHECK:      (func $string.get_codeunit (type $0) (param $ref externref) (result i32)
  ;; CHECK-NEXT:  (stringview_wtf16.get_codeunit
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.get_codeunit (param $ref externref) (result i32)
    (call $charCodeAt
      (local.get $ref)
      (i32.const 2)
    )
  )

  ;; CHECK:      (func $string.slice (type $13) (param $ref externref) (result externref)
  ;; CHECK-NEXT:  (stringview_wtf16.slice
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:   (i32.const 3)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.slice (param $ref externref) (result externref)
    ;; Note how the internal name has _foo appended, but that does not confuse
    ;; use - the module and base names of the import are what matter.
    (call $substring_foo
      (local.get $ref)
      (i32.const 2)
      (i32.const 3)
    )
  )

  ;; CHECK:      (func $wrong (type $14) (param $ref externref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $wrong-base
  ;; CHECK-NEXT:    (local.get $ref)
  ;; CHECK-NEXT:    (i32.const 4)
  ;; CHECK-NEXT:    (i32.const 5)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $wrong-module
  ;; CHECK-NEXT:    (local.get $ref)
  ;; CHECK-NEXT:    (i32.const 6)
  ;; CHECK-NEXT:    (i32.const 7)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $wrong (param $ref externref)
    ;; We do nothing with functions with the wrong base or module name.
    (drop
      (call $wrong-base
        (local.get $ref)
        (i32.const 4)
        (i32.const 5)
      )
    )
    (drop
      (call $wrong-module
        (local.get $ref)
        (i32.const 6)
        (i32.const 7)
      )
    )
  )
)
