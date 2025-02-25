;;;;;;;;;;;;;;;;;;;;;;;
;; Utility Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Define ad-atom-nodup, that adds an atom only if it is not already
;; in the atomspace
(: add-atom-nodup (-> $st Atom ()))
(= (add-atom-nodup $space $atom)
   (case (match $space $atom $atom)
     (($atom ())
      (Empty (add-atom $space $atom)))))

;; Add all atoms from an expression to a given atomspace
(: add-atoms-nodup (-> $st Expression ()))
(= (add-atoms-nodup $space $atoms)
   (if (== $atoms ())
       ()
       (let* (($head (car-atom $atoms))
              ($tail (cdr-atom $atoms))
              ($dummy (add-atom-nodup $space $head)))
         (add-atoms-nodup $space $tail))))

;;;;;;;;;
;; Nat ;;
;;;;;;;;;

;; Define Nat
(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

;; Define cast functions between Nat and Number
(: fromNumber (-> Number Nat))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))
(: fromNat (-> Nat Number))
(= (fromNat Z) 0)
(= (fromNat (S $k)) (+ 1 (fromNat $k)))
