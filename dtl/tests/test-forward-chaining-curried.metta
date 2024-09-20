;; Register module
!(register-module! ../../../chaining)
!(import! &self chaining:dtl:forward:curried)
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

;; Test forward chainer DTL curried
! "=== Test forward Chainer DTL Curried ==="

;; Source is always assumed true
!(assertEqual
  (fc &kb Z (: a A))
  (: a A))

;; Two step forward with source: A 
!(assertEqualToResult
  (fc &kb (fromNumber 2) (: a A))
  ((: a A)
   (: ((ModusPonens ab) a) B)))

;; Three step forward with source: A 
!(assertEqualToResult
  (fc &kb (fromNumber 3) (: a A))
  ((: a A)
   (: ((ModusPonens ab) a) B)
   (: ((ModusPonens bc) ((ModusPonens ab) a)) C)))

;; Test iterative forward chainer DTL curried
! "=== Test iterative forward Chainer DTL Curried ==="

!(add-atom &kb (: cd (→ C D)))

!(assertEqualToResult
  (ifcc &kb (fromNumber 3) (fromNumber 2) (: a A))
  ((: a A)
   (: ((ModusPonens ab) a) B)
   (: ((ModusPonens bc) ((ModusPonens ab) a)) C)
   (: ((ModusPonens cd) ((ModusPonens bc) ((ModusPonens ab) a))) D)))
