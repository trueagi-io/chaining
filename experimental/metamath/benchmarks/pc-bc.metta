;; Like pc-fc.metta but within backward chaining

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
(= (bc $depth (: $x $a)) (match &ab (: $x $a) (: $x $a)))
;; Recursive steps, binary application
(= (bc (S $k) (: ($f $x1 $x2) $b))
   (match &rb (: $f (-> $a1 $a2 $b))
          (let* (((: $x1 $a1) (bc $k (: $x1 $a1)))
                 ((: $x2 $a2) (bc $k (: $x2 $a2))))
            (: ($f $x1 $x2) $b))))

;;;;;;;;;;
;; Main ;;
;;;;;;;;;;

;; ;; Full depth 2
;; !(bc (fromNumber 2) (: $x $a))

;; ;; Full depth 3
;; !(bc (fromNumber 3) (: $x $a))

;; ;; Full depth 4
;; !(bc (fromNumber 4) (: $x $a))

;; ;; id
;; !(bc (fromNumber 2) (: $x (→ 𝜑 𝜑)))

;; ;; 2a1
;; !(bc (fromNumber 3) (: $x (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜑)))))

;; ;; pm2.27
;; !(bc (fromNumber 5) (: $x (→ 𝜑 (→ (→ 𝜑 𝜓) 𝜓))))

;; ;; pm2.43
;; !(bc (fromNumber 2) (: $x (→ (→ 𝜑 (→ 𝜑 𝜓)) (→ 𝜑 𝜓))))

;; ;; imim2
;; !(bc (fromNumber 3) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜑) (→ 𝜒 𝜓)))))

;; ;; imim1
;; !(bc (fromNumber 5) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜒)))))

;; ;; pm2.83
;; !(bc (fromNumber 5) (: $x (→ (→ 𝜑 (→ 𝜓 𝜒)) (→ (→ 𝜑 (→ 𝜒 𝜃)) (→ 𝜑 (→ 𝜓 𝜃))))))

;; ;; peirceroll
;; !(bc (fromNumber 5) (: $x (→ (→ (→ (→ 𝜑 𝜓) 𝜑) 𝜑) (→ (→ (→ 𝜑 𝜓) 𝜒) (→ (→ 𝜒 𝜑) 𝜑)))))

;; ;; imim12
;; !(bc (fromNumber 5) (: $x (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜃) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜃))))))

;; ;; jarr NEXT
;; !(bc (fromNumber 2) (: $x (→ (→ (→ 𝜑 𝜓) 𝜒) (→ 𝜓 𝜒))))

;; ;; pm2.86 NEXT
;; !(bc (fromNumber 2) (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ 𝜑 (→ 𝜓 𝜒)))))

;; ;; loolin NEXT
;; !(bc (fromNumber 2) (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜓 𝜑)) (→ 𝜓 𝜑))))

;; ;; loowoz NEXT
;; !(bc (fromNumber 2) (: $x (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ (→ 𝜓 𝜑) (→ 𝜓 𝜒)))))
