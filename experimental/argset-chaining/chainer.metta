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
   (let* (($cs (new-space))
          ($ps (new-space))
          )
   ($cs $ps))
)

;;When adding an atom to the KB, it is first normalized
;;Then it is added to the indexed spaces
(= (add-to-kb ($cs $ps) $stmt)
   (let* (($nstmt (normalize $stmt))
          ((-> $pset $cset) $nstmt)
          ($_ (foldl-atom $cset () $accum $celem (let $_ $accum (add-atom $cs ($celem $nstmt)))))
          ($_ (foldl-atom $pset () $accum $pelem (let $_ $accum (add-atom $ps ($pelem $nstmt)))))
          )
   ())
)

(= (tracem $msg $a) (trace! ($msg $a) $a))

;;Lookup functions
;;Get the combined set of all atoms in the KB
;(= (lookup-all ($cs $ps))
;   (combine (get-setspace-elements $cs)))

(= ((lookup_ff $s) ($elems $rules) $elem)
    (match $s ($elem $res) ((cons-atom $elem $elems) (cons-atom $res $rules))))

;;Get all atoms that proof any conclusion in the query set
(= (lookup-cset-in-kb ($cs $ps) $query)
   (myfoldr-atom $query (() ()) (lookup_ff $cs)))

(= ((lookup_partial_ff $s) ($elems $rules) $elem)
    (unify $s ($elem $res) ((cons-atom $elem $elems) (cons-atom $res $rules)) ((cons-atom $elem $elems) $rules)))

;This could be smarter we could combine stuff
(= (lookup-pset-in-kb ($cs $ps) $query)
   (case (myfoldr-atom $query (() ()) (lookup_partial_ff $ps))
     ((Empty ($query $var))
      ($res $res)
     )
   ))

;;Normalize a statement (remove parameters that are part of the conclusion)
(= (normalize (-> $pset $cset))
   (let ($npset $_ $ncset) (overlap2 $pset $cset) (-> $npset $cset)))

;;Takes a list/expression of statements and combines them
(= (combine $a) (normalize (myfold-atom1 $a unionStmt)))

;;Takes 2 statements and combines them
;;TODO should this also normalize the statements?
(= (unionStmt $stmt1 $stmt2)
   (if (or (== (get-metatype $stmt1) Variable) (== $stmt1 ()))
     $stmt2
     (if (or (== (get-metatype $stmt2) Variable) (== $stmt2 ()))
       $stmt1
       (let (-> $pset1 $cset1) $stmt1
         (let (-> $pset2 $cset2) $stmt2
           (-> (unique-union-atom $pset1 $pset2) (concat $cset1 $cset2)))))))

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;
(: bc (-> $a                            ; Knowledge base space
          Nat                           ; Maximum depth
          $q                            ; Query
          $q))                          ; Result

(= (bcn $kb $depth_full $query) (bc $kb $depth_full (normalize $query)))

(= (bc $kb $depth_full (-> $pset $cset))
 (if (== $cset ()) (-> () ()) ;You can always proove the empty set
     (let* (;Lookup all combination of rules that proof our conclusions
            (debug (trace! (Query (-> $pset $cset)) debug))
            (($cset $cmatched) (if (== (get-metatype $cset) Expression) (lookup-cset-in-kb $kb $cset) ($cset $cmatched)))
            (debug (trace! (Cmatched $cmatched) debug))
            ;Lookup all combinations of rules that contain our parameters
            (($pset $pmatched) (if (== (get-metatype $pset) Expression) (lookup-pset-in-kb $kb $pset) ($pset $pmatched)))
            (debug (trace! (Pmatched $pmatched) debug))

            ;Combine all the rules into one
            ((-> $mpset $mcset) (combine (merge-nodups $cmatched $pmatched)))

            ;Check which parameters are covered
            ;$_pset we could use but don't need
            ;$npset is the set of parameters that are covered
            ;$ppset is the set of parameters that are not covered (need to prove them)
            (($_pset $npset $ppset) (overlap2 $pset $mpset))

            (debug (trace! (Psets $_pset $npset $ppset) debug))

            ;If there are no parameters to prove run the cpu functions
            ($mcset (if (== $ppset ()) (map-atom $mcset $s (runcpu $s)) $mcset))
           )
           (unify $depth_full (S $depth) ;Check if we can search deeper
             ;Now we try to prove ppset we know we can use pset for that
             ;But we can also use mcset since if ppset is proven we know mcset is proven
             (let (-> $fpset $fcset) (bc $kb $depth (-> (unique-union-atom $mcset $pset) $ppset))
             (let $mcset (map-atom $mcset $s (runcpu $s)) ;run cpu functions now that ppset is proven
                  (-> $npset (unique-union-atom $fcset $mcset))))
             (if (== $ppset ()) (-> $npset $mcset) (empty))))))

;If $stmt is a CPU statement, then run the CPU function
(= (runcpu $stmt)
   (unify $stmt (: (CPU $f $args) (CPU $res)) (: (CPU $f $args) (CPU (cons-atom $f $args))) $stmt))

;Some tests
!(bind! &s (init-kb))

!(add-to-kb &s (-> ((: $a A) (: $b B)) ((: (f $a $b) C))))
!(add-to-kb &s (-> ((: $b B)) ((: (f2 a $b) D))))
!(add-to-kb &s (-> ((: $b B) (: $e E)) ((: (f3 a $b $e) F))))

!(add-to-kb &s (-> () ((: a A))))
!(add-to-kb &s (-> () ((: b B))))

;!(let ($cs $ps) &s (add-atom $cs test))
;!(let ($cs $ps) &s (println! $cs))
;!(let ($cs $ps) &s (match $cs $a $a))

;!(let ($cs $ps) &s ((lookup_ff $cs) (() ()) (: $a A)))

;!(lookup-cset-in-kb &s ((: $a A)))

!(bind! &start ((py-atom time.time)))

;; Basic type queries
;!(assertEqual (limit 1 (bc &s Z (-> () ((: $_ A)))))
;    (-> () ((: a A))))
!(bc &s Z (-> () ((: $_ A))))

!(bind! &end ((py-atom time.time)))
!(- &end &start)

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

;Benchmark
;!(bind! &b (init-kb))
;
;!(add-to-kb &b (-> ((: $a A)) ((: (f0 $a) B))))
;!(add-to-kb &b (-> ((: $b B)) ((: (f1 $b) C))))
;!(add-to-kb &b (-> ((: $c C)) ((: (f2 $c) D))))
;!(add-to-kb &b (-> ((: $d D)) ((: (f3 $d) E))))
;!(add-to-kb &b (-> ((: $e E)) ((: (f4 $e) F))))
;!(add-to-kb &b (-> ((: $f F)) ((: (f5 $f) G))))
;!(add-to-kb &b (-> ((: $g G)) ((: (f6 $g) H))))
;!(add-to-kb &b (-> ((: $h H)) ((: (f7 $h) I))))
;!(add-to-kb &b (-> ((: $i I)) ((: (f8 $i) J))))
;!(add-to-kb &b (-> ((: $j J)) ((: (f9 $j) K))))
;
;!(bc &b (fromNumber 4) (-> ((: $a A)) ((: $k K))))
