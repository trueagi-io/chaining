!(import! &self setspace)

;; Define Nat
(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

;; Define <=
(: <= (-> $a $a Bool))
(= (<= $x $y) (or (< $x $y) (== $x $y)))

;; Define cast functions between Nat and Number
(: fromNumber (-> Number Nat))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))
(: fromNat (-> Nat Number))
(= (fromNat Z) 0)
(= (fromNat (S $k)) (+ 1 (fromNat $k)))

;; Custom fold function since the stdlib version has issues
(= (myfold-atom $list $init $f)
   (if-decons-expr $list $head $tail
      (myfold-atom $tail ($f $init $head) $f)
      $init))

;(= ((elem $eqf) $list $elem) 
;   (foldl-atom $list False $accum $candiate (let $eq ($eqf $candiate $elem) (or $accum $eq))))

(= ((elem_ff $eqf $elem) $accum $candidate) (let $eq ($eqf $candidate $elem) (or $accum $eq)))

(= ((elem $eqf) $list $elem)
   (myfold-atom $list False (elem_ff $eqf $elem)))

;; Check if 2 elements are unifiable
(= (unifiable $a $b) (unify $a $b True False))

;; Check if 2 elements are unifiable
(= (unifiable2 $a $b) (unify $a $b $a Empty))

!(assertEqual (unifiable a a) True)
!(assertEqual (unifiable a b) False)

;; Check if an element is proofable
(= (proofable $kb $depth $query)
   (case (bc $kb $depth $query)
     ((Empty False)
     ($res True))))

(= (traceid $x) (trace! $x $x))

;; Check if 2 elements are proofable
(= ((unifyproof $kb $depth) (: $p $t) $b) (let $b1 (unifiable (: $p $t) $b) (let $b2 (proofable $kb $depth (: $prf (-> ($b) $t))) (or $b1 $b2))))

(= (elemunify $list $elem) ((elem unifiable) $list $elem))

!(assertEqual (elemunify ((a $a) (b $b)) (a a)) True)

(= ((elemproof $kb $depth) $list $elem) ((elem (unifyproof $kb $depth)) $list $elem))

;;Subtract one set from another
(= ((sub_ff $list) $accum $elem)
   (if (elemunify $list $elem) $accum (cons-atom $elem $accum)))

(: substract (-> Expression Expression Expression))
(= (substract $list1 $list2)
   (myfold-atom $list1 () (sub_ff $list2)))

;;Remove one element from a set
(= ((removef $eqf) $list $elem) (let ($bool $nlist) ((removef_rec $eqf) $list $elem False) (if $bool $nlist Empty)))

(= ((removef_rec $eqf) $list $elem $bool)
   (if-decons-expr $list $head $tail
      (if ($eqf $head $elem) (True $tail) (let ($nbool $new_tail) ((removef_rec $eqf) $tail $elem $bool) ($nbool (cons-atom $head $new_tail))))
      ($bool $list)))

(= (remove $list $elem) ((removef ==) $list $elem))
(= (removeUnifiable $list $elem) ((removef unifiable) $list $elem))
(= ((removeProofable $kb $depth) $list $elem) ((removef (unifyproof $kb $depth)) $list $elem))

!(assertEqual (remove (a b c) a) (b c))

;;Check if two sets are unifiable
(= (seteq_ff ($b $lst) $elem)
     (let $nlst (removeUnifiable $lst $elem) ($b $nlst)))

(= (seteq $list1 $list2)
   (if (or (== (get-metatype $list1) Variable) (== (get-metatype $list2) Variable))
     True
     (let ($b $l2) (myfold-atom $list1 (True $list2) seteq_ff) (and $b (== $l2 ())))))

!(assertEqual (seteq (a b) (b a)) True)
!(assertEqual (seteq (a b) (a b)) True)

;;Check if one set is a subset of another up to unifiability
(= (subset $list1 $list2)
   (if (or (== (get-metatype $list1) Variable) (== (get-metatype $list2) Variable)) True
   (let ($b $l2) (myfold-atom $list1 (True $list2) seteq_ff) $b)))


(= ((subsetprf_ff $kb $depth $lst) $b $elem)
   (if ((elemproof $kb $depth) $lst $elem) $b False))

