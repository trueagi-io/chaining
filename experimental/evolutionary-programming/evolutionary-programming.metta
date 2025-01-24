;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Example of using the MeTTa backward chainer to do evolutionary          ;;
;; programming.  The idea is to delegate the search to the backward        ;;
;; chainer.  However, due to the lack of inference control, here, the      ;;
;; search equates to exhaustive enumeration.                               ;;
;;                                                                         ;;
;; In order to avoid                                                       ;;
;;                                                                         ;;
;; 1. conflict between the built-in type checker and the backward chainer, ;;
;; 2. spontaneous reduction of terms like (and True False),                ;;
;;                                                                         ;;
;; the vocabulary of the representational language is renamed as follows   ;;
;;                                                                         ;;
;; * Bool -> 𝐁𝐨𝐨𝐥                                                          ;;
;; * True -> 𝐓𝐫𝐮𝐞                                                          ;;
;; * False -> 𝐅𝐚𝐥𝐬𝐞                                                        ;;
;; * and -> 𝐚𝐧𝐝                                                            ;;
;; * or -> 𝐨𝐫                                                              ;;
;; * not -> 𝐧𝐨𝐭                                                            ;;
;;                                                                         ;;
;; using unicode characters.                                               ;;
;;                                                                         ;;
;; Variables are represented by DeBruijn Indices:                          ;;
;;                                                                         ;;
;; * 1st argument: z                                                       ;;
;; * 2nd argument: (s z)                                                   ;;
;; * 3rd argument: (s (s z))                                               ;;
;;                                                                         ;;
;; etc.                                                                    ;;
;;                                                                         ;;
;;                                                                         ;;
;; To reframe evolutionary programming as a form of reasoning, we          ;;
;; express the query of finding inhabitants of the type expressing the     ;;
;; class of *fit programs*.  To acheive that we use a Sigma type.  The     ;;
;; full query looks like                                                   ;;
;;                                                                         ;;
;; (: $fitcnd (Σ 𝐁𝐨𝐨𝐥 (Fit $ftns)))                                        ;;
;;                                                                         ;;
;; where                                                                   ;;
;;                                                                         ;;
;; * $fitcnd is a hole for a dependent pair containing a candidate and     ;;
;;   a proof that it is fit.                                               ;;
;; * $ftns is a hole for a number representing the degree of fitness.      ;;
;; * Fit is a type constructor expressing a subclass of 𝐁𝐨𝐨𝐥, taking as    ;;
;;   argument the degree of fitness.                                       ;;
;;                                                                         ;;
;; Results from such query may look like                                   ;;
;;                                                                         ;;
;; (: (MkΣ (Fit 0) (𝐚𝐧𝐝 (s z) z) CPU) (Σ 𝐁𝐨𝐨𝐥 (Fit 0)))                   ;;
;; (: (MkΣ (Fit -1) (𝐨𝐫 𝐅𝐚𝐥𝐬𝐞 𝐅𝐚𝐥𝐬𝐞) CPU) (Σ 𝐁𝐨𝐨𝐥 (Fit -1)))               ;;
;; ...                                                                     ;;
;;                                                                         ;;
;; The first result expresses that (𝐚𝐧𝐝 (s z) z) belongs to the class      ;;
;; of fittest candidates, because 0 indicates no classification            ;;
;; error.  The second result expresses that (𝐨𝐫 𝐅𝐚𝐥𝐬𝐞 𝐅𝐚𝐥𝐬𝐞) belongs        ;;
;; to the class of less fit candidates, because -1 indicates one           ;;
;; classification error.  The proof in all cases in merely CPU because     ;;
;; it is in fact delegated to an evaluation function that takes place      ;;
;; outside of reasoning, but is triggered by reasoning.                    ;;
;;                                                                         ;;
;; A likely possible alternative to using a Sigma type would be to use     ;;
;; a subtyping relationship.  Meaning that a fit candidate would           ;;
;; be an inhabitant of a subtype of boolean expressions.  This             ;;
;; could be expressed as                                                   ;;
;;                                                                         ;;
;; (<: (Fit $ftns) 𝐁𝐨𝐨𝐥)                                                   ;;
;; (: $cnd (Fit $ftns))                                                    ;;
;;                                                                         ;;
;; but is left for a future experiment.                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
  (is-closed (𝐚𝐧𝐝 𝐓𝐫𝐮𝐞 (𝐨𝐫 $x 𝐅𝐚𝐥𝐬𝐞)))
  False)
