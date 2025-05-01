;; Inference control experiment using PLN as inference controller,
;; alpha version.
;;
;; It is an evolutionary step over rnd-inf-ctl.metta in that
;;
;; 1. It takes an inferential context, corresponding to other premises
;;    surrounding a particular recursive backward chainer call.
;;
;; 2. Given the current query and its surrounding context, it
;;    formulates a PLN query expressing an estimate of how promising
;;    that query is.
;;
;; The corpus is based on the propositional calculus of
;;
;; https://us.metamath.org/mpeuni/mmtheorems1.html

;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;; ;;
;; ;; Utils ;; ;;
;; ;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;
;; De Bruijn Index ;;
;;;;;;;;;;;;;;;;;;;;;

;; Define DeBruijn type and constructors.
(: DeBruijn Type)
(: z DeBruijn)
(: s (-> DeBruijn DeBruijn))

;; Convert Nat to DeBruijn
(: toDeBruijn (-> Nat DeBruijn))
(= (toDeBruijn Z) z)
(= (toDeBruijn (S $k)) (s (toDeBruijn $k)))

;;;;;;;;;;;
;; Maybe ;;
;;;;;;;;;;;

;; Define Maybe type
(: Maybe (-> $a Type))
(: Nothing (Maybe $a))
(: Just (-> $a (Maybe $a)))

;;;;;;;;;;
;; Pair ;;
;;;;;;;;;;

;; Pair type and constructor
(: Pair (-> $a $b Type))
(: MkPair (-> $a $b (Pair $a $b)))

;; Pair access functions
(: fst (-> (Pair $a $b) $a))
(: snd (-> (Pair $a $b) $b))

;;;;;;;;;;;
;; Until ;;
;;;;;;;;;;;

;; Add 1
(: succ (-> Number Number))
(= (succ $n) (+ 1 $n))

;; Loop-like function ported from Haskell.  Iterate applying a given
;; function till some condition is reached.
(: until (-> (-> $a Bool)               ; Predicate
             (-> $a $a)                 ; Next
             $a                         ; Initial value
             $a))                       ; Final value
(= (until $p $f $x)
   (if ($p $x) $x (until $p $f ($f $x))))

;; Test until
(: until.test.p (-> Number Bool))
(= (until.test.p $n) (== $n 10))
!(assertEqual
  (until until.test.p succ 0)
  10)

;;;;;;;;;;
;; List ;;
;;;;;;;;;;

;; Declaration of List data type and constructors
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

;; Build a list from an expression, containing all the sub-expressions
;; as elements of the list.
(: List.fromExpression (-> Expression (List $a)))
(= (List.fromExpression $expr)
   (if (== $expr ())
       Nil
       (let* (($head (car-atom $expr))
              ($tail (cdr-atom $expr)))
         (Cons $head (List.fromExpression $tail)))))

;; Return the maximum between two value given a certain less than
;; predicate.
(: maxWith (-> (-> $a $a Bool) $a $a Bool))
(= (maxWith $lt $x $y)
   (if ($lt $x $y) $y $x))

;; Return a maximum element of a non empty list, given a certain less
;; than predicate.
(: List.maxElementWith (-> (-> $a $a Bool) (List $a) $a))
(= (List.maxElementWith $lt (Cons $head $tail))
   (case $tail
     ((Nil $head)
      ($else (let $met (List.maxElementWith $lt $tail)
               (maxWith $lt $head $met))))))

;; Fold a List from right to left
(: List.foldr (-> (-> $a $b $b) $b (List $a) $b))
(= (List.foldr $f $i Nil) $i)
(= (List.foldr $f $i (Cons $h $t)) ($f $h (List.foldr $f $i $t)))

;; Fold a List from left to right
(: List.foldl (-> (-> $b $a $b) $b (List $a) $b))
(= (List.foldl $f $i Nil) $i)
(= (List.foldl $f $i (Cons $h $t)) (List.foldl $f ($f $i $h) $t))

;; Define List.append (concatenate two lists).
(: List.append (-> (List $a) (List $a) (List $a)))
(= (List.append $xs $ys) (List.foldr Cons $ys $xs))

;; Test List.append
!(assertEqual
  (List.append (Cons a (Cons b Nil)) (Cons c (Cons d Nil)))
  (Cons a (Cons b (Cons c (Cons d Nil)))))

;; Define List.appendElem that appends an element at the end of a
;; list.
(: List.appendElem (-> (List $a) $a (List $a)))
(= (List.appendElem $xs $x) (List.append $xs (Cons $x Nil)))

;; Define List.elemIndex that returns the index of an element in a
;; List, if it exists.
(: List.elemIndex (-> $a (List $a) (Maybe Nat)))
(= (List.elemIndex $x Nil) Nothing)
(= (List.elemIndex $x (Cons $head $tail))
   (if (== $x $head)
       (Just Z)
       (case (List.elemIndex $x $tail)
         (((Just $k) (Just (S $k)))
          (Nothing Nothing)))))

;; Test List.elemIndex
!(assertEqual (List.elemIndex 42 (Cons 0 (Cons 1 Nil))) Nothing)
!(assertEqual (List.elemIndex 42 (Cons 0 (Cons 42 Nil))) (Just (S Z)))

;; Define List.length
(: List.length (-> (List $a) Nat))
(= (List.length Nil) Z)
(= (List.length (Cons $head $tail)) (S (List.length $tail)))

;; Define List.map
(: List.map (-> (-> $a $b) (List $a) (List $b)))
(= (List.map $f Nil) Nil)
(= (List.map $f (Cons $x $xs)) (Cons ($f $x) (List.map $f $xs)))

;; Test List.map
(: List.map.test.foo (-> Number Number))
(= (List.map.test.foo $x) (+ 1 $x))
!(assertEqual
  (List.map List.map.test.foo (Cons 1 (Cons 2 (Cons 3 Nil))))
  (Cons 2 (Cons 3 (Cons 4 Nil))))

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

;;;;;;;;;;;;;;;;;;
;; Delayed Call ;;
;;;;;;;;;;;;;;;;;;

;; Data structure to carry around function calls without running them.
;; The DCall.runARITY method is used to run a DCall on demand.

;; Parameterized type representing a delayed call of a certain type
;; signature, operator followed by operands
(: DCall (-> Type    ; Output type of a nullary operator
             Type))
(: DCall (-> Type    ; Input type of first operand
             type    ; Output type of a unary operator
             Type))
(: DCall (-> Type    ; Input type of first operand
             Type    ; Input type of second operand
             type    ; Output type of a unary operator
             Type))
(: DCall (-> Type    ; Input type of first operand
             Type    ; Input type of second operand
             Type    ; Input type of third operand
             type    ; Output type of a unary operator
             Type))
