!(import! &self utils)
!(import! &self setspace)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;In this chainer our statements look like
;($pset ⊢ $cset)
;; $pset and $cset are sets of proofs of the form (: $term Type)

;;To add a direct proof af a type use a function that as $pset == ()
;;(() ⊢ ((: a A)))
;;A simple function from a to b looks like:
;;(((: $a A)) ⊢ ((: (f $a) B)))

;;This chainer requires 2 indecies to lookup atoms
;; One maps Conclusions to the Rules that prove them
;; The other maps Premises to the Rules that use them
;;They can be created with the init-kb function
(= (init-kb)
   (let* (($cs (new-space))
          ($ps (new-state (create-setspace)))
          )
   ($cs $ps))
)

(= (show-cs ($cs $ps)) (match $cs $a $a))
(= (show-ps ($cs $ps)) (sstostring (get-state $ps)))

;;When adding an atom to the KB, it is first normalized
;;Then it is added to the indexed spaces
(= (add-to-kb ($cs $ps) $nstmt)
   (let* (;($nstmt (normalize $stmt))
          (($pset ⊢ $cset) $nstmt)
          ($_ (foldl-atom $cset () $accum $celem (let $_ $accum (if (=unify $celem (: (CPU $f $args) (CPU $res))) () (add-atom $cs ($celem $nstmt))))))
          ($ss (get-state $ps))
          ($ns (insert-setspace $ss $pset $nstmt))
          ($res (change-state! $ps $ns))
          )
   (Okay))
)

;Lokup all rules that prove a conclusion
(= (lookup-ccls ($cs $ps) $ccls)
   (match $cs ($ccls $rule) ($ccls $rule)))

;Lookup all rules whose premises are a subset of $query
(= (lookup-pset-in-kb ($cs $ps) $query)
   (let $ss (get-state $ps) (combine (lookup-all-subsets $ss $query))))

;;Normalize a statement (remove premises that are part of the conclusion)
(= (normalize ()) ())
(= (normalize ($pset ⊢ $cset))
   ;(let $pset (if (is-variable $pset) () $pset)
   (if (is-variable $cset)
     ($pset ⊢ ($ccls))
     (let ($npset $_ $ncset) (overlap2 $pset $cset) ($npset ⊢ $cset))))

;;Takes a list/expression of statements and combines them
(= (combine $a) (normalize (myfold-atom1 $a unionStmt)))

;;Takes 2 statements and combines them
;;TODO should this also normalize the statements?
(= (unionStmt $stmt1 $stmt2)
   (if (or (is-variable $stmt1) (== $stmt1 ()))
     $stmt2
     (if (or (is-variable $stmt2) (== $stmt2 ()))
       $stmt1
       (let ($pset1 ⊢ $cset1) $stmt1
         (let ($pset2 ⊢ $cset2) $stmt2
           ((unique-union-atom $pset1 $pset2) ⊢ (concat $cset1 $cset2)))))))

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;

;Entry point for the backward chainer
;that ensure the query is normalized
(= (bc $kb $depth_full $query)
 (bcset $kb $depth_full (normalize $query))
)

;Backward chainer for a set of conclusions
(= (bcset $kb $depth_full ($pset ⊢ $cset))
 (if-decons-expr $cset $ccls $ctail
  (let ($ppset ⊢ $pcset) (bcsingle $kb $depth_full ($pset ⊢ $ccls))
   (if (== $ctail ()) ;Don't recurse if there is nothing left to do
    ($ppset ⊢ $pcset)
    (let* 
     (;(($ncset $_cset $nctail) (overlap2 $pcset $ctail)) ;We could check if we have already prooved other things in $ctail but its a lot of overhead so we skip it for now
      ;($npset (concat $pset $pcset))
      ;($npcset (concat $ncset $_cset))
      ;(($rpset ⊢ $rcset) (bcp $kb $depth_full ($npset ⊢ $nctail)))
      (($rpset ⊢ $rcset) (bcset $kb $depth_full ($pset ⊢ $ctail)))
     )
     ;(normalize (unionStmt ($ppset ⊢ $npcset) ($rpset ⊢ $rcset)))
     (normalize (unionStmt ($ppset ⊢ $pcset) ($rpset ⊢ $rcset)))
    )
   )
  )
  ;$cset is empty nothing to do
  (() ⊢ ())
 )
)



;Backward chainer for a single conclusion
(= (bcsingle $kb $depth_full ($pset ⊢ $ccls))
 (let* ;Go step backwards
  ((($ccls ($lc_pset ⊢ $lc_cset)) (lookup-ccls $kb $ccls)) ;Get rule to prove $ccls
   (($_pset $opset $ppset) (overlap2 $pset $lc_pset)) ;Check if we have already prooved $lc_pset
   ($npset (concat $opset $ppset))
  )
  ;Alternate to a forward step
  (if (== $ppset ()) ;Nothing lef to prove runcpu and return
    (let $lc_cset (runcpu $lc_cset)
      ($npset ⊢ $lc_cset)
    )
    ;Premises left to prove
    (unify $depth_full (S $depth)
      (let* (
         (($a ⊢ $b) (bcset $kb $depth ($pset ⊢ $ppset))) ;Proof the premises
         ($lc_cset (runcpu $lc_cset))
         )
         (normalize (unionStmt ($npset ⊢ $lc_cset) ($a ⊢ $b)))
       )
       (if (is-variable $pset)
        ($npset ⊢ $lc_cset)
        Emtpy)
    )
    ;(let* (
    ;  ((S $depth) $depth_full) ;Make sure we can go deeper
    ;  (($a ⊢ $b) (bcset $kb $depth_full ($pset ⊢ $ppset))) ;Proof the premises
    ;  ($lc_cset (map-atom $lc_cset $elem (runcpu $elem))) ;Run the CPU function
    ;  )
    ;  (normalize (unionStmt ($npset ⊢ $lc_cset) ($a ⊢ $b)))
    ;)
  )
 )
)

(= (runcpu $stmts)
 (if-decons-expr $stmts $stmt $rest
   (let $stmt (unify $stmt (: (CPU $f $args) (CPU $res)) (if (is-closed $args) (: (CPU $f $args) (CPU (cons-atom $f $args))) $stmt) $stmt)
   (let $rest (runcpu $rest)
     (cons-atom $stmt $rest)))
   $stmts))
