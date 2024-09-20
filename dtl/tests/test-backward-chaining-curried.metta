;; Register module
!(register-module! ../../../chaining)
!(import! &self chaining:dtl:backward:curried)
!(import! &self chaining:dtl:utils)

;; Knowledge and rule base
!(bind! &kb (new-space))

;; Knowledge base
!(add-atom &kb (: ab (→ A B)))
!(add-atom &kb (: bc (→ B C)))
!(add-atom &kb (: a A))

;; Rule base
!(add-atom &kb (: ModusPonens (-> (→ $p $q)  ; Premise 1
                                  (-> $p     ; Premise 2
                                      $q)))) ; Conclusion
!(add-atom &kb (: Deduction (-> (→ $q $r)         ; Premise 1
                                (-> (→ $p $q)     ; Premise 2
                                    (→ $p $r))))) ; Conclusion
!(add-atom &kb (: . (-> (-> $q $r)         ; Premise 1
                        (-> (-> $p $q)     ; Premise 2
                            (-> $p $r))))) ; Conclusion


;; Test backward chainer DTL curried
! "=== Test Backward Chainer DTL Curried ==="

;; Prove A (axiom)
!(assertEqual
  (syn &kb Z (: a A))
  (: a A))

;; Prove (-> (→ A B) (-> A B)) (axiom)
!(assertEqual
  (syn &kb Z (: $prf (-> $prms (-> A B))))
  (: ModusPonens (-> (→ A B) (-> A B))))

;; Prove (-> A B)
!(assertEqual
  (syn &kb (fromNumber 1) (: $prf (-> A B)))
  (: (ModusPonens ab) (-> A B)))

;; Prove B (one modus ponens)
!(assertEqual
  (syn &kb (fromNumber 2) (: $prf B))
  (: ((ModusPonens ab) a) B))

;; Prove C (two modus ponens)
!(assertEqual
  (syn &kb (fromNumber 3) (: $prf C))
  (: ((ModusPonens bc) ((ModusPonens ab) a)) C))

;; Prove C (two modus ponens, or one modus ponens and one deduction)
!(assertEqualToResult
  (syn &kb (fromNumber 4) (: $prf C))
  ((: ((((. ModusPonens) (Deduction bc)) ab) a) C)
   (: (((. (ModusPonens bc)) (ModusPonens ab)) a) C)
   (: ((ModusPonens ((Deduction bc) ab)) a) C)
   (: ((ModusPonens bc) ((ModusPonens ab) a)) C)))

;; Prove 3-premises version of Modus Ponens, that is
;;
;; (-> (→ $q $r) (-> (→ $p $q) (-> $p $r)))
!(assertEqualToResult
  (syn &kb (fromNumber 4) (: $prf (-> (→ $q $r) (-> (→ $p $q) (-> $p $r)))))
  ((: ((((. .) .) ModusPonens) Deduction) (-> (→ $q $r) (-> (→ $p $q) (-> $p $r))))
   (: ((. (. ModusPonens)) Deduction) (-> (→ $q $r) (-> (→ $p $q) (-> $p $r))))))

;; Prove 3-premises version of Deduction, that is
;;
;; (-> (→ $r $s) (-> (→ $q $r) (-> (→ $p $q) (→ $p $s))))
!(assertEqualToResult
  (syn &kb (fromNumber 4) (: $prf (-> (→ $r $s) (-> (→ $q $r) (-> (→ $p $q) (→ $p $s))))))
  ((: ((((. .) .) Deduction) Deduction) (-> (→ $r $s) (-> (→ $q $r) (-> (→ $p $q) (→ $p $s)))))
   (: ((. (. Deduction)) Deduction) (-> (→ $r $s) (-> (→ $q $r) (-> (→ $p $q) (→ $p $s)))))))

;; Test Iterative Chainer Wrapped Around Forward Revertant (collapse)
! "=== Test Iterative Chainer Wrapped Around Backward DTL Curried (collapse) ==="

;; No iteration
!(assertEqual
  (isyn &kb Z Z (: a A))
  (: a A))
!(assertEqualToResult
  (match &kb (,
   (: ab (→ A B))
   (: bc (→ B C))
   (: a A)
   (: ModusPonens (-> (→ $p $q) (-> $p $q)))
   (: Deduction (-> (→ $q $r) (-> (→ $p $q) (→ $p $r))))
   (: . (-> (-> $q $r) (-> (-> $p $q) (-> $p $r)))))
  asserted)
  (asserted))

;; One iteration of two steps backward chainer.  We need two steps
;; of backward chaining because one step merely returns what is in the
;; knowledge/rule base.
!(assertEqual
  (isyn &kb (fromNumber 2) (fromNumber 1) (: $prf B))
  (: ((ModusPonens ab) a) B))
!(assertEqualToResult
  (match &kb (,
   (: ab (→ A B))
   (: bc (→ B C))
   (: a A)
   (: ModusPonens (-> (→ $p $q) (-> $p $q)))
   (: Deduction (-> (→ $q $r) (-> (→ $p $q) (→ $p $r))))
   (: . (-> (-> $q $r) (-> (-> $p $q) (-> $p $r))))
   (: ((ModusPonens ab) a) B))
  asserted)
  (asserted)) 

;; One iteration of two steps backward chainer.  C can be proven with
;; just one iteration by re-using the proof of B.
!(assertEqual
  (isyn &kb (fromNumber 2) (fromNumber 1) (: $prf C))
  (: ((ModusPonens bc) ((ModusPonens ab) a)) C))
!(assertEqualToResult
  (match &kb (,
   (: ab (→ A B))
   (: bc (→ B C))
   (: a A)
   (: ModusPonens (-> (→ $p $q) (-> $p $q)))
   (: Deduction (-> (→ $q $r) (-> (→ $p $q) (→ $p $r))))
   (: . (-> (-> $q $r) (-> (-> $p $q) (-> $p $r))))
   (: ((ModusPonens ab) a) B)
   (: ((ModusPonens bc) ((ModusPonens ab) a)) C))
  asserted)
  (asserted))

;; One iteration of four steps backward chainer.  With four steps,
;; proof abstractions such as 3-premises version of Modus Ponens can
;; be inferred as well.
!(assertEqualToResult
  (isyn &kb (fromNumber 4) (fromNumber 1)
        (: $prf (-> (→ $q $r) (-> (→ $p $q) (-> $p $r)))))
  ((: ((((. .) .) ModusPonens) Deduction)
      (-> (→ $q $r) (-> (→ $p $q) (-> $p $r))))
   (: ((. (. ModusPonens)) Deduction)
      (-> (→ $q $r) (-> (→ $p $q) (-> $p $r))))))

;; Let's add more premises to the knowledge base
!(add-atom &kb (: cd (→ C D)))
!(add-atom &kb (: de (→ D E)))
!(add-atom &kb (: ef (→ E F)))

;; Then F can be proven with one iteration and three steps (instead of
;; four) of backward chaining by re-using the proof abstraction
;; previously inferred.
;;
;; TODO: re-enable after introducing assert contain
;; !(assertEqualToResult
  !(isyn &kb (fromNumber 3) (fromNumber 1) (: $prf F))
  ;; ((: (((((((. .) .) ModusPonens) Deduction) ef) de) ((ModusPonens cd) ((ModusPonens bc) ((ModusPonens ab) a)))) F)
  ;;  (: (((((. (. ModusPonens)) Deduction) ef) de) ((ModusPonens cd) ((ModusPonens bc) ((ModusPonens ab) a)))) F))
