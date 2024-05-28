;; Implement functions to convert terms between MeTTa, lambda calculus
;; and combinatory logic.
;;
;; For the lambda calculus <-> combinatory logic part, the code is
;; inspired from the paper:
;;
;; A correct-by-construction conversion from lambda calculus to
;; combinatory logic, by Wouter Swierstra.
;;
;; As in the paper, the version of combinatory logic in consideration
;; is S, K, I.  In order not to have S, the combinator, be confused
;; with with S, the successor, we use the unicode characters 𝐒, 𝐊 and
;; 𝐈, as well as other similar unicode characters for more
;; combinators.  Also all functions are explicitly curried, thus 𝐊 x y
;; is represented in MeTTa as ((𝐊 x) y).
;;
;; On the lambda-calculus side, the MeTTa representation of a lambda
;; abstraction is (λ <VAR> <BODY>).  Applications are explicitly
;; curried as well, thus (x y z) is represented ((x y) z).
;;
;; An excellent source information about combinatory logic can be
;; found in this blog series
;;
;; https://farrugiamaths.quora.com/Combinatory-logic-Using-math-boldsymbol-mathsf-S-math-and-math-boldsymbol-mathsf-K-math-Part-1
;;
;; by Alexander Farrugia
;;
;; To test if our reduction rules and convertion algorithms between
;; lambda calculus and combinatory logic are correct we use arithmetic.
;;
;; For arithmetic in combinatory logic, see
;;
;; https://farrugiamaths.quora.com/Combinatory-logic-Natural-numbers-and-predicates-Part-6
;;
;; For arithmetic in lambda calculus, see
;;
;; https://en.wikipedia.org/wiki/Lambda_calculus#Arithmetic_in_lambda_calculus

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Common functions and types ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define DeBruijn type
(: DeBruijn Type)

