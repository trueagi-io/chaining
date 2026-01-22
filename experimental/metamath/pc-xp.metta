;; Experiment to verify or rediscover proofs of the propositional
;; calculus fragment of set theory of Metamath.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;; ;;
;; ;; Hyper parameters ;; ;;
;; ;;;;;;;;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
(= (reverse-arguments) True)

;; Re-discover proofs.  If it is True then the proofs are attempted to
;; be re-discovered instead of merely being checked.
(= (search-proof) True)

;; Process assertions up to the provided index (excluded).  The
;; default is 1526 because the full corpus contains 1525 assertions.
(= (up-to-idx) 7)

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
;; (: match' (-> (List $a) $a $a $a)) ; NEXT: re-enable when fixed
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
;; (: foldr (-> (-> $a $b $b) $b $c $d))  ; NEXT: re-enable when fixed
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
   (if ($p $x) $x (until $p $f ($f $x))))

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

;; Take a term representing a proof and replace its body by a variable
;; (as to be able to rediscover it).  If it is a lambda abstraction,
;; then replace the lambda term body by a variable, other replace the
;; whole term by a variable.
;; (: remove-body (-> $a $a))
(= (remove-body $prf)
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

;; Test remove-body
!(test
  (remove-body (λ mpi.2 mpi.1 (mpd mpi.2 (a1i mpi.1))))
  (λ mpi.2 mpi.1 $bdy))
!(test
  (remove-body (mpd ax-1 ax-1))
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
                      (let* (;; Get head of term
                             ($head (car-atom $term))
                             ;; Get tail of term
                             ($tail (cdr-atom $term))
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

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Backward Chainer with support for lambda abstraction at the entry
;; point (no recursive search on lambda terms).
;;
;; The arguments of the backward chainer are:
;;
;; * Knowledge base: reference to a space containing axioms and rules
;;   in the format (: <NAME> <RULE>).  Rules may or may not be curried
;;   depending on the convenience of the situation.
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
(: bc (-> $a                            ; Knowledge base space
          Nat                           ; Maximum depth
          $c                            ; Query
          $c))                          ; Result
(= (bc $kb $depth (: $prf $thrm))
   ;; (trace! (👁 bc $kb $depth (: $prf $thrm))
   (case $depth
     (;; Depth 0
      (Z (_bc $kb Nil Z (: $prf $thrm)))
      ;; Depth greater than 0 (consider lambda abstraction)
      ((S $k)
       (case (get-metatype $prf)
         ((Symbol (_bc $kb Nil (S $k) (: $prf $thrm)))
          (Grounded (_bc $kb Nil (S $k) (: $prf $thrm)))
          (Variable (_bc $kb Nil (S $k) (: $prf $thrm)))
          (Expression
           (if (== () $prf)
               (_bc $kb Nil (S $k) (: $prf $thrm))
               (case (: $prf $thrm)
                 (;; Unary lambda abstraction
                  ((: (λ $x $y) (-> $a $b))
                   (let (: $y $b)
                     (_bc $kb
                          (Cons (: $x $a) Nil)
                          $k
                          (: $y $b))
                     (: (λ $x $y) (-> $a $b))))
                  ;; Binary lambda abstraction
                  ((: (λ $x1 $x2 $y) (-> $a1 $a2 $b))
                   (let (: $y $b)
                     (_bc $kb
                          (Cons (: $x1 $a1) (Cons (: $x2 $a2) Nil))
                          $k
                          (: $y $b))
                     (: (λ $x1 $x2 $y) (-> $a1 $a2 $b))))
                  ;; Ternary lambda abstraction
                  ((: (λ $x1 $x2 $x3 $y) (-> $a1 $a2 $a3 $b))
                   (let (: $y $b)
                     (_bc $kb
                          (Cons (: $x1 $a1)
                                (Cons (: $x2 $a2)
                                      (Cons (: $x3 $a3)
                                            Nil)))
                          $k
                          (: $y $b))
                     (: (λ $x1 $x2 $x3 $y) (-> $a1 $a2 $a3 $b))))
                  ;; Quaternary lambda abstraction
                  ((: (λ $x1 $x2 $x3 $x4 $y) (-> $a1 $a2 $a3 $a4 $b))
                   (let (: $y $b)
                     (_bc $kb
                          (Cons (: $x1 $a1)
                                (Cons (: $x2 $a2)
                                      (Cons (: $x3 $a3)
                                            (Cons (: $x4 $a4)
                                                  Nil))))
                          $k
                          (: $y $b))
                     (: (λ $x1 $x2 $x3 $x4 $y) (-> $a1 $a2 $a3 $a4 $b))))
                  ;; Quintenary lambda abstraction
                  ((: (λ $x1 $x2 $x3 $x4 $x5 $y) (-> $a1 $a2 $a3 $a4 $a5 $b))
                   (let (: $y $b)
                     (_bc $kb
                          (Cons (: $x1 $a1)
                                (Cons (: $x2 $a2)
                                      (Cons (: $x3 $a3)
                                            (Cons (: $x4 $a4)
                                                  (Cons (: $x5 $a5)
                                                        Nil)))))
                          $k
                          (: $y $b))
                     (: (λ $x1 $x2 $x3 $x4 $x5 $y) (-> $a1 $a2 $a3 $a4 $a5 $b))))
                  ;; Senary lambda abstraction
                  ((: (λ $x1 $x2 $x3 $x4 $x5 $x6 $y) (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))
                   (let (: $y $b)
                     (_bc $kb
                          (Cons (: $x1 $a1)
                                (Cons (: $x2 $a2)
                                      (Cons (: $x3 $a3)
                                            (Cons (: $x4 $a4)
                                                  (Cons (: $x5 $a5)
                                                        (Cons (: $x6 $a6)
                                                              Nil))))))
                          $k
                          (: $y $b))
                     (: (λ $x1 $x2 $x3 $x4 $x5 $x6 $y) (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))))
                  ;; Septenary lambda abstraction
                  ((: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $y) (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))
                   (let (: $y $b)
                     (_bc $kb
                          (Cons (: $x1 $a1)
                                (Cons (: $x2 $a2)
                                      (Cons (: $x3 $a3)
                                            (Cons (: $x4 $a4)
                                                  (Cons (: $x5 $a5)
                                                        (Cons (: $x6 $a6)
                                                              (Cons (: $x7 $a7)
                                                                    Nil)))))))
                          $k
                          (: $y $b))
                     (: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $y) (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))))
                  ;; Octonary lambda abstraction
                  ((: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $y)
                      (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))
                   (let (: $y $b)
                     (_bc $kb
                          (Cons (: $x1 $a1)
                                (Cons (: $x2 $a2)
                                      (Cons (: $x3 $a3)
                                            (Cons (: $x4 $a4)
                                                  (Cons (: $x5 $a5)
                                                        (Cons (: $x6 $a6)
                                                              (Cons (: $x7 $a7)
                                                                    (Cons (: $x8 $a8)
                                                                          Nil))))))))
                          $k
                          (: $y $b))
                     (: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $y)
                        (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))))
                  ;; Nonary lambda abstraction
                  ((: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $y)
                      (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))
                   (let (: $y $b)
                     (_bc $kb
                          (Cons (: $x1 $a1)
                                (Cons (: $x2 $a2)
                                      (Cons (: $x3 $a3)
                                            (Cons (: $x4 $a4)
                                                  (Cons (: $x5 $a5)
                                                        (Cons (: $x6 $a6)
                                                              (Cons (: $x7 $a7)
                                                                    (Cons (: $x8 $a8)
                                                                          (Cons (: $x9 $a9)
                                                                                Nil)))))))))
                          $k
                          (: $y $b))
                     (: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $y)
                        (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))))
                  ;; Denary lambda abstraction
                  ((: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10 $y)
                      (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))
                   (let (: $y $b)
                     (_bc $kb
                          (Cons (: $x1 $a1)
                                (Cons (: $x2 $a2)
                                      (Cons (: $x3 $a3)
                                            (Cons (: $x4 $a4)
                                                  (Cons (: $x5 $a5)
                                                        (Cons (: $x6 $a6)
                                                              (Cons (: $x7 $a7)
                                                                    (Cons (: $x8 $a8)
                                                                          (Cons (: $x9 $a9)
                                                                                (Cons (: $x10 $a10)
                                                                                      Nil))))))))))
                          $k
                          (: $y $b))
                     (: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10 $y)
                        (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))))
                  ;; Otherwise
                  ($else (_bc $kb Nil (S $k) (: $prf $thrm)))))))))))));)

