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

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Curried Backward Chainer.  There is no explicit support for lambda
;; abstraction due to the combinatorial explosion resulting from
;; combining lambda and application.  Instead, variables are
;; explicitly added to the knowledge base.  So for instance, if the
;; program to synthesize has the following type signature
;;
;; Boolean -> Boolean -> Boolean
;;
;; meaning it is a binary boolean function, thus has 2 arguments, we
;; add the following two declarations in the knowledge base
;;
;; (: x Boolean)
;; (: y Boolean)
;;
;; where x and y represents the variables associated with the
;; arguments.  In order to draw an arbitrary number of variables, one
;; may use DeBruijn index where z represents the first variable, (s z)
;; the second, (s (s z)) the third, etc.
;;
;; The arguments of the backward chainer are:
;;
;; * Knowledge base: pointer to a space containing axioms and rules in
;;   the format (: <NAME> <RULE>).  Note that rules are explicitely
;;   curried, meaning that a rule with two premises is represented by
;;
;;   (: <NAME> (-> <PREMISE1> (-> <PREMISE2> <CONCLUSION>)))
;;
;;   In addition, each premise must be an inline typing relationship,
;;   to represent dependent types.  It should be noted that such
;;   typing relationship must be provided even if the witness is not
;;   present in the rest of the definition.  For instance <PREMISE1>
;;   would have the format (NEXT: do we really need that?)
;;
;;   (: <TERM1> <TYPE1>)
;;
;; * Maximum depth: maximum depth of the generated proof tree.
;;
;; * Query: a metta term of the form (: <PROOF> <THEOREM>) where
;;   <PROOF> and <THEOREM> may contain free variables that may be
;;   filled by the backward chainer.
(: bc (-> $a                            ; Knowledge base space
          Nat                           ; Maximum depth
          $c                            ; Query
          $c))                          ; Result

;; Base case: match the knowledge base
(= (bc $kb $_ (: $prf $thrm))
   (match $kb (: $prf $thrm) (: $prf $thrm)))
;; Recursive steps
;; Unary proof application
(= (bc $kb (S $k) (: ($prfabs $prfarg) $thrm))
   (let* (;; Recurse on unary rule
          ((: $prfabs (-> (: $prfarg $prms) $thrm))
           (bc $kb $k (: $prfabs (-> (: $prfarg $prms) $thrm))))
          ;; Recurse on premise
          ((: $prfarg $prms) (bc $kb $k (: $prfarg $prms))))
     (: ($prfabs (: $prfarg $prms)) $thrm)))
;; Binary proof application
(= (bc $kb (S $k) (: ($prfabs $prfarg1 $prfarg2) $thrm))
   (let* (;; Recurse on binary rule
          ((: $prfabs (-> (: $prfarg1 $prms1)
                          (: $prfarg2 $prms2)
                          $thrm))
           (bc $kb $k (: $prfabs (-> (: $prfarg1 $prms1)
                                     (: $prfarg2 $prms2)
                                     $thrm))))
          ;; Recurse on premise 1
          ((: $prfarg1 $prms1) (bc $kb $k (: $prfarg1 $prms1)))
          ;; Recurse on premise 2
          ((: $prfarg2 $prms2) (bc $kb $k (: $prfarg2 $prms2))))
     (: ($prfabs $prfarg1 $prfarg2) $thrm)))
;; Ternary proof application
(= (bc $kb (S $k) (: ($prfabs $prfarg1 $prfarg2 $prfarg3) $thrm))
   (let* (;; Recurse on ternary rule
          ((: $prfabs (-> (: $prfarg1 $prms1)
                          (: $prfarg2 $prms2)
                          (: $prfarg3 $prms3)
                          $thrm))
           (bc $kb $k (: $prfabs (-> (: $prfarg1 $prms1)
                                     (: $prfarg2 $prms2)
                                     (: $prfarg3 $prms3)
                                     $thrm))))
          ;; Recurse on premise 1
          ((: $prfarg1 $prms1) (bc $kb $k (: $prfarg1 $prms1)))
          ;; Recurse on premise 2
          ((: $prfarg2 $prms2) (bc $kb $k (: $prfarg2 $prms2)))
          ;; Recurse on premise 3
          ((: $prfarg3 $prms3) (bc $kb $k (: $prfarg3 $prms3))))
     (: ($prfabs $prfarg1 $prfarg2 $prfarg3) $thrm)))

;;;;;;;;;;;;;
;; Fitness ;;
;;;;;;;;;;;;;

;; Evaluation function.  Given a candidate and a tuple of values (the
;; input arguments), output the result of the evaluation of that
;; candidate on the arguments.
(: evaluate (-> Atom Expression Atom))
(= (evaluate T $inputs) T)
(= (evaluate F $inputs) F)
(= (evaluate x ($x $y)) $x)
(= (evaluate y ($x $y)) $y)
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
  (evaluate x (F T))
  F)
!(assertEqual
  (evaluate (Or T x) (F T))
  T)
!(assertEqual
  (evaluate (And (Or T x) y) (F T))
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
  ((evaluate-correctness (And (Or T x) y)) ((F T) T))
  True)

;; Output -1 when given False, 0 otherwise.
(: correctness-to-number (-> Bool Number))
(= (correctness-to-number True) 0)
(= (correctness-to-number False) -1)

;; Fitness function.  Assign a fitness score to a given candidate
;; corresponding to the number of incorrect answers compared to a
;; certain truth table (here binary conjunction).
(: fitness (-> Atom Number))
(= (fitness $cnd)
   (let* (;; Define a truth table
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
  (fitness (And x y))
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
!(add-atom &kb (: x Boolean))
!(add-atom &kb (: y Boolean))

;; Define fitness predicate.  It takes 2 arguments
;; 1. a number representing the fitness of
;; 2. a given candidate.
;;
;; The type of the candidate is merely Bool because the programs being
;; evolved are boolean expressions.
!(add-atom &kb
           (: Fit (-> (: $fit Number)
                      (-> (: $cnd Boolean)
                          Type))))

;; Completement the backward chainer with a custom call to calculate
;; the fitness of a given candidate.  At this point sub-symbolic
;; processing takes over for efficiency reason.  The proof is merely
;; represented by the symbol CPU.  It is as if the proof were saying
;; that "the fitness of the given candidate is such because the CPU
;; said so".  Because a CPU is a black box from the viewpoint of a
;; program, it conveys the idea that the backward chainer should trust
;; that black box and move on.
(= (bc &kb $_ (: CPU ((Fit $fit) $cnd)))
   (when (is-closed $cnd)
     (let $fit (fitness $cnd)
       (: CPU ((Fit $fit) $cnd)))))
