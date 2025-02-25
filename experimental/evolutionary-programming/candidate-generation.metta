;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Stripped down version of evolutionary-programming.metta, containing     ;;
;; on candidate generation.                                                ;;
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;
;; Knowledge base ;;
;;;;;;;;;;;;;;;;;;;;

!(bind! &kb (new-space))

;; Define the vocabulary of the programs to evolve.  We use the type
;; 𝐁𝐨𝐨𝐥 instead of Bool to make sure it does interfere the built-in
;; Bool type.
!(add-atom &kb (: 𝐚𝐧𝐝 (-> (: $x 𝐁𝐨𝐨𝐥) (: $y 𝐁𝐨𝐨𝐥) 𝐁𝐨𝐨𝐥)))
!(add-atom &kb (: 𝐨𝐫 (-> (: $x 𝐁𝐨𝐨𝐥) (: $y 𝐁𝐨𝐨𝐥) 𝐁𝐨𝐨𝐥)))
!(add-atom &kb (: 𝐧𝐨𝐭 (-> (: $x 𝐁𝐨𝐨𝐥) 𝐁𝐨𝐨𝐥)))
!(add-atom &kb (: 𝐓𝐫𝐮𝐞 𝐁𝐨𝐨𝐥))
!(add-atom &kb (: 𝐅𝐚𝐥𝐬𝐞 𝐁𝐨𝐨𝐥))

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
