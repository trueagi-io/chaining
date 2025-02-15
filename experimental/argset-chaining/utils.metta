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

(= (myfold-atom1 $list $f)
   (if (== (get-metatype $list) Variable)
     $list
     (if-decons-expr $list $head $tail
        (myfold-atom $tail $head $f)
        $list)))

(= (myfoldr-atom $list $init $f)
   (if-decons-expr $list $head $tail
      ($f (myfoldr-atom $tail $init $f) $head)
      $init))

;;Concat 2 sets together
;;If either set is a variable, return the other set
(= (concat $list1 $list2)
   (if (== (get-metatype $list1) Variable)
     $list2
     (if (== (get-metatype $list2) Variable)
     $list1
     (union-atom $list1 $list2))))

;;Remove $elem from set if it can be unified with an element in $list
;;Return the unified $elem and the remaining set

(= (remove $list $elem)
   (if-decons-expr $list $head $tail
      (unify $elem $head ($head $tail) (let ($res $ntail) (remove $tail $elem) ($res (cons-atom $head $ntail))))
      (() $list)
))

(= (elem $elem $list)
   (if-decons-expr $list $head $tail
      (unify $elem $head ($head $list) (let ($res $ntail) (elem $tail $elem) ($res (cons-atom $head $ntail))))
      (() $list)
))

;;Helper function for overlap
(= (overlap_ff ($left $intersection $right) $elem)
   (let ($res $nright) (remove $right $elem)
     (if (== $res ())
        ((cons-atom $elem $left) $intersection $nright)
        ($left (cons-atom $res $intersection) $nright))))

;;Calculate the overlap of 2 sets
;;Retruns (($list1 - $list2) ($list1 intersection $list2) ($list2 - $list1))
;;Variables are treated as matchichg any set
(= (overlap $list1 $list2)
   (if (== (get-metatype $list1) Variable)
     (() $list2 ())
     (if (== (get-metatype $list2) Variable)
       (() $list1 ())
       (myfoldr-atom $list1 (() () $list2) overlap_ff))))

;;Same as above but $variables don't match anything.
(= (overlap2 $list1 $list2)
   (if (or (== (get-metatype $list1) Variable) (== (get-metatype $list2) Variable))
     ($list1 () $list2)
     (myfoldr-atom $list1 (() () $list2) overlap_ff)))

!(assertEqual (overlap (a b c) (a b d)) ((c) (a b) (d)))

;;Custom unique function that works with variables
(= (myunique $a) (if (== (get-metatype $a) Variable) $a (unique-atom $a)))

;;Custom unique union function that works with variables
(= (unique-union-atom $a $b) (let $res (concat $a $b) (myunique $res)))

(= (merge_ff $list $elem)
   (let ($res $nlist) (elem $right $elem)
     (if (== $res ())
        ($nlist)
        (cons-atom $elem $list))))

(= (merge-nodups $a $b)
   (if (== (get-metatype $a) Variable)
     $b
     (if (== (get-metatype $b) Variable)
       $a
       (myfoldr-atom $a $b merge_ff))))
