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

(= (traceid $x) (trace! $x $x))

;;Concat 2 sets together
(= (concat $list1 $list2)
   (if (== (get-metatype $list1) Variable)
     $list2
     (if (== (get-metatype $list2) Variable)
     $list1
     (union-atom $list1 $list2))))

(= (remove_rec $list $elem)
   (if-decons-expr $list $head $tail
      (unify $elem $head
        ($head $tail)
        (let ($res $ntail) (remove_rec $tail $elem) ($res (cons-atom $head $ntail))))
      (() $list)
))

(= (overlap_ff ($left $intersection $right) $elem)
   (let ($res $nright) (remove_rec $right $elem)
     (if (== $res ())
        ((cons-atom $elem $left) $intersection $nright)
        ($left (cons-atom $res $intersection) $nright))))

(= (overlap $list1 $list2)
   (if (== (get-metatype $list1) Variable)
     (() $list2 ())
     (if (== (get-metatype $list2) Variable)
       (() $list1 ())
       (myfold-atom $list1 (() () $list2) overlap_ff))))

(= (overlap2 $list1 $list2)
   (if (== (get-metatype $list1) Variable)
     (() () $list2)
     (if (== (get-metatype $list2) Variable)
       ($list1 () ())
       (myfold-atom $list1 (() () $list2) overlap_ff))))