;;Check if list1 is a subset of list2 up to proofability
(= ((subsetprf $kb $depth) $list1 $list2)
   (if (or (== (get-metatype $list1) Variable) (== (get-metatype $list2) Variable)) True
   (let ($b $l2) (myfold-atom $list1 True (subsetprf_ff $kb $depth $list2)) $b)))

(= (subtract_subset $list1 $list2)
    (myfold-atom $list1 $list2 remove))

(= ((subtract_subset_proof $kb $depth) $list1 $list2)
    (myfold-atom $list1 $list2 (removeProofable $kb $depth)))


;;Concat 2 sets together
(= (concat $list1 $list2)
   (if (== (get-metatype $list1) Variable)
     $list2
     (if (== (get-metatype $list2) Variable)
     $list1
     (union-atom $list1 $list2))))

;; Check if an element is proofable
(= (proofable $kb $depth $query)
   (case (bc $kb $depth $query)
     ((Empty False)
     ($res True))))

(= ((proof $kb $depth) $a (: $pb $tb)) (bc $kb $depth (: $prf (-> ($a) $tb))))

(= ((removef_rec2 $eqf) $list $elem)
   (if-decons-expr $list $head $tail
      (case ($eqf $elem $head)
        ((Empty (let ($res $ntail) ((removef_rec2 $eqf) $tail $elem) ($res (cons-atom $head $ntail))))
         ($res ($res $tail))
        ))
      (() $list)
   ))

(= (meq $a $b) (if (== $a $b) True Empty))

!(assertEqual ((removef_rec2 meq) (a b c) x) (() (a b c)))

(= ((overlap_ff $eqf) ($left $intersection $right) $elem)
   (let ($res $nright) ((removef_rec2 $eqf) $right $elem)
     (if (== $res ())
        ((cons-atom $elem $left) $intersection $nright)
        ($left (cons-atom $elem $intersection) $nright))))

(= ((overlap $eqf) $list1 $list2)
   (if (== (get-metatype $list1) Variable)
     (() $list2 ())
     (if (== (get-metatype $list2) Variable)
       (() $list1 ())
       (myfold-atom $list1 (() () $list2) (overlap_ff $eqf)))))

(= ((overlap2 $eqf) $list1 $list2)
   (if (== (get-metatype $list1) Variable)
     (() () $list2)
     (if (== (get-metatype $list2) Variable)
       ($list1 () ())
       (myfold-atom $list1 (() () $list2) (overlap_ff $eqf)))))

