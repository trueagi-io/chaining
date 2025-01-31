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


;; Check if an Atom unifiables with an element from a set/Expression
(: (elem (-> Expression Atom Bool)))
(= (elem $list $elem) 
   (foldl-atom $list False $accum $candiate (chain (unify $candiate $elem True False) $eq (or $accum $eq))))

;; Custom fold function since the stdlib version has issues
(= (myfold-atom $list $init $f)
   (if-decons-expr $list $head $tail
      (myfold-atom $tail ($f $init $head) $f)
      $init))


;;Subtract one set from another
(= ((sub_ff $list) $accum $elem)
   (if (elem $list $elem) $accum (cons-atom $elem $accum)))

(: substract (-> Expression Expression Expression))
(= (substract $list1 $list2)
   (myfold-atom $list1 () (sub_ff $list2)))

;;Remove one element from a set
(= (remove $list $elem)
   (if-decons-expr $list $head $tail
      (if (== $head $elem) $tail (let $new_tail (remove $tail $elem) (cons-atom $head $new_tail)))
      $list))

;;Check if two sets are equal
(= (seteq_ff ($b $lst) $elem)
     (if (elem $lst $elem) ($b (remove $lst $elem)) (False $lst)))

(= (seteq $list1 $list2)
   (if (or (== (get-metatype $list1) Variable) (== (get-metatype $list2) Variable)) True
   (let ($b $l2) (myfold-atom $list1 (True $list2) seteq_ff)
     (if (or (not $b) (not (== $l2 ()))) False True)
   )))


;;Check if one set is a subset of another
(= (subset $list1 $list2)
   (if (or (== (get-metatype $list1) Variable) (== (get-metatype $list2) Variable)) True
   (let ($b $l2) (myfold-atom $list1 (True $list2) seteq_ff) $b)))


;;Concat 2 sets together
(= (concat $list1 $list2)
   (if (== (get-metatype $list1) Variabel)
     $list2
     (if (== (get-metatype $list2) Variable)
     $list1
     (union-atom $list1 $list2))))

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
          $r))                          ; Result

(= (bc $kb $depth_full $query) 
 ;Base Case
 (unify $kb $query $query
  ;Recursive steps
  (let* (((S $depth) $depth_full)
         ((: ($abs $args) (-> $prms $conclusion)) (cleanStmt $query))
         ((: $matched_prf (-> $matched_prms $conclusion))
          (bc $kb $depth (: $matched_prf (-> $matched_prms $conclusion))))

         (($matched_abs $matched_args) (cleanPrf $matched_prf))

         (() (unify $abs $matched_abs () Empty))

         (() (if (subset $prms $matched_prms) () Empty))
         (() (if (subset $args (concat $matched_prms $matched_args)) () Empty))

         ($toproof_prms (if (== (get-metatype $args) Variable) (substract $matched_prms $prms) (substract $args $matched_args)))
         ($noproof_prms (if (== (get-metatype $args) Variable) (substract $prms $matched_args) (substract $matched_prms $args)))

         ($proofed_prms (map-atom $toproof_prms $premise (bc $kb $depth $premise)))

         ($final_prms (concat $matched_args $proofed_prms))

         (() (if (seteq $final_prms $args) () Empty))
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
!(assertEqual (bc &s Z (: $prf A))
    (: a A))
!(assertEqual (bc &s (S (S Z)) (: $p C))
    (: (f ((: b B) (: a A))) C))
!(assertEqual (bc &s (S (S Z)) (: (f ((: a A) (: b B))) $t))
    (: (f ((: b B) (: a A))) C))

; Partial application
!(assertEqual (bc &s (S (S Z)) (: $prf (-> ((: $a A)) C)))
    (: (f ((: b B))) (-> ((: $a A)) C)))
!(myAssertEqual (bc &s (S (S Z)) (: (f ((: b B))) $t))
    (: (f ((: b B))) (-> ((: $a A)) C)))
;
!(assertEqual (bc &s (S (S Z)) (: $prf D))
    (: (f2 ((: a A) (: b B))) D))
!(myAssertEqual (bc &s (S (S Z)) (: (f2 ((: a A) (: b B))) $t))
    (: (f2 ((: a A) (: b B))) D))
!(myAssertEqual (bc &s (S (S Z)) (: (f2 ((: b B) (: a A))) $t))
    (: (f2 ((: a A) (: b B))) D))

!(assertEqual (bc &s (S (S Z)) (: $prf (-> ((: $e E)) F)))
    (: (f3 ((: a A) (: b B))) (-> ((: $e E)) F)))
!(assertEqual (bc &s (S (S Z)) (: (f3 ((: a A) (: b B))) (-> ((: $e E)) F)))
    (: (f3 ((: a A) (: b B))) (-> ((: $e E)) F)))
!(myAssertEqual (bc &s (S (S Z)) (: (f3 ((: a A) (: b B))) $t))
    (: (f3 ((: a A) (: b B))) (-> ((: $e E)) F)))

