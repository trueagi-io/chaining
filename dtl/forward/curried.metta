;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Curried Forward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; In the curried Forward chainer, in order to go forward, the
;; chainer need to unfold the rules backward.  For that reason the
;; forward chainer calls the backward chainer with a rule abstraction as
;; query instead of invoking a match query.

;; Curried Forward Chainer.  The arguments of the forward chainer are:
;;
;; * Knowledge base: pointer to a space containing axioms and rules in
;;   the format (: <NAME> <RULE>).  Note that rules are explicitely
;;   curried, meaning that a rule with two premises is represented by
;;
;;   (: <NAME> (-> <PREMISE1> (-> <PREMISE2> <CONCLUSION>)))
;;
;; * Maximum depth: maximum depth of the generated proof tree.
;;
;; * Source: a metta term of the form (: <PROOF> <THEOREM>) where
;;   <PROOF> and <THEOREM> may contain free variables.  Beware that
;;   the source is assumed to be true.  That is especially important
;;   to consider when introducing free variables, because these free
;;   variables will be treated as if they are univerally quantified.
;;
;; A result is a conclusion that can be reached from the source.  If
;; multiple results are possible, they are returned as a
;; superposition.

;; Backward chainer/synthesizer
;; TODO: Import the curried backward chainer instead of repeating the 
;; definition here.
;; Note: Named the function name 'bc' here to avoid importing it twice,
;; incase both chainers are imported at the same time.

(: bc (-> $a                           ; Knowledge base space
          Nat                          ; Maximum depth
          $b                           ; Query
          $b))                         ; Result

;; Base case
(= (bc $kb $_ (: $prf $ccln)) (match $kb (: $prf $ccln) (: $prf $ccln)))

;; Recursive step
(= (bc $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (let* (((: $prfabs (-> $prms $ccln)) (bc $kb $k (: $prfabs (-> $prms $ccln))))
          ((: $prfarg $prms) (bc $kb $k (: $prfarg $prms))))
     (: ($prfabs $prfarg) $ccln)))

;; Forward DTL Curried
(: fcc (-> $a                            ; Knowledge base space
           Nat                           ; Maximum depth
           $b                            ; Source
           $b))                          ; Conclusion

;; Base case
(= (fcc $kb $_ (: $prf $prms)) (: $prf $prms))

;; Recursive step
(= (fcc $kb (S $k) (: $prfarg $prms))
   (let (: $prfabs (-> $prms $ccln)) (bc $kb $k (: $prfabs (-> $prms $ccln)))
     (fcc $kb $k (: ($prfabs $prfarg) $ccln))))
(= (fcc $kb (S $k) (: $prfabs (-> $prms $ccln)))
    (let (: $prfarg $prms) (bc $kb $k (: $prfarg $prms))
     (fcc $kb $k (: ($prfabs $prfarg) $ccln))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Iterative Forward chaining DTL curried using Backward chaining ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Call the forward chainer DTL curried iteratively, 
;; the chainer unfolds the rules backward using the backward chainer/synthesizer.

;; Iterative Forward DTL Curried Chainer

(: ifcc (-> $a                            ; Knowledge base space 
            Nat                           ; Depth
            Nat                           ; Number of iterations
            $b                            ; Source
            $b))                          ; Conclusion

;; Base case.  For now it terminates at exactly iteration Z to avoid
;; collecting too many redundant results.
(= (ifcc $kb $depth Z $prms) $prms)

;; Iterative step
(= (ifcc $kb $depth (S $k) $prms)
   (let* (($res (fcc $kb $depth $prms))
          ($cres (collapse $res))
          ($dummy (add-atoms-nodup $kb $cres)))
     (ifcc $kb $depth $k (superpose $cres))))
