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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;; ;;
;; ;; Hyper Parameters ;; ;;
;; ;;;;;;;;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Boolean parameter to determine whether the search for random seeds
;; is enabled.  Warning: if is enabled, it may run for a long time.
!(bind! &seed-search True)

;; Not supported yet
;; ;; Set this parameter to True if you want to print debug traces on
;; ;; stderr
;; !(bind! &debug-trace True)

;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;; ;;
;; ;; Utils ;; ;;
;; ;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add Atom without Duplicate ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Reduce and add an atom only if it is not already in the atomspace.
;; Warning: if the atom to be added is not in the space but matches
;; any atom in the space, it will not be added either.  Return the
;; added (or not added) atom.
(: add-reduct-nodup (-> $a              ; Space
                        $b              ; Atom
                        (->)))
(= (add-reduct-nodup $space $atom)
   (case (match $space $atom $atom)
     (($atom ())
      (Empty (add-reduct $space $atom)))))

;; Test add-atom-nodup
!(assertEqualToResult
  (let* (($space (new-space))
         (() (add-reduct-nodup $space A))
         (() (add-reduct-nodup $space A)))
    (get-atoms $space))
  (A))
!(assertEqualToResult
  (let* (($space (new-space))
         (() (add-reduct-nodup $space A))
         (() (add-reduct-nodup $space B)))
    (get-atoms $space))
  (A B))

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

;;;;;;;;;;;;
;; Number ;;
;;;;;;;;;;;;

;; Return the minimum between two values
(: min (-> Number Number Number))
(= (min $x $y) (if (< $x $y) $x $y))

;; Return the minimum between two values
(: max (-> Number Number Number))
(= (max $x $y) (if (< $x $y) $y $x))

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

;; Test if the input is equal to a given value
(: curried-equal-to (-> $a (-> $a Bool)))
(= ((curried-equal-to $n) $x) (== $n $x))

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
!(assertEqual
  (until (curried-equal-to 10) succ 0)
  10)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set random seed and run ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set random seed and run nullary function
(: set-rnd-seed-run0 (-> Number (-> $a) $a))
(= (set-rnd-seed-run0 $n $f)
   (let () (set-random-seed &rng $n) ($f)))

;; Set random seed and run nullary function.  Outputs True iff it
;; succeeds, that is it is not empty.
(: (set-rnd-seed-run0-not-empty (-> Number (-> $a) Bool)))
(= (set-rnd-seed-run0-not-empty $n $f)
   (case (set-rnd-seed-run0 $n $f)
     ((Empty False)
      ($else True))))

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
(: List.appendElem (-> $a (List $a) (List $a)))
(= (List.appendElem $x $xs) (List.append $xs (Cons $x Nil)))

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

;;;;;;;;;;;;
;; String ;;
;;;;;;;;;;;;

;; Fold a tuple from right to left
(: foldr (-> (-> $a $b $b) $b $c $d))
(= (foldr $f $i $xs)
   (if (== $xs ())
       $i
       (let* (($h (car-atom $xs))
              ($t (cdr-atom $xs))
              ($ft (foldr $f $i $t)))
         ($f $h $ft))))

;; Concatenate two terms
(: append (-> $a $a $a))
(= (append $lhs $rhs) (foldr cons-atom $rhs $lhs))

;; Concatenate two strings (implemented in my own branch)
(: String.append (-> String String String))
;; (= (String.append $x $y) (call-fn! string_concat $x $y)) ; Only MeTTaLog
(= (String.append $x $y) ((py-dot $x __add__ (-> String String String)) $y))
;; (= (String.append $x $y) (charsToString (append (stringToChars $x) (stringToChars $y))))

;; Test String.append
!(assertEqual (String.append "abc" "def") "abcdef")
!(assertEqual (String.append "\"" "\"") "\"\"")

;; Overload String.append to support more than 2 arguments
(: String.append3 (-> String String String String))
(= (String.append3 $x $y $z) (String.append $x (String.append $y $z)))
(: String.append4 (-> String String String String String))
(= (String.append4 $x $y $z $w) (String.append $x (String.append3 $y $z $w)))
(: String.append5 (-> String String String String String String))
(= (String.append5 $x $y $z $w $s) (String.append $x (String.append4 $y $z $w $s)))

;; Join a list of string by a separator
(: String.join (-> String (List String) String))
(= (String.join $separator Nil) "")
(= (String.join $separator (Cons $head $tail))
   (case $tail
     ((Nil $head)
      ($else (String.append3 $head $separator (String.join $separator $tail))))))

;; Test String.join
!(assertEqual (String.join ", " (Cons "x=42" (Cons "y=24" Nil))) "x=42, y=24")

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
(: Control Type)
(MkControl (-> $a                                     ; PLN Space
               (-> (List $b) (List $b) Nat $b Number) ; Estimator
               Control))

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
;; ([∧] [P] [Q])
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
(: [z] PLN.Term.DeBruijn)
(: [s] (-> PLN.Term.DeBruijn PLN.Term.DeBruijn))

;; Make sure that [z] and [s] can be typed as PLN.Term as well
(: [z] PLN.Term)
(: [s] (-> PLN.Term.DeBruijn PLN.Term))

;; Define axiom and inference rule names as PLN terms
(: [ax-1] PLN.Term)
(: [ax-2] PLN.Term)
(: [ax-3] PLN.Term)
(: [ax-mp] (-> PLN.Term PLN.Term PLN.Term))
(: [mp2.1] PLN.Term)
(: [mp2.2] PLN.Term)
(: [mp2.3] PLN.Term)
(: [mp2b.1] PLN.Term)
(: [mp2b.2] PLN.Term)
(: [mp2b.3] PLN.Term)
(: [a1i.1] PLN.Term)
(: [PC] (List PLN.Term))
(: [𝜑] PLN.Term)
(: [𝜓] PLN.Term)
(: [𝜒] PLN.Term)

;; Define PLN Term logical connectors at the object level.  NEXT:
;; support PLN.Term.DeBruijn.
(: [→] (-> PLN.Term PLN.Term PLN.Term))
(: [∧] (-> PLN.Term PLN.Term PLN.Term))
(: [∨] (-> PLN.Term PLN.Term PLN.Term))
(: [¬] (-> PLN.Term PLN.Term))

;; Define typing relationship at the object level.
(: [:] (-> PLN.Term PLN.Term PLN.Term))

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

;; Access truth value from judgement
(: PLN.tv (-> PLN.Judgement PLN.TruthValue))
(= (PLN.tv (≞ $stm $tv)) $tv)

;;;;;;;;;;;;;;;;;;;;;;;
;; Thompson Sampling ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Thompson sample from a simple truth value.  For now only confidence
;; of 0 or 1 are supported.  This assumption allows us to operate
;; Thompson sampling without requiring a Beta distribution.  Indeed if
;; the confidence is 0 then it amounts to a uniform sampling, assuming
;; a flat Bayesian prior that is.  And if the confidence is 1 then we
;; just return the strength.
(: thompson-sample (-> PLN.TruthValue Number))
(= (thompson-sample (PLN.MkSTV $s 0))
   ;; (trace! (👁 thompson-sample (PLN.MkSTV $s 0))
   (random-float &rng 0 1));)