;; Define DeBruijn constructors
(: Z' DeBruijn)                        ; Zero
(: S' (-> DeBruijn DeBruijn))          ; Successor

;; Define Maybe type
(: Maybe (-> $a Type))
(: Nothing (Maybe $a))
(: Just (-> $a (Maybe $a)))

;; Define list type
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

;; Define is-expression, a function that returns True iff the input is
;; a MeTTa expression, meaning it is not a symbol or a variable.
(: is-expression (-> Atom Bool))
(= (is-expression $x) (== (get-metatype $x) Expression))

;; Test is-expression
!(assertEqual (is-expression $x) False)
!(assertEqual (is-expression A) False)
!(assertEqual (is-expression (A B)) True)

;; Define is-variable, a function that returns True iff its input is a
;; MeTTa variable.
(: is-variable (-> Atom Bool))
(= (is-variable $x) (== (get-metatype $x) Variable))

;; Test is-variable
!(assertEqual (is-variable $x) True)
!(assertEqual (is-variable A) False)
!(assertEqual (is-variable (A $x)) False)

;; Define is-symbol, a function that returns True iff its input is a
;; MeTTa symbol.
(: is-symbol (-> Atom Bool))
(= (is-symbol $x) (== (get-metatype $x) Symbol))

;; Test is-symbol
!(assertEqual (is-symbol $x) False)
!(assertEqual (is-symbol A) True)
!(assertEqual (is-symbol (A $x)) False)

;; Till lazy or and and gets into the stdlib
(: lazy-or (-> Bool Atom Bool))
(= (lazy-or False $x) $x)
(= (lazy-or True $x) True)
(: lazy-and (-> Bool Atom Bool))
(= (lazy-and False $x) False)
(= (lazy-and True $x) $x)

;; Return True iff the first argument is a subterm of the second
;; argument.
;;
;; For instance
;;
;; (is-subterm-of A A) returns True
;; (is-subterm-of A (A B)) returns True
;; (is-subterm-of A B) returns False
;; (is-subterm-of A (B C)) returns False
;;
;; It should handle variables properly (that is assume that variables
;; with different names are different terms), for instance
;;
;; (is-subterm-of $x $x) returns True
;; (is-subterm-of $x ($x $y)) returns True
;; (is-subterm-of $x $y) returns False
;; (is-subterm-of $x ($y $z)) return False
;;
;; Terms can of course contain both symbols and variables, for
;; instance
;;
;; (is-subterm-of A ($x A)) returns True
;; (is-subterm-of $x ($x A)) returns True
;; (is-subterm-of A ($x B)) returns False
;; (is-subterm-of $x ($y A)) returns False
;;
;; It should of course detect a subterm when it is buried deeper
;; inside the superterm, for instance
;;
;; (is-subterm-of A (C (B A))) returns True
;; (is-subterm-of A (B (C D))) returns False
(: is-subterm-of (-> Atom Atom Bool))
(= (is-subterm-of $x $y)
   ;; Base cases
   (if (== $x $y)
       True
       (if (== $y ())
           False
           ;; Recursive step
           (if (is-expression $y)
               (lazy-or (let $head (car-atom $y) (is-subterm-of $x $head))
                        (let $tail (cdr-atom $y) (is-subterm-of $x $tail)))
               ;; Final base case
               False))))

;; Test is-subterm-of
!(assertEqual (is-subterm-of A A) True)
!(assertEqual (is-subterm-of A ()) False)
!(assertEqual (is-subterm-of A (A B)) True)
!(assertEqual (is-subterm-of A B) False)
!(assertEqual (is-subterm-of A (B C)) False)
!(assertEqual (is-subterm-of $x $x) True)
!(assertEqual (is-subterm-of $x ($x $y)) True)
!(assertEqual (is-subterm-of $x $y) False)
!(assertEqual (is-subterm-of $x ($y $z)) False)
!(assertEqual (is-subterm-of A ($x A)) True)
!(assertEqual (is-subterm-of $x ($x A)) True)
!(assertEqual (is-subterm-of A ($x B)) False)
!(assertEqual (is-subterm-of $x ($y A)) False)
!(assertEqual (is-subterm-of A (C (B A))) True)
!(assertEqual (is-subterm-of A (B (C D))) False)

;; Define α-Binding type, that represents a binding from a variable to
;; another variable.
(: α-Binding Type)
(: ↔α (-> Variable Variable α-Binding))

;; Insert an α-binding in a list of α-bindings.  Returns maybe the new
;; list of α-bindings if the insertion succeeded, that is the
;; α-binding is consistent with the list, or entirely missing from it.
(: α-insert (-> α-Binding (List α-Binding) (Maybe (List α-Binding))))
;; Base case
(= (α-insert (↔α $x $y) Nil) (Just (Cons (↔α $x $y) Nil)))
;; Recursive step
(= (α-insert (↔α $x $y) (Cons (↔α $z $w) $tail))
   (if (== $x $z)
       (if (== $y $w)
           (Just (Cons (↔α $z $w) $tail))
           Nothing)
       (if (== $y $w)
           Nothing
           (case (α-insert (↔α $x $y) $tail)
             ((Nothing Nothing)
              ((Just $νtl) (Just (Cons (↔α $z $w) $νtl))))))))

;; Test α-insert
!(assertEqual
  (α-insert (↔α $x $y) Nil)
  (Just (Cons (↔α $x $y) Nil)))
!(assertEqual
  (α-insert (↔α $x $y) (Cons (↔α $x $y) Nil))
  (Just (Cons (↔α $x $y) Nil)))
!(assertEqual
  (α-insert (↔α $x $y) (Cons (↔α $x $z) Nil))
  Nothing)
!(assertEqual
  (α-insert (↔α $x $y) (Cons (↔α $z $w) Nil))
  (Just (Cons (↔α $z $w) (Cons (↔α $x $y) Nil))))

;; Join two α-bindings to produce an α-bindings consisting of the
;; union of these.  If the two α-bindings provided in input are
;; inconsistent, or one of them in Nothing, then return Nothing.
(: α-join (-> (Maybe (List α-Binding))
              (Maybe (List α-Binding))
              (Maybe (List α-Binding))))
;; Base cases
(= (α-join Nothing Nothing) Nothing)
(= (α-join Nothing (Just $_)) Nothing)
(= (α-join (Just $_) Nothing) Nothing)
(= (α-join (Just Nil) (Just $other)) (Just $other))
;; Recursive step
(= (α-join (Just (Cons $head $tail)) (Just $other))
   (α-join (Just $tail) (α-insert $head $other)))

;; Test α-join
!(assertEqual
  (α-join Nothing Nothing)
  Nothing)
!(assertEqual
  (α-join (Just Nil) (Just Nil))
  (Just Nil))
!(assertEqual
  (α-join (Just Nil) (Just (Cons (↔α $x $y) Nil)))
  (Just (Cons (↔α $x $y) Nil)))
!(assertEqual
  (α-join (Just (Cons (↔α $x $y) Nil)) (Just Nil))
  (Just (Cons (↔α $x $y) Nil)))
!(assertEqual
  (α-join (Just Nil) (Just (Cons (↔α $x $y) Nil)))
  (Just (Cons (↔α $x $y) Nil)))
!(assertEqual
  (α-join (Just (Cons (↔α $x $y) Nil)) (Just (Cons (↔α $x $z) Nil)))
  Nothing)
!(assertEqual
  (α-join (Just (Cons (↔α $x $y) Nil)) (Just (Cons (↔α $x $y) Nil)))
  (Just (Cons (↔α $x $y) Nil)))
!(assertEqual
  (α-join (Just (Cons (↔α $x $y) Nil)) (Just (Cons (↔α $z $w) Nil)))
  (Just (Cons (↔α $z $w) (Cons (↔α $x $y) Nil))))

;; Given two terms, $lhs and $rhs, return maybe a list of α-bindings
;; so that if $lhs is α-equivalent to $rhs, substituting all variables
;; in $rhs according to the α-bindings would result in a term that is
;; equal to $lhs.  If $lhs and $rhs are not α-equivalent then return
;; Nothing.
(: α-bindings (-> Atom Atom (Maybe (List α-Binding))))
(= (α-bindings $lhs $rhs)
   (case (get-metatype $lhs)
     ((Symbol (if (== $lhs $rhs)
                  (Just Nil)
                  Nothing))
      (Grounded (if (== $lhs $rhs)
                    (Just Nil)
                    Nothing))
      (Variable (if (is-variable $rhs)
                    (Just (Cons (↔α $lhs $rhs) Nil))
                    Nothing))
      (Expression (if (== $lhs ())
                      ;; $lhs is ()
                      (if (== $rhs ())
                          (Just Nil)
                          Nothing)
                      ;; $lhs is not ()
                      (if (== $rhs ())
                          Nothing
                          (case (get-metatype $rhs)
                            ((Symbol Nothing)
                             (Grounded Nothing)
                             (Variable Nothing)
                             (Expression
                              (let* (($hd-lhs (car-atom $lhs))
                                     ($tl-lhs (cdr-atom $lhs))
                                     ($hd-rhs (car-atom $rhs))
                                     ($tl-rhs (cdr-atom $rhs))
                                     ($hd-α-bs (α-bindings $hd-lhs $hd-rhs))
                                     ($tl-α-bs (α-bindings $tl-lhs $tl-rhs)))
                                (α-join $hd-α-bs $tl-α-bs)))))))))))

;; Test α-bindings
!(assertEqual
  (α-bindings A B)
  Nothing)
!(assertEqual
  (α-bindings $x B)
  Nothing)
!(assertEqual
  (α-bindings () ())
  (Just Nil))
!(assertEqual
  (α-bindings (R $x) $y)
  Nothing)
!(assertEqual
  (α-bindings $x $y)
  (Just (Cons (↔α $x $y) Nil)))
!(assertEqual
  (α-bindings (R $x) (R $y))
  (Just (Cons (↔α $x $y) Nil)))
!(assertEqual
  (α-bindings ((R $x) A) ((R $y) $z))
  Nothing)
!(assertEqual
  (α-bindings ((R $x) $x) ((R $z) $w))
  Nothing)
!(assertEqual
  (α-bindings ((R $x) $y) ((R $z) $z))
  Nothing)
!(assertEqual
  (α-bindings (R $x (R $y)) (R $z $z))
  Nothing)
!(assertEqual
  (α-bindings ((R $x) $y) ((R $z) $w))
  (Just (Cons (↔α $y $w) (Cons (↔α $x $z) Nil))))

;; Return True iff two given terms are alpha-equivalent.  For now all
;; variables are assumed to be free, the notion of scope is not
;; implemented.
(: =α (-> $a $b Bool))
(= (=α $lhs $rhs) (case (α-bindings $lhs $rhs)
                    ((Nothing False)
                     ((Just $_) True))))

;; Test =α
!(assertEqual (=α $x $x) True)
!(assertEqual (=α $x $y) True)
!(assertEqual (=α A B) False)
!(assertEqual (=α A $y) False)
!(assertEqual (=α (R $x) (R $y)) True)
!(assertEqual (=α (R $x $x) (R $y $z)) False)
!(assertEqual (=α (R $x (R $y)) (R $z $z)) False)
!(assertEqual (=α (λ $x (λ $y $x)) (λ $z (λ $w $z))) True)

;;;;;;;;;;;;;;;;;;;;;
;; Reduction rules ;;
;;;;;;;;;;;;;;;;;;;;;

;; Due to double-sided matching, combinatory logic and lambda calculus
;; reduction rules cannot be emulated that easily.  Instead a reduce
;; function is implemented instead.

;; Reduce lambda application
;; (: λ (-> Variable $a (-> $b $c))) ; Problemantic for =α (no idea why)
;; (: λ (-> Variable Atom Atom)) ; Problematic for reduction
;; (= ((λ $x $f) $y) (let ($νx $νf) (sealed ($x) ($x $f)) (let $νx $y $νf)))

;; ;; Test lambda calculus reduction
;; !(assertEqual
;;   $x
;;   $x)
;; !(assertEqual
;;   ($f $x)
;;   ($f $x))
;; !(assertEqual
;;   (λ $x ($f $x))
;;   (λ $x ($f $x)))
;; !(assertEqual
;;   ((λ $x $x) $y)
;;   $y)
;; !(assertEqual
;;   ((λ $x $x) (λ $x $x))
;;   (λ $x $x))
;; !(assertEqual
;;   ((λ $f (λ $x $x)) $g)
;;   (λ $x $x))
;; !(assertEqual
;;   (λ $f (λ $x $x))                       ; 0
;;   (λ $f (λ $x $x)))
;; !(assertEqual
;;   (λ $f (λ $x ($f $x)))                  ; 1
;;   (λ $f (λ $x ($f $x))))
;; !(assertEqual
;;   (λ $n (λ $f (λ $x ($f (($n $f) $x))))) ; Successor
;;   (λ $n (λ $f (λ $x ($f (($n $f) $x))))))
;; ;; NEXT: re-enable assertEqual when duplicates are fixed.
;; ;; See issue https://github.com/trueagi-io/hyperon-experimental/issues/235
;; !(assertEqual
;;   ((λ $n (λ $f (λ $x (($n $x) ($f $x))))) ; 𝐒
;;    (λ $y (λ $z (λ $w ($y ($z $w))))))     ; 𝐁
;;   (λ $f (λ $x (λ $w ($x (($f $x) $w)))))) ; Successor
;; ;; NEXT: re-enable assertEqual when duplicates are fixed.
;; ;; See issue https://github.com/trueagi-io/hyperon-experimental/issues/235
;; ;; !(assertEqual
;; !((λ $n (λ $f (λ $x ($f (($n $f) $x)))))
;;   (λ $f (λ $x $x))) ; 1, successor of 0
;; ;; (λ $f (λ $x ($f $x))))
;; ;; !(assertEqual
;; !((λ $n (λ $f (λ $x ($f (($n $f) $x)))))  ; Successor
;;   ((λ $n (λ $f (λ $x ($f (($n $f) $x))))) ; Successor
;;    (λ $f (λ $x $x))))                     ; 0
;; ;; (λ $f (λ $x ($f ($f $x)))))            ; 2, the result of (Succ (Succ 0))
;; !(assertEqual
;;   (λ $m (λ $n (λ $f (λ $x (($m $f) (($n $f) $x)))))) ; Plus
;;   (λ $m (λ $n (λ $f (λ $x (($m $f) (($n $f) $x)))))))
;; ;; NEXT: re-enable assertEqual when duplicates are fixed.
;; ;; See issue https://github.com/trueagi-io/hyperon-experimental/issues/235
;; ;; !(assertEqual
;;  !((λ $m (λ $n (λ $f (λ $x (($m $f) (($n $f) $x)))))) ; Plus
;;    (λ $f (λ $x $x)))                                  ; 0
;;   ;; (λ $n (λ $f (λ $x (($n $f) $x)))))  ; (Plus 0)
;; ;; !(assertEqual
;;   !(((λ $m (λ $n (λ $f (λ $x (($m $f) (($n $f) $x)))))) ; Plus
;;     (λ $f (λ $x $x)))                                  ; 0
;;    (λ $f (λ $x $x)))                                   ; 0
;; ;;   (λ $f (λ $x $x)))  ; 0, the result of (Plus 0 0)
;; ;; !(assertEqual
;;  !(((λ $m (λ $n (λ $f (λ $x (($m $f) (($n $f) $x)))))) ; Plus
;;     (λ $f (λ $x ($f $x))))                             ; 1
;;    (λ $f (λ $x ($f ($f $x)))))                         ; 2
;; ;;   (λ $f (λ $x ($f ($f ($f $x))))))  ; 3, the result of (Plus 1 2)

;; Reduction rules for combinatory logic.  In the process, we
;; introduce combinators 𝐌, 𝐍, 𝐓, 𝐖, 𝐁, 𝐂 and 𝐔.
;; (= (𝐈 $x) $x)
;; (= ((𝐊 $x) $y) $x)
;; (= (((𝐒 $x) $y) $z) (($x $z) ($y $z)))
;; (= (𝐌 $x) ($x $x))
;; (= ((𝐍 $x) $y) $y)
;; (= ((𝐓 $x) $y) ($y $x))
;; (= ((𝐖 $x) $y) (($x $y) $y))
;; (= (((𝐁 $x) $y) $z) ($x ($y $z)))
;; (= (((𝐂 $x) $y) $z) (($x $z) $y))
;; (= ((𝐔 $x) $y) ($y (($x $x) $y)))
;; (= ((𝐒 𝐊) 𝐊) 𝐈)
;; (= ((𝐒 (𝐊 𝐊)) 𝐈) 𝐊)
;; (= ((𝐒 𝐈) 𝐈) 𝐌)
;; (= (𝐊 𝐈) 𝐍)
;; (= ((𝐒 (𝐊 (𝐒 𝐈))) 𝐊) 𝐓)
;; (= ((𝐒 𝐒) 𝐍) 𝐖)
;; (= ((𝐒 (𝐊 𝐒)) 𝐊) 𝐁)
;; (= ((𝐒 (𝐁 𝐁 𝐒)) (𝐊 𝐊)) 𝐂)
;; (= ((𝐁 (𝐒 𝐈)) (𝐒 𝐈 𝐈)) 𝐔)

;; ;; Test combinatory logic reduction
;; !(assertEqual
;;   (𝐊 𝐈)                                 ; 0
;;   𝐍)
;; !(assertEqual
;;   ((𝐒 (𝐊 𝐊)) 𝐈)
;;   𝐊)
;; !(assertEqual
;;   ((𝐒 (𝐊 𝐒)) 𝐊)
;;   𝐁)
;; !(assertEqual
;;   ((𝐒 𝐒) (𝐊 𝐈))
;;   𝐖)
;; !(assertEqual
;;   ((𝐒 𝐒) 𝐍)
;;   𝐖)
;; !(assertEqual
;;   (𝐒 ((𝐒 (𝐊 𝐒)) 𝐊))                    ; Successor
;;   (𝐒 𝐁))
;; !(assertEqual
;;   ((𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)) (𝐊 𝐈))            ; 1, as (Successor 0)
;;   ((𝐒 𝐁) 𝐍))
;; !(assertEqual
;;   ((𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)) ((𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)) (𝐊 𝐈))) ; 2, as (Successor (Successor 0))
;;   ((𝐒 𝐁) ((𝐒 𝐁) 𝐍)))
;; !(assertEqual
;;   (((𝐒 (𝐊 (𝐒 𝐈))) 𝐊) (𝐒 ((𝐒 (𝐊 𝐒)) 𝐊))) ; Plus
;;   (𝐓 (𝐒 𝐁)))
;; !(assertEqual
;;   ((((𝐒 𝐈) (𝐊 (𝐒 𝐁))) 𝐍) 𝐍)             ; Apparently this is equivalent to (Plus 0 0)
;;   𝐍)
;; !(assertEqual
;;   (((𝐓 (𝐒 𝐁)) 𝐍) 𝐍)
;;   𝐍)
;; !(assertEqual
;;   (((((𝐒 (𝐊 (𝐒 𝐈))) 𝐊) (𝐒 ((𝐒 (𝐊 𝐒)) 𝐊))) (𝐊 𝐈)) (𝐊 𝐈)) ; 0, as (Plus 0 0)
;;   𝐍)
;; !(assertEqual
;;   (((((𝐒 (𝐊 (𝐒 𝐈))) 𝐊) (𝐒 ((𝐒 (𝐊 𝐒)) 𝐊))) ((𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)) (𝐊 𝐈)))
;;    ((𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)) ((𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)) (𝐊 𝐈)))) ; 3, as (Plus 1 2)
;;   ((𝐒 𝐁) ((𝐒 𝐁) ((𝐒 𝐁) 𝐍))))

