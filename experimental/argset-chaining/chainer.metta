!(import! &self setspace)
!(import! &self utils)
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
   (let* (($fs (create-setspace))
          ($cs (new-space))
          ($ps (create-setspace))
          )
   ($fs $cs $ps))
)

;;When adding an atom to the KB, it is first normalized
;;Then it is added to the indexed spaces
(= (add-to-kb ($fs $cs $ps) $nstmt)
   (let* (($nstmt (normalize $stmt))
          ((: $fset (-> $pset $cset)) $nstmt)
          ($nstmt (add-to-setspace $fs $fset $nstmt))
          ($_ (foldl-atom $cset () $accum $celem (let $_ $accum (add-atom $cs ($celem $nstmt)))))
          ($_ps (add-to-ps $ps $nstmt))
          )
   ())
)

(= (typeonl_ff $accum (: $prf $type)) (cons-atom $type $accum))

(= (typeonly $stmts) (myfold-atom $stmts () typeonl_ff))

(= (add-to-ps $ps $stmt)
   (let (: $fset (-> $pset $cset)) $stmt
   (let $ptypes (typeonly $pset)
   (let $res (partial-lookup-in-setspace $ps $ptypes)
   (let $cres (myfold-atom $res () concat)
   (let $stmts (cons-atom $stmt $cres)
   (let (: $nfset (-> $npset $ncset)) (combine $stmts)
   (let $nptypes (typeonly $npset)
   (add-to-setspace $ps $nptypes $stmts)))))))))

(= (tracem $msg $a) (trace! ($msg $a) $a))

;;Lookup functions

;;Get the combined set of atoms the minimally cover the query set
(= (lookup-fset-in-kb ($fs $cs $ps) $query)
   (combine (lookup-in-setspace $fs $query)))

;;Get the combined set of all atoms in the KB
(= (lookup-all ($fs $cs $ps))
   (combine (get-setspace-elements $fs)))

(= ((lookup_ff $s) $accum $elem)
    (match $s ($elem $res) (cons-atom $res $accum)))

;;Get all atoms that proof any conclusion in the query set
(= (lookup-cset-in-kb ($fs $cs $ps) $query)
   (myfold-atom $query () (lookup_ff $cs)))

;;Get all atoms that use any parameter in the query set
(= (lookup-pset-in-kb ($fs $cs $ps) $query)
   (let $qtypes (typeonly $query)
   (myfold-atom (partial-lookup-in-setspace $ps $qtypes) () concat)))

;;Normalize a statement (remove parameters that are part of the conclusion)
(= (normalize (: $fset (-> $pset $cset)))
   (let ($npset $_ $ncset) (overlap2 $pset $cset) (: $fset (-> $npset $cset))))

;;Takes a list/expression of statements and combines them
(= (combine $a) (normalize (myfold-atom1 $a unionStmt)))

;;Takes 2 statements and combines them
;;TODO should this also normalize the statements?
(= (unionStmt $stmt1 $stmt2)
   (if (or (== (get-metatype $stmt1) Variable) (== $stmt1 ()))
     $stmt2
     (if (or (== (get-metatype $stmt2) Variable) (== $stmt2 ()))
       $stmt1
       (let (: $fset1 (-> $pset1 $cset1)) $stmt1
         (let (: $fset2 (-> $pset2 $cset2)) $stmt2
           (: (unique-union-atom $fset1 $fset2) (-> (unique-union-atom $pset1 $pset2) (concat $cset1 $cset2))))))))

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;
(: bc (-> $a                            ; Knowledge base space
          Nat                           ; Maximum depth
          $q                            ; Query
          $q))                          ; Result

(= (withFset $kb (: $fset (-> $pset $cset)))
   (let (: $ffset (-> $fpset $fcset)) (lookup-fset-in-kb $kb $fset) ;can't match $fset since order might be different
   (let ($_pset $npset ()) (overlap $pset $fpset) ;check that we dont need more parameters than $pset and remove unneeded ones
   (let (() $ncset $_cset) (overlap $cset $fcset) ;check if $cset is a subset of $fcset
        (: $ffset (-> $npset $fcset))))))

