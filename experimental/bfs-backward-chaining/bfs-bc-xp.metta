;; Breadth-first search backward chaining.  It works by iteratively
;; generating macro rules (lemmas) using dedicated combinators.

;; In search for the combinators
;;
;; From https://hackage.haskell.org/package/data-aviary-0.4.0/docs/Data-Aviary-Birds.html
;;
;; we find relevant combinator
;;
;; - [blackbird](https://hackage.haskell.org/package/data-aviary-0.4.0/docs/src/Data-Aviary-Birds.html#blackbird)
;;   - type: (c -> d) -> (a -> b -> c) -> a -> b -> d
;;   - definition: blackbird f g x y = f (g x y)
;;
;; - ?
;;   - type: (c -> d -> e) -> (a -> b -> d) -> c -> a -> b -> e
;;   - definition: g >>:> h = \c a b -> g c (h a b)
;;
;; - [eagle](https://hackage.haskell.org/package/data-aviary-0.4.0/docs/src/Data-Aviary-Birds.html#eagle)
;;   - type (a -> d -> e) -> a -> (b -> c -> d) -> b -> c -> e
;;   - definition: eagle f x g y z = f x (g y z)
;;
;; Candidate: eaglebald, goldfinch

;; How it works
;;
;; Given theorem TH
;; Iteration 0:
;; (: $x $a)
;;
;; Iteration 1:
;; (: ax-mp (-> (→ $a $b) $a $b))
;;
;; Iteration 2:
;; (: ax-mp (-> (→ $a $b) $a $b))
;; - Gen ->
;; 1. (: (λ x y z (ax-mp x (ax-mp y z))) (-> (→ $a $c) (→ $b $a) $b $c))
;; 2. (: (λ x y z (ax-mp (ax-mp x y) z)) (-> (→ $b (→ $a $c)) $b $a $c))
;; 3. (: (λ x y z w (ax-mp (ax-mp x y) (ax-mp z w)) ?)) ???
;;
;; Iteration 3:
;; 

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
   (let* (((: $f (-> $a $b)) (bc $kb $env $idx $k (: $f (-> $a $b))))
          ((: $x $a) (bc $kb $env $idx $k (: $x $a))))
     (: ($f $x) $b)))
;; Proof abstraction
(= (bc $kb $env $x (S $k) (: (λ $x $y) (-> $a $b)))
   (let (: $y $b)
     (bc $kb (Cons (: $x $a) $env) (s $x) $k (: $y $b))
     (: (λ $x $y) (-> $a $b))))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;; ;;
;; ;; Knowledge Bases ;; ;;
;; ;;;;;;;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

!(bind! &kb (new-space))

;; Modus ponens (curried representation)
!(add-atom &kb (: mp (-> (→ $a $b)
                         (-> $a
                             $b))))

;; Blackbird
!(add-atom &kb (: .: (-> (-> $c $d)
                         (-> (-> $a (-> $b $c))
                             (-> $a
                                 (-> $b
                                     $d))))))

;; Blackbird specialized for mp
;; .mp = (λ z ((.: z) mp))
!(add-atom &kb (: .mp (-> (-> $b $c)
                          (-> (→ $a $b)
                              (-> $a
                                  $c)))))

;; NEXT: write reduction rules to turn composition into application.
;; NEXT: find way to inner apply .mp (hint: have the bc discover it).
;; NEXT: prune search by only allowing inner to outer.

;;;;;;;;;;
;; Main ;;
;;;;;;;;;;

;; !(bc &kb Nil z (fromNumber 0) (: $x $a))
;; !(bc &kb Nil z (fromNumber 1) (: $x (-> $a (-> $b 𝜑))))
;; !(bc &kb Nil z (fromNumber 2) (: ((λ z z) mp) (-> $a (-> $b 𝜑))))
;; !(bc &kb Nil z (fromNumber 2) (: ((λ z z) $x) $a))
;; !(bc &kb Nil z (fromNumber 2) (: $x (-> $a (-> $b (-> $c (-> $d 𝜑))))))
;; !(bc &kb Nil z (fromNumber 2) (: $x (-> $a (-> $b (-> $c (-> $d 𝜑))))))

;; !(bc &kb Nil z (fromNumber 2) (: (.mp (.mp mp)) $a))
!(bc &kb Nil z (fromNumber 0) (: .mp $a))
!(bc &kb Nil z (fromNumber 3) (: (λ z ((.: z) mp)) $a))
;; !(bc &kb Nil z (fromNumber 4) (: $x (-> (-> b c)
;;                                         (-> (→ a b)
;;                                             (-> a
;;                                                 c)))))
;; !(bc &kb Nil z (fromNumber 4) (: (λ z $y)
;;                                  (-> (-> b c)
;;                                      (-> (→ a b)
;;                                          (-> b
;;                                              c)))))
;; !(bc &kb Nil z (fromNumber 5) (: ((.: mp) mp) $a))
