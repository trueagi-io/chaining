;; Experiment to verify or rediscover proofs of the propositional
;; calculus fragment of set theory of Metamath.

;; NEXT: discover more reduction rules (maybe automate the discovery process)

;; NEXT: see if disabling type definitions speed things up.

;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;; ;;
;; ;; Parameters ;; ;;
;; ;;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Experiment Parameters ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Process assertions up to the provided index (excluded).  The
;; default is 1526 because the full corpus contains 1525 assertions.
;;
;; It is set to 95 because the 95 theorem is too slow proof.
(= (up-to-idx) 95)

;;;;;;;;;;;;;;;;;;;;;;;
;; Search Parameters ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Whether to reverse the order of arguments.  For instance
;;
;; (: ax-mp (-> $𝜑 (→ $𝜑 $𝜓) $𝜓))
;;
;; becomes
;;
;; (: ax-mp (-> (→ $𝜑 $𝜓) $𝜑 $𝜓))
;;
;; This can speed up the proof search because in the reversed order,
;; the first arguments tend to be more constrained than the lastest
;; ones, which can have the effect of pruning earlier the search.
;;
;; Indeed, early results confirm that.  Reversing the arguments allows
;; to rediscover the first proofs (up to index 50 excluded) in 9.144s,
;; instead of 6m47.418s if not reversed.
(= (reverse-arguments) True)

;; Re-discover proofs.  If it is True then the proofs are attempted to
;; be re-discovered instead of merely being checked.
(= (search-proof) True)

;; For each theorem, search for all possible proofs.  Otherwise, stop
;; at the first one.
(= (search-all-proofs) False)

;; Bound search by proof size instead of proof depth.
(= (bound-search-by-proof-size) True)

;; Use proof reduction as pruning mechanism duing search
(= (prune-reduct) True)

;;;;;;;;;;;;;;;;;;;;;;;
;; Logger Parameters ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Log level
(= (log-level) info)

;; Log file path
(= (log-filepath) "pc-xp.log")

;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;; ;;
;; ;; Imports ;; ;;
;; ;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;

;; Import logger library
!(import! &self (library lib_import))
!(git-import! "https://github.com/ngeiswei/petta_lib_logger")
!(import! &self (library lib_logger))

;; Import the propositional calculus corpus in the format
;; (MkIndexed INDEX (MkAxiom LABEL AXIOM))
;; (MkIndexed INDEX (MkTheorem LABEL PROOF THEOREM))
!(if (reverse-arguments)
     (import! &pc-idxd propositional-calculus-reversed-arguments)
     (import! &pc-idxd propositional-calculus))

;;;;;;;;;;;;;;;;;;;;;;
;; Configure Logger ;;
;;;;;;;;;;;;;;;;;;;;;;

!(logger-set-level (log-level))
!(logger-set-filepath (log-filepath))

;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;; ;;
;; ;; Functions ;; ;;
;; ;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;
;; Concat ;;
;;;;;;;;;;;;

;; Concat atoms.  The implementation uses union-atom and assumes that
;; it preserves order.
(= (concat-atom $x $y) (union-atom $x $y))

;;;;;;;;;;
;; When ;;
;;;;;;;;;;

;; Binary conditional.  Only execute branch if condition is True
(: when (-> Bool Atom $a))
(= (when $c $x) (if $c $x (empty)))

;;;;;;;;;;;
;; Sized ;;
;;;;;;;;;;;

;; Associate a size to a term
(: Sized (-> $a Type))
(: MkSized (-> $n                       ; Size
               $a                       ; Object
               (Sized $a)))             ; Sized object

;; Access functions
(= (Sized.size (MkSized $s $x)) $s)
(= (Sized.object (MkSized $s $x)) $x)

;;;;;;;;;;;;;;;
;; Assertion ;;
;;;;;;;;;;;;;;;

;; Assertion, either axiom or theorem
(: Assertion Type)
(: MkAxiom (-> Symbol ; Label
               Atom   ; Axiom
               Assertion))
(: MkTheorem (-> Symbol ; Label
                 Atom   ; Proof
                 Atom   ; Theorem
                 Assertion))

;; Indexed assertion
(: Indexed Type)
(: MkIndexed (-> Number    ; Index
                 Assertion ; Axiom or Theorem
                 Indexed))

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

;; Implement monad interface for return
(: Maybe.return (-> $a (Maybe $a)))
(= (Maybe.return $x) (Just $x))

;; Implement monad interface for bind
(: Maybe.bind (-> (Maybe $a) (-> $a (Maybe $b)) (Maybe $b)))
(= (Maybe.bind Nothing $f) Nothing)
(= (Maybe.bind (Just $x) $f) ($f $x))

;; Test Maybe
(: Maybe.test.foo (-> Number (Maybe String)))
(= (Maybe.test.foo $x) (if (== $x 42) (Just "42") Nothing))
!(test
  (Maybe.bind Nothing Maybe.test.foo)
  Nothing)
!(test
  (Maybe.bind (Just 0) Maybe.test.foo)
  Nothing)
!(test
  (Maybe.bind (Just 42) Maybe.test.foo)
  (Just "42"))

;;;;;;;;;;;;
;; Syntax ;;
;;;;;;;;;;;;

;; Return True iff the given term is an expression
(: is-expression (-> $a Bool))
(= (is-expression $x) (== (get-metatype $x) Expression))

;; Test is-expression
!(test
  (is-expression id)
  False)

;; Return True iff the given term is a lambda abstraction, meaning an
;; expression of the form (λ VARIABLES BODY)
;;
;; NEXT: simplify once issue
;; https://github.com/trueagi-io/PeTTa/issues/182 has been
;; solved.
(: is-lambda (-> $a Bool))
(= (is-lambda $x)
   (if (is-expression $x)
       (if (== () $x)
           False
           (== λ (car-atom $x)))
       False))

