;; TODO: patternize function as well ($f A B C)

;;;;;;;;;;;;;;;;
;; Properties ;;
;;;;;;;;;;;;;;;;

;; Return true iff $x is a MeTTa expression
(= (isExpression $x) (== (get-metatype $x) Expression))

;; Test isExpression
!(test (isExpression A) False)
!(test (isExpression (B $x)) True)

;;;;;;;;;;;;;
;; Counter ;;
;;;;;;;;;;;;;

;; Define Counter type, constructors and methods
(: Counter (-> $a Type))
(: Counter.Nil (Counter $a))
(: Counter.Cons (-> $a                  ; Key
                    Number              ; Count
                    (Counter $a)        ; Tail
                    (Counter $a)))

;; Insert a key in the counter
;; (: Counter.insert (-> $a                ; Key
;;                       (Counter $a)      ; Old counter
;;                       (counter $a)))    ; New counter
(= (Counter.insert $x Counter.Nil) (Counter.Cons $x 1 Counter.Nil))
(= (Counter.insert $x (Counter.Cons $k $n $tail))
   (if (== $x $k)
       (Counter.Cons $k (+ $n 1) $tail)
       (Counter.Cons $k $n (Counter.insert $x $tail))))

;; Test Counter.insert
!(test
  (Counter.insert A Counter.Nil)
  (Counter.Cons A 1 Counter.Nil))
!(test
  (Counter.insert A (Counter.Cons A 1 Counter.Nil))
  (Counter.Cons A 2 Counter.Nil))
!(test
  (Counter.insert B (Counter.Cons A 2 Counter.Nil))
  (Counter.Cons A 2 (Counter.Cons B 1 Counter.Nil)))
!(test
  (Counter.insert (C $x) (Counter.Cons A 2 (Counter.Cons B 1 Counter.Nil)))
  (Counter.Cons A 2 (Counter.Cons B 1 (Counter.Cons (C $x) 1 Counter.Nil))))
!(test
  (Counter.insert (C $x)
                  (Counter.Cons A 2
                                (Counter.Cons B 1
                                              (Counter.Cons (C $x) 1
                                                            Counter.Nil))))
  (Counter.Cons A 2 (Counter.Cons B 1 (Counter.Cons (C $x) 2 Counter.Nil))))


;; Like Counter.insert but use a provided equality
;; (: Counter.insertWith (-> (-> $a $a Bool) ; Equality
;;                           $a              ; Key
;;                           (Counter $a)    ; Old counter
;;                           (Counter $a)))  ; New counter
(= (Counter.insertWith $eq $x Counter.Nil) (Counter.Cons $x 1 Counter.Nil))
(= (Counter.insertWith $eq $x (Counter.Cons $k $n $tail))
   (if ($eq $x $k)
       (Counter.Cons $k (+ $n 1) $tail)
       (Counter.Cons $k $n (Counter.insertWith $eq $x $tail))))

;; Test Counter.insertWith
!(test
  (Counter.insertWith =alpha A Counter.Nil)
  (Counter.Cons A 1 Counter.Nil))
!(test
  (Counter.insertWith =alpha A (Counter.Cons A 1 Counter.Nil))
  (Counter.Cons A 2 Counter.Nil))
!(test
  (Counter.insertWith =alpha B (Counter.Cons A 2 Counter.Nil))
  (Counter.Cons A 2 (Counter.Cons B 1 Counter.Nil)))
!(test
  (Counter.insertWith =alpha (C $x)
                      (Counter.Cons A 2 (Counter.Cons B 1 Counter.Nil)))
  (Counter.Cons A 2 (Counter.Cons B 1 (Counter.Cons (C $x) 1 Counter.Nil))))
!(test
  (Counter.insertWith =alpha
                      (C $y)
                      (Counter.Cons A 2
                                    (Counter.Cons B 1
                                                  (Counter.Cons (C $x) 2
                                                                Counter.Nil))))
  (Counter.Cons A 2 (Counter.Cons B 1 (Counter.Cons (C $x) 3 Counter.Nil))))

;;;;;;;;;;;
;; Miner ;;
;;;;;;;;;;;

;; Get shallow abstraction of a term.  If the term is a symbol,
;; grounding or variable, then return itself, otherwise, if it is an
;; expression, return the first element (the function) and abstract
;; the arguments.
;;
;; For instance `(inc 42)` shallow abstracs to `(inc $x)`.
(= (shallowAbstractTerm $x)
   (if (isExpression $x)
       (case $x
         (;; Unary application
          (($f $y) ($f $z))
          ;; Else (TODO)
          ($else $else)))
       $x))

;; Test shallowAbstractTerm
!(test (shallowAbstractTerm A) A)
!(test (shallowAbstractTerm (A B)) (A $x))

;; Return a counter mapping each shallow abstraction of $db that
;; unifies with $pat with its count.  $db is assumed to be a MeTTa
;; expression.
;; (: countShallowAbstractions (-> $a $b Counter))
(= (countShallowAbstractions $db $pat)
   (trace! (👁 countShallowAbstractions $db $pat)
   (case $db
     (;; Base case, empty $db
      (() Counter.Nil)
      ;; Recursive step, non-empty $db
      ($else (let ($head $tail) (decons-atom $db)
                  (Counter.insertWith =alpha
                                      (shallowAbstractTerm $head)
                                      (countShallowAbstractions $tail $pat))))))))

;; Test countShallowAbstractions
!(test (countShallowAbstractions () $pat) Counter.Nil)
!(test (countShallowAbstractions (A) $pat) (Counter.Cons A 1 Counter.Nil))
!(test (countShallowAbstractions (A A) $pat) (Counter.Cons A 2 Counter.Nil))
!(test (countShallowAbstractions (A B) $pat)
       (Counter.Cons B 1 (Counter.Cons A 1 Counter.Nil)))
!(test (countShallowAbstractions (A A B) $pat)
       (Counter.Cons B 1 (Counter.Cons A 2 Counter.Nil)))
!(test (countShallowAbstractions ((A B)) $pat) (Counter.Cons (A $x) 1 Counter.Nil))
!(test (countShallowAbstractions ((A B) (A C)) $pat)
       (Counter.Cons (A $x) 2 Counter.Nil))
!(test (countShallowAbstractions ((A B) (A C) D E) $pat)
       (Counter.Cons E 1 (Counter.Cons D 1 (Counter.Cons (A $x) 2 Counter.Nil))))

;; Get shallow abstractions of $pat with counts greater than or equal
;; to $ms according to $db.  The multiplicity of results is handled by
;; superposition.
(= (shallowAbstract $ms $db $pat)
   ;; NEXT
   )

;; Given a pattern of the form (f x) return its database according x.
;; This function does not create bindings on x (NEXT: verify).
;; NEXT: find a better name that can be adjusted for different patterns.
(= (subdb $db ($f $x)) (collapse (let ($f $x) (superpose $db) $x)))

;; Pattern mine database $db starting at pattern $pat so that any
;; specialization of $pat has a support greater than or equal to $ms.
;; It is assumed that ms <= (count $db $pat) at the entry point.
(= (mine $ms $db $pat)
   (let $shab (shallowAbstract $ms $db $pat)
     (if (isExpression $shab)
         ;; If expression recurse
         (case $shab
           (;; Unary application
            (($f $x) ($f (mine $ms (subdb $db ($f $x)) $x)))
            ;; Else (TODO)
            ($else $else)))
         ;; Else return itself
         $shab)))
