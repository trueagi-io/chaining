;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Testing MeTTaLog to see if we can implement the backward chainer       ;;
;; without depth.                                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;
;; Nat ;;
;;;;;;;;;

;; Define Nat
(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Curried Backward Chainer.
;;
;; The arguments of the backward chainer are:
;;
;; * Knowledge base: pointer to a space containing axioms and rules in
;;   the format (: <NAME> <RULE>).  Note that rules are explicitely
;;   curried, meaning that a rule with two premises is represented by
;;
;;   (: <NAME> (-> <PREMISE1> (-> <PREMISE2> <CONCLUSION>)))
;;
;;   In addition, each premise must be an inline typing relationship,
;;   to represent dependent types.  It should be noted that such
;;   typing relationship must be provided even if the witness is not
;;   present in the rest of the definition.  For instance <PREMISE1>
;;   would have the format (NEXT: do we really need that?)
;;
;;   (: <TERM1> <TYPE1>)
;;
;; * Maximum depth: maximum depth of the generated proof tree.
;;
;; * Query: a metta term of the form (: <PROOF> <THEOREM>) where
;;   <PROOF> and <THEOREM> may contain free variables that may be
;;   filled by the backward chainer.
(: bc (-> $a                            ; Knowledge base space
          Nat                           ; Maximum depth
          $c                            ; Query
          $c))                          ; Result

;; Base case: match the knowledge base
(= (bc $kb (: $prf $thrm))
   (match $kb (: $prf $thrm) (: $prf $thrm)))
;; Recursive steps: proof application
(= (bc $kb (: ($prfabs $prfarg) $thrm))
   (let* (((: $prfabs (-> $prms $thrm))
           (bc $kb (: $prfabs (-> $prms $thrm))))
          ((: $prfarg $prms)
           (bc $kb (: $prfarg $prms))))
     (: ($prfabs $prfarg) $thrm)))

;;;;;;;;;;;;;;;;;;;;
;; Knowledge base ;;
;;;;;;;;;;;;;;;;;;;;

!(bind! &kb (new-space))

!(add-atom &kb (: Trans (-> (→ $b $c)
                            (-> (→ $a $b)
                                (→ $a $c)))))
!(add-atom &kb (: AB (→ A B)))
!(add-atom &kb (: BC (→ B C)))

;; Test the backward chainer.  Only limit of 1 avoids infinit
;; recursion because there is only 1 result per call.
!(limit 1 (bc &kb (: $prf (→ A B))))
!(limit 1 (bc &kb (: $prf (→ B C))))
!(limit 1 (bc &kb (: $prf (-> (→ B C) (-> (→ A B) (→ A C))))))
!(limit 1 (bc &kb (: $prf (→ A C))))
