;; Standalone polyward chaining experiments.

;;;;;;;;;
;; Nat ;;
;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;
;; Forward Revertant ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Forward chainer that may go backward if necessary.

! "=== Forward Revertant ==="

;; Knowledge base
!(bind! &kb (new-space))
!(add-atom &kb (: ab (→ A B)))
!(add-atom &kb (: bc (→ B C)))
!(add-atom &kb (: a A))

;; Rule base
!(bind! &rb (new-space))
!(add-atom &rb (: ModusPonens (->
                               ;; Premises
                               (→ $p $q)
                               $p
                               ;; Conclusion
                               $q)))
!(add-atom &rb (: Deduction (->
                             ;; Premises
                             (→ $p $q)
                             (→ $q $r)
                             ;; Conclusion
                             (→ $p $r))))

;; Backward chainer, based on the DTL version of
;; `../backward-chaining/bc-xp.metta` but rules are in an atomspace
;; instead of being hardwired.  To be used by the forward revertant
;; chainer defined below.
(: bc (-> Nat Atom Atom))
;; Base case
(= (bc $depth (: $prf $ccln))
   (match &kb (: $prf $ccln) (: $prf $ccln)))
;; Recursive cases
(= (bc (S $k) (: $prf $ccln))
   (match &rb (: $ctor (-> $prms1 $prms2 $ccln))
          (let* (((: $prf1 $prms1) (bc $k (: $prf1 $prms1)))
                 ((: $prf2 $prms2) (bc $k (: $prf2 $prms2)))
                 (($ctor $prf1 $prf2) $prf))
            (: $prf $ccln))))

;; Test backward chainer
!(assertEqual
  (bc Z (: $prf A))
  (: a A))
!(assertEqual
  (bc Z (: $prf (→ A B)))
  (: ab (→ A B)))
!(assertEqual
  (bc Z (: $prf (→ B C)))
  (: bc (→ B C)))
!(assertEqual
  (bc (fromNumber 1) (: $prf B))
  (: (ModusPonens ab a) B))
!(assertEqualToResult
  (bc (fromNumber 2) (: $prf C))
  ((: (ModusPonens bc (ModusPonens ab a)) C)
   (: (ModusPonens (Deduction ab bc) a) C)))
!(assertEqual
  (bc (fromNumber 2) (: $prf (→ A C)))
  (: (Deduction ab bc) (→ A C)))

;; Forward revertant chainer, based on the DTL version of
;; `../backward-chaining/bc-xp.metta` but matching premises is
;; replaced by calling the backward chainer defined above.
(: frc (-> Nat Atom Atom))
;; Base case
(= (frc $depth (: $prf $prms)) (: $prf $prms))
;; Recursive cases
(= (frc (S $k) (: $prf1 $prms1))
   (match &rb (: $ctor (-> $prms1 $prms2 $ccln))
          (let (: $prf2 $prms2) (bc $k (: $prf2 $prms2))
               (frc $k (: ($ctor $prf1 $prf2) $ccln)))))
(= (frc (S $k) (: $prf2 $prms2))
   (match &rb (: $ctor (-> $prms1 $prms2 $ccln))
          (let (: $prf1 $prms1) (bc $k (: $prf1 $prms1))
               (frc $k (: ($ctor $prf1 $prf2) $ccln)))))

;; Test forward revertant chainer
!(assertEqual
  (frc Z (: a A))
  (: a A))
!(assertEqualToResult
  (frc (fromNumber 1) (: a A))
  ((: a A)
   (: (ModusPonens ab a) B)))
;; Disable assertEqualToResult due to leftover
;; !(assertEqualToResult
  !(frc (fromNumber 2) (: a A))
  ;; ((: a A)
  ;;  (: (ModusPonens ab a) B)
  ;;  (: (ModusPonens bc (ModusPonens ab a)) C)
  ;;  (: (ModusPonens (Deduction ab bc) a) C)))
