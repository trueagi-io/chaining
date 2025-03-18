;; Attempt to port the propositional calculus of
;;
;; https://us.metamath.org/mpeuni/mmtheorems1.html
;;
;; alongside a few theorems for the backward chainer

;;;;;;;;;
;; Nat ;;
;;;;;;;;;

;; Define Nat
(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

;; Define cast functions between Nat and Number
(: fromNumber (-> Number Nat))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))
(: fromNat (-> Nat Number))
(= (fromNat Z) 0)
(= (fromNat (S $k)) (+ 1 (fromNat $k)))

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Curried Backward Chainer.  The arguments of the backward chainer
;; are:
;;
;; * Knowledge base: pointer to a space containing axioms and rules in
;;   the format (: <NAME> <RULE>).  Note that rules are explicitely
;;   curried, meaning that a rule with two premises is represented by
;;
;;   (: <NAME> (-> <PREMISE1> (-> <PREMISE2> <CONCLUSION>)))
;;
;; * Query: a metta term of the form (: <PROOF> <THEOREM>) where
;;   <PROOF> and <THEOREM> may contain free variables that may be
;;   filled by the backward chainer.
;;
;; * Maximum depth: maximum depth of the generated proof tree.
;;
;; A result is the query with its variables grounded, fully or
;; partially.  If multiple results are possible, they are returned as
;; a superposition.
(: bc (-> $a                            ; Knowledge base space
          Nat                           ; Maximum depth
          $b                            ; Query
          $b))                          ; Result
;; Base case
(= (bc $kb $_ (: $prf $ccln)) (match $kb (: $prf $ccln) (: $prf $ccln)))
;; Recursive step
(= (bc $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (let* (;; Recurse on prfabs
          ((: $prfabs (-> $prms $ccln))
           (bc $kb $k (: $prfabs (-> $prms $ccln))))
          ;; Recurse on prfarg
          ((: $prfarg $prms)
           (bc $kb $k (: $prfarg $prms))))
     (: ($prfabs $prfarg) $ccln)))

;;;;;;;;;;;;;;;;;;;;
;; Knowledge base ;;
;;;;;;;;;;;;;;;;;;;;

;; Based on https://us.metamath.org/mpeuni/mmtheorems1.html
;;
;; References:
;;
;; [Margaris] Margaris, Angelo, First Order Mathematical Logic,
;; Blaisdell Publishing Company, Waltham, Massachusetts (1967)
;; [QA9.M327].

!(bind! &kb (new-space))

;; Axiom Simp. Axiom A1 of [Margaris] p. 49.
(: ax-1 (-> $a (-> $b $a)))

;; Axiom Frege. Axiom A2 of [Margaris] p. 49.
(: ax-2 (-> (-> $a (-> $b $c)) (-> (-> $a $b) (-> $a $c))))

;; Axiom Transp. Axiom A3 of [Margaris] p. 49.
(: ax-3 (-> (-> (Not $a) (Not $b)) (-> $b $a)))

;;;;;;;;;;
;; Test ;;
;;;;;;;;;;

;; Test https://us.metamath.org/mpeuni/mp2.html