;; Test is-lambda
!(test
  (is-lambda A)
  False)
!(test
  (is-lambda (A B))
  False)
!(test
  (is-lambda (λ $x $y))
  True)

;; Return True iff the given term is an arrow type, meaning has the
;; following format (-> A), (-> A B), (-> A B C), etc.
;;
;; NEXT: simplify once issue
;; https://github.com/trueagi-io/PeTTa/issues/182 has been
;; solved.
(: is-arrow (-> Atom Bool))
(= (is-arrow $x)
   (if (is-expression $x)
       (if (== () $x)
           False
           (== -> (car-atom $x)))
       False))

;; Test is-arrow
!(test
  (is-arrow A)
  False)
!(test
  (is-arrow (F A B))
  False)
!(test
  (is-arrow (-> $a $b))
  True)

;; Return True iff the given term is a product, meaning an expression
;; of the form (, FIRST SECOND)
;;
;; NEXT: simplify once issue
;; https://github.com/trueagi-io/PeTTa/issues/182 has been
;; solved.
(: is-product (-> $a Bool))
(= (is-product $x)
   (if (is-expression $x)
       (if (== () $x)
           False
           (== , (car-atom $x)))
       False))

;; Test is-lambda
!(test
  (is-product A)
  False)
!(test
  (is-product (A B))
  False)
!(test
  (is-product (, A B))
  True)

;; Drop last element of a tuple
(= (drop-last $xs)
   (if (is-expression $xs)
       (if (== $xs ())
           (empty)
           (if (== (length $xs) 1)
               ()
               (let* ((($head $tail) (decons-atom $xs))
                      ($dlt (drop-last $tail)))
                 (cons-atom $head $dlt))))
       (empty)))

;; Test drop-last
!(test
  (drop-last (A))
  ())
!(test
  (drop-last (A B))
  (A))
!(test
  (drop-last (A B C))
  (A B))

;; Take last element of a tuple
(= (take-last $xs)
   (if (is-expression $xs)
       (if (== $xs ())
           (empty)
           (if (== (length $xs) 1)
               (car-atom $xs)
               (take-last (cdr-atom $xs))))
       (empty)))

;; Test take-last
!(test
  (take-last (A))
  A)
!(test
  (take-last (A B))
  B)

;; Get lambda variables.  Prune if not a lambda term.
(= (get-lambda-variables $term)
   (if (is-lambda $term)
       (let ($h $t) (decons-atom $term)
            (drop-last $t))
       (empty)))

;; Test get-lambda-variables
!(test
  (collapse (get-lambda-variables A))
  ())
!(test
  (get-lambda-variables (λ $x $y))
  ($x))
!(test
  (get-lambda-variables (λ $x1 $x2 $y))
  ($x1 $x2))

;; Get lambda body.  Prune if not a lambda term.
(= (get-lambda-body $term)
   (if (is-lambda $term)
       (take-last $term)
       (empty)))

;; Test get-lambda-body
!(test
  (collapse (get-lambda-body A))
  ())
!(test
  (get-lambda-body (λ $x A))
  A)
!(test
  (get-lambda-body (λ $x1 $x2 A))
  A)

;; Get arrow premises.  Prune if not an arrow.
(= (get-arrow-premises $term)
   (if (is-arrow $term)
       (let ($h $t) (decons-atom $term)
            (drop-last $t))
       (empty)))

;; Test get-lambda-variables
!(test
  (collapse (get-arrow-premises A))
  ())
!(test
  (get-arrow-premises (-> A B))
  (A))
!(test
  (get-arrow-premises (-> A B C))
  (A B))

;; Get lambda body.  Prune if not a lambda term.
(= (get-arrow-conclusion $term)
   (if (is-arrow $term)
       (take-last $term)
       (empty)))

;; Test get-lambda-body
!(test
  (collapse (get-arrow-conclusion A))
  ())
!(test
  (get-arrow-conclusion (-> A B))
  B)
!(test
  (get-arrow-conclusion (-> A B C))
  C)

;;;;;;;;;
;; Zip ;;
;;;;;;;;;

;; Zip two tuples with a given function.  It is assumed that both $xs
;; and $ys have the same length.
(= (zip-with $f $xs $ys)
   (if (== $xs ())
       ()
       (let* ((($xh $xt) (decons-atom $xs))
              (($yh $yt) (decons-atom $ys))
              ($zh ($f $xh $yh))
              ($zt (zip-with $f $xt $yt)))
         (cons-atom $zh $zt))))

;; Test zip-with
!(test
  (zip-with : () ())
  ())
!(test
  (zip-with : (x) (a))
  ((: x a)))
!(test
  (zip-with : (x y) (a b))
  ((: x a) (: y b)))

