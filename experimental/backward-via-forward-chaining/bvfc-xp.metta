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

;; ;;;;;;;;;;;;;;;;;;;
;; ;; Curry/Uncurry ;;
;; ;;;;;;;;;;;;;;;;;;;

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

;; Curried backward chainer with lambda abstraction
(: bc (-> $a                            ; Knowledge base space
          $b                            ; Environment
          DeBruijn                      ; De Bruijn Index
          Nat                           ; Maximum depth
          $c                            ; Query
          $c))                          ; Result

;; Base cases
(= (bc $kb $env $idx $_ (: $x $a))
   (match $kb (: $x $a) (: $x $a)))
(= (bc $kb $env $idx $_ (: $x $a))
   (match' $env (: $x $a) (: $x $a)))

;; Recursive steps

;; Proof application
(= (bc $kb $env $idx (S $k) (: ($f $x) $b))
   ;; (trace! (👁 bc-app $kb $env $idx (S $k) (: ($f $x) $b))
   (let* (((: $f (-> $a $b)) (bc $kb $env $idx $k (: $f (-> $a $b))))
          ((: $x $a) (bc $kb $env $idx $k (: $x $a))))
     (: ($f $x) $b)));)
;; ;; Proof abstraction
;; (= (bc $kb $env $x (S $k) (: (λ $x $y) (-> $a $b)))
;;    ;; (trace! (👁 bc-abs $kb $env $x (S $k) (: (λ $x $y) (-> $a $b)))
;;    (let (: $y $b)
;;      (bc $kb (Cons (: $x $a) $env) (s $x) $k (: $y $b))
;;      (: (λ $x $y) (-> $a $b))));)

;; Like above, but fully annotated
;; ;; Proof application (fully annotated)
;; (= (bc $kb $env $idx (S $k) (: ($f (: $x $a)) $b))
;;    (let* (((: $f (-> $a $b)) (bc $kb $env $idx $k (: $f (-> $a $b))))
;;           ((: $x $a) (bc $kb $env $idx $k (: $x $a))))
;;      (: ($f (: $x $a)) $b)))
;; ;; Proof abstraction (fully annotated)
;; (= (bc $kb $env $x (S $k) (: (λ (: $x $a) $y) (-> $a $b)))
;;    (let (: $y $b)
;;      (bc $kb (Cons (: $x $a) $env) (s $x) $k (: $y $b))
;;      (: (λ (: $x $a) $y) (-> $a $b))))

;;;;;;;;;;;;;;;;;;;;;
;; Forward Chainer ;;
;;;;;;;;;;;;;;;;;;;;;

;; Apply one forward chaining step by applying each rule in the rule
;; base space, $rb, to the argument (: $x $a).
(: fc-step (-> $a $b $c))
;; Unary application given argument
(= (fc-step $rb (: $x $a)) (match $rb (: $f (-> $a $b)) (: ($f $x) $b)))
;; Unary application given abstraction
(= (fc-step $rb (: $f (-> $a $b))) (match $rb (: $x $a) (: ($f $x) $b)))

;; Iteratively apply forward chaining growing the results at each
;; iteration.
;; (: fc (-> $a Nat $b $b))
(= (fc $rb $depth (: $x $a)) (: $x $a))
(= (fc $rb (S $k) (: $x $a)) (fc $rb $k (fc-step $rb (: $x $a))))

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
;;   (bc &∅-kb Nil z (fromNumber 5) (: $x (-> (-> b c)
;;                                            (-> (-> a b)
;;                                                (-> a
;;                                                    c)))))
;;   (: (λ z (λ (s z) (λ (s (s z)) (z ((s z) (s (s z)))))))
;;      (-> (-> b c) (-> (-> a b) (-> a c)))))

;; ;; Rediscover blackbird and nothing else
;; ;; !(test
;; !(once (bc &∅-kb Nil z (fromNumber 6) (: $x (-> (-> c d)
;;                                                 (-> (-> a (-> b c))
;;                                                     (-> a
;;                                                         (-> b
;;                                                             d)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Modus Ponens KB ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Rediscover .:mp and nothing else
;; ;; !(test
;; !(bc &mp-kb Nil z (fromNumber 6) (: (λ z $x) (-> (-> b c) (-> (→ a b) (-> a c)))))
;;   ;; (: (λ z ((.: z) mp)) (-> (-> $b $c) (-> (→ $a $b) (-> $a $c)))))

;;;;;;;;;;;;;;;;;;;;;
;; Test General KB ;;
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Specialized KB for Breadth-first ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Replace first argument by modus ponens
!(test
  (bc &bfs-kb Nil z (fromNumber 0)
      (: .:mp (-> (-> $b $c)
                  (-> (→ $a $b) (-> $a $c)))))
  (: .:mp (-> (-> $b $c)
              (-> (→ $a $b) (-> $a $c)))))

;; Replace second argument by modus ponens
!(test
  (bc &bfs-kb Nil z (fromNumber 1)
      (: (. .:mp) (-> (-> $a (-> $c $d))
                      (-> $a (-> (→ $b $c) (-> $b $d))))))
  (: (. .:mp) (-> (-> $a (-> $c $d))
                  (-> $a (-> (→ $b $c) (-> $b $d))))))

;; Replace third argument by modus ponens
!(test
  (bc &bfs-kb Nil z (fromNumber 2)
      (: (. (. .:mp))
         (-> (-> $a (-> $b (-> $d $e)))
             (-> $a (-> $b (-> (→ $c $d) (-> $c $e)))))))
  (: (. (. .:mp))
     (-> (-> $a (-> $b (-> $d $e)))
         (-> $a (-> $b (-> (→ $c $d) (-> $c $e)))))))

;; NEXT: write reduction rules to turn composition into application.

;; NEXT: prune search by only allowing inner to outer.

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
!(let $res (fc &emt
               (: .:mp (-> (-> $b $c) (-> (→ $a $b) (-> $a $c))))
               (fromNumber 10))
   (add-atom &bet $res))

;; Expand backward theorem (→ 𝜑 𝜑)

;; Looking for something like
;; (: (λ x y z w (ax-mp x (ax-mp (ax-mp y z) w))) (-> $a $b $c $d (→ 𝜑 𝜑)))
;; !(fc &bet (: ax-mp (-> (→ $a (→ 𝜑 𝜑)) (-> $a (→ 𝜑 𝜑)))) (fromNumber 7))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test depth-first search backward chaining via forward chaining ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; NEXT
