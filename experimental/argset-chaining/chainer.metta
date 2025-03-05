!(import! &self utils)
!(import! &self setspace)
!(import! &self tvformulas)
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
     (let ($npset $_ $ncset) (overlap2 $pset $cset) ($npset ⊢ (runreduction $cset))))

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
           ((unique-union-atom $pset1 $pset2) ⊢ (unique-union-atom $cset1 $cset2)))))))

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;

;Entry point for the backward chainer
;that ensure the query is normalized
(= (bc $kb $depth_full $query)
 (let ($npset ⊢ $ncset) (normalize $query)
  (if (is-variable $ncset)
   (bcsingle $kb $depth_full ($npset ⊢ $ncset))
   (bcset $kb $depth_full ($npset ⊢ $ncset))
  )
 )
)

;Backward chainer for a set of conclusions
(= (bcset $kb $depth_full ($pset ⊢ $cset))
 (if-decons-expr $cset $ccls $ctail
  ;(let ($ppset ⊢ $pcset) (combine (tracem scol (collapse (capture (tracem sbcol (bcsingle $kb $depth_full ($pset ⊢ $ccls)))))))
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
  )
  ;Alternate to a forward step
  (if (== $ppset ()) ;Nothing lef to prove runcpu and return
    (let $rc (runcpu $lc_cset)
      ($lc_pset ⊢ $lc_cset)
    )
    ;Premises left to prove
    (unify $depth_full (S $depth)
      (let* (
         (($a ⊢ $b) (bcset $kb $depth ($pset ⊢ $ppset))) ;Proof the premises
         ;(($npcset $_ppset ()) (tracem (o2 $b $ppset) (overlap2 $b $ppset)))
         ($rc2 (cpu2 $lc_cset) (runcpu $lc_cset))
         )
         (normalize (unionStmt ($lc_pset ⊢ $lc_cset) ($a ⊢ $b)))
       )
       (if (is-variable $pset)
        ($lc_pset ⊢ $lc_cset)
        Emtpy)
    )
  )
 )
)

;(= (runcpu $stmts) $stmts)

(= (runcpu $stmts)
 (if-decons-expr $stmts $stmt $rest
   (let $stmt (unify $stmt (: (CPU $f $args) (CPU $res)) (if (is-closed $args) (: (CPU $f $args) (CPU (cons-atom $f $args))) $stmt) $stmt)
     (runcpu $rest))
   ()))

(= (merge $base $stmts)
  (if-decons-expr $stmts $stmt $rest
        (let ((: $prf1 (Eval $type1 $tv1)) (: $prf2 (Eval $type2 $tv2))) ($base $stmt)
         (if (elemexpr $prf1 $prf2)
           (: $prf2 (Eval $type2 $tv2))
           (if (elemexpr $prf2 $prf1)
             (: $prf1 (Eval $type1 $tv1))
             (merge (: (revision $prf1 $prf2) (Eval $type1 (mergetvs $tv1 $tv2))) $rest)
           )
         )
       )
        $base
        ))

!(assertEqual (merge (: p1 (Eval (m a) (stv 0.9 0.9))) ((: p2 (Eval (m a) (stv 0.9 0.9)))))
              (: (revision p1 p2) (Eval (m a) (stv 0.9 0.9473684210526316))))

;(= (runreduction $stmts) $stmts)

(= (runreduction $stmts)
 (if-decons-expr $stmts $stmt $rest
  (let (: $prf $type) $stmt
   (if (is-variable $type)
    (let $nrest (runreduction $rest)
     (cons-atom $stmt $nrest))
    (let ($removed $remaining) (removeAlphaMagic $rest $stmt)
     (let $nstmt (merge $stmt $removed)
      (let $nrest (runreduction $remaining)
       (cons-atom $nstmt $nrest)))
    )))
  $stmts
 )
)

!(assertEqual (runreduction ((: p1 (Eval (m a) (stv 0.9 0.9))) (: p2 (Eval (m a) (stv 0.9 0.9))) (: p3 (Eval (m b) (stv 0.9 0.9)))))
              ((: (revision p1 p2) (Eval (m a) (stv 0.9 0.9473684210526316))) (: p3 (Eval (m b) (stv 0.9 0.9)))))

;!(collapse (let* (($args (superpose ( ((: (CPU + (1 2)) (CPU $v)) (: b (B $v)))
;                                      ((: (CPU + (2 2)) (CPU $v)) (: b (B $v))))))
;       )
;       ((runcpu $args) $args)))
