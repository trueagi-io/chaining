;; Experiment to verify or rediscover proofs of the propositional
;; calculus fragment of set theory of Metamath.

;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;; ;;
;; ;; Functions ;; ;;
;; ;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;
;; Maybe ;;
;;;;;;;;;;;

;; Define Maybe type
(: Maybe (-> $a Type))
(: Nothing (Maybe $a))
(: Just (-> $a (Maybe $a)))

;;;;;;;;;;
;; List ;;
;;;;;;;;;;

;; Declaration of List data type and constructors
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

;;;;;;;;;;;;;;;;;;;;;
;; Match over list ;;
;;;;;;;;;;;;;;;;;;;;;

;; Similar to match but takes a list of terms instead of a space.
(: match' (-> (List $a) $a $a $a))
(= (match' Nil $ptrn $tmpl) (empty))
(= (match' (Cons $hd $tl) $ptrn $tmpl) (let $ptrn $hd $tmpl))
(= (match' (Cons $hd $tl) $ptrn $tmpl) (match' $tl $ptrn $tmpl))

;; Test match' on empty list
!(test
  (collapse (match' Nil ($x $y) ($y $x)))
  ())

;; Test match' on singleton
!(test
  (collapse (match' (Cons (A B) Nil) ($x $y) ($y $x)))
  ((B A)))

;; Test match' on pair
!(test
  (collapse (match' (Cons (A B) (Cons (C D) Nil)) ($x $y) ($y $x)))
  ((B A)
   (D C)))

;;;;;;;;;;
;; Fold ;;
;;;;;;;;;;

;; Fold a tuple from right to left
;; (: foldr (-> (-> $a $b $b) $b $c $d))
(= (foldr $f $i $xs)
   (if (== $xs ())
       $i
       (let* (($h (car-atom $xs))
              ($t (cdr-atom $xs))
              ($ft (foldr $f $i $t)))
         ($f $h $ft))))

;; Test foldr
!(test
  (foldr + 0 (1 2 3))
  6)

;;;;;;;;;;;;;;;
;; Successor ;;
;;;;;;;;;;;;;;;

;; Increment a number by 1
(: succ (-> Number Number))
(= (succ $n) (+ 1 $n))

;;;;;;;;;
;; Map ;;
;;;;;;;;;

(: map (-> (-> $a $b) $c $d))
(= (map $f $xs) (case $xs
                  (;; Empty expression
                   (() ())
                   ;; Non-empty expression
                   ($xs (let* (($h (car-atom $xs))
                               ($t (cdr-atom $xs))
                               ($fh ($f $h))
                               ($ft (map $f $t)))
                          (cons-atom $fh $ft))))))

;; Test map
!(test
  (map succ (0 1 2))
  (1 2 3))

;;;;;;;;;;;;;;;;;
;; Max element ;;
;;;;;;;;;;;;;;;;;

;; Given a tuple of numbers, return the maximum, or 0 if empty.
(: max-element (-> $a Number))
(= (max-element $expr) (foldr max 0 $expr))

;; Test max-element
!(test
  (max-element (1 3 2))
  3)

;;;;;;;;;;;;;;;
;; Max index ;;
;;;;;;;;;;;;;;;

;; Extract the maximum index of a corpus in a given space
(: max-index (-> $a Number))
(= (max-index $spc)
   (max-element (collapse (match $spc (MkIndexed $idx $asrt) $idx))))

;;;;;;;;;;;
;; Until ;;
;;;;;;;;;;;

;; Test if the input is equal to a given value
(: equal-to-10 (-> Number Bool))
(= (equal-to-10 $x) (== 10 $x))

;; Loop-like function ported from Haskell.  Iterate applying a given
;; function till some condition is reached.
(: until (-> (-> $a Bool)               ; Predicate
             (-> $a $a)                 ; Next
             $a                         ; Initial value
             $a))                       ; Final value
(= (until $p $f $x)
   (trace! (👁 until $p $f $x)
   (if ($p $x) $x (until $p $f ($f $x)))))

;; Test until
!(test
  (until equal-to-10 succ 0)
  10)

;;;;;;;;;;;;;;;;
;; Term depth ;;
;;;;;;;;;;;;;;;;

;; Return the depth of a term.  If the term is a symbol then the depth
;; is 0.  Likewise the depth of (R A B) is 1, etc.
(: term-depth (-> $a Number))
(= (term-depth $term)
   (case (get-metatype $term)
     (;; Symbol
      (Symbol 0)
      ;; Grounded
      (Grounded 0)
      ;; Variable
      (Variable 0)
      ;; Expression
      (Expression (+ (max-element (map term-depth $term)) 1)))))

;; Test term-depth
!(test
  (term-depth A)
  0)
!(test
  (term-depth (R A (S B C)))
  2)

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Backward Chainer with support for environment and lambda
;; abstraction.
;;
;; The arguments of the backward chainer are:
;;
;; * Knowledge base: reference to a space containing axioms and rules
;;   in the format (: <NAME> <RULE>).  Rules may or may not be curried
;;   depending on the convenience of the situation.
;;
;; * Environment: a list of typing relationships such as
;;
;;   (Cons (: z 𝐁𝐨𝐨𝐥) (Cons (: (s z) 𝐁𝐨𝐨𝐥) Nil))
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
          (List $b)                     ; Environment
          Nat                           ; Maximum depth
          $c                            ; Query
          $c))                          ; Result

;; Base cases

;; Match the knowledge base
(= (bc $kb $env $_ (: $x $a)) (match $kb (: $x $a) (: $x $a)))
;; Match the environment
(= (bc $kb $env $_ (: $x $a)) (match' $env (: $x $a) (: $x $a)))

;; Recursive steps

;; Unary proof abstraction
(= (bc $kb $env (S $k) (: (λ $x $y) (-> $a $b)))
   (let (: $y $b) (bc $kb (Cons (: $x $a) $env) $k (: $y $b))
     (: (λ $x $y) (-> $a $b))))
;; Binary proof abstraction
(= (bc $kb $env (S $k) (: (λ $x $y $z) (-> $a $b $c)))
   (let (: $z $c) (bc $kb (Cons (: $x $a) (Cons (: $y $b) $env)) $k (: $z $c))
     (: (λ $x $y $z) (-> $a $b $c))))

;; Unary proof application
(= (bc $kb $env (S $k) (: ($f $x) $b))
   (let* (;; Recurse on unary rule
          ((: $f (-> $a $b)) (bc $kb $env $k (: $f (-> $a $b))))
          ;; Recurse on premise
          ((: $x $a) (bc $kb $env $k (: $x $a))))
     (: ($f $x) $b)))
;; Binary proof application
(= (bc $kb $env (S $k) (: ($f $x $y) $c))
   (let* (;; Recurse on binary rule
          ((: $f (-> $a $b $c)) (bc $kb $env $k (: $f (-> $a $b $c))))
          ;; Recurse on premise 1
          ((: $x $a) (bc $kb $env $k (: $x $a)))
          ;; Recurse on premise 2
          ((: $y $b) (bc $kb $env $k (: $y $b))))
     (: ($f $x $y) $c)))

;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;; ;;
;; ;; Tests ;; ;;
;; ;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;

;; Import the propositional calculus corpus in the format
;; (MkIndexed INDEX (MkAxiom LABEL AXIOM))
;; (MkIndexed INDEX (MkTheorem LABEL PROOF THEOREM))
!(import! &pc-idxd propositional-calculus)

;; Retrieve the maximum index of the propositional calculus corpus
!(bind! &midx (max-index &pc-idxd))

;; In case the input number is something, then return True iff it is
;; equal of the maximum index of the propositional calculus indexed
;; corpus.  If the input number is nothing, then return True as well
;; because it means that a verification has failed and thus the
;; experiment should be aborted.
(: equal-to-maxidx (-> (Maybe Number) Bool))
(= (equal-to-maxidx $midx)
   (trace! (👁 equal-to-maxidx $midx)
   (case $midx
     (;; Just
      ;; ((Just $idx) (== (max-index &pc-idxd) $idx)) ; TODO: use &midx
      ((Just $idx) (== 3 $idx)) ; TODO: use &midx
      ;; Nothing
      (Nothing True)))))

;; Create a propositional calculus knowledge base, containing type
;; theoretic representation of assertions like
;;
;; (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑)))
;; (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))))
;; (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)))
;; (: ax-mp (-> $𝜑 (→ $𝜑 $𝜓) $𝜓))
!(bind! &pc-kb (new-space))

;; Process the assertion corresponding to the given index and return
;; the index of the next assertion to process.  Meaning, if the
;; assertion is an axiom, insert the axiom in the knowledge base, and
;; if the assertion is a theorem, verify the theorem and then insert
;; it in the knowledge base as if it were an axiom.
(: process-assertion-step (-> (Maybe Number) (Maybe Number)))
(= (process-assertion-step $midx)
   (case $midx
     (;; Just
      ((Just $idx)
       (case (match &pc-idxd (MkIndexed $idx $asrt) $asrt)
         (;; Axiom
          ((MkAxiom $label $axiom)
           (progn (trace! (👁 "Add axiom" (: $label $axiom))
                          (add-atom &pc-kb (: $label $axiom)))
                  (Just (+ $idx 1))))
          ;; Theorem
          ((MkTheorem $label $proof $thrm)
           (progn (trace! (👁 "Add theorem" (: $label $thrm))
                          (add-atom &pc-kb (: $label $thrm)))
                  (Just (+ $idx 1)))))))
           ;; (let $depth (fromNumber (proof-depth $proof))
           ;;   (case (bc &pc-kb Nil $depth (: $proof $thrm))
           ;;     (;; Verified
           ;;      ((: $proof $thrm) (progn (add-atom &pc-kb (: $label $thrm))
           ;;                               (Just (+ $idx 1))))
           ;;      ;; Not verified
           ;;      (Empty Nothing))))))))
      ;; Nothing
      (Nothing Nothing))))

;; Run verification loop
!(until equal-to-maxidx process-assertion-step (Just 0))
!(get-atoms &pc-kb)
