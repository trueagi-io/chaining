;; Import modules
!(register-module! ../../../chaining)
!(import! &self chaining:dtl:forward:no-curry)
!(import! &self chaining:dtl:utils)

;; Knowledge and rule base
!(bind! &kb (new-space))

!(add-atom &kb (: a A))
!(add-atom &kb (: ab (→ A B)))
!(add-atom &kb (: bc (→ B C)))

!(add-atom &kb (: ModusPonens (->
                            ;; Premises
                            (→ $p $q)
                            $p
                            ;; Conclusion
                            $q)))

!(add-atom &kb (: Deduction (->
                            ;; Premises
                            (→ $p $q)
                            (→ $q $r)
                            ;; Conclusion
                            (→ $p $r))))

!(assertEqualToResult
  (fc &kb (fromNumber 2) (: a A))
  ((: a A)
   (: (ModusPonens ab a) B)
   (: (ModusPonens bc (ModusPonens ab a)) C)))
!(assertEqualToResult
  (fc &kb (fromNumber 2) (: ab (→ A B)))
  ((: ab (→ A B))
   (: (ModusPonens ab a) B)
   (: (ModusPonens bc (ModusPonens ab a)) C)
   (: (Deduction ab bc) (→ A C))
   (: (ModusPonens (Deduction ab bc) a) C)))
!(assertEqualToResult
  (let (: $prf (→ $x $y)) (match &kb $a $a)
       (fc &kb (fromNumber 1) (: $prf (→ $x $y))))
  ((: ab (→ A B))
   (: bc (→ B C))
   (: (ModusPonens ab a) B)
   (: (Deduction ab bc) (→ A C))
   (: (Deduction ab bc) (→ A C))))
