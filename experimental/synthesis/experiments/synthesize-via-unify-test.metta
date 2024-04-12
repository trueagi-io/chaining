;; Import modules
!(import! &self synthesize-via-unify.metta)
!(import! &self ../../common/Record.metta)

;; Knowledge base
(: kb (-> Atom))
(= (kb) (superpose ((: f (-> Number String))
                    (: g (-> String Bool))
                    (: h (-> Bool Number))
                    (: i (-> String Number Bool)))))

;; Rule base
(: rb (-> Atom))
(= (rb) (superpose ((: . (-> (-> $b $c) (-> $a $b) (-> $a $c))) ; Function composition
                    (: .: (-> (-> $c $d) (-> $a $b $c) (-> $a $b $d)))))) ; Blackbird

;; Test program synthesizer
!(record synthesize ((: $term $type) kb rb Z))                  ; (: f (-> Number String)), (: g (-> String Bool)), (: h (-> Bool Number)), (: i (-> String Number Bool))
!(record synthesize ((: $term (-> Number String)) kb rb Z))     ; (: f (-> Number String))
!(record synthesize ((: $term (-> String Number Number)) kb rb (S Z)))     ; (: f (-> Number String))
!(record synthesize ((: $term (-> Number Bool)) kb rb (S Z)))   ; (: (. g f) (-> Number Bool))
!(record synthesize ((: (. g f) (-> Number Bool)) kb rb (S Z))) ; (: (. g f) (-> Number Bool))
!(record synthesize ((: (. g f) $type) kb rb (S Z)))            ; (: (. g f) (-> Number Bool))
!(record synthesize ((: $term $type) kb rb (S Z)))              ; (: f (-> Number String)), ..., (: (. f h) (-> Bool String)), ...
!(record synthesize ((: (. (. g f) h) (-> $in Bool)) kb rb (fromNumber 2))) ; (: (. (. g f) h) (-> Bool Bool)) (fromNumber 3))
!(record synthesize ((: (. $g h) $type) kb rb (fromNumber 3))) ; (: (. f h) (-> Bool String))
!(record synthesize ((: (. $g h) (-> Number $out)) kb rb (fromNumber 3)))   ; No answer
!(record synthesize ((: (. g $f) (-> $in String)) kb rb (fromNumber 3))) ; No answer
!(record synthesize ((: (. g $f) (-> $in Bool)) kb rb (fromNumber 3)))   ; (: (. g f) (-> Number Bool)), (: (. g (. f h)) (-> Bool Bool)), (: (. g (. f (. h g))) (-> String Bool))
!(record synthesize ((: $term $type) kb rb (fromNumber 4)))     ; Too long to list
;; !(record synthesize ((: $term (-> Number Number)) kb rb (fromNumber 6))) ; Too long to run
