;; Return true iff $x is a MeTTa expression
(= (is-expression $x) (== (get-metatype $x) Expression))

;; Get shallow abstractions of $pat with counts greater than or equal
;; to $ms according to $db.  The multiplicity of results is handled by
;; superposition.
(= (shallow-abstract $ms $db $pat)
   ;; NEXT
   )

;; Given a pattern of the form (f x) return its database according x.
;; This function does not create bindings on x.
;; NEXT: find a better name that can be adjusted for different patterns.
(= (subdb $db ($f $x)) (collapse (let ($f $x) (superpose $db) $x)))

;; Pattern mine database $db starting at pattern $pat so that any
;; specialization of $pat has a support greater than or equal to $ms.
;; It is assumed that ms <= (count $db $pat) at the entry point.
(= (mine $ms $db $pat)
   (let $shab (shallow-abstract $ms $db $pat)
     (if (is-expression $shab)
         ;; If expression recurse
         (case $shab
           (;; Unary application
            (($f $x) ($f (mine $ms (subdb $db ($f $x)) $x)))
            ;; Else (TODO)
            ($else $else)))
         ;; Else return itself
         $shab)))
