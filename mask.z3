(declare-const aL Int)
(declare-const aH Int)
(declare-const a1L Int)
(declare-const a1H Int)
(declare-const exe Int)
(define-const two8 Int 256)

;; this proves that masking two u8 vars using 2 constraints
;; is equivalent to masking them with 1 joint constraint
(define-fun u8 ((x Int)) Bool (and (>= x 0) (< x 256)))
(define-fun u1 ((x Int)) Bool (and (>= x 0) (< x 2)))
(define-const specification Bool 
	(and
	(= a1L (* exe aL) )
	(= a1H (* exe aH) )
	(u8 aL)
	(u8 aH)
	(u8 a1L)
	(u8 a1H)
	(u1 exe)
	)
)
(define-const constraint Bool 
	(and
	(= (+ a1L (* two8 a1H)) (* exe (+ aL (* two8 aH))) )
	(u8 aL)
	(u8 aH)
	(u8 a1L)
	(u8 a1H)
	(u1 exe)
	)
)

(assert (not (iff constraint specification)))
(check-sat)
