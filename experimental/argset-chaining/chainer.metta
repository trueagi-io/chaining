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

!(unique-atom (a a b))

!(unique-union-atom (a b) (b c))


(= (unionStmt $stmt1 $stmt2)
   (if (or (== (get-metatype $stmt1) Variable) (== $stmt1 ()))
     $stmt2
     (if (or (== (get-metatype $stmt2) Variable) (== $stmt2 ()))
       $stmt1
       (: (unique-union-atom $fset1 $fset2) (-> (unique-union-atom $pset1 $pset2) (unique-union-atom $cset1 $cset2))))))

(= (myfold-atom1 $list $f)
   (if (== (get-metatype $list) Variable)
     $list
     (if-decons-expr $list $head $tail
        (myfold-atom $tail $head $f)
        $list)))

!(myfold-atom1 (1 2 3) +)

!(unionStmt (: (a) (-> () (A))) (: (b) (-> () (B))))

!(myfold-atom1 ((: (a) (-> () (A))) (: (b) (-> () (B)))) unionStmt)

!(myfold-atom1 ((: (a) (-> ((: $var X)) (A)))) unionStmt)

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;
(: bc (-> $a                            ; Knowledge base space
          Nat                           ; Maximum depth
          $q                            ; Query
          $q))                          ; Result


(= (bc $kb $depth_full (: $fset (-> $pset $cset)))
 (unify $kb (: $ufset (-> $pset $cset)) (traceid (let ($_ $nfset ()) ((overlap unifiable2) $fset $ufset) (: $nfset (-> $pset $cset))))
  (let ($npset $_ $ncset) ((overlap unifiable2) $pset $cset)
   (if (== $ncset ())
    (: () (: $var ()))
    ;Base Case
    ;Recursive steps
    (let* (((S $depth) $depth_full)

           (debug (trace! (Query (: $fset (-> $npset $ncset))) debug))

           ((: $mfset (-> $mpset $mcset)) (myfold-atom1 (map-atom $ncset $conclusion (bc $kb $depth (sealed $fset (: $fset (-> $matched_prms ($conclusion)))))) unionStmt))

           (debug (trace! (Match (: $mfset (-> $mpset $mcset))) debug))

           ;(($mprms $_ ()) ((overlap (unifyproof $kb $depth)) $mpset $mcset))

           ;($clean_mpset (myfold-atom1 (map-atom $mpset $elem (let (: $prf (-> $prms $type)) $elem $type)) unique-union-atom))

           (debug (trace! (Proof1 (: $fset (-> $npset $mpset))) debug))

           ((: $pfset (-> $ppset $pcset)) (traceid (bc $kb $depth (: $fset (-> $npset $mpset)))))

           (debug (trace! (Proof2 (: $pfset (-> $ppset $pcset))) debug))
          )
     (: (unique-union-atom $mfset $pfset) (-> $ppset $cset)))))))

;Some tests
!(bind! &s (new-space))

!(add-atom &s (: f (-> ((: $a A) (: $b B)) C)))
!(add-atom &s (: (f2 ((: a A))) (-> ((: $b B)) D)))
!(add-atom &s (: (f3 ((: a A))) (-> ((: $b B) (: $e E)) F)))
!(add-atom &s (: a A))
!(add-atom &s (: b B))


;Sometimes we get $var#1234 in the output which causes the assert to fail
(= (myAssertEqual $x $y)
   (unify $x $y () (Error $x should equal $y)))

; Basic type queries
;!(assertEqual (bc &s Z (: $prf A))
;    (: a A))
;!(assertEqual (bc &s (S (S Z)) (: $p C))
;    (: (f ((: b B) (: a A))) C))
;!(assertEqual (bc &s (S (S Z)) (: (f ((: a A) (: b B))) $t))
;    (: (f ((: b B) (: a A))) C))
;
;; Partial application
;!(assertEqual (bc &s (S (S Z)) (: $prf (-> ((: $a A)) C)))
;    (: (f ((: b B))) (-> ((: $a A)) C)))
;!(myAssertEqual (bc &s (S (S Z)) (: (f ((: b B))) $t))
;    (: (f ((: b B))) (-> ((: $a A)) C)))
;;
;!(assertEqual (bc &s (S (S Z)) (: $prf D))
;    (: (f2 ((: a A) (: b B))) D))
;!(myAssertEqual (bc &s (S (S Z)) (: (f2 ((: a A) (: b B))) $t))
;    (: (f2 ((: a A) (: b B))) D))
;!(myAssertEqual (bc &s (S (S Z)) (: (f2 ((: b B) (: a A))) $t))
;    (: (f2 ((: a A) (: b B))) D))
;
;!(assertEqual (bc &s (S (S Z)) (: $prf (-> ((: $e E)) F)))
;    (: (f3 ((: a A) (: b B))) (-> ((: $e E)) F)))
;!(assertEqual (bc &s (S (S Z)) (: (f3 ((: a A) (: b B))) (-> ((: $e E)) F)))
;    (: (f3 ((: a A) (: b B))) (-> ((: $e E)) F)))
;!(myAssertEqual (bc &s (S (S Z)) (: (f3 ((: a A) (: b B))) $t))
;    (: (f3 ((: a A) (: b B))) (-> ((: $e E)) F)))

!(bind! &kb (new-space))

!(bind! b (: (b) (-> () ((: (b) (-> () (B)))))))
!(add-atom &kb b)
!(bind! b_d (: (b_d) (-> ((: $b (-> () (B)))) ((: ((b_d $b)) (-> () (D)))))))
;!(bind! b_d (: (b_d) (-> ((: $b (-> () (B)))) (D))))
!(add-atom &kb b_d)

!(bind! a_c (: (a_c) (-> ((: $a (-> () (A)))) ((: ((a_c $a)) (-> () (C)))))))
!(add-atom &kb a_c)
!(add-atom &kb (: (c_d) (-> ((: $c (-> () (C)))) ((: ((c_d $c)) (-> () (D)))))))

;!(bc &kb (S (S Z)) (: $prf (-> () (C))))
;!(bc &kb (S (S Z)) (: $prf (-> ((: $a (-> () (A)))) ((: (($prf $a)) (-> () (D)))))))

!(myAssertEqual (bc &kb Z (: (a_c) (-> $a $b))) a_c)
!(myAssertEqual (bc &kb Z (: $prf (-> ((: $a (-> () (A)))) ((: $a (-> () (A))))))) (: () (: $prf ())))
!(assertEqual (bc &kb Z (: $prf (-> () ((: $p2 (-> () (B))))))) b)

;!(myAssertEqual (bc &kb Z (: $prf (-> () (D)))) (: $prf (-> () (D))))
!(bc &kb (S Z) (: $prf (-> () ((: $p2 ( -> () (D)))))))

;!(overlap2 &kb (S (S Z)) ((: $pa (-> () (A)))) ((: $pc (-> () (C)))))

;!(bc &kb (S (S Z)) (: $prf (-> ((: $a (-> () (A))) (: $b (-> () (B)))) (D))))
