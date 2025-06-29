;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt -all --closed-world --preserve-type-order \
;; RUN:     --type-merging --remove-unused-types -S -o - | filecheck %s

(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $A (struct))
    (type $A (struct))
    ;; CHECK:       (type $B (descriptor $C (struct)))
    (type $B (descriptor $C (struct)))
    ;; CHECK:       (type $C (describes $B (struct)))
    (type $C (describes $B (struct)))
  )

  ;; The types have different shapes and should not be merged.
  ;; CHECK:      (global $A (ref null $A) (ref.null none))
  (global $A (ref null $A) (ref.null none))
  ;; CHECK:      (global $B (ref null $B) (ref.null none))
  (global $B (ref null $B) (ref.null none))
  ;; CHECK:      (global $C (ref null $C) (ref.null none))
  (global $C (ref null $C) (ref.null none))
)

(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $A (descriptor $A.desc (struct (field i32))))
    (type $A (descriptor $A.desc (struct (field i32))))
    ;; CHECK:       (type $A.desc (describes $A (struct)))
    (type $A.desc (describes $A (struct)))

    ;; CHECK:       (type $B (descriptor $B.desc (struct (field f64))))
    (type $B (descriptor $B.desc (struct (field f64))))
    ;; CHECK:       (type $B.desc (describes $B (struct)))
    (type $B.desc (describes $B (struct)))
  )

  ;; $A and $B have different shapes and should not be merged, so therefore
  ;; $A.desc and $B.desc should not be merged.
  ;; CHECK:      (global $A (ref null $A) (ref.null none))
  (global $A (ref null $A) (ref.null none))
  ;; CHECK:      (global $A.desc (ref null $A.desc) (ref.null none))
  (global $A.desc (ref null $A.desc) (ref.null none))
  ;; CHECK:      (global $B (ref null $B) (ref.null none))
  (global $B (ref null $B) (ref.null none))
  ;; CHECK:      (global $B.desc (ref null $A.desc) (ref.null none))
  (global $B.desc (ref null $B.desc) (ref.null none))
)

(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $A (descriptor $A.desc (struct)))
    (type $A (descriptor $A.desc (struct)))
    ;; CHECK:       (type $A.desc (describes $A (struct (field i32))))
    (type $A.desc (describes $A (struct (field i32))))

    ;; CHECK:       (type $B (descriptor $B.desc (struct)))
    (type $B (descriptor $B.desc (struct)))
    ;; CHECK:       (type $B.desc (describes $B (struct (field f64))))
    (type $B.desc (describes $B (struct (field f64))))
  )

  ;; $A.desc and $B.desc have different shapes and should not be merged, so
  ;; therefore $A and $B should not be merged.
  ;; CHECK:      (global $A (ref null $A) (ref.null none))
  (global $A (ref null $A) (ref.null none))
  ;; CHECK:      (global $A.desc (ref null $A.desc) (ref.null none))
  (global $A.desc (ref null $A.desc) (ref.null none))
  ;; CHECK:      (global $B (ref null $A) (ref.null none))
  (global $B (ref null $B) (ref.null none))
  ;; CHECK:      (global $B.desc (ref null $B.desc) (ref.null none))
  (global $B.desc (ref null $B.desc) (ref.null none))
)