(: DCall (-> Type    ; Input type of first operand
             Type    ; Input type of second operand
             Type    ; Input type of third operand
             Type    ; Input type of fourth operand
             type    ; Output type of a unary operator
             Type))

;; DCall data constructors
(: MkDCall (-> (-> $a) (DCall $a)))                    ; Nullary
(: MkDCall (-> (-> $a $b) $a (DCall $a $b)))           ; Unary
(: MkDCall (-> (-> $a $b $c) $a $b (DCall $a $b $c)))  ; Binary
(: MkDCall (-> (-> $a $b $c $d)
               $a $b $c
               (DCall $a $b $c $d)))                   ; Ternary
(: MkDCall (-> (-> $a $b $c $d $e)
               $a $b $c $d
               (DCall $a $b $c $d $e)))                ; Quaternary
(: MkDCall (-> (-> $a $b $c $d $e $f)
               $a $b $c $d $e
               (DCall $a $b $c $d $e $f)))             ; Quinary

;; Run a nullary DCall
(: DCall.run0 (-> (DCall $a) $a))
(= (DCall.run0 (MkDCall $f)) ($f))
;; Run a unary DCall
(: DCall.run1 (-> (DCall $a $b) $b))
(= (DCall.run1 (MkDCall $f $x)) ($f $x))
;; Run a binary DCall
(: DCall.run2 (-> (DCall $a $b $c) $c))
(= (DCall.run2 (MkDCall $f $x $y)) ($f $x $y))
;; Run a ternary DCall
(: DCall.run3 (-> (DCall $a $b $c $d) $d))
(= (DCall.run3 (MkDCall $f $x $y $z)) ($f $x $y $z))
;; Run a Quaternary DCall
(: DCall.run4 (-> (DCall $a $b $c $d $e) $e))
(= (DCall.run4 (MkDCall $f $x $y $z $w)) ($f $x $y $z $w))
;; Run a Quinary DCall
(: DCall.run5 (-> (DCall $a $b $c $d $e $f) $f))
(= (DCall.run5 (MkDCall $g $x $y $z $w $v)) ($g $x $y $z $w $v))

;;;;;;;;;;;;;;;;
;; Test DCall ;;
;;;;;;;;;;;;;;;;

(: foo (-> Number))
(= (foo) 42)
(: bar (-> Bool String))
(= (bar $x) (if $x "True" "False"))
(: baz (-> String Number Bool))
(= (baz $x $y) (and (== $x "abc") (== $y 42)))
(: qux (-> Number Bool String Atom))
(= (qux $x $y $z) (R $x $y $z))
(: quux (-> Number Bool String Number Atom))
(= (quux $x $y $z $w) (RS $x $y $z $w))
(: corge (-> Number Bool String Number Bool Atom))
(= (corge $x $y $z $w $v) (T $x $y $z $w $v))

;; Test foo wrapped in a DCall
!(assertEqual
  (DCall.run0 (MkDCall foo))
  42)

;; Test bar wrapped in a DCall
!(assertEqual
  (DCall.run1 (MkDCall bar True))
  "True")

;; Test baz wrapped in a DCall
!(assertEqual
  (DCall.run2 (MkDCall baz "abc" 42))
  True)

;; Test qux wrapped in a DCall
!(assertEqual
  (DCall.run3 (MkDCall qux 42 True "abc"))
  (R 42 True "abc"))

;; Test quux wrapped in a DCall
!(assertEqual
  (DCall.run4 (MkDCall quux 42 True "abc" 42))
  (RS 42 True "abc" 42))

;; Test corge wrapped in a DCall
!(assertEqual
  (DCall.run5 (MkDCall corge 42 True "abc" 42 False))
  (T 42 True "abc" 42 False))

;;;;;;;;;;;;;;;;;;;;
;; Estimate DCall ;;
;;;;;;;;;;;;;;;;;;;;

;; Data structure containing a value estimating the probability of
;; success associated to a DCall

;; Parameterized type representing a pair of estimate and assocated
;; delayed call of a certain type signature, operator followed by
;; operands
(: EDCall (-> Type    ; Output type of a nullary operator
              Type))
(: EDCall (-> Type    ; Input type of first operand
              type    ; Output type of a unary operator
              Type))
(: EDCall (-> Type    ; Input type of first operand
              Type    ; Input type of second operand
              type    ; Output type of a unary operator
              Type))
(: EDCall (-> Type    ; Input type of first operand
              Type    ; Input type of second operand
              Type    ; Input type of third operand
              type    ; Output type of a unary operator
              Type))
(: EDCall (-> Type    ; Input type of first operand
              Type    ; Input type of second operand
              Type    ; Input type of third operand
              Type    ; Input type of fourth operand
              type    ; Output type of a unary operator
              Type))

;; EDCall data constructors
(: MkEDCall (-> Number     ; Estimate
                (DCall $a) ; Nullary DCall
                (EDCall $a)))
(: MkEDCall (-> Number        ; Estimate
                (DCall $a $b) ; Unary DCall
                (EDCall $a $b)))
(: MkEDCall (-> Number           ; Estimate
                (DCall $a $b $c) ; Binary DCall
                (EDCall $a $b $c)))
(: MkEDCall (-> Number              ; Estimate
                (DCall $a $b $c $d) ; Ternary DCall
                (EDCall $a $b $c $d)))
(: MkEDCall (-> Number                 ; Estimate
                (DCall $a $b $c $d $e) ; Quaternary DCall
                (EDCall $a $b $c $d $e)))
(: MkEDCall (-> Number                    ; Estimate
                (DCall $a $b $c $d $e $f) ; Quinary DCall
                (EDCall $a $b $c $d $e $f)))

;; Less than predicate over EDCall objects of same signature.  Compare
;; their estimates.
(: EDCall.lt0 (-> (EDCall $a) (EDCall $a) Bool))
(= (EDCall.lt0 (MkEDCall $le (MkDCall $lf))
               (MkEDCall $re (MkDCall $rf)))
   (< $le $re))
(: EDCall.lt1 (-> (EDCall $a $b) (EDCall $a $b) Bool))
(= (EDCall.lt1 (MkEDCall $le (MkDCall $lf $lx))
               (MkEDCall $re (MkDCall $rf $rx)))
   (< $le $re))
(: EDCall.lt2 (-> (EDCall $a $b $c) (EDCall $a $b $c) Bool))
(= (EDCall.lt2 (MkEDCall $le (MkDCall $lf $lx $ly))
               (MkEDCall $re (MkDCall $rf $rx $ry)))
   (< $le $re))
(: EDCall.lt3 (-> (EDCall $a $b $c $d) (EDCall $a $b $c $d) Bool))
(= (EDCall.lt3 (MkEDCall $le (MkDCall $lf $lx $ly $lz))
               (MkEDCall $re (MkDCall $rf $rx $ry $rz)))
   (< $le $re))