(= (bc $kb $depth_full $query)
 (let $nquery (normalize $query) ;First normalize the query
 (let (: $fset (-> $pset $cset)) $nquery ;Deconstruct the query
 (if (== $cset ()) (: () (-> (()) ())) ;You can always proove the empty set
 (if (and (and (== (get-metatype $fset) Variable) (== (get-metatype $cset) Variable)) (== (get-metatype $pset) Variable)) ;If all the sets are variables combine everything
     (lookup-all $kb)
 (if (== (get-metatype $fset) Expression) ;If we have a fixed sed of functions just get those
     (withFset $kb $nquery)
     (let* (;(debug (trace! (Query $nquery) debug))
            ($cmatched (if (and (== (get-metatype $cset) Expression) (not (== $cset ()))) (lookup-cset-in-kb $kb $cset) $cmatched))
            ;(debug (trace! (Cmatched $cmatched) debug))
            ($pmatched (if (and (== (get-metatype $pset) Expression) (not (== $pset ()))) (lookup-pset-in-kb $kb $pset) $pmatched))
            ;(debug (trace! (Pmatched $pmatched) debug))

            (($co $cp $po) (overlap2 $cmatched $pmatched)) ;TODO we could just store function names in cspace anc pspace and then just do a lookup in the fspace

            ;(debug (trace! (cocppo $co $cp $po) debug))

            ((: $mfset (-> $mpset $mcset)) (combine (concat $co (concat $cp $po))))

            (debug (trace! (F (: $mfset (-> $mpset $mcset))) debug))

            ;(debug (trace! (Ovlerap $pset $mpset) debug))
            (($_pset $npset $ppset) (overlap2 $pset $mpset))

            ;(debug (trace! (Overlap $cset $mcset) debug))
            ((() $ncset $pcset) (overlap2 $cset $mcset))
            ;(debug (trace! (O $_cset $ncset $pcset) debug))

            ;(debug (trace! (unique-union-atom $pcset $pset) debug))
            ($mcset (if (== $ppset ()) (map-atom $mcset $s (runcpu $s)) $mcset))
           )
           (unify $depth_full (S $depth) 
             (let (: $pfset (-> $fpset $fcset)) (bc $kb $depth (: $fset (-> $pcset $ppset))); (-> (unique-union-atom $pcset $pset) $ppset)))
                  (: (unique-union-atom $mfset $pfset) (-> $npset (unique-union-atom $pcset (unique-union-atom $ncset $fcset)))))
             (if (== $ppset ()) (: $mfset (-> $npset $mcset)) (empty))))))))))

(= (runcpu $stmt)
   (trace! (cpu $stmt) (unify $stmt (: (CPU $f $args) (CPU $res)) (: (CPU $f $args) (CPU (cons-atom $f $args))) $stmt)))

!(bind! &t (init-kb))

!(add-to-kb &t (: (cpu) (-> () ((: (CPU $f $args) (CPU $res))))))
;!(add-to-kb &t (: (add) (-> ((: $pn1 (Number $n1)) (: $pn2 (Number $n2)) (: (CPU + ($n1 $n2)) (CPU $n3))) ((: (add $pn1 $pn2) (Number $n3)))))) 
!(add-to-kb &t (: (increment) (-> ((: $pn1 (Number $n1)) (: (CPU + ($n1 1)) (CPU $n2))) ((: (add $pn1) (Inc $n2))))))
;!(add-to-kb &t (: (add) (-> ((: $pn1 (Number $n1)) (: $pn2 (Number $n2))) ((: (add $pn1 $pn2) (Add $n1 $n2))))))
!(add-to-kb &t (: (n1) (-> () ((: (n1) (Number 1))))))
;!(add-to-kb &t (: (n2) (-> () ((: (n2) (Number 2))))))

;!(add-to-kb &t (: (n1) (-> (()) ((: (n1) (Number Z))))))
;!(add-to-kb &t (: (inc) (-> ((: $pn1 (Number $n1))) ((: (inc $pn1) (Number (S $n1)))))))

!(bc &t (S Z) (: $fset (-> () ((: $p (Inc $n))))))

