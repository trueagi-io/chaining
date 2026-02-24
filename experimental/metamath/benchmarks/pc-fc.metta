;; Generate all proofs up to a certain depth in a forward way

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

;; Forward step over a given set of premises.
;; Binary application
(= (fs2 $rb (: $x1 $a1) (: $x2 $a2))
   (match $rb (: $f (-> $a1 $a2 $b)) (: ($f $x1 $x2) $b)))

;; Forward step over any premises in the current solution set.
;; Binary application
(= (fs $rb $ss)
   (fs2 $rb
        (match $ss (: $x1 $a1) (: $x1 $a1))
        (match $ss (: $x2 $a2) (: $x2 $a2))))

;; Like fs and also add the results back to the solution space
(= (fs-add-to-ss $rb $ss)
   (let $ns (collapse (fs $rb $ss))
     (let $nss (superpose $ns)
       (add-atom $ss $nss))))

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

;; Solution set
!(bind! &ss (new-space))

;; Run step 0 of forward chaining
!(match &ab (: $x $a) (add-atom &ss (: $x $a)))

;; Run step 1 of forward chaining
!(fs-add-to-ss &rb &ss)

;; Run step 2 of forward chaining
!(fs-add-to-ss &rb &ss)

;; Run step 3 of forward chainin
!(fs-add-to-ss &rb &ss)

;; Run step 4 of forward chainin
!(fs-add-to-ss &rb &ss)

!(get-atoms &ss)