(= (thompson-sample (PLN.MkSTV $s 1))
   ;; (trace! (👁 thompson-sample (PLN.MkSTV $s 1))
    $s);)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reduce PLN statements ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Reduce PLN statement.  For now it only supports neutral element
;; elimination.
(: PLN.reduce (-> PLN.Statement PLN.Statement))
(= (PLN.reduce $stm)
   ;; (trace! (👁 PLN.reduce $stm)
   (case (get-metatype $stm)
     ((Symbol $stm)
      (Grounded $stm)
      (Expression (case $stm
                    (;; Nullary
                     (() ())
                     ;; Unary
                     (($x) ($x))
                     ;; Binary
                     (($x $y) ($x (PLN.reduce $y)))
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
                     (($x $y $z) ($x (PLN.reduce $y) (PLN.reduce $z)))
                     ;; Quaternary
                     ((𝛩 $x $y $z) $stm)
                     ;; Other quaternary
                     (($x $y $z $w) ($x (PLN.reduce $y)
                                        (PLN.reduce $z)
                                        (PLN.reduce $w)))
                     ;; Quinary
                     (($x $y $z $w $v) ($x
                                        (PLN.reduce $y)
                                        (PLN.reduce $z)
                                        (PLN.reduce $w)
                                        (PLN.reduce $v)))
                     ;; Otherwise
                     ($else (Error $stm "Not supported in PLN.reduce")))))
      ($else (Error (get-metatype $stm) "Not supported in PLN.reduce")))));)

;; Test PLN.reduce
!(assertEqual
  (PLN.reduce ⊤)
  ⊤)
!(assertEqual
  (PLN.reduce (𝛩 [PC] z [𝜑]))
  (𝛩 [PC] z [𝜑]))
!(assertEqual
  (PLN.reduce (∧ (𝛩 [PC] z [𝜑]) ⊤))
  (𝛩 [PC] z [𝜑]))
!(assertEqual
  (PLN.reduce (∧ (𝛩 [PC] (s (s z)) (s z))
                 (∧ (𝛩 [PC] z ([→] (s z) ([→] [𝜓] [𝜒])))
                    ⊤)))
  (∧ (𝛩 [PC] (s (s z)) (s z)) (𝛩 [PC] z ([→] (s z) ([→] [𝜓] [𝜒])))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Convert backward chainer call to PLN ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Convert the arguments of a backward chainer call to a PLN statement
;; such that the semantics of its associated truth value corresponds
;; to how likely the holes in the arguments of the call (the
;; environment, the query and its surrounding premises) can be filled
;; within the provided depth.
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
;; (∃ z (𝛩 (Cons ([:] [a1i.1] [𝜑]) [PC]) z ([→] [𝜓] [𝜑])) ∧ (depth_lte z 1))
;;
;; where
;;
;; - z is the first De Bruijn index,
;;
;; - all symbols of the logic have been dropped to the object level
;;   (or mesa level), by being surrounded with [].  So for instance, :
;;   becomes [:], a1i.1 becomes [a1i.1], → becomes [→], etc.
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
             PLN.Statement))            ; PLN statement
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
   (∃ (toDeBruijn $k) (variablesToPLN $k $plnstm)))

;; Convert a theory in PLN format
(: theoryToPLN (-> (List $a) (List PLN.Term)))
(= (theoryToPLN $thry) (List.map typingToPLN $thry))

;; Add extra case to List.map to handle PC
(: PC (List $a))
(= (List.map $f PC) [PC])

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
   (let* (;; Convert theory into PLN term
          ($thrypln (theoryToPLN $thry))
          ;; Convert proof into PLN term, and accumulate new variables
          ((MkPair $nvars $prfpln) (proofToPLN $vars $prf))
          ;; Convert type into PLN term, and accumulate new variables
          ((MkPair $nnvars $thrmpln) (typeToPLN $nvars $thrm)))
     (MkPair $nnvars (𝛩 $thrypln $prfpln $thrmpln))))

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
                                  (MkPair $vars ()))))))

;; Turn a variable into its corresponding DeBruijn index and update
;; the list of encountered variables if necessary.
(: variableToPLN (-> (List Variable)    ; Variables encountered so far
                     Variable           ; Variable
                     (Pair (List Variable) PLN.Term)))
(= (variableToPLN $vars $var)
   (case (List.elemIndex $var $vars)
     (((Just $idx) (MkPair $vars (toDeBruijn $idx)))
      (Nothing (MkPair (List.appendElem $var $vars)
                       (toDeBruijn (List.length $vars)))))))

;; Turn a symbol, proof or type into its corresponding PLN term.  It
;; could probably be simplified by automatically adding underscored
;; around any symbol, but I feel it's better for now to exhaustively
;; enumerate all supported symbols for the sake of clarity.
;;
;; Note that the output type is anything because it may return not
;; only PLN terms but also PLN functions, going from terms to terms,
;; such as [→].
(: symbolToPLN (-> Symbol $a))
(= (symbolToPLN $x)
   (parse (String.append3 "[" (repr $x) "]")))

;; Test typingToPLN
!(assertEqual
  (typingToPLN (: a1i.1 𝜑))
  ([:] [a1i.1] [𝜑]))
!(assertEqual
  (typingToPLN PC)
  [PC])

;; Test theoryToPLN
!(assertEqual
  (theoryToPLN Nil)
  Nil)
!(assertEqual
  (theoryToPLN PC)
  [PC])
!(assertEqual
  (theoryToPLN (Cons (: a1i.1 𝜑) Nil))
  (Cons ([:] [a1i.1] [𝜑]) Nil))
!(assertEqual
  (theoryToPLN (Cons (: a1i.1 𝜑) PC))
  (Cons ([:] [a1i.1] [𝜑]) [PC]))

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
  (MkPair Nil [𝜑]))
!(assertEqual
  (typeToPLN Nil (→ 𝜓 𝜑))
  (MkPair Nil ([→] [𝜓] [𝜑])))

;; Test queryToPLN
!(assertEqual
  (queryToPLN Nil Nil (: $prf 𝜑))
  (MkPair (Cons $prf Nil) (𝛩 Nil z [𝜑])))
!(assertEqual
  (queryToPLN Nil Nil (: $prf (→ 𝜓 𝜑)))
  (MkPair (Cons $prf Nil) (𝛩 Nil z ([→] [𝜓] [𝜑]))))
!(assertEqual
  (queryToPLN PC Nil (: ax-3 (→ (→ (¬ 𝜑) (¬ 𝜓)) (→ 𝜓 𝜑))))
  (MkPair Nil (𝛩 [PC] [ax-3] ([→] ([→] ([¬] [𝜑]) ([¬] [𝜓])) ([→] [𝜓] [𝜑])))))
