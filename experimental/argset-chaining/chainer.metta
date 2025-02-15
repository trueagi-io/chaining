!(import! &self utils)
!(import! &self setspace2)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;In this chainer our statements look like
;(: $fset (-> $pset $cset))
;; Where $fset is a set of function names
;; $pset and $cset are sets of proof of the form (: $arg Type)
;; in $pset $arg is always a variable
;; in $cset its a combination of function names and arg vars from $pset

;;To add a direct proof af a type use a function that as $pset == ()
;;( (a) (-> () ((: (a) A))))
;;in english the set of function (a) take no arguments/empty set
;;and produce the set of proofs containg one element (: (a) A)
;;A simple function from a to b looks like:
;;( (f) (-> ((: $a A)) ((: (f $a) B))))

;;This chainer requires 3 indecies to lookup atoms
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
          ((-> $pset $cset) $nstmt)
          ($_ (foldl-atom $cset () $accum $celem (let $_ $accum (add-atom $cs ($celem $nstmt)))))
          ;($_ (foldl-atom $pset () $accum $pelem (let $_ $accum (add-atom $ps ($pelem $nstmt)))))
          ($ss (get-state $ps))
          ($ns (insert-setspace $ss $pset $nstmt))
          ($res (change-state! $ps $ns))
          )
   (Okay))
)

;;Lookup functions
;;Get the combined set of all atoms in the KB
;(= (lookup-all ($cs $ps))
;   (combine (get-setspace-elements $cs)))

(= ((lookup_ff $s) ($elems $rules) $elem)
    (match $s ($elem $res) ((cons-atom $elem $elems) (cons-atom $res $rules))))

;;Get all atoms that proof any conclusion in the query set
(= (lookup-cset-in-kb ($cs $ps) $query)
   (myfoldr-atom $query (() ()) (lookup_ff $cs)))

(= (lookup-ccls ($cs $ps) $ccls)
   (match $cs ($ccls $rule) ($ccls $rule)))

;This could be smarter we could combine stuff

(= (lookup-pset-in-kb ($cs $ps) $query)
   (let $ss (get-state $ps) (combine (lookup-all-subsets $ss $query))))

;;Normalize a statement (remove parameters that are part of the conclusion)
(= (normalize ()) ())
(= (normalize (-> $pset $cset))
   (let $pset (if (== (get-metatype $pset) Variable) (()) $pset)
   (let $cset (if (== (get-metatype $cset) Variable) ($ccls) $cset)
   (let ($npset $_ $ncset) (overlap2 $pset $cset) (-> $npset $cset)))))

;;Takes a list/expression of statements and combines them
(= (combine $a) (normalize (myfold-atom1 $a unionStmt)))

;;Takes 2 statements and combines them
;;TODO should this also normalize the statements?
(= (unionStmt $stmt1 $stmt2)
   (if (or (== (get-metatype $stmt1) Variable) (== $stmt1 ()))
     $stmt2
     (if (or (== (get-metatype $stmt2) Variable) (== $stmt2 ()))
       $stmt1
       (let (-> $pset1 $cset1) (tracem stmt1 $stmt1)
         (let (-> $pset2 $cset2) (tracem stmt2 $stmt2)
           (-> (unique-union-atom $pset1 $pset2) (concat $cset1 $cset2)))))))

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;
(= (bcp $kb $depth_full (-> $pset $cset))
 (if-decons-expr $cset $ccls $ctail
  (let*
   ((debug (trace! (bcp $ccls $ctail) debug))
    ((-> $ppset $pcset) (bc $kb $depth_full (-> $pset $ccls)))
    ;(debug (trace! (Proof (-> $ppset $pcset)) debug))
   )
   (if (== $ctail ()) ;Don't recurse if there is nothing left to do
    (-> $ppset $pcset)
    (let* 
     ((($ncset $_cset $nctail) (overlap2 $pcset $ctail))
      ($npset (concat $pset $pcset))
      ;(debug (trace! (NPset $npset) debug))
      ((-> $rpset $rcset) (bcp $kb $depth_full (-> $npset $nctail)))
      ;(debug (trace! (Proof2 (-> $rpset $rcset)) debug))
     )
     (normalize (unionStmt (-> $ppset $pcset) (-> $rpset $rcset)))
    )
   )
  )
  ;$cset is empty nothing to do
  (-> $var $cset)
 )
)

(= (bc $kb $depth_full (-> $pset $ccls))
 (let* ;Go step backwards
  ((($ccls (-> $lc_pset $lc_cset)) (lookup-ccls $kb $ccls))
   (debug (trace! (lc (-> $lc_pset $lc_cset)) debug))
   (($_pset $opset $ppset) (overlap2 $pset $lc_pset))
   ;(debug (trace! (overlap2 $_pset $opset $ppset) debug))
  )
  ;Alternate to a forward step
  (if (== $ppset (()))
    (-> $lc_pset $lc_cset)
    (let (-> $a $b)
         ;(bcp $kb $depth_full (-> $pset $ppset))
         (fc $kb $depth_full (-> $pset $ppset)) ;Add $lc_set?
         (normalize (unionStmt (-> $lc_pset $lc_cset) (-> $a $b)))
    )
  )
 )
)

