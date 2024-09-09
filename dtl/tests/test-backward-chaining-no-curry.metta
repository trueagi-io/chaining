;; Import modules
!(register-module! ../../../chaining)
!(import! &self chaining:dtl:backward:no-curry)
!(import! &self chaining:dtl:utils)

;; Knowledge and rule base
!(bind! &kb (new-space))

;; Facts/axioms
!(add-atom &kb (: f (-> Number String)))
!(add-atom &kb (: g (-> String Bool)))
!(add-atom &kb (: h (-> Bool Number)))
!(add-atom &kb (: i (-> String Number Bool)))

;; Rules
!(add-atom &kb (: . (-> (-> $b $c) (-> $a $b) (-> $a $c)))) ; Function composition
!(add-atom &kb (: .: (-> (-> $c $d) (-> $a $b $c) (-> $a $b $d)))) ; Blackbird (generalized composition)

;; Test program synthesizer

;; Query for functions from Number to String at depth 0.
!(assertEqual
  (synthesize &kb Z (: $term (-> Number String)))
  (: f (-> Number String)))

;; Query for functions of depth 1, from String and Number to Number.
!(assertEqual
  (synthesize &kb (S Z) (: $term (-> String Number Number)))
  (: (.: h i) (-> String Number Number)))

;; Queries for any function from Number to Bool of at most depth 1.
!(assertEqual
  (synthesize &kb (S Z) (: $term (-> Number Bool)))
  (: (. g f) (-> Number Bool)))

;; Queries for the specific `(.g f)` composition, checking if it goes from Number to Bool af depth 1.
!(assertEqual
  (synthesize &kb (S Z) (: (. g f) (-> Number Bool)))
  (: (. g f) (-> Number Bool)))

;; Type inference for `(. g f)`
!(assertEqual
  (synthesize &kb (S Z) (: (. g f) $type))
  (: (. g f) (-> Number Bool)))

;; Input type inference for `(. (. g f) h)`, at depth 2
!(assertEqual
  (synthesize &kb (fromNumber 2) (: (. (. g f) h) (-> $in Bool)))
  (: (. (. g f) h) (-> Bool Bool)))

;; Query for any function which can be composed with `g`, taking any input type and return Bool, at depth 3
!(assertEqualToResult
  (synthesize &kb (fromNumber 3) (: (. g $f) (-> $in Bool)))
  ((: (. g f) (-> Number Bool))
   (: (. g (. f h)) (-> Bool Bool))
   (: (. g (. f (. h g))) (-> String Bool))
   (: (. g (. (. f h) g)) (-> String Bool))
   (: (. g (. (. f h) (. g f))) (-> Number Bool))))

;; Query for any function which can be composed with `h`, with any type signature, at depth 3
!(assertEqualToResult
  (synthesize &kb (fromNumber 3) (: (. $g h) $type))
  ((: (. f h) (-> Bool String))
   (: (. (. g f) h) (-> Bool Bool))
   (: (. (. h (. g f)) h) (-> Bool Number))
   (: (. (. (. f h) (. g f)) h) (-> Bool String))
   (: (. (. (. h g) f) h) (-> Bool Number))))

;; Query for any function which can be composed with `h`, taking a `Number` and returning any type, at depth 3
!(assertEqualToResult
  (synthesize &kb (fromNumber 3) (: (. $g h) (-> Number $out))) ; No answer, since `h` doesn't take Number
   ())

;; Query for any function which can be composed with `g` and take any input type and return String, at depth 3
!(assertEqualToResult
  (synthesize &kb (fromNumber 3) (: (. g $f) (-> $in String))) ; No answer, since `g` doesn't return string
   ())