;;;;;;;;;;;;;;;;;;;;;;
;; Match over tuple ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Match pattern over a tuple of elements
(= (match' $tuple $ptrn $tmpl) (let $ptrn (superpose $tuple) $tmpl))

;; Test match' on empty tuple
!(test
  (collapse (match' () ($x $y) ($y $x)))
  ())

;; Test match' on singleton
!(test
  (collapse (match' ((A B)) ($x $y) ($y $x)))
  ((B A)))

;; Test match' on pair
!(test
  (collapse (match' ((A B) (C D)) ($x $y) ($y $x)))
  ((B A)
   (D C)))

;;;;;;;;;
;; Get ;;
;;;;;;;;;

;; Specialized match where the pattern is equal to the template
(= (get $spc $ptrn) (match $spc $ptrn $ptrn))

;; Specialized match' where the pattern is equal to the template
(= (get' $spc $ptrn) (match' $spc $ptrn $ptrn))

;;;;;;;;;;
;; Fold ;;
;;;;;;;;;;

;; Fold a tuple from right to left
;; (: foldr (-> (-> $a $b $b) $b $c $d))  ; NEXT: re-enable when fixed
(= (foldr $f $i $xs)
   (if (== $xs ())
       $i
       (let* ((($h $t) (decons-atom $xs))
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
                   ($xs (let* ((($h $t) (decons-atom $xs))
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

;; Loop-like function ported from Haskell.  Iterate applying a given
;; function till some condition is reached.  You may want to make sure
;; that the predicate and the next function are deterministic,
;; otherwise the behavior of until might be a bit unpredictable.
(: until (-> (-> $a Bool)               ; Predicate
             (-> $a $a)                 ; Next
             $a                         ; Initial value
             $a))                       ; Final value
(= (until $p $f $x)
   (if ($p $x) $x (until $p $f ($f $x))))

;; Test until
(: test.equal-to-10 (-> Number Bool))
(= (test.equal-to-10 $x) (== 10 $x))
!(test
  (until test.equal-to-10 succ 0)
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

;;;;;;;;;;;;;;;
;; Term size ;;
;;;;;;;;;;;;;;;

;; Return the size of a term, which correspond to the number symbols,
;; variables and grounded subterms in the given term.
(= (term-size $x)
   (if (is-expression $x)
       (if (== $x ())
           0
           (let ($head $tail) (decons-atom $x)
                (+ (term-size $head) (term-size $tail))))
       1))

;; Test term-size
!(test
  (term-size A)
  1)
!(test
  (term-size ((R A) $x))
  3)
!(test
  (term-size (R A (S B C)))
  5)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Replace body of lambda by variable ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Take a term representing a proof and replace its body by a variable
;; (as to be able to rediscover it).  If it is a lambda abstraction,
;; then replace the lambda term body by a variable, other replace the
;; whole term by a variable.
;; (: replace-body-by-variable (-> $a $a))
(= (replace-body-by-variable $prf)
   (case (get-metatype $prf)
     ((Symbol $y)
      (Grounded $y)
      (Variable $y)
      (Expression
       (if (== () $prf)
           $y
           (case $prf
             (;; Unary lambda abstraction
              ((λ $x $bdy)
               (λ $x $y))
              ;; Binary lambda abstraction
              ((λ $x1 $x2 $bdy)
               (λ $x1 $x2 $y))
              ;; Ternary lambda abstraction
              ((λ $x1 $x2 $x3 $bdy)
               (λ $x1 $x2 $x3 $y))
              ;; Quaternary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $bdy)
               (λ $x1 $x2 $x3 $x4 $y))
              ;; Quintenary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $x5 $bdy)
               (λ $x1 $x2 $x3 $x4 $x5 $y))
              ;; Senary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $x5 $x6 $bdy)
               (λ $x1 $x2 $x3 $x4 $x5 $x6 $y))
              ;; Septenary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $bdy)
               (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $y))
              ;; Octonary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $bdy)
               (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $y))
              ;; Nonary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $bdy)
               (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $y))
              ;; Denary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10 $bdy)
               (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10 $y))
              ;; Otherwise
              ($else $y))))))))

;; Test replace-body-by-variable
!(test
  (replace-body-by-variable (λ mpi.2 mpi.1 (mpd mpi.2 (a1i mpi.1))))
  (λ mpi.2 mpi.1 $bdy))
!(test
  (replace-body-by-variable (mpd ax-1 ax-1))
  $bdy)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Variable Introduction ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Replace a given symbol by a variable in a term.
(: replace-symbol-by-variable (-> Symbol $a $a))
(= (replace-symbol-by-variable $sym $term) (_replace-symbol-by-variable $sym $x $term))
(: _replace-symbol-by-variable (-> Symbol Variable $a $a))
(= (_replace-symbol-by-variable $sym $var $term)
   (case (get-metatype $term)
     ((Symbol (if (== $sym $term) $var $term))
      (Grounded $term)
      (Variable $term)
      (Expression (if (== $term ())
                      $term
                      (let* (;; Get head and tail of term
                             (($head $tail) (decons-atom $term))
                             ;; Recurs on head
                             ($nhd (_replace-symbol-by-variable $sym $var $head))
                             ;; Recurs on tail
                             ($ntl (_replace-symbol-by-variable $sym $var $tail)))
                        ;; Cons result
                        (cons-atom $nhd $ntl)))))))

;; Test replace-symbol-by-variable
!(test
  (replace-symbol-by-variable 𝜑 𝜑)
  $𝜑)
!(test
  (replace-symbol-by-variable 𝜑 (-> (→ 𝜑 (→ 𝜓 𝜒)) 𝜓 𝜑 𝜒))
  (-> (→ $𝜑 (→ 𝜓 𝜒)) 𝜓 $𝜑 𝜒))

;; Replace all greek letters by variables
(: replace-greeks-by-variables (-> $a $a))
(= (replace-greeks-by-variables $term)
   (foldr replace-symbol-by-variable $term (𝜑 𝜓 𝜒 𝜃 𝜏 𝜂 𝜁 𝜎 𝜌 𝜇 𝜆 𝜅)))

;; Test replace-greeks-by-variables
!(test
  (replace-greeks-by-variables 𝜑)
  $𝜑)
!(test
  (replace-greeks-by-variables (-> (→ 𝜑 (→ 𝜓 𝜒)) 𝜓 𝜑 𝜒))
  (-> (→ $𝜑 (→ $𝜓 $𝜒)) $𝜓 $𝜑 $𝜒))

;;;;;;;;;;;;;;;
;; Reduction ;;
;;;;;;;;;;;;;;;

;; Define space mapping proofs to label, with data of the form
;;
;; (Label PROOF LABEL)
!(bind! &labels (new-space))

;; Callback to be passed to the backward chainer.  It is called over
;; every result, intermediary included, that the backward chainer
;; finds.  For now it used as a reduction pruner, meaning that if the
;; result is recognized as reducible, then it is pruned.  For now only
;; reducing proof to its label is supported.  Meaning that only a
;; proof not associated to an existing label is allowed.  In other
;; words, instead of rediscovering the proof of an existing label, it
;; should re-use this label.
(: callback (-> $a $a))
(= (callback (: $x $a)) ; (: $x $a))
   (progn
    ;; (logger-tracef "Call: (callback %w)" ((: $x $a)))
    (if (prune-reduct)
        (case (once (match &labels (Label $x $y) $y))
          (($y (empty))
           (Empty (: $x $a))))
        (: $x $a))))

;; The code below is only kept for documentation or potential future
;; use as the reduction based prunning is handled by the callback
;; instead.

;; Reduce a proof to its label if any, or nothing otherwise.
;; (: reduce-to-label (-> $a (Maybe $a)))
(= (reduce-to-label $x)
   (case (once (match &labels (Label $x $y) $y))
     (($y (Just $y))
      (Empty Nothing))))

;; Apply any reduction rules till a fixed point is reached.  The input
;; is supposed to be closed, that is it does not contain free
;; variables.  Also, in applications such as (f a), f can be assumed
;; not to be reducible due to the lack of higher order rules in
;; propositional calculus.
;; (: reduce-proof (-> $a $a))
(= (reduce-proof $x)
   (if (is-expression $x)
       ;; Recursive steps
       (case $x
         (;; Nullary tuple
          (() ())
          ;; Unary application
          (($f $x1)
           (let $nx1 (reduce-proof $x1)
             (if (== $nx1 $x1)
                 ;; $x1 already reduced, attempt to reduce $x to label
                 (case (reduce-to-label $x)
                   (;; Reduced, return $y
                    ((Just $y) $y)
                    ;; Not reduced, return $x
                    (Nothing $x)))
                 ;; $x1 is reducible, reapply reduction
                 (reduce-proof ($f $nx1)))))
          ;; Binary application
          (($f $x1 $x2)
           (let* (($nx1 (reduce-proof $x1))
                  ($nx2 (reduce-proof $x2)))
             (if (and (== $nx1 $x1)
                      (== $nx2 $x2))
                 ;; $x1 and $x2 are already reduced, attempt to reduce
                 ;; $x to label
                 (case (reduce-to-label $x)
                   (;; Reduced, return $y
                    ((Just $y) $y)
                    ;; Not reduced, return $x
                    (Nothing $x)))
                 ;; $x1 and $x2 are reducible, reapply reduction
                 (reduce-proof ($f $nx1 $nx2)))))
          ;; Ternary application
          (($f $x1 $x2 $x3)
           (let* (($nx1 (reduce-proof $x1))
                  ($nx2 (reduce-proof $x2))
                  ($nx3 (reduce-proof $x3)))
             (if (and (== $nx1 $x1)
                      (and (== $nx2 $x2)
                           (== $nx3 $x3)))
                 ;; All arguments are already reduced, attempt to
                 ;; reduce $x to label
                 (case (reduce-to-label $x)
                   (;; Reduced, return $y
                    ((Just $y) $y)
                    ;; Not reduced, return $x
                    (Nothing $x)))
                 ;; Arguments are reducible, reapply reduction
                 (reduce-proof ($f $nx1 $nx2 $nx3)))))))
       ;; Base case
       (case (reduce-to-label $x)
         (;; Reduced, return $y
          ((Just $y) $y)
          ;; Not reduced, return $x
          (Nothing $x)))))

;; ;; Test reduce
;; !(add-atom &labels (Label (a1i id_) idd))
;; !(add-atom &labels (Label (mpd ax-1 ax-1) id_))
;; !(add-atom &labels (Label (3bitr2i bicom
;;                                    (bibi2i notnotb)
;;                                    notbi)
;;                           con2bi))
;; !(test
;;   (reduce-to-label ax-1)
;;   Nothing)
;; !(test
;;   (reduce-to-label (mpd ax-1 ax-1))
;;   (Just id_))
;; !(test
;;   (reduce-proof ax-1)
;;   ax-1)
;; !(test
;;   (reduce-proof id_)
;;   id_)
;; !(test
;;   (reduce-proof (a1i id_))
;;   idd)
;; !(test
;;   (reduce-proof (mpd ax-1 ax-1))
;;   id_)
;; !(test
;;   (reduce-proof (3bitr2i bicom (bibi2i notnotb) notbi))
;;   con2bi)

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Backward Chainer with support for lambda abstraction at the entry
;; point (no recursive search on lambda terms).  The knowledge is
;; decomposed into a rule base and an axiom base because we know we
;; never need to search both at the same time, only one or the other.
;;
;; The arguments of the backward chainer are:
;;
;; * Rule base: reference to a space containing rules in the format
;;
;; (: NAME (-> PREMISE1 ... CONCLUSION))
;;
;; * Axiom base: reference to a space containing axioms in the format
;;
;; (: NAME AXIOM)
;;
;; * Callback: function to be called everytime a result, final or
;;   intermediary is produced.  This function can be used to for
;;   instance store final and intermediary results, or acts as a
;;   filter (by returning (empty) when a condition is met, or any
;;   combinations thereof.
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

;; Entry point
(: bc (-> $a                            ; Rule base space
          $b                            ; Axiom base space
          (-> $c $c)                    ; Callback
          Nat                           ; Maximum depth
          $c                            ; Query
          $c))                          ; Result
(= (bc $rb $ab $cb $depth (: $prf $thrm))
   (progn
    (logger-tracef "Call (lambda): (bc %w %w %w %w (: %w %w))"
                   ($rb $ab $cb $depth $prf $thrm))
    (case $depth
      (;; Depth 0
       (Z (_bc $rb $ab $cb () Z (: $prf $thrm)))
       ;; Depth greater than 0 (consider lambda abstraction)
       ((S $k)
        (if (is-expression $prf)
            ;; Proof is an expression, check whether it is a lambda term
            (if (== () $prf)
                ;; Proof is empty and already fully defined
                (: $prf $thrm)
                ;; Proof is not empty
                (if (is-lambda $prf)
                    ;; Proof is a lambda term
                    (let* (;; Get variables, body, premises and conclusion
                           ($xs (get-lambda-variables $prf))
                           ($as (get-arrow-premises $thrm))
                           ($y (get-lambda-body $prf))
                           ($b (get-arrow-conclusion $thrm))
                           ;; Build environment
                           ($env (zip-with : $xs $as))
                           ;; Call _bc to proof conclusion given environment
                           ((: $y $b) (_bc $rb $ab $cb $env $k (: $y $b)))
                           ;; Reconstruct lambda term
                           ($prf (cons-atom λ (concat-atom $xs ($y))))
                           ;; Reconstruct arrow
                           ($thrm (cons-atom -> (concat-atom $as ($b)))))
                      ;; Output
                      (: $prf $thrm))
                    ;; Not a lambda term, merely call _bc
                    (_bc $rb $ab $cb () (S $k) (: $prf $thrm))))
            ;; Proof is not an expression, merely call _bc
            (_bc $rb $ab $cb () (S $k) (: $prf $thrm))))))))

;; Recursive search.  No support for lambda abstraction, but support
;; for environment, which is a tuple of typing relationships such as
;;
;;   ((: x 𝐁𝐨𝐨𝐥) (: y 𝐁𝐨𝐨𝐥))
;;
;; Also, the proof abstraction is only searched shallowly, at depth 0,
;; because they are no higher order inference rules anyway.
;; NEXT: re-enable when fixed
;; (: _bc (-> $a                            ; Rule base space
;;            $b                            ; Axiom base space
;;            (-> $d $d)                    ; Callback
;;            $c                            ; Environment
;;            Nat                           ; Maximum depth
;;            $d                            ; Query
;;            $d))                          ; Result

;; Base cases

;; Match the axiom base
(= (_bc $rb $ab $cb $env $k (: $x $a))
   (progn
    ;; (logger-tracef "Call (ab): (_bc %w %w %w %w %w (: %w %w))"
    ;;                ($rb $ab $cb $env $k $x $a))
    ($cb (get $ab (: $x $a)))))

;; Match the environment
(= (_bc $rb $ab $cb $env $k (: $x $a))
   (progn
    ;; (logger-tracef "Call (env): (_bc %w %w %w %w %w (: %w %w))"
    ;;                ($rb $ab $cb $env $k $x $a))
    ($cb (get' $env (: $x $a)))))

;; Recursive steps

;; Product.  It is used internally by proof application to iterate
;; over premises.  Due to being only used internally, we do not
;; account for its depth.  The product is associative but is assumed
;; here to only take right associative forms like (, x (, y z)).
;;
;; WARNING: decomposing multi-premise recursion using product makes a
;; more elegant code but it is also significantly, like 10x, slower.
(= (_bc_prod $rb $ab $cb $env $k (: (, $x $y) (, $a $b)))
   (progn
    ;; (logger-tracef "Call (prod): (_bc_prod %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env $k (: (, $x $y) (, $a $b))))
    (let* (;; Recurse on first component
           ((: $x $a) (_bc $rb $ab $cb $env $k (: $x $a)))
           ;; Recurse on second component
           ((: $y $b) (if (is-product $y)
                          (_bc_prod $rb $ab $cb $env $k (: $y $b))
                          (_bc $rb $ab $cb $env $k (: $y $b)))))
      (: (, $x $y) (, $a $b)))))

;; The following functions enumerates proof application patterns by
;; arity.  The duplication up to arity is necessary to obtain search
;; branches from the non-determinism.  Maybe it can be simplified
;; further but this would require to implement a macro that would
;; generate them.

;; Unary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x) $b))
   (progn
    ;; (logger-tracef "Call (app-1): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x) $b)))
    (let* (;; Query unary rule
           ((: $f (-> $a $b)) (get $rb (: $f (-> $a $b))))
           ;; Recurse on premise
           ((: $x $a) (_bc $rb $ab $cb $env $k (: $x $a))))
      ($cb (: ($f $x) $b)))))

;; Binary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2) $b))
   (progn
    ;; (logger-tracef "Call (app-2): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2) $b)))
    (let* (;; Query binary rule
           ((: $f (-> $a1 $a2 $b))
            (get $rb (: $f (-> $a1 $a2 $b))))
           ;; Recurse on premises
           ((: (, $x1 $x2) (, $a1 $a2))
            (_bc_prod $rb $ab $cb $env $k (: (, $x1 $x2) (, $a1 $a2)))))
      ($cb (: ($f $x1 $x2) $b)))))

;; Ternary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3) $b))
   (progn
    ;; (logger-tracef "Call (app-3): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3) $b)))
    (let* (;; Query ternary rule
           ((: $f (-> $a1 $a2 $a3 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 $x3)) (, $a1 (, $a2 $a3)))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 $x3)) (, $a1 (, $a2 $a3))))))
      ($cb (: ($f $x1 $x2 $x3) $b)))))

