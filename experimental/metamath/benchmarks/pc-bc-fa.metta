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
;; Recursive steps
;; Unary application
(= (bc $rb $ab (S $k) (: ($f $x) $b))
   (match $rb (: $f (-> $a $b))
          (: ($f (bc $rb $ab $k (: $x $a)))
             $b)))
;; Binary application
(= (bc $rb $ab (S $k) (: ($f $x1 $x2) $b))
   (match $rb (: $f (-> $a1 $a2 $b))
          (: ($f (bc $rb $ab $k (: $x1 $a1))
                 (bc $rb $ab $k (: $x2 $a2)))
             $b)))
;; Ternary application
(= (bc $rb $ab (S $k) (: ($f $x1 $x2 $x3) $b))
   (match $rb (: $f (-> $a1 $a2 $a3 $b))
          (: ($f (bc $rb $ab $k (: $x1 $a1))
                 (bc $rb $ab $k (: $x2 $a2))
                 (bc $rb $ab $k (: $x3 $a3)))
             $b)))

;;;;;;;;;;;;;;;;;;;;;
;; Knowledge Bases ;;
;;;;;;;;;;;;;;;;;;;;;

;; Rule base up to index 8 included
!(bind! &rb (new-space))
!(add-atom &rb (: ax-mp (-> (→ $𝜑 $𝜓) $𝜑 $𝜓)))
!(add-atom &rb (: mp2 (-> (→ $𝜑 (→ $𝜓 $𝜒)) $𝜓 $𝜑 $𝜒)))
!(add-atom &rb (: mp2b (-> (→ $𝜓 $𝜒) (→ $𝜑 $𝜓) $𝜑 $𝜒)))
!(add-atom &rb (: a1i (-> $𝜑 (→ $𝜓 $𝜑))))

;; Axiom base up to index 8 included
!(bind! &ab (new-space))
!(add-atom &ab (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑))))
!(add-atom &ab (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒)))))
!(add-atom &ab (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑))))

;;;;;;;;;;
;; Main ;;
;;;;;;;;;;

!(bc &rb &ab (fromNumber 2) (: $x $a))