!(assertEqual
  (is-closed (𝐨𝐫 (𝐧𝐨𝐭 𝐅𝐚𝐥𝐬𝐞) 𝐓𝐫𝐮𝐞))
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
;; 𝐁𝐨𝐨𝐥 -> 𝐁𝐨𝐨𝐥 -> 𝐁𝐨𝐨𝐥
;;
;; meaning it is a binary boolean function, thus has 2 arguments, we
;; add the following two declarations in the environment
;;
;; (: z 𝐁𝐨𝐨𝐥)
;; (: (s z) 𝐁𝐨𝐨𝐥)
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
;;   (Cons (: z 𝐁𝐨𝐨𝐥) (Cons (: (s z) 𝐁𝐨𝐨𝐥) Nil))
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
(= (evaluate 𝐓𝐫𝐮𝐞 $inputs) 𝐓𝐫𝐮𝐞)
(= (evaluate 𝐅𝐚𝐥𝐬𝐞 $inputs) 𝐅𝐚𝐥𝐬𝐞)
;; Variables.  Note that if the DeBruijn index is greater than the
;; length of the tuple corresponding to the input arguments, MeTTa
;; will raise an error.
(= (evaluate z $inputs) (car-atom $inputs))
(= (evaluate (s $k) $inputs) (let $tail (cdr-atom $inputs) (evaluate z $tail)))
;; Operators
(= (evaluate (𝐚𝐧𝐝 $x $y) $inputs)
   (if (== (evaluate $x $inputs) 𝐓𝐫𝐮𝐞)
       (evaluate $y $inputs)
       𝐅𝐚𝐥𝐬𝐞))
(= (evaluate (𝐨𝐫 $x $y) $inputs)
   (if (== (evaluate $x $inputs) 𝐅𝐚𝐥𝐬𝐞)
       (evaluate $y $inputs)
       𝐓𝐫𝐮𝐞))
(= (evaluate (𝐧𝐨𝐭 $x) $inputs)
   (if (== (evaluate $x $inputs) 𝐅𝐚𝐥𝐬𝐞)
       𝐓𝐫𝐮𝐞
       𝐅𝐚𝐥𝐬𝐞))

;; Test evaluate
!(assertEqual
  (evaluate 𝐓𝐫𝐮𝐞 (𝐅𝐚𝐥𝐬𝐞 𝐓𝐫𝐮𝐞))
  𝐓𝐫𝐮𝐞)
!(assertEqual
  (evaluate z (𝐅𝐚𝐥𝐬𝐞 𝐓𝐫𝐮𝐞))
  𝐅𝐚𝐥𝐬𝐞)
!(assertEqual
  (evaluate (𝐨𝐫 𝐓𝐫𝐮𝐞 z) (𝐅𝐚𝐥𝐬𝐞 𝐓𝐫𝐮𝐞))
  𝐓𝐫𝐮𝐞)
!(assertEqual
  (evaluate (𝐚𝐧𝐝 (𝐨𝐫 𝐓𝐫𝐮𝐞 z) (s z)) (𝐅𝐚𝐥𝐬𝐞 𝐓𝐫𝐮𝐞))
  𝐓𝐫𝐮𝐞)

;; Evaluation correctness function.  Given a candidate and a pair
;; (INPUTS OUTPUT), compare the output of the candidate with the
;; output of the pair, return True if their outputs are equal, False
;; otherwise.  Provided in curried form for convenience.
(: evaluate-correctness (-> Atom (-> Expression Bool)))
(= ((evaluate-correctness $cnd) ($inputs $output))
   (== $output (evaluate $cnd $inputs)))

;; Test evaluate-correctness
!(assertEqual
  ((evaluate-correctness 𝐓𝐫𝐮𝐞) ((𝐅𝐚𝐥𝐬𝐞 𝐓𝐫𝐮𝐞) 𝐓𝐫𝐮𝐞))
  True)
!(assertEqual
  ((evaluate-correctness (𝐚𝐧𝐝 (𝐨𝐫 𝐓𝐫𝐮𝐞 z) (s z))) ((𝐅𝐚𝐥𝐬𝐞 𝐓𝐫𝐮𝐞) 𝐓𝐫𝐮𝐞))
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
          ($truth-table (((𝐓𝐫𝐮𝐞 𝐓𝐫𝐮𝐞) 𝐓𝐫𝐮𝐞)
                         ((𝐓𝐫𝐮𝐞 𝐅𝐚𝐥𝐬𝐞) 𝐅𝐚𝐥𝐬𝐞)
                         ((𝐅𝐚𝐥𝐬𝐞 𝐓𝐫𝐮𝐞) 𝐅𝐚𝐥𝐬𝐞)
                         ((𝐅𝐚𝐥𝐬𝐞 𝐅𝐚𝐥𝐬𝐞) 𝐅𝐚𝐥𝐬𝐞)))
          ;; Get tuple of correctness of outputs
          ($corrects (map (evaluate-correctness $cnd) $truth-table)))
     ;; Count of the number errors
     (foldr + 0 (map correctness-to-number $corrects))))

