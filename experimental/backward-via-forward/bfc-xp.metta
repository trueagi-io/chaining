;; Backward via forward chaining.  It works by forwadly generating
;; hypothetical truths (and their associated proof abstractions)
;; instead of absolute truths (and their associated proofs), then,
;; still going forward, by applying these hypothetical truths to the
;; axioms to reach absolute truths.  The idea being that only
;; hypothetical truth proving given theorems are produced and nothing
;; else.
;;
;; Hypothetical truths are produced using dedicated combinators.
;;
;; By combining the bluebird and blackbird
;; [combinators](https://hackage.haskell.org/package/data-aviary-0.4.0/docs/src/Data-Aviary-Birds.html)
;; one can apply modus ponens backward while doing forward chaining.
;;
;; The blackbird operator can be used to create a specialized rule to
;; expand modus ponens backward on the first argument of any abstract
;; proof:
;;
;; .:mp = (λ z ((.: z) mp))
;;
;; with type signature
;;
;; (-> (-> $b $c) (-> (→ $a $b) (-> $a $c)))
;;
;; or in Haskell
;;
;; (b -> c) -> ((→ a b) -> a -> c)
;;
;; meaning this rule can turn any abstract proof of type (b -> c) into
;; am abstract proof of type (→ a b) -> a -> c.  In other words b is
;; replaced by (→ a b) -> a, i.e. a monus ponens expansion on the
;; first argument.
;;
;; Then the bluebird can be used to move this specialized rule to
;; expand modus ponens backward to any argument of any abstract proof:
;;
;; (. .:mp) to expand the second argument, (. (. .:mp)) to expand the
;; third argument, etc.

;; Disable co-unification
!(translatePredicate (set_prolog_flag occurs_check True))

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

;; Cast Number into Nat
(: fromNumber (-> Number Nat))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

;; Add two natural numbers
(: plus (-> Nat Nat Nat))
(= (plus $x Z) $x)
(= (plus $x (S $y)) (plus (S $x) $y))

;; Test plus
!(test
  (plus (S (S Z)) (S (S (S Z))))
  (S (S (S (S (S Z))))))

;; Subtrack two natural numbers.  If the second natural is greater
;; than the first then return zero.
(: minus (-> Nat Nat Nat))
(= (minus $x Z) $x)
(= (minus (S $x) (S $y)) (minus $x $y))
(= (minus Z (S $y)) Z)

;; Test minus
!(test
  (minus (S (S Z)) (S (S (S Z))))
  Z)
!(test
  (minus (S (S (S Z))) (S (S Z)))
  (S Z))

;; Less than or equal comparison for natural numbers
(= (lte Z Z) True)
(= (lte Z (S $y)) True)
(= (lte (S $x) Z) False)
(= (lte (S $x) (S $y))
   (trace! (👁 (=== lte (S $x) (S $y) (lte $x $y)))
   (lte $x $y)))
;; (= (lte Z Z) True)
;; (= (lte Z (S $y)) True)
;; (= (lte (S $x) Z) False)
;; (= (lte (S $x) (S $y)) (lte $x $y))

;; Test lte
!(test
  (lte (S (S Z)) (S (S Z)))
  True)
!(test
  (lte (S (S Z)) (S Z))
  False)
!(test
  (lte (S Z) (S (S Z)))
  True)

;;;;;;;;;;
;; When ;;
;;;;;;;;;;

;; NEXT: disabled because it results in massive slowdown or freeze

;; ;; Run the code if the condition is true, otherwise prune the branch
;; (: when (-> Bool Atom $a))
;; (= (when $c $x) (if $c $x (empty)))

;;;;;;;;;;;;;;;;;;;;;
;; De Bruijn Index ;;
;;;;;;;;;;;;;;;;;;;;;

;; Define DeBruijn type
(: DeBruijn Type)

;; Define DeBruijn constructors
(: z DeBruijn)                        ; Zero
(: s (-> DeBruijn DeBruijn))          ; Successor

;;;;;;;;;;
;; List ;;
;;;;;;;;;;

;; Declaration of List data type and constructors
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

;;;;;;;;;;;
;; Maybe ;;
;;;;;;;;;;;

;; Define Maybe type
(: Maybe (-> $a Type))
(: Nothing (Maybe $a))
(: Just (-> $a (Maybe $a)))

;;;;;;;;;;;
;; Sized ;;
;;;;;;;;;;;

;; ;; Associate a size to a term
;; (: Sized (-> $a Type))
;; (: MkSized (-> Nat $a (Sized $a)))

;;;;;;;;;;;;;;;;;;;
;; Curry/Uncurry ;;
;;;;;;;;;;;;;;;;;;;

;; ;; Define is-expression
;; (: is-expression (-> Atom Bool))
;; (= (is-expression $term) (== (get-metatype $term) Expression))

;; ;; Define cons-cons-atom, that applies const-atom twice
;; (: cons-cons-atom (-> Atom Atom Atom Atom))
;; (= (cons-cons-atom $head1 $head2 $tail)
;;    (let $head2-tail (cons-atom $head2 $tail)
;;      (cons-atom $head1 $head2-tail)))

;; ;; Given a pair of arguments and a binary operator, flattened the
;; ;; right argument if it contains the binary operator.  The
;; ;; unflattening does not propagate recursively to left, only to the
;; ;; right and only to the operator right below, and so on.
;; ;;
;; ;; For instance
;; ;;
;; ;; (right-dissociate (-> T1 (-> T2 (T3 A B))) ->)
;; ;;
;; ;; outputs
;; ;;
;; ;; (-> T1 T2 (T3 A B))
;; (: right-dissociate (-> Atom Atom Atom))
;; (= (right-dissociate $term $op)
;;    (if (is-expression $term)
;;        (if (== $term ())
;;            ()
;;            (case $term
;;              ((($op $larg $rarg) (let* (($rd-larg (right-dissociate $larg $op))
;;                                         ($rd-rarg (right-dissociate $rarg $op)))
;;                                    (if (is-expression $rd-rarg)
;;                                        (let* (($head (car-atom $rd-rarg))
;;                                               ($tail (cdr-atom $rd-rarg)))
;;                                          (if (== $head $op)
;;                                              (cons-cons-atom $op $larg $tail)
;;                                              (cons-cons-atom $op $larg ($rd-rarg))))
;;                                        (cons-cons-atom $op $larg ($rd-rarg)))))
;;               ($_ $term))))
;;        $term))

;; ;; Test right-associate-with
;; !(test
;;   (right-dissociate T ->)
;;   T)
;; !(test
;;   (right-dissociate () ->)
;;   ())
;; !(test
;;   (right-dissociate (T) ->)
;;   (T))
;; !(test
;;   (right-dissociate (-> T1 T2) ->)
;;   (-> T1 T2))
;; !(test
;;   (right-dissociate (-> T1 (T2 A B)) ->)
;;   (-> T1 (T2 A B)))
;; !(test
;;   (right-dissociate (-> T1 (-> T2 T3)) ->)
;;   (-> T1 T2 T3))
;; !(test
;;   (right-dissociate (-> T1 (-> T2 (T3 A B))) ->)
;;   (-> T1 T2 (T3 A B)))
;; !(test
;;   (right-dissociate (-> (-> T1 (-> T2 T3)) T4) ->)
;;   (-> (-> T1 T2 T3) T4))

;; ;; Convert type from curried format to uncurried format.
;; ;;
;; ;; For instance
;; ;;
;; ;; (uncurry-type (: Trans (-> (=== $x $y) (-> (=== $y $z) (=== $x $z)))))
;; ;;
;; ;; outputs
;; ;;
;; ;; (: Trans (-> (=== $x $y) (=== $y $z) (=== $x $z)))
;; ;;
;; ;; Note that the uncurrying only occurs on the arrow operator, nowhere
;; ;; else.
;; (: uncurry-type (-> Atom Atom))
;; (= (uncurry-type $term)
;;    (if (is-expression $term)
;;        (if (== $term ())
;;            ()
;;            (let* (($head (car-atom $term))
;;                   ($tail (cdr-atom $term)))
;;              (if (== $head ->)
;;                  (right-dissociate $term $head)
;;                  (let* (($ca-head (uncurry-type $head))
;;                         ($ca-tail (uncurry-type $tail)))
;;                    (cons-atom $ca-head $ca-tail)))))
;;        $term))

;; ;; Test uncurry-type
;; !(test
;;   (uncurry-type T)
;;   T)
;; !(test
;;   (uncurry-type ())
;;   ())
;; !(test
;;   (uncurry-type (T))
;;   (T))
;; !(test
;;   (uncurry-type (R A B))
;;   (R A B))
;; !(test
;;   (uncurry-type ((R A B)))
;;   ((R A B)))
;; !(test
;;   (uncurry-type (-> T1 T2))
;;   (-> T1 T2))
;; !(test
;;   (uncurry-type (-> T1 (-> T2 T3)))
;;   (-> T1 T2 T3))
;; !(test
;;   (uncurry-type (-> (-> T1 (-> T2 T3)) T4))
;;   (-> (-> T1 T2 T3) T4))

;; ;; ;; Uncurry ((. f) g) to (. f g)
;; ;; ;; (: bluebird-uncurry (-> Atom (Maybe Atom)))
;; ;; (= (bluebird-uncurry $term)
;; ;;    (case $term
;; ;;      (((($bluebird $f) $g) (if (== $bluebird .)
;; ;;                                (Just (. $f $g))
;; ;;                                Nothing))
;; ;;       ($else Nothing))))

;; ;; ;; Test bluebird-uncurry
;; ;; !(test
;; ;;   (bluebird-uncurry ((. $f) $g))
;; ;;   (Just (. $f $g)))
;; ;; !(test
;; ;;   (bluebird-uncurry (((Φ $f) $g) $h))
;; ;;   Nothing)

;; ;; ;; Uncurry term, so for instance
;; ;; ;;
;; ;; ;; ((. $f) $g)
;; ;; ;;
;; ;; ;; becomes
;; ;; ;;
;; ;; ;; (. $f $g)
;; ;; ;;
;; ;; ;; Take into account the arity of the operators involved.  For
;; ;; ;; instance
;; ;; ;;
;; ;; ;; (((. $f) $g) $x)
;; ;; ;;
;; ;; ;; becomes
;; ;; ;;
;; ;; ;; ((. $f $g) $x)
;; ;; ;;
;; ;; ;; instead of
;; ;; ;;
;; ;; ;; (. $f $g $x)
;; ;; ;;
;; ;; ;; because . is binary, not trinary.
;; ;; (: uncurry-term (-> Atom Atom))
;; ;; (= (uncurry-term $term)
;; ;;    (case (get-metatype $term)
;; ;;      ((Variable $term)
;; ;;       (Symbol $term)
;; ;;       (Grounded $term)
;; ;;       (Expression
;; ;;        (if (== $term ())
;; ;;            ()
;; ;;            ;; Recursive steps
;; ;;            (case $term
;; ;;              ((($f $g) (let* (($νf (uncurry-term $f))
;; ;;                               ($νg (uncurry-term $g)))
;; ;;                          (if (and (== $νf $f) (== $νg $g))
;; ;;                              ;; $f and $g are uncurried, try to match
;; ;;                              ;; them to known uncurring rules
;; ;;                              (case (bluebird-uncurry $term)
;; ;;                                (;; They match, return the result
;; ;;                                 ((Just $r) $r)
;; ;;                                 ;; They do not match, return unchanged
;; ;;                                 (Nothing ($f $g))))
;; ;;                              ;; $f and $g changed, attempt to uncurry
;; ;;                              ;; their application once more
;; ;;                              (uncurry-term ($νf $νg)))))
;; ;;               ;; Otherwise, return unchanged
;; ;;               ($else $term))))))))

;; ;; ;; Test uncurry-term
;; ;; !(test
;; ;;   (uncurry-term ((. $f) $g))
;; ;;   (. $f $g))
;; ;; !(test
;; ;;   (uncurry-term ((. $h) ((. $i) $j)))
;; ;;   (. $h (. $i $j)))
;; ;; !(test
;; ;;   (uncurry-term (. (. .:mp)))
;; ;;   (. (. .:mp)))

;; ;; ;; Uncurry a type definition
;; ;; (: uncurry (-> Atom Atom))
;; ;; (= (uncurry (: $x $a)) (: (uncurry-term $x) (uncurry-type $a)))

;; ;; ;; ;; test uncurry
;; ;; ;; ;; !(test
;; ;; ;;   !(uncurry (: (. (. .:mp))
;; ;; ;;               (-> (-> $a (-> $b (-> $d $e)))
;; ;; ;;                   (-> $a (-> $b (-> (→ $c $d) (-> $c $e)))))))
;; ;; ;;   ;; (: (. (. .:mp)) (-> (-> $a $b $d $e)
;; ;; ;;   ;;                     $a $b (→ $c $d) $c $e)))
;; ;; ;; (: (. (. .:mp)) (-> (-> $_365620 (-> $_365638 (-> $_365656 $_365662)))
;; ;; ;;                     $_365620 $_365638 (→ $_365692 $_365656) $_365692 $_365662))

;;;;;;;;;;;;;;;
;; Reduction ;;
;;;;;;;;;;;;;;;

;; Reduce proofs with .:mp into equivalent proofs with mp
;; NEXT: implement

;;;;;;;;;;;;;;;;;;;;;
;; Match over list ;;
;;;;;;;;;;;;;;;;;;;;;

;; Similar to match but takes a list of terms instead of a space.
;; (: match' (-> (List Atom) $a $a $a))
(= (match' Nil $pattern $rewrite) (empty))
(= (match' (Cons $head $tail) $pattern $rewrite) (let $pattern $head $rewrite))
(= (match' (Cons $head $tail) $pattern $rewrite) (match' $tail $pattern $rewrite))

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

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Curried backward chainer
(: bc (-> $a                            ; Knowledge base space
          Nat                           ; Maximum depth
          $b                            ; Query
          $c))                          ; Result

;; Base cases
(= (bc $kb $_ (: $x $a)) (match $kb (: $x $a) (: $x $a)))

;; Recursive steps
;; Proof application
(= (bc $kb (S $k) (: ($f $x) $b))
   (let* (((: $f (-> $a $b)) (bc $kb $k (: $f (-> $a $b))))
          ((: $x $a) (bc $kb $k (: $x $a))))
     ;; Filter out mp because it is not a proposition
     (if (!= $x mp) (: ($f $x) $b) (empty))))
     ;; (when (!= $x mp) (: ($f $x) $b))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer with λ abstraction ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Curried backward chainer with lambda abstraction
(: λbc (-> $a                            ; Knowledge base space
           $b                            ; Environment
           DeBruijn                      ; De Bruijn Index
           Nat                           ; Maximum depth
           $c                            ; Query
           $d))                          ; Result

;; Base cases
(= (λbc $kb $env $idx $_ (: $x $a))
   (match $kb (: $x $a) (: $x $a)))
(= (λbc $kb $env $idx $_ (: $x $a))
   (match' $env (: $x $a) (: $x $a)))

;; Recursive steps

;; Proof application
(= (λbc $kb $env $idx (S $k) (: ($f $x) $b))
   ;; (trace! (👁 λbc-app $kb $env $idx (S $k) (: ($f $x) $b))
   (let* (((: $f (-> $a $b)) (λbc $kb $env $idx $k (: $f (-> $a $b))))
          ((: $x $a) (λbc $kb $env $idx $k (: $x $a))))
     (: ($f $x) $b)));)
;; Proof abstraction
(= (λbc $kb $env $x (S $k) (: (λ $x $y) (-> $a $b)))
   ;; (trace! (👁 λbc-abs $kb $env $x (S $k) (: (λ $x $y) (-> $a $b)))
   (let (: $y $b)
     (λbc $kb (Cons (: $x $a) $env) (s $x) $k (: $y $b))
     (: (λ $x $y) (-> $a $b))));)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer with maximum proof size ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Backward chainer with maximum proof size, specialized for
;; propositional calculus.  Note that here, contrary to depth, leaves
;; (i.e. axioms) have a size of 1.  Internal nodes (i.e. inference
;; rules) also have a size of 1.  However to apply an n-ary inference
;; rule requires at least a size of 1 + arity, one for the internal
;; node, arity for the children.
;; (: sbc (Nat                           ; Maximum size
;;         $a                            ; Query
;;         (Sized $b)))                  ; Sized result

;; Base cases, axioms ax-1, ax-2, ax-3
(= (sbc Z (: $x $a)) (empty))
(= (sbc (S $k) (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (MkSized (S Z) (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑)))))
(= (sbc (S $k) (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (MkSized (S Z) (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))))))
(= (sbc (S $k) (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (MkSized (S Z) (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)))))

;; Recursive step, inference rule mp
(= (sbc (S (S (S $k))) (: (mp $f $x) $b))
   (let* (((MkSized $fs (: $f (→ $a $b))) (sbc (S $k) (: $f (→ $a $b))))
          ((MkSized $xs (: $x $a)) (sbc (minus (S (S $k)) $fs) (: $x $a))))
     (MkSized (S (plus $fs $xs)) (: (mp $f $x) $b))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Optimized backward chainer with maximum proof size ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Same as above but uses Number instead of Nat
(= (obc-gtz $s (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (MkSized 1 (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑)))))
(= (obc-gtz $s (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (MkSized 1 (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))))))
(= (obc-gtz $s (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (MkSized 1 (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)))))
(= (obc-gtz $s (: (mp $f $x) $b))
   (if (< 2 $s)
       (let* (((MkSized $fs (: $f (→ $a $b))) (obc (- $s 2) (: $f (→ $a $b))))
              ((MkSized $xs (: $x $a)) (obc (- (- $s 1) $fs) (: $x $a))))
         (MkSized (+ (+ $fs $xs) 1) (: (mp $f $x) $b)))
       (empty)))
(= (obc $s (: $x $a))
   (if (< 0 $s)
       (obc-gtz $s (: $x $a))
       (empty)))
;; (= (obc-gtz $s (: (mp $f $x) $b))
;;    (when (< 2 $s)
;;      (let* (((MkSized $fs (: $f (→ $a $b))) (obc (- $s 2) (: $f (→ $a $b))))
;;             ((MkSized $xs (: $x $a)) (obc (- (- $s 1) $fs) (: $x $a))))
;;        (MkSized (+ (+ $fs $xs) 1) (: (mp $f $x) $b)))))
;; (= (obc $s (: $x $a))
;;    (when (< 0 $s) (obc-gtz $s (: $x $a))))

;;;;;;;;;;;;;;;;;;;;;
;; Forward Chainer ;;
;;;;;;;;;;;;;;;;;;;;;

;; Apply one forward chaining step by applying each rule in the rule
;; base space, $rb, to the argument (: $x $a).
;; (: fc-step (-> $a                       ; Knowledge base
;;                $b                       ; Query
;;                $c))
;; Unary application given argument
(= (fc-step $rb (: $x $a)) (match $rb (: $f (-> $a $b)) (: ($f $x) $b)))
;; Unary application given abstraction
(= (fc-step $rb (: $f (-> $a $b))) (match $rb (: $x $a) (: ($f $x) $b)))

;; Iteratively apply forward chaining growing the results at each
;; iteration.
;; (: fc (-> $a                            ; Knowledge base
;;           Nat                           ; Maximum depth
;;           $b                            ; Target Query
;;           $b                            ; Query
;;           $b))
;; Base case.
(= (fc $rb $depth (: $tx $ta) (: $x $a))
   ;; (trace! (👁 fc-b $rb $depth (: $tx $ta) (: $x $a))
   (let (: $x $a) (: $tx $ta) (: $x $a)));)
;; Recursive step
(= (fc $rb (S $k) (: $tx $ta) (: $x $a))
   ;; (trace! (👁 fc-r $rb (S $k) (: $tx $ta) (: $x $a))
   (fc $rb $k (: $tx $ta) (fc-step $rb (: $x $a))));)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer via forward chaining ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Backward via forward chaining
;; (: (bfc (-> $a                         ; Knowledge base
;;             Nat                        ; Maximum depth
;;             $b                         ; Query
;;             $b)))
(= (bfc $rb $depth (: $x $a))
   ;; (trace! (👁 bfc $rb $depth (: $x $a))
           (fc $rb $depth (: $x $a) (: id (-> $a $a))));)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Optimized Forward Chainer ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Like above but specialized for inversed propositional calculus,
;; uses Number instead of Nat and avoid placing .:mp as arguments.

;; ;; Iteratively apply forward chaining growing the results at each
;; ;; iteration.
;; ;; (: ofc (-> Number                        ; Maximum depth
;; ;;            Number                        ; Hypotheses count
;; ;;            $b                            ; Target Query
;; ;;            $b                            ; Query
;; ;;            $b))
;; ;; Base case.
;; (= (ofc $depth $hypcnt (: $tx $ta) (: $x $a))
;;    (if (== $hypcnt 0)
;;        (let (: $x $a) (: $tx $ta) (: $x $a))
;;        (empty)))

;; ;; Recursive steps
;; ;; Specialized application given argument of .:mp
;; (= (ofc $depth $hypcnt (: $tx $ta) (: $f (-> $b $c)))
;;    (if (and (< 0 $depth) (<= $hypcnt $depth))
;;        (ofc (- $depth 1) (+ $hypcnt 1) (: $tx $ta)
;;             (: (.:mp $f) (-> (→ $a $b) (-> $a $c))))
;;        (empty)))
;; ;; Specialized application given abstraction
;; (= (ofc $depth $hypcnt (: $tx $ta) (: $f (-> (→ $𝜑 (→ $𝜓 $𝜑)) $b)))
;;    (if (and (< 0 $depth) (<= $hypcnt $depth))
;;        (ofc (- $depth 1) (- $hypcnt 1) (: $tx $ta) (: ($f ax-1) $b))
;;        (empty)))
;; (= (ofc $depth $hypcnt (: $tx $ta)
;;         (: $f (-> (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))) $b)))
;;    (if (and (< 0 $depth) (<= $hypcnt $depth))
;;        (ofc (- $depth 1) (- $hypcnt 1) (: $tx $ta) (: ($f ax-2) $b))
;;        (empty)))
;; (= (ofc $depth $hypcnt (: $tx $ta) (: $f (-> (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)) $b)))
;;    (if (and (< 0 $depth) (<= $hypcnt $depth))
;;        (ofc (- $depth 1) (- $hypcnt 1) (: $tx $ta) (: ($f ax-3) $b))
;;        (empty)))

;; Iteratively apply forward chaining growing the results at each
;; iteration.
;; (: ofc (-> Nat                           ; Maximum depth
;;            Nat                           ; Hypotheses count
;;            $b                            ; Target Query
;;            $b                            ; Query
;;            $b))
;; Base case.
(= (ofc $depth Z (: $tx $ta) (: $x $a))
   (let (: $x $a) (: $tx $ta) (: $x $a)))

;; Recursive steps
;; Specialized application given argument of .:mp
(= (ofc (S $k) (S $l) (: $tx $ta) (: $f (-> $b $c)))
   (if (lte $l $k)
       (ofc $k (S (S $l)) (: $tx $ta)
            (: (.:mp $f) (-> (→ $a $b) (-> $a $c))))
       (empty)))
;; Specialized application given abstraction
(= (ofc (S $k) (S $l) (: $tx $ta) (: $f (-> (→ $𝜑 (→ $𝜓 $𝜑)) $b)))
   (if (lte $l $k)
       (ofc $k $l (: $tx $ta) (: ($f ax-1) $b))
       (empty)))
(= (ofc (S $k) (S $l) (: $tx $ta)
        (: $f (-> (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))) $b)))
   (if (lte $l $k)
       (ofc $k $l (: $tx $ta) (: ($f ax-2) $b))
       (empty)))
(= (ofc (S $k) (S $l) (: $tx $ta) (: $f (-> (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)) $b)))
   (if (lte $l $k)
       (ofc $k $l (: $tx $ta) (: ($f ax-3) $b))
       (empty)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Optimized backward chainer via forward chaining ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Backward via forward chaining
;; ;; (: (obfc (-> Number                     ; Maximum depth
;; ;;              $b                         ; Query
;; ;;              $b)))
;; (= (obfc $depth (: $x $a))
;;    (ofc $depth 1 (: $x $a) (: id (-> $a $a))))

;; Backward via forward chaining
;; (: (obfc (-> Nat                        ; Maximum depth
;;              $b                         ; Query
;;              $b)))
(= (obfc $depth (: $x $a))
   (ofc $depth (S Z) (: $x $a) (: id (-> $a $a))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;; ;;
;; ;; Knowledge Bases ;; ;;
;; ;;;;;;;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;
;; Empty KB ;;
;;;;;;;;;;;;;;

;; Empty KB.  Convenient to limit the search to lambda expressions and
;; nothing else
!(bind! ∅-kb (new-space))

;;;;;;;;;;;;;;;;;;;;;
;; Modus Ponens KB ;;
;;;;;;;;;;;;;;;;;;;;;

;; KB with nothing but Modus Ponens
!(bind! &mp-kb (new-space))

;; Modus ponens (curried representation)
!(add-atom &mp-kb (: mp (-> (→ $a $b)
                            (-> $a
                                $b))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Propositional Calculus KB ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; KB with propositional calculus rules and axioms
!(bind! &pc-kb (new-space))

;; Modus ponens (curried representation)
!(add-atom &pc-kb (: mp (-> (→ $a $b)
                            (-> $a
                                $b))))

;; Axiom of the principle of simplification
!(add-atom &pc-kb (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))

;; Axiom of Frege
!(add-atom &pc-kb (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))

;; Axiom of the principle of transposition
!(add-atom &pc-kb (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))

;;;;;;;;;;;;;;;;
;; General KB ;;
;;;;;;;;;;;;;;;;

;; KB with Modus Ponens and a few combinators
!(bind! &gen-kb (new-space))

;; Modus ponens (curried representation)
!(add-atom &gen-kb (: mp (-> (→ $a $b)
                             (-> $a
                                 $b))))

;; Bluebird
!(add-atom &gen-kb (: . (-> (-> $b $c)
                            (-> (-> $a $b)
                                (-> $a
                                    $c)))))

;; Blackbird
!(add-atom &gen-kb (: .: (-> (-> $c $d)
                             (-> (-> $a (-> $b $c))
                                 (-> $a
                                     (-> $b
                                         $d))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Specialized KB for Breadth-first Search ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; KB with rules specialized for breadth-first search of propositional calculus
!(bind! &bfs-kb (new-space))

;; Bluebird
!(add-atom &bfs-kb (: . (-> (-> $b $c)
                            (-> (-> $a $b)
                                (-> $a
                                    $c)))))

;; Blackbird specialized for mp
;; .:mp = (λ z ((.: z) mp))
!(add-atom &bfs-kb (: .:mp (-> (-> $b $c)
                               (-> (→ $a $b)
                                   (-> $a
                                       $c)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Specialized KB for Depth-first Search ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; KB with rules specialized for breadth-first search of propositional calculus
!(bind! &dfs-kb (new-space))

;; Axiom of the principle of simplification
!(add-atom &dfs-kb (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))

;; Axiom of Frege
!(add-atom &dfs-kb (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))

;; Axiom of the principle of transposition
!(add-atom &dfs-kb (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))

;; Blackbird specialized for mp
;; .:mp = (λ z ((.: z) mp))
!(add-atom &dfs-kb (: .:mp (-> (-> $b $c)
                               (-> (→ $a $b)
                                   (-> $a
                                       $c)))))

;;;;;;;;;;;;;;;;
;; ;;;;;;;;;; ;;
;; ;; Main ;; ;;
;; ;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;
;; Test Empty KB ;;
;;;;;;;;;;;;;;;;;;;

;; ;; Rediscover bluebird and nothing else
;; !(test
;;   (λbc &∅-kb Nil z (fromNumber 5) (: $x (-> (-> b c)
;;                                             (-> (-> a b)
;;                                                 (-> a
;;                                                     c)))))
;;   (: (λ z (λ (s z) (λ (s (s z)) (z ((s z) (s (s z)))))))
;;      (-> (-> b c) (-> (-> a b) (-> a c)))))

;; ;; Rediscover blackbird and nothing else
;; ;; !(test
;; !(once (λbc &∅-kb Nil z (fromNumber 6) (: $x (-> (-> c d)
;;                                                  (-> (-> a (-> b c))
;;                                                      (-> a
;;                                                          (-> b
;;                                                              d)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Modus Ponens KB ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Rediscover .:mp and nothing else
;; ;; !(test
;; !(λbc &mp-kb Nil z (fromNumber 6) (: (λ z $x) (-> (-> b c) (-> (→ a b) (-> a c)))))
;;   ;; (: (λ z ((.: z) mp)) (-> (-> $b $c) (-> (→ $a $b) (-> $a $c)))))

;;;;;;;;;;;;;;;;;;;;;
;; Test General KB ;;
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Specialized KB for Breadth-first ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Replace first argument by modus ponens
;; !(test
;;   (bc &bfs-kb (fromNumber 0)
;;       (: .:mp (-> (-> $b $c)
;;                   (-> (→ $a $b) (-> $a $c)))))
;;   (: .:mp (-> (-> $b $c)
;;               (-> (→ $a $b) (-> $a $c)))))

;; ;; Replace second argument by modus ponens
;; !(test
;;   (bc &bfs-kb (fromNumber 1)
;;       (: (. .:mp) (-> (-> $a (-> $c $d))
;;                       (-> $a (-> (→ $b $c) (-> $b $d))))))
;;   (: (. .:mp) (-> (-> $a (-> $c $d))
;;                   (-> $a (-> (→ $b $c) (-> $b $d))))))

;; ;; Replace third argument by modus ponens
;; !(test
;;   (bc &bfs-kb (fromNumber 2)
;;       (: (. (. .:mp))
;;          (-> (-> $a (-> $b (-> $d $e)))
;;              (-> $a (-> $b (-> (→ $c $d) (-> $c $e)))))))
;;   (: (. (. .:mp))
;;      (-> (-> $a (-> $b (-> $d $e)))
;;          (-> $a (-> $b (-> (→ $c $d) (-> $c $e)))))))

;; NEXT: write reduction rules to turn composition into application.

;; NEXT: for breadth-first search, prune search by only allowing inner
;;       to outer.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test forward chainer on expansion rules ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Expansion meta-theory (bluebird) to produce backward expansion rules
!(bind &emt (new-space))
!(add-atom &emt (: . (-> (-> $b $c)
                        (-> (-> $a $b)
                            (-> $a
                                $c)))))

;; NEXT: add missing solutions
;; ;; Test one step forward chainer
;; !(test
;;   (fc-step &emt
;;            (: .:mp (-> (-> $b $c) (-> (→ $a $b) (-> $a $c)))))
;;   (: (. .:mp) (-> (-> $a (-> $c $d)) (-> $a (-> (→ $b $c) (-> $b $d))))))

;; ;; Test forward chainer at depth 1
;; !(test
;;   (collapse (fc &emt (fromNumber 1)
;;                 (: .:mp (-> (-> $b $c) (-> (→ $a $b) (-> $a $c))))))
;;   ((: .:mp (-> (-> $b $c) (-> (→ $a $b) (-> $a $c))))
;;    (: (. .:mp) (-> (-> $a' (-> $c' $d')) (-> $a' (-> (→ $b' $c') (-> $b' $d')))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test forward chainer on backward expansion ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Backward expansion theory
!(bind &bet (new-space))

;; Populate backward expansion theory using the expansion meta-theory
!(let $res (fc &emt (fromNumber 10)
               (: .:mp (-> (-> $b $c) (-> (→ $a $b) (-> $a $c)))))
   (add-atom &bet $res))

;; Expand backward theorem (→ 𝜑 𝜑)

;; Looking for something like
;; (: (λ x y z w (ax-mp x (ax-mp (ax-mp y z) w))) (-> $a $b $c $d (→ 𝜑 𝜑)))
;; !(fc &bet (fromNumber 7) (: ax-mp (-> (→ $a (→ 𝜑 𝜑)) (-> $a (→ 𝜑 𝜑)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test regular backward chaing ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; id
;; !(once (bc &pc-kb (fromNumber 4) (: $x (→ 𝜑 𝜑))))

;; ;; pm2.43
;; !(once (bc &pc-kb (fromNumber 4) (: $x (→ (→ 𝜑 (→ 𝜑 𝜓)) (→ 𝜑 𝜓)))))

;; ;; 2a1
;; !(once (bc &pc-kb (fromNumber 5) (: $x (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜑))))))

;; ;; imim2
;; !(once (bc &pc-kb (fromNumber 5) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜑) (→ 𝜒 𝜓))))))

;; ;; jarr
;; !(once (bc &pc-kb (fromNumber 6) (: $x (→ (→ (→ 𝜑 𝜓) 𝜒) (→ 𝜓 𝜒)))))

;; ;; loowoz
;; !(once (bc &pc-kb (fromNumber 7) (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ (→ 𝜓 𝜑) (→ 𝜓 𝜒))))))

;; ;; pm2.27
;; !(once (bc &pc-kb (fromNumber 7) (: $x (→ 𝜑 (→ (→ 𝜑 𝜓) 𝜓)))))

;; NEXT: determine depths

;; ;; imim1
;; !(once (bc &pc-kb (fromNumber 7) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜒))))))

;; ;; pm2.83
;; !(once (bc &pc-kb (fromNumber 7) (: $x (→ (→ 𝜑 (→ 𝜓 𝜒)) (→ (→ 𝜑 (→ 𝜒 𝜃)) (→ 𝜑 (→ 𝜓 𝜃)))))))

;; ;; peirceroll
;; !(once (bc &pc-kb (fromNumber 7) (: $x (→ (→ (→ (→ 𝜑 𝜓) 𝜑) 𝜑) (→ (→ (→ 𝜑 𝜓) 𝜒) (→ (→ 𝜒 𝜑) 𝜑))))))

;; ;; imim12
;; !(once (bc &pc-kb (fromNumber 7) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜃) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜃)))))))

;; ;; pm2.86
;; !(once (bc &pc-kb (fromNumber 7) (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ 𝜑 (→ 𝜓 𝜒))))))

;; ;; loolin
;; !(once (bc &pc-kb (fromNumber 7) (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜓 𝜑)) (→ 𝜓 𝜑)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test depth-first search backward chaining via forward chaining ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; NEXT: find out how to have bfc and sbc explore the same space

;; ;; Exhausively generate all proofs of certain sizes
;; !(bfc &dfs-kb (fromNumber 1) (: $x $a))
;; !(bfc &dfs-kb (fromNumber 2) (: $x $a))
;; !(bfc &dfs-kb (fromNumber 3) (: $x $a))
;; !(bfc &dfs-kb (fromNumber 4) (: $x $a))
;; !(bfc &dfs-kb (fromNumber 5) (: $x $a))
;; !(bfc &dfs-kb (fromNumber 6) (: $x $a))
;; !(bfc &dfs-kb (fromNumber 7) (: $x $a))
;; !(bfc &dfs-kb (fromNumber 8) (: $x $a))
;; !(bfc &dfs-kb (fromNumber 9) (: $x $a))
;; !(bfc &dfs-kb (fromNumber 10) (: $x $a))
;; !(bfc &dfs-kb (fromNumber 11) (: $x $a))
;; !(bfc &dfs-kb (fromNumber 12) (: $x $a))
;; !(bfc &dfs-kb (fromNumber 13) (: $x $a))

;; ;; id
;; !(bfc &dfs-kb (fromNumber 5) (: $x (→ 𝜑 𝜑)))

;; ;; pm2.43
;; !(bfc &dfs-kb (fromNumber 7) (: $x (→ (→ 𝜑 (→ 𝜑 𝜓)) (→ 𝜑 𝜓))))

;; ;; 2a1
;; !(bfc &dfs-kb (fromNumber 7) (: $x (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜑)))))

;; ;; imim2
;; !(bfc &dfs-kb (fromNumber 7) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜑) (→ 𝜒 𝜓)))))

;; ;; jarr
;; !(bfc &dfs-kb (fromNumber 13) (: $x (→ (→ (→ 𝜑 𝜓) 𝜒) (→ 𝜓 𝜒))))

;; ;; pm2.27
;; !(bfc &dfs-kb (fromNumber 13) (: $x (→ 𝜑 (→ (→ 𝜑 𝜓) 𝜓))))

;; ;; imim1
;; !(bfc &dfs-kb (fromNumber 15) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜒)))))

;; ;; loowoz (~3m)
;; !(bfc &dfs-kb (fromNumber 19) (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ (→ 𝜓 𝜑) (→ 𝜓 𝜒)))))

