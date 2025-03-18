;; Attempt to port the propositional calculus of
;;
;; https://us.metamath.org/mpeuni/mmtheorems1.html
;;
;; alongside a few theorems for the backward chainer

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
;;
;; A result is the query with its variables grounded, fully or
;; partially.  If multiple results are possible, they are returned as
;; a superposition.
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

;; Recursive step
;; Unary proof application
(= (bc $kb $env (S $k) (: ($prfabs $prfarg) $thrm))
   (let* (;; Recurse on unary rule
          ((: $prfabs (-> $prms $thrm))
           (bc $kb $env $k (: $prfabs (-> $prms $thrm))))
          ;; Recurse on premise
          ((: $prfarg $prms)
           (bc $kb $env $k (: $prfarg $prms))))
     (: ($prfabs $prfarg) $thrm)))

;;;;;;;;;;;;;;;;;;;;
;; Knowledge base ;;
;;;;;;;;;;;;;;;;;;;;

;; Based on https://us.metamath.org/mpeuni/mmtheorems1.html
;;
;; References:
;;
;; [Margaris] Margaris, Angelo, First Order Mathematical Logic,
;; Blaisdell Publishing Company, Waltham, Massachusetts (1967)
;; [QA9.M327].

!(bind! &kb (new-space))

;; Rule 1 of [Hamilton] p. 73.
;; https://us.metamath.org/mpeuni/ax-mp.html
!(add-atom &kb (: ax-mp (-> $𝜑 (-> ($𝜑 → $𝜓) $𝜓))))

;; Axiom Simp. Axiom A1 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-1.html
!(add-atom &kb (: ax-1 ($𝜑 → ($𝜓 → $𝜑))))

;; Axiom Frege. Axiom A2 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-2.html
!(add-atom &kb (: ax-2 (($𝜑 → ($𝜓 → $𝜒)) → (($𝜑 → $𝜓) → ($𝜑 → $𝜒)))))

;; Axiom Transp. Axiom A3 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-3.html
!(add-atom &kb (: ax-3 (((¬ $𝜑) → (¬ $𝜓)) → ($𝜓 → $𝜑))))

;;;;;;;;;;
;; Test ;;
;;;;;;;;;;



;; Test https://us.metamath.org/mpeuni/mp2.html
;; !(bc &kb
;;      (Cons (: mp2.1 $𝜑)
;;            (Cons (: mp2.2 $𝜓)
;;                  (Cons (: mp2.3 ($𝜑 → ($𝜓 → $𝜒)))
;;                        Nil)))
;;      (fromNumber 2)
;;      (: $prf $𝜒))

!(bc &kb
     Nil
     (fromNumber 0)
     (: $prf (-> $𝜑                       ; mp2.1
                 (-> $𝜓                   ; mp2.2
                     (-> ($𝜑 → ($𝜓 → $𝜒)) ; mp2.3
                         $𝜒)))))          ; mp2
