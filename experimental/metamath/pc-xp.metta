;; Experiment to verify or rediscover proofs of the propositional
;; calculus fragment of set theory of Metamath.

;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;; ;;
;; ;; Functions ;; ;;
;; ;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;
;; Eager trace ;;
;;;;;;;;;;;;;;;;;

(: trace!! (-> Expression Expression Expression))
(= (trace!! $pr $ret)
   (quote (progn (println! $pr) $ret)))
!(add-translator-rule! trace!!)

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
   (case (: $prf $thrm)
     (;; Unary lambda abstraction
      ((: (λ $x $y) (-> $a $b))
       (let (: $y $b)
         (bc_search $kb (Cons (: $x $a) Nil) $depth (: $y $b))
         (: (λ $x $y) (-> $a $b))))
      ;; Binary lambda abstraction
      ((: (λ $x1 $x2 $y) (-> $a1 $a2 $b))
       (let (: $y $b)
         (bc_search $kb
                    (Cons (: $x1 $a1) (Cons (: $x2 $a2) Nil))
                    $depth
                    (: $y $b))
         (: (λ $x1 $x2 $y) (-> $a1 $a2 $b))))
      ;; Ternary lambda abstraction
      ((: (λ $x1 $x2 $x3 $y) (-> $a1 $a2 $a3 $b))
       (let (: $y $b)
         (bc_search $kb
                    (Cons (: $x1 $a1) (Cons (: $x2 $a2) (Cons (: $x3 $a3) Nil)))
                    $depth
                    (: $y $b))
         (: (λ $x1 $x2 $x3 $y) (-> $a1 $a2 $a3 $b))))
      ;; Quaternary lambda abstraction
      ((: (λ $x1 $x2 $x3 $x4 $y) (-> $a1 $a2 $a3 $a4 $b))
       (let (: $y $b)
         (bc_search $kb
                    (Cons (: $x1 $a1)
                          (Cons (: $x2 $a2)
                                (Cons (: $x3 $a3)
                                      (Cons (: $x4 $a4) Nil))))
                    $depth
                    (: $y $b))
         (: (λ $x1 $x2 $x3 $x4 $y) (-> $a1 $a2 $a3 $a4 $b))))
      ;; Quintenary lambda abstraction
      ((: (λ $x1 $x2 $x3 $x4 $x5 $y) (-> $a1 $a2 $a3 $a4 $a5 $b))
       (let (: $y $b)
         (bc_search $kb
                    (Cons (: $x1 $a1)
                          (Cons (: $x2 $a2)
                                (Cons (: $x3 $a3)
                                      (Cons (: $x4 $a4)
                                            (Cons (: $x5 $a5)
                                                  Nil)))))
                    $depth
                    (: $y $b))
         (: (λ $x1 $x2 $x3 $x4 $x5 $y) (-> $a1 $a2 $a3 $a4 $a5 $b))))
      ;; Senary lambda abstraction
      ((: (λ $x1 $x2 $x3 $x4 $x5 $x6 $y) (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))
       (let (: $y $b)
         (bc_search $kb
                    (Cons (: $x1 $a1)
                          (Cons (: $x2 $a2)
                                (Cons (: $x3 $a3)
                                      (Cons (: $x4 $a4)
                                            (Cons (: $x5 $a5)
                                                  (Cons (: $x6 $a6)
                                                        Nil))))))
                    $depth
                    (: $y $b))
         (: (λ $x1 $x2 $x3 $x4 $x5 $x6 $y) (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))))
      ;; Septenary lambda abstraction
      ((: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $y) (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))
       (let (: $y $b)
         (bc_search $kb
                    (Cons (: $x1 $a1)
                          (Cons (: $x2 $a2)
                                (Cons (: $x3 $a3)
                                      (Cons (: $x4 $a4)
                                            (Cons (: $x5 $a5)
                                                  (Cons (: $x6 $a6)
                                                        (Cons (: $x7 $a7)
                                                              Nil)))))))
                    $depth
                    (: $y $b))
         (: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $y) (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))))
      ;; Octonary lambda abstraction
      ((: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $y)
          (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))
       (let (: $y $b)
         (bc_search $kb
                    (Cons (: $x1 $a1)
                          (Cons (: $x2 $a2)
                                (Cons (: $x3 $a3)
                                      (Cons (: $x4 $a4)
                                            (Cons (: $x5 $a5)
                                                  (Cons (: $x6 $a6)
                                                        (Cons (: $x7 $a7)
                                                              (Cons (: $x8 $a8)
                                                                    Nil))))))))
                    $depth
                    (: $y $b))
         (: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $y)
            (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))))
      ;; Nonary lambda abstraction
      ((: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $y)
          (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))
       (let (: $y $b)
         (bc_search $kb
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
                    $depth
                    (: $y $b))
         (: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $y)
            (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))))
      ;; Denary lambda abstraction
      ((: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10 $y)
          (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))
       (let (: $y $b)
         (bc_search $kb
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
                    $depth
                    (: $y $b))
         (: (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10 $y)
            (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))))
      ;; Otherwise
      ($_ (bc_search $kb Nil $depth (: $prf $thrm))))))