;; ;; imim12
;; !(bfc &dfs-kb (fromNumber 25) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜃) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜃))))))

;; ;; pm2.83
;; !(bfc &dfs-kb (fromNumber 25) (: $x (→ (→ 𝜑 (→ 𝜓 𝜒)) (→ (→ 𝜑 (→ 𝜒 𝜃)) (→ 𝜑 (→ 𝜓 𝜃))))))

;; ;; loolin
;; !(bfc &dfs-kb (fromNumber 26) (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜓 𝜑)) (→ 𝜓 𝜑))))

;; NEXT: determine depths

;; ;; peirceroll
;; !(bfc &dfs-kb (fromNumber 26) (: $x (→ (→ (→ (→ 𝜑 𝜓) 𝜑) 𝜑) (→ (→ (→ 𝜑 𝜓) 𝜒) (→ (→ 𝜒 𝜑) 𝜑)))))

;; ;; pm2.86
;; !(bfc &dfs-kb (fromNumber 26) (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ 𝜑 (→ 𝜓 𝜒)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test optimized depth-first search backward chaining via forward chaining ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Exhausively generate all proofs of certain sizes
;; !(obfc &dfs-kb (fromNumber 1) (: $x $a))
;; !(obfc &dfs-kb (fromNumber 2) (: $x $a))
;; !(obfc &dfs-kb (fromNumber 3) (: $x $a))
;; !(obfc &dfs-kb (fromNumber 4) (: $x $a))
;; !(obfc &dfs-kb (fromNumber 5) (: $x $a))
;; !(obfc &dfs-kb (fromNumber 6) (: $x $a))
;; !(obfc &dfs-kb (fromNumber 7) (: $x $a))
;; !(obfc &dfs-kb (fromNumber 8) (: $x $a))
;; !(obfc &dfs-kb (fromNumber 9) (: $x $a))
;; !(obfc &dfs-kb (fromNumber 10) (: $x $a))
;; !(obfc &dfs-kb (fromNumber 11) (: $x $a))
;; !(obfc &dfs-kb (fromNumber 12) (: $x $a))
;; !(obfc 13 (: $x $a))

;; ;; id
;; !(obfc &dfs-kb (fromNumber 5) (: $x (→ 𝜑 𝜑)))

;; ;; pm2.43
;; !(obfc &dfs-kb (fromNumber 7) (: $x (→ (→ 𝜑 (→ 𝜑 𝜓)) (→ 𝜑 𝜓))))

;; ;; 2a1
;; !(obfc &dfs-kb (fromNumber 7) (: $x (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜑)))))