;; Reduce (𝐈 $x) to $x
(: 𝐈-reduce (-> $a (Maybe $a)))
(= (𝐈-reduce $term)
   (case $term
     ((($i $x) (if (== $i 𝐈) (Just $x) Nothing))
      ($_ Nothing))))

;; Reduce ((𝐊 $x) $y) to $x
(: 𝐊-reduce (-> $a (Maybe $a)))
(= (𝐊-reduce $term)
   (case $term
     (((($k $x) $y) (if (== $k 𝐊) (Just $x) Nothing))
      ($_ Nothing))))

;; Reduce (((𝐒 $x) $y) $z) to (($x $z) ($y $z))
(: 𝐒-reduce (-> $a (Maybe $a)))
(= (𝐒-reduce $term)
   (case $term
     ((((($s $x) $y) $z) (if (== $s 𝐒) (Just (($x $z) ($y $z))) Nothing))
      ($_ Nothing))))

;; Reduce (𝐌 $x) to ($x $x)
(: 𝐌-reduce (-> $a (Maybe $a)))
(= (𝐌-reduce $term)
   (case $term
     ((($m $x) (if (== $m 𝐌) (Just ($x $x)) Nothing))
      ($_ Nothing))))

;; Reduce ((𝐍 $x) $y) to $y
(: 𝐍-reduce (-> $a (Maybe $a)))
(= (𝐍-reduce $term)
   (case $term
     (((($n $x) $y) (if (== $n 𝐍) (Just $y) Nothing))
      ($_ Nothing))))