;; Recursive search.  No support for lambda abstraction, but support
;; for environment, which is a list of typing relationships such as
;;
;;   (Cons (: x 𝐁𝐨𝐨𝐥) (Cons (: y 𝐁𝐨𝐨𝐥) Nil))
;; NEXT: re-enable type signature when fixed
;; (: bc_search (-> $a                            ; Knowledge base space
;;                  (List $b)                     ; Environment
;;                  Nat                           ; Maximum depth
;;                  $c                            ; Query
;;                  $c))                          ; Result
;; Base cases
;; Match the knowledge base
(= (bc_search $kb $env $_ (: $x $a)) (match $kb (: $x $a) (: $x $a)))
;; Match the environment
(= (bc_search $kb $env $_ (: $x $a)) (match' $env (: $x $a) (: $x $a)))

;; Recursive steps
;; Unary proof application
(= (bc_search $kb $env (S $k) (: ($f $x) $b))
   (let* (;; Recurse on unary rule
          ((: $f (-> $a $b))
           (bc_search $kb $env $k (: $f (-> $a $b))))
          ;; Recurse on premise
          ((: $x $a) (bc_search $kb $env $k (: $x $a))))
     (: ($f $x) $b)))
;; Binary proof application
(= (bc_search $kb $env (S $k) (: ($f $x1 $x2) $b))
   (let* (;; Recurse on binary rule
          ((: $f (-> $a1 $a2 $b))
           (bc_search $kb $env $k (: $f (-> $a1 $a2 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (bc_search $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (bc_search $kb $env $k (: $x2 $a2))))
     (: ($f $x1 $x2) $b)))
;; Ternary proof application
(= (bc_search $kb $env (S $k) (: ($f $x1 $x2 $x3) $b))
   (let* (;; Recurse on ternary rule
          ((: $f (-> $a1 $a2 $a3 $b))
           (bc_search $kb $env $k (: $f (-> $a1 $a2 $a3 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (bc_search $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (bc_search $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (bc_search $kb $env $k (: $x3 $a3))))
     (: ($f $x1 $x2 $x3) $b)))
;; Quaternary proof application
(= (bc_search $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4) $b))
   (let* (;; Recurse on quaternary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $b))
           (bc_search $kb $env $k (: $f (-> $a1 $a2 $a3 $a4 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (bc_search $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (bc_search $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (bc_search $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (bc_search $kb $env $k (: $x4 $a4))))
     (: ($f $x1 $x2 $x3 $x4) $b)))
;; Quintenary proof application
(= (bc_search $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5) $b))
   (let* (;; Recurse on quintenary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $a5 $b))
           (bc_search $kb $env $k (: $f (-> $a1 $a2 $a3 $a4 $a5 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (bc_search $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (bc_search $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (bc_search $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (bc_search $kb $env $k (: $x4 $a4)))
          ;; Recurse on premise 5
          ((: $x5 $a5) (bc_search $kb $env $k (: $x5 $a5))))
     (: ($f $x1 $x2 $x3 $x4 $x5) $b)))
;; Senary proof application
(= (bc_search $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b))
   (let* (;; Recurse on senary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $a5 $6 $b))
           (bc_search $kb $env $k (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (bc_search $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (bc_search $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (bc_search $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (bc_search $kb $env $k (: $x4 $a4)))
          ;; Recurse on premise 5
          ((: $x5 $a5) (bc_search $kb $env $k (: $x5 $a5)))
          ;; Recurse on premise 6
          ((: $x6 $a6) (bc_search $kb $env $k (: $x6 $a6))))
     (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b)))
;; Septenary proof application
(= (bc_search $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b))
   (let* (;; Recurse on septenary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))
           (bc_search $kb $env $k (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (bc_search $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (bc_search $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (bc_search $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (bc_search $kb $env $k (: $x4 $a4)))
          ;; Recurse on premise 5
          ((: $x5 $a5) (bc_search $kb $env $k (: $x5 $a5)))
          ;; Recurse on premise 6
          ((: $x6 $a6) (bc_search $kb $env $k (: $x6 $a6)))
          ;; Recurse on premise 7
          ((: $x7 $a7) (bc_search $kb $env $k (: $x7 $a7))))
     (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b)))
;; Octonary proof application
(= (bc_search $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b))
   (let* (;; Recurse on octonary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))
           (bc_search $kb $env $k (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (bc_search $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (bc_search $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (bc_search $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (bc_search $kb $env $k (: $x4 $a4)))
          ;; Recurse on premise 5
          ((: $x5 $a5) (bc_search $kb $env $k (: $x5 $a5)))
          ;; Recurse on premise 6
          ((: $x6 $a6) (bc_search $kb $env $k (: $x6 $a6)))
          ;; Recurse on premise 7
          ((: $x7 $a7) (bc_search $kb $env $k (: $x7 $a7)))
          ;; Recurse on premise 8
          ((: $x8 $a8) (bc_search $kb $env $k (: $x8 $a8))))
     (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b)))
;; Nonary proof application
(= (bc_search $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b))
   (let* (;; Recurse on nonary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))
           (bc_search $kb $env $k (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (bc_search $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (bc_search $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (bc_search $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (bc_search $kb $env $k (: $x4 $a4)))
          ;; Recurse on premise 5
          ((: $x5 $a5) (bc_search $kb $env $k (: $x5 $a5)))
          ;; Recurse on premise 6
          ((: $x6 $a6) (bc_search $kb $env $k (: $x6 $a6)))
          ;; Recurse on premise 7
          ((: $x7 $a7) (bc_search $kb $env $k (: $x7 $a7)))
          ;; Recurse on premise 8
          ((: $x8 $a8) (bc_search $kb $env $k (: $x8 $a8)))
          ;; Recurse on premise 9
          ((: $x9 $a9) (bc_search $kb $env $k (: $x9 $a9))))
     (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b)))
;; Denary proof application
(= (bc_search $kb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b))
   (let* (;; Recurse on denary rule
          ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))
           (bc_search $kb
                      $env
                      $k
                      (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))))
          ;; Recurse on premise 1
          ((: $x1 $a1) (bc_search $kb $env $k (: $x1 $a1)))
          ;; Recurse on premise 2
          ((: $x2 $a2) (bc_search $kb $env $k (: $x2 $a2)))
          ;; Recurse on premise 3
          ((: $x3 $a3) (bc_search $kb $env $k (: $x3 $a3)))
          ;; Recurse on premise 4
          ((: $x4 $a4) (bc_search $kb $env $k (: $x4 $a4)))
          ;; Recurse on premise 5
          ((: $x5 $a5) (bc_search $kb $env $k (: $x5 $a5)))
          ;; Recurse on premise 6
          ((: $x6 $a6) (bc_search $kb $env $k (: $x6 $a6)))
          ;; Recurse on premise 7
          ((: $x7 $a7) (bc_search $kb $env $k (: $x7 $a7)))
          ;; Recurse on premise 8
          ((: $x8 $a8) (bc_search $kb $env $k (: $x8 $a8)))
          ;; Recurse on premise 9
          ((: $x9 $a9) (bc_search $kb $env $k (: $x9 $a9)))
          ;; Recurse on premise 10
          ((: $x10 $a10) (bc_search $kb $env $k (: $x10 $a10))))
     (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b)))

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
   (case $midx
     (;; Just
      ;; ((Just $idx) (== (+ (max-index &pc-idxd) 1) $idx)) ; TODO: use &midx
      ((Just $idx) (== (+ 1525 1) $idx))
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
           (progn (trace!! (👁 (Iteration $idx "Add axiom" $label))
                           (add-atom &pc-kb (: $label $axiom)))
                  (Just (+ $idx 1))))
          ;; Theorem
          ((MkTheorem $label $proof $thrm)
           (trace!! (👁 (Iteration $idx "Verify and add theorem" $label))
           (let $depth (fromNumber (term-depth $proof))
             (case (bc &pc-kb $depth (: $proof $thrm))
               (;; Verified
                ((: $proof $thrm) (progn (add-atom &pc-kb (: $label $thrm))
                                         (Just (+ $idx 1))))
                ;; Not verified
                (Empty Nothing)))))))))
      ;; Nothing
      (Nothing Nothing))))

;; Run verification loop
!(until equal-to-maxidx process-assertion-step (Just 0))
!(get-atoms &pc-kb)