!(assertEqual
  (queryToPLN (Cons (: mp2.1 𝜑)
                    (Cons (: mp2.2 𝜓)
                          (Cons (: mp2.3 (→ 𝜑 (→ 𝜓 𝜒)))
                                PC)))
              Nil
              (: (ax-mp mp2.1 mp2.3) (→ 𝜓 𝜒)))
  (MkPair Nil (𝛩 (Cons ([:] [mp2.1] [𝜑])
                       (Cons ([:] [mp2.2] [𝜓])
                             (Cons ([:] [mp2.3] ([→] [𝜑] ([→] [𝜓] [𝜒])))
                                   [PC])))
                 ([ax-mp] [mp2.1] [mp2.3])
                 ([→] [𝜓] [𝜒]))))

;; Test variablesToPLN
!(assertEqual
  (variablesToPLN Z (𝛩 Nil z [𝜑]))
  (𝛩 Nil z [𝜑]))
!(assertEqual
  (variablesToPLN (S Z) (𝛩 Nil z [𝜑]))
  (∃ z (𝛩 Nil z [𝜑])))

;; Test toPLN
!(assertEqual
  (toPLN Nil Nil (S Z) (: $prf 𝜑))
  (∃ z (𝛩 Nil z [𝜑])))
!(assertEqual
  (toPLN Nil Nil (S Z) (: $prf (→ 𝜓 𝜑)))
  (∃ z (𝛩 Nil z ([→] [𝜓] [𝜑]))))
!(assertEqual
  (toPLN PC Nil (S Z) (: $prf (→ 𝜓 𝜑)))
  (∃ z (𝛩 [PC] z ([→] [𝜓] [𝜑]))))
!(assertEqual
  (toPLN (Cons (: a1i.1 𝜑) PC) Nil (S Z) (: $prf (→ 𝜓 𝜑)))
  (∃ z (𝛩 (Cons ([:] [a1i.1] [𝜑]) [PC]) z ([→] [𝜓] [𝜑]))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add Theta instance to PLN Space ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Outputs the theory of a corresponding environment (just prepend the
;; environment to PC.
(: toTheory (-> (List $a) (List $a)))
(= (toTheory $env)
   (List.append $env PC))

;; Given a PLN space and a description of the query (supposedly closed
;; by now), convert the query into a 𝛩 instance, add it to the PLN
;; space and return the query unchanged.  For now depth is
;; unsupported.
(: addInstance (-> $a              ; PLN Space
                   (List $b)       ; Theory
                   Nat             ; Depth
                   $b              ; Query
                   $b))            ; Query pass through
(= (addInstance $pln-kb $thry $depth $query)
   (let* (($pln-statement (toPLN $thry Nil $depth $query))
          ($pln-judgment (≞ $pln-statement (PLN.MkSTV 1 1)))
          (() (add-reduct-nodup $pln-kb $pln-judgment)))
     $query))

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
   (match' $env (: $prf $thrm) (: $prf $thrm)))

;; Axiom Simp. Axiom A1 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-1.html
(: bc-ax-1 (-> Control                   ; Estimator
               (List $a)                 ; Environment
               (List $a)                 ; Surrounding premises
               Nat                       ; Maximum depth
               $a                        ; Query
               $a))                      ; Result
(= (bc-ax-1 $ctl $env $ctx $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))

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
   (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))

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
   (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))

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
     (: (ax-mp $prfarg1 $prfarg2) $𝜓)))

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

