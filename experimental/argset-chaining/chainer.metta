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
(= (init-kb $kb)
   (let* (($fs (create-setspace))
          ($cs (new-space))
          ($ps (new-space))
          (() (add-atom $kb (functionSpace $fs)))
          (() (add-atom $kb (conclusionSpace $cs)))
          (() (add-atom $kb (parameterSpace $ps)))
          )
   ())
)

;;When adding an atom to the KB, it is first normalized
;;Then it is added to the indexed spaces
(= (add-to-kb $kb $atom)
   (let* (($natom (normalize $atom))
          ($fs (match $kb (functionSpace $fs) $fs))
          ($cs (match $kb (conclusionSpace $cs) $cs))
          ($ps (match $kb (parameterSpace $ps) $ps))
          ((: $fset (-> $pset $cset)) $natom)
          ($natom (add-to-setspace $fs $fset $natom))
          ($_ (foldl-atom $cset () $accum $celem (let $_ $accum (add-atom $cs ($celem $natom)))))
          ($_ (foldl-atom $pset () $accum $pelem (let $_ $accum (add-atom $ps ($pelem $natom)))))
          )
   ())
)

;;Lookup functions

;;Get the combined set of atoms the minimally cover the query set
(= (lookup-fset-in-kb $kb $query)
   (match $kb (functionSpace $fs) (combine (lookup-in-setspace $fs $query))))

;;Get the combined set of all atoms in the KB
(= (lookup-all $kb)
   (match $kb (functionSpace $fs) (combine (get-setspace-elements $fs))))

(= ((lookup_ff $s) $accum $elem)
    (match $s ($elem $res) (cons-atom $res $accum)))

;;Get all atoms that proof any conclusion in the query set
(= (lookup-cset-in-kb $kb $query)
   (match $kb (conclusionSpace $cs) (combine (myfold-atom $query () (lookup_ff $cs)))))

;;Get all atoms that use any parameter in the query set
(= (lookup-pset-in-kb $kb $query)
   (match $kb (parameterSpace $ps) (combine (myfold-atom $query () (lookup_ff $ps)))))

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
           (: (unique-union-atom $fset1 $fset2) (-> (unique-union-atom $pset1 $pset2) (unique-union-atom $cset1 $cset2))))))))

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
 (if (== $cset ()) (: () (-> () ())) ;You can always proove the empty set
 (if (and (and (== (get-metatype $fset) Variable) (== (get-metatype $cset) Variable)) (== (get-metatype $pset) Variable)) ;If all the sets are variables combine everything
     (lookup-all $kb)
 (if (== (get-metatype $fset) Expression) ;If we have a fixed sed of functions just get those
     (withFset $kb $nquery)
     (let* (($cmatched (if (and (== (get-metatype $cset) Expression) (not (== $cset ()))) (lookup-cset-in-kb $kb $cset) $cmatched))
            ($pmatched (if (and (== (get-metatype $pset) Expression) (not (== $pset ()))) (lookup-pset-in-kb $kb $pset) $pmatched))

            ((: $mfset (-> $mpset $mcset)) (normalize (unionStmt $cmatched $pmatched)))

            (($_pset $npset $ppset) (overlap2 $pset $mpset))
            ((() $cset $pcset) (overlap2 $cset $mcset))
           )
           (unify $depth_full (S $depth) 
            (let (: $pfset (-> $fpset $fcset)) (bc $kb $depth (: $fset (-> $pcset $ppset)))
                 (: (unique-union-atom $mfset $pfset) (-> $npset (unique-union-atom $pcset (unique-union-atom $cset $fcset)))))
            (if (== $ppset ()) (: $mfset (-> $npset $mcset)) (empty))
            ))))))))


;Some tests
!(bind! &s (new-space))

!(init-kb &s)

!(add-to-kb &s (: (f) (-> ((: $a A) (: $b B)) ((: (f $a $b) C)))))
!(add-to-kb &s (: (f2 a) (-> ((: $b B)) ((: (f2 a b) D)))))
!(add-to-kb &s (: (f3 a) (-> ((: $b B) (: $e E)) ((: (f3 a $b $e) F)))))

!(add-to-kb &s (: (a) (-> () ((: (a) A)))))
!(add-to-kb &s (: (b) (-> () ((: (b) B)))))

; Basic type queries
!(assertEqual (bc &s Z (: $fset (-> () ((: $_ A)))))
    (: (a) (-> () ((: (a) A)))))

!(assertEqual (bc &s (S (S Z)) (: $p (-> () ((: $_ C)))))
    (: (f b a) (-> () ((: (f (a) (b)) C) (: (a) A) (: (b) B)))))

!(assertEqual (bc &s (S (S Z)) (: (f a b) $t))
    (: (a b f) (-> () ((: (a) A) (: (b) B) (: (f (a) (b)) C)))))

;; Partial application
!(assertEqual (bc &s (S (S Z)) (: $prf (-> ((: $a A)) ((: $c C)))))
    (: (f b) (-> ((: $a A)) ((: (f $a (b)) C) (: (b) B)))))

!(assertEqual (bc &s (S (S Z)) (: (f b) $t))
    (: (b f) (-> ((: $a A)) ((: (b) B) (: (f $a (b)) C)))))

!(assertEqual (bc &s (S (S Z)) (: $prf (-> () ((: $d D)))))
    (: (f2 a b) (-> () ((: (f2 a b) D) (: (b) B)))))
!(assertEqual (bc &s (S (S Z)) (: (f2 a b) $t))
    (: (f2 a b) (-> () ((: (f2 a b) D) (: (b) B)))))
!(assertEqual (bc &s (S (S Z)) (: (f2 b a) $t))
    (: (f2 a b) (-> () ((: (f2 a b) D) (: (b) B)))))

!(assertEqual (bc &s (S (S Z)) (: $prf (-> ((: $e E)) ((: $f F)))))
    (: (f3 a b) (-> ((: $e E)) ((: (f3 a (b) $e) F) (: (b) B)))))
!(assertEqual (bc &s (S (S Z)) (: (f3 a b) (-> ((: $e E)) ((: $f F)))))
    (: (f3 a b) (-> ((: $e E)) ((: (f3 a (b) $e) F) (: (b) B)))))
!(assertEqual (bc &s (S (S Z)) (: (f3 a b) $t))
    (: (f3 a b) (-> ((: $e E)) ((: (f3 a (b) $e) F) (: (b) B)))))

!(bind! &f1 (new-space))

!(init-kb &f1)

!(add-to-kb &f1 (: (f1) (-> () ((: (f1) A)))))
!(add-to-kb &f1 (: (f2) (-> ((: $b B)) ((: $a A) (: (f2 $a $b) C)))))

!(assertEqual (bc &f1 (S Z) (: $fset (-> () ((: $a A))))) (: (f1) (-> () ((: (f1) A)))))

!(bind! &f2 (new-space))

!(init-kb &f2)

!(add-to-kb &f2 (: (f1) (-> ((: $a A)) ((: (f1 $a) B)))))
!(add-to-kb &f2 (: (f2) (-> ((: $a A) (: $c C)) ((: (f2 $a $c) D)))))

!(assertEqual (bc &f2 (S Z) (: $fset (-> ((: $a A)) $type))) (: (f1) (-> ((: $a A)) ((: (f1 $a) B)))))