;; Quaternary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4) $b))
   (progn
    ;; (logger-tracef "Call (app-4): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4) $b)))
    (let* (;; Query quaternary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 $x4)))
               (, $a1 (, $a2 (, $a3 $a4))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 $x4)))
                         (, $a1 (, $a2 (, $a3 $a4)))))))
      ($cb (: ($f $x1 $x2 $x3 $x4) $b)))))

;; Quintenary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5) $b))
   (progn
    ;; (logger-tracef "Call (app-5): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5) $b)))
    (let* (;; Query quintenary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $a5 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 (, $x4 $x5))))
               (, $a1 (, $a2 (, $a3 (, $a4 $a5)))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 (, $x4 $x5))))
                         (, $a1 (, $a2 (, $a3 (, $a4 $a5))))))))
      ($cb (: ($f $x1 $x2 $x3 $x4 $x5) $b)))))

;; Senary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b))
   (progn
    ;; (logger-tracef "Call (app-6): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b)))
    (let* (;; Query senary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 $x6)))))
               (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 $a6))))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 $x6)))))
                         (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 $a6)))))))))
      ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b)))))

;; Septenary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b))
   (progn
    ;; (logger-tracef "Call (app-7): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b)))
    (let* (;; Query septenary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 $x7))))))
               (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 $a7)))))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 $x7))))))
                         (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 $a7))))))))))
      ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b)))))

