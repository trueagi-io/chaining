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

(: is-variable (-> Atom Bool))
(= (is-variable $x) (== (get-metatype $x) Variable))

(: lazy-or (-> Bool Atom Bool))
(= (lazy-or False $x) $x)
(= (lazy-or True $x) True)

(: lazy-and (-> Bool Atom Bool))
(= (lazy-and False $x) False)
(= (lazy-and True $x) $x)

(: is-expression (-> Atom Bool))
(= (is-expression $x) (== (get-metatype $x) Expression))

;Check that expression contains no variables
(: is-closed (-> Atom Bool))
(= (is-closed $x) (if (is-variable $x)
                      False
                      (if (lazy-and (is-expression $x) (not (== $x ())))
                          (lazy-and (let $head (car-atom $x) (is-closed $head))
                                    (let $tail (cdr-atom $x) (is-closed $tail)))
                          True)))



;Trace a message + argument and return the argument
(= (tracem $msg $a) (trace! ($msg $a) $a))

;Time an expression and return the result
(: time (-> Atom $a))
(= (time $expr)
   (let $start ((py-atom time.time))
   (let $res $expr
   (let $stop ((py-atom time.time))
   (Time (- $stop $start) $res)))))

;; Custom fold function since the stdlib version has issues
(= (myfold-atom $list $init $f)
   (if-decons-expr $list $head $tail
      (myfold-atom $tail ($f $init $head) $f)
      $init))

;;Custom fold which assumes the first elment of the list as an init
(= (myfold-atom1 $list $f)
   (if (== (get-metatype $list) Variable)
     $list
     (if-decons-expr $list $head $tail
        (myfold-atom $tail $head $f)
        $list)))

;;Fold right to maintain the order of the list
(= (myfoldr-atom $list $init $f)
   (if-decons-expr $list $head $tail
      ($f (myfoldr-atom $tail $init $f) $head)
      $init))

!(assertEqual (myfoldr-atom (1 2 3) 0 +) 6)

;;Because mettalog eliminates duplicates
(= (munion-atom $list1 $list2)
   (if-decons-expr $list1 $head $tail
      (let $res (munion-atom $tail $list2)
         (cons-atom $head $res))
      $list2))

;;Concat 2 sets together
;;If either set is a variable, return the other set
(= (concat $list1 $list2)
   (if (== (get-metatype $list1) Variable)
     $list2
     (if (== (get-metatype $list2) Variable)
     $list1
     (munion-atom $list1 $list2))))

!(assertEqual (concat (a b c) (a b d)) (a b c a b d))

;;Remove $elem from set if it can be unified with an element in $list
;;Return the unified $elem and the remaining set
(= (remove $list $elem)
   (if-decons-expr $list $head $tail
      (unify $elem $head ($head $tail) (let ($res $ntail) (remove $tail $elem) ($res (cons-atom $head $ntail))))
      (() $list)
))

;;Check if 3 Atoms are unifiable without modifying them
(= (=unify $a $b) (sealed ($a $b) (unify $a $b True False)))

;;Given a proofen premise and list of target conclusions, remove the premise from the list
(= (removePrf $ccls $premise)
 (if-decons-expr $ccls $head $tail
   (if (=unify $premise $head) ;Check unifiability but don't modify the premise or the conclusion
    (let (: $prf $Type) $head
     (if (lazy-or (is-closed $Type) (=alpha $premise $head)) ;If the conclusion Type is closed or the premise is alpha equivalent to the conclusion
        (let $premise $head ($head $tail))                   ;we can be sure that there is no other way to prove the conclusion

        ;Otherwise we need to create a superposition where we remove the conclusion and where we don't
        ;Make sure the unification of premise and conclusion happens inside the superposition to not affect the other alternative
        (superpose ((let $premise $head ($head $tail)) (let ($res $ntail) (remove3 $tail $premise) ($res (cons-atom $head $ntail)))))
     ))
     ;If it is not unifiable, recurse on the tail
     (let ($res $ntail) (remove3 $tail $premise) ($res (cons-atom $head $ntail)))
  )
  ;Ccls list is empty
  (() $ccls)
 )
)

!(assertEqual (remove3 ((: $a2 A) (: $b B)) (: $a A)) ((: $a2 A) ((: $b B))))

;Check if an element is in a list based on unification
;Return the unified element and the remaining list
(= (elem $elem $list)
   (if-decons-expr $list $head $tail
      (unify $elem $head ($head $list) (let ($res $ntail) (elem $tail $elem) ($res (cons-atom $head $ntail))))
      (() $list)
))

;Check if an element is in a list based on unification
;Return a boolean
(= (elemB $elem $list)
   (if-decons-expr $list $head $tail
      (unify $elem $head True (elemB $elem $tail))
      False
))

;;Helper function for overlap
(= (overlap_ff ($left $intersection $right) $elem)
   (let ($res $nright) (remove3 $right $elem)
     (if (== $res ())
       ((cons-atom $elem $left) $intersection $right)
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
   (if (or (is-variable $list1) (is-variable $list2))
     ($list1 () $list2)
     (myfoldr-atom $list1 (() () $list2) overlap_ff)))

!(assertAlphaEqual (overlap2 ((: $a A)) ((: $a2 A) (: $b B))) (() ((: $a A)) ((: $b B))))

;;Custom unique function that works with variables
(= (myunique $a) (if (== (get-metatype $a) Variable) $a (unique-atom $a)))

!(assertEqual (myunique (a b a)) (a b))

;;Custom unique union function that works with variables
(= (unique-union-atom $a $b) (let $res (concat $a $b) (myunique $res)))

!(assertEqual (unique-union-atom ((: $a A) (: b B)) ((: a A))) ((: a A) (: b B)))