;; Test fitness
!(assertEqual
  (fitness 𝐓𝐫𝐮𝐞)
  -3)
!(assertEqual
  (fitness (𝐚𝐧𝐝 z (s z)))
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
;; 𝐁𝐨𝐨𝐥 instead of Bool to make sure it does interfere the built-in
;; Bool type.
!(add-atom &kb (: 𝐚𝐧𝐝 (-> (: $x 𝐁𝐨𝐨𝐥) (: $y 𝐁𝐨𝐨𝐥) 𝐁𝐨𝐨𝐥)))
!(add-atom &kb (: 𝐨𝐫 (-> (: $x 𝐁𝐨𝐨𝐥) (: $y 𝐁𝐨𝐨𝐥) 𝐁𝐨𝐨𝐥)))
!(add-atom &kb (: 𝐧𝐨𝐭 (-> (: $x 𝐁𝐨𝐨𝐥) 𝐁𝐨𝐨𝐥)))
!(add-atom &kb (: 𝐓𝐫𝐮𝐞 𝐁𝐨𝐨𝐥))
!(add-atom &kb (: 𝐅𝐚𝐥𝐬𝐞 𝐁𝐨𝐨𝐥))

;; Define fitness predicate.  It takes 2 arguments
;; 1. a number representing the fitness of
;; 2. a given candidate.
;;
;; The type of the candidate is merely Bool because the programs being
;; evolved are boolean expressions.
!(add-atom &kb
           (: Fit (-> (: $ftns Number)
                      (-> (: $cnd 𝐁𝐨𝐨𝐥)
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
      (Cons (: z 𝐁𝐨𝐨𝐥) (Cons (: (s z) 𝐁𝐨𝐨𝐥) Nil))
      Z
      (: $cnd 𝐁𝐨𝐨𝐥))
  ((: 𝐓𝐫𝐮𝐞 𝐁𝐨𝐨𝐥)
   (: 𝐅𝐚𝐥𝐬𝐞 𝐁𝐨𝐨𝐥)
   (: z 𝐁𝐨𝐨𝐥)
   (: (s z) 𝐁𝐨𝐨𝐥)))

;; Generate candidates up to depth 1 (assuming a unary function)
!(assertEqualToResult
  (bc &kb
      (Cons (: z 𝐁𝐨𝐨𝐥) Nil)
      (fromNumber 1)
      (: $cnd 𝐁𝐨𝐨𝐥))
  ((: 𝐓𝐫𝐮𝐞 𝐁𝐨𝐨𝐥)
   (: 𝐅𝐚𝐥𝐬𝐞 𝐁𝐨𝐨𝐥)
   (: z 𝐁𝐨𝐨𝐥)
   (: (𝐨𝐫 𝐓𝐫𝐮𝐞 𝐓𝐫𝐮𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐨𝐫 𝐓𝐫𝐮𝐞 𝐅𝐚𝐥𝐬𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐨𝐫 𝐓𝐫𝐮𝐞 z) 𝐁𝐨𝐨𝐥)
   (: (𝐨𝐫 𝐅𝐚𝐥𝐬𝐞 𝐓𝐫𝐮𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐨𝐫 𝐅𝐚𝐥𝐬𝐞 𝐅𝐚𝐥𝐬𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐨𝐫 𝐅𝐚𝐥𝐬𝐞 z) 𝐁𝐨𝐨𝐥)
   (: (𝐨𝐫 z 𝐓𝐫𝐮𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐨𝐫 z 𝐅𝐚𝐥𝐬𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐨𝐫 z z) 𝐁𝐨𝐨𝐥)
   (: (𝐚𝐧𝐝 𝐓𝐫𝐮𝐞 𝐓𝐫𝐮𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐚𝐧𝐝 𝐓𝐫𝐮𝐞 𝐅𝐚𝐥𝐬𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐚𝐧𝐝 𝐓𝐫𝐮𝐞 z) 𝐁𝐨𝐨𝐥)
   (: (𝐚𝐧𝐝 𝐅𝐚𝐥𝐬𝐞 𝐓𝐫𝐮𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐚𝐧𝐝 𝐅𝐚𝐥𝐬𝐞 𝐅𝐚𝐥𝐬𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐚𝐧𝐝 𝐅𝐚𝐥𝐬𝐞 z) 𝐁𝐨𝐨𝐥)
   (: (𝐚𝐧𝐝 z 𝐓𝐫𝐮𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐚𝐧𝐝 z 𝐅𝐚𝐥𝐬𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐚𝐧𝐝 z z) 𝐁𝐨𝐨𝐥)
   (: (𝐧𝐨𝐭 𝐓𝐫𝐮𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐧𝐨𝐭 𝐅𝐚𝐥𝐬𝐞) 𝐁𝐨𝐨𝐥)
   (: (𝐧𝐨𝐭 z) 𝐁𝐨𝐨𝐥)))

;; ;; Generate 1 candidate up to depth 2 (only works with MeTTaLog)
;; !(limit 1 (bc &kb Nil (fromNumber 1) (: $cnd 𝐁𝐨𝐨𝐥)))

;; Evaluate candidate 𝐓𝐫𝐮𝐞
!(assertEqual
  (bc &kb Nil Z (: $prf ((Fit $ftns) 𝐓𝐫𝐮𝐞)))
  (: CPU ((Fit -3) 𝐓𝐫𝐮𝐞)))

;; Evaluate candidate z
!(assertEqual
  (bc &kb (Cons (: z 𝐁𝐨𝐨𝐥) Nil) Z (: $prf ((Fit $ftns) z)))
  (: CPU ((Fit -1) z)))

;; Evaluate candidate (𝐨𝐫 z (s z))
!(assertEqual
  (bc &kb
      (Cons (: z 𝐁𝐨𝐨𝐥) (Cons (: (s z) 𝐁𝐨𝐨𝐥) Nil))
      Z
      (: $prf ((Fit $ftns) (𝐨𝐫 z (s z)))))
  (: CPU ((Fit -2) (𝐨𝐫 z (s z)))))

;; Evaluate candidate (𝐚𝐧𝐝 z (s z))
!(assertEqual
  (bc &kb
      (Cons (: z 𝐁𝐨𝐨𝐥) (Cons (: (s z) 𝐁𝐨𝐨𝐥) Nil))
      Z
      (: $prf ((Fit $ftns) (𝐚𝐧𝐝 z (s z)))))
  (: CPU ((Fit 0) (𝐚𝐧𝐝 z (s z)))))

;; Infer type of Fit
!(assertAlphaEqual
  (bc &kb Nil Z (: Fit $t))
  (: Fit (-> (: $ftns Number) (-> (: $cnd 𝐁𝐨𝐨𝐥) Type))))

;; Infer type of (Fit $ftns), assuming that $ftns is of type Number
!(assertAlphaEqual
  (bc &kb
      (Cons (: $ftns Number) Nil)
      (fromNumber 1)
      (: (Fit $ftns) $t))
  (: (Fit $ftns) (-> (: $cnd 𝐁𝐨𝐨𝐥) Type)))

;; Instantiate sigma type rule for the Fit predicate, assuming that
;; $ftns is of type Number.
!(assertEqual
  (bc &kb
      (Cons (: $ftns Number) Nil)
      Z (: $prf (-> (: (Fit $ftns) (-> (: $_ 𝐁𝐨𝐨𝐥) Type))
                    (: $cnd 𝐁𝐨𝐨𝐥)
                    (: $cpuprf ((Fit $ftns) $cnd))
                    (Σ 𝐁𝐨𝐨𝐥 (Fit $ftns)))))
  (: MkΣ (-> (: (Fit $ftns) (-> (: $_ 𝐁𝐨𝐨𝐥) Type))
             (: $cnd 𝐁𝐨𝐨𝐥)
             (: $cpuprf ((Fit $ftns) $cnd))
             (Σ 𝐁𝐨𝐨𝐥 (Fit $ftns)))))

;; Instantiate all candidates and their fitness scores up to depth 1,
;; assuming that $ftns is of type Number.
!(bc &kb
     (Cons (: z 𝐁𝐨𝐨𝐥) (Cons (: (s z) 𝐁𝐨𝐨𝐥) (Cons (: $ftns Number) Nil)))
     (fromNumber 2)
     (: $fitcnd (Σ 𝐁𝐨𝐨𝐥 (Fit $ftns))))
