;; Attempt to convert
;; [demo0.mm](https://github.com/zariuq/mmverify.py/blob/metta/examples/demo0.mm)
;; to MeTTa using dependent types.

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

;; Backward Chainer supporting dependent types.
;;
;; The arguments of the backward chainer are:
;;
;; * Knowledge base: pointer to a space containing axioms and rules in
;;   the format (: <NAME> <RULE>).  Rules may not be curried, meaning
;;   that a rule with n premises may be represented by
;;
;;   (: <NAME> (-> <PREMISE1> ... <PREMISEn> <CONCLUSION>))
;;
;;   In addition, each premise must be an inline typing relationship,
;;   to represent dependent types.  It should be noted that such
;;   typing relationship must be provided even if the witness is not
;;   present in the rest of the definition.  For instance <PREMISE1>
;;   would have the format
;;
;;   (: <TERM1> <TYPE1>)
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
(: bc (-> $a                            ; Knowledge base space
          Nat                           ; Maximum depth
          $b                            ; Query
          $b))                          ; Result

;; Base cases
;; Match the knowledge base
(= (bc $kb $_ (: $prf $thrm)) (match $kb (: $prf $thrm) (: $prf $thrm)))

;; Recursive steps

;; Unary proof application
(= (bc $kb (S $k) (: ($prfabs $prfarg) $thrm))
   (let* (;; Recurse on abtraction
          ((: $prfabs (-> (: $prfarg $prms) $thrm))
           (bc $kb $k (: $prfabs (-> (: $prfarg $prms) $thrm))))
          ;; Recurse on premise
          ((: $prfarg $prms)
           (bc $kb $k (: $prfarg $prms))))
     ;; Output fulfilled query
     (: ($prfabs $prfarg) $thrm)))

;; Binary proof application
(= (bc $kb (S $k) (: ($prfabs $prfarg1 $prfarg2) $thrm))
   (let* (;; Recurse on abstraction
          ((: $prfabs (-> (: $prfarg1 $prms1)
                          (: $prfarg2 $prms2)
                          $thrm))
           (bc $kb $k (: $prfabs (-> (: $prfarg1 $prms1)
                                     (: $prfarg2 $prms2)
                                     $thrm))))
          ;; Recurse on first premise
          ((: $prfarg1 $prms1)
           (bc $kb $k (: $prfarg1 $prms1)))
          ;; Recurse on second premise
          ((: $prfarg2 $prms2)
           (bc $kb $k (: $prfarg2 $prms2))))
     ;; Output fulfilled query
     (: ($prfabs $prfarg1 $prfarg2) $thrm)))

;; Ternary proof application
(= (bc $kb (S $k) (: ($prfabs $prfarg1 $prfarg2 $prfarg3) $thrm))
   (let* (;; Recurse on abstraction
          ((: $prfabs (-> (: $prfarg1 $prms1)
                          (: $prfarg2 $prms2)
                          (: $prfarg3 $prms3)
                          $thrm))
           (bc $kb $k (: $prfabs (-> (: $prfarg1 $prms1)
                                     (: $prfarg2 $prms2)
                                     (: $prfarg3 $prms3)
                                     $thrm))))
          ;; Recurse on first premise
          ((: $prfarg1 $prms1)
           (bc $kb $k (: $prfarg1 $prms1)))
          ;; Recurse on second premise
          ((: $prfarg2 $prms2)
           (bc $kb $k (: $prfarg2 $prms2)))
          ;; Recurse on third premise
          ((: $prfarg3 $prms3)
           (bc $kb $k (: $prfarg3 $prms3))))
     ;; Output fulfilled query
     (: ($prfabs $prfarg1 $prfarg2 $prfarg3) $thrm)))

;; Quaternary proof application
(= (bc $kb (S $k) (: ($prfabs $prfarg1 $prfarg2 $prfarg3 $prfarg4) $thrm))
   (let* (;; Recurse on abstraction
          ((: $prfabs (-> (: $prfarg1 $prms1)
                          (: $prfarg2 $prms2)
                          (: $prfarg3 $prms3)
                          (: $prfarg4 $prms4)
                          $thrm))
           (bc $kb $k (: $prfabs (-> (: $prfarg1 $prms1)
                                     (: $prfarg2 $prms2)
                                     (: $prfarg3 $prms3)
                                     (: $prfarg4 $prms4)
                                     $thrm))))
          ;; Recurse on first premise
          ((: $prfarg1 $prms1)
           (bc $kb $k (: $prfarg1 $prms1)))
          ;; Recurse on second premise
          ((: $prfarg2 $prms2)
           (bc $kb $k (: $prfarg2 $prms2)))
          ;; Recurse on third premise
          ((: $prfarg3 $prms3)
           (bc $kb $k (: $prfarg3 $prms3)))
          ;; Recurse on fourth premise
          ((: $prfarg4 $prms4)
           (bc $kb $k (: $prfarg4 $prms4))))
     ;; Output fulfilled query
     (: ($prfabs $prfarg1 $prfarg2 $prfarg3 $prfarg4) $thrm)))

;; Quintenary proof application
(= (bc $kb (S $k) (: ($prfabs $prfarg1 $prfarg2 $prfarg3 $prfarg4 $prfarg5) $thrm))
   (let* (;; Recurse on abstraction
          ((: $prfabs (-> (: $prfarg1 $prms1)
                          (: $prfarg2 $prms2)
                          (: $prfarg3 $prms3)
                          (: $prfarg4 $prms4)
                          (: $prfarg5 $prms5)
                          $thrm))
           (bc $kb $k (: $prfabs (-> (: $prfarg1 $prms1)
                                     (: $prfarg2 $prms2)
                                     (: $prfarg3 $prms3)
                                     (: $prfarg4 $prms4)
                                     (: $prfarg5 $prms5)
                                     $thrm))))
          ;; Recurse on first premise
          ((: $prfarg1 $prms1)
           (bc $kb $k (: $prfarg1 $prms1)))
          ;; Recurse on second premise
          ((: $prfarg2 $prms2)
           (bc $kb $k (: $prfarg2 $prms2)))
          ;; Recurse on third premise
          ((: $prfarg3 $prms3)
           (bc $kb $k (: $prfarg3 $prms3)))
          ;; Recurse on fourth premise
          ((: $prfarg4 $prms4)
           (bc $kb $k (: $prfarg4 $prms4)))
          ;; Recurse on fifth premise
          ((: $prfarg5 $prms5)
           (bc $kb $k (: $prfarg5 $prms5))))
     ;; Output fulfilled query
     (: ($prfabs $prfarg1 $prfarg2 $prfarg3 $prfarg4 $prfarg5) $thrm)))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;; ;;
;; ;; Knowledge base ;; ;;
;; ;;;;;;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Convert
;; [demo0.mm](https://github.com/zariuq/mmverify.py/blob/metta/examples/demo0.mm)
;; to MeTTa using a type theoretic representation.
;;
;; There are three levels of difficulty or rather nearness to the
;; Metamath representation:
;;
;; - Easy: term and wff are ignored, metamath implication is replaced
;;   by arrow type.
;;
;; - Medium: term and wff are taken into account.
;;
;; - Hard: metamath implication is used.

;;;;;;;;;;
;; Easy ;;
;;;;;;;;;;

!(bind! &kbe (new-space))

;; Informal description:
;;   Equality is right Euclidean (see https://arxiv.org/pdf/1806.05036)
;;
;; Metamath description:
;;   $( State Axiom ~ a1 . $)
;;   a1 $a |- ( t = r -> ( t = s -> r = s ) ) $.
;;
;; Warning: not using ⟨->⟩ and the fact that $t $r and $s are wff.
!(add-atom &kbe (: a1 (-> (: $ter (⟨=⟩ $t $r))
                          (: $tes (⟨=⟩ $t $s))
                          (⟨=⟩ $r $s))))

;; Informal description:
;;   Zero is a right identity of addition.
;;
;; Metamath description:
;;   $( State Axiom ~ a2 . $)
;;   a2 $a |- ( t + 0 ) = t $.
;;
;; Warning: not using the fact that $t is wff.
!(add-atom &kbe (: a2 (⟨=⟩ (⟨+⟩ $t ⟨0⟩) $t)))

;;;;;;;;;;;
;; Tests ;;
;;;;;;;;;;;

;; Informal description:
;;   Prove that equality is reflexive.
;;
;; This can be proved by combining axiom a1 and a2 as follows.
;; According to a2
;;
;; if t = r and t = s then r = s
;;
;; Substituting t by t'+ 0, r by t', and s by t' we obtain
;;
;; if t' + 0 = t' and t' + 0 = t' then t' = t'
;;
;; Since t' + 0 = t' according to a1, it follows that
;;
;; t' = t'
;;
;; Metamath description:
;;   $( Prove a theorem.  (Contributed by NM, 1-Jan-2004.) $)
;;   th1 $p |- t = t $=
;;   $( Here is its proof: $)
;;     tt tze tpl tt weq tt tt weq tt a2 tt tze tpl tt weq tt tze tpl tt weq tt tt
;;     weq wim tt a2 tt tze tpl tt tt a1 mp mp $.
!(assertEqual
  (bc &kbe (fromNumber 1) (: $prf (⟨=⟩ $t $t)))
  (: (a1 a2 a2) (⟨=⟩ $t $t)))

;;;;;;;;;;;;
;; Medium ;;
;;;;;;;;;;;;

!(bind! &kbm (new-space))

;; Informal description:
;;   Zero is a term
;;
;; Metamath description:
;;   $( Define "term" (part 1 of 2). $)
;;   tze $a term 0 $.
!(add-atom &kbm (: ⟨0⟩ ⟨term⟩))

;; Informal description:
;;   Adding two terms outputs a term
;;
;; Metamath description:
;;   $( Define "term" (part 2 of 2). $)
;;   tpl $a term ( t + r ) $.
!(add-atom &kbm (: ⟨+⟩ (-> (: $t ⟨term⟩)
                           (: $r ⟨term⟩)
                           ⟨term⟩)))

;; Informal description:
;;   Equality between two terms is a well formed formula.
;;
;; Metamath description:
;;   $( Define "wff" (part 1 of 2). $)
;;   weq $a wff t = r $.
!(add-atom &kbm (: ⟨=⟩ (-> (: $t ⟨term⟩)
                           (: $r ⟨term⟩)
                           ⟨wff⟩)))

;; Informal description:
;;   Equality is right Euclidean (see https://arxiv.org/pdf/1806.05036)
;;
;; Metamath description:
;;   $( State Axiom ~ a1 . $)
;;   a1 $a |- ( t = r -> ( t = s -> r = s ) ) $.
;;
;; Warning: not using ⟨->⟩ and the fact that $t $r and $s are wff.
!(add-atom &kbm (: a1 (-> (: $t ⟨term⟩)
                          (: $r ⟨term⟩)
                          (: $s ⟨term⟩)
                          (: $ter (⟨=⟩ $t $r))
                          (: $tes (⟨=⟩ $t $s))
                          (⟨=⟩ $r $s))))

;; Informal description:
;;   Zero is a right identity of addition.
;;
;; Metamath description:
;;   $( State Axiom ~ a2 . $)
;;   a2 $a |- ( t + 0 ) = t $.
;;
;; Warning: not using the fact that $t is wff.
!(add-atom &kbm (: a2 (-> (: $t ⟨term⟩)
                          (⟨=⟩ (⟨+⟩ $t ⟨0⟩) $t))))

;;;;;;;;;;;
;; Tests ;;
;;;;;;;;;;;

;; Informal description:
;;   Prove that equality is reflexive.
;;
;; This can be proved by combining axiom a1 and a2 as follows.
;; According to a2
;;
;; if t = r and t = s then r = s
;;
;; Substituting t by t'+ 0, r by t', and s by t' we obtain
;;
;; if t' + 0 = t' and t' + 0 = t' then t' = t'
;;
;; Since t' + 0 = t' according to a1, it follows that
;;
;; t' = t'
;;
;; Metamath description:
;;   $( Prove a theorem.  (Contributed by NM, 1-Jan-2004.) $)
;;   th1 $p |- t = t $=
;;   $( Here is its proof: $)
;;     tt tze tpl tt weq tt tt weq tt a2 tt tze tpl tt weq tt tze tpl tt weq tt tt
;;     weq wim tt a2 tt tze tpl tt tt a1 mp mp $.
!(add-atom &kbm (: ⟨t⟩ ⟨term⟩))
!(assertIncludes
  (bc &kbm (fromNumber 3) (: $prf (⟨=⟩ ⟨t⟩ ⟨t⟩)))
  ((: (a1 (⟨+⟩ ⟨t⟩ ⟨0⟩)
          ⟨t⟩
          ⟨t⟩
          (a2 ⟨t⟩)
          (a2 ⟨t⟩))
      (⟨=⟩ ⟨t⟩ ⟨t⟩))))

;;;;;;;;;;
;; Hard ;;
;;;;;;;;;;

;; NEXT

!(bind! &kbh (new-space))

;; Informal description:
;;   Zero is a term
;;
;; Metamath description:
;;   $( Define "term" (part 1 of 2). $)
;;   tze $a term 0 $.
!(add-atom &kbh (: ⟨0⟩ ⟨term⟩))

;; Informal description:
;;   Adding two terms outputs a term
;;
;; Metamath description:
;;   $( Define "term" (part 2 of 2). $)
;;   tpl $a term ( t + r ) $.
!(add-atom &kbh (: ⟨+⟩ (-> (: $t ⟨term⟩)
                           (: $r ⟨term⟩)
                           ⟨term⟩)))

;; Informal description:
;;   Equality between two terms is a well formed formula.
;;
;; Metamath description:
;;   $( Define "wff" (part 1 of 2). $)
;;   weq $a wff t = r $.
!(add-atom &kbh (: ⟨=⟩ (-> (: $t ⟨term⟩)
                           (: $r ⟨term⟩)
                           ⟨wff⟩)))

;; Informal description:
;;   Implication between two well formed formulas is a well formed formula.
;;
;; Metamath description:
;;   $( Define "wff" (part 2 of 2). $)
;;   wim $a wff ( P -> Q ) $.
!(add-atom &kbh (: ⟨->⟩ (-> (: $P ⟨wff⟩)
                            (: $Q ⟨wff⟩)
                            ⟨wff⟩)))

;; Informal description:
;;   Equality is right Euclidean (see https://arxiv.org/pdf/1806.05036)
;;
;; Metamath description:
;;   $( State Axiom ~ a1 . $)
;;   a1 $a |- ( t = r -> ( t = s -> r = s ) ) $.
;;
;; Warning: not using ⟨->⟩ and the fact that $t $r and $s are wff.
!(add-atom &kbh (: a1 (-> (: $t ⟨term⟩)
                          (: $r ⟨term⟩)
                          (: $s ⟨term⟩)
                          (: $ter (⟨=⟩ $t $r))
                          (: $tes (⟨=⟩ $t $s))
                          (⟨=⟩ $r $s))))

;; Informal description:
;;   Zero is a right identity of addition.
;;
;; Metamath description:
;;   $( State Axiom ~ a2 . $)
;;   a2 $a |- ( t + 0 ) = t $.
;;
;; Warning: not using the fact that $t is wff.
!(add-atom &kbh (: a2 (-> (: $t ⟨term⟩)
                          (⟨=⟩ (⟨+⟩ $t ⟨0⟩) $t))))

;; Informal description:
;;   Modus ponens
;;
;; Metamath description:
;;   ${
;;     min $e |- P $.
;;     maj $e |- ( P -> Q ) $.
;;     $( Define the modus ponens inference rule. $)
;;     mp $a |- Q $.
;;   $}
!(add-atom &kbh (: mp (-> (: $P ⟨wff⟩)
                          (: $Q ⟨wff⟩)
                          (: $min $P)
                          (: $maj (⟨->⟩ $P $Q))
                          $Q)))

;;;;;;;;;;;
;; Tests ;;
;;;;;;;;;;;

;; Informal description:
;;   Prove that equality is reflexive.
;;
;; This can be proved by combining axiom a1 and a2 as follows.
;; According to a2
;;
;; if t = r and t = s then r = s
;;
;; Substituting t by t'+ 0, r by t', and s by t' we obtain
;;
;; if t' + 0 = t' and t' + 0 = t' then t' = t'
;;
;; Since t' + 0 = t' according to a1, it follows that
;;
;; t' = t'
;;
;; Metamath description:
;;   $( Prove a theorem.  (Contributed by NM, 1-Jan-2004.) $)
;;   th1 $p |- t = t $=
;;   $( Here is its proof: $)
;;     tt tze tpl tt weq tt tt weq tt a2 tt tze tpl tt weq tt tze tpl tt weq tt tt
;;     weq wim tt a2 tt tze tpl tt tt a1 mp mp $.
!(add-atom &kbh (: ⟨t⟩ ⟨term⟩))
;; !(assertIncludes
  !(bc &kbh (fromNumber 3) (: $prf (⟨=⟩ ⟨t⟩ ⟨t⟩)))
  ;; ((: (a1 (⟨+⟩ ⟨t⟩ ⟨0⟩)
  ;;         ⟨t⟩
  ;;         ⟨t⟩
  ;;         (a2 ⟨t⟩)
  ;;         (a2 ⟨t⟩))
  ;;     (⟨=⟩ ⟨t⟩ ⟨t⟩))))