;; ;; imim2
;; !(obfc &dfs-kb (fromNumber 7) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜑) (→ 𝜒 𝜓)))))

;; ;; jarr
;; !(obfc &dfs-kb 13 (: $x (→ (→ (→ 𝜑 𝜓) 𝜒) (→ 𝜓 𝜒))))

;; ;; pm2.27
;; !(obfc &dfs-kb (fromNumber 13) (: $x (→ 𝜑 (→ (→ 𝜑 𝜓) 𝜓))))

;; ;; imim1
;; !(obfc 15 (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜒)))))

;; ;; loowoz (~7s)
;; ;; !(obfc 19 (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ (→ 𝜓 𝜑) (→ 𝜓 𝜒)))))
;; !(obfc (fromNumber 19) (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ (→ 𝜓 𝜑) (→ 𝜓 𝜒)))))

;; ;; imim12
;; !(obfc &dfs-kb (fromNumber 25) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜃) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜃))))))

;; ;; pm2.83
;; !(obfc &dfs-kb (fromNumber 25) (: $x (→ (→ 𝜑 (→ 𝜓 𝜒)) (→ (→ 𝜑 (→ 𝜒 𝜃)) (→ 𝜑 (→ 𝜓 𝜃))))))

;; ;; loolin
;; !(obfc &dfs-kb (fromNumber 26) (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜓 𝜑)) (→ 𝜓 𝜑))))