;!(overlap ((: $a (-> () (A)))) ((: (f2 $a) (-> () (B))) (: (a) (-> () (A)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(= (myunique $a) (if (== (get-metatype $a) Variable) $a (unique-atom $a)))

(= (unique-union-atom $a $b) (let $res (concat $a $b) (myunique $res)))

(= (unionStmt $stmt1 $stmt2)
   (if (or (== (get-metatype $stmt1) Variable) (== $stmt1 ()))
     $stmt2
     (if (or (== (get-metatype $stmt2) Variable) (== $stmt2 ()))
       $stmt1
       (let (: $fset1 (-> $pset1 $cset1)) $stmt1
         (let (: $fset2 (-> $pset2 $cset2)) $stmt2
           (: (unique-union-atom $fset1 $fset2) (-> (unique-union-atom $pset1 $pset2) (unique-union-atom $cset1 $cset2))))))))

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


(= (bc $kb $depth_full (: $fset (-> $pset $cset)))
 (case (if (== (get-metatype $fset) Variable)
           (unify $kb (: $fset (-> $pset $cset)) (: $fset (-> $pset $cset)) ()) 
           (myfold-atom1 (traceid (lookup-fset-in-kb $kb $fset)) unionStmt))
   (((: $uf (-> $up $uc))
     (let ($nup $nupc $nuc) (trace! (Overlap $up $uc) (overlap2 $up $uc)) (: $uf (-> $nup $nuc)))
    )
    (() 
     (let ($npset $_ $ncset) (trace! (NormalizeInput $pset $cset) (overlap2 $pset $cset))
       (if (== $ncset ())
        (: () (-> (()) ()))
        ;Base Case
        ;Recursive steps
        (let* (((S $depth) $depth_full)

               (debug (trace! (Query (: $fset (-> $npset $ncset))) debug))

               (debug (trace! (TryMatch (map-atom $ncset $conclusion (: $fset (-> $matched_prms ($conclusion))))) debug))

               ($mres (map-atom $ncset $conclusion (bc $kb $depth (sealed $fset (: $fset (-> $matched_prms ($conclusion)))))))

               (debug (trace! (Mres $mres) debug))

               ((: $mfset (-> $mpset $mcset)) (myfold-atom1 $mres unionStmt))

               (debug (trace! (Match (: $mfset (-> $mpset $mcset))) debug))

               ;(($mprms $_ ()) ((overlap (unifyproof $kb $depth)) $mpset $mcset))

               (debug (trace! (Proof1 (: $fset (-> $pset $maset))) debug))

               ((: $pfset (-> $ppset $pcset)) (traceid (bc $kb $depth (: $fset (-> $npset $mpset)))))

               (debug (trace! (Proof2 (: $pfset (-> $ppset $pcset))) debug))
   )
(: (unique-union-atom $mfset $pfset) (-> (unique-union-atom $npset $ppset) $ncset)))))))))



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
          ((: $fset (-> $pset $cset)) $atom)
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
;!(bind! &s (new-space))
;
;!(init-kb &s fs cs)
;
;!(add-to-kb &s (: (f) (-> (: $pab (A B)) (C))))
;!(add-to-kb &s (: (f2 a) (-> (: $b (B)) (D))))
;!(add-to-kb &s (: (f3 a) (-> (: $b (B E)) (F))))
;
;!(add-to-kb &s (: (a) (-> (: () ()) (A))))
;!(add-to-kb &s (: (b) (-> (: () ()) (B))))

;!(myAssertEqual (lookup-fset-in-kb &s (f a))
;  [(: (a) (-> (: () ()) (A)))
;  ,(: (f) (-> (: $pab (A B)) (C)))])

; Basic type queries
;!(assertEqual (bc &s Z (: $prf (-> $a (A))))
;    (: (a) (-> (: () ()) (A))))
;
;!(assertEqual (bc &s (S (S Z)) (: $p (-> (: $_ ()) (C))))
;    (: (f b a) (-> (: () ()) (C))))
;
;!(assertEqual (bc &s (S (S Z)) (: (f a b) $t))
;    (: (a b f) (-> (: () ()) (C))))
;
;;; Partial application
;!(assertEqual (bc &s (S (S Z)) (: $prf (-> (: $a (A)) (C))))
;    (: (f b) (-> (: () (A)) (C))))
;
;!(myAssertEqual (bc &s (S (S Z)) (: (f b) $t))
;    (: (b f) (-> (: () (A)) (C))))
;;;
;!(assertEqual (bc &s (S (S Z)) (: $prf (-> (: () ()) (D))))
;    (: (f2 a b) (-> (: () ()) (D))))
;!(myAssertEqual (bc &s (S (S Z)) (: (f2 a b) $t))
;    (: (f2 a b) (-> (: () ()) (D))))
;!(myAssertEqual (bc &s (S (S Z)) (: (f2 b a) $t))
;    (: (f2 a b) (-> (: () ()) (D))))
;;
;!(assertEqual (bc &s (S (S Z)) (: $prf (-> (: $e (E)) (F))))
;    (: (f3 a b) (-> (: () (E)) (F))))
;!(assertEqual (bc &s (S (S Z)) (: (f3 a b) (-> (: $e (E)) (F))))
;    (: (f3 a b) (-> (: () (E)) (F))))
;!(myAssertEqual (bc &s (S (S Z)) (: (f3 a b) $t))
;    (: (f3 a b) (-> (: () (E)) (F))))

!(bind! &k (new-space))

!(init-kb &k kfs kcs)

!(add-to-kb &k (: (a) (-> () A)))
!(add-to-kb &k (: ((ab $a)) (-> (: $a (A)) (B))))

!(bc &k Z (: (a ab) $type))
!(bc &k (S Z) (: $fset (-> () ((: $prf B)))))

;!(add-to-kb &k (: (f0) (-> ((: $a A) (: $b B)) ((: (f0 $a $b) C)))))
;
;!(add-to-kb &k (: (f1) (-> ((: $b B)) ((: (f1 $b) D)))))
;
;!(add-to-kb &k (: (f2) (-> ((: $a A)) ((: (f2 $a) B)))))
;
;!(add-to-kb &k (: (a) (-> () ((: (a) A)))))
;
;
;!(bc &k Z (: (f0 f1 f2) $t))
;
;!(bc &k Z (: (a f2 f0 f1) $t))
;
;!(bc &k z (: $fste (-> ((: $a A)) $cset)))


