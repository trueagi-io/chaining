;; Breadth-first search backward chaining.  It works by iteratively
;; generating macro rules (lemmas) using dedicated combinators.
;;
;; By combining the bluebird and blackbird
;; [combinators](https://hackage.haskell.org/package/data-aviary-0.4.0/docs/src/Data-Aviary-Birds.html)
;; one can apply modus ponens backward while doing forward chaining.
;;
;; The blackbird operator can be used to create a specialized rule to
;; expand modus ponens backward on the first argument of any abstract
;; proof:
;;
;; .:mp = (λ z ((.: z) mp))
;;
;; with type signature
;;
;; (-> (-> $b $c)
;;     (-> (→ $a $b) (-> $a $c)))
;;
;; or in Haskell
;;
;; (b -> c) -> ((→ a b) -> a -> c)
;;
;; meaning this rule can turn any abstract proof of type (b -> c) into
;; am abstract proof of type (→ a b) -> a -> c.  In other words b is
;; replaced by (→ a b) -> a, i.e. a monus ponens expansion on the
;; first argument.
;;
;; Then the bluebird can be used to move this specialized rule to
;; expand modus ponens backward to any argument of any abstract proof:
;;
;; (. .:mp) to expand the second argument, (. (. .:mp)) to expand the
;; third argument, etc.

;; Disable co-unification
!(translatePredicate (set_prolog_flag occurs_check True))

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
   ;; (trace! (👁 bc-app $kb $env $idx (S $k) (: ($f $x) $b))
   (let* (((: $f (-> $a $b)) (bc $kb $env $idx $k (: $f (-> $a $b))))
          ((: $x $a) (bc $kb $env $idx $k (: $x $a))))
     (: ($f $x) $b)));)
;; Proof abstraction
(= (bc $kb $env $x (S $k) (: (λ $x $y) (-> $a $b)))
   ;; (trace! (👁 bc-abs $kb $env $x (S $k) (: (λ $x $y) (-> $a $b)))
   (let (: $y $b)
     (bc $kb (Cons (: $x $a) $env) (s $x) $k (: $y $b))
     (: (λ $x $y) (-> $a $b))));)

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

;;;;;;;;;;;;;;
;; Empty KB ;;
;;;;;;;;;;;;;;

;; Empty KN.  Convenient to limit the search to lambda expressions and
;; nothing else
!(bind! ∅-kb (new-space))

;;;;;;;;;;;;;;;;;;;;;
;; Modus Ponens KB ;;
;;;;;;;;;;;;;;;;;;;;;

;; KB with nothing but Modus Ponens
!(bind! &mp-kb (new-space))

;; Modus ponens (curried representation)
!(add-atom &mp-kb (: mp (-> (→ $a $b)
                            (-> $a
                                $b))))

;;;;;;;;;;;;;;;;
;; General KB ;;
;;;;;;;;;;;;;;;;

;; KB with Modus Ponens and a few combinators
!(bind! &gen-kb (new-space))

;; Modus ponens (curried representation)
!(add-atom &gen-kb (: mp (-> (→ $a $b)
                             (-> $a
                                 $b))))

;; Bluebird
!(add-atom &gen-kb (: . (-> (-> $b $c)
                            (-> (-> $a $b)
                                (-> $a
                                    $c)))))

;; Blackbird
!(add-atom &gen-kb (: .: (-> (-> $c $d)
                             (-> (-> $a (-> $b $c))
                                 (-> $a
                                     (-> $b
                                         $d))))))

;;;;;;;;;;;;;;;;;;;;
;; Specialized KB ;;
;;;;;;;;;;;;;;;;;;;;

;; KB with rules specialized for breadth-first search of propositional calculus
!(bind! &spe-kb (new-space))

;; Modus ponens (curried representation)
!(add-atom &spe-kb (: mp (-> (→ $a $b)
                             (-> $a
                                 $b))))

;; Bluebird
!(add-atom &spe-kb (: . (-> (-> $b $c)
                            (-> (-> $a $b)
                                (-> $a
                                    $c)))))

;; Blackbird specialized for mp
;; .:mp = (λ z ((.: z) mp))
!(add-atom &spe-kb (: .:mp (-> (-> $b $c)
                               (-> (→ $a $b)
                                   (-> $a
                                       $c)))))

;;;;;;;;;;
;; Main ;;
;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;
;; Test Empty KB ;;
;;;;;;;;;;;;;;;;;;;

;; ;; Rediscover bluebird and nothing else
;; !(test
;;   (bc &∅-kb Nil z (fromNumber 5) (: $x (-> (-> b c)
;;                                            (-> (-> a b)
;;                                                (-> a
;;                                                    c)))))
;;   (: (λ z (λ (s z) (λ (s (s z)) (z ((s z) (s (s z)))))))
;;      (-> (-> b c) (-> (-> a b) (-> a c)))))

;; ;; Rediscover blackbird and nothing else
;; ;; !(test
;; !(once (bc &∅-kb Nil z (fromNumber 6) (: $x (-> (-> c d)
;;                                                 (-> (-> a (-> b c))
;;                                                     (-> a
;;                                                         (-> b
;;                                                             d)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Modus Ponens KB ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Rediscover .:mp and nothing else
;; ;; !(test
;; !(bc &mp-kb Nil z (fromNumber 6) (: (λ z $x) (-> (-> b c) (-> (→ a b) (-> a c)))))
;;   ;; (: (λ z ((.: z) mp)) (-> (-> $b $c) (-> (→ $a $b) (-> $a $c)))))

;;;;;;;;;;;;;;;;;;;;;
;; Test General KB ;;
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Specialized KB ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Replace first argument by modus ponens
!(test
  (bc &spe-kb Nil z (fromNumber 0)
      (: .:mp (-> (-> $b $c)
                 (-> (→ $a $b) (-> $a $c)))))
  (: .:mp (-> (-> $b $c)
             (-> (→ $a $b) (-> $a $c)))))

;; Replace second argument by modus ponens
!(test
  (bc &spe-kb Nil z (fromNumber 1)
      (: (. .:mp) (-> (-> $a (-> $c $d))
                     (-> $a (-> (→ $b $c) (-> $b $d))))))
  (: (. .:mp) (-> (-> $a (-> $c $d))
                 (-> $a (-> (→ $b $c) (-> $b $d))))))

;; Replace third argument by modus ponens
!(test
  (bc &spe-kb Nil z (fromNumber 2)
      (: (. (. .:mp))
         (-> (-> $a (-> $b (-> $d $e)))
             (-> $a (-> $b (-> (→ $c $d) (-> $c $e)))))))
  (: (. (. .:mp))
     (-> (-> $a (-> $b (-> $d $e)))
         (-> $a (-> $b (-> (→ $c $d) (-> $c $e)))))))

;; NEXT: write reduction rules to turn composition into application.

;; NEXT: prune search by only allowing inner to outer.
