;; Inference control experiment using PLN as inference controller.
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

;;;;;;;;;;
;; List ;;
;;;;;;;;;;

;; Declaration of List data type and constructors
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

;; Build a list from an expression, containing all the sub-expressions
;; as elements of the list.
(: fromExpression (-> Expression (List $a)))
(= (fromExpression $expr) (if (== $expr ())
                              Nil
                              (let* (($head (car-atom $expr))
                                     ($tail (cdr-atom $expr)))
                                (Cons $head (fromExpression $tail)))))

;; Return the maximum between two value given a certain less than
;; predicate.
(: maxWith (-> (-> $a $a Bool) $a $a Bool))
(: (= maxWith $tl $x $y) (if ($tl $x $y) $y $x))

;; Return a maximum element of a non empty list, given a certain less
;; than predicate.
(: List.maxElementWith (-> (-> $a $a Bool) (List $a) $a))
(= (List.maxElementWith $tl (Cons $head $tail))
   (case $tail
     (Nil $head)
     ($else (let $met (List.maxElementWith $lt $tail)
              (maxWith $tl $head $met)))))

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

;; DCall data constructors
(: MkDCall (-> (-> $a) (DCall $a)))                            ; Nullary
(: MkDCall (-> (-> $a $b) $a (DCall $a $b)))                   ; Unary
(: MkDCall (-> (-> $a $b $c) $a $b (DCall $a $b $c)))          ; Binary
(: MkDCall (-> (-> $a $b $c $d) $a $b $c (DCall $a $b $c $d))) ; Ternary

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;; ;;
;; ;; Backward chainer ;; ;;
;; ;;;;;;;;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; For now we write a backward chainer that is specialized for the
;; propositional calculus of MetaMath.  The inference control
;; simulates a Thompson sampling selection (though totally random for
;; now), that is a random number is associated to each path of
;; possible non-deterministic reductions, and only the path with the
;; greatest number is taken.  Also, to make the random selection
;; easier to implement, to have more control over the non-determinism,
;; the coding style is monolithic.
(: bc (-> (List $b)                     ; Environment
          Nat                           ; Maximum depth
          $c                            ; Query
          $c))                          ; Result

;;;;;;;;;;;;;;;;
;; Base cases ;;
;;;;;;;;;;;;;;;;

;; Match the environment
(: bc-env (-> (List $a) Nat $a $a))
(= (bc-env $env $depth (: $prf $thrm))
   (match' $env (: $prf $thrm) (: $prf $thrm)))

;; Axiom Simp. Axiom A1 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-1.html
(: bc-ax-1 (-> (List $a) Nat $a $a))
(= (bc-ax-1 $env $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))

;; Axiom Frege. Axiom A2 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-2.html
(: bc-ax-2 (-> (List $a) Nat $a $a))
(= (bc-ax-2 $env
            $depth
            (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))

;; Axiom Transp. Axiom A3 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-3.html
(: bc-ax-3 (-> (List $a) Nat $a $a))
(= (bc-ax-3 $env $depth (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))

;;;;;;;;;;;;;;;;;;;;
;; Recursive step ;;
;;;;;;;;;;;;;;;;;;;;

;; Rule 1 of [Hamilton] p. 73.
;; https://us.metamath.org/mpeuni/ax-mp.html
(: bc-ax-mp (-> (List $a) Nat $a $a))
(= (bc-ax-mp $env (S $k) (: (ax-mp $prfarg1 $prfarg2) $𝜓))
   (let* (;; Recurse on premise 1
          ((: $prfarg1 $𝜑) (bc $env $k (: $prfarg1 $𝜑)))
          ;; Recurse on premise 2
          ((: $prfarg2 (→ $𝜑 $𝜓)) (bc $env $k (: $prfarg2 (→ $𝜑 $𝜓)))))
     (: (ax-mp $prfarg1 $prfarg2) $𝜓)))

;;;;;;;;;;;;;;
;; Monolith ;;
;;;;;;;;;;;;;;

(= (bc $env $depth (: $prf $thrm))
   (let $estimates (collapse (ebc $env $depth (: $prf $thrm)))
     (List.maxElementWith EDCall.lt (fromExpression $estimates))))

;; Define backward chainer estimate.  It mirrors the backward chainer
;; code, but outputs an EDCall, meaning a branch and its estimate of
;; success, instead of directly taking the branch.
(: ebc (-> (List $a)                      ; Environment
           Nat                            ; Depth
           $a                             ; Query
           (EDCall (List $a) Nat $a $a))) ; EDCall

;; Estimate of matching the environment.  NEXT: the estimate should be
;; calculated for each matching result.
(= (ebc $env $depth (: $prf $thrm))
   (MkEDCall (random-float &rng 0 1)    ; Random for now
             (MkDCall bc-env $env $depth (: $prf $thrm))))

;; Estimate of Axiom A1
(= (ebc $env $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (MkEDCall (random-float &rng 0 1)    ; Random for now
             (MkDCall bc-env $env $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))))

;;
(= (bc-estimate $env $depth (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (bc-estimate-ax-2 (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))))))
(= (bc-estimate $env $depth (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (bc-estimate-ax-3 (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)))))
(= (bc-estimate $env (S $k) (: (ax-mp $prfarg1 $prfarg2) $𝜓))
   (bc-estimate-ax-mp $env (S $k) (: (ax-mp $prfarg1 $prfarg2) $𝜓)))

;;;;;;;;;;;;;;;;
;; ;;;;;;;;;; ;;
;; ;; Test ;; ;;
;; ;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;

;; Test subgoal of https://us.metamath.org/mpeuni/mp2.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
!(bc (Cons (: mp2.1 𝜑)
           (Cons (: mp2.2 𝜓)
                 (Cons (: mp2.3 (→ 𝜑 (→ 𝜓 𝜒)))
                       Nil)))
     (fromNumber 1)
     ;; (: (ax-mp mp2.1 mp2.3) (→ 𝜓 𝜒)))
     (: $prf (→ 𝜓 𝜒)))

;; Test https://us.metamath.org/mpeuni/mp2.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
!(bc (Cons (: mp2.1 𝜑)
           (Cons (: mp2.2 𝜓)
                 (Cons (: mp2.3 (→ 𝜑 (→ 𝜓 𝜒)))
                       Nil)))
     (fromNumber 2)
     ;; (: (ax-mp mp2.2 (ax-mp mp2.1 mp2.3)) 𝜒))
     (: $prf 𝜒))

;; Test https://us.metamath.org/mpeuni/mp2b.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
!(bc (Cons (: mp2b.1 𝜑)
           (Cons (: mp2b.2 (→ 𝜑 𝜓))
                 (Cons (: mp2b.3 (→ 𝜓 𝜒))
                       Nil)))
     (fromNumber 2)
     ;; (: (ax-mp (ax-mp mp2b.1 mp2b.2) mp2b.3) 𝜒))
     (: $prf 𝜒))

;; Test https://us.metamath.org/mpeuni/a1i.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
!(bc (Cons (: a1i.1 𝜑) Nil)
     (fromNumber 1)
     ;; (: (ax-mp a1i.1 ax-1) (→ 𝜓 𝜑)))
     (: $prf (→ 𝜓 𝜑)))
