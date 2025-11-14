;; THIS IS THE ONE LESS CHUNK TRICK
;; WHEN DECOMPOSING U16 -> U8 x U8
;; WE CAN OMIT CREATING ONE OF THE U8
;; BY RANGE CHECKING A LINEAR EXPRESSION INSTEAD
;; THIS RANGE CHECK USUALLY COMES FREE IN A 8x8 LOOKUP
;; AIRBENDER USES THIS TRICK EXTENSIVELY

;----------------------------------------------------- helper functions
(define-const two (_ BitVec 32) #x00000002)
(define-fun u1 ((x (_ BitVec 32))) Bool (and (bvuge x #x00000000) (bvult x two)) )
(define-const two8 (_ BitVec 32) #x00000100)
(define-fun u8 ((x (_ BitVec 32))) Bool (and (bvuge x #x00000000) (bvult x two8)) )
(define-const two16 (_ BitVec 32) #x00010000)
(define-fun u16 ((x (_ BitVec 32))) Bool (and (bvuge x #x00000000) (bvult x two16)) )

(define-const invtwo8 (_ BitVec 32) #x00800000)
(define-const p (_ BitVec 32) #x7fffffff)
(define-fun tou64 ((x (_ BitVec 32))) (_ BitVec 64) ((_ zero_extend 32) x))
(define-fun tou32 ((x (_ BitVec 64))) (_ BitVec 32) ((_ extract 31 0) x))
(define-fun modmul ((x (_ BitVec 32)) (y (_ BitVec 32))) (_ BitVec 32) (tou32 (bvurem (bvmul (tou64 x) (tou64 y)) (tou64 p))))
(define-fun modadd ((x (_ BitVec 32)) (y (_ BitVec 32))) (_ BitVec 32) (tou32 (bvurem (bvadd (tou64 x) (tou64 y)) (tou64 p))))
(define-fun modneg ((x (_ BitVec 32))) (_ BitVec 32) (bvsub p x))
(define-fun modsub ((x (_ BitVec 32)) (y (_ BitVec 32))) (_ BitVec 32) (modadd x (modneg y)))

;------------------------------------------------------ circuit inputs
(declare-const a (_ BitVec 32))
(declare-const b (_ BitVec 32))
(declare-const of (_ BitVec 32))
(declare-const clow (_ BitVec 32))
(declare-const chigh (_ BitVec 32))

;------------------------------------------------------- circuit assumptions
(define-const assumptions Bool (and
    (u16 a)
    (u16 b)
))

;------------------------------------------------------- circuit statement
(define-const specification Bool (and
    (u8 clow)
    (u8 chigh)
    (u1 of)
    (= (bvadd a b) (bvadd clow (bvmul two8 chigh) (bvmul two16 of)) )
))

;------------------------------------------------------- circuit constraint
(define-const constraints Bool (and
    (u8 clow)
    (u1 of)
    (let
        ((chighexpr
            ;; (bvlshr (bvsub (bvsub (bvadd a b) (bvmul two16 of)) clow) #x00000008) 
            (modmul (modsub (modsub (bvadd a b) (bvmul two16 of)) clow) invtwo8) 
        ))
        (and
            ;; (= #x00 ((_ extract 7 0) (bvsub (bvsub (bvadd a b) (bvmul two16 of)) clow)) )
            (u8 chighexpr)
            (= chigh chighexpr) ;; binder
        )
    )
))

;------------------------------------------------------- z3 SAT check
(assert assumptions)
;(assert (not (=> constraints specification))) ;; implies
(assert (not (= constraints specification))) ;; if and only if
(check-sat)
