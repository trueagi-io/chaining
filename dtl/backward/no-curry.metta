;; Enumerate all programs up to a given depth that are consistent with
;; the query, using the given axiom non-deterministic functions and rules.
;;
;; The arguments are:
;;
;; $query: an Atom under the form (: TERM TYPE).  The atom may contain
;;         free variables within TERM and TYPE to form various sort of
;;         queries, such as:
;;         1. Backward chaining: (: $term (Inheritance $x Mammal))
;;         2. Forward chaining: (: ($rule $premise AXIOM) $type)
;;         3. Mixed chaining: (: ($rule $premise AXIOM) (Inheritance $x Mammal))
;;         4. Type checking: (: TERM TYPE)
;;         5. Type inference: (: TERM $type)
;;
;; $kb: a Knowledge base containing axioms and rules in a format
;;      (: TERM TYPE).
;;
;; $depth: a Nat representing the maximum depth of the generated
;;         programs.

(: synthesize (-> $a                           ; Knowledge base space
                  Nat                          ; Maximum depth
                  $b                           ; Query
                  $b))                         ; Result
     
;; Nullary rule (axiom)
(= (synthesize $kb $depth $query)
     (match $kb $query $query))
;; Unary rule
(= (synthesize $kb (S $k) $query)
   (let* (((: $ructor (-> $premise $conclusion)) (match $kb $a $a))
          ((: ($ructor $proof) $conclusion) $query)
          ((: $proof $premise) (synthesize $kb $k (: $proof $premise))))
     $query))
;; Binary rule
(= (synthesize $kb (S $k) $query)
   (let* (((: $ructor (-> $premise1 $premise2 $conclusion)) (match $kb $a $a))
          ((: ($ructor $proof1 $proof2) $conclusion) $query)
          ((: $proof1 $premise1) (synthesize $kb $k (: $proof1 $premise1)))
          ((: $proof2 $premise2) (synthesize $kb $k (: $proof2 $premise2))))
     $query))
;; Trinary rule
(= (synthesize $kb (S $k) $query)
   (let* (((: $ructor (-> $premise1 $premise2 $premise3 $conclusion)) (match $kb $a $a))
          ((: ($ructor $proof1 $proof2 $proof3) $conclusion) $query)
          ((: $proof1 $premise1) (synthesize $kb $k (: $proof1 $premise1)))
          ((: $proof2 $premise2) (synthesize $kb $k (: $proof2 $premise2)))
          ((: $proof3 $premise3) (synthesize $kb $k (: $proof3 $premise3))))
     $query))
;; Quaternary rule
(= (synthesize $kb (S $k) $query)
   (let* (((: $ructor (-> $premise1 $premise2 $premise3 $premise4 $conclusion)) (match $kb $a $a))
          ((: ($ructor $proof1 $proof2 $proof3 $proof4) $conclusion) $query)
          ((: $proof1 $premise1) (synthesize $kb $k (: $proof1 $premise1)))
          ((: $proof2 $premise2) (synthesize $kb $k (: $proof2 $premise2)))
          ((: $proof3 $premise3) (synthesize $kb $k (: $proof3 $premise3)))
          ((: $proof4 $premise4) (synthesize $kb $k (: $proof4 $premise4))))
     $query))
;; Quintenary rule
(= (synthesize $kb (S $k) $query)
   (let* (((: $ructor (-> $premise1 $premise2 $premise3 $premise4 $premise5 $conclusion)) (match $kb $a $a))
          ((: ($ructor $proof1 $proof2 $proof3 $proof4 $proof5) $conclusion) $query)
          ((: $proof1 $premise1) (synthesize $kb $k (: $proof1 $premise1)))
          ((: $proof2 $premise2) (synthesize $kb $k (: $proof2 $premise2)))
          ((: $proof3 $premise3) (synthesize $kb $k (: $proof3 $premise3)))
          ((: $proof4 $premise4) (synthesize $kb $k (: $proof4 $premise4)))
          ((: $proof5 $premise5) (synthesize $kb $k (: $proof5 $premise5))))
     $query))