;; Reduce ((𝐓 $x) $y) to ($y $x)
(: 𝐓-reduce (-> $a (Maybe $a)))
(= (𝐓-reduce $term)
   (case $term
     (((($t $x) $y) (if (== $t 𝐓) (Just ($y $x)) Nothing))
      ($_ Nothing))))

;; Reduce ((𝐖 $x) $y) to (($x $y) $y)
(: 𝐖-reduce (-> $a (Maybe $a)))
(= (𝐖-reduce $term)
   (case $term
     (((($w $x) $y) (if (== $w 𝐖) (Just (($x $y) $y)) Nothing))
      ($_ Nothing))))

;; Reduce (((𝐁 $x) $y) $z) to ($x ($y $z))
(: 𝐁-reduce (-> $a (Maybe $a)))
(= (𝐁-reduce $term)
   (case $term
     ((((($b $x) $y) $z) (if (== $b 𝐁) (Just ($x ($y $z))) Nothing))
      ($_ Nothing))))

;; Reduce (((𝐂 $x) $y) $z) to (($x $z) $y)
(: 𝐂-reduce (-> $a (Maybe $a)))
(= (𝐂-reduce $term)
   (case $term
     ((((($c $x) $y) $z) (if (== $c 𝐂) (Just (($x $z) $y)) Nothing))
      ($_ Nothing))))

;; Reduce ((𝐔 $x) $y) to ($y (($x $x) $y))
(: 𝐔-reduce (-> $a (Maybe $a)))
(= (𝐔-reduce $term)
   (case $term
     (((($u $x) $y) (if (== $u 𝐔) (Just ($y (($x $x) $y))) Nothing))
      ($_ Nothing))))

;; Reduce ((λ $x $y) $z) to (let ($νx $νy) (sealed ($x) ($x $y)) (reduce (let $νx $z $νy)))
(: β-reduce (-> $a (Maybe $a)))
(= (β-reduce $term)
   (case $term
     (((($l $x $y) $z) (if (== $l λ) (Just (let ($νx $νy) (sealed ($x) ($x $y))
                                                (let $νx $z $νy))) Nothing))
      ($_ Nothing))))

