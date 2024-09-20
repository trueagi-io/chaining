;;;;;;;;;
;; DTL ;;
;;;;;;;;;

;; Foward chainer
(: fc (-> $a                            ; Knowledge base space 
          Nat                           ; Depth
          $b                            ; Source
          $b))                          ; Conclusion
;; Base case
(= (fc $kb $depth (: $proof $premise)) (: $proof $premise))
;; Recursive steps
(= (fc $kb (S $k) (: $proof1 $premise1))
   (let* (((: $ructor (-> $premise1 $premise2 $conclusion)) (get-atoms $kb))
          ((: $proof2 $premise2) (get-atoms $kb)))
     (fc $kb $k (: ($ructor $proof1 $proof2) $conclusion))))
(= (fc $kb (S $k) (: $proof2 $premise2))
   (let* (((: $ructor (-> $premise1 $premise2 $conclusion)) (get-atoms $kb))
          ((: $proof1 $premise1) (get-atoms $kb)))
     (fc $kb $k (: ($ructor $proof1 $proof2) $conclusion))))