(: EDCall.lt4 (-> (EDCall $a $b $c $d $e) (EDCall $a $b $c $d $e) Bool))
(= (EDCall.lt4 (MkEDCall $le (MkDCall $lf $lx $ly $lz $lw))
               (MkEDCall $re (MkDCall $rf $rx $ry $rz $rw)))
   (< $le $re))
(: EDCall.lt5 (-> (EDCall $a $b $c $d $e $f) (EDCall $a $b $c $d $e $f) Bool))
(= (EDCall.lt5 (MkEDCall $le (MkDCall $lg $lx $ly $lz $lw $lf))
               (MkEDCall $re (MkDCall $rg $rx $ry $rz $rw $rf)))
   (< $le $re))

;; Test EDCall
!(assertEqual
  (EDCall.lt0 (MkEDCall 0.9 (MkDCall foo))
              (MkEDCall 0.2 (MkDCall foo)))
  False)
!(assertEqual
  (EDCall.lt1 (MkEDCall 0.3 (MkDCall bar False))
              (MkEDCall 0.6 (MkDCall bar True)))
  True)
!(assertEqual
  (EDCall.lt2 (MkEDCall 0.4 (MkDCall baz "abc" 42))
              (MkEDCall 0.5 (MkDCall baz "def" 24)))
  True)
!(assertEqual
  (EDCall.lt3 (MkEDCall 0.2 (MkDCall qux 42 True "abc"))
              (MkEDCall 0.1 (MkDCall qux 24 False "def")))
  False)
!(assertEqual
  (EDCall.lt4 (MkEDCall 0.2 (MkDCall quux 42 True "abc" 42))
              (MkEDCall 0.3 (MkDCall quux 24 False "def" 24)))
  True)
!(assertEqual
  (EDCall.lt5 (MkEDCall 0.6 (MkDCall corge 42 True "abc" 42 True))
              (MkEDCall 0.3 (MkDCall corge 24 False "def" 24 False)))
  False)

;; Test taking the max of two EDCalls
(: EDCalls.test.foo (-> $a $b $c $c))
(= (EDCalls.test.foo $x $y $z) $z)
(: EDCalls.test.bar (-> $a $b $c $c))
(= (EDCalls.test.bar $x $y $z) $z)
!(assertEqual
  (maxWith EDCall.lt3
           (MkEDCall 0.9 (MkDCall EDCalls.test.foo Nil Z (: ax1 T1)))
           (MkEDCall 0.8 (MkDCall EDCalls.test.bar Nil Z (: ax2 T2))))
  (MkEDCall 0.9 (MkDCall EDCalls.test.foo Nil Z (: ax1 T1))))

;; Run a nullary EDCall
(: EDCall.run0 (-> (EDCall $a) $a))
(= (EDCall.run0 (MkEDCall $estimate (MkDCall $f))) ($f))
;; Run a unary EDCall
(: EDCall.run1 (-> (EDCall $a $b) $b))
(= (EDCall.run1 (MkEDCall $estimate (MkDCall $f $x))) ($f $x))
;; Run a binary EDCall
(: EDCall.run2 (-> (EDCall $a $b $c) $c))
(= (EDCall.run2 (MkEDCall $estimate (MkDCall $f $x $y))) ($f $x $y))
;; Run a ternary EDCall
(: EDCall.run3 (-> (EDCall $a $b $c $d) $d))
(= (EDCall.run3 (MkEDCall $estimate (MkDCall $f $x $y $z))) ($f $x $y $z))
;; Run a quaternary EDCall
(: EDCall.run4 (-> (EDCall $a $b $c $d $e) $e))
(= (EDCall.run4 (MkEDCall $estimate (MkDCall $f $x $y $z $w)))
   ($f $x $y $z $w))
;; Run a quinary EDCall
(: EDCall.run5 (-> (EDCall $a $b $c $d $e $f) $f))
(= (EDCall.run5 (MkEDCall $estimate (MkDCall $g $x $y $z $w $v)))
   ($g $x $y $z $w $v))

;;;;;;;;;;;;;
;; Control ;;
;;;;;;;;;;;;;

;; Control structure holding the inference control, parameterized by
;; the query language.  For now it merely holds a function to estimate
;; the probability of success of a particular branch.
(: Control (-> $a Type))
(MkControl (-> (-> (List $a)            ; Environment
                   (List $a)            ; Context
                   Nat                  ; Depth
                   $a                   ; Query
                   Number)              ; Estimate
               (Control $a)))

;;;;;;;;;
;; PLN ;;
;;;;;;;;;

;; Define PLN TruthValue type and its constructor MkSimpleTruthValue
(: PLN.TruthValue Type)
(: PLN.MkSTV (-> Number    ; Strength
                 Number    ; Confidence
                 PLN.TruthValue))

;; Define PLN Term type.  PLN terms are expressions defining the
;; objects that the PLN predicates can take in input.  To not be
;; confused with PLN connectors such as ∧ and constants such ⊥, PLN
;; terms are surrounded by underscore characters when needed.  So for
;; instance a formula
;;
;; (∧ P Q)
;;
;; can be represented at the object level as
;;
;; (_∧_ _P_ _Q_)
;;
;; We need to do that because in this experiment we reason about 𝛩, a
;; ternary predicate relating theories, proofs and theorems, thus we
;; need a way to represent them at the object level.
(: PLN.Term Type)

;; Make sure that z and s can be typed as PLN.Term as well
(: z PLN.Term)
(: s (-> DeBruijn PLN.Term))

;; Define PLN Term DeBruijn index constructors, used in quantifiers at
;; the object level.
(: PLN.Term.DeBruijn Type)
(: _z_ PLN.Term.DeBruijn)
(: _s_ (-> PLN.Term.DeBruijn PLN.Term.DeBruijn))

;; Make sure that _z_ and _s_ can be typed as PLN.Term as well
(: _z_ PLN.Term)
(: _s_ (-> PLN.Term.DeBruijn PLN.Term))

;; Define axiom and inference rule names as PLN terms
(: _ax-1_ PLN.Term)
(: _ax-2_ PLN.Term)
(: _ax-3_ PLN.Term)
(: _ax-mp_ PLN.Term)
(: _mp2.1_ PLN.Term)
(: _mp2.2_ PLN.Term)
(: _mp2.3_ PLN.Term)
(: _mp2b.1_ PLN.Term)
(: _mp2b.2_ PLN.Term)
(: _mp2b.3_ PLN.Term)
(: _a1i.1_ PLN.Term)
(: _PC_ PLN.Term)
(: _𝜑_ PLN.Term)
(: _𝜓_ PLN.Term)
(: _𝜒_ PLN.Term)

