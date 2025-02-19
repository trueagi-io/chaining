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

;;When adding an atom to the KB, it is first normalized
;;Then it is added to the indexed spaces
(= (add-to-kb ($cs $ps) $stmt)
   (let* (($nstmt (normalize $stmt))
          (($pset ⊢ $cset) $nstmt)
          ($_ (foldl-atom $cset () $accum $celem (let $_ $accum (add-atom $cs ($celem $nstmt)))))
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
   (let $pset (if (is-variable $pset) () $pset)
   (if (is-variable $cset)
     ($pset ⊢ ($ccls))
     (let ($npset $_ $ncset) (overlap2 $pset $cset) ($npset ⊢ $cset)))))

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
    (let $lc_cset (map-atom $lc_cset $elem (runcpu $elem))
      ($npset ⊢ $lc_cset)
    )
    ;Premises left to prove
    (let* (
      ((S $depth) $depth_full) ;Make sure we can go deeper
      (($a ⊢ $b) (bcset $kb $depth_full ($pset ⊢ $ppset))) ;Proof the premises
      ($lc_cset (map-atom $lc_cset $elem (runcpu $elem))) ;Run the CPU function
      )
      (normalize (unionStmt ($npset ⊢ $lc_cset) ($a ⊢ $b)))
    )
  )
 )
)

;If $stmt is a CPU statement, then run the CPU function
(= (runcpu $stmt)
   (unify $stmt (: (CPU $f $args) (CPU $res)) (: (CPU $f $args) (CPU (cons-atom $f $args))) $stmt))

!(bind! &cpu (init-kb))

!(add-to-kb &cpu (() ⊢ ((: a1 (A 1)))))
!(add-to-kb &cpu (() ⊢ ((: a2 (A 2)))))

!(add-to-kb &cpu (((: $a1 (A $v1)) (: $a2 (A $v2))) ⊢ ((: (CPU + ($v1 $v2)) (CPU $v3)) (: (b $a1 $a2) (B $v3)))))

!(assertEqualToResult (bc &cpu (S Z) (() ⊢ ((: $b (B $v)))))
   ((() ⊢ ((: (CPU + (2 2)) (CPU 4)) (: (b a2 a2) (B 4)) (: a2 (A 2)) (: a2 (A 2))))
    (() ⊢ ((: (CPU + (2 1)) (CPU 3)) (: (b a2 a1) (B 3)) (: a2 (A 2)) (: a1 (A 1))))
    (() ⊢ ((: (CPU + (1 2)) (CPU 3)) (: (b a1 a2) (B 3)) (: a1 (A 1)) (: a2 (A 2))))
    (() ⊢ ((: (CPU + (1 1)) (CPU 2)) (: (b a1 a1) (B 2)) (: a1 (A 1)) (: a1 (A 1))))))

;;Some tests
!(bind! &s (init-kb))

!(add-to-kb &s (((: $a A) (: $b B)) ⊢ ((: (f $a $b) C))))
!(add-to-kb &s (((: $b B)) ⊢ ((: (f2 a $b) D))))
!(add-to-kb &s (((: $b B) (: $e E)) ⊢ ((: (f3 a $b $e) F))))

!(add-to-kb &s (() ⊢ ((: a A))))
!(add-to-kb &s (() ⊢ ((: b B))))

; Basic type queries
!(assertEqual (bc &s Z (() ⊢ ((: $a A)))) (() ⊢ ((: a A))))

!(assertEqual (bc &s Z (() ⊢ ((: $a A)(: $b B)))) (() ⊢ ((: a A)(: b B))))

!(assertEqual (bc &s (S (S Z)) (() ⊢ ((: $p C))))
    (() ⊢ ((: (f a b) C) (: a A) (: b B))))

!(assertEqual (bc &s (S (S Z)) (() ⊢ ((: (f a b) $t))))
    (() ⊢ ((: (f a b) C) (: a A) (: b B))))

;Partial application
!(assertEqual (bc &s (S (S Z)) (((: $a A)) ⊢ ((: $c C))))
     (((: $a A)) ⊢ ((: (f $a b) C) (: b B))))

!(assertEqual (bc &s (S Z) (() ⊢ ((: (f $a b) $t))))
    (() ⊢ ((: (f a b) C) (: a A) (: b B))))

!(assertEqual (bc &s (S (S Z)) (() ⊢ ((: $d D))))
    (() ⊢ ((: (f2 a b) D) (: b B))))

!(assertEqual (bc &s (S (S Z)) (() ⊢ ((: (f2 a b) $t))))
    (() ⊢ ((: (f2 a b) D) (: b B))))

!(assertEqual (bc &s (S (S Z)) (((: $e E)) ⊢ ((: $f F))))
    (((: $e E)) ⊢ ((: (f3 a b $e) F) (: b B))))

!(assertEqual (bc &s (S (S Z)) (((: $e E)) ⊢ ((: (f3 a b $e) $t))))
    (((: $e E)) ⊢ ((: (f3 a b $e) F) (: b B))))

!(bind! &f1 (init-kb))

!(add-to-kb &f1 (() ⊢ ((: (f1) A))))
!(add-to-kb &f1 (((: $b B)) ⊢ ((: $a A) (: (f2 $a $b) C))))

!(assertEqual (bc &f1 (S Z) (() ⊢ ((: $a A)))) (() ⊢ ((: (f1) A))))

!(bind! &f2 (init-kb))

!(add-to-kb &f2 (((: $a A)) ⊢ ((: (f1 $a) B))))
!(add-to-kb &f2 (((: $a A) (: $c C)) ⊢ ((: (f2 $a $c) D))))

!(assertEqual (bc &f2 (S Z) (((: $a A)) ⊢ $type)) (((: $a A)) ⊢ ((: (f1 $a) B))))

!(bind! &f3 (init-kb))

!(add-to-kb &f3 (((: $a A)) ⊢ ((: (f2 $a) B))))
!(add-to-kb &f3 (((: $z Z)) ⊢ ((: (f2 $a) B))))
!(add-to-kb &f3 (((: $a A) (: $b B)) ⊢ ((: (f3 $a $b) C))))
!(add-to-kb &f3 (((: $a A) (: $x X)) ⊢ ((: (ff $a $x) Y))))
!(add-to-kb &f3 (((: $c C)) ⊢ ((: (f4 $c) D))))

!(assertEqual (bc &f3 (S (S Z)) (((: $a A)) ⊢ ((: $d D))))
   (((: $a A)) ⊢ ((: (f4 (f3 $a (f2 $a))) D) (: (f3 $a (f2 $a)) C) (: (f2 $a) B))))

!(bind! &b (init-kb))

!(add-to-kb &b (((: $a A)) ⊢ ((: (ab $a) B))))
!(add-to-kb &b (((: $b B)) ⊢ ((: (bc $b) C))))
!(add-to-kb &b (((: $c C)) ⊢ ((: (cd $c) D))))
!(add-to-kb &b (((: $d D)) ⊢ ((: (de $d) E))))
!(add-to-kb &b (((: $e E)) ⊢ ((: (ef $e) F))))
!(add-to-kb &b (((: $f F)) ⊢ ((: (fg $f) G))))
!(add-to-kb &b (((: $g G)) ⊢ ((: (gh $g) H))))

!(time (bcset &b (fromNumber 3) (((: $a A)) ⊢ ((: $f D)))))

