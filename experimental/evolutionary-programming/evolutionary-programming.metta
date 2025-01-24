;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Example of using MeTTa backward chainer to do evolutionary programming ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;
;; Nat ;;
;;;;;;;;;

;; Define Nat
(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

;; Define <=
(: <= (-> $a $a Bool))
(= (<= $x $y) (or (< $x $y) (== $x $y)))

;; Define cast functions between Nat and Number
(: fromNumber (-> Number Nat))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))
(: fromNat (-> Nat Number))
(= (fromNat Z) 0)
(= (fromNat (S $k)) (+ 1 (fromNat $k)))

;;;;;;;;;;;
;; Utils ;;
;;;;;;;;;;;

;; Run the code if the condition is true, otherwise prune the branch
(: when (-> Bool $a $a))
(= (when $c $x) (if $c $x (empty)))

;; Return True iff $term is closed
(: is-closed (-> Atom Bool))
(= (is-closed $term)
   (case (get-metatype $term)
     ((Variable False)
      (Symbol True)
      (Grounded True)
      (Expression (if (== $term ())
                      True
                      (let* (($head (car-atom $term))
                             ($tail (cdr-atom $term)))
                        (and (is-closed $head) (is-closed $tail))))))))

;; Test is-closed
!(assertEqual
  (is-closed A)
  True)
!(assertEqual
  (is-closed $x)
  False)
!(assertEqual
  (is-closed (And T (Or $x F)))
  False)
!(assertEqual
  (is-closed (Or (Not F) T))
  True)

;; Apply a given function to every element of a tuple
(: map (-> (-> $a $b) $c $d))
(= (map $f $xs)
   (if (== $xs ())
       ()
       (let* (($h (car-atom $xs))
              ($t (cdr-atom $xs))
              ($fh ($f $h))
              ($ft (map $f $t)))
         (cons-atom $fh $ft))))

;; Test map
!(assertEqual
  (map repr (1 2 3))
  ("1" "2" "3"))

;; Fold a tuple from right to left
(: foldr (-> (-> $a $b $b) $b $c $d))
(= (foldr $f $i $xs)
   (if (== $xs ())
       $i
       (let* (($h (car-atom $xs))
              ($t (cdr-atom $xs))
              ($ft (foldr $f $i $t)))
         ($f $h $ft))))

;; Test foldr
!(assertEqual
  (foldr + 0 (1 2 3))
  6)

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

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Backward Chainer with environment.  There is no explicit support
;; for lambda abstraction due to the combinatorial explosion resulting
;; from combining lambda abstractions and applications.  Instead,
;; variables are added to the environment manually.  So for instance,
;; if the program to synthesize has the following type signature
;;
;; Boolean -> Boolean -> Boolean
;;
;; meaning it is a binary boolean function, thus has 2 arguments, we
;; add the following two declarations in the environment
;;
;; (: z Boolean)
;; (: (s z) Boolean)
;;
;; where z and (s z) represents the variables associated with the two
;; arguments.
;;
;; The arguments of the backward chainer are:
;;
;; * Knowledge base: reference to a space containing axioms and rules
;;   in the format (: <NAME> <RULE>).  Rules may or may not be curried
;;   depending on the convenience of the situation.
;;
;; * Environment: a list of typing relationships such as
;;
;;   (Cons (: z Boolean) (Cons (: (s z) Boolean) Nil))
;;
;; * Maximum depth: maximum depth of the generated proof tree.
;;
;; * Query: a metta term of the form (: <PROOF> <THEOREM>) where
;;   <PROOF> and <THEOREM> may contain free variables that may be
;;   filled by the backward chainer.
(: bc (-> $a                            ; Knowledge base space
          (List $b)                     ; Environment
          Nat                           ; Maximum depth
          $c                            ; Query
          $c))                          ; Result

;; Base cases
;; Match the knowledge base
(= (bc $kb $env $_ (: $prf $thrm))
   (match $kb (: $prf $thrm) (: $prf $thrm)))
