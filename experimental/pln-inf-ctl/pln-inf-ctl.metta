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

;; Define DeBruijn type
(: DeBruijn Type)

;; Define DeBruijn constructors
(: z DeBruijn)                        ; Zero
(: s (-> DeBruijn DeBruijn))          ; Successor

;; Converters
(: DeBruijn.fromNat (-> Nat DeBruijn))
(= (DeBruijn.fromNat Z) z)
(= (DeBruijn.fromNat (S $k)) (s (DeBruijn.fromNat $k)))

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
(= (maxWith $lt $x $y) (if ($lt $x $y) $y $x))

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
(= (quux $x $y $z $w) (S $x $y $z $w))

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

;; Test qux wrapped in a DCall
!(assertEqual
  (DCall.run4 (MkDCall quux 42 True "abc" 42))
  (S 42 True "abc" 42))

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

;;;;;;;;;
;; PLN ;;
;;;;;;;;;

;; The vocabulary of PLN is defined as follows
;;
;; - Boolean connectors are ∧, ∨, ¬.  Note that these Boolean
;;   connectors are in fact pointwise predicate connectors.  So that
;;   (∧ P Q) is a predicate resulting from the pointwise conjunction
;;   of P and Q, themselves predicates.
;;
;; - Boolean constants ⊥ and ⊤, are also pointwise predicates
;;   corresponding respectively to the predicate that returns always
;;   False and the predicate that returns always True.  Please do not
;;   confuse ⊤ and T.  ⊤ is the top predicate, while T is an upper
;;   case letter of the Latin alphabet.  Before you start cursing me
;;   to no end for that decision, please consider that the type
;;   checker will be able to catch your potential typos.
;;
;; NEXT: define the PLN type, with PLN.Judgement, PLN.Statement and
;; PLN.Term.

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
;; - the surrounsing premises are Nil
;; - the depth 1
;;
;; would be converted into the following PLN query
;;
;; (∃z (Θ (Cons (_:_ _a1i.1_ _𝜑_) PC) z (_→_ _𝜓_ _𝜑_)) ∧ (depth_lte z 1))
;;
;; where
;;
;; - z is the first De Bruijn index,
;;
;; - all symbols of the logic have been dropped to the object level
;;   (or mesa level), by being surrounded with _.  So for instance, :
;;   becomes _:_, a1i.1 becomes _a1i.1_, → becomes _→_, etc.
;;
;; - The ternary predicate Θ is a PLN predicate representing the
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
(: toPLN (-> (List $a)                  ; Theory
             (List $a)                  ; Surrounding premises
             Nat                        ; Maximum Depth
             $a                         ; Query
             PLN.Judgement))            ; PLN judgement
(= (toPLN $thry $ctx $depth (: $prf $thrm))
   NEXT)

;; Like toPLN but takes the query and the surrounding premises all at
;; once, called context.  It does not take other parameters like
;; depth.  Additionally, it takes a list of variables encountered so
;; far in the context that has been consumed.  It outputs a pair of
;; list of all variables encountered so far and a PLN proposition as a
;; conjunction of Θ propositions.
(: contextToPLN (-> (List $a)                   ; Theory
                    (List Variable)             ; Variables so far
                    (List $a)                   ; Context
                    (Pair (List Variable) PLN.Statement))) ; Variables
                                                           ; and PLN
                                                           ; statement
(= (contextToPLN $thry $vars Nil)
   (MkPair $vars ))
(= (contextToPLN $thry $vars (Cons $head $tail))
   (let* (;; Turn the head into an atomic Θ proposition
          ((MkPair $nvars $headpln) (queryToPLN $thry $vars $head))
          ;; Turn the tail into a conjunction of Θ propositions
          ((MkPair $nnvars $tailpln) (contextToPLN $thry $nvars $tail)))
     (MkPair $nnvars (∧ $headpln $tailpln))))

;; Like contextToPLN but only takes a single query in argument
;; alongside a list of variables so far encountered.  It returns a
;; pair of list of variables encountered so far and a PLN statement
;; corresponding to a Θ atomic proposition.
(: queryToPLN (-> (List $a)                   ; Theory
                  (List Variable)             ; Variables encountered so far
                  $a                          ; Query
                  (Pair (List Variable) PLN.Statement))) ; Variables
                                                         ; and PLN
                                                         ; statement
(= (queryToPLN $thry $vars (: $prf $thrm))
   (let* (;; Convert proof into PLN term, and accumulate new variables
          ((MkPair $nvars $prfpln) (proofToPLN $vars $prf))
          ;; Convert type into PLN term, and accumulate new variables
          ((MkPair $nnvars $thrmpln) (typeToPLN $nvars $thrm)))
     (MkPair $nnvars (Θ $thry $prfpln $thrmpln))))

