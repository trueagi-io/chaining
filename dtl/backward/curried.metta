;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Backward DTL Curried ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Similar to the traditional backward chaining DTL but rules are
;; curried.  This allows to partially apply rule which is useful for
;; inferring proof abstractions.

;; Backward chainer/synthesizer
(: syn (-> $a                           ; Knowledge base space
           Nat                          ; Maximum depth
           $b                           ; Query
           $b))                         ; Result

;; Base case
(= (syn $kb $_ (: $prf $ccln)) (match $kb (: $prf $ccln) (: $prf $ccln)))

;; Recursive step
(= (syn $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (let* (((: $prfabs (-> $prms $ccln)) (syn $kb $k (: $prfabs (-> $prms $ccln))))
          ((: $prfarg $prms) (syn $kb $k (: $prfarg $prms))))
     (: ($prfabs $prfarg) $ccln)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Iterative Chainer Wrapped Around Backward DTL Curried (collapse) ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Call the backward DTL curried chainer iteratively, adding the
;; proofs, or proof abstractions to the knowledge space after each
;; iterations.  To avoid irreproducible behavior (due to the side
;; effects of modifying the atomspace), each call of the backward
;; chainer collapses between iterations.
(: isyn (-> $a                            ; Knowledge base space
            Nat                           ; Depth
            Nat                           ; Number of iterations
            $b                            ; Query
            $b))                          ; Result

;; Base case.  For now it terminates at exactly iteration Z to avoid
;; collecting too many redundant results.
(= (isyn $kb $depth Z $query) $query)

;; Iterative step
(= (isyn $kb $depth (S $k) $query)
   (let* (($cres (collapse (syn $kb $depth $query)))
          ($dummy (add-atoms-nodup $kb $cres)))
     (isyn $kb $depth $k (superpose $cres))))
