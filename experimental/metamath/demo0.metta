;; Convert
;; [demo0.mm](https://github.com/zariuq/mmverify.py/blob/metta/examples/demo0.mm)
;; to MeTTa using a type theoretic representation.

;; Informal description:
;;   Zero is a term
;;
;; Metamath description:
;;   $( Define "term" (part 1 of 2). $)
;;   tze $a term 0 $.
(: ⟨0⟩ ⟨term⟩)

;; Informal description:
;;   Adding two terms outputs a term
;;
;; Metamath description:
;;   $( Define "term" (part 2 of 2). $)
;;   tpl $a term ( t + r ) $.
(: ⟨+⟩ (-> ⟨term⟩ ⟨term⟩ ⟨term⟩))

;; Informal description:
;;   Equality between two terms is a well formed formula.
;;
;; Metamath description:
;;   $( Define "wff" (part 1 of 2). $)
;;   weq $a wff t = r $.
(: ⟨=⟩ (-> ⟨term⟩ ⟨term⟩ ⟨wff⟩))

;; Informal description:
;;   Implication between two well formed formulas is a well formed formula.
;;
;; Metamath description:
;;   $( Define "wff" (part 2 of 2). $)
;;   wim $a wff ( P -> Q ) $.
(: ⟨->⟩ (-> <wff> <wff> <wff>))


;; Informal description:
;;   Equality is right Euclidean (see https://arxiv.org/pdf/1806.05036)
;;
;; Metamath description:
;;   $( State Axiom ~ a1 . $)
;;   a1 $a |- ( t = r -> ( t = s -> r = s ) ) $.
;;
;; Warning: not using ⟨->⟩ and the fact that $t $r and $s are wff.
(: a1 (-> (⟨=⟩ $t $r) (-> (⟨=⟩ $t $s) (⟨=⟩ $r $s))))

;; Informal description:
;;   Zero is a right identity of addition.
;;
;; Metamath description:
;;   $( State Axiom ~ a2 . $)
;;   a2 $a |- ( t + 0 ) = t $.
;;
;; Warning: not using the fact that $t is wff.
(: a2 (⟨=⟩ (⟨+⟩ $t ⟨0⟩) $t))

;; Informal description:
;;   Modus ponens
;;
;; Metamath description:
;;   ${
;;     min $e |- P $.
;;     maj $e |- ( P -> Q ) $.
;;     $( Define the modus ponens inference rule. $)
;;     mp $a |- Q $.
;;   $}
;;
;; Warning: not using the fact that $P and $Q are wff.
(: mp (-> $P (-> (⟨->⟩ $P $Q) $Q)))

;; Informal description:
;;   Prove that equality is reflexive.  NEXT.
;;
;; Metamath description:
;;   $( Prove a theorem.  (Contributed by NM, 1-Jan-2004.) $)
;;   th1 $p |- t = t $=
;;   $( Here is its proof: $)
;;     tt tze tpl tt weq tt tt weq tt a2 tt tze tpl tt weq tt tze tpl tt weq tt tt
;;     weq wim tt a2 tt tze tpl tt tt a1 mp mp $.
NEXT
