;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Example of doing modal logic in MeTTa.  By that I mean, being able ;;
;; to dynamically change the knowledge base (aka environment) while   ;;
;; reasoning.  For instance the chainer can enter the context of      ;;
;; someone's beliefs, reason inside that context, then export the     ;;
;; conclusions back to the universal context.                         ;;
;;                                                                    ;;
;; Some notations are borrowed from                                   ;;
;;                                                                    ;;
;; https://en.wikipedia.org/wiki/Doxastic_logic                       ;;
;;                                                                    ;;
;; but the example does not attempt to emulate everything in the      ;;
;; wikipedia page, far from it, only the idea of dynamically moving   ;;
;; in and out of a believer's context.                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;
;; List ;;
;;;;;;;;;;

;; Declaration of List data type and constructors
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

;; Fold a tuple from right to left
(: foldr (-> (-> $a $b $b)  ; Binary operator
             $b             ; Initial value
             $c             ; Container
             $b))
(= (foldr $f $i $xs)
   (if (== $xs ())
       $i
       (let* (($h (car-atom $xs))
              ($t (cdr-atom $xs))
              ($ft (foldr $f $i $t)))
         ($f $h $ft))))

;; Test foldr
!(assertEqual
  (foldr + 0 (1 2 3))
  6)
!(assertEqual
  (foldr Cons Nil (A B C))
  (Cons A (Cons B (Cons C Nil))))

;;;;;;;;;;;;;;;;;;;;;
;; Match over list ;;
;;;;;;;;;;;;;;;;;;;;;

