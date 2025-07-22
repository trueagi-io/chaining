;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Example of probabilistic backward chaining.                      ;;
;;                                                                  ;;
;; Inspired from problog.                                           ;;
;;                                                                  ;;
;; Each typing relationship has a probability attached to it and it ;;
;; influences the base case of the backward chainer by              ;;
;; probabilistically filtering in at a rate determined by this      ;;
;; probability.                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Import random module
!(import! &self random)

;;;;;;;;;
;; Nat ;;
;;;;;;;;;

;; Define Nat
(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

;; Define cast functions between Nat and Number
(: fromNumber (-> Number Nat))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))
(: fromNat (-> Nat Number))
(= (fromNat Z) 0)
(= (fromNat (S $k)) (+ 1 (fromNat $k)))

;;;;;;;;;;
;; When ;;
;;;;;;;;;;

;; Run the code if the condition is true, otherwise prune the branch
(: when (-> Bool Atom $a))
(= (when $c $x) (if $c $x (empty)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Probabilistic Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Probabilistic Backward Chainer.  The arguments of the backward
;; chainer are:
;;
;; * Knowledge base: pointer to a space containing axioms and rules in
;;   the format (: <PROB> <NAME> <RULE>).  Where <PROB> is the
;;   probability of triggering the rule.
;;
;; * Query: a metta term of the form (: <PROOF> <THEOREM>) where
;;   <PROOF> and <THEOREM> may contain free variables that may be
;;   filled by the backward chainer.
;;
;; * Maximum depth: maximum depth of the generated proof tree.
;;
;; A result is the query with its variables grounded, fully or
;; partially.  If multiple results are possible, they are returned as
;; a superposition.
(: pbc (-> $a                            ; Knowledge base space
           Nat                           ; Maximum depth
           $b                            ; Query
           $b))                          ; Result
;; Base case
(= (pbc $kb $_ (: $pbl $prf $ccln))
   ;; (trace! (👁 pbc-base $_ (: $pbl $prf $ccln))
   (match $kb (: $pbl $prf $ccln)
          (when (< (random-float &rng 0 1) $pbl)
            (: $pbl $prf $ccln))));)
;; Recursive step
;; Unary application
(= (pbc $kb (S $k) (: $pbl ($prfabs $prfarg) $ccln))
   ;; (trace! (👁 pbc-rec1 (S $k) (: $pbl ($prfabs $prfarg) $ccln))
   (let* (;; Recurse on abstraction
          ((: $pblabs $prfabs (-> $prms $ccln))
           (pbc $kb $k (: $pblabs $prfabs (-> $prms $ccln))))
          ;; Recurse on argument
          ((: $pblarg $prfarg $prms)
           (pbc $kb $k (: $pblarg $prfarg $prms)))
          ;; Calculate probability of application
          ($pbl (× $pblabs $pblarg)))   ; NEXT: is it true?
     (: $pbl ($prfabs $prfarg) $ccln)));)
;; Binary application
(= (pbc $kb (S $k) (: $pbl ($prfabs $prfarg1 $prfarg2) $ccln))
   ;; (trace! (👁 pbc-rec2 (S $k) (: $pbl ($prfabs $prfarg1 $prfarg2) $ccln))
   (let* (;; Recurse on abstraction
          ((: $pblabs $prfabs (-> $prms1 $prms2 $ccln))
           (pbc $kb $k (: $pblabs $prfabs (-> $prms1 $prms2 $ccln))))
          ;; Recurse on first argument
          ((: $pblarg1 $prfarg1 $prms1)
           (pbc $kb $k (: $pblarg1 $prfarg1 $prms1)))
          ;; Recurse on second argument
          ((: $pblarg2 $prfarg2 $prms2)
           (pbc $kb $k (: $pblarg2 $prfarg2 $prms2)))
          ;; Calculate probability of application
          ($pbl (× $pblabs (× $pblarg1 $pblarg2)))) ; NEXT: is it true?
     (: $pbl ($prfabs $prfarg1 $prfarg2) $ccln)));)

;;;;;;;;;;;
;; Tests ;;
;;;;;;;;;;;

;; Tests provided by Abdulrahman Omar, themselves found
;; [here](https://dtai.cs.kuleuven.be/problog/tutorial/tutslides/01_basic.html)

;; Smoke knowledge base
!(bind! &smoke-kb (new-space))
!(add-atom &smoke-kb (: 0.8 sa (stress ann)))
!(add-atom &smoke-kb (: 0.6 iab (influences ann bob)))
!(add-atom &smoke-kb (: 0.5 iab (influences ann henry)))
!(add-atom &smoke-kb (: 0.4 iab (influences henry carl)))
!(add-atom &smoke-kb (: 0.2 ibc (influences bob carl)))
!(add-atom &smoke-kb (: 1 ss (-> (stress $x) (smokes $x))))
!(add-atom &smoke-kb (: 1 iss (-> (influences $y $x) (smokes $y) (smokes $x))))

;; Smoke query
!(set-random-seed &rng 0)
!(assertEqual
  (pbc &smoke-kb (fromNumber 3) (: $pbl $prf (smokes carl)))
  (: (× 1 (× 0.4 (× 1 (× 0.5 (× 1 0.8)))))
     (iss iab (iss iab (ss sa)))
     (smokes carl)))

;; Break knowledge base
!(bind! &break-kb (new-space))
!(add-atom &break-kb (: 1 tj (throws john)))
!(add-atom &break-kb (: 0.5 tm (throws mary)))
!(add-atom &break-kb (: 0.8 tmb (-> (throws mary) break)))
!(add-atom &break-kb (: 0.6 tjb (-> (throws john) break)))

;; Break query
!(set-random-seed &rng 0)
!(assertEqual
  (pbc &break-kb (fromNumber 3) (: $pbl $prf break))
  (: (× 0.8 0.5) (tmb tm) break))
!(set-random-seed &rng 2)
!(assertEqualToResult
  (pbc &break-kb (fromNumber 3) (: $pbl $prf break))
  ((: (× 0.8 0.5) (tmb tm) break)
   (: (× 0.6 1) (tjb tj) break)))
!(set-random-seed &rng 2)
!(assertEqualToResult
  (pbc &break-kb (fromNumber 3) (: $pbl $prf (throws $x)))
  ((: 1 tj (throws john))
   (: 0.5 tm (throws mary))))
