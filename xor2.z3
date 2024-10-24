(declare-const a (_ BitVec 32))
(declare-const b (_ BitVec 32))
(declare-const c (_ BitVec 32))
(declare-const d (_ BitVec 32))

;; this z3 proves that two chained xors are equivalent to
;; one xor equals the other xor
(define-const specification Bool 
	(= a (bvxor (bvxor b c) d))
)
(define-const constraint Bool 
	(= (bvxor a b) (bvxor c d))
)

(assert (not (iff constraint specification)))
(check-sat)
