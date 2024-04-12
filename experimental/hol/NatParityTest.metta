;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Definition of a chainer, Nat, plus and some proofs about the
;; existance of the parity properties of Nat such as Even and Odd.
;;
;; Implement a sigma type, take example from
;;
;; https://idris2.readthedocs.io/en/latest/tutorial/typesfuns.html#dependent-pairs
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

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Knowledge/rule base ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

!(bind! &kb (new-space))

;; The following code is translated into axioms and rules to handled
;; by the backward chainer.
;;
;; ;; Define Σ type (called DPair in Idris)
;; (: Σ (-> (: $a Type) (-> $a Type) Type))
;;
;; ;; Define DPair constructor
;; (: MkΣ (-> (: $p (-> $a Type)) (: $x $a) ($p $x) (Σ $a $p)))
;;
;; ;; Define the even property
;; (: Even (-> Nat Type))
;; (: MkEvenZ (Even Z))
;; (: MkEvenSS (-> (Even $k) (Even (S (S $k)))))
;;
;; ;; Define examples of even numbers (0 and 2)
;; (: (MkΣ Even Z MkEvenZ) (Σ Nat Even))
;; (: (MkΣ Even (S (S Z)) (MkEvenSS MkEvenZ)) (Σ Nat Even))
;; (: $prf (Σ Nat Even))
;;
;; ;; Define double function
;; (: double (-> Nat Nat))
;; (= (double Z) Z)
;; (= (double (S $k)) (S (S (double $k))))
;;
;; ;; Σ access functions
;; (: Σ.val (-> (Σ $a $p) $a))
;; (= (Σ.val (MkΣ $prop $val $prf)) $val)
;; (: Σ.prf (-> (Σ $a $p) $p))
;; (= (Σ.prf (MkΣ $prop $val $prf)) $prf)
;;
;; ;; Define double function, with the guaranty that the output is even
;; (: doubleΣ (-> Nat (Σ Nat Even)))
;; (= (doubleΣ Z) (MkΣ Even Z MkEvenZ))
;; (= (doubleΣ (S $k)) (MkΣ Even
;;                          (S (S (Σ.val (doubleΣ $k))))
;;                          (MkEvenSS (Σ.prf (doubleΣ $k)))))
;;
;; ;; For all x, (double x) is even
;; ;; ∀x (Even (double x))
;; (: double-even-prf (-> (: $x Nat) (Even (double $x))))
;;
;; ;; Independent product type (i.e. conjunction)
;; (: ⊗ (-> Type Type Type))
;;
;; ;; Equality
;; (: === (-> $a $a Type))
;;
;; ;; ;; NEXT
;;
;; ;; ;; For all x, there exists k such that k = (double x) and k is even
;; ;; ;; ∀x ∃k k=(double x) ∧ (Even k)
;; ;; (: double-Σ-even-prf (-> ($x : Nat)
;; ;;                          (Σ Nat (λ $k (⊗ (=== $k (double $x)) (Even $k))))))
;;
;; ;; (: double-Σ-even-prf (-> ($x : Nat) (Σ Nat (EqualDoubleAndEven $x))))
;; ;; (: EqualDoubleAndEven (-> Nat (-> Nat Type)))
;; ;; (= ((EqualDoubleAndEven $x) $k) (⊗ (=== $k (double $x)) (Even $k)))
;; ;; ;; Or, alternatively
;; ;; ;; (= (EqualDoubleAndEven $x) (λ $k (× (=== $k (double $x)) (Even $k))))

;; ;; Define Nat
;; !(add-atom &kb (: Nat Type))
;; !(add-atom &kb (: Z Nat))
;; !(add-atom &kb (: S (-> (: $x Nat) Nat)))

;; ;; Define Even
;; !(add-atom &kb (: Even (-> (: $x Nat) Type)))
;; !(add-atom &kb (: MkEvenZ (Even Z)))
;; !(add-atom &kb (: MkEvenSS (-> (: $prf (Even $k))   ; Premise
;;                                (Even (S (S $k)))))) ; Conclusion

;; ;; Define Σ
;; !(add-atom &kb (: MkΣ (-> (: $p (-> (: $_ $a) Type)) ; Premise 1.  We
;;                                                      ; need to use (: $_ $a)
;;                                                      ; as opposed to just $a
;;                                                      ; to be fully consistent with
;;                                                      ; The (: PROOF PREMISE)
;;                                                      ; notation, till it becomes
;;                                                      ; optional.
;;                           (-> (: $x $a)              ; Premise 2
;;                               (-> (: $prf ($p $x))   ; Premise 3
;;                                   (Σ $a $p))))))     ; Conclusion

