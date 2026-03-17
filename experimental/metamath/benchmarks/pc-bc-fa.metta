;; Like pc-bc.metta but proofs are fully type annotated

;;;;;;;;;;;;;;;
;; Functions ;;
;;;;;;;;;;;;;;;

;; Define Nat
(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

;; Cast Number into Nat
(: fromNumber (-> Number Nat))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

;; Backward chainer
;; Base case
(= (bc $rb $ab $depth (: $x $a)) (match $ab (: $x $a) (: $x $a)))
;; Recursive steps, binary application
(= (bc $rb $ab (S $k) (: ($f $x1 $x2) $b))
   (match $rb (: $f (-> $a1 $a2 $b))
          (: ($f (bc $rb $ab $k (: $x1 $a1))
                 (bc $rb $ab $k (: $x2 $a2)))
             $b)))

;;;;;;;;;;;;;;;;;;;;;
;; Knowledge Bases ;;
;;;;;;;;;;;;;;;;;;;;;

;; Rule base
!(bind! &rb (new-space))
!(add-atom &rb (: ax-mp (-> (→ $𝜑 $𝜓) $𝜑 $𝜓)))

;; Axiom base
!(bind! &ab (new-space))
!(add-atom &ab (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
!(add-atom &ab (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
!(add-atom &ab (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))

;;;;;;;;;;
;; Main ;;
;;;;;;;;;;

!(bc &rb &ab (fromNumber 2) (: $x $a))
