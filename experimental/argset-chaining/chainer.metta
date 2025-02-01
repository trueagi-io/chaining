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

!((removef_rec2 meq) (a b c) x)

(= ((overlap_ff $eqf) ($left $intersection $right) $elem)
   (let ($res $nright) ((removef_rec2 $eqf) $right $elem False)
     (if $bool
        ($left (cons-atom $elem $intersection) $nright)
        ((cons-atom $elem $left) $intersection $nright))))

(= ((overlap $eqf) $list1 $list2)
   (if (== (get-metatype $list1) Variable)
     (() () $list2)
     (if (== (get-metatype $list2) Variable)
       ($list1 () ())
       (myfold-atom $list1 (() () $list2) (overlap_ff $eqf)))))

!((overlap ==) (a b c) (a b d))
!((overlap ==) (a) (c))

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

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;
(: bc (-> $a                            ; Knowledge base space
          Nat                           ; Maximum depth
          $q                            ; Query
          $q))                          ; Result

(= (bc $kb $depth_full $query) 
 ;Base Case
 (unify $kb $query $query
  ;Recursive steps
  (let* (((S $depth) $depth_full)

         ($debug (trace! (Query $query) a))
         
         ((: ($abs $args) (-> $prms $conclusion)) (cleanStmt $query))

         ($debug (trace! (CleanQuery (: ($abs $args) (-> $prms $conclusion))) a))

         ((: $matched_prf (-> $matched_prms $conclusion))
          (bc $kb $depth (: $matched_prf (-> $matched_prms $conclusion))))

         ($debug (trace! (Match1 (: $matched_prf (-> $matched_prms $conclusion))) a))

         (($matched_abs $matched_args) (cleanPrf $matched_prf))

         ($debug (trace! (Match2 (($matched_abs $matched_args) (-> $matched_prms $conclusion))) a))

         ($abs $matched_abs)

         ($debug (trace! (Overlap $prms $matched_prms) a))
         (($superfluous_prms $noproof_prms $proof_prms) ((overlap (unifyproof $kb $depth)) $prms $matched_prms))
         ($debug (trace! (Overlap2 $superfluous_prms $noproof_prms $proof_prms) a))


         ($debug (trace! (Overlap3 $args (concat $proof_prms $matched_args)) a))
         (($superfluous_args $final_args ()) ((overlap (unifyproof $kb $depth)) $args (concat $proof_prms $matched_args)))
         ($debug (trace! (Overlap4 $superfluous_args $final_args) a))


         ($debug (trace! (ProfPrms1 $proof_prms) a))
         ($proof_prms (map-atom $proof_prms $premise (bc $kb $depth $premise)))
         ($debug (trace! (ProfPrms2 $proof_prms) a))
        )
    (prettyStmt (: ($matched_abs $final_prms) (-> $noproof_prms $conclusion))))))

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

;!(add-atom &kb (: a A))
;!(add-atom &kb (: ab_c (-> ((: $a A) (: $b B)) C)))
!(add-atom &kb (: a_c (-> ((: $a A)) C)))
!(add-atom &kb (: c_d (-> ((: $c C)) D)))

!(bc &kb (S (S Z)) (: $prf (-> ((: $a A)) D)))
;!(bc &kb (S (S Z)) (: $prf (-> ((: $a A) (: $b B)) D)))