;; Define PLN Term logical connectors at the object level.  NEXT:
;; support PLN.Term.DeBruijn.
(: _→_ (-> PLN.Term PLN.Term PLN.Term))
(: _∧_ (-> PLN.Term PLN.Term PLN.Term))
(: _∨_ (-> PLN.Term PLN.Term PLN.Term))
(: _¬_ (-> PLN.Term PLN.Term))

;; Define typing relationship at the object level.
(: _:_ (-> PLN.Term PLN.Term PLN.Term))

;; Define PLN Statement type.  A PLN statement represents a predicate
;; or conditioned predicate.
(: PLN.Statement Type)

;; Define PLN Statement constructors ∧, ∨, ¬.  Note that these
;; connectors represent in fact pointwise predicate connectors.  So
;; that (∧ P Q) is a predicate resulting from the pointwise
;; conjunction of P and Q, themselves predicates.
(: ∧ (-> PLN.Statement PLN.Statement PLN.Statement))
(: ∨ (-> PLN.Statement PLN.Statement PLN.Statement))
(: ¬ (-> PLN.Statement PLN.Statement))

;; Define PLN Statement constants ⊥ and ⊤, which are also pointwise
;; predicates corresponding respectively to the predicate that returns
;; always False and the predicate that returns always True.  Please do
;; not confuse ⊤ and T.  ⊤ is the top predicate, while T is an upper
;; case letter of the Latin alphabet.  Before you start cursing me to
;; no end for that decision, please consider that the type checker
;; will be able to catch your potential typos.
(: ⊤ PLN.Statement)
(: ⊥ PLN.Statement)

;; Define PLN Statement existential quantifier ∃.  For now we avoid
;; concerns about its semantics, including the interval aspect
;; explained in the PLN book.  Since 𝛩 is deterministic anyway, let's
;; see how far we can go with a crisp version of this quantifier.
;; NEXT: DeBruijn or PLN.DeBruijn?
(: ∃ (-> DeBruijn PLN.Statement PLN.Statement))

;; Define PLN Statement constructors from a set of primitive
;; predicates.  For now only 𝛩, a ternary predicate representing the
;; relationship between theory, proof and theorem, is used.  A theory
;; is a collection of axioms and inference rules, for now encoded as a
;; list of PLN terms.  Even though 𝛩 is completely deterministic, it
;; is treated as probabilistic to cope with the insufficient knowledge
;; and resources about it.  Indeed, 𝛩 is semi-computable at best, thus
;; it is pointless to hope we can ever know everything about.  For
;; that reason, 𝛩 (or any other PLN predicates) has the following
;; underlying type signature
;;
;; 𝛩 : Theory -> Proof -> Theorem -> Ω -> Bool
;;
;; where Ω is the sample space of the underlying probability space.
(: 𝛩 (-> (List PLN.Term) PLN.Term PLN.Term PLN.Statement))

;; Define PLN judgement type and its constructor.  A judgement is a
;; PLN statement alonside its assigned truth value, constructed with
;; the ≞ connector.
(: PLN.Judgement Type)
(: ≞ (-> PLN.Statement PLN.TruthValue PLN.Judgement))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reduce PLN statements ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Reduce PLN statement.  For now it only supports neutral element
;; elimination.
(: PLN.reduce (-> PLN.Statement PLN.Statement))
(= (PLN.reduce $stm)
   (case (get-metatype $stm)
     ((Symbol $stm)
      (Grounded $stm)
      (Expression (case $stm
                    (;; Nullary
                     (() ())
                     ;; Unary
                     (($x) ((PLN.reduce $x)))
                     ;; Binary
                     (($x $y) ((PLN.reduce $x) (PLN.reduce $y)))
                     ;; Ternary
                     ;; →
                     ((→ $x ⊤) ⊤)
                     ((→ ⊤ $x) (PLN.reduce $x))
                     ((→ $x ⊥) (¬ (PLN.reduce $x)))
                     ((→ ⊥ $x) ⊤)
                     ;; ∧
                     ((∧ $x ⊤) (PLN.reduce $x))
                     ((∧ ⊤ $x) (PLN.reduce $x))
                     ((∧ ⊥ $x) ⊥)
                     ((∧ $x ⊥) ⊥)
                     ;; ∨
                     ((∨ $x ⊤) ⊤)
                     ((∨ ⊤ $x) ⊤)
                     ((∨ $x ⊥) (PLN.reduce $x))
                     ((∨ ⊥ $x) (PLN.reduce $x))
                     ;; Other ternary
                     (($x $y $z) ((PLN.reduce $x)
                                  (PLN.reduce $y)
                                  (PLN.reduce $z)))
                     ;; Quaternary
                     ((𝛩 $x $y $z) $stm)
                     ;; Other quaternary
                     (($x $y $z $w) ((PLN.reduce $x)
                                     (PLN.reduce $y)
                                     (PLN.reduce $z)
                                     (PLN.reduce $w)))
                     ;; Quinary
                     (($x $y $z $w $v) ((PLN.reduce $x)
                                        (PLN.reduce $y)
                                        (PLN.reduce $z)
                                        (PLN.reduce $w)
                                        (PLN.reduce $v)))
                     ;; Otherwise
                     ($else (Error $stm "Not supported in PLN.reduce")))))
      ($else (Error (get-metatype $stm) "Not supported in PLN.reduce")))))

;; Test PLN.reduce
!(assertEqual
  (PLN.reduce ⊤)
  ⊤)
!(assertEqual
  (PLN.reduce (𝛩 (Cons _PC_ Nil) z _𝜑_))
  (𝛩 (Cons _PC_ Nil) z _𝜑_))
!(assertEqual
  (PLN.reduce (∧ (𝛩 (Cons _PC_ Nil) z _𝜑_) ⊤))
  (𝛩 (Cons _PC_ Nil) z _𝜑_))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Convert backward chainer call to PLN ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Convert the arguments of a backward chainer call to a PLN judgement