;; Explicit reduction of combinatory logic and lambda calculus terms
;; to work around the lack of one-sided matching in reduction
(: reduce (-> $a $a))
(= (reduce $term)
   (case (get-metatype $term)
     ((Symbol $term)
      (Grounded $term)
      (Variable $term)
      (Expression
       ;; Base cases
       (if (== $term ())
           ()
           (if (== $term ((𝐒 𝐊) 𝐊))
               𝐈
               (if (== $term ((𝐒 (𝐊 𝐊)) 𝐈))
                   𝐊
                   (if (== $term ((𝐒 𝐈) 𝐈))
                       𝐌
                       (if (== $term (𝐊 𝐈))
                           𝐍
                           (if (== $term ((𝐒 (𝐊 (𝐒 𝐈))) 𝐊))
                               𝐓
                               (if (== $term ((𝐒 𝐒) 𝐍))
                                   𝐖
                                   (if (== $term ((𝐒 (𝐊 𝐒)) 𝐊))
                                       𝐁
                                       (if (== $term ((𝐒 (𝐁 𝐁 𝐒)) (𝐊 𝐊)))
                                           𝐂
                                           (if (== $term ((𝐁 (𝐒 𝐈)) (𝐒 𝐈 𝐈)))
                                               𝐔
                                               ;; Recursive steps
                                               (case $term
                                                 ;; Application
                                                 ((($f $g) (let* (($νf (reduce $f))
                                                                  ($νg (reduce $g)))
                                                             (if (and (== $νf $f) (== $νg $g))
                                                                 ;; $f and $g are already reduced,
                                                                 ;; try to match them to an known reduction rule
                                                                 (case (𝐈-reduce $term)
                                                                   (((Just $r) $r)
                                                                    (Nothing
                                                                     (case (𝐊-reduce $term)
                                                                       (((Just $r) $r)
                                                                        (Nothing
                                                                         (case (𝐒-reduce $term)
                                                                           (((Just $r) (reduce $r))
                                                                            (Nothing
                                                                             (case (𝐌-reduce $term)
                                                                               (((Just $r) (reduce $r))
                                                                                (Nothing
                                                                                 (case (𝐍-reduce $term)
                                                                                   (((Just $r) $r)
                                                                                    (Nothing
                                                                                     (case (𝐓-reduce $term)
                                                                                       (((Just $r) (reduce $r))
                                                                                        (Nothing
                                                                                         (case (𝐖-reduce $term)
                                                                                           (((Just $r) (reduce $r))
                                                                                            (Nothing
                                                                                             (case (𝐁-reduce $term)
                                                                                               (((Just $r) (reduce $r))
                                                                                                (Nothing
                                                                                                 (case (𝐂-reduce $term)
                                                                                                   (((Just $r) (reduce $r))
                                                                                                    (Nothing
                                                                                                     (case (𝐔-reduce $term)
                                                                                                       (((Just $r) (reduce $r))
                                                                                                        (Nothing
                                                                                                         (case (β-reduce $term)
                                                                                                           (((Just $r) (reduce $r))
                                                                                                            ;; No known reduction rule,
                                                                                                            ;; Return as it is
                                                                                                            (Nothing ($f $g))))
                                                                                                         )))
                                                                                                     )))
                                                                                                 )))
                                                                                             )))
                                                                                         )))
                                                                                     )))
                                                                                 )))
                                                                             )))
                                                                         )))
                                                                     )))
                                                                 (reduce ($νf $νg)))))
                                                  ;; Abstraction
                                                  ((λ $x $f) (λ $x (reduce $f)))))))))))))))))))

;; Test reduce on combinatory logic
!(assertEqual
  (reduce 𝐒)
  𝐒)
!(assertEqual
  (reduce ((𝐒 (𝐊 𝐊)) 𝐈))
  𝐊)
!(assertEqual
  (reduce (𝐊 𝐈))                          ; 0
  𝐍)
!(assertEqual
  (reduce (𝐒 𝐒))
  (𝐒 𝐒))
!(assertEqual
  (reduce ((𝐒 (𝐊 𝐒)) 𝐊))
  𝐁)
!(assertEqual
  (reduce ((𝐒 (𝐊 (𝐒 𝐈))) 𝐊))
  𝐓)
!(assertEqual
  (reduce ((𝐒 𝐒) (𝐊 𝐈)))
  𝐖)
!(assertEqual
  (reduce ((𝐒 𝐒) 𝐍))
  𝐖)
!(assertEqual
  (reduce (𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)))             ; Successor
  (𝐒 𝐁))
!(assertEqual
  (reduce ((𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)) (𝐊 𝐈)))     ; 1, as (Successor 0)
  ((𝐒 𝐁) 𝐍))
!(assertEqual
  (reduce ((𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)) ((𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)) (𝐊 𝐈)))) ; 2, as (Successor (Successor 0))
  ((𝐒 𝐁) ((𝐒 𝐁) 𝐍)))
!(assertEqual
  (reduce (𝐓 (𝐒 𝐁))) ; Plus
  (𝐓 (𝐒 𝐁)))
!(assertEqual
  (reduce (𝐓 (𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)))) ; Plus
  (𝐓 (𝐒 𝐁)))
!(assertEqual
  (reduce (((𝐒 (𝐊 (𝐒 𝐈))) 𝐊) (𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)))) ; Plus
  (𝐓 (𝐒 𝐁)))
!(assertEqual
  (reduce ((((𝐒 𝐈) (𝐊 (𝐒 𝐁))) 𝐍) 𝐍))    ; Apparently this is equivalent to (Plus 0 0)
  𝐍)
!(assertEqual
  (reduce (((𝐓 (𝐒 𝐁)) 𝐍) 𝐍))            ; 0, as (Plus 0 0)
  𝐍)
!(assertEqual
  (reduce (((((𝐒 (𝐊 (𝐒 𝐈))) 𝐊) (𝐒 ((𝐒 (𝐊 𝐒)) 𝐊))) (𝐊 𝐈)) (𝐊 𝐈))) ; 0, as (Plus 0 0)
  𝐍)
!(assertEqual
  (reduce (((((𝐒 (𝐊 (𝐒 𝐈))) 𝐊) (𝐒 ((𝐒 (𝐊 𝐒)) 𝐊))) ((𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)) (𝐊 𝐈)))
           ((𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)) ((𝐒 ((𝐒 (𝐊 𝐒)) 𝐊)) (𝐊 𝐈))))) ; 3, as (Plus 1 2)
  ((𝐒 𝐁) ((𝐒 𝐁) ((𝐒 𝐁) 𝐍))))