;Some tests
;!(bind! &s (init-kb))
;
;!(add-to-kb &s (: (f) (-> ((: $a A) (: $b B)) ((: (f $a $b) C)))))
;!(add-to-kb &s (: (f2 a) (-> ((: $b B)) ((: (f2 a b) D)))))
;!(add-to-kb &s (: (f3 a) (-> ((: $b B) (: $e E)) ((: (f3 a $b $e) F)))))
;
;!(add-to-kb &s (: (a) (-> () ((: (a) A)))))
;!(add-to-kb &s (: (b) (-> () ((: (b) B)))))
;
;; Basic type queries
;!(assertEqual (bc &s Z (: $fset (-> () ((: $_ A)))))
;    (: (a) (-> () ((: (a) A)))))
;
;!(assertEqual (bc &s (S (S Z)) (: $p (-> () ((: $_ C)))))
;    (: (f b a) (-> () ((: (f (a) (b)) C) (: (a) A) (: (b) B)))))
;
;!(assertEqual (bc &s (S (S Z)) (: (f a b) $t))
;    (: (a b f) (-> () ((: (a) A) (: (b) B) (: (f (a) (b)) C)))))
;
;;; Partial application
;!(assertEqual (bc &s (S (S Z)) (: $prf (-> ((: $a A)) ((: $c C)))))
;    (: (f b) (-> ((: $a A)) ((: (f $a (b)) C) (: (b) B)))))
;
;!(assertEqual (bc &s (S (S Z)) (: (f b) $t))
;    (: (b f) (-> ((: $a A)) ((: (b) B) (: (f $a (b)) C)))))
;
;!(assertEqual (bc &s (S (S Z)) (: $prf (-> () ((: $d D)))))
;    (: (f2 a b) (-> () ((: (f2 a b) D) (: (b) B)))))
;!(assertEqual (bc &s (S (S Z)) (: (f2 a b) $t))
;    (: (f2 a b) (-> () ((: (f2 a b) D) (: (b) B)))))
;!(assertEqual (bc &s (S (S Z)) (: (f2 b a) $t))
;    (: (f2 a b) (-> () ((: (f2 a b) D) (: (b) B)))))
;
;!(assertEqual (bc &s (S (S Z)) (: $prf (-> ((: $e E)) ((: $f F)))))
;    (: (f3 a b) (-> ((: $e E)) ((: (f3 a (b) $e) F) (: (b) B)))))
;!(assertEqual (bc &s (S (S Z)) (: (f3 a b) (-> ((: $e E)) ((: $f F)))))
;    (: (f3 a b) (-> ((: $e E)) ((: (f3 a (b) $e) F) (: (b) B)))))
;!(assertEqual (bc &s (S (S Z)) (: (f3 a b) $t))
;    (: (f3 a b) (-> ((: $e E)) ((: (f3 a (b) $e) F) (: (b) B)))))
;
;!(bind! &f1 (init-kb))
;
;!(add-to-kb &f1 (: (f1) (-> () ((: (f1) A)))))
;!(add-to-kb &f1 (: (f2) (-> ((: $b B)) ((: $a A) (: (f2 $a $b) C)))))
;
;!(assertEqual (bc &f1 (S Z) (: $fset (-> () ((: $a A))))) (: (f1) (-> () ((: (f1) A)))))
;
;!(bind! &f2 (init-kb))
;
;!(add-to-kb &f2 (: (f1) (-> ((: $a A)) ((: (f1 $a) B)))))
;!(add-to-kb &f2 (: (f2) (-> ((: $a A) (: $c C)) ((: (f2 $a $c) D)))))
;
;!(assertEqual (bc &f2 (S Z) (: $fset (-> ((: $a A)) $type))) (: (f1) (-> ((: $a A)) ((: (f1 $a) B)))))

;!(bind! &f3 (new-space))
;
;!(init-kb &f3)
;
;!(add-to-kb &f3 (: (f2) (-> ((: $a A)) ((: (f2 $a) B)))))
;!(add-to-kb &f3 (: (f2) (-> ((: $z Z)) ((: (f2 $a) B)))))
;!(add-to-kb &f3 (: (f3) (-> ((: $a A) (: $b B)) ((: (f3 $a $b) C)))))
;!(add-to-kb &f3 (: (ff) (-> ((: $a A) (: $x X)) ((: (ff $a $x) Y)))))
;!(add-to-kb &f3 (: (f4) (-> ((: $c C)) ((: (f4 $c) D)))))

;!(match &f3 (parameterSpace $ps) (partial-lookup-in-setspace $ps ((: $a A) (: $d D))))
;!(match &f3 (parameterSpace $ps) (pretty-print-setspace $ps))

;!(lookup-pset-in-kb &f3 ((: $a A)))

;!(assertEqual
;!(bc &f3 Z (: $fset (-> ((: $a A)) ((: $d D)))))
 ;(: (f1) (-> () ((: (f1) A)))))


;Benchmark
;!(bind! &b (init-kb))
;
;!(add-to-kb &b (: (a) (-> (()) ((: (a) A)))))
;!(add-to-kb &b (: (f0) (-> ((: $a A)) ((: (f0 $a) B)))))
;!(add-to-kb &b (: (f1) (-> ((: $b B)) ((: (f1 $b) C)))))
;!(add-to-kb &b (: (f2) (-> ((: $c C)) ((: (f2 $c) D)))))
;!(add-to-kb &b (: (f3) (-> ((: $d D)) ((: (f3 $d) E)))))
;!(add-to-kb &b (: (f4) (-> ((: $e E)) ((: (f4 $e) F)))))
;!(add-to-kb &b (: (f5) (-> ((: $f F)) ((: (f5 $f) G)))))
;!(add-to-kb &b (: (f6) (-> ((: $g G)) ((: (f6 $g) H)))))
;!(add-to-kb &b (: (f7) (-> ((: $h H)) ((: (f7 $h) I)))))
;!(add-to-kb &b (: (f8) (-> ((: $i I)) ((: (f8 $i) J)))))
;!(add-to-kb &b (: (f9) (-> ((: $j J)) ((: (f9 $j) K)))))
;
;!(bc &b (fromNumber 5) (: $fset (-> ((: $a A)) ((: $k K)))))