;; Like queryToPLN but takes a proof (or part thereof) in argument
;; alongside a list of variables so far encountered.  It outputs a
;; pair of variables encountered so far and a PLN term.
(: proofToPLN (-> (List Variable)       ; Variables encountered so far
                  $a                    ; Proof
                  (Pair (List Variable PLN.Term)) ; Variables and PLN
                                                  ; term
(= (proofToPLN $vars $prf)
   NEXT)

;; Like proofToPLN but takes a type (or part thereof) in argument
;; alongside a list of variables so far encountered.
(: typeToPLN (-> (List Variable)       ; Variables encountered so far
                  $a                   ; Type
                  (Pair (List Variable) PLN.Term))  ; Variables and
                                                    ; PLN term
(= (typeToPLN $vars $thrm)
   NEXT)

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
(: bc (-> (List $a)                     ; Environment
          (List $a)                     ; Surrounding premises
          Nat                           ; Maximum depth
          $a                            ; Query
          $a))                          ; Result

;;;;;;;;;;;;;;;;
;; Base cases ;;
;;;;;;;;;;;;;;;;

;; Match the environment
(: bc-env (-> (List $a) (List $a) Nat $a $a))
(= (bc-env $env $ctx $depth (: $prf $thrm))
   (trace! (® bc-env $ctx $depth (: $prf $thrm))
   (match' $env (: $prf $thrm) (: $prf $thrm))))

;; Axiom Simp. Axiom A1 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-1.html
(: bc-ax-1 (-> (List $a) (List $a) Nat $a $a))
(= (bc-ax-1 $env $ctx $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (trace! (® bc-ax-1 $ctx $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑)))))

;; Axiom Frege. Axiom A2 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-2.html
(: bc-ax-2 (-> (List $a) (List $a) Nat $a $a))
(= (bc-ax-2 $env $ctx $depth
            (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (trace! (® bc-ax-2 $ctx $depth (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))))))

;; Axiom Transp. Axiom A3 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-3.html
(: bc-ax-3 (-> (List $a) (List $a) Nat $a $a))
(= (bc-ax-3 $env $depth $ctx
            (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (trace! (® bc-ax-3 $ctx $depth (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)))))

;;;;;;;;;;;;;;;;;;;;
;; Recursive step ;;
;;;;;;;;;;;;;;;;;;;;

;; Rule 1 of [Hamilton] p. 73.
;; https://us.metamath.org/mpeuni/ax-mp.html
(: bc-ax-mp (-> (List $a) (List $a) Nat $a $a))
(= (bc-ax-mp $env $ctx (S $k) (: (ax-mp $prfarg1 $prfarg2) $𝜓))
   (trace! (® bc-ax-mp $ctx (S $k) (: (ax-mp $prfarg1 $prfarg2) $𝜓))
   (let* (;; Recurse on premise 1
          ((: $prfarg1 $𝜑)
           (bc $env
               ;; Add premise 2 in context
               (Cons (: $prfarg2 (→ $𝜑 $𝜓)) $ctx)
               $k (: $prfarg1 $𝜑)))
          ;; Recurse on premise 2
          ((: $prfarg2 (→ $𝜑 $𝜓))
           (bc $env
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
(: bce (-> (List $a)                      ; Environment
           (List $a)                      ; Surrounding premises
           Nat                            ; Depth
           $a                             ; Query
           (EDCall (List $a) (List $a) Nat $a $a))) ; EDCall

;; Estimate of matching the environment.  NEXT: the estimate should
;; probably be calculated for each matching result.
(= (bce $env $ctx $depth (: $prf $thrm))
   (MkEDCall (random-float &rng 0 1)    ; NEXT: replace by PLN
             (MkDCall bc-env $env $ctx $depth (: $prf $thrm))))

;; Estimate of Axiom A1
(= (bce $env $ctx $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (MkEDCall (random-float &rng 0 1)    ; NEXT: replace by PLN
             (MkDCall bc-ax-1 $env $ctx $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))))

;; Estimate of Axiom A2
(= (bce $env $ctx $depth
        (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (MkEDCall (random-float &rng 0 1)    ; NEXT: replace by PLN
             (MkDCall bc-ax-2 $env $ctx $depth
                      (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))))

;; Estimate of Axiom A3
(= (bce $env $ctx $depth
        (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (MkEDCall (random-float &rng 0 1)    ; NEXT: replace by PLN
             (MkDCall bc-ax-3 $env $ctx $depth
                      (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))))

;; Estimate of Rule 1 (modus ponens)
(= (bce $env $ctx (S $k)
        (: (ax-mp $prfarg1 $prfarg2) $𝜓))
   (MkEDCall (random-float &rng 0 1)    ; NEXT: replace by PLN
             (MkDCall bc-ax-mp $env $ctx (S $k)
                      (: (ax-mp $prfarg1 $prfarg2) $𝜓))))

;;;;;;;;;;;;;;
;; Monolith ;;
;;;;;;;;;;;;;;

;; See above for its type signature and comment
(= (bc $env $ctx $depth (: $prf $thrm))
   (trace! (® bc $ctx $depth (: $prf $thrm))
   (let* (($edcalls (collapse (bce $env $ctx $depth (: $prf $thrm))))
          ($edcall_seq (List.fromExpression $edcalls))
          ($best_edcall (List.maxElementWith EDCall.lt4 $edcall_seq)))
     (EDCall.run4 $best_edcall))))

;;;;;;;;;;;;;;;;
;; ;;;;;;;;;; ;;
;; ;; Test ;; ;;
;; ;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;

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
;;         (case (bc (Cons (: mp2.1 𝜑)
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
  (bc Nil Nil (fromNumber 0) (: $prf (→ (→ (¬ 𝜑) (¬ 𝜓)) (→ 𝜓 𝜑))))
  (: ax-3 (→ (→ (¬ 𝜑) (¬ 𝜓)) (→ 𝜓 𝜑))))

;; Test subgoal of https://us.metamath.org/mpeuni/mp2.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
!(set-random-seed &rng 0)
!(assertEqual
  (bc (Cons (: mp2.1 𝜑)
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
  (bc (Cons (: mp2.1 𝜑)
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
  (bc (Cons (: mp2b.1 𝜑)
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
  (bc (Cons (: a1i.1 𝜑) Nil)
      Nil
      (fromNumber 1)
      (: $prf (→ 𝜓 𝜑)))
  (: (ax-mp a1i.1 ax-1) (→ 𝜓 𝜑)))