;; Octonary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b))
   (progn
    ;; (logger-tracef "Call (app-8): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b)))
    (let* (;; Query octonary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 $x8)))))))
               (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 $a8))))))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 $x8)))))))
                         (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 $a8)))))))))))
      ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b)))))

;; Nonary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b))
   (progn
    ;; (logger-tracef "Call (app-9): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b)))
    (let* (;; Query nonary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 $x9))))))))
               (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 $a9)))))))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 $x9))))))))
                         (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 $a9))))))))))))
      ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b)))))

;; Denary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b))
   (progn
    ;; (logger-tracef "Call (app-10): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b)))
    (let* (;; Query denary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 $x9))))))))
               (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 $a9)))))))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 (, $x9 $x10)))))))))
                         (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 (, $a9 $a10)))))))))))))
      ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Optimized Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Like bc but uses proof size instead of depth.  Maybe "optimized" is
;; a misnomer but it has been observed to be much faster this way.

;; ;; Entry point
;; (: obc (-> $a                            ; Rule base space
;;            $b                            ; Axiom base space
;;            (-> $c $c)                    ; Callback
;;            Number                        ; Maximum proof size
;;            $c                            ; Query
;;            $c))                          ; Result
(= (obc $rb $ab $cb $mps (: $prf $thrm))
   (progn
    (logger-tracef "Call (lambda): (obc %w %w %w %w (: %w %w))"
                   ($rb $ab $cb $mps $prf $thrm))
    (if (< 0 $mps)
        (if (is-expression $prf)
            ;; Proof is an expression, check whether it is a lambda term
            (if (== () $prf)
                ;; Proof is empty and already fully defined
                (: $prf $thrm)
                ;; Proof is not empty
                (if (is-lambda $prf)
                    ;; Proof is a lambda term
                    (let* (;; Get variables, body, premises and conclusion
                           ($xs (get-lambda-variables $prf))
                           ($as (get-arrow-premises $thrm))
                           ($y (get-lambda-body $prf))
                           ($b (get-arrow-conclusion $thrm))
                           ;; Build environment
                           ($env (zip-with : $xs $as))
                           ;; Calculate maximum body size (decount λ
                           ;; and variables)
                           ($mbs (- $mps (+ (length $xs) 1)))
                           ;; Call _obc to proof conclusion given environment
                           ((MkSized $bdysize (: $y $b))
                            (_obc $rb $ab $cb $env $mbs (: $y $b)))
                           ;; Reconstruct lambda term
                           ($prf (cons-atom λ (concat-atom $xs ($y))))
                           ;; Reconstruct arrow
                           ($thrm (cons-atom -> (concat-atom $as ($b)))))
                      ;; Output
                      (: $prf $thrm))
                    ;; Not a lambda term, merely call _obc
                    (Sized.object (_obc $rb $ab $cb () $mps (: $prf $thrm)))))
            ;; Proof is not an expression, merely call _obc
            (Sized.object (_obc $rb $ab $cb () $mps (: $prf $thrm))))
        ;; If maximum proof size is 0, then no proof can possibly be found
        (empty))))