;; Test reduce on lambda calculus
!(assertEqual
  (reduce $x)
  $x)
!(assertEqual
  (reduce ($x $x))
  ($x $x))
!(assertEqual
  (reduce ($f $x))
  ($f $x))
!(assertEqual
  (reduce (λ $x ($f $x)))
  (λ $x ($f $x)))
!(assertEqual
  (reduce ((λ $x $x) $y))
  $y)
!(assertEqual
  (reduce ((λ $x $x) (λ $x $x)))
  (λ $x $x))
!(assertEqual
  (reduce ((λ $f (λ $x $x)) $g))
  (λ $x $x))
!(assertEqual
  (reduce (λ $f (λ $x $x)))                       ; 0
  (λ $f (λ $x $x)))
!(assertEqual
  (reduce (λ $f (λ $x ($f $x))))                  ; 1
  (λ $f (λ $x ($f $x))))
!(assertEqual
  !(reduce (($n $f) $x)) ; Successor subsubsubsubterm
  (($n $f) $x))
!(assertEqual
  !(reduce ($f (($n $f) $x))) ; Successor subsubsubterm
  ($f (($n $f) $x)))
!(assertEqual
  !(reduce (λ $x ($f (($n $f) $x)))) ; Successor subsubterm
  (λ $x ($f (($n $f) $x))))
!(assertEqual
  !(reduce (λ $f (λ $x ($f (($n $f) $x))))) ; Successor subterm
  (λ $f (λ $x ($f (($n $f) $x)))))
!(assertEqual
  !(reduce (λ $n (λ $f (λ $x ($f (($n $f) $x)))))) ; Successor
  (λ $n (λ $f (λ $x ($f (($n $f) $x))))))
;; NEXT: re-enable assertEqual when duplicates are fixed.
;; See issue https://github.com/trueagi-io/hyperon-experimental/issues/235
;; !(assertEqual
!(reduce ((λ $n (λ $f (λ $x ($f (($n $f) $x)))))
          (λ $f (λ $x $x)))) ; 1, successor of 0
;; (λ $f (λ $x ($f $x))))
;; !(assertEqual
!(reduce ((λ $n (λ $f (λ $x ($f (($n $f) $x)))))  ; Successor
          ((λ $n (λ $f (λ $x ($f (($n $f) $x))))) ; Successor
           (λ $f (λ $x $x)))))                    ; 0
;; (λ $f (λ $x ($f ($f $x)))))  ; 2, the result of (Succ (Succ 0))
!(assertEqual
  (reduce (λ $m (λ $n (λ $f (λ $x (($m $f) (($n $f) $x))))))) ; Plus
  (λ $m (λ $n (λ $f (λ $x (($m $f) (($n $f) $x)))))))
;; NEXT: re-enable assertEqual when duplicates are fixed.
;; See issue https://github.com/trueagi-io/hyperon-experimental/issues/235
!(assertEqual
  (reduce (((λ $m (λ $n (λ $f (λ $x (($m $f) (($n $f) $x)))))) ; Plus
            (λ $f (λ $x $x)))                                  ; 0
           (λ $f (λ $x $x))))                                  ; 0
  (λ $f (λ $x $x)))  ; 0, the result of (Plus 0 0)