;; NEXT: determine depths

;; ;; peirceroll
;; !(obfc &dfs-kb (fromNumber 26) (: $x (→ (→ (→ (→ 𝜑 𝜓) 𝜑) 𝜑) (→ (→ (→ 𝜑 𝜓) 𝜒) (→ (→ 𝜒 𝜑) 𝜑)))))

;; ;; pm2.86
;; !(obfc &dfs-kb (fromNumber 26) (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ 𝜑 (→ 𝜓 𝜒)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test proof-sized bound backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Exhausively generate all proofs of certain sizes
;; !(sbc (fromNumber 1) (: $x $a))
;; !(sbc (fromNumber 2) (: $x $a))
;; !(sbc (fromNumber 3) (: $x $a))
;; !(sbc (fromNumber 4) (: $x $a))
;; !(sbc (fromNumber 5) (: $x $a))
;; !(sbc (fromNumber 6) (: $x $a))
;; !(sbc (fromNumber 7) (: $x $a))
;; !(sbc (fromNumber 8) (: $x $a))
;; !(sbc (fromNumber 9) (: $x $a))
;; !(sbc (fromNumber 10) (: $x $a))
;; !(sbc (fromNumber 11) (: $x $a))
;; !(sbc (fromNumber 12) (: $x $a))
;; !(sbc (fromNumber 13) (: $x $a))

;; ;; id
;; !(sbc (fromNumber 5) (: $x (→ 𝜑 𝜑)))

;; ;; pm2.43
;; !(sbc (fromNumber 7) (: $x (→ (→ 𝜑 (→ 𝜑 𝜓)) (→ 𝜑 𝜓))))

;; ;; 2a1
;; !(sbc (fromNumber 7) (: $x (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜑)))))

