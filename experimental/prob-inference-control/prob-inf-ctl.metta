;; Like ../inference-control but attempt to uses probabilities

;; (: pbc (-> $a                           ; Knowledge base
;;            (ProbControl $b $c)          ; Probabilistic control structure
;;            $))


(= (hbc $kb $depth (: $prf $thrm))
   (
