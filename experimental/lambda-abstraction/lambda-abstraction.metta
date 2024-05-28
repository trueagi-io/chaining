;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Example of both backward chainer with lambda abstraction.           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;
;; Nat ;;
;;;;;;;;;

;; Define Nat
(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

;; Define <=
(: <= (-> $a $a Bool))
(= (<= $x $y) (or (< $x $y) (== $x $y)))

;; Define cast functions between Nat and Number
(: fromNumber (-> Number Nat))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))
(: fromNat (-> Nat Number))
(= (fromNat Z) 0)
(= (fromNat (S $k)) (+ 1 (fromNat $k)))

;;;;;;;;;;;;;;;;;;;;;
;; De Bruijn Index ;;
;;;;;;;;;;;;;;;;;;;;;

;; Define DeBruijn type
(: DeBruijn Type)

;; Define DeBruijn constructors
(: Z' DeBruijn)                        ; Zero
(: S' (-> DeBruijn DeBruijn))          ; Successor

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
;; * Environment: a superposition of typing relationship between De
;;   Bruijn index and type, such as (: Z' String).
;;
;; * De Bruijn Index: De Bruijn Index to use in case of lambda
;;   abstraction.
;;
;; * Maximum depth: maximum depth of the generated proof tree.
;;
;; * Query: a metta term of the form (: <PROOF> <THEOREM>) where
;;   <PROOF> and <THEOREM> may contain free variables that may be
;;   filled by the backward chainer.
;;
;; A result is the query with its variables grounded, fully or
;; partially.  If multiple results are possible, they are returned as
;; a superposition.
;;
;; Note that the proof is fully type annotated.  Without full type
;; annotation, lambda abstraction sometimes leads to incorrect
;; results.  It is suspected to come from the fact that the proof
;; application recursive step loses bindings about the premise.
;; Having a fully annotated proof is a good thing anyway, to display a
;; proof tree and to have a indepth view into the proof.  In order to
;; remove the type annoation one can use (NEXT: implement)
;; remove-type-annotation.
(: bc (-> $a                            ; Knowledge base space
          $b                            ; Environment
          DeBruijn                      ; De Bruijn Index
          Nat                           ; Maximum depth
          $c                            ; Query
          $c))                          ; Result
;; Base cases
;; Match the knowledge base
(= (bc $kb $env $idx $_ (: $prf $thrm))
   (match $kb (: $prf $thrm) (: $prf $thrm)))
;; Match the environment
(= (bc $kb $env $idx $_ (: $prf $thrm))
   (let (: $prf $thrm) $env (: $prf $thrm)))

;; Recursive steps
;; Proof application
(= (bc $kb $env $idx (S $k) (: ($prfabs (: $prfarg $prms)) $thrm))
   (let* (((: $prfabs (-> $prms $thrm))
           (bc $kb $env $idx $k (: $prfabs (-> $prms $thrm))))
          ((: $prfarg $prms)
           (bc $kb $env $idx $k (: $prfarg $prms))))
     (: ($prfabs (: $prfarg $prms)) $thrm)))
;; Proof abstraction
(= (bc $kb $env $idx (S $k) (: (λ $idx $prfbdy) (-> $prms $thrm)))
   (let (: $prfbdy $thrm)
     (bc $kb (superpose ((: $idx $prms) $env)) (S' $idx) $k (: $prfbdy $thrm))
     (: (λ $idx $prfbdy) (-> $prms $thrm))))

;;;;;;;;;;;;;;;;;;;;
;; Knowledge base ;;
;;;;;;;;;;;;;;;;;;;;

;; Simple knowledge base for expository purpose.  Do not confuse `->`,
;; the MeTTa arrow type, and `→`, a regular MeTTa symbol denoting a
;; relationship.

!(bind! &kb (new-space))

!(add-atom &kb (: a A))
!(add-atom &kb (: ab (→ A B)))
!(add-atom &kb (: bc (→ B C)))
!(add-atom &kb (: ModusPonens
                (-> (→ $p $q)           ; Premise 1
                    (-> $p              ; Premise 2
                        $q))))          ; Conclusion

;;;;;;;;;;;;;;;;;;;;;
;; Reduction Rules ;;
;;;;;;;;;;;;;;;;;;;;;

;; Identity application
(= ((λ $x $x) $y) $y)

;;;;;;;;;;;
;; Tests ;;
;;;;;;;;;;;

;; Find proof of A
!(assertEqual
  (bc &kb () Z' (fromNumber 0) (: $prf A))
  (: a A))

;; Find proof of B
!(assertEqual
  (bc &kb () Z' (fromNumber 2) (: $prf B))
  (: ((ModusPonens (: ab (→ A B))) (: a A)) B))

;; Find proof of C
!(assertEqual
  (bc &kb () Z' (fromNumber 3) (: $prf C))
  (: ((ModusPonens (: bc (→ B C))) (: ((ModusPonens (: ab (→ A B))) (: a A)) B)) C))

;; Find proof of (-> A B)
!(assertEqual
  (bc &kb () Z' (fromNumber 1) (: $prf (-> A B)))
  (: (ModusPonens (: ab (→ A B))) (-> A B)))

;; Find proof of (-> A A)
!(assertEqualToResult
  (bc &kb () Z' (fromNumber 1) (: $prf (-> A A)))
  ((: (λ Z' a) (-> A A))
   (: (λ Z' Z') (-> A A))
   (: (λ Z' a) (-> A A))))

;; Infer type of (λ Z' ((ModusPonens (: ab (→ A B))) (: Z' A)))
!(assertEqual
  (bc &kb () Z' (fromNumber 3)
      (: (λ Z' ((ModusPonens (: ab (→ A B))) (: Z' A))) $thrm))
  (: (λ Z' ((ModusPonens (: ab (→ A B))) (: Z' A))) (-> A B)))

;; Find proof of (-> $h C), filling the $h hypothesis
!(assertEqualToResult
  (bc &kb () Z' (fromNumber 1) (: $prf (-> $h C)))
  ((: (λ Z' Z') (-> C C))
   (: (ModusPonens (: bc (→ B C))) (-> B C))))

;; Find proof of (-> A B) with depth 3 to include lambda abstractions
!(assertEqualToResult
  (bc &kb () Z' (fromNumber 3) (: (λ Z' $bdy) (-> A B)))
  ((: (λ Z' ((ModusPonens (: ab (→ A B))) (: a A))) (-> A B))
   (: (λ Z' ((ModusPonens (: ab (→ A B))) (: Z' A))) (-> A B))
   (: (λ Z' ((ModusPonens (: ab (→ A B))) (: a A))) (-> A B))))

;; Find proof of (-> A B) with depth 3 to include lambda abstractions
;; Disabled because it takes 5 hours and returns 1200+ candidates
;; !(assertEqualToResult
  ;; !(bc &kb () Z' (fromNumber 3) (: $prf (-> A B)))
  ;; ((: (λ Z' ((ModusPonens (: ab (→ A B))) (: a A))) (-> A B))
  ;;  (: (λ Z' ((ModusPonens (: ab (→ A B))) (: Z' A))) (-> A B))
  ;;  (: (λ Z' ((ModusPonens (: ab (→ A B))) (: a A))) (-> A B))))