;; Like _bc but uses proof size instead of depth, and outputs a sized
;; (: PROOF THEOREM) result.
;;
;; NEXT: re-enable when fixed
;; (: _obc (-> $a                            ; Rule base space
;;             $b                            ; Axiom base space
;;             (-> $c $c)                    ; Callback
;;             (List $b)                     ; Environment
;;             Number                        ; Maximum proof size
;;             $c                            ; Query
;;             (Sized $c)))                  ; Result

;; Base cases

;; Match the axiom base
(= (_obc $rb $ab $cb $env $mps (: $x $a))
   (if (< 0 $mps)
       (progn
        ;; (logger-tracef "Call (ab): (_obc %w %w %w %w %w (: %w %w))"
        ;;                ($rb $ab $cb $env $mps $x $a))
        (MkSized 1 ($cb (get $ab (: $x $a)))))
       (empty)))

;; Match the environment
(= (_obc $rb $ab $cb $env $mps (: $x $a))
   (if (< 0 $mps)
       (progn
        ;; (logger-tracef "Call (env): (_obc %w %w %w %w %w (: %w %w))"
        ;;                ($rb $ab $cb $env $mps $x $a))
        (MkSized 1 ($cb (get' $env (: $x $a)))))
       (empty)))

;; Recursive steps

;; Product.  It is used internally by proof application to iterate
;; over premises.  Due to being only used internally, we do not
;; account for the size of the product itself `,`.  The product is
;; associative but is assumed here to only take right associative
;; forms like (, x (, y z)).
(= (_obc_prod $rb $ab $cb $env $mps (: (, $x $y) (, $a $b)))
   (progn
    ;; (logger-tracef "Call (prod): (_obc_prod %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env $mps (: (, $x $y) (, $a $b))))
    (let* (;; Recurse on first component
           ((MkSized $xps (: $x $a)) (_obc $rb $ab $cb $env $mps (: $x $a)))
           ;; Calculate remaining maximum size
           ($rms (- $mps $xps))
           ;; Recurse on second component
           ((MkSized $yps (: $y $b))
            (if (is-product $y)
                (_obc_prod $rb $ab $cb $env $rms (: $y $b))
                (_obc $rb $ab $cb $env $rms (: $y $b)))))
      ;; Output sized proof (sum up sizes of all subproofs)
      (MkSized (+ $xps $yps) (: (, $x $y) (, $a $b))))))

;; Unary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x) $b))
   (if (< 1 $mps)
       (progn
        ;; (logger-tracef "Call (app-1): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x) $b)))
        (let* (;; Query unary rule
               ((: $f (-> $a $b)) (get $rb (: $f (-> $a $b))))
               ;; Recurse on premise
               ((MkSized $xps (: $x $a))
                (_obc $rb $ab $cb $env (- $mps 1) (: $x $a))))
          ;; Output sized proof (size of proof of premise + rule)
          (MkSized (+ $xps 1) ($cb (: ($f $x) $b)))))
       (empty)))

;; Binary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2) $b))
   (if (< 2 $mps)
       (progn
        ;; (logger-tracef "Call (app-2): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2) $b)))
        (let* (;; Query binary rule
               ((: $f (-> $a1 $a2 $b)) (get $rb (: $f (-> $a1 $a2 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 $x2) (, $a1 $a2)))
                (_obc_prod $rb $ab $cb $env (- $mps 1) (: (, $x1 $x2) (, $a1 $a2)))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2) $b)))))
       (empty)))