;; ;; imim2
;; !(sbc (fromNumber 7) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜑) (→ 𝜒 𝜓)))))

;; ;; jarr
;; !(sbc (fromNumber 13) (: $x (→ (→ (→ 𝜑 𝜓) 𝜒) (→ 𝜓 𝜒))))

;; ;; pm2.27
;; !(sbc (fromNumber 13) (: $x (→ 𝜑 (→ (→ 𝜑 𝜓) 𝜓))))

;; ;; imim1
;; !(sbc (fromNumber 15) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜒)))))

;; ;; loowoz (~1h)
;; !(sbc (fromNumber 19) (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ (→ 𝜓 𝜑) (→ 𝜓 𝜒)))))

;; ;; imim12
;; !(sbc (fromNumber 25) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜃) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜃))))))

;; ;; pm2.83
;; !(sbc (fromNumber 25) (: $x (→ (→ 𝜑 (→ 𝜓 𝜒)) (→ (→ 𝜑 (→ 𝜒 𝜃)) (→ 𝜑 (→ 𝜓 𝜃))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test proof-sized bound optimized backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Exhausively generate all proofs of certain sizes
;; !(obc 1 (: $x $a))
;; !(obc 2 (: $x $a))
;; !(obc 3 (: $x $a))
;; !(obc 4 (: $x $a))
;; !(obc 5 (: $x $a))
;; !(obc 6 (: $x $a))
;; !(obc 7 (: $x $a))
;; !(obc 8 (: $x $a))
;; !(obc 9 (: $x $a))
;; !(obc 10 (: $x $a))
;; !(obc 11 (: $x $a))
;; !(obc 12 (: $x $a))
;; !(obc 13 (: $x $a))

;; ;; id
;; !(obc 5 (: $x (→ 𝜑 𝜑)))

;; ;; pm2.43
;; !(obc 7 (: $x (→ (→ 𝜑 (→ 𝜑 𝜓)) (→ 𝜑 𝜓))))

;; ;; 2a1
;; !(obc 7 (: $x (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜑)))))

;; ;; imim2
;; !(obc 7 (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜑) (→ 𝜒 𝜓)))))