;; Estimate of environment
(= (bce (MkControl $pln-kb $est) $env $ctx $depth (: $prf $thrm))
   (trace! (👁 bce-env (MkControl $pln-kb $est) $env $ctx $depth (: $prf $thrm))
   (let (: $prf $thrm) (match' $env (: $prf $thrm) (: $prf $thrm))
        (MkEDCall ($est $env $ctx $depth (: $prf $thrm))
                  (MkDCall bc-env (MkControl $pln-kb $est) $env $ctx $depth
                           (: $prf $thrm))))))

;; Estimate of Axiom A1
(= (bce (MkControl $pln-kb $est) $env $ctx $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (trace! (👁 bce-ax-1 (MkControl $pln-kb $est) $env $ctx $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (MkEDCall ($est $env $ctx $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
             (MkDCall bc-ax-1 (MkControl $pln-kb $est) $env $ctx $depth
                      (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑)))))))

;; Estimate of Axiom A2
(= (bce (MkControl $pln-kb $est) $env $ctx $depth
        (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (trace! (👁 bce-ax-2 (MkControl $pln-kb $est) $env $ctx $depth
        (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (MkEDCall ($est $env $ctx $depth (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
             (MkDCall bc-ax-2 (MkControl $pln-kb $est) $env $ctx $depth
                      (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))))))))

;; Estimate of Axiom A3
(= (bce (MkControl $pln-kb $est) $env $ctx $depth
        (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (trace! (👁 bce-ax-3 (MkControl $pln-kb $est) $env $ctx $depth
        (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (MkEDCall ($est $env $ctx $depth (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
             (MkDCall bc-ax-3 (MkControl $pln-kb $est) $env $ctx $depth
                      (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)))))))

;; Estimate of Rule 1 (modus ponens)
(= (bce (MkControl $pln-kb $est) $env $ctx (S $k)
        (: (ax-mp $prfarg1 $prfarg2) $𝜓))
   (trace! (👁 bce-ax-mp (MkControl $pln-kb $est) $env $ctx (S $k)
        (: (ax-mp $prfarg1 $prfarg2) $𝜓))
   (MkEDCall ($est $env $ctx (S $k) (: (ax-mp $prfarg1 $prfarg2) $𝜓))
             (MkDCall bc-ax-mp (MkControl $pln-kb $est) $env $ctx (S $k)
                      (: (ax-mp $prfarg1 $prfarg2) $𝜓)))))

;;;;;;;;;;;;;;
;; Monolith ;;
;;;;;;;;;;;;;;

;; See above for its type signature and comment
(= (bc (MkControl $pln-kb $est) $env $ctx $depth (: $prf $thrm))
   (trace! (👁 bc (MkControl $pln-kb $est) $env $ctx $depth (: $prf $thrm))
   (let* (;; Run superposition of backward chainer estimations
          ($edcalls (collapse (bce (MkControl $pln-kb $est) $env $ctx $depth (: $prf $thrm))))
          ;; Select the best EDCall
          ($edcall_seq (List.fromExpression $edcalls))
          ($best_edcall (List.maxElementWith EDCall.lt5 $edcall_seq))
          ;; Run it
          ($result (EDCall.run5 $best_edcall)))
     ;; Add the result into the PLN space and return the result
     (addInstance $pln-kb (toTheory $env) $depth $result))))

;;;;;;;;;;;;;;;;;
;; PLN Chainer ;;
;;;;;;;;;;;;;;;;;

;; Replace a given De Bruijn index by a given variable in a given PLN
;; statement or term
(: DeBruijnToVariable (-> DeBruijn $a $a))
(= (DeBruijnToVariable $idx $trm) (_DeBruijnToVariable $idx $x $trm))
(: _DeBruijnToVariable (-> DeBruijn Variable $a $a))
(= (_DeBruijnToVariable $idx $var $term)
   (case (get-metatype $term)
     ((Symbol (if-equal $idx $term $var $term))
      (Grounded $term)
      (Variable $term)
      (Expression
       (if-equal $idx $term
                 $var
                 (if (isDeBruijn $term)
                     $term
                     (if-decons-expr $term $head $tail
                                     ;; Non-empty expression
                                     (let* (;; Recursive call on head
                                            ($nhd (_DeBruijnToVariable $idx $var $head))
                                            ;; Recursive call on tail
                                            ($ntl (_DeBruijnToVariable $idx $var $tail)))
                                       ;; Cons result
                                       (cons-atom $nhd $ntl))
                                     ;; Empty expression
                                     ())))))))

;; Return True iff the given term is also DeBruijn index.  NEXT: alternative
(: isDeBruijn (-> $a Bool))
(= (isDeBruijn $term)
   (case (get-metatype $term)
     ((Symbol (if-equal $term z True False))
      (Grounded False)
      (Variable False)
      (Expression
       (if-decons-expr $term $head ($tail)
                       ;; Non-empty expression
                       (and (== $head s) (isDeBruijn $tail))
                       ;; Empty expression
                       False)))))

;; Test isDeBruijn
!(assertEqual
  (isDeBruijn A)
  False)
!(assertEqual
  (isDeBruijn ())
  False)
!(assertEqual
  (isDeBruijn (A B))
  False)
!(assertEqual
  (isDeBruijn z)
  True)
!(assertEqual
  (isDeBruijn (s z))
  True)
!(assertEqual
  (isDeBruijn (s (s z)))
  True)
!(assertEqual
  (isDeBruijn [PC])
  False)

;; Test DeBruijnToVariable
!(assertAlphaEqual
  (DeBruijnToVariable z (𝛩 [PC] z [𝜑]))
  (𝛩 [PC] $x [𝜑]))
!(assertAlphaEqual
  (DeBruijnToVariable z (𝛩 [PC] z (s z)))
  (𝛩 [PC] $x (s z)))
!(assertAlphaEqual
  (DeBruijnToVariable (s z) (𝛩 [PC] z (s z)))
  (𝛩 [PC] z $x))
!(assertAlphaEqual
  (DeBruijnToVariable (s z)
                      (∃ z (𝛩 (Cons ([:] [mp2.1] [𝜑]) [PC])
                              ([ax-mp] z (s z))
                              ([→] [𝜓] [𝜒]))))
  (∃ z (𝛩 (Cons ([:] [mp2.1] [𝜑]) [PC]) ([ax-mp] z $x) ([→] [𝜓] [𝜒]))))

;; For now PLN chaining is greedy, without inference control.  That is
;; because we first want to make sure PLN-based inference control
;; works at all.  In other words, to begin with we focus on making the
;; inference control accurate, not necessarily efficient.
(: pln-bc (-> $a             ; PLN knowledge base
              Nat            ; Maximum depth
              PLN.Judgment   ; PLN judgement with holes.  Normally,
                             ; only one hole on the truth value.
              PLN.Judgment)) ; PLN judgement without hole

;; Base cases

;; Match the kb
(= (pln-bc $kb $depth (: $prf $thrm))
   ;; (trace! (👁 pln-bc-env $kb $depth (: $prf $thrm))
   (match $kb (: $prf $thrm) (: $prf $thrm)));)

;; Undefined (Udf).  The Udf axiom takes any PLN statement and creates
;; a judgement with the undefined truth value, with strength 1 and
;; confidence 0, corresponding to complete unknown.
(= (pln-bc $kb $depth (: Udf (≞ $stm (PLN.MkSTV 1 0))))
   ;; (trace! (👁 pln-bc-udf $kb $depth (: Udf (≞ $stm (PLN.MkSTV 1 0))))
   (: Udf (≞ $stm (PLN.MkSTV 1 0))));)

;; Recursive steps

;; Existential Quantifier Introduction - from instance - (EQI).  The
;; truth value on the existantial quantifier is equal to that on the
;; instance.  For this to work well, merging truth values obtained
;; from different instances (or different paths) will need to be
;; applied.  The challenges should be no different than other truth
;; value merging, meaning one needs to estimate how much independent
;; they are (maybe this can be outsourced to PLN itself).
(= (pln-bc $kb (S $k) (: (EQI $prfarg) (≞ (∃ $idx $stm) (PLN.MkSTV $s $c))))
   ;; (trace! (👁 pln-bc-eqi $kb (S $k)
   ;;            (: (EQI $prfarg) (≞ (∃ $idx $stm) (PLN.MkSTV $s $c))))
   (let* (;; Replace $idx by a free variable in $stm
          ($stm-fv (DeBruijnToVariable $idx $stm))
          ;; Recurse on the dequantified statement
          ((: $prfarg (≞ $stm-fv (PLN.MkSTV $s $c)))
           (pln-bc $kb $k (: $prfarg (≞ $stm-fv (PLN.MkSTV $s $c))))))
     ;; TODO: take care of unifying $stm and $stm-fv
     (: (EQI $prfarg) (≞ (∃ $idx $stm) (PLN.MkSTV $s $c)))));)

;; Conjunction Introduction (CI).  The formula is somewhat
;; conservative but not maximally so, taking the product of the
;; strengths and the min of the confidences.  Note that it is not
;; consistent with probability theory, because two strengths can only
;; be multipled if they are assumed to be independent, but in this
;; case, their confidences should not be the min, rather their counts
;; should be added.  We cannot opt for the most conservative approach
;; because it should assume that both conjuncts are disjoint, which
;; would output a strength of 0 regardless of the strengths of the
;; premises.  Anyway, for now we use that formula until we come up
;; with something better.
(= (pln-bc $kb (S $k) (: (CI $prfarg1 $prfarg2)
                         (≞ (∧ $stm1 $stm2) (PLN.MkSTV $s $c))))
   ;; (trace! (👁 pln-bc-ci $kb (S $k) (: (CI $prfarg1 $prfarg2)
   ;;                                 (≞ (∧ $stm1 $stm2) (PLN.MkSTV $s $c))))
   (let* (;; Recursive on stm1
          ((: $prfarg1 (≞ $stm1 (PLN.MkSTV $s1 $c1)))
           (pln-bc $kb $k (: $prfarg1 (≞ $stm1 (PLN.MkSTV $s1 $c1)))))
          ;; Recursive on stm2
          ((: $prfarg2 (≞ $stm2 (PLN.MkSTV $s2 $c2)))
           (pln-bc $kb $k (: $prfarg2 (≞ $stm2 (PLN.MkSTV $s2 $c2)))))
          ;; Calculate strength and confidence
          ($s (* $s1 $s2))
          ($c (min $c1 $c2)))
     ;; Output conjunction
     (: (CI $prfarg1 $prfarg2) (≞ (∧ $stm1 $stm2) (PLN.MkSTV $s $c)))));)

;; Less than predicate over typing relationships of PLN judgements by
;; confidence.  For instance the following call
;;
;; (lt_by_conf (: PRF1 (≞ STM1 (MkSTV 0.4 0.5)))
;;             (: PRF2 (≞ STM2 (MkSTV 0.6 0.4))))
;;
;; outputs
;;
;; False because the confidence of STM1 according to PRF1, 0.5, is not
;; less than the confidence of STM2 according to PRF2, 0.4.
(: lt_by_conf (-> $a $a Bool))
(= (lt_by_conf (: $prf1 (≞ $stm1 (PLN.MkSTV $s1 $c1)))
               (: $prf2 (≞ $stm2 (PLN.MkSTV $s2 $c2))))
   (< $c1 $c2))

;; Test lt_by_conf (TODO: replace by assert once ready)
!(assertEqual
  (lt_by_conf (: Ax1 (≞ (∃ (s z) (∃ z (𝛩 [PC] ([ax-mp] z (s z)) ([→] [𝜓] [𝜒]))))
                        (PLN.MkSTV 1 0)))
              (: Ax2 (≞ (∃ (s z) (∃ z (𝛩 [PC] ([ax-mp] z (s z)) ([→] [𝜓] [𝜒]))))
                        (PLN.MkSTV 0 0))))
  False)

;; Test pln-bc
!(bind! &pln-bc.test.kb (new-space))

;; Populate pln-bc.test.kb with instances of 𝛩
!(add-atom &pln-bc.test.kb (: ax-1-inst
                              (≞ (𝛩 [PC]
                                    [ax-1]
                                    ([→] [𝜑] ([→] [𝜓] [𝜑])))
                                 (PLN.MkSTV 1 1))))
!(add-atom &pln-bc.test.kb (: ax-2-inst
                              (≞ (𝛩 [PC]
                                    [ax-2]
                                    ([→] ([→] [𝜑] ([→] [𝜓] [𝜒]))
                                         ([→] ([→] [𝜑] [𝜓]) ([→] [𝜑] [𝜒]))))
                                 (PLN.MkSTV 1 1))))
!(add-atom &pln-bc.test.kb (: ax-pm-inst
                              (≞ (𝛩 (Cons ([:] [mp2.1] [𝜑])
                                          (Cons ([:] [mp2.2] [𝜓])
                                                (Cons ([:] [mp2.3] ([→] [𝜑] ([→] [𝜓] [𝜒])))
                                                      [PC])))
                                    ([ax-mp] [mp2.1] [mp2.3])
                                    ([→] [𝜓] [𝜒]))
                                 (PLN.MkSTV 1 1))))

;; Test axioms (instances)
!(assertEqual
  (pln-bc &pln-bc.test.kb
          (fromNumber 0)
          (: $prf (≞ (𝛩 [PC] [ax-1] ([→] [𝜑] ([→] [𝜓] [𝜑])))
                     (PLN.MkSTV $s 1))))
  (: ax-1-inst
     (≞ (𝛩 [PC] [ax-1] ([→] [𝜑] ([→] [𝜓] [𝜑])))
        (PLN.MkSTV 1 1))))
!(assertEqual
  (pln-bc &pln-bc.test.kb
          (fromNumber 0)
          (: $prf
             (≞ (𝛩 [PC] [ax-2] ([→] ([→] [𝜑] ([→] [𝜓] [𝜒]))
                                    ([→] ([→] [𝜑] [𝜓]) ([→] [𝜑] [𝜒]))))
                (PLN.MkSTV $s 1))))
  (: ax-2-inst
     (≞ (𝛩 [PC] [ax-2] ([→] ([→] [𝜑] ([→] [𝜓] [𝜒]))
                            ([→] ([→] [𝜑] [𝜓]) ([→] [𝜑] [𝜒]))))
        (PLN.MkSTV 1 1))))

;; Test conjunction
!(assertEqual
  (pln-bc &pln-bc.test.kb
          (fromNumber 1)
          (: $prf (≞ (∧ (𝛩 [PC] [ax-1] ([→] [𝜑] ([→] [𝜓] [𝜑])))
                        (𝛩 [PC]
                           [ax-2]
                           ([→] ([→] [𝜑] ([→] [𝜓] [𝜒]))
                                ([→] ([→] [𝜑] [𝜓]) ([→] [𝜑] [𝜒])))))
                     (PLN.MkSTV $s 1))))
  (: (CI ax-1-inst ax-2-inst)
     (≞ (∧ (𝛩 [PC] [ax-1] ([→] [𝜑] ([→] [𝜓] [𝜑])))
           (𝛩 [PC] [ax-2] ([→] ([→] [𝜑] ([→] [𝜓] [𝜒]))
                               ([→] ([→] [𝜑] [𝜓]) ([→] [𝜑] [𝜒])))))
        (PLN.MkSTV 1 1))))

;; Test existential quantification
!(assertEqual
  (pln-bc &pln-bc.test.kb
          (fromNumber 1)
          (: $prf (≞ (∃ z (𝛩 [PC] z ([→] [𝜑] ([→] [𝜓] [𝜑]))))
                     (PLN.MkSTV $s 1))))
  (: (EQI ax-1-inst)
     (≞ (∃ z (𝛩 [PC] z ([→] [𝜑] ([→] [𝜓] [𝜑])))) (PLN.MkSTV 1 1))))
!(assertEqual
  (pln-bc &pln-bc.test.kb
          (fromNumber 1)
          (: $prf
             (≞ (∃ z (𝛩 [PC] z ([→] ([→] [𝜑] ([→] [𝜓] [𝜒]))
                                    ([→] ([→] [𝜑] [𝜓]) ([→] [𝜑] [𝜒])))))
                (PLN.MkSTV $s 1))))
  (: (EQI ax-2-inst)
     (≞ (∃ z (𝛩 [PC] z ([→] ([→] [𝜑] ([→] [𝜓] [𝜒]))
                            ([→] ([→] [𝜑] [𝜓]) ([→] [𝜑] [𝜒])))))
        (PLN.MkSTV 1 1))))
!(assertEqualToResult
  (pln-bc &pln-bc.test.kb
          (fromNumber 2)
          (: $prf
             (≞ (∃ (s z) (∃ z (𝛩 [PC] z (s z))))
                (PLN.MkSTV $s 1))))
  ((: (EQI (EQI ax-1-inst)) (≞ (∃ (s z) (∃ z (𝛩 [PC] z (s z)))) (PLN.MkSTV 1 1)))
   (: (EQI (EQI ax-2-inst)) (≞ (∃ (s z) (∃ z (𝛩 [PC] z (s z)))) (PLN.MkSTV 1 1)))))
!(assertEqual
  (pln-bc &pln-bc.test.kb
          (fromNumber 2)
          (: (EQI $prfarg)
             (≞ (∃ (s z)
                   (∃ z
                      (𝛩 (Cons ([:] [mp2.1] [𝜑])
                               (Cons ([:] [mp2.2] [𝜓])
                                     (Cons ([:] [mp2.3] ([→] [𝜑] ([→] [𝜓] [𝜒])))
                                           [PC])))
                         ([ax-mp] z (s z))
                         ([→] [𝜓] [𝜒]))))
                (PLN.MkSTV $s 1))))
  (: (EQI (EQI ax-pm-inst))
     (≞ (∃ (s z)
           (∃ z
              (𝛩 (Cons ([:] [mp2.1] [𝜑])
                       (Cons ([:] [mp2.2] [𝜓])
                             (Cons ([:] [mp2.3] ([→] [𝜑] ([→] [𝜓] [𝜒])))
                                   [PC])))
                 ([ax-mp] z (s z))
                 ([→] [𝜓] [𝜒]))))
        (PLN.MkSTV 1 1))))

;; Test existential quantification and conjunction
!(assertEqual
  (pln-bc &pln-bc.test.kb
          (fromNumber 3)
          (: $prf (≞ (∃ (s z)
                        (∃ z
                           (∧ (𝛩 [PC] z ([→] [𝜑] ([→] [𝜓] [𝜑])))
                              (𝛩 [PC] (s z) ([→] ([→] [𝜑] ([→] [𝜓] [𝜒]))
                                                 ([→] ([→] [𝜑] [𝜓]) ([→] [𝜑] [𝜒])))))))
                     (PLN.MkSTV $s 1))))
  (: (EQI (EQI (CI ax-1-inst ax-2-inst)))
     (≞ (∃ (s z)
           (∃ z
              (∧ (𝛩 [PC] z ([→] [𝜑] ([→] [𝜓] [𝜑])))
                 (𝛩 [PC] (s z) ([→] ([→] [𝜑] ([→] [𝜓] [𝜒]))
                                    ([→] ([→] [𝜑] [𝜓]) ([→] [𝜑] [𝜒])))))))
        (PLN.MkSTV 1 1))))

;;;;;;;;;;;;;;;;
;; ;;;;;;;;;; ;;
;; ;; Test ;; ;;
;; ;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Random Control ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; The tests attempt to prove mp2, mp2b and a1i.1 respectively, which
;; are theorems from Metamath.  The inference control is completely
;; random, that is at each non-deterministic branch, the control
;; selects one randomly.  In order to find a proof, we rerun each
;; attempt for each theorem with a different random seed.  We also
;; store the seed for future use (which only works if the random
;; generator is fixed).  Additionally, in the random control
;; structure, a space is provided.  The backward chainer will populate
;; the spaces with 𝛩 instances.  These instances will be used in a
;; second round of inference control tests where PLN can be used to
;; reason about the instances to extract patterns to make better than
;; random inference control decisions.

;; Define PLN space
!(bind! &pln-kb (new-space))

;; Define random estimator
(: rnd-estimate (-> (List $a)           ; Environment
                    (List $a)           ; Surrounding premises
                    Nat                 ; Depth
                    $a                  ; Query
                    Number))            ; Estimate
(= (rnd-estimate $env $ctx $depth $query) (random-float &rng 0 1))

;; Define control with random estimator
!(bind! &rnd-ctl (MkControl &pln-kb rnd-estimate))

;; (: bc.test.mp2.p (-> Number Bool))
;; (= (bc.test.mp2.p $n) (set-rnd-seed-run0-not-empty $n bc.test.mp2))
;; !(until bc.test.mp2.p succ 0)
;;
;; At the end of the loop, it outputs the seed.

;; Test ax-3
(: bc.test.ax-3 (-> $a))
(= (bc.test.ax-3)
   (bc &rnd-ctl Nil Nil (fromNumber 0) (: $prf (→ (→ (¬ 𝜑) (¬ 𝜓)) (→ 𝜓 𝜑)))))
;; Define predicate to check a random seed for that test
(: bc.test.ax-3.p (-> Number Bool))
(= (bc.test.ax-3.p $n) (set-rnd-seed-run0-not-empty $n bc.test.ax-3))
;; Set or look for a random seed
!(bind! &bc.test.ax-3.seed
        (if &seed-search
            ;; Look for random seed
            (until bc.test.ax-3.p succ 0)
            ;; Use prederminted seed
            1))
!(println! ("Random seed for ax-3:" &bc.test.ax-3.seed))
;; Test
!(assertEqual
  (set-rnd-seed-run0 &bc.test.ax-3.seed bc.test.ax-3)
  (: ax-3 (→ (→ (¬ 𝜑) (¬ 𝜓)) (→ 𝜓 𝜑))))

;; Test subgoal of https://us.metamath.org/mpeuni/mp2.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
(: bc.test.sub-mp2 (-> $a))
(= (bc.test.sub-mp2)
   (bc &rnd-ctl
       (Cons (: mp2.1 𝜑)
             (Cons (: mp2.2 𝜓)
                   (Cons (: mp2.3 (→ 𝜑 (→ 𝜓 𝜒)))
                         Nil)))
       Nil
       (fromNumber 1)
       (: $prf (→ 𝜓 𝜒))))
;; Define predicate to check a random seed for that test
(: bc.test.sub-mp2.p (-> Number Bool))
(= (bc.test.sub-mp2.p $n) (set-rnd-seed-run0-not-empty $n bc.test.sub-mp2))
;; Set or look for a random seed
!(bind! &bc.test.sub-mp2.seed
        (if &seed-search
            ;; Look for random seed
            (until bc.test.sub-mp2.p succ 0)
            ;; Use prederminted seed
            0))
!(println! ("Random seed for sub-mp2:" &bc.test.sub-mp2.seed))
;; Test
!(assertEqual
  (set-rnd-seed-run0 &bc.test.sub-mp2.seed bc.test.sub-mp2)
  (: (ax-mp mp2.1 mp2.3) (→ 𝜓 𝜒)))

;; Test https://us.metamath.org/mpeuni/mp2.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
(: bc.test.mp2 (-> $a))
(= (bc.test.mp2)
   (bc &rnd-ctl
       (Cons (: mp2.1 𝜑)
             (Cons (: mp2.2 𝜓)
                   (Cons (: mp2.3 (→ 𝜑 (→ 𝜓 𝜒)))
                         Nil)))
       Nil
       (fromNumber 2)
       (: $prf 𝜒)))
;; Define predicate to check a random seed for that test
(: bc.test.mp2.p (-> Number Bool))
(= (bc.test.mp2.p $n) (set-rnd-seed-run0-not-empty $n bc.test.mp2))
;; Set or look for a random seed
!(bind! &bc.test.mp2.seed
        (if &seed-search
            ;; Look for random seed
            (until bc.test.mp2.p succ 0)
            ;; Use prederminted seed
            0))
!(println! ("Random seed for mp2:" &bc.test.mp2.seed))
;; Test
!(assertEqual
  (set-rnd-seed-run0 &bc.test.mp2.seed bc.test.mp2)
  (: (ax-mp mp2.2 (ax-mp mp2.1 mp2.3)) 𝜒))

;; Test https://us.metamath.org/mpeuni/mp2b.html
(: bc.test.mp2b (-> $a))
(= (bc.test.mp2b)
   (bc &rnd-ctl
       (Cons (: mp2b.1 𝜑)
             (Cons (: mp2b.2 (→ 𝜑 𝜓))
                   (Cons (: mp2b.3 (→ 𝜓 𝜒))
                         Nil)))
       Nil
       (fromNumber 2)
       (: $prf 𝜒)))
;; Define predicate to check a random seed for that test
(: bc.test.mp2b.p (-> Number Bool))
(= (bc.test.mp2b.p $n) (set-rnd-seed-run0-not-empty $n bc.test.mp2b))
;; Set or look for a random seed
!(bind! &bc.test.mp2b.seed
        (if &seed-search
            ;; Look for random seed
            (until bc.test.mp2b.p succ 0)
            ;; Use prederminted seed
            160))
!(println! ("Random seed for mp2b:" &bc.test.mp2b.seed))
;; Test
!(assertEqual
  (set-rnd-seed-run0 &bc.test.mp2b.seed bc.test.mp2b)
  (: (ax-mp (ax-mp mp2b.1 mp2b.2) mp2b.3) 𝜒))

;; Test https://us.metamath.org/mpeuni/a1i.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
(: bc.test.a1i.1 (-> $a))
(= (bc.test.a1i.1)
   (bc &rnd-ctl
       (Cons (: a1i.1 𝜑) Nil)
       Nil
       (fromNumber 1)
       (: $prf (→ 𝜓 𝜑))))
;; Define predicate to check a random seed for that test
(: bc.test.a1i.1.p (-> Number Bool))
(= (bc.test.a1i.1.p $n) (set-rnd-seed-run0-not-empty $n bc.test.a1i.1))
;; Set or look for a random seed
!(bind! &bc.test.a1i.1.seed
        (if &seed-search
            ;; Look for random seed
            (until bc.test.a1i.1.p succ 0)
            ;; Use prederminted seed
            4))
!(println! ("Random seed for mp2b:" &bc.test.a1i.1.seed))
;; Test
!(assertEqual
  (set-rnd-seed-run0 &bc.test.a1i.1.seed bc.test.a1i.1)
  (: (ax-mp a1i.1 ax-1) (→ 𝜓 𝜑)))

;; NEXT

;; ;; Run the backward chainer once unconstrained
;; (: bc.test.any (-> $a))
;; (= (bc.test.any)
;;    (bc &rnd-ctl Nil Nil (fromNumber 2) (: $prf $thrm)))

;; ;; Run the backward chainer with a given random seed and output the
;; ;; incremented random seed
;; (: bc.test.any.next (-> Number Number))
;; (= (bc.test.any.next $n)
;;    (let $_ (collapse (set-rnd-seed-run0 $n bc.test.any))
;;      (succ $n)))

;; ;; Run the backward chainer N times unconstrained
;; !(until (curried-equal-to 100) bc.test.any.next 0)

;; ;; Output PLN space
;; ! "&pln-kb:"
;; !(get-atoms &pln-kb)

;;;;;;;;;;;;;;;;;;;;;;
;; Test PLN Control ;;
;;;;;;;;;;;;;;;;;;;;;;

;; ;; The following is obtained from running the code above and can be uncommented to avoid rerunning that code.
;; !(add-reduct-nodup &pln-kb (: inst-1 (≞ (𝛩 [PC] [ax-3] ([→] ([→] ([¬] [𝜑]) ([¬] [𝜓])) ([→] [𝜓] [𝜑]))) (PLN.MkSTV 1 1))))
;; !(add-reduct-nodup &pln-kb (: inst-2 (≞ (𝛩 (Cons ([:] [mp2.1] [𝜑]) (Cons ([:] [mp2.2] [𝜓]) (Cons ([:] [mp2.3] ([→] [𝜑] ([→] [𝜓] [𝜒]))) [PC]))) [mp2.1] [𝜑]) (PLN.MkSTV 1 1))))
;; !(add-reduct-nodup &pln-kb (: inst-3 (≞ (𝛩 (Cons ([:] [mp2.1] [𝜑]) (Cons ([:] [mp2.2] [𝜓]) (Cons ([:] [mp2.3] ([→] [𝜑] ([→] [𝜓] [𝜒]))) [PC]))) [mp2.3] ([→] [𝜑] ([→] [𝜓] [𝜒]))) (PLN.MkSTV 1 1))))
;; !(add-reduct-nodup &pln-kb (: inst-4 (≞ (𝛩 (Cons ([:] [mp2.1] [𝜑]) (Cons ([:] [mp2.2] [𝜓]) (Cons ([:] [mp2.3] ([→] [𝜑] ([→] [𝜓] [𝜒]))) [PC]))) [mp2.2] [𝜓]) (PLN.MkSTV 1 1))))
;; !(add-reduct-nodup &pln-kb (: inst-5 (≞ (𝛩 (Cons ([:] [mp2.1] [𝜑]) (Cons ([:] [mp2.2] [𝜓]) (Cons ([:] [mp2.3] ([→] [𝜑] ([→] [𝜓] [𝜒]))) [PC]))) ([ax-mp] [mp2.1] [mp2.3]) ([→] [𝜓] [𝜒])) (PLN.MkSTV 1 1))))
;; !(add-reduct-nodup &pln-kb (: inst-6 (≞ (𝛩 (Cons ([:] [mp2.1] [𝜑]) (Cons ([:] [mp2.2] [𝜓]) (Cons ([:] [mp2.3] ([→] [𝜑] ([→] [𝜓] [𝜒]))) [PC]))) ([ax-mp] [mp2.2] ([ax-mp] [mp2.1] [mp2.3])) [𝜒]) (PLN.MkSTV 1 1))))
;; !(add-reduct-nodup &pln-kb (: inst-7 (≞ (𝛩 (Cons ([:] [mp2b.1] [𝜑]) (Cons ([:] [mp2b.2] ([→] [𝜑] [𝜓])) (Cons ([:] [mp2b.3] ([→] [𝜓] [𝜒])) [PC]))) [mp2b.1] [𝜑]) (PLN.MkSTV 1 1))))
;; !(add-reduct-nodup &pln-kb (: inst-8 (≞ (𝛩 (Cons ([:] [mp2b.1] [𝜑]) (Cons ([:] [mp2b.2] ([→] [𝜑] [𝜓])) (Cons ([:] [mp2b.3] ([→] [𝜓] [𝜒])) [PC]))) [mp2b.3] ([→] [𝜓] [𝜒])) (PLN.MkSTV 1 1))))
;; !(add-reduct-nodup &pln-kb (: inst-9 (≞ (𝛩 (Cons ([:] [mp2b.1] [𝜑]) (Cons ([:] [mp2b.2] ([→] [𝜑] [𝜓])) (Cons ([:] [mp2b.3] ([→] [𝜓] [𝜒])) [PC]))) [mp2b.2] ([→] [𝜑] [𝜓])) (PLN.MkSTV 1 1))))
;; !(add-reduct-nodup &pln-kb (: inst-a (≞ (𝛩 (Cons ([:] [mp2b.1] [𝜑]) (Cons ([:] [mp2b.2] ([→] [𝜑] [𝜓])) (Cons ([:] [mp2b.3] ([→] [𝜓] [𝜒])) [PC]))) ([ax-mp] [mp2b.1] [mp2b.2]) [𝜓]) (PLN.MkSTV 1 1))))
;; !(add-reduct-nodup &pln-kb (: inst-b (≞ (𝛩 (Cons ([:] [mp2b.1] [𝜑]) (Cons ([:] [mp2b.2] ([→] [𝜑] [𝜓])) (Cons ([:] [mp2b.3] ([→] [𝜓] [𝜒])) [PC]))) ([ax-mp] ([ax-mp] [mp2b.1] [mp2b.2]) [mp2b.3]) [𝜒]) (PLN.MkSTV 1 1))))
;; !(add-reduct-nodup &pln-kb (: inst-c (≞ (𝛩 (Cons ([:] [a1i.1] [𝜑]) [PC]) [a1i.1] [𝜑]) (PLN.MkSTV 1 1))))
;; !(add-reduct-nodup &pln-kb (: inst-d (≞ (𝛩 (Cons ([:] [a1i.1] [𝜑]) [PC]) [ax-1] ([→] [𝜑] ([→] [𝜓] [𝜑]))) (PLN.MkSTV 1 1))))
;; !(add-reduct-nodup &pln-kb (: inst-e (≞ (𝛩 (Cons ([:] [a1i.1] [𝜑]) [PC]) ([ax-mp] [a1i.1] [ax-1]) ([→] [𝜓] [𝜑])) (PLN.MkSTV 1 1))))
;; ;; !(add-reduct-nodup &pln-kb (≞ (∃ (s z) (∃ z (𝛩 (Cons ([:] [mp2.1] [𝜑]) (Cons ([:] [mp2.2] [𝜓]) (Cons ([:] [mp2.3] ([→] [𝜑] ([→] [𝜓] [𝜒]))) [PC]))) [ax-1] ([→] z ([→] (s z) z))))) (PLN.MkSTV 1 1)))
;; ;; !(add-reduct-nodup &pln-kb (≞ (∃ (s z) (∃ z (𝛩 (Cons ([:] [mp2b.1] [𝜑]) (Cons ([:] [mp2b.2] ([→] [𝜑] [𝜓])) (Cons ([:] [mp2b.3] ([→] [𝜓] [𝜒])) [PC]))) [ax-1] ([→] z ([→] (s z) z))))) (PLN.MkSTV 1 1)))
;; ;; !(add-reduct-nodup &pln-kb (≞ (∃ z (𝛩 (Cons ([:] [mp2b.1] [𝜑]) (Cons ([:] [mp2b.2] ([→] [𝜑] [𝜓])) (Cons ([:] [mp2b.3] ([→] [𝜓] [𝜒])) [PC]))) [ax-1] ([→] ([→] [𝜑] [𝜓]) ([→] z ([→] [𝜑] [𝜓]))))) (PLN.MkSTV 1 1)))
;; ;; !(add-reduct-nodup &pln-kb (≞ (∃ z (𝛩 (Cons ([:] [mp2b.1] [𝜑]) (Cons ([:] [mp2b.2] ([→] [𝜑] [𝜓])) (Cons ([:] [mp2b.3] ([→] [𝜓] [𝜒])) [PC]))) ([ax-mp] [mp2b.2] [ax-1]) ([→] z ([→] [𝜑] [𝜓])))) (PLN.MkSTV 1 1)))

;; In this series of tests we rerun the same tests as above but PLN is
;; allowed to reason about the viability of each branch.

;; Define PLN estimator, an estimator parameterized by a PLN knowledge
;; base about 𝛩, and a maximum depth of chaining for PLN reasoning.
(: pln-estimate (-> $a                 ; PLN knowledge base
                    Nat                ; PLN chaining depth
                    (-> (List $b)      ; Environment
                        (List $b)      ; Surrounding premises
                        Nat            ; Depth
                        $b             ; Query
                        Number)))      ; Estimate
(= ((pln-estimate $pln-kb $pln-depth) $env $ctx $depth $query)
   (trace! (👁 pln-estimate $pln-kb $pln-depth $env $ctx $depth $query)
   (let* (;; Extract PLN statement reflecting the backward chainer query
          ($pln-stm (toPLN (toTheory $env) $ctx $depth $query))
          ;; Build a PLN judgement from this statement
          ($pln-jdm (: $prf (≞ $pln-stm (PLN.MkSTV $s $c))))
          ;; Run PLN on this judgement
          ($results (collapse (pln-bc $pln-kb $pln-depth $pln-jdm)))
          ;; Build of list of results
          ($lst (List.fromExpression $results))
          ;; Select result with maximum confidence
          ((: $max-prf $max-stm) (List.maxElementWith lt_by_conf $lst))
          ;; Access its truth value
          ($tv (PLN.tv $max-stm)))
     ;; Thompson sample a first order probability from $tv
     (thompson-sample $tv))))

;; Define control with PLN estimator
!(bind! &pln-ctl-depth (fromNumber 2))
!(bind! &pln-ctl (MkControl &pln-kb (pln-estimate &pln-kb &pln-ctl-depth)))

;; Test ax-3
!(assertEqual
  (bc &pln-ctl Nil Nil (fromNumber 0) (: $prf (→ (→ (¬ 𝜑) (¬ 𝜓)) (→ 𝜓 𝜑))))
  (: ax-3 (→ (→ (¬ 𝜑) (¬ 𝜓)) (→ 𝜓 𝜑))))

;; Test sub-mp2
!(assertEqual
  (bc &pln-ctl
      (Cons (: mp2.1 𝜑)
            (Cons (: mp2.2 𝜓)
                  (Cons (: mp2.3 (→ 𝜑 (→ 𝜓 𝜒)))
                        Nil)))
      Nil
      (fromNumber 1)
      (: $prf (→ 𝜓 𝜒)))
  (: (ax-mp mp2.1 mp2.3) (→ 𝜓 𝜒)))