;; Ternary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3) $b))
   (if (< 3 $mps)
       (progn
        ;; (logger-tracef "Call (app-3): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3) $b)))
        (let* (;; Query ternary rule
               ((: $f (-> $a1 $a2 $a3 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 $x3)) (, $a1 (, $a2 $a3))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 $x3)) (, $a1 (, $a2 $a3))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3) $b)))))
       (empty)))

;; Quaternary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4) $b))
   (if (< 4 $mps)
       (progn
        ;; (logger-tracef "Call (app-4): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4) $b)))
        (let* (;; Query quaternary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 $x4)))
                                 (, $a1 (, $a2 (, $a3 $a4)))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 $x4)))
                              (, $a1 (, $a2 (, $a3 $a4)))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4) $b)))))
       (empty)))

;; Quintenary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5) $b))
   (if (< 5 $mps)
       (progn
        ;; (logger-tracef "Call (app-5): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5) $b)))
        (let* (;; Query quintenary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $a5 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 (, $x4 $x5))))
                                 (, $a1 (, $a2 (, $a3 (, $a4 $a5))))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 (, $x4 $x5))))
                              (, $a1 (, $a2 (, $a3 (, $a4 $a5))))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4 $x5) $b)))))
       (empty)))

;; Senary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b))
   (if (< 6 $mps)
       (progn
        ;; (logger-tracef "Call (app-6): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b)))
        (let* (;; Query senary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 $x6)))))
                                 (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 $a6)))))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 $x6)))))
                              (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 $a6)))))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b)))))
       (empty)))

;; Septenary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b))
   (if (< 7 $mps)
       (progn
        ;; (logger-tracef "Call (app-7): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b)))
        (let* (;; Query septenary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 $x7))))))
                                 (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 $a7))))))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 $x7))))))
                              (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 $a7))))))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b)))))
       (empty)))

;; Octonary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b))
   (if (< 8 $mps)
       (progn
        ;; (logger-tracef "Call (app-8): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b)))
        (let* (;; Query octonary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 $x8)))))))
                                 (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 $a8)))))))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 $x8)))))))
                              (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 $a8)))))))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b)))))
       (empty)))

;; Nonary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b))
   (if (< 9 $mps)
       (progn
        ;; (logger-tracef "Call (app-9): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b)))
        (let* (;; Query nonary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 $x9))))))))
                                 (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 $a9))))))))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 $x9))))))))
                              (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 $a9))))))))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b)))))
       (empty)))

;; Denary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b))
   (if (< 10 $mps)
       (progn
        ;; (logger-tracef "Call (app-10): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b)))
        (let* (;; Query denary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 $x9))))))))
                                 (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 $a9))))))))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 (, $x9 $x10)))))))))
                              (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 (, $a9 $a10)))))))))))))
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b)))))
       (empty)))

;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;; ;;
;; ;; Tests ;; ;;
;; ;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;
;; Helpers ;;
;;;;;;;;;;;;;

;; In case the input number is something, then return True iff it is
;; equal of the maximum index of the propositional calculus indexed
;; corpus.  If the input number is nothing, then return True as well
;; because it means that a verification has failed and thus the
;; experiment should be aborted.
(: equal-to-upidx-or-nothing (-> (Maybe Number) Bool))
(= (equal-to-upidx-or-nothing $idxm)
   (case $idxm
     (((Just $idx) (== (up-to-idx) $idx))
      (Nothing True))))

;; Create a propositional calculus rule base, containing type
;; theoretic representation of rules like
;;
;; (: ax-mp (-> (→ $𝜑 $𝜓) $𝜑 $𝜓))
!(bind! &pc-rb (new-space))

;; Create a propositional calculus axiom base, containing type
;; theoretic representation of axioms like
;;
;; (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑)))
;; (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))))
;; (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)))
!(bind! &pc-ab (new-space))

;; Enable occurs check to detect cycles in unification (note that it
;; returns a variable, this is normal)
!(translatePredicate (set_prolog_flag occurs_check True))

;; Add assertion to knowledge bases.  If it is an axiom then add it to
;; pc-ab.  If it is a rule then add it to pc-rb.  Additionally replace
;; greek letters by variables.
(= (add-to-kbs $label $stmt)
   (let $stmt-with-vars (replace-greeks-by-variables $stmt)
     ;; Add to rule base or axiom base
     (if (is-arrow $stmt)
         (add-atom &pc-rb (: $label $stmt-with-vars))
         (add-atom &pc-ab (: $label $stmt-with-vars)))))

