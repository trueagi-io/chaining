
! "=== DTL ==="

;; Foward chainer
(: fc_dtl (-> Atom (-> Atom) (-> Atom) Nat Atom))
;; Base case
(= (fc_dtl (: $proof $premise) $kb $rb $depth) (: $proof $premise))
;; Recursive steps
(= (fc_dtl (: $proof1 $premise1) $kb $rb (S $k))
   (let* (((: $ructor (-> $premise1 $premise2 $conclusion)) ($rb))
          ((: $proof2 $premise2) ($kb)))
     (fc_dtl (: ($ructor $proof1 $proof2) $conclusion) $kb $rb $k)))
(= (fc_dtl (: $proof2 $premise2) $kb $rb (S $k))
   (let* (((: $ructor (-> $premise1 $premise2 $conclusion)) ($rb))
          ((: $proof1 $premise1) ($kb)))
     (fc_dtl (: ($ructor $proof1 $proof2) $conclusion) $kb $rb $k)))