(= (fc $kb $depth_full (-> $pset $cset))
 (let* ;Go step forwards
  ((debug (trace! (fc (-> $pset $cset)) debug))
   (debug (trace! (lookup-pset-in-kb $kb $pset) debug))
   ((-> $lp_pset $lp_cset) (lookup-pset-in-kb $kb $pset)) ;TODO unification with $pset possible?
   (debug (trace! (lp (-> $lp_pset $lp_cset)) debug))
   (debug (trace! (overlapPre $lp_cset $cset) debug))
   (($_cset $ocset $pcset) (overlap $lp_cset $cset))
   (debug (trace! (overlap $_cset $ocset $pcset) debug))

   ($npset (concat $pset $lp_cset))
  )
  (unify $depth_full (S $depth) ;Check if we can search deeper
   (if (== (get-metatype $cset) Variable) ;If $cset is a variable just keep going forward
    (fc $kb $depth (-> $npset $pcset))
    (if (tracem =pc (== $pcset ())) ;If $pcset is empty we solved the problem otherwise we try to prove it
      (-> $lp_pset $lp_cset)
      (bcp $kb $depth (-> $npset $pcset))
    )
   )
   (if (== $pcset ()) ;If $pcset is empty we can return what we have
     (-> $lp_pset $lp_cset)
     Empty 
   )
  )
 )
)

;If $stmt is a CPU statement, then run the CPU function
;(= (runcpu $stmt)
;   (unify $stmt (: (CPU $f $args) (CPU $res)) (: (CPU $f $args) (CPU (cons-atom $f $args))) $stmt))

;Some tests
;!(bind! &s (init-kb))

;!(add-to-kb &s (-> ((: $a A) (: $b B)) ((: (f $a $b) C))))
;!(add-to-kb &s (-> ((: $b B)) ((: (f2 a $b) D))))
;!(add-to-kb &s (-> ((: $b B) (: $e E)) ((: (f3 a $b $e) F))))

;!(add-to-kb &s (-> (()) ((: a A))))
;!(add-to-kb &s (-> (()) ((: b B))))

;!(bind! &start ((py-atom time.time)))

;; Basic type queries
;!(assertEqual (limit 1 )
;    (-> () ((: a A))))
;!(bcp &s Z (-> $args ((: $a A) (: $b B))))

;!(bind! &end ((py-atom time.time)))
;!(- &end &start)

;!(assertEqual (bc &s (S (S Z)) (-> () ((: $p C))))
;    (-> () ((: a A) (: b B) (: (f a b) C))))
;
;!(assertEqual (bc &s (S (S Z)) (-> () ((: (f a b) $t))))
;    (-> () ((: a A) (: b B) (: (f a b) C))))
;;
;;;; Partial application
;!(assertEqual (bc &s (S (S Z)) (-> ((: $a A)) ((: $c C))))
;    (-> ((: $a A)) ((: b B) (: (f $a b) C))))
;
;!(assertEqual (bc &s (S Z) (-> $prms ((: (f $a b) $t))))
;    (-> () ((: a A) (: b B) (: (f a b) C))))
;
;!(assertEqual (bc &s (S (S Z)) (-> () ((: $d D))))
;    (-> () ((: b B) (: (f2 a b) D))))
;
;!(assertEqual (bc &s (S (S Z)) (-> $prms ((: (f2 a b) $t))))
;    (-> () ((: b B) (: (f2 a b) D))))
;
;!(assertEqual (bc &s (S (S Z)) (-> ((: $e E)) ((: $f F))))
;    (-> ((: $e E)) ((: b B) (: (f3 a b $e) F))))
;
;!(assertEqual (bc &s (S (S Z)) (-> ((: $e E)) ((: (f3 a b $e) $t))))
;    (-> ((: $e E)) ((: b B) (: (f3 a b $e) F))))
;
;!(bind! &f1 (init-kb))
;
;!(add-to-kb &f1 (-> () ((: (f1) A))))
;!(add-to-kb &f1 (-> ((: $b B)) ((: $a A) (: (f2 $a $b) C))))
;
;!(assertEqual (bc &f1 (S Z) (-> () ((: $a A)))) (-> () ((: (f1) A))))
;
;!(bind! &f2 (init-kb))
;
;!(add-to-kb &f2 (-> ((: $a A)) ((: (f1 $a) B))))
;!(add-to-kb &f2 (-> ((: $a A) (: $c C)) ((: (f2 $a $c) D))))
;
;!(assertEqual (bc &f2 (S Z) (-> ((: $a A)) $type)) (-> ((: $a A)) ((: (f1 $a) B))))

;!(bind! &f3 (init-kb))
;
;!(add-to-kb &f3 (-> ((: $a A)) ((: (f2 $a) B))))
;!(add-to-kb &f3 (-> ((: $z Z)) ((: (f2 $a) B))))
;!(add-to-kb &f3 (-> ((: $a A) (: $b B)) ((: (f3 $a $b) C))))
;!(add-to-kb &f3 (-> ((: $a A) (: $x X)) ((: (ff $a $x) Y))))
;!(add-to-kb &f3 (-> ((: $c C)) ((: (f4 $c) D))))
;
;!(assertEqual (bc &f3 (S (S Z)) (-> ((: $a A)) ((: $d D))))
;   (-> () ((: $a A))))