;; Recursive search.  No support for lambda abstraction, but support
;; for environment, which is a list of typing relationships such as
;;
;;   (Cons (: x 𝐁𝐨𝐨𝐥) (Cons (: y 𝐁𝐨𝐨𝐥) Nil))
;;
;; Also, the proof abstraction is only searched shallowly, at depth 0,
;; because they are no higher order inference rules anyway.
;;
;; NEXT: re-enable type signature when fixed
;; (: _bc (-> $a                            ; Knowledge base space
;;            (List $b)                     ; Environment
;;            Nat                           ; Maximum depth
;;            $c                            ; Query
;;            $c))                          ; Result
;; Base cases
;; Match the knowledge base
(= (_bc $kb $env $k (: $x $a))
   ;; (trace! (👁 _bc-kb $kb $env $k (: $x $a))
   (match $kb (: $x $a) (: $x $a)));)
;; Match the environment
(= (_bc $kb $env $k (: $x $a))
   ;; (trace! (👁 _bc-env $kb $env $k (: $x $a))
   (match' $env (: $x $a) (: $x $a)));)

;; Recursive steps
;; Unary proof application
(= (_bc $kb $env (S $k) (: ($f $x) $b))
   ;; (trace! (👁 _bc-1 $kb $env (S $k) (: ($f $x) $b))
   (let* (;; Recurse on unary rule
          ((: $f (-> $a $b))
           (_bc $kb $env Z (: $f (-> $a $b))))
          ;; Recurse on premise
          ((: $x $a) (_bc $kb $env $k (: $x $a))))
     (: ($f $x) $b)));)
;; Binary proof application
(= (_bc $kb $env (S $k) (: ($f $x1 $x2) $b))
   ;; (trace! (👁 _bc-2 $kb $env (S $k) (: ($f $x1 $x2) $b))
   (let* (;; Recurse on binary rule
          ((: $f (-> $a1 $a2 $b))
           (_bc $kb $env Z (: $f (-> $a1 $a2 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (_bc $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (_bc $kb $env $k (: $x2 $a2))))
     (: ($f $x1 $x2) $b)));)
;; Ternary proof application
(= (_bc $kb $env (S $k) (: ($f $x1 $x2 $x3) $b))
   ;; (trace! (👁 _bc-3 $kb $env (S $k) (: ($f $x1 $x2 $x3) $b))
   (let* (;; Recurse on ternary rule
          ((: $f (-> $a1 $a2 $a3 $b))
           (_bc $kb $env Z (: $f (-> $a1 $a2 $a3 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (_bc $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (_bc $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (_bc $kb $env $k (: $x3 $a3))))
     (: ($f $x1 $x2 $x3) $b)));)
;; Quaternary proof application
(= (_bc $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4) $b))
   ;; (trace! (👁 _bc-4 $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4) $b))
   (let* (;; Recurse on quaternary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $b))
           (_bc $kb $env Z (: $f (-> $a1 $a2 $a3 $a4 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (_bc $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (_bc $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (_bc $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (_bc $kb $env $k (: $x4 $a4))))
     (: ($f $x1 $x2 $x3 $x4) $b)));)
;; Quintenary proof application
(= (_bc $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5) $b))
   ;; (trace! (👁 _bc-5 $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5) $b))
   (let* (;; Recurse on quintenary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $a5 $b))
           (_bc $kb $env Z (: $f (-> $a1 $a2 $a3 $a4 $a5 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (_bc $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (_bc $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (_bc $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (_bc $kb $env $k (: $x4 $a4)))
          ;; Recurse on premise 5
          ((: $x5 $a5) (_bc $kb $env $k (: $x5 $a5))))
     (: ($f $x1 $x2 $x3 $x4 $x5) $b)));)
;; Senary proof application
(= (_bc $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b))
   ;; (trace! (👁 _bc-6 $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b))
   (let* (;; Recurse on senary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $a5 $6 $b))
           (_bc $kb $env Z (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (_bc $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (_bc $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (_bc $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (_bc $kb $env $k (: $x4 $a4)))
          ;; Recurse on premise 5
          ((: $x5 $a5) (_bc $kb $env $k (: $x5 $a5)))
          ;; Recurse on premise 6
          ((: $x6 $a6) (_bc $kb $env $k (: $x6 $a6))))
     (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b)));)
;; Septenary proof application
(= (_bc $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b))
   ;; (trace! (👁 _bc-7 $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b))
   (let* (;; Recurse on septenary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))
           (_bc $kb $env Z (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (_bc $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (_bc $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (_bc $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (_bc $kb $env $k (: $x4 $a4)))
          ;; Recurse on premise 5
          ((: $x5 $a5) (_bc $kb $env $k (: $x5 $a5)))
          ;; Recurse on premise 6
          ((: $x6 $a6) (_bc $kb $env $k (: $x6 $a6)))
          ;; Recurse on premise 7
          ((: $x7 $a7) (_bc $kb $env $k (: $x7 $a7))))
     (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b)));)
;; Octonary proof application
(= (_bc $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b))
   ;; (trace! (👁 _bc-8 $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b))
   (let* (;; Recurse on octonary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))
           (_bc $kb $env Z (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (_bc $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (_bc $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (_bc $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (_bc $kb $env $k (: $x4 $a4)))
          ;; Recurse on premise 5
          ((: $x5 $a5) (_bc $kb $env $k (: $x5 $a5)))
          ;; Recurse on premise 6
          ((: $x6 $a6) (_bc $kb $env $k (: $x6 $a6)))
          ;; Recurse on premise 7
          ((: $x7 $a7) (_bc $kb $env $k (: $x7 $a7)))
          ;; Recurse on premise 8
          ((: $x8 $a8) (_bc $kb $env $k (: $x8 $a8))))
     (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b)));)
;; Nonary proof application
(= (_bc $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b))
   ;; (trace! (👁 _bc-9 $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b))
   (let* (;; Recurse on nonary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))
           (_bc $kb $env Z (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (_bc $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (_bc $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (_bc $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (_bc $kb $env $k (: $x4 $a4)))
          ;; Recurse on premise 5
          ((: $x5 $a5) (_bc $kb $env $k (: $x5 $a5)))
          ;; Recurse on premise 6
          ((: $x6 $a6) (_bc $kb $env $k (: $x6 $a6)))
          ;; Recurse on premise 7
          ((: $x7 $a7) (_bc $kb $env $k (: $x7 $a7)))
          ;; Recurse on premise 8
          ((: $x8 $a8) (_bc $kb $env $k (: $x8 $a8)))
          ;; Recurse on premise 9
          ((: $x9 $a9) (_bc $kb $env $k (: $x9 $a9))))
     (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b)));)
;; Denary proof application
(= (_bc $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b))
   ;; (trace! (👁 _bc-10 $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b))
   (let* (;; Recurse on denary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))
           (_bc $kb $env Z
                (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (_bc $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (_bc $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (_bc $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (_bc $kb $env $k (: $x4 $a4)))
          ;; Recurse on premise 5
          ((: $x5 $a5) (_bc $kb $env $k (: $x5 $a5)))
          ;; Recurse on premise 6
          ((: $x6 $a6) (_bc $kb $env $k (: $x6 $a6)))
          ;; Recurse on premise 7
          ((: $x7 $a7) (_bc $kb $env $k (: $x7 $a7)))
          ;; Recurse on premise 8
          ((: $x8 $a8) (_bc $kb $env $k (: $x8 $a8)))
          ;; Recurse on premise 9
          ((: $x9 $a9) (_bc $kb $env $k (: $x9 $a9)))
          ;; Recurse on premise 10
          ((: $x10 $a10) (_bc $kb $env $k (: $x10 $a10))))
     (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b)));)

;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;; ;;
;; ;; Tests ;; ;;
;; ;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;

;; Import the propositional calculus corpus in the format
;; (MkIndexed INDEX (MkAxiom LABEL AXIOM))
;; (MkIndexed INDEX (MkTheorem LABEL PROOF THEOREM))
!(if (reverse-arguments)
     (import! &pc-idxd propositional-calculus-reversed-arguments)
     (import! &pc-idxd propositional-calculus))

;; In case the input number is something, then return True iff it is
;; equal of the maximum index of the propositional calculus indexed
;; corpus.  If the input number is nothing, then return True as well
;; because it means that a verification has failed and thus the
;; experiment should be aborted.
(: equal-to-maxidx (-> (Maybe Number) Bool))
(= (equal-to-maxidx $midx)
   (case $midx
     (;; Just
      ;; ((Just $idx) (== (+ (max-index &pc-idxd) 1) $idx)) ; TODO: use &midx
      ((Just $idx) (== (up-to-idx) $idx))
      ;; Nothing
      (Nothing True))))

;; Create a propositional calculus knowledge base, containing type
;; theoretic representation of assertions like
;;
;; (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑)))
;; (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))))
;; (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)))
;; (: ax-mp (-> $𝜑 (→ $𝜑 $𝜓) $𝜓))
!(bind! &pc-kb (new-space))

;; Enable occurs check to detect cycles in unification
!(translatePredicate (set_prolog_flag occurs_check True))

;; Process the assertion corresponding to the given index and return
;; the index of the next assertion to process.  Meaning, if the
;; assertion is an axiom, insert the axiom in the knowledge base, and
;; if the assertion is a theorem, verify the theorem and then insert
;; it in the knowledge base as if it were an axiom.
(: process-assertion-step (-> (Maybe Number) (Maybe Number)))
(= (process-assertion-step $midx)
   ;; (trace! (👁 process-assertion-step $midx)
   (case $midx
     (;; Just
      ((Just $idx)
       (case (match &pc-idxd (MkIndexed $idx $asrt) $asrt)
         (;; Axiom
          ((MkAxiom $label $axiom)
           (progn (trace! (👁 (Iteration $idx "Add axiom" $label))
                           (add-atom &pc-kb (: $label $axiom)))
                  (Just (+ $idx 1))))
          ;; Theorem
          ((MkTheorem $label $proof $thrm)
           (let $depth (term-depth $proof)
             (if (search-proof)
                 (trace! (👁 (Iteration $idx "Search proof of" $label "up to depth" $depth))
                 (case (bc &pc-kb (fromNumber $depth) (: (remove-body $proof) $thrm))
                   (;; Found
                    ((: $proof $thrm) (progn (add-atom &pc-kb (: $label $thrm))
                                             (Just (+ $idx 1))))
                    ;; Not found
                    (Empty Nothing))))
                 (trace! (👁 (Iteration $idx "Verify proof of" $label "up to depth" $depth))
                 (let (: $proof $thrm)
                   (bc &pc-kb (fromNumber $depth) (: $proof $thrm))
                   (case (: $proof $thrm)
                     (;; Verified
                      ((: $proof $thrm) (progn (add-atom &pc-kb (: $label $thrm))
                                               (Just (+ $idx 1))))
                      ;; Not verified
                      (Empty Nothing)))))))))))
      ;; Nothing
      (Nothing Nothing))));)

;; Run verification loop (skip the first 2 assertions idi and a1ii
;; which are only useful)
!(until equal-to-maxidx process-assertion-step (Just 2))
!(get-atoms &pc-kb)