;; such that its truth value reflects how likely the holes in the
;; arguments of the call (the environment, the query and its
;; surrounding premises) can be filled within the provided depth.
;;
;; So for instance, if the backward chainer call is
;;
;; (bc (Cons (: a1i.1 𝜑) Nil)
;;     Nil
;;     (fromNumber 1)
;;     (: $prf (→ 𝜓 𝜑)))
;;
;; thus
;;
;; - the environment is (Cons (: a1i.1 𝜑) Nil)
;; - the query is (: $prf (→ 𝜓 𝜑))
;; - the surrounding premises are Nil
;; - the depth 1
;;
;; would be converted into the following PLN query
;;
;; (∃ z (𝛩 (Cons (_:_ _a1i.1_ _𝜑_) PC) z (_→_ _𝜓_ _𝜑_)) ∧ (depth_lte z 1))
;;
;; where
;;
;; - z is the first De Bruijn index,
;;
;; - all symbols of the logic have been dropped to the object level
;;   (or mesa level), by being surrounded with _.  So for instance, :
;;   becomes _:_, a1i.1 becomes _a1i.1_, → becomes _→_, etc.
;;
;; - The ternary predicate 𝛩 is a PLN predicate representing the
;;   relationship between Theory, Proof and Theorem, in this
;;   respective argument order.  It is also a partial function mapping
;;   its first two arguments, Theory and Proof to the third one,
;;   Theorem.  Meaning, given a theory and a proof, there is at most
;;   one corresponding theorem.  It is partial because not all proof
;;   terms are actually well formed proofs.
;;
;; - The binary predicate depth_lte is true iff the depth of the first
;;   argument is equal or below the number provided as second
;;   argument.
;;
;; Informally, the PLN statement above should be read as
;;
;; There exists a proof z of (→ 𝜓 𝜑), with a maximum depth of 1,
;; within theory (Cons (: a1i.1 𝜑) PC).
;;
;; where the theory includes the static theory PC and its environment
;; (: a1i.1 𝜑).  Note that in this experiment the static part of the
;; theory is hardcoded in the backward chainer.  In general the theory
;; must be completely provided, but here, for the sake of simplicity
;; we will simply hide its description under the symbol PC, which
;; stands for Propositional Calculus.
;;
;; NEXT: support depth.
(: toPLN (-> (List $a)                  ; Theory
             (List $a)                  ; Surrounding premises
             Nat                        ; Maximum Depth
             $a                         ; Query
             PLN.Judgement))            ; PLN judgement
(= (toPLN $thry $ctx $depth (: $prf $type))
   (let* (;; Turn the context into a PLN statement
          ((MkPair $vars $plnctx) (contextToPLN $thry Nil $ctx))
          ;; Turn the query into a PLN statement
          ((MkPair $nvars $plnstm) (queryToPLN $thry $vars (: $prf $type)))
          ;; Build the conjunction of query and context and reduce it
          ($plnred (PLN.reduce (∧ $plnstm $plnctx))))
     ;; Wrap existential quantifiers around the reduced PLN statement
     (variablesToPLN (List.length $nvars) $plnred)))

;; Given a number of variables and a PLN statement containing De
;; Bruijn indices corresponding to these variables, wrap existential
;; quantifiers around the given PLN statement.
(: variablesToPLN (-> Nat             ; Number of variables
                      PLN.Statement   ; PLN statement to be
                                      ; existentially quantified
                      PLN.Statement)) ; Resulting PLN statement
(= (variablesToPLN Z $plnstm) $plnstm)
(= (variablesToPLN (S $k) $plnstm)
   (trace! (👁 variablesToPLN (S $k) $plnstm)
   (∃ (toDeBruijn $k) (variablesToPLN $k $plnstm))))

;; Convert a theory in PLN format
(: theoryToPLN (-> (List $a) (List PLN.Term)))
(= (theoryToPLN $thry) (trace! (👁 theoryToPLN $thry)
                               (List.map typingToPLN $thry)))

;; Convert a typing relationship in PLN format.  It is meant to be
;; called by theoryToPLN thus does not require to update variables as
;; it is assumed that theories have no holes in them (it is an
;; interesting thought to allow holes in theories though).  It is also
;; why the converter outputs a PLN term instead of a PLN statement,
;; because the output is meant to exist at the object level, as a data
;; point of 𝛩.
(: typingToPLN (-> $a PLN.Term))
(= (typingToPLN $tyr)
   (case (get-metatype $tyr)
     ((Symbol (symbolToPLN $tyr))
      (Expression
       (if-decons-expr $tyr $hdtyr $tltyr
                       ;; Non-empty expression
                       (let* (;; Call typingToPLN on head
                              ($hdpln (typingToPLN $hdtyr))
                              ;; Call typeToPLN on tail
                              ($tlpln (typingToPLN $tltyr)))
                         ;; Cons result
                         (cons-atom $hdpln $tlpln))
                       ;; Empty expression
                       ()))
      ($else (Error $tyr "Case not supported in typingToPLN")))))

;; Like toPLN but takes the query and the surrounding premises all at
;; once, called context.  It does not take other parameters like
;; depth.  Additionally, it takes a list of variables encountered so
;; far in the context that has been consumed.  It outputs a pair of
;; list of all variables encountered so far and a PLN proposition as a
;; conjunction of 𝛩 propositions.
(: contextToPLN (-> (List $a)                   ; Theory
                    (List Variable)             ; Variables so far
                    (List $a)                   ; Context
                    (Pair (List Variable) PLN.Statement))) ; Variables
                                                           ; and PLN
                                                           ; statement
(= (contextToPLN $thry $vars Nil)
   (MkPair $vars ⊤))
(= (contextToPLN $thry $vars (Cons $head $tail))
   (let* (;; Turn the head into an atomic 𝛩 proposition
          ((MkPair $nvars $headpln) (queryToPLN $thry $vars $head))
          ;; Turn the tail into a conjunction of 𝛩 propositions
          ((MkPair $nnvars $tailpln) (contextToPLN $thry $nvars $tail)))
     (MkPair $nnvars (∧ $headpln $tailpln))))

;; Like contextToPLN but only takes a single query in argument
;; alongside a list of variables so far encountered.  It returns a
;; pair of list of variables encountered so far and a PLN statement
;; corresponding to a 𝛩 atomic proposition.
(: queryToPLN (-> (List $a)                   ; Theory
                  (List Variable)             ; Variables encountered so far
                  $a                          ; Query
                  (Pair (List Variable) PLN.Statement))) ; Variables
                                                         ; and PLN
                                                         ; statement
(= (queryToPLN $thry $vars (: $prf $thrm))
   (trace! (👁 queryToPLN $thry $vars (: $prf $thrm))
   (let* (;; Convert theory into PLN term
          ($thrypln (theoryToPLN $thry))
          ;; Convert proof into PLN term, and accumulate new variables
          ((MkPair $nvars $prfpln) (proofToPLN $vars $prf))
          ;; Convert type into PLN term, and accumulate new variables
          ((MkPair $nnvars $thrmpln) (typeToPLN $nvars $thrm)))
     (MkPair $nnvars (𝛩 $thrypln $prfpln $thrmpln)))))

;; Like queryToPLN but takes a proof (or part thereof) in argument
;; alongside a list of variables so far encountered.  It outputs a
;; pair of variables encountered so far and a PLN term.
(: proofToPLN (-> (List Variable)       ; Variables encountered so far
                  $a                    ; Proof
                  (Pair (List Variable PLN.Term)))) ; Variables and PLN
                                                    ; term
