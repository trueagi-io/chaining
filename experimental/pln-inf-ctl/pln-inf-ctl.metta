;; Inference control experiment using PLN as inference controller.
;;
;; The corpus is based on the propositional calculus of
;;
;; https://us.metamath.org/mpeuni/mmtheorems1.html

;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;; ;;
;; ;; Utils ;; ;;
;; ;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;; ;;
;; ;; Backward chainer ;; ;;
;; ;;;;;;;;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; For now we write a backward chainer that is specialized for the
;; propositional calculus of MetaMath.  The inference control
;; simulates a Thompson sampling selection (though totally random for
;; now), that is a random number is associated to each path of
;; possible non-deterministic reductions, and only the path with the
;; greatest number is taken.  Also, to make the random selection
;; easier to implement, to have more control over the non-determinism,
;; the coding style is monolithic.
(: bc (-> (List $b)                     ; Environment
          Nat                           ; Maximum depth
          $c                            ; Query
          $c))                          ; Result

;;;;;;;;;;;;;;;;
;; Base cases ;;
;;;;;;;;;;;;;;;;

;; Match the environment
(= (bc-env $env (: $prf $thrm))
   (match' $env (: $prf $thrm) (: $prf $thrm)))

;; Axiom Simp. Axiom A1 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-1.html
(= (bc-ax-1 (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))

;; Axiom Frege. Axiom A2 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-2.html
(= (bc-ax-2 (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))

;; Axiom Transp. Axiom A3 of [Margaris] p. 49.
;; https://us.metamath.org/mpeuni/ax-3.html
(= (bc-ax-3 (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))

;;;;;;;;;;;;;;;;;;;;
;; Recursive step ;;
;;;;;;;;;;;;;;;;;;;;

;; Rule 1 of [Hamilton] p. 73.
;; https://us.metamath.org/mpeuni/ax-mp.html
(= (bc-ax-mp $env (S $k) (: (ax-mp $prfarg1 $prfarg2) $𝜓))
   (let* (;; Recurse on premise 1
          ((: $prfarg1 $𝜑) (bc $env $k (: $prfarg1 $𝜑)))
          ;; Recurse on premise 2
          ((: $prfarg2 (→ $𝜑 $𝜓)) (bc $env $k (: $prfarg2 (→ $𝜑 $𝜓)))))
     (: (ax-mp $prfarg1 $prfarg2) $𝜓)))

;;;;;;;;;;;;;;
;; Monolith ;;
;;;;;;;;;;;;;;

;; NEXT: create non-deterministic eb (evaluate branch) function that
;;       returns a score and function to apply.

;; For now implement a polylithic way just to test that it works
(= (bc $env $depth (: $prf $thrm))
   (bc-env $env (: $prf $thrm)))
(= (bc $env $depth (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
   (bc-ax-1 (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑)))))
(= (bc $env $depth (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
   (bc-ax-2 (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))))))
(= (bc $env $depth (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))
   (bc-ax-3 (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)))))
(= (bc $env (S $k) (: (ax-mp $prfarg1 $prfarg2) $𝜓))
   (bc-ax-mp $env (S $k) (: (ax-mp $prfarg1 $prfarg2) $𝜓)))

;;;;;;;;;;;;;;;;
;; ;;;;;;;;;; ;;
;; ;; Test ;; ;;
;; ;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;

;; Test subgoal of https://us.metamath.org/mpeuni/mp2.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
!(bc (Cons (: mp2.1 𝜑)
           (Cons (: mp2.2 𝜓)
                 (Cons (: mp2.3 (→ 𝜑 (→ 𝜓 𝜒)))
                       Nil)))
     (fromNumber 1)
     ;; (: (ax-mp mp2.1 mp2.3) (→ 𝜓 𝜒)))
     (: $prf (→ 𝜓 𝜒)))

;; Test https://us.metamath.org/mpeuni/mp2.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
!(bc (Cons (: mp2.1 𝜑)
           (Cons (: mp2.2 𝜓)
                 (Cons (: mp2.3 (→ 𝜑 (→ 𝜓 𝜒)))
                       Nil)))
     (fromNumber 2)
     ;; (: (ax-mp mp2.2 (ax-mp mp2.1 mp2.3)) 𝜒))
     (: $prf 𝜒))

;; Test https://us.metamath.org/mpeuni/mp2b.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
!(bc (Cons (: mp2b.1 𝜑)
           (Cons (: mp2b.2 (→ 𝜑 𝜓))
                 (Cons (: mp2b.3 (→ 𝜓 𝜒))
                       Nil)))
     (fromNumber 2)
     ;; (: (ax-mp (ax-mp mp2b.1 mp2b.2) mp2b.3) 𝜒))
     (: $prf 𝜒))

;; Test https://us.metamath.org/mpeuni/a1i.html
;;
;; Note that variables have been replaced by symbols to force them to
;; be different which considerably prunes the search space.
!(bc (Cons (: a1i.1 𝜑) Nil)
     (fromNumber 1)
     ;; (: (ax-mp a1i.1 ax-1) (→ 𝜓 𝜑)))
     (: $prf (→ 𝜓 𝜑)))