;; ;; jarr
;; !(obc 13 (: $x (→ (→ (→ 𝜑 𝜓) 𝜒) (→ 𝜓 𝜒))))

;; ;; pm2.27
;; !(obc 13 (: $x (→ 𝜑 (→ (→ 𝜑 𝜓) 𝜓))))

;; ;; imim1
;; !(obc 15 (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜒)))))

;; ;; loowoz (~3s)
;; !(obc 19 (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ (→ 𝜓 𝜑) (→ 𝜓 𝜒)))))

;; ;; imim12
;; !(obc 25 (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜃) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜃))))))

;; ;; pm2.83
;; !(obc 25 (: $x (→ (→ 𝜑 (→ 𝜓 𝜒)) (→ (→ 𝜑 (→ 𝜒 𝜃)) (→ 𝜑 (→ 𝜓 𝜃))))))

;; ;; loolin (~15m)
;; !(obc 26 (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜓 𝜑)) (→ 𝜓 𝜑))))

;; NEXT: determine depths

;; ;; peirceroll
;; !(obc 28 (: $x (→ (→ (→ (→ 𝜑 𝜓) 𝜑) 𝜑) (→ (→ (→ 𝜑 𝜓) 𝜒) (→ (→ 𝜒 𝜑) 𝜑)))))

;; ;; pm2.86
;; !(obc 28 (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ 𝜑 (→ 𝜓 𝜒)))))