;!((overlap ==) (a b c) (a b d))
!(assertEqual ((overlap meq) (a) (c)) ((a) () (c)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; To simplify the chainer we assume that everything is a function
;; So (: a A) needs to be exppressed as (: (a ()) (-> () A))

;; To convert to the function from we have the following
(= (cleanThrm $thrm) (unify $thrm (-> $prms $ccls) (-> $prms $ccls) (-> () $thrm)))
(= (cleanPrf $prf) (unify $prf ($abs $args) ($abs $args) ($prf ())))
(= (cleanStmt (: $prf $thrm)) (: (cleanPrf $prf) (cleanThrm $thrm)))

;; And this is to convert back to the original form
(= (prettyThrm $thrm) (unify $thrm (-> () $ccls) $ccls $thrm))
(= (prettyPrf $prf) (unify $prf ($abs ()) $abs $prf))
(= (prettyStmt (: $prf $thrm)) (: (prettyPrf $prf) (prettyThrm $thrm)))

!(assertEqualToResult (prettyStmt (cleanStmt (: a A))) ((: a A)))


(= (myunique $a) (if (== (get-metatype $a) Variable) $a (unique-atom $a)))

(= (unique-union-atom $a $b) (let $res (concat $a $b) (myunique $res)))

(= (unionStmt $stmt1 $stmt2)
   (if (or (== (get-metatype $stmt1) Variable) (== $stmt1 ()))
     $stmt2
     (if (or (== (get-metatype $stmt2) Variable) (== $stmt2 ()))
       $stmt1
       (let (: $fset1 (-> (: $pset1 $aset1) $cset1)) $stmt1
         (let (: $fset2 (-> (: $pset2 $aset2) $cset2)) $stmt2
           (: (unique-union-atom $fset1 $fset2) (-> (: (unique-union-atom $pset1 $pset2) (unique-union-atom $aset1 $aset2)) (unique-union-atom $cset1 $cset2))))))))

(= (myfold-atom1 $list $f)
   (if (== (get-metatype $list) Variable)
     $list
     (if-decons-expr $list $head $tail
        (myfold-atom $tail $head $f)
        $list)))

;!(myfold-atom1 ((: (a) (-> () (A))) (: (b) (-> () (B)))) unionStmt)

;!(myfold-atom1 ((: (a) (-> ((: $var X)) (A)))) unionStmt)

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;
(: bc (-> $a                            ; Knowledge base space
          Nat                           ; Maximum depth
          $q                            ; Query
          $q))                          ; Result


(= (bc $kb $depth_full (: $fset (-> (: $pset $aset) $cset)))
 ;(unify $kb (: $ufset (-> (: $pset $aset) $cset)) (let ($_ $nfset ()) ((overlap unifiable2) $fset $ufset) (: $nfset (-> (: $pset $aset) $cset)))
 (case (if (== (get-metatype $fset) Variable)
           (unify $kb (: $fset (-> (: $pset $aset) $cset)) (: $fset (-> (: $pset $aset) $cset)) ()) 
           ;(myfold-atom1 (map-atom $fset $f (match $kb (: ($f) (-> (: $pset $aset) $cset)) (: ($f) (-> (: $pset $aset) $cset)))) unionStmt))
           (myfold-atom1 (traceid (lookup-fset-in-kb $kb $fset)) unionStmt))
   (((: $uf (-> (: $up $ua) $uc))
     (let ($nua $nuac $nuc) (trace! (Overlap $ua $uc) ((overlap2 unifiable2) $ua $uc)) (: $uf (-> (: $up $nua) $nuc)))
    )
    (() 
     (let ($naset $_ $ncset) (trace! ($aset $cset) ((overlap2 unifiable2) $aset $cset))
       (if (== $ncset ())
        (: () (-> (: () ()) ()))
        ;Base Case
        ;Recursive steps
        (let* (((S $depth) $depth_full)

               (debug (trace! (Query (: $fset (-> (: $pset $naset) $ncset))) debug))

               (debug (trace! (TryMatch (map-atom $ncset $conclusion (: $fset (-> $matched_prms ($conclusion))))) debug))

               ($mres (map-atom $ncset $conclusion (bc $kb $depth (sealed $fset (: $fset (-> $matched_prms ($conclusion)))))))

               (debug (trace! (Mres $mres) debug))

               ((: $mfset (-> (: $mpset $maset) $mcset)) (myfold-atom1 $mres unionStmt))

               (debug (trace! (Match (: $mfset (-> (: $mpset $maset) $mcset))) debug))

               ;(($mprms $_ ()) ((overlap (unifyproof $kb $depth)) $mpset $mcset))

               ;($clean_mpset (myfold-atom1 (map-atom $mpset $elem (let (: $prf (-> $prms $type)) $elem $type)) unique-union-atom))

               (debug (trace! (Proof1 (: $fset (-> (: $pset $naset) $maset))) debug))

               ((: $pfset (-> (: $ppset $paset) $pcset)) (traceid (bc $kb $depth (: $fset (-> (: $pset $naset) $maset)))))

               (debug (trace! (Proof2 (: $pfset (-> (: $ppset $paset) $pcset))) debug))
   )
(: (unique-union-atom $mfset $pfset) (-> (: $ppset (unique-union-atom $naset $paset)) $ncset)))))))))



;Sometimes we get $var#1234 in the output which causes the assert to fail
(: myAssertEqual (-> Atom Atom Expression))
(= (myAssertEqual $x $y)
   (case $x
    ((Empty (Error $x is empty missing $y))
     ($out (unify $out $y () (Error $out should equal $y)))
     )))
!(bind! &kb (new-space))

!(add-atom &kb (: (b) (-> (: () ()) (B))))
!(add-atom &kb (: (b_d) (-> (: $b (B)) (D))))

;!(myAssertEqual (bc &kb Z (: $prf (-> $_ (B))))
  ;(: (b) (-> $a (B))))
;!(myAssertEqual (bc &kb Z (: $prf (-> (: $_ ()) (B)))) 
  ;(: (b) (-> $a (B))))

;!(myAssertEqual (bc &kb (S Z) (: $prf (-> (: $_ ()) (D)))) (: $prf (-> (: $_ ()) (D))))

!(bind! &kb2 (new-space))

!(add-atom &kb2 (: (a_c) (-> (: $a (A)) (C))))
!(add-atom &kb2 (: (c_d) (-> (: $c (C)) (D))))

;!(bc &kb2 (S Z) (: $prf (-> (: $a (A)) (D))))
;!(bc &kb2 (S Z) (: (a_c c_d) (-> (: $a (A)) (D))))
;!(bc &kb2 (S Z) (: (a_c c_d) $t))


(= (init-kb $kb $fs $cs)
   (let* (($fs (create-space $fs))
          ($cs (create-space $cs))
          (() (add-atom $kb (functionSpace $fs)))
          (() (add-atom $kb (conclusionSpace $cs)))
          )
   ())
)

(= (add-to-kb $kb $atom)
   (let* (($fs (match $kb (functionSpace $fs) $fs))
          ($cs (match $kb (conclusionSpace $cs) $cs))
          ((: $fset (-> (: $pset $aset) $cset)) $atom)
          ($atom (add-to-space $fs $fset $atom))
          ($atom (add-to-space $cs $cset $atom))
          )
   (add-atom $kb $atom))
)

(= (lookup-fset-in-kb $kb $query)
   (match $kb (functionSpace $fs) (lookup-in-space $fs $query)))

(= (lookup-cset-in-kb $kb $query)
   (match $kb (conclusionSpace $cs) (lookup-in-space $cs $query)))
          

;Some tests
!(bind! &s (new-space))

!(init-kb &s fs cs)

!(add-to-kb &s (: (f) (-> (: $pab (A B)) (C))))
!(add-to-kb &s (: (f2 a) (-> (: $b (B)) (D))))
!(add-to-kb &s (: (f3 a) (-> (: $b (B E)) (F))))

!(add-to-kb &s (: (a) (-> (: () ()) (A))))
!(add-to-kb &s (: (b) (-> (: () ()) (B))))

;!(myAssertEqual (lookup-fset-in-kb &s (f a))
;  [(: (a) (-> (: () ()) (A)))
;  ,(: (f) (-> (: $pab (A B)) (C)))])

; Basic type queries
!(assertEqual (bc &s Z (: $prf (-> $a (A))))
    (: (a) (-> (: () ()) (A))))

!(assertEqual (bc &s (S (S Z)) (: $p (-> (: $_ ()) (C))))
    (: (f b a) (-> (: () ()) (C))))

!(assertEqual (bc &s (S (S Z)) (: (f a b) $t))
    (: (a b f) (-> (: () ()) (C))))

;; Partial application
!(assertEqual (bc &s (S (S Z)) (: $prf (-> (: $a (A)) (C))))
    (: (f b) (-> (: () (A)) (C))))

!(myAssertEqual (bc &s (S (S Z)) (: (f b) $t))
    (: (b f) (-> (: () (A)) (C))))
;;
!(assertEqual (bc &s (S (S Z)) (: $prf (-> (: () ()) (D))))
    (: (f2 a b) (-> (: () ()) (D))))
!(myAssertEqual (bc &s (S (S Z)) (: (f2 a b) $t))
    (: (f2 a b) (-> (: () ()) (D))))
!(myAssertEqual (bc &s (S (S Z)) (: (f2 b a) $t))
    (: (f2 a b) (-> (: () ()) (D))))
;
!(assertEqual (bc &s (S (S Z)) (: $prf (-> (: $e (E)) (F))))
    (: (f3 a b) (-> (: () (E)) (F))))
!(assertEqual (bc &s (S (S Z)) (: (f3 a b) (-> (: $e (E)) (F))))
    (: (f3 a b) (-> (: () (E)) (F))))
!(myAssertEqual (bc &s (S (S Z)) (: (f3 a b) $t))
    (: (f3 a b) (-> (: () (E)) (F))))

!(bind! &k (new-space))

!(init-kb &k fs cs)

!(add-to-kb &k (: (f0) (-> (: $pab (A B)) (C))))
!(add-to-kb &k (: (f1) (-> (: $pab (C)) (D))))
!(add-to-kb &k (: (f2) (-> (: $pab (A)) (B))))

!(bc &k Z (: (f0 f1 f2) $t))
