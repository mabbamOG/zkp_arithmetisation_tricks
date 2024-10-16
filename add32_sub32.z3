;; author: Mario A. Barbara 16.10.2024
;; the relevant part here is that if we have these type of operations 
;; (either addition or subtraction of 5 32-bit variables) we can express it 
;; as a constraint joining together 32-bit add/sub results and of/uf flags, 
;; as long as we also add the 32-bit constraint to the result and <= 4 
;; to the of/uf flags. a tighter constraint is possible but 
;; it's mainly useful if we wanted to work with exact values..

(define-const two32 Int 4294967296)
(define-const max32 Int (- two32 1))
(define-fun range ((x Int) (n Int)) Bool (and (>= x 0) (<= x n)))

(declare-const a Int)
(assert (range a max32))

(declare-const b Int)
(assert (range b max32))

(declare-const c Int)
(assert (range c max32))

(declare-const d Int)
(assert (range d max32))

(declare-const e Int)
(assert (range e max32))

(declare-const sum Int)
(assert (range sum max32))

(declare-const sub Int)
(assert (range sub max32))

(declare-const of Int)
(declare-const uf Int)
(assert (= (+ sum (* two32 of)) (+ a b c d e)))
(assert (= (- sub (* two32 uf)) (- a b c d e)))

(assert (not 
	(and
  ;; tight bounds
	(range of 4)
	(range uf 4)

	;; tighter bounds (optional)
	(range (+ sum (* two32 of)) (- (* 5 two32) 5))
	(>= (- sub (* two32 uf)) (+ (* -4 two32) 4))
	)
))

(check-sat)
(get-model)