(= (proofToPLN $vars $prf)
   (case (get-metatype $prf)
     (;; If the proof is a variable, return the corresponding DeBruijn
      ;; index and update the list variables if necessary.
      (Variable (variableToPLN $vars $prf))
      ;; If the proof is a symbol, return its corresponding PLN object
      (Symbol (MkPair $vars (symbolToPLN $prf)))
      ;; If the proof is an expression, recurse
      (Expression (if-decons-expr $prf $hdprf $tlprf
                                  ;; Non-empty expression
                                  (let* (;; Call proofToPLN on head
                                         ((MkPair $nvars $hdpln)
                                          (proofToPLN $vars $hdprf))
                                         ;; Call proofToPLN on tail
                                         ((MkPair $nnvars $tlpln)
                                          (proofToPLN $nvars $tlprf))
                                         ;; Cons result
                                         ($prfpln (cons-atom $hdpln $tlpln)))
                                    (MkPair $nnvars $prfpln))
                                  ;; Empty expression
                                  (MkPair $vars ()))))))

;; Like proofToPLN but takes a type (or part thereof) in argument
;; alongside a list of variables so far encountered.
(: typeToPLN (-> (List Variable)       ; Variables encountered so far
                  $a                   ; Type
                  (Pair (List Variable) PLN.Term)))  ; Variables and
                                                     ; PLN term
(= (typeToPLN $vars $type)
   (trace! (👁 typeToPLN $vars $type)
   (case (get-metatype $type)
     (;; If the type is a variable, check if it is in $vars, if it is
      ;; then return its corresponding De Bruijn index, otherwise,
      ;; append it first, then return its De Bruijn index.
      (Variable (variableToPLN $vars $type))
      ;; If the type is a symbol, return its corresponding PLN object
      (Symbol (MkPair $vars (symbolToPLN $type)))
      ;; If the type is an expression, recurse
      (Expression (if-decons-expr $type $hdty $tlty
                                  ;; Non-empty expression
                                  (let* (;; Call typeToPLN on head
                                         ((MkPair $nvars $hdpln)
                                          (typeToPLN $vars $hdty))
                                         ;; Call typeToPLN on tail
                                         ((MkPair $nnvars $tlpln)
                                          (typeToPLN $nvars $tlty))
                                         ;; Cons result
                                         ($typln (cons-atom $hdpln $tlpln)))
                                    (MkPair $nnvars $typln))
                                  ;; Empty expression
                                  (MkPair $vars ())))))))

;; Turn a variable into its corresponding DeBruijn index and update
;; the list of encountered variables if necessary.
(: variableToPLN (-> (List Variable)    ; Variables encountered so far
                     Variable           ; Variable
                     (Pair (List Variable) PLN.Term)))
(= (variableToPLN $vars $var)
   (trace! (👁 variableToPLN $vars $var)
   (case (List.elemIndex $var $vars)
     (((Just $idx) (MkPair $vars (toDeBruijn $idx)))
      (Nothing (MkPair (List.appendElem $vars $var)
                       (toDeBruijn (List.length $vars))))))))

;; Turn a symbol, proof or type into its corresponding PLN term.  It
;; could probably be simplified by automatically adding underscored
;; around any symbol, but I feel it's better for now to exhaustively
;; enumerate all supported symbols for the sake of clarity.
;;
;; Note that the output type is anything because it may return not
;; only PLN terms but also PLN functions, going from terms to terms,
;; such as _→_.
(: symbolToPLN (-> Symbol $a))
;; Place holder for propositional calculus
(= (symbolToPLN PC) _PC_)
;; Typing relationship
(= (symbolToPLN :) _:_)
;; Axioms
(= (symbolToPLN ax-1) _ax-1_)
(= (symbolToPLN ax-2) _ax-2_)
(= (symbolToPLN ax-3) _ax-3_)
;; Inference rules
(= (symbolToPLN ax-mp) _ax-mp_)
;; Hypothesis
(= (symbolToPLN mp2.1) _mp2.1_)
(= (symbolToPLN mp2.2) _mp2.2_)
(= (symbolToPLN mp2.3) _mp2.3_)
(= (symbolToPLN mp2b.1) _mp2b.1_)
(= (symbolToPLN mp2b.2) _mp2b.2_)
(= (symbolToPLN mp2b.3) _mp2b.3_)
(= (symbolToPLN a1i.1) _a1i.1_)
;; Connectors
(= (symbolToPLN →) _→_)
(= (symbolToPLN ¬) _¬_)
;; Formula
(= (symbolToPLN 𝜑) _𝜑_)
(= (symbolToPLN 𝜓) _𝜓_)
(= (symbolToPLN 𝜒) _𝜒_)

;; Test typingToPLN
!(assertEqual
  (typingToPLN (: a1i.1 𝜑))
  (_:_ _a1i.1_ _𝜑_))
!(assertEqual
  (typingToPLN PC)
  _PC_)

;; Test theoryToPLN
!(assertEqual
  (theoryToPLN Nil)
  Nil)
!(assertEqual
  (theoryToPLN (Cons PC Nil))
  (Cons _PC_ Nil))
!(assertEqual                           ; NEXT
  (theoryToPLN (Cons (: a1i.1 𝜑) Nil))
  (Cons (_:_ _a1i.1_ _𝜑_) Nil))
!(assertEqual
  (theoryToPLN (Cons (: a1i.1 𝜑) (Cons PC Nil)))
  (Cons (_:_ _a1i.1_ _𝜑_) (Cons _PC_ Nil)))

;; Test variableToPLN
!(assertEqual
  (variableToPLN Nil $prf)
  (MkPair (Cons $prf Nil) z))
!(assertEqual
  (variableToPLN (Cons $prf Nil) $prf)
  (MkPair (Cons $prf Nil) z))

;; Test proofToPLN
!(assertEqual
  (proofToPLN Nil $prf)
  (MkPair (Cons $prf Nil) z))

;; Test typeToPLN
!(assertEqual
  (typeToPLN Nil 𝜑)
  (MkPair Nil _𝜑_))
!(assertEqual
  (typeToPLN Nil (→ 𝜓 𝜑))
  (MkPair Nil (_→_ _𝜓_ _𝜑_)))

;; Test queryToPLN
!(assertEqual
  (queryToPLN Nil Nil (: $prf 𝜑))
  (MkPair (Cons $prf Nil) (𝛩 Nil z _𝜑_)))
!(assertEqual
  (queryToPLN Nil Nil (: $prf (→ 𝜓 𝜑)))
  (MkPair (Cons $prf Nil) (𝛩 Nil z (_→_ _𝜓_ _𝜑_))))

;; Test variablesToPLN
!(assertEqual
  (variablesToPLN Z (𝛩 Nil z _𝜑_))
  (𝛩 Nil z _𝜑_))