;; Similar to match but takes a list of terms instead of a space.
(: match' (-> (List Atom) $a $a $a))
(= (match' Nil $pattern $rewrite) (empty))
(= (match' (Cons $head $tail) $pattern $rewrite) (let $pattern $head $rewrite))
(= (match' (Cons $head $tail) $pattern $rewrite) (match' $tail $pattern $rewrite))

;; Test match' on empty list
!(assertEqualToResult
  (match' Nil ($x $y) ($y $x))
  ())

;; Test match' on singleton
!(assertEqual
  (match' (Cons (A B) Nil) ($x $y) ($y $x))
  (B A))

;; Test match' on pair
!(assertEqualToResult
  (match' (Cons (A B) (Cons (C D) Nil)) ($x $y) ($y $x))
  ((B A)
   (D C)))

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Backward Chainer with environment for supporting modal logic.  In
;; addition to generic proof application rule, modal rules are also
;; implemented, directly hardwired in the backward chainer.  The code
;; for these modal rules can be found further below under the
;; Knowledge Base section.
;;
;; The arguments of the backward chainer are:
;;
;; * Knowledge base: reference to a space containing axioms and rules
;;   in the format (: <NAME> <RULE>).  Rules may or may not be curried
;;   depending on the convenience of the situation.
;;
;; * Environment: contextual knowledge about the belief of an agent.
;;   For instance, if John believes that the Earth is flat in the
;;   universal context, i.e. (: bjef (ℬ John (-> Earth Flat))),
;;   then the environment will contain
;;
;;   (: (π bjef) (-> Earth Flat))
;;
;;   where π is a projection operator.  Thus
;;
;;   (π bjef)
;;
;;   represents the proof that the Earth is Flat inside the context of
;;   what John believes.
;;
;; * Maximum depth: maximum depth of the generated proof tree.
;;
;; * Query: a metta term of the form (: <PROOF> <THEOREM>) where
;;   <PROOF> and <THEOREM> may contain free variables that may be
;;   filled by the backward chainer.
(: bc (-> $a                            ; Knowledge base space
          (List $b)                     ; Environment
          Nat                           ; Maximum depth
          $c                            ; Query
          $c))                          ; Result

;; Base cases
;; Match the knowledge base
(= (bc $kb $env $_ (: $prf $thrm))
   (match $kb (: $prf $thrm) (: $prf $thrm)))
;; Match the environment
(= (bc $kb $env $_ (: $prf $thrm))
   (match' $env (: $prf $thrm) (: $prf $thrm)))

;; Recursive steps
;; Unary proof application
(= (bc $kb $env (S $k) (: ($prfabs $prfarg) $thrm))
   (let* (;; Recursive call to discover a proof abstraction
          ((: $prfabs (-> $prms $thrm))
           (bc $kb $env $k (: $prfabs (-> $prms $thrm))))
          ;; Recursive call to prove the premise
          ((: $prfarg $prms)
           (bc $kb $env $k (: $prfarg $prms))))
     (: ($prfabs $prfarg) $thrm)))

;;;;;;;;;;;;;;;;;;;;
;; Knowledge base ;;
;;;;;;;;;;;;;;;;;;;;

;; Space containing the knowledge base, what is true in the universal
;; context.
!(bind! &kb (new-space))

;; What is flat is mathematical
!(add-atom &kb (: fm (-> Flat Mathematics)))

;; John believes the Earth is flat
!(add-atom &kb (: bjef (ℬ John (-> Earth Flat))))

;; John believes that what is mathematical is divine
!(add-atom &kb (: bjmd (ℬ John (-> Mathematics Divine))))

;; Function composition (aka deduction)
!(add-atom &kb (: . (-> (-> $b $c)
                        (-> (-> $a $b)
                            (-> $a $c)))))

;; Given that knowledge the idea is to emulate the reasoning leading
;; to John believing that the Earth is divine, but in such a way that
;; the reasoning path goes from the universal context to the context
;; of what John believes, in that context infer that the Earth is
;; divine, then go back to the universal context to infer that John
;; believes that the Earth is divine.
;;
;; The proof tree would look like:
;;
;;                        -------------------------
;;                        Γ ⊢ (-> Flat Mathematics)
;;                       --------------------------  -------------------------
;;                       Γ' ⊢ (-> Flat Mathematics)  Γ' ⊢ (Mathematics Divine)
;; --------------------  ----------------------------------------------------(.)
;; Γ' ⊢ (-> Earth Flat)                  Γ' ⊢ (-> Flat Divine)
;; ----------------------------------------------------------(.)
;;                   Γ' ⊢ (-> Earth Divine)
;;               ------------------------------
;;               Γ ⊢ (ℬ John (-> Earth Divine))
;;
;; where Γ is the unversal context, while Γ' is the context of what
;; John believes.  That proof tree hides the work involved in building
;; Γ' but that is the job of the backward chainer.

;; Modal rule to go backward from a belief, $x, by some agent, $c,
;; expressed as (ℬ $c $x) in the universal context to the content of
;; that belief expressed as $x in the context of what this agent
;; believes.
;;
;; The operaotr δ (from δόξα, which means belief in Greek) is used as
;; constructor to go from the proof $x_prf of a belief $x in the
;; context of what $c believes to the universal context.  So if we
;; have
;;
;; (: $prf $x)
;;
;; in the context of what $c believes, then we can define
;;
;; (: (δ $c $prf) (ℬ $c $x))
;;
;; in the universal context.  Likewise, π is the inverse of δ, it
;; allows to project the proof of the belief of an agent in the
;; universal context to the proof of that belief in the context of the
;; agent's beliefs.  So if we have
;;
;; (: $prf (ℬ $c $x))
;;
;; in the universe context, then we can define
;;
;; (: (π $prf) $x)
;;
;; in the context of the agent's belief.
;;
;; TODO: the operation of building the new environment of the agent's
;; beliefs is currently very expensive, but I believe that can be
;; considerably optimized by using the proper built-ins.  For instance
;; it may be constant time in MORK.  Memoizing could help as well.
(= (bc $kb $env (S $k) (: (δ $c $prf) (ℬ $c $x)))
   (let* (;; Collect the beliefs of $c from the universal context
          ($cbs (collapse (match $kb (: $bcy_prf (ℬ $c $y)) (: (π $bcy_prf) $y))))
          ;; Build new environment for the recurive call
          ($νenv (foldr Cons $env $cbs))
          ;; Recursive call to prove $x in $νenv
          ((: $prf $x) (bc $kb $νenv $k (: $prf $x))))
     (: (δ $c $prf) (ℬ $c $x))))

;;;;;;;;;;;
;; Tests ;;
;;;;;;;;;;;

;; Find a proof that Mathematics is Divine in the context of John's
;; beliefs
!(assertEqual
  (bc &kb
      (Cons (: (π bjmd) (-> Mathematics Divine)) (Cons (: (π bjef) (-> Earth Flat)) Nil))
      (fromNumber 0)
      (: $prf (-> Mathematics Divine)))
  (: (π bjmd) (-> Mathematics Divine)))

;; Find a proof that the Earth is Flat in the context of John's
;; beliefs
!(assertEqual
  (bc &kb
      (Cons (: (π bjmd) (-> Mathematics Divine)) (Cons (: (π bjef) (-> Earth Flat)) Nil))
      (fromNumber 0)
      (: $prf (-> Earth Flat)))
  (: (π bjef) (-> Earth Flat)))

;; Find a proof that Flat is Mathematics in both the context of John's
;; beliefs and the universal context.
!(assertEqual
  (bc &kb
      (Cons (: (π bjmd) (-> Mathematics Divine)) (Cons (: (π bjef) (-> Earth Flat)) Nil))
      (fromNumber 0)
      (: $prf (-> Flat Mathematics)))
  (: fm (-> Flat Mathematics)))

;; Infer type of .
!(assertAlphaEqual
  (bc &kb Nil (fromNumber 0) (: . $t))
  (: . (-> (-> $b $c)
           (-> (-> $a $b)
               (-> $a $c)))))

;; Type check (: . (-> (-> Mathematics Divine) (-> (-> Flat Mathematics) (-> Flat Divine))))
!(assertEqual
  (bc &kb
      (Cons (: (π bjmd) (-> Mathematics Divine)) (Cons (: (π bjef) (-> Earth Flat)) Nil))
      (fromNumber 0)
      (: . (-> (-> Mathematics Divine) (-> (-> Flat Mathematics) (-> Flat Divine)))))
  (: . (-> (-> Mathematics Divine) (-> (-> Flat Mathematics) (-> Flat Divine)))))

;; Type check (: (. (π bjmd)) (-> (-> Flat Mathematics) (-> Flat Divine)))
!(assertEqual
  (bc &kb
      (Cons (: (π bjmd) (-> Mathematics Divine)) (Cons (: (π bjef) (-> Earth Flat)) Nil))
      (fromNumber 1)
      (: (. (π bjmd)) (-> (-> Flat Mathematics) (-> Flat Divine))))
  (: (. (π bjmd)) (-> (-> Flat Mathematics) (-> Flat Divine))))

;; Infer type of ((. (π bjmd)) fm) using both the context of John's
;; beliefs and the universal context.
!(assertEqual
  (bc &kb
      (Cons (: (π bjmd) (-> Mathematics Divine)) (Cons (: (π bjef) (-> Earth Flat)) Nil))
      (fromNumber 2)
      (: ((. (π bjmd)) fm) $t))
  (: ((. (π bjmd)) fm) (-> Flat Divine)))

;; Find a proof that Flat is Divine in both the context of John's
;; beliefs and the universal context.
!(assertEqual
  (bc &kb
      (Cons (: (π bjmd) (-> Mathematics Divine)) (Cons (: (π bjef) (-> Earth Flat)) Nil))
      (fromNumber 2)
      (: $prf (-> Flat Divine)))
  (: ((. (π bjmd)) fm) (-> Flat Divine)))

;; Find a proof that the Earth is Mathematics in both the context of
;; John's beliefs and the universal context.
!(assertEqual
  (bc &kb
      (Cons (: (π bjmd) (-> Mathematics Divine)) (Cons (: (π bjef) (-> Earth Flat)) Nil))
      (fromNumber 2)
      (: $prf (-> Earth Mathematics)))
  (: ((. fm) (π bjef)) (-> Earth Mathematics)))

;; Find a proof that the Earth is Divine in the context of John's
;; beliefs
!(assertEqual
  (bc &kb
      (Cons (: (π bjmd) (-> Mathematics Divine)) (Cons (: (π bjef) (-> Earth Flat)) Nil))
      (fromNumber 3)
      (: $prf (-> Earth Divine)))
  (: ((. (π bjmd)) ((. fm) (π bjef))) (-> Earth Divine)))

;; Find a proof that John believes that the Earth is Divine
!(assertEqual
  (bc &kb Nil (fromNumber 4) (: $prf (ℬ John (-> Earth Divine))))
  (: (δ John ((. (π bjmd)) ((. fm) (π bjef))))
     (ℬ John (-> Earth Divine))))