;; Match the environment
(= (bc $kb $env $_ (: $prf $thrm))
   (match' $env (: $prf $thrm) (: $prf $thrm)))

;; Recursive steps
;; Unary proof application
(= (bc $kb $env (S $k) (: ($prfabs $prfarg) $thrm))
   (let* (;; Recurse on unary rule
          ((: $prfabs (-> (: $prfarg $prms) $thrm))
           (bc $kb $env $k (: $prfabs (-> (: $prfarg $prms) $thrm))))
          ;; Recurse on premise
          ((: $prfarg $prms) (bc $kb $env $k (: $prfarg $prms))))
     (: ($prfabs $prfarg) $thrm)))
;; Binary proof application
(= (bc $kb $env (S $k) (: ($prfabs $prfarg1 $prfarg2) $thrm))
   (let* (;; Recurse on binary rule
          ((: $prfabs (-> (: $prfarg1 $prms1)
                          (: $prfarg2 $prms2)
                          $thrm))
           (bc $kb $env $k (: $prfabs (-> (: $prfarg1 $prms1)
                                          (: $prfarg2 $prms2)
                                          $thrm))))
          ;; Recurse on premise 1
          ((: $prfarg1 $prms1) (bc $kb $env $k (: $prfarg1 $prms1)))
          ;; Recurse on premise 2
          ((: $prfarg2 $prms2) (bc $kb $env $k (: $prfarg2 $prms2))))
     (: ($prfabs $prfarg1 $prfarg2) $thrm)))
;; Ternary proof application
(= (bc $kb $env (S $k) (: ($prfabs $prfarg1 $prfarg2 $prfarg3) $thrm))
   (let* (;; Recurse on ternary rule
          ((: $prfabs (-> (: $prfarg1 $prms1)
                          (: $prfarg2 $prms2)
                          (: $prfarg3 $prms3)
                          $thrm))
           (bc $kb $env $k (: $prfabs (-> (: $prfarg1 $prms1)
                                          (: $prfarg2 $prms2)
                                          (: $prfarg3 $prms3)
                                          $thrm))))
          ;; Recurse on premise 1
          ((: $prfarg1 $prms1) (bc $kb $env $k (: $prfarg1 $prms1)))
          ;; Recurse on premise 2
          ((: $prfarg2 $prms2) (bc $kb $env $k (: $prfarg2 $prms2)))
          ;; Recurse on premise 3
          ((: $prfarg3 $prms3) (bc $kb $env $k (: $prfarg3 $prms3))))
     (: ($prfabs $prfarg1 $prfarg2 $prfarg3) $thrm)))

;;;;;;;;;;;;;
;; Fitness ;;
;;;;;;;;;;;;;

;; Evaluation function.  Given a candidate and a tuple of values (the
;; input arguments), output the result of the evaluation of that
;; candidate on the arguments.
(: evaluate (-> Atom Expression Atom))
;; Constants
(= (evaluate T $inputs) T)
(= (evaluate F $inputs) F)
;; Variables.  Note that if the DeBruijn index is greater than the
;; length of the tuple corresponding to the input arguments, MeTTa
;; will raise an error.
(= (evaluate z $inputs) (car-atom $inputs))
(= (evaluate (s $k) $inputs) (let $tail (cdr-atom $inputs) (evaluate z $tail)))
;; Operators
(= (evaluate (And $x $y) $inputs)
   (if (== (evaluate $x $inputs) T)
       (evaluate $y $inputs)
       F))
(= (evaluate (Or $x $y) $inputs)
   (if (== (evaluate $x $inputs) F)
       (evaluate $y $inputs)
       T))
(= (evaluate (Not $x) $inputs)
   (if (== (evaluate $x $inputs) F)
       T
       F))

;; Test evaluate
!(assertEqual
  (evaluate T (F T))
  T)
!(assertEqual
  (evaluate z (F T))
  F)
!(assertEqual
  (evaluate (Or T z) (F T))
  T)
!(assertEqual
  (evaluate (And (Or T z) (s z)) (F T))
  T)

;; Evaluation correctness function.  Given a candidate and a pair
;; (INPUTS OUTPUT), compare the output of the candidate with the
;; output of the pair, return True if their outputs are equal, False
;; otherwise.  Provided in curried form for convenience.
(: evaluate-correctness (-> Atom (-> Expression Bool)))
(= ((evaluate-correctness $cnd) ($inputs $output))
   (== $output (evaluate $cnd $inputs)))

;; Test evaluate-correctness
!(assertEqual
  ((evaluate-correctness T) ((F T) T))
  True)
!(assertEqual
  ((evaluate-correctness (And (Or T z) (s z))) ((F T) T))
  True)

;; Output -1 when given False, 0 otherwise.
(: correctness-to-number (-> Bool Number))
(= (correctness-to-number True) 0)
(= (correctness-to-number False) -1)

;; Fitness function.  Assign a fitness score to a given candidate
;; corresponding to the number of incorrect answers compared to a
;; certain truth table.  In that particular implementation the truth
;; table is hardwired to correspond to logical conjunction.
(: fitness (-> Atom Number))
(= (fitness $cnd)
   (let* (;; Define a truth table (logical conjunction)
          ($truth-table (((T T) T)
                         ((T F) F)
                         ((F T) F)
                         ((F F) F)))
          ;; Get tuple of correctness of outputs
          ($corrects (map (evaluate-correctness $cnd) $truth-table)))
     ;; Count of the number errors
     (foldr + 0 (map correctness-to-number $corrects))))

;; Test fitness
!(assertEqual
  (fitness T)
  -3)
!(assertEqual
  (fitness (And z (s z)))
  0)

;;;;;;;;;;;;;;;;;;;;
;; Knowledge base ;;
;;;;;;;;;;;;;;;;;;;;

!(bind! &kb (new-space))

;; Define Σ (Sigma type, also called DPair in Idris)
!(add-atom &kb
           (: MkΣ
              (-> (: $p (-> (: $_ $a) Type)) ; Premise 1.  We
                                             ;   need to use (: $_ $a)
                                             ;   as opposed to just $a
                                             ;   to be fully consistent with
                                             ;   The (: PROOF PREMISE)
                                             ;   notation, till it becomes
                                             ;   optional.
                  (: $x $a)                  ; Premise 2
                  (: $prf ($p $x))           ; Premise 3
                  (Σ $a $p))))               ; Conclusion

;; Define the vocabulary of the programs to evolve.  We use the type
;; Boolean instead of Bool to make sure it does interfere the built-in
;; Bool type.
!(add-atom &kb (: And (-> (: $x Boolean) (: $y Boolean) Boolean)))
!(add-atom &kb (: Or (-> (: $x Boolean) (: $y Boolean) Boolean)))
!(add-atom &kb (: Not (-> (: $x Boolean) Boolean)))
!(add-atom &kb (: T Boolean))
!(add-atom &kb (: F Boolean))

;; Define fitness predicate.  It takes 2 arguments
;; 1. a number representing the fitness of
;; 2. a given candidate.
;;
;; The type of the candidate is merely Bool because the programs being
;; evolved are boolean expressions.
!(add-atom &kb
           (: Fit (-> (: $ftns Number)
                      (-> (: $cnd Boolean)
                          Type))))

;; Completement the backward chainer with a custom call to calculate
;; the fitness of a given candidate.  At this point sub-symbolic
;; processing takes over for efficiency reason.  The proof is merely
;; represented by the symbol CPU.  It is as if the proof were saying
;; "the fitness of the given candidate is such because the CPU said
;; so".  Because a CPU is a black box from the viewpoint of a program,
;; it conveys the idea that the backward chainer should trust that
;; black box and move along.
(= (bc $kb $env $_ (: CPU ((Fit $ftns) $cnd)))
   (when (is-closed $cnd)
     (let $ftns (fitness $cnd)
       (: CPU ((Fit $ftns) $cnd)))))

;;;;;;;;;;
;; Test ;;
;;;;;;;;;;

;; Generate candidates up to depth 0 (assuming a binary function)
!(assertEqualToResult
  (bc &kb
      (Cons (: z Boolean) (Cons (: (s z) Boolean) Nil))
      Z
      (: $cnd Boolean))
  ((: T Boolean)
   (: F Boolean)
   (: z Boolean)
   (: (s z) Boolean)))

;; Generate candidates up to depth 1 (assuming a unary function)
!(assertEqualToResult
  (bc &kb
      (Cons (: z Boolean) Nil)
      (fromNumber 1)
      (: $cnd Boolean))
  ((: T Boolean)
   (: F Boolean)
   (: z Boolean)
   (: (Or T T) Boolean)
   (: (Or T F) Boolean)
   (: (Or T z) Boolean)
   (: (Or F T) Boolean)
   (: (Or F F) Boolean)
   (: (Or F z) Boolean)
   (: (Or z T) Boolean)
   (: (Or z F) Boolean)
   (: (Or z z) Boolean)
   (: (And T T) Boolean)
   (: (And T F) Boolean)
   (: (And T z) Boolean)
   (: (And F T) Boolean)
   (: (And F F) Boolean)
   (: (And F z) Boolean)
   (: (And z T) Boolean)
   (: (And z F) Boolean)
   (: (And z z) Boolean)
   (: (Not T) Boolean)
   (: (Not F) Boolean)
   (: (Not z) Boolean)))

;; ;; Generate 1 candidate up to depth 2 (only works with MeTTaLog)
;; !(limit 1 (bc &kb Nil (fromNumber 1) (: $cnd Boolean)))

;; Evaluate candidate T
!(assertEqual
  (bc &kb Nil Z (: $prf ((Fit $ftns) T)))
  (: CPU ((Fit -3) T)))

;; Evaluate candidate z
!(assertEqual
  (bc &kb (Cons (: z Boolean) Nil) Z (: $prf ((Fit $ftns) z)))
  (: CPU ((Fit -1) z)))

;; Evaluate candidate (Or z (s z))
!(assertEqual
  (bc &kb
      (Cons (: z Boolean) (Cons (: (s z) Boolean) Nil))
      Z
      (: $prf ((Fit $ftns) (Or z (s z)))))
  (: CPU ((Fit -2) (Or z (s z)))))

;; Evaluate candidate (And z (s z))
!(assertEqual
  (bc &kb
      (Cons (: z Boolean) (Cons (: (s z) Boolean) Nil))
      Z
      (: $prf ((Fit $ftns) (And z (s z)))))
  (: CPU ((Fit 0) (And z (s z)))))

;; Infer type of Fit
!(assertAlphaEqual
  (bc &kb Nil Z (: Fit $t))
  (: Fit (-> (: $ftns Number) (-> (: $cnd Boolean) Type))))

;; Infer type of (Fit $ftns), assuming that $ftns is of type Number
!(assertAlphaEqual
  (bc &kb
      (Cons (: $ftns Number) Nil)
      (fromNumber 1)
      (: (Fit $ftns) $t))
  (: (Fit $ftns) (-> (: $cnd Boolean) Type)))

;; Instantiate sigma type rule for the Fit predicate, assuming that
;; $ftns is of type Number.
!(assertEqual
  (bc &kb
      (Cons (: $ftns Number) Nil)
      Z (: $prf (-> (: (Fit $ftns) (-> (: $_ Boolean) Type))
                    (: $cnd Boolean)
                    (: $cpuprf ((Fit $ftns) $cnd))
                    (Σ Boolean (Fit $ftns)))))
  (: MkΣ (-> (: (Fit $ftns) (-> (: $_ Boolean) Type))
             (: $cnd Boolean)
             (: $cpuprf ((Fit $ftns) $cnd))
             (Σ Boolean (Fit $ftns)))))

;; Instantiate all candidates and their fitness scores up to depth 1,
;; assuming that $ftns is of type Number.
!(bc &kb
     (Cons (: z Boolean) (Cons (: (s z) Boolean) (Cons (: $ftns Number) Nil)))
     (fromNumber 2)
     (: $cnds (Σ Boolean (Fit $ftns))))