!(assertEqual
  (reduce (((λ $m (λ $n (λ $f (λ $x (($m $f) (($n $f) $x)))))) ; Plus
            (λ $f (λ $x ($f $x))))                             ; 1
           (λ $f (λ $x ($f ($f $x))))))                        ; 2
  (λ $f (λ $x ($f ($f ($f $x))))))  ; 3, the result of (Plus 1 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Combinatory logic to λ-calculus ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Convert combinatory logic to lambda-calculus
(: cl2lc (-> $a $a))
;; Base cases
(= (cl2lc $term)
   (case (get-metatype $term)
     ((Symbol (case $term
                ((𝐈 (λ $x $x))
                 (𝐊 (λ $x (λ $y $x)))
                 (𝐒 (λ $f (λ $g (λ $x (($f $x) ($g $x))))))
                 (𝐌 (λ $x ($x $x)))
                 (𝐍 (λ $x (λ $y $y)))
                 (𝐓 (λ $x (λ $y ($y $x))))
                 (𝐖 (λ $x (λ $y (($x $y) $y))))
                 (𝐁 (λ $x (λ $y (λ $z ($x ($y $z))))))
                 (𝐂 (λ $x (λ $y (λ $z (($x $z) $y)))))
                 (𝐔 (λ $x (λ $y ($y (($x $x) $y)))))
                 ($_ $term))))
      (Variable $term)
      (Grounded $term)
      (Expression (if (== $term ())
                      ()
                      (case $term
                        ((($f $g) ((cl2lc $f) (cl2lc $g)))
                         ($_ $term))))))))

;; Test cl2lc
!(assertEqual
  (=α (cl2lc 𝐍) (λ $f (λ $x $x)))       ; 0
  True)
!(assertEqual
  (=α (cl2lc (𝐒 𝐁))
      ((λ $n (λ $f (λ $x (($n $x) ($f $x))))) ; 𝐒
       (λ $y (λ $z (λ $w ($y ($z $w)))))))    ; 𝐁
  True)
!(assertequal
  (=α (reduce (cl2lc (𝐒 𝐁)))
      (λ $n (λ $f (λ $x ($f (($n $f) $x)))))) ; Successor
  True)
!(assertEqual
  (=α (reduce (cl2lc ((𝐒 𝐁) 𝐍)))                      ; (Succ 0)
      (reduce ((λ $n (λ $f (λ $x ($f (($n $f) $x)))))  ; Successor
               (λ $f (λ $x $x)))))                     ; 0
  True)
!(assertEqual
  (=α (reduce (cl2lc ((𝐒 𝐁) 𝐍)))       ; (Succ 0)
      (λ $f (λ $x ($f $x))))            ; 1, as (Succ 0)
  True)
!(assertEqual
  (=α (reduce (cl2lc (((𝐓 (𝐒 𝐁)) 𝐍) 𝐍)))  ; (Plus 0 0)
      (λ $f (λ $x $x)))                     ; 0
  True)
!(assertEqual
  (=α (reduce (cl2lc (((𝐓 (𝐒 𝐁)) ((𝐒 𝐁) 𝐍)) ((𝐒 𝐁) ((𝐒 𝐁) 𝐍))))) ; (Plus 1 2)
      (λ $f (λ $x ($f ($f ($f $x))))))                              ; 3
  True)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; λ-calculus to combinatory logic ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Convert lambda-calculus to combinatory logic
(: lc2cl (-> Atom Number Atom Atom))
(= (lc2cl $term $cnt $dir)
   (if (is-expression $term)
       (if (== $term ())
           ;; Base cases
           (trace! (bas-∅ (term $term) (cnt $cnt) (dir $dir)) ())
           ;; Recursive steps
           (case $term
             (((λ $x $f)
               (if (is-variable $x)
                   (if (== $f $x)
                       ;; Base case
                       (trace! (bas-I (term $term) (cnt $cnt) (dir $dir)) 𝐈)
                       ;; Recursive steps
                       (let $clf (lc2cl $f (+ 1 $cnt) λC)
                         (if (is-subterm-of $x $f)
                             ; Build 𝐒
                             (trace! (rec-S (term $term) (clf $clf) (cnt $cnt) (dir $dir))
                                     (if (is-expression $clf)
                                         (case $clf
                                           ((($g $h) ((𝐒 (lc2cl (λ $x $g) (+ 2 $cnt) λL))
                                                      (lc2cl (λ $x $h) (+ 2 $cnt) λR)))
                                                ($_ (empty))))
                                         $clf))
                             ; Build 𝐊
                             (trace! (rec-K (term $term) (clf $clf) (cnt $cnt) (dir $dir))
                                     (𝐊 $clf)))))
                   (empty)))
              (($f $g) (trace! (rec-app (term $term) (cnt $cnt) (dir $dir))
                               ((lc2cl $f (+ 1 $cnt) L) (lc2cl $g (+ 1 $cnt) R)))))))
           (trace! (bas-nch (term $term) (cnt $cnt) (dir $dir)) $term)))

;; ;; Convert lambda-calculus to combinatory logic
;; (: lc2cl (-> Atom Number Atom Atom))
;; (= (lc2cl $term $cnt $dir)
;;    (if (is-expression $term)
;;        (if (== $term ())
;;            ;; Base cases
;;            (trace! (bas-∅ (term $term) (cnt $cnt) (dir $dir)) ())
;;            ;; NEXT: try to get rid of as many base cases as possible
;;            (if (=α $term (λ $x $x))
;;                (trace! (bas-I (term $term) (cnt $cnt) (dir $dir)) 𝐈)
;;                (if (=α $term (λ $x (λ $y $x)))
;;                    (trace! (bas-K (term $term) (cnt $cnt) (dir $dir)) 𝐊)
;;                    (if (=α $term (λ $f (λ $g (λ $x (($f $x) ($g $x))))))
;;                        (trace! (bas-S (term $term) (cnt $cnt) (dir $dir)) 𝐒)
;;                        (if (=α $term (λ $x ($x $x)))
;;                            (trace! (bas-M (term $term) (cnt $cnt) (dir $dir)) 𝐌)
;;                            ;; Recursive steps
;;                            (case $term
;;                              (((λ $x $f)
;;                                (if (is-variable $x)
;;                                    (let $clf (lc2cl $f (+ 1 $cnt) λC)
;;                                      (if (is-subterm-of $x $f)
;;                                          ; Build 𝐒
;;                                          (trace! (rec-S (term $term) (clf $clf) (cnt $cnt) (dir $dir))
;;                                          (if (is-expression $clf)
;;                                              (case $clf
;;                                                ((($g $h) ((𝐒 (lc2cl (λ $x $g) (+ 2 $cnt) λL))
;;                                                           (lc2cl (λ $x $h) (+ 2 $cnt) λR)))
;;                                                 ($_ (empty))))
;;                                              $clf))
;;                                          ; Build 𝐊
;;                                          (trace! (rec-K (term $term) (clf $clf) (cnt $cnt) (dir $dir))
;;                                          (𝐊 $clf))))
;;                                    (empty)))
;;                               (($f $g) (trace! (rec-app (term $term) (cnt $cnt) (dir $dir))
;;                                        ((lc2cl $f (+ 1 $cnt) L) (lc2cl $g (+ 1 $cnt) R)))))))))))
;;        (trace! (bas-nch (term $term) (cnt $cnt) (dir $dir)) $term)))

;; NEXT: add tests on remaining individual combinators

;; Test lc2cl
!(assertEqual
  (lc2cl $f 0 C)
  $f)
!(assertEqual
  (lc2cl ($f $x) 0 C)
  ($f $x))
!(assertEqual
  (lc2cl ($f ($f $x)) 0 C)
  ($f ($f $x)))
!(assertEqual
  (lc2cl (λ $x $x) 0 C)
  𝐈)
!(assertEqual
  (lc2cl (λ $x (λ $y $x)) 0 C)
  𝐊)
!(assertEqual
  (lc2cl (λ $f (λ $g (λ $x (($f $x) ($g $x))))))
  𝐒)
!(assertEqual
  (lc2cl (λ $x ($x $x)))
  𝐌)
!(assertEqual
  (lc2cl (λ $x $f))
  (𝐊 $f))
!(assertEqual
  (lc2cl (λ $x ($f $g)))
  (𝐊 ($f $g)))
;; NEXT: make sure that spontaneous reduction is not impoverishing the comparison.
!(assertEqual
  (lc2cl (λ $f (λ $x $x)))       ; 0
  𝐍)
!(assertEqual
  (lc2cl (λ $n (λ $f (λ $x ($f (($n $f) $x)))))) ; Successor
  (𝐒 𝐁))
!(assertEqual
  (lc2cl ((λ $n (λ $f (λ $x ($f (($n $f) $x))))) ; Successor
          (λ $f (λ $x $x))))                     ; 0
  ((𝐒 𝐁) 𝐍))
!(assertEqual
  (lc2cl (λ $f (λ $x ($f $x))))            ; 1, as (Succ 0)
  ((𝐒 𝐁) 𝐍))
!(assertEqual
  (lc2cl (((λ $m (λ $n (λ $f (λ $x (($m $f) (($n $f) $x)))))) ; Plus
           (λ $f (λ $x $x)))                                  ; 0
          (λ $f (λ $x $x))))                                  ; 0
  (((𝐓 (𝐒 𝐁)) 𝐍) 𝐍))
!(assertEqual
  (lc2cl (((λ $m (λ $n (λ $f (λ $x (($m $f) (($n $f) $x)))))) ; Plus
           (λ $f (λ $x ($f $x))))                             ; 1
          (λ $f (λ $x ($f ($f $x))))))                        ; 2
  (((𝐓 (𝐒 𝐁)) ((𝐒 𝐁) 𝐍)) ((𝐒 𝐁) ((𝐒 𝐁) 𝐍))))

;;;;;;;;;;;;;;;;;;;;;;;;;
;; MeTTa to λ-calculus ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Convert metta to lambda calculus with De Bruijn indices.  It takes
;; in arguments
;;
;; 1. De Bruijn index to use for the next abstraction
;;
;; 2. MeTTa term.  Built-in operators such as let must be previously
;;    converted into LET to avoid spontaneous reduction.  NEXT: maybe
;;    we actually don't.
(: mt2lc (-> DeBruijn Atom Atom))
(= (mt2lc $idx $term)
   (case (get-metatype $term)
     ((Symbol $term)
      (Grounded $term)
      (Variable $term)
      (Expression (case $term
                    (;; Empty
                     (() ())
                     ;; LET
                     ((LET $x $y $f) (let* (($x $idx)
                                            ($νf (mt2lc (S' $idx) $f))
                                            ($νy (mt2lc $idx $y)))
                                       ((λ $x $νf) $νy)))
                     ;; Application
                     (($f $x) ((mt2lc $idx $f) (mt2lc $idx $x)))
                     ;; Other
                     ($term $term)))))))

!(assertEqual
  (mt2lc Z' (LET $x (inc 1) (plus $x $x)))
  ((λ Z' (plus Z' Z')) (inc 1)))

!(assertEqual
  (mt2lc Z'
         (LET $spleeter-output
              (snet.sound-spleeter.spleeter ((snet.sound-spleeter.MkInput "") $input))
              (LET $english-vocals (snet.sound-spleeter.Output.vocals $spleeter-output)
                   (LET $chinese-lyrics
                        (naint.machine-translation.Output.translation
                         (naint.machine-translation.translate
                          (((naint.machine-translation.MkInput "English") "Chinese")
                           (snet.speech-recognition.Text.text
                            (snet.speech-recognition.s2t
                             (snet.speech-recognition.MkAudio $english-vocals))))))
                        (LET $midi-notes (tomidi.MIDI.data (tomidi.MkAudio $english-vocals))
                             (LET $chinese-vocals
                                  (naint.midi2voice-zh.Answer.output_audio
                                   (naint.midi2voice-zh.singingZH
                                    (((naint.midi2voice-zh.MkQuery $chinese-lyrics)
                                      $midi-notes) 1.0)))
                                  (mixer.Audio.data
                                   (mixer.mix
                                    ((mixer.MkMultiAudio
                                      (snet.sound-spleeter.Output.accomp $spleeter-output))
                                     $chinese-vocals)))))))))
  ((λ Z' ((λ (S' Z') ((λ (S' (S' Z')) ((λ (S' (S' (S' Z'))) ((λ (S' (S' (S' (S' Z')))) (mixer.Audio.data (mixer.mix ((mixer.MkMultiAudio (snet.sound-spleeter.Output.accomp Z')) (S' (S' (S' (S' Z')))))))) (naint.midi2voice-zh.Answer.output_audio (naint.midi2voice-zh.singingZH (((naint.midi2voice-zh.MkQuery (S' (S' Z'))) (S' (S' (S' Z')))) 1.0))))) (tomidi.MIDI.data (tomidi.MkAudio (S' Z'))))) (naint.machine-translation.Output.translation (naint.machine-translation.translate (((naint.machine-translation.MkInput "English") "Chinese") (snet.speech-recognition.Text.text (snet.speech-recognition.s2t (snet.speech-recognition.MkAudio (S' Z'))))))))) (snet.sound-spleeter.Output.vocals Z'))) (snet.sound-spleeter.spleeter ((snet.sound-spleeter.MkInput "") $input))))

;; We replace let by LET to avoid the program getting spontaneously
;; reduced, indeed the following
;;
;; !(let $spleeter-output
;;       (snet.sound-spleeter.spleeter ((snet.sound-spleeter.MkInput "") $input))
;;       (let $english-vocals (snet.sound-spleeter.Output.vocals $spleeter-output)
;;            (let $chinese-lyrics
;;                 (naint.machine-translation.Output.translation
;;                  (naint.machine-translation.translate
;;                   (((naint.machine-translation.MkInput "English") "Chinese")
;;                    (snet.speech-recognition.Text.text
;;                     (snet.speech-recognition.s2t
;;                      (snet.speech-recognition.MkAudio $english-vocals))))))
;;                 (let $midi-notes (tomidi.MIDI.data (tomidi.MkAudio $english-vocals))
;;                      (let $chinese-vocals
;;                           (naint.midi2voice-zh.Answer.output_audio
;;                            (naint.midi2voice-zh.singingZH
;;                             (((naint.midi2voice-zh.MkQuery $chinese-lyrics)
;;                               $midi-notes) 1.0)))
;;                           (mixer.Audio.data
;;                            (mixer.mix
;;                             ((mixer.MkMultiAudio
;;                               (snet.sound-spleeter.Output.accomp $spleeter-output))
;;                              $chinese-vocals))))))))
;;
;; results into
;;
;; (mixer.Audio.data
;;  (mixer.mix
;;   ((mixer.MkMultiAudio
;;     (snet.sound-spleeter.Output.accomp
;;      (snet.sound-spleeter.spleeter
;;       ((snet.sound-spleeter.MkInput "") $input))))
;;    (naint.midi2voice-zh.Answer.output_audio
;;     (naint.midi2voice-zh.singingZH
;;      (((naint.midi2voice-zh.MkQuery
;;         (naint.machine-translation.Output.translation
;;          (naint.machine-translation.translate
;;           (((naint.machine-translation.MkInput "English") "Chinese")
;;            (snet.speech-recognition.Text.text
;;             (snet.speech-recognition.s2t
;;              (snet.speech-recognition.MkAudio
;;               (snet.sound-spleeter.Output.vocals
;;                (snet.sound-spleeter.spleeter
;;                 ((snet.sound-spleeter.MkInput "") $input))))))))))
;;        (tomidi.MIDI.data
;;         (tomidi.MkAudio
;;          (snet.sound-spleeter.Output.vocals
;;           (snet.sound-spleeter.spleeter
;;            ((snet.sound-spleeter.MkInput "") $input)))))) 1.0))))))
;;
;; involving multiple calls of the same services.  In particular
;; snet.sound-spleeter.spleeter is called 3 times.
