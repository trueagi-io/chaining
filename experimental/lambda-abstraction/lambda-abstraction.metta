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
(: Zi DeBruijn)                        ; Zero
(: Si (-> DeBruijn DeBruijn))          ; Successor

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
;;   Bruijn index and type, such as (: (BDIdx Z) String).
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
(= (bc $kb $env $bdi $_ (: $prf $thrm))
   (match $kb (: $prf $thrm) (: $prf $thrm)))
;; Match the environment
(= (bc $kb $env $bdi $_ (: $prf $thrm))
   (let (: $prf $thrm) $env (: $prf $thrm)))

;; Recursive steps
;; Proof application
(= (bc $kb $env $bdi (S $k) (: ($prfabs (: $prfarg $prms)) $thrm))
   (let* (((: $prfabs (-> $prms $thrm))
           (bc $kb $env $bdi $k (: $prfabs (-> $prms $thrm))))
          ((: $prfarg $prms)
           (bc $kb $env $bdi $k (: $prfarg $prms))))
     (: ($prfabs (: $prfarg $prms)) $thrm)))
;; Proof abstraction
(= (bc $kb $env $bdi (S $k) (: (λ $bdi $prfbdy) (-> $prms $thrm)))
   (let (: $prfbdy $thrm)
     (bc $kb (superpose ((: $bdi $prms) $env)) (Si $bdi) $k (: $prfbdy $thrm))
     (: (λ $bdi $prfbdy) (-> $prms $thrm))))

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

;;;;;;;;;;;
;; Tests ;;
;;;;;;;;;;;

;; Find proof of A
!(assertEqual
  (bc &kb () Zi (fromNumber 0) (: $prf A))
  (: a A))
;; Find proof of B
!(assertEqual
  (bc &kb () Zi (fromNumber 2) (: $prf B))
  (: ((ModusPonens ab) a) B))
;; ;; Find proof of C
;; !(assertEqual
;;   (bc &kb () Zi (fromNumber 3) (: $prf C))
;;   (: ((ModusPonens bc) ((ModusPonens ab) a)) C))
;; ;; Find proof of (-> A B)
;; ;; !(assertEqual
;;   ;; !(bc &kb () Zi (fromNumber 1) (: $prf (-> $a $a)))
;; ;; !(bc &kb () Zi (fromNumber 2) (: $prf (-> $a $b)))
;; Find proof of (-> $h C), filling the $h hypothesis
!(bc &kb () Zi (fromNumber 1) (: $prf (-> $h C)))