;; Add proof to label mapping to labels space
(= (add-to-labels $proof $label)
   (add-atom &labels (Label $proof $label)))

;; Process the axiom of given index, that is insert the axiom into
;; pc-ab and return the next index.
;; NEXT: re-enable when fixed
;; (: process-axiom (-> Number Assertion (Maybe Number)))
(= (process-axiom $idx (MkAxiom $label $axiom))
   (progn
    (logger-infof "Iteration %w: add axiom %w" ($idx $label))
    (add-to-kbs $label $axiom)
    (Maybe.return (+ $idx 1))))

;; Process the theorem of a given index by checking its proof, if it
;; succeeds then insert it alongside its proof into the propositional
;; knowledge bases and return the next idx, or Nothing if it fails.
;; NEXT: re-enable when fixed (: process-theorem-check (-> Number
;; Number Assertion (Maybe Number)))
(= (process-theorem-check $idx $bound (MkTheorem $label $proof $thrm))
   (progn
    (if (bound-search-by-proof-size)
        (logger-infof "Iteration %w: verify proof of %w up to size %w"
                      ($idx $label $bound))
        (logger-infof "Iteration %w: verify proof of %w up to depth %w"
                      ($idx $label $bound)))
    (let (: $proof $thrm)
      (if (bound-search-by-proof-size)
          (obc &pc-rb &pc-ab callback $bound (: $proof $thrm))
          (bc &pc-rb &pc-ab callback (fromNumber $bound) (: $proof $thrm)))
      (case (: $proof $thrm)
        (;; Verified
         ((: $proof $thrm) (progn (add-to-kbs $label $thrm)
                                  (Maybe.return (+ $idx 1))))
         ;; Not verified
         (Empty Nothing))))))

;; Rediscover proof(s) of a theorem.  The results are returned as an
;; expression, a tuple of solutions, instead of a superposition to
;; avoid nondeterminism.
(= (rediscover-proofs $depth $proof $thrm)
   (let ;;Replace proof body by variable
       $proof-wo-bdy
       (replace-body-by-variable $proof)
     ;; Call backward chainer to rediscover the proof
     (collapse
      (if (search-all-proofs)
          (bc &pc-rb &pc-ab callback (fromNumber $depth)
              (: $proof-wo-bdy $thrm))
          (once (bc &pc-rb &pc-ab callback (fromNumber $depth)
                    (: $proof-wo-bdy $thrm)))))))

;; Process the theorem of a given index by rediscovering its proof, if
;; it succeeds then insert its alongside its proof(s) into the
;; propositional calculus knowledge bases and return the next idx, or
;; Nothing if it fails.
;;
;; NEXT: re-enable when fixed
;; (: process-theorem-search (-> Number Number Assertion (Maybe Number)))
(= (process-theorem-search $idx $depth (MkTheorem $label $proof $thrm))
   (progn
    (logger-infof "Iteration %w: search proof of %w up to depth %w"
                  ($idx $label $depth))
    (let $prfs-thrms
        (rediscover-proofs $depth $proof $thrm)
      (if (== $prfs-thrms ())
          ;; No proof
          (progn (logger-info "No proof found")
                 Nothing)
          ;; One or more proofs
          (progn
           ;; For each proof add mapping from proof to label
           (collapse
            (let (: $p $t) (superpose $prfs-thrms)
                 (progn
                  (logger-infof "Found proof%w %w" (: $p))
                  (add-to-labels $p $label))))
           ;; Add proved theorem as lemma in kbs
           (add-to-kbs $label $thrm)
           ;; Output next index
           (Just (+ $idx 1)))))))

;; Process the theorem of a given index, that is either check or
;; rediscover its proof, if it succeeds then insert it alongside its
;; proof into the propositional calculus knowledge bases and return
;; the next idx, or Nothing if it fails.
;; NEXT: re-enable when fixed
;; (: process-theorem (-> Number Assertion (Maybe Number)))
(= (process-theorem $idx (MkTheorem $label $proof $thrm))
   (let $bound (if (bound-search-by-proof-size)
                   (term-size $proof)   ; Calculate proof size
                   (term-depth $proof)) ; Calculate proof depth
     (if (search-proof)
         (process-theorem-search $idx
                                 $bound
                                 (MkTheorem $label $proof $thrm))
         (process-theorem-check $idx
                                $bound
                                (MkTheorem $label $proof $thrm)))))

;; Process the assertion corresponding to the given index and return
;; the index of the next assertion to process.  Meaning, if the
;; assertion is an axiom, insert the axiom in the knowledge base, and
;; if the assertion is a theorem, verify or proof the theorem and then
;; insert it in the knowledge base as if it were an axiom.  If it
;; fails to verify or proof then return Nothing instead of the next
;; index.
(: process-assertion (-> Number (Maybe Number)))
(= (process-assertion $idx)
   (progn
    (logger-tracef "Call: (process-assertion %w)" ($idx))
    (case (match &pc-idxd (MkIndexed $idx $asrt) $asrt)
      (((MkAxiom $label $axiom) (process-axiom $idx $asrt))
       ((MkTheorem $label $proof $thrm) (process-theorem $idx $asrt))
       ($else Nothing)))))

;; Like process-assertion but wrapped in Maybe.bind to accept maybe a
;; number, which the until construct needs.
(: process-assertion-m (-> (Maybe Number) (Maybe Number)))
(= (process-assertion-m $midx) (Maybe.bind $midx process-assertion))

;;;;;;;;;;;;;;;;;;;;;;;
;; Process PC Corpus ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Loop over all assertions of the corpus
!(until equal-to-upidx-or-nothing process-assertion-m (Just 2))

;; Log the content of pc-rb and pc-ab
!(logger-debugf "pc-rb: %w" ((get-atoms &pc-rb)))
!(logger-debugf "pc-ab: %w" ((get-atoms &pc-ab)))