;; ;; Equality is transitive
;; !(add-atom &kb (: Trans (-> (: $prf1 (=== $x $y))     ; Premise 1
;;                             (-> (: $prf2 (=== $y $z)) ; Premise 2
;;                                 (=== $x $z)))))       ; Conclusion

;; ;; Equality is symmetric
;; !(add-atom &kb (: Sym (-> (: $prf (=== $x $y)) ; Premise
;;                           (=== $y $x))))       ; Conclusion

;; ;; Equality respects function application
;; !(add-atom &kb (: Cong (-> (: $f (-> (: $_ $a) $b))                 ; Premise 1
;;                            (-> (: $x $a)                            ; Premise 2
;;                                (-> (: $x' $a)                       ; Premise 3
;;                                    (-> (: $prf (=== $x $x'))        ; Premise 4
;;                                        (=== ($f $x) ($f $x')))))))) ; Conclusion

;; ;; Rule of replacement
;; !(add-atom &kb (: Replace (-> (: $prf1 (=== $x $x')) ; Premise 1
;;                               (-> (: $prf2 $x)       ; Premise 2
;;                                   $x'))))            ; Conclusion

;; ;; Modus Ponens (application)
;; !(add-atom &kb (: MP (-> (: $f (-> (: $x $a) $b)) ; Premise 1
;;                          (-> (: $x $a)            ; Premise 2
;;                              $b))))               ; Conclusion

;; ;; Define double
;; !(add-atom &kb (: double (-> (: $k Nat) Nat)))
;; !(add-atom &kb (: double_base (=== (double Z) Z)))
;; !(add-atom &kb (: double_rec (-> (: $k Nat)
;;                                  (=== (double (S $k)) (S (S (double $k)))))))

;; K combinator
!(add-atom &kb (: AK (-> (: $x $a)            ; Premise
                         (-> (: $y $b) $a)))) ; Conclusion

;; S combinator
!(add-atom &kb (: AS (-> (: $g (-> (: $x $a) (-> (: $y $b) $c))) ; Premise 1
                         (-> (: $f (-> (: $x $a) $b))            ; Premise 2
                             (-> (: $x $a) $c)))))               ; Conclusion

;; ;; Composition operator
;; !(add-atom &kb (: . (-> (: $g (-> (: $y $b) $c))     ; Premise 1
;;                         (-> (: $f (-> (: $x $a) $b)) ; Premise 2
;;                             (-> (: $x $a) $c)))))    ; Conclusion

;; ;; Flip operator
;; !(add-atom &kb (: flip (-> (: $f (-> (: $x $a) (-> (: $y $b) $c))) ; Premise
;;                            (-> (: $y $b) (-> (: $x $a) $c)))))     ; Conclusion

;; ;; Lambda abstraction.  Note that $x does not need to be a MeTTa
;; ;; variable, or even contain MeTTa variables at all.  As such a closed
;; ;; term is a valid variable as well, which corresponds to a very
;; ;; specific, yet valid, abstraction.
;; ;;
;; ;; The problem of that definition is that (: $y $b) needs to be
;; ;; proven, and only a closed term can have such proof, thus it would
;; ;; automatically limit lambda abstraction to constant functions.
;; !(add-atom &kb (: (λ $x) (-> (: $y $b)            ; Premise (body)
;;                              (-> (: $x $a) $b)))) ; Conclusion

;; ;; Lambda identity
;; !(add-atom &kb (: ((λ $x) $x) (-> (: $x $a) $a)))

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Similar to the backward chainer in NatDTLTest but rules are
;; optionally represented as dependent products.  Meaning rule
;; premises may contain type-of relationships.  That is, instead of
;;
;; (: RULE_CONSTRUCTOR (-> PREMISE CONCLUSION))
;;
;; it must be
;;
;; (: RULE_CONSTRUCTOR (-> (: PROOF PREMISE) CONCLUSION))
;;
;; Typically PROOF will be a variable, but it can also be a term
;; containing variables, in which case CONCLUSION may contain that
;; term, or variables of that term.
;;
;; Unlike for the backward chainer in NatDTLTest, the non-dependent
;; format is supported as well.  EDIT: not yet!

;; Base case
(: bc (-> $a Nat $a))
(= (bc $kb (: $prf $ccln) $_)
   ;; Query the knowledge for a rule or a fact
   (match $kb (: $prf $ccln) (: $prf $ccln)))

;; Recursive step
(= (bc $kb (: ($prfabs $prfarg) $ccln) (S $k))
   (let* (;; Recurse on proof abstraction
          ((: $prfabs (-> (: $prfarg $prms) $ccln))
           (bc $kb (: $prfabs (-> (: $prfarg $prms) $ccln)) $k))
          ;; Recurse on proof argument
          ((: $prfarg $prms)
           (bc $kb (: $prfarg $prms) $k)))
     (: ($prfabs $prfarg) $ccln)))

;;;;;;;;;;;;;;;
;; Reduction ;;
;;;;;;;;;;;;;;;

;; Reduction rules to simplify proofs and reduce redundancy

;; TODO: these rules should be proven first.  Then they could
;; automatically be inserted.

;; ;; Involution of symmetry
;; (= (Sym (Sym $f)) $f)

;; ;; Composition to application
;; (= (((. $g) $f) $x) ($g ($f $x)))

;; ;; Involution of flip
;; (= (flip (flip $f)) $f)

;; ;; Identity
;; (= (((λ $x) $x) $y) $y)

;; ;; Lambda composition
;; (= ((. $f) ((λ $x) $y)) ((λ $x) ($f $y)))

;;;;;;;;;;;
;; Tests ;;
;;;;;;;;;;;

;; ;; Synthesize natural numbers
;; !(bc &kb (: $prf Nat) (fromNumber 3))

;; ;; Prove that 0 is even
;; (bc &kb (: $prf (Even (fromNumber 0))) (fromNumber 0))

;; ;; Prove that 2 is even
;; (bc &kb (: $prf (Even (fromNumber 2))) (fromNumber 1))

;; ;; Synthesize even numbers
;; (bc &kb (: $prf (Σ Nat Even)) (fromNumber 4))

;; ;; Synthesize unary functions over natural numbers, that is
;; ;; prove (-> (: $k Nat) Nat).
;; (bc &kb (: $prf (-> (: $k Nat) Nat)) (fromNumber 3))

;; ;; Synthesize the identity function from AK and AS, that is prove
;; ;;
;; ;; (-> (: $x $a) $a)
;; ;;
;; ;; Such a proof could be
;; ;;
;; ;; ((AS AK) AK)
;; (bc &kb (: $prf (-> (: $x $a) $a)) (fromNumber 2))

;; ;; Synthesize the composition operator, also corresponding to the B
;; ;; combinator, from AK and AS, that is prove
;; ;;
;; ;; (-> (: $g (-> (: $y $b) $c))
;; ;;     (-> (: $f (-> (: $x $a) $b))
;; ;;         (-> (: $x $a) $c)))
;; ;;
;; ;; such proof could be
;; ;;
;; ;; ((AS (AK AS)) AK)
;; (bc &kb (: $prf (-> (: $g (-> (: $y $b) $c)) (-> (: $f (-> (: $x $a) $b)) (-> (: $x $a) $c))))
;;      (fromNumber 3))

;; NEXT: infer the C combinator, such that C = (S (S (K (S (K S) K)) S) (K K)).
;;
;; 1. Infer its type with the backward chainer
;;
;; 2. Synthesize its definition given its type

;; NEXT: see if flip = ((.) (.) f . (const . const))

;; NEXT: see if S x y z = (x .) (y z)

;; NEXT: write lambda-calculus to combinatory logic converter

;; NEXT
;; ;; Synthesize the flip operator from AK and AS, that is prove
;; ;;
;; ;; (-> (: $f (-> (: $x $a) (-> (: $y $b) $c)))
;; ;;     (-> (: $y $b) (-> (: $x $a) $c)))))
;; ;;
;; ;; A possible proof could be
;; ;;
;; ;; ((AS ((AS (AK AS)) AK)) AS)
(bc &kb (: $prf (-> (: $f (-> (: $x $a) (-> (: $y $b) $c))) (-> (: $y $b) (-> (: $x $a) $c))))
     (fromNumber 5))
;; (bc &kb (: ((AS ((AS (AK AS)) AK)) AS)
;;         (-> (: $f (-> (: $x $a) (-> (: $y $b) $c))) (-> (: $z $b) (-> (: $w $a) $c))))
;;      (fromNumber 10))
;; (bc &kb (: ((AS ((AS (AK AS)) AK)) AS)
;;         (-> (: $f (-> (: $x $a) (-> (: $y $b) $c))) (-> (: $y $b) (-> (: $x $a) $c))))
;;      (fromNumber 20))

;; ;; ;; Prove that (double Z) is even.
;; ;; ;;
;; ;; ;; A possible proof of that is represented by the following proof tree:
;; ;; ;;
;; ;; ;;                                  --(Z)       -----------------(double_base)
;; ;; ;;                                  Nat         (=== (double Z) Z)
;; ;; ;; -------------------(Even) --(Z)  --(double)  -----------------(Sym)
;; ;; ;; (-> (: $_ Nat) Type)      Nat    Nat         (=== Z (double Z))
;; ;; ;; --------------------------------------------------------------(Cong)  -------(MkEvenZ)
;; ;; ;;                (=== (Even Z) (Even (double Z)))                       (Even Z)
;; ;; ;;                --------------------------------------------------------------(Replace)
;; ;; ;;                                       (Even (double Z))
;; ;; ;;
;; ;; ;; Or in MeTTa format:
;; ;; ;;
;; ;; ;; (: ((Replace ((((Cong Even) Z) (double Z)) (Sym double_base))) MkEvenZ) (Even (double Z)))
;; (bc &kb (: $prf (Even (double Z))) (fromNumber 6))

;; ;; Prove
;; ;;
;; ;; (-> (: Even (-> (: $_ Nat) Type))
;; ;;     (-> (: (double (S $k)) Nat)
;; ;;         (-> (: (S (S (double $k))) Nat)
;; ;;             (-> (: $eq (=== (double (S $k)) (S (S (double $k)))))
;; ;;                 (=== (Even (double (S $k))) (Even (S (S (double $k)))))))))
;; ;;
;; ;; which should merely be Cong.
;; !(assertEqual
;;   (bc (: $prf (-> (: Even (-> (: $_ Nat) Type))
;;                   (-> (: (double (S $k)) Nat)
;;                       (-> (: (S (S (double $k))) Nat)
;;                           (-> (: $eq (=== (double (S $k)) (S (S (double $k)))))
;;                               (=== (Even (double (S $k))) (Even (S (S (double $k))))))))))
;;       (fromNumber 0))
;;   (: Cong (-> (: Even (-> (: $_ Nat) Type))
;;               (-> (: (double (S $k)) Nat)
;;                   (-> (: (S (S (double $k))) Nat)
;;                       (-> (: $eq (=== (double (S $k)) (S (S (double $k)))))
;;                           (=== (Even (double (S $k))) (Even (S (S (double $k)))))))))))

;; ;; Prove
;; ;;
;; ;; (-> (: (double (S $k)) Nat)
;; ;;     (-> (: (S (S (double $k))) Nat)
;; ;;         (-> (: $eq (=== (double (S $k)) (S (S (double $k)))))
;; ;;             (=== (Even (double (S $k))) (Even (S (S (double $k))))))))
;; ;;
;; ;; which should be (Cong Even).
;; !(assertEqual
;;   (bc (: $prf (-> (: (double (S $k)) Nat)
;;                   (-> (: (S (S (double $k))) Nat)
;;                       (-> (: $eq (=== (double (S $k)) (S (S (double $k)))))
;;                           (=== (Even (double (S $k))) (Even (S (S (double $k)))))))))
;;       (fromNumber 1))
;;   (: (Cong Even) (-> (: (double (S $k)) Nat)
;;                      (-> (: (S (S (double $k))) Nat)
;;                          (-> (: $eq (=== (double (S $k)) (S (S (double $k)))))
;;                              (=== (Even (double (S $k))) (Even (S (S (double $k))))))))))

;; ;; ;; Prove NEXT
;; ;; ;;
;; ;; ;; (-> (: $k Nat)
;; ;; ;;     (-> (: $eq (=== (double (S $k)) (S (S (double $k)))))
;; ;; ;;         (=== (Even (double (S $k))) (Even (S (S (double $k)))))))
;; ;; ;;
;; ;; ;; which could be
;; ;; ;;
;; ;; ;; ((λ $k) (((Cong Even) (double (S $k))) (S (S (double $k)))))
;; ;; ;;
;; ;; ;; or something not involving λ like
;; ;; ;;
;; ;; ;; (((Cong Even) (double (S $k))) (S (S (double $k)))) double_rec
;; ;; ;;
;; ;; ;; (λ $k (f (double_rec $k)))
;; ;; ;;
;; ;; ;; double_rec
;; ;; ;;
;; ;; ;; though this one is wrong, it should be corrected, maybe using flip,
;; ;; ;; composition or such.
;;   (bc &kb (: $prf (-> (: $k Nat)
;;                    (-> (: $eq (=== (double (S $k)) (S (S (double $k)))))
;;                        (=== (Even (double (S $k))) (Even (S (S (double $k))))))))
;;        (fromNumber 7))

;; ;; Prove
;; ;;
;; ;; (-> (: $k Nat) (-> (: Even (-> (: $_ Nat) Type)) (-> (: (double (S $k)) Nat) (-> (: (S (S (double $k))) Nat) (-> (: $eq (=== (double (S $k)) (S (S (double $k))))) (=== (Even (double (S $k))) (Even (S (S (double $k))))))))))
;; ;;
;; ;; (λ $k Cong)
;; (bc &kb (: $prf (-> (: $k Nat)
;;                  (-> (: Even (-> (: $_ Nat) Type))
;;                      (-> (: (double (S $k)) Nat)
;;                          (-> (: (S (S (double $k))) Nat)
;;                              (-> (: $eq (=== (double (S $k)) (S (S (double $k)))))
;;                                  (=== (Even (double (S $k))) (Even (S (S (double $k)))))))))))
;;      (fromNumber 5))

;; ;; Prove that (-> (: $k Nat) (=== (Even (double (S $k))) (Even (S (S (double $k))))))
;; ;;
;; ;; A possible proof tree would be
;; ;;
;; ;;
;; ;; 
;; ;; ----------------------------------------------------------------------------------------------
;; ;; (-> (: $k Nat) (=== (Even (double (S $k))) (Even (S (S (double $k))))))
;; (bc &kb (: $prf (-> (: $k Nat) (=== (Even (double (S $k))) (Even (S (S (double $k))))))) (fromNumber 7))



;; ;; Prove that (=== (Even (S (S (double $k)))) (Even (double (S $k))))
;; ;;
;; ;; (same as above but Sym)
;; ;;
;; (bc &kb (: $prf (=== (Even (S (S (double $k)))) (Even (double (S $k))))) (fromNumber 5))
;; (bc &kb (: $prf (-> (: $k Nat) (=== (Even (S (S (double $k)))) (Even (double (S $k))))) (fromNumber 5)))


;; Prove that if (double k) is even, then (double (S k)) is even
;;
;; A possible proof of that is represented by the following proof tree:
;;
;; NEXT: test subproofs
;;
;;                                                                                                                                                                                         --------------------------------------------------------(double_rec)  ---------($k)
;;                                                                                                                                                                                         (-> (: $k Nat) (=== (double (S $k)) (S (S (double $k)))))             (: $k Nat)
;;                                                                        -------------------(Even)  ----------------------(double (S $k))  --------------------------(S (S (double $k)))  -------------------------------------------------------------------------------(ModusPonens)
;;                                                                        (-> (: $_ Nat) Type)       (: (double (S $k)) Nat)                (: (S (S (double $k))) Nat)                    (=== (double (S $k)) (S (S (double $k))))
;;                                                 -----------------($e)  ---------------------------------------------------------------------------------------------------------------------------------------------------------(Cong)
;;                                                 (Even (double $k))                                           (=== (Even (double (S $k))) (Even (S (S (double $k)))))
;;                                                 -------------------------(MkEvenSS)                          ------------------------------------------------------(Sym)
;;                                                 (Even (S (S (double $k))))                                   (=== (Even (S (S (double $k)))) (Even (double (S $k))))
;;                    -----------------($e)        -------------------------------------------------------------------------------------------------------------------(Replace)
;;                    (Even (double $k))           (Even (double (S $k)))
;; --($k)             --------------------------------------------------(λ)
;; Nat                (-> (: $e (Even (double $k))) (Even (double (S $k))
;; ---------------------------------------------------------------------(λ)
;;  (-> (: $k Nat) (-> (: $e (Even (double $k))) (Even (double (S $k)))
;;
;; Or in MeTTa format:
;;
;; (λ (: $k Nat) (λ (: $e (Even (double $k))) (Replace (MkEvenSS $e) (Sym (Cong Even (double (S $k)) (S (S (double $k))) (ModusPonens double_rec $k))))))
;;
;; NEXT: is it possible to do better by using composition?  ANSWER: probably with composing double_rec, Trans, Sym and Cong

;; ;; NEXT: this fails with the following error
;; ;;
;; ;; thread '<unnamed>' panicked at /home/nilg/Work/TrueAGI/hyperon-experimental/lib/src/atom/matcher.rs:199:14:
;; ;; Unexpected state
;; ;; note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
;; ;; fatal runtime error: Rust panics must be rethrown
;; ;; Aborted (core dumped)
;; (bc &kb (: $prf (-> (: $k Nat) (-> (: $e (Even (double $k))) (Even (double (S $k)))))) (fromNumber 8))

;; ;; ;; Prove that for all x, (double x) is even
;; ;; (bc &kb (: $prf (-> (: $x Nat) (Even (double $x)))) (fromNumber 3))