!(assertEqual
  (variablesToPLN (S Z) (𝛩 Nil z _𝜑_))
  (∃ z (𝛩 Nil z _𝜑_)))

;; Test toPLN
!(assertEqual
  (toPLN Nil Nil (S Z) (: $prf 𝜑))
  (∃ z (𝛩 Nil z _𝜑_)))
!(assertEqual
  (toPLN Nil Nil (S Z) (: $prf (→ 𝜓 𝜑)))
  (∃ z (𝛩 Nil z (_→_ _𝜓_ _𝜑_))))
!(assertEqual
  (toPLN (Cons PC Nil) Nil (S Z) (: $prf (→ 𝜓 𝜑)))
  (∃ z (𝛩 (Cons _PC_ Nil) z (_→_ _𝜓_ _𝜑_))))
!(assertEqual
  (toPLN (Cons (: a1i.1 𝜑) (Cons PC Nil)) Nil (S Z) (: $prf (→ 𝜓 𝜑)))
  (∃ z (𝛩 (Cons (_:_ _a1i.1_ _𝜑_) (Cons _PC_ Nil)) z (_→_ _𝜓_ _𝜑_))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;; ;;
;; ;; Backward chainer ;; ;;
;; ;;;;;;;;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; For now we write a backward chainer that is specialized for the
;; propositional calculus of MetaMath.  The inference control turns
;; the query and other surrounding premises into a PLN statement that,
;; once evaluated, provides an estimate as to whether the recursive
;; backward chainer call is likely to be fruitful.  Since this
;; estimate is a Truth Value with an underlying second order
;; distribution, Thompson sampling can be used to balance exploration
;; and exploitation.  Specifically, a first order probability is
;; sampled for each branch, and the branch with the maximum
;; probability is selected.
;;
;; NEXT: detail exactly inputs and output.
(: bc (-> Control   ; Estimator
          (List $a) ; Environment
          (List $a) ; Surrounding premises
          Nat       ; Maximum depth
          $a        ; Query
          $a))      ; Result

;;;;;;;;;;;;;;;;
;; Base cases ;;
;;;;;;;;;;;;;;;;

;; Match the environment
(: bc-env (-> Control                   ; Estimator
              (List $a)                 ; Environment
              (List $a)                 ; Surrounding premises
              Nat                       ; Maximum depth
              $a                        ; Query
              $a))                      ; Result
(= (bc-env $ctl $env $ctx $depth (: $prf $thrm))
   (trace! (👁 bc-env $ctl $ctx $depth (: $prf $thrm))
   (match' $env (: $prf $thrm) (: $prf $thrm))))

;; Axiom Simp. Axiom A1 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-1.html
(: bc-ax-1 (-> Control                   ; Estimator
               (List $a)                 ; Environment
               (List $a)                 ; Surrounding premises
               Nat                       ; Maximum depth
               $a                        ; Query
               $a))                      ; Result
(= (bc-ax-1 $ctl $env $ctx $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (trace! (👁 bc-ax-1 $ctl $ctx $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑)))))

;; Axiom Frege. Axiom A2 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-2.html
(: bc-ax-2 (-> Control                   ; Estimator
               (List $a)                 ; Environment
               (List $a)                 ; Surrounding premises
               Nat                       ; Maximum depth
               $a                        ; Query
               $a))                      ; Result
(= (bc-ax-2 $ctl $env $ctx $depth
            (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (trace! (👁 bc-ax-2 $ctl $ctx $depth
              (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))))))

;; Axiom Transp. Axiom A3 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-3.html
(: bc-ax-3 (-> Control                   ; Estimator
               (List $a)                 ; Environment
               (List $a)                 ; Surrounding premises
               Nat                       ; Maximum depth
               $a                        ; Query
               $a))                      ; Result
(= (bc-ax-3 $ctl $env $depth $ctx
            (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (trace! (👁 bc-ax-3 $ctx $depth
              (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)))))

;;;;;;;;;;;;;;;;;;;;
;; Recursive step ;;
;;;;;;;;;;;;;;;;;;;;

;; Rule 1 of [Hamilton] p. 73.
;; https://us.metamath.org/mpeuni/ax-mp.html
(: bc-ax-mp (-> Control                   ; Estimator
                (List $a)                 ; Environment
                (List $a)                 ; Surrounding premises
                Nat                       ; Maximum depth
                $a                        ; Query
                $a))                      ; Result
(= (bc-ax-mp $ctl $env $ctx (S $k)
             (: (ax-mp $prfarg1 $prfarg2) $𝜓))
   (trace! (👁 bc-ax-mp $ctl $ctx (S $k)
              (: (ax-mp $prfarg1 $prfarg2) $𝜓))
   (let* (;; Recurse on premise 1
          ((: $prfarg1 $𝜑)
           (bc $ctl $env
               ;; Add premise 2 in context
               (Cons (: $prfarg2 (→ $𝜑 $𝜓)) $ctx)
               $k (: $prfarg1 $𝜑)))
          ;; Recurse on premise 2
          ((: $prfarg2 (→ $𝜑 $𝜓))
           (bc $ctl $env
               ;; Add premise 1 in context
               (Cons (: $prfarg1 $𝜑) $ctx)
               $k (: $prfarg2 (→ $𝜑 $𝜓)))))
     (: (ax-mp $prfarg1 $prfarg2) $𝜓))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Backward Chainer Estimate ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define backward chainer estimate.  It mirrors the backward chainer
;; code, but outputs an EDCall, meaning a branch and its estimate of
;; success, instead of directly taking the branch.
(: bce (-> Control   ; Estimator
           (List $a) ; Environment
           (List $a) ; Surrounding premises
           Nat       ; Depth
           $a        ; Query
           (EDCall Control (List $a) (List $a) Nat $a $a))) ; EDCall

;; Estimate of environment.  NEXT: the estimate should probably be
;; calculated for each matching result.
(= (bce (MkControl $est) $env $ctx $depth (: $prf $thrm))
   (trace! (👁 bce-env (MkControl $est) $env $ctx $depth (: $prf $thrm))
   (MkEDCall ($est $env $ctx $depth (: $prf $thrm))
             (MkDCall bc-env (MkControl $est) $env $ctx $depth
                      (: $prf $thrm)))))

;; Estimate of Axiom A1
(= (bce (MkControl $est) $env $ctx $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (trace! (👁 bce-ax-1 (MkControl $est) $env $ctx $depth
              (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (MkEDCall ($est $env $ctx $depth (: $prf $thrm))
             (MkDCall bc-ax-1 (MkControl $est) $env $ctx $depth
                      (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑)))))))

;; Estimate of Axiom A2
(= (bce (MkControl $est) $env $ctx $depth
        (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (trace! (👁 bce-ax-2 (MkControl $est) $env $ctx $depth
              (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))))
   (MkEDCall ($est $env $ctx $depth (: $prf $thrm))
             (MkDCall bc-ax-2 (MkControl $est) $env $ctx $depth
                      (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))))))))

;; Estimate of Axiom A3
(= (bce (MkControl $est) $env $ctx $depth
        (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (trace! (👁 bce-ax-3 (MkControl $est) $env $ctx $depth
              (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)))
   (MkEDCall ($est $env $ctx $depth (: $prf $thrm))
             (MkDCall bc-ax-3 (MkControl $est) $env $ctx $depth
                      (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)))))))

;; Estimate of Rule 1 (modus ponens)
(= (bce (MkControl $est) $env $ctx (S $k)
        (: (ax-mp $prfarg1 $prfarg2) $𝜓))
   (trace! (👁 bce-ax-mp (MkControl $est) $env $ctx (S $k)
              (: (ax-mp $prfarg1 $prfarg2) $𝜓))
   (MkEDCall ($est $env $ctx $depth (: $prf $thrm))
             (MkDCall bc-ax-mp (MkControl $est) $env $ctx (S $k)
                      (: (ax-mp $prfarg1 $prfarg2) $𝜓)))))

;;;;;;;;;;;;;;
;; Monolith ;;
;;;;;;;;;;;;;;

;; See above for its type signature and comment
(= (bc (MkControl $est) $env $ctx $depth (: $prf $thrm))
   (trace! (👁 bc $ctx $depth (: $prf $thrm))
   (let* (($edcalls (collapse (bce (MkControl $est) $env $ctx $depth (: $prf $thrm))))
          ($edcall_seq (List.fromExpression $edcalls))
          ($best_edcall (List.maxElementWith EDCall.lt5 $edcall_seq)))
     (EDCall.run5 $best_edcall))))

;;;;;;;;;;;;;;;;;
;; PLN Chainer ;;
;;;;;;;;;;;;;;;;;

;; For now PLN chaining is greedy, without inference control.  That is
;; because we first want to make sure PLN-based inference control
;; works at all.  In other words, to begin with we focus on making the
;; inference control accurate, not necessarily efficient.

(: pln-bc (-> $a             ; PLN knowledge base
              Nat            ; Maximum depth
              PLN.Judgment   ; PLN judgement with holes.  Normally,
                             ; only one hole on the truth value.
              PLN.Judgment)) ; PLN judgement without hole

;; Udf axiom takes any PLN statement and associate the judgement with
;; the undefined truth value, with strength 1 and confidence 0,
;; corresponding to complete unknown.
(= (pln-bc &pln-kb $depth (: Udf $prf (≞ $pln-stm (PLN.MkSTV 1 0))))
   (: Udf (≞ $pln-stm (PLN.MkSTV 1 0))))

;;;;;;;;;;;;;;;;
;; ;;;;;;;;;; ;;
;; ;; Test ;; ;;
;; ;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Random Control ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(: rnd-estimate (-> (List $a) (List $a) Nat $a Number))
(= (rnd-estimate $env $ctx $depth $query) (random-float &rng 0 1))
!(bind! &rnd-ctl (MkControl rnd-estimate))

;; In order to reproduce the tests, the random seed needs to be set
;; just right, and it becomes harder and harder to find a seed that
;; works as the inference path becomes longer and longer.  For that we
;; systematically search for a random seed with the following code
;; (this is an example to discover the seed of test mp2).
;;
;; (: (bc.test.mp2.p (-> Number Bool)))
;; (= (bc.test.mp2.p $n)
;;    (trace! (® bc.test.mp2.p $n)
;;    (let () (set-random-seed &rng $n)
;;         (case (bc &rnd-ctl
;;                   (Cons (: mp2.1 𝜑)
;;                         (Cons (: mp2.2 𝜓)
;;                               (Cons (: mp2.3 (→ 𝜑 (→ 𝜓 𝜒)))
;;                                     Nil)))
;;                   (fromNumber 2)
;;                   (: $prf 𝜒))
;;                   ;; (: (ax-mp mp2.2 (ax-mp mp2.1 mp2.3)) 𝜒))
;;           ((Empty False)
;;            ($else True))))))
;; !(until bc.test.mp2.p succ 0)
;;
;; At the end of the loop, it outputs the seed.

;; Test ax-3
!(set-random-seed &rng 1)
!(assertEqual
  (bc &rnd-ctl Nil Nil (fromNumber 0) (: $prf (→ (→ (¬ 𝜑) (¬ 𝜓)) (→ 𝜓 𝜑))))
  (: ax-3 (→ (→ (¬ 𝜑) (¬ 𝜓)) (→ 𝜓 𝜑))))

;; Test subgoal of https://us.metamath.org/mpeuni/mp2.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
!(set-random-seed &rng 0)
!(assertEqual
  (bc &rnd-ctl
      (Cons (: mp2.1 𝜑)
            (Cons (: mp2.2 𝜓)
                  (Cons (: mp2.3 (→ 𝜑 (→ 𝜓 𝜒)))
                        Nil)))
      Nil
      (fromNumber 1)
      (: $prf (→ 𝜓 𝜒)))
  (: (ax-mp mp2.1 mp2.3) (→ 𝜓 𝜒)))

;; Test https://us.metamath.org/mpeuni/mp2.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
!(set-random-seed &rng 84)
!(assertEqual
  (bc &rnd-ctl
      (Cons (: mp2.1 𝜑)
            (Cons (: mp2.2 𝜓)
                  (Cons (: mp2.3 (→ 𝜑 (→ 𝜓 𝜒)))
                        Nil)))
      Nil
      (fromNumber 2)
      (: $prf 𝜒))
  (: (ax-mp mp2.2 (ax-mp mp2.1 mp2.3)) 𝜒))

;; Test https://us.metamath.org/mpeuni/mp2b.html
!(set-random-seed &rng 363)
!(assertEqual
  (bc &rnd-ctl
      (Cons (: mp2b.1 𝜑)
            (Cons (: mp2b.2 (→ 𝜑 𝜓))
                  (Cons (: mp2b.3 (→ 𝜓 𝜒))
                        Nil)))
      Nil
      (fromNumber 2)
      (: $prf 𝜒))
  (: (ax-mp (ax-mp mp2b.1 mp2b.2) mp2b.3) 𝜒))

;; Test https://us.metamath.org/mpeuni/a1i.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
!(set-random-seed &rng 4)
!(assertEqual
  (bc &rnd-ctl
      (Cons (: a1i.1 𝜑) Nil)
      Nil
      (fromNumber 1)
      (: $prf (→ 𝜓 𝜑)))
  (: (ax-mp a1i.1 ax-1) (→ 𝜓 𝜑)))
