;; Experiment to verify or rediscover proofs of the propositional
;; calculus fragment of set theory of Metamath.
;;
;; TIMEOUT-RESCUE CASCADE (LLM as last resort, skip on LLM miss):
;;   For EVERY theorem (from iteration 2, no index gating):
;;     eval 1 -- hot-KB (30 most recent lemmas + axioms), wall-clock-capped
;;               at (hot-timeout-seconds); a timeout counts as a hot miss.
;;     eval 2 -- full KB, wall-clock-capped at (obc-timeout-seconds) = 10 min
;;               via timed_obc_once (pc_xp_timed.pl).
;;               * found     -> done
;;               * not_found -> search space exhausted at this proof size;
;;                              with skips accumulating this usually means a
;;                              needed lemma was skipped earlier -> SKIP this
;;                              theorem too and keep going.
;;               * timeout   -> queue the LLM rescue.
;;     eval 3 -- LLM-predicted sub-theory (training corpus: 6-183).
;;               * found -> done
;;               * miss  -> SKIP this theorem (it is NOT added to the KB)
;;                          and move on to the next iteration.
;;   No upper bound: the run continues to the corpus end, skipping the
;;   theorems that neither a 10-min full-KB search nor the LLM can crack.
;;   NOTE: a skipped theorem's lemma is unavailable to later proofs, so
;;   downstream theorems that need it may themselves time out and skip.
;; EVERY tier runs in its own `until` iteration (exactly one obc call per
;; evaluation), chained by the full-retry-idx / llm-retry-idx state flags:
;; a tier miss queues the next tier and re-runs the same idx.  Multiple obc
;; calls per evaluation are NOT safe: a 3rd call spuriously found nothing
;; (iteration 83 com23), and even a 2nd call hard-failed silently and
;; killed the until loop (iteration 161 impi, 2026-07-13).  This mirrors
;; the same-idx-retry mechanism pc-xp-llm-theory uses.

;; NEXT: automate the discovery process of reduction rules.  It is
;; especially relevant here because new lemmas are constantly added.
;; Thus hand written reduction rules will not suffice.

;; Note that all type definitions over functions have been commented
;; out because it results in a significant speed up.

;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;; ;;
;; ;; Parameters ;; ;;
;; ;;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Experiment Parameters ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Process assertions up to the provided index (excluded).  The
;; maximum value is 1526 because the full corpus contains 1525
;; assertions.
;;
;; When using proof depth as search boundary, it is set to 95 because
;; the 95 theorem is very slow to proof.
;;
;; When using proof size as search boundary, it is set to 182 because
;; the 182 theorem is very slow to proof.
;;
;; Set to the maximum (1526): NO upper bound -- with the skip-on-LLM-miss
;; policy the run keeps going past theorems it cannot crack, so it stops
;; only at the corpus end or on a genuine (fast) full-KB exhaustion.
(= (up-to-idx) 1526)

;;;;;;;;;;;;;;;;;;;;;;;
;; Search Parameters ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Whether to reverse the order of arguments.  For instance
;;
;; (: ax-mp (-> $𝜑 (→ $𝜑 $𝜓) $𝜓))
;;
;; becomes
;;
;; (: ax-mp (-> (→ $𝜑 $𝜓) $𝜑 $𝜓))
;;
;; This can speed up the proof search because in the reversed order,
;; the first arguments tend to be more constrained than the lastest
;; ones, which can have the effect of pruning earlier the search.
;;
;; Indeed, early results confirm that.  Reversing the arguments allows
;; to rediscover the first proofs (up to index 50 excluded) in 9.144s,
;; instead of 6m47.418s if not reversed.
(= (reverse-arguments) True)

;; Re-discover proofs.  If it is True then the proofs are attempted to
;; be re-discovered instead of merely being checked.
(= (search-proof) True)

;; For each theorem, search for all possible proofs.  Otherwise, stop
;; at the first one.
(= (search-all-proofs) False)

;; Bound search by proof size instead of proof depth.
(= (bound-search-by-proof-size) True)

;; Use proof reduction as pruning mechanism during search
(= (prune-reduct) False)

;; Use a hot-knowledge base for speedy proof search.  The hot-knowledge
;; base is a sub-theory consisting of all axioms plus only the latest
;; lemmas (controlled by hot-kb-size).  When enabled the proof search
;; first tries the hot-KB and, only if no proof is found, falls back to
;; the full knowledge bases.
(= (use-hot-kb) True)

;; Number of most recently proved lemmas to retain in the hot-knowledge
;; base.  Older lemmas are evicted so that the search space does not
;; grow unboundedly.  Original axioms are never evicted.
(= (hot-kb-size) 30)

;; Use an LLM to predict a small relevant sub-theory as the RESCUE tier:
;; it is consulted only when the timed full-KB search exceeds its wall-clock
;; budget.  The LLM is asked which labels (axioms + lemmas) are likely
;; needed to prove the current goal; those labels are copied into small
;; "llm" bases (&pc-llm-rb / &pc-llm-ab) and searched.  If even the LLM
;; misses, the theorem is SKIPPED (not added to the KB) and the run moves
;; on.  Worked examples: pc-xp-llm-trace-obc-log-to-183-lean.metta (6-183),
;; so LLM rescues at <= 183 are answer-in-prompt; 184+ are genuine.
(= (use-llm-theory) True)

;; Wall-clock budget (seconds) for the full-KB obc search (via
;; timed_obc_once in pc_xp_timed.pl).  If the search exceeds this, it is
;; aborted and the LLM rescue is queued.  10 minutes.
(= (obc-timeout-seconds) 600)

;; Wall-clock budget (seconds) for the HOT-KB search.  Hot searches are
;; normally sub-second, but at large proof sizes even the 30-lemma space
;; explodes (observed: pm2.61iii at size 13 ground for 43+ min in the hot
;; tier -- discovered 2026-07-19).  A hot search over budget counts as a
;; hot miss and falls through to the timed full-KB tier.
(= (hot-timeout-seconds) 60)

;; LLM backend selector, consumed by the Python bridge (pc_xp_llm.py):
;; "claude"/"anthropic", "gemini"/"google", "minimax"/"snet", "openai"/"gpt",
;; "ollama", or "ollama:<model>".
;; "claude" needs ANTHROPIC_API_KEY in the environment (with balance!);
;; model defaults to claude-fable-5, override with ANTHROPIC_MODEL.
(= (llm-model) "claude")

;; Per-call timeout (seconds) for the prediction request.
(= (llm-timeout) 60)

;;;;;;;;;;;;;;;;;;;;;;;
;; Logger Parameters ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Log level
(= (log-level) debug)

;; Log file path
(= (log-filepath) "pc-xp.log")

;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;; ;;
;; ;; Imports ;; ;;
;; ;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;

;; Import logger library.
!(import! &self (library lib_import))
!(progn (translatePredicate (working_dir $this-dir))
        (translatePredicate (atomic_list_concat ($this-dir "/repos") $repos-dir))
        (git-import! "https://github.com/ngeiswei/petta_lib_logger" "" $repos-dir))
!(import_prolog_functions_from_file (library petta_lib_logger lib_logger.pl)
                                    (logger-set-filepath
                                     logger-set-level
                                     logger-info
                                     logger-infof
                                     logger-debugf
                                     logger-tracef))

;; Load the LLM sub-theory predictor bridge.  pc_xp_llm.py must be on the
;; PYTHONPATH; importing it registers _registerLabel / _predictTheory /
;; _inPredicted onto builtins.
!(if (use-llm-theory) (import! &self "pc_xp_llm.py") ())

;; Import the propositional calculus corpus in the format
;; (MkIndexed INDEX (MkAxiom LABEL AXIOM))
;; (MkIndexed INDEX (MkTheorem LABEL PROOF THEOREM))
!(if (reverse-arguments)
     (import! &pc-idxd ../../metamath/propositional-calculus-reversed-arguments)
     (import! &pc-idxd ../../metamath/propositional-calculus))

;;;;;;;;;;;;;;;;;;;;;;
;; Configure Logger ;;
;;;;;;;;;;;;;;;;;;;;;;

!(logger-set-level (log-level))
!(progn (translatePredicate (working_dir $this-dir))
        (translatePredicate (atomic_list_concat ($this-dir "/" (log-filepath)) $log-path))
        (logger-set-filepath $log-path))

;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;; ;;
;; ;; Functions ;; ;;
;; ;;;;;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;
;; Concat ;;
;;;;;;;;;;;;

;; Concat atoms.  The implementation uses union-atom and assumes that
;; it preserves order.
(= (concat-atom $x $y) (union-atom $x $y))

;;;;;;;;;;
;; When ;;
;;;;;;;;;;

;; Binary conditional.  Only execute branch if condition is True
(: when (-> Bool Atom $a))
(= (when $c $x) (if $c $x (empty)))

;;;;;;;;;;;
;; Sized ;;
;;;;;;;;;;;

;; Associate a size to a term
(: Sized (-> $a Type))
(: MkSized (-> $n                       ; Size
               $a                       ; Object
               (Sized $a)))             ; Sized object

;; Access functions
(= (Sized.size (MkSized $s $x)) $s)
(= (Sized.object (MkSized $s $x)) $x)

;;;;;;;;;;;;;;;
;; Assertion ;;
;;;;;;;;;;;;;;;

;; Assertion, either axiom or theorem
(: Assertion Type)
(: MkAxiom (-> Symbol ; Label
               Atom   ; Axiom
               Assertion))
(: MkTheorem (-> Symbol ; Label
                 Atom   ; Proof
                 Atom   ; Theorem
                 Assertion))

;; Indexed assertion
(: Indexed Type)
(: MkIndexed (-> Number    ; Index
                 Assertion ; Axiom or Theorem
                 Indexed))

;;;;;;;;;
;; Nat ;;
;;;;;;;;;

;; Define Nat
(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

;; Define cast functions between Nat and Number
;; (: fromNumber (-> Number Nat))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))
;; (: fromNat (-> Nat Number))
(= (fromNat Z) 0)
(= (fromNat (S $k)) (+ 1 (fromNat $k)))

;;;;;;;;;;;
;; Maybe ;;
;;;;;;;;;;;

;; Define Maybe type
(: Maybe (-> $a Type))
(: Nothing (Maybe $a))
(: Just (-> $a (Maybe $a)))

;; Implement monad interface for return
;; (: Maybe.return (-> $a (Maybe $a)))
(= (Maybe.return $x) (Just $x))

;; Implement monad interface for bind
;; (: Maybe.bind (-> (Maybe $a) (-> $a (Maybe $b)) (Maybe $b)))
(= (Maybe.bind Nothing $f) Nothing)
(= (Maybe.bind (Just $x) $f) ($f $x))

;; Test Maybe
(: Maybe.test.foo (-> Number (Maybe String)))
(= (Maybe.test.foo $x) (if (== $x 42) (Just "42") Nothing))
!(test
  (Maybe.bind Nothing Maybe.test.foo)
  Nothing)
!(test
  (Maybe.bind (Just 0) Maybe.test.foo)
  Nothing)
!(test
  (Maybe.bind (Just 42) Maybe.test.foo)
  (Just "42"))

;;;;;;;;;;;;
;; Syntax ;;
;;;;;;;;;;;;

;; Return True iff the given term is an expression
;; (: is-expression (-> $a Bool))
(= (is-expression $x) (== (get-metatype $x) Expression))

;; Test is-expression
!(test
  (is-expression id)
  False)

;; Return True iff the given term is a lambda abstraction, meaning an
;; expression of the form (λ VARIABLES BODY)
;;
;; NEXT: simplify once issue
;; https://github.com/trueagi-io/PeTTa/issues/182 has been
;; solved.
;; (: is-lambda (-> $a Bool))
(= (is-lambda $x)
   (if (is-expression $x)
       (if (== () $x)
           False
           (== λ (car-atom $x)))
       False))

;; Test is-lambda
!(test
  (is-lambda A)
  False)
!(test
  (is-lambda (A B))
  False)
!(test
  (is-lambda (λ $x $y))
  True)

;; Return True iff the given term is an arrow type, meaning has the
;; following format (-> A), (-> A B), (-> A B C), etc.
;;
;; NEXT: simplify once issue
;; https://github.com/trueagi-io/PeTTa/issues/182 has been
;; solved.
;; (: is-arrow (-> Atom Bool))
(= (is-arrow $x)
   (if (is-expression $x)
       (if (== () $x)
           False
           (== -> (car-atom $x)))
       False))

;; Test is-arrow
!(test
  (is-arrow A)
  False)
!(test
  (is-arrow (F A B))
  False)
!(test
  (is-arrow (-> $a $b))
  True)

;; Return True iff the given term is a product, meaning an expression
;; of the form (, FIRST SECOND)
;;
;; NEXT: simplify once issue
;; https://github.com/trueagi-io/PeTTa/issues/182 has been
;; solved.
;; (: is-product (-> $a Bool))
(= (is-product $x)
   (if (is-expression $x)
       (if (== () $x)
           False
           (== , (car-atom $x)))
       False))

;; Test is-lambda
!(test
  (is-product A)
  False)
!(test
  (is-product (A B))
  False)
!(test
  (is-product (, A B))
  True)

;; Drop last element of a tuple
(= (drop-last $xs)
   (if (is-expression $xs)
       (if (== $xs ())
           (empty)
           (if (== (length $xs) 1)
               ()
               (let* ((($head $tail) (decons-atom $xs))
                      ($dlt (drop-last $tail)))
                 (cons-atom $head $dlt))))
       (empty)))

;; Test drop-last
!(test
  (drop-last (A))
  ())
!(test
  (drop-last (A B))
  (A))
!(test
  (drop-last (A B C))
  (A B))

;; Take last element of a tuple
(= (take-last $xs)
   (if (is-expression $xs)
       (if (== $xs ())
           (empty)
           (if (== (length $xs) 1)
               (car-atom $xs)
               (take-last (cdr-atom $xs))))
       (empty)))

;; Test take-last
!(test
  (take-last (A))
  A)
!(test
  (take-last (A B))
  B)

;; Get lambda variables.  Prune if not a lambda term.
(= (get-lambda-variables $term)
   (if (is-lambda $term)
       (let ($h $t) (decons-atom $term)
            (drop-last $t))
       (empty)))

;; Test get-lambda-variables
!(test
  (collapse (get-lambda-variables A))
  ())
!(test
  (get-lambda-variables (λ $x $y))
  ($x))
!(test
  (get-lambda-variables (λ $x1 $x2 $y))
  ($x1 $x2))

;; Get lambda body.  Prune if not a lambda term.
(= (get-lambda-body $term)
   (if (is-lambda $term)
       (take-last $term)
       (empty)))

;; Test get-lambda-body
!(test
  (collapse (get-lambda-body A))
  ())
!(test
  (get-lambda-body (λ $x A))
  A)
!(test
  (get-lambda-body (λ $x1 $x2 A))
  A)

;; Get arrow premises.  Prune if not an arrow.
(= (get-arrow-premises $term)
   (if (is-arrow $term)
       (let ($h $t) (decons-atom $term)
            (drop-last $t))
       (empty)))

;; Test get-lambda-variables
!(test
  (collapse (get-arrow-premises A))
  ())
!(test
  (get-arrow-premises (-> A B))
  (A))
!(test
  (get-arrow-premises (-> A B C))
  (A B))

;; Get lambda body.  Prune if not a lambda term.
(= (get-arrow-conclusion $term)
   (if (is-arrow $term)
       (take-last $term)
       (empty)))

;; Test get-lambda-body
!(test
  (collapse (get-arrow-conclusion A))
  ())
!(test
  (get-arrow-conclusion (-> A B))
  B)
!(test
  (get-arrow-conclusion (-> A B C))
  C)

;;;;;;;;;
;; Zip ;;
;;;;;;;;;

;; Zip two tuples with a given function.  It is assumed that both $xs
;; and $ys have the same length.
(= (zip-with $f $xs $ys)
   (if (== $xs ())
       ()
       (let* ((($xh $xt) (decons-atom $xs))
              (($yh $yt) (decons-atom $ys))
              ($zh ($f $xh $yh))
              ($zt (zip-with $f $xt $yt)))
         (cons-atom $zh $zt))))

;; Test zip-with
!(test
  (zip-with : () ())
  ())
!(test
  (zip-with : (x) (a))
  ((: x a)))
!(test
  (zip-with : (x y) (a b))
  ((: x a) (: y b)))

;;;;;;;;;;;;;;;;;;;;;;
;; Match over tuple ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Match pattern over a tuple of elements
(= (match' $tuple $ptrn $tmpl) (let $ptrn (superpose $tuple) $tmpl))

;; Test match' on empty tuple
!(test
  (collapse (match' () ($x $y) ($y $x)))
  ())

;; Test match' on singleton
!(test
  (collapse (match' ((A B)) ($x $y) ($y $x)))
  ((B A)))

;; Test match' on pair
!(test
  (collapse (match' ((A B) (C D)) ($x $y) ($y $x)))
  ((B A)
   (D C)))

;;;;;;;;;
;; Get ;;
;;;;;;;;;

;; Specialized match where the pattern is equal to the template
(= (get $spc $ptrn) (match $spc $ptrn $ptrn))

;; Specialized match' where the pattern is equal to the template
(= (get' $spc $ptrn) (match' $spc $ptrn $ptrn))

;;;;;;;;;;
;; Fold ;;
;;;;;;;;;;

;; Fold a tuple from right to left
;; (: foldr (-> (-> $a $b $b) $b $c $d))  ; NEXT: re-enable when fixed
(= (foldr $f $i $xs)
   (if (== $xs ())
       $i
       (let* ((($h $t) (decons-atom $xs))
              ($ft (foldr $f $i $t)))
         ($f $h $ft))))

;; Test foldr
!(test
  (foldr + 0 (1 2 3))
  6)

;;;;;;;;;;;;;;;
;; Successor ;;
;;;;;;;;;;;;;;;

;; Increment a number by 1
;; (: succ (-> Number Number))
(= (succ $n) (+ 1 $n))

;;;;;;;;;
;; Map ;;
;;;;;;;;;

;; (: map (-> (-> $a $b) $c $d))
(= (map $f $xs) (case $xs
                  (;; Empty expression
                   (() ())
                   ;; Non-empty expression
                   ($xs (let* ((($h $t) (decons-atom $xs))
                               ($fh ($f $h))
                               ($ft (map $f $t)))
                          (cons-atom $fh $ft))))))

;; Test map
!(test
  (map succ (0 1 2))
  (1 2 3))

;;;;;;;;;;;;;;;;;
;; Max element ;;
;;;;;;;;;;;;;;;;;

;; Given a tuple of numbers, return the maximum, or 0 if empty.
;; (: max-element (-> $a Number))
(= (max-element $expr) (foldr max 0 $expr))

;; Test max-element
!(test
  (max-element (1 3 2))
  3)

;;;;;;;;;;;;;;;
;; Max index ;;
;;;;;;;;;;;;;;;

;; Extract the maximum index of a corpus in a given space
;; (: max-index (-> $a Number))
(= (max-index $spc)
   (max-element (collapse (match $spc (MkIndexed $idx $asrt) $idx))))

;;;;;;;;;;;
;; Until ;;
;;;;;;;;;;;

;; Loop-like function ported from Haskell.  Iterate applying a given
;; function till some condition is reached.  You may want to make sure
;; that the predicate and the next function are deterministic,
;; otherwise the behavior of until might be a bit unpredictable.
;; (: until (-> (-> $a Bool)               ; Predicate
;;              (-> $a $a)                 ; Next
;;              $a                         ; Initial value
;;              $a))                       ; Final value
(= (until $p $f $x)
   (if ($p $x) $x (until $p $f ($f $x))))

;; Test until
(: test.equal-to-10 (-> Number Bool))
(= (test.equal-to-10 $x) (== 10 $x))
!(test
  (until test.equal-to-10 succ 0)
  10)

;;;;;;;;;;;;;;;;
;; Term depth ;;
;;;;;;;;;;;;;;;;

;; Return the depth of a term.  If the term is a symbol then the depth
;; is 0.  Likewise the depth of (R A B) is 1, etc.
;; (: term-depth (-> $a Number))
(= (term-depth $term)
   (case (get-metatype $term)
     (;; Symbol
      (Symbol 0)
      ;; Grounded
      (Grounded 0)
      ;; Variable
      (Variable 0)
      ;; Expression
      (Expression (+ (max-element (map term-depth $term)) 1)))))

;; Test term-depth
!(test
  (term-depth A)
  0)
!(test
  (term-depth (R A (S B C)))
  2)

;;;;;;;;;;;;;;;
;; Term size ;;
;;;;;;;;;;;;;;;

;; Return the size of a term, which correspond to the number symbols,
;; variables and grounded subterms in the given term.
(= (term-size $x)
   (if (is-expression $x)
       (if (== $x ())
           0
           (let ($head $tail) (decons-atom $x)
                (+ (term-size $head) (term-size $tail))))
       1))

;; Test term-size
!(test
  (term-size A)
  1)
!(test
  (term-size ((R A) $x))
  3)
!(test
  (term-size (R A (S B C)))
  5)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Replace body of lambda by variable ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Take a term representing a proof and replace its body by a variable
;; (as to be able to rediscover it).  If it is a lambda abstraction,
;; then replace the lambda term body by a variable, other replace the
;; whole term by a variable.
;; (: replace-body-by-variable (-> $a $a))
(= (replace-body-by-variable $prf)
   (case (get-metatype $prf)
     ((Symbol $y)
      (Grounded $y)
      (Variable $y)
      (Expression
       (if (== () $prf)
           $y
           (case $prf
             (;; Unary lambda abstraction
              ((λ $x $bdy)
               (λ $x $y))
              ;; Binary lambda abstraction
              ((λ $x1 $x2 $bdy)
               (λ $x1 $x2 $y))
              ;; Ternary lambda abstraction
              ((λ $x1 $x2 $x3 $bdy)
               (λ $x1 $x2 $x3 $y))
              ;; Quaternary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $bdy)
               (λ $x1 $x2 $x3 $x4 $y))
              ;; Quintenary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $x5 $bdy)
               (λ $x1 $x2 $x3 $x4 $x5 $y))
              ;; Senary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $x5 $x6 $bdy)
               (λ $x1 $x2 $x3 $x4 $x5 $x6 $y))
              ;; Septenary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $bdy)
               (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $y))
              ;; Octonary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $bdy)
               (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $y))
              ;; Nonary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $bdy)
               (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $y))
              ;; Denary lambda abstraction
              ((λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10 $bdy)
               (λ $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10 $y))
              ;; Otherwise
              ($else $y))))))))

;; Test replace-body-by-variable
!(test
  (replace-body-by-variable (λ mpi.2 mpi.1 (mpd mpi.2 (a1i mpi.1))))
  (λ mpi.2 mpi.1 $bdy))
!(test
  (replace-body-by-variable (mpd ax-1 ax-1))
  $bdy)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Variable Introduction ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Replace a given symbol by a variable in a term.
;; (: replace-symbol-by-variable (-> Symbol $a $a))
(= (replace-symbol-by-variable $sym $term) (_replace-symbol-by-variable $sym $x $term))
;; (: _replace-symbol-by-variable (-> Symbol Variable $a $a))
(= (_replace-symbol-by-variable $sym $var $term)
   (case (get-metatype $term)
     ((Symbol (if (== $sym $term) $var $term))
      (Grounded $term)
      (Variable $term)
      (Expression (if (== $term ())
                      $term
                      (let* (;; Get head and tail of term
                             (($head $tail) (decons-atom $term))
                             ;; Recurs on head
                             ($nhd (_replace-symbol-by-variable $sym $var $head))
                             ;; Recurs on tail
                             ($ntl (_replace-symbol-by-variable $sym $var $tail)))
                        ;; Cons result
                        (cons-atom $nhd $ntl)))))))

;; Test replace-symbol-by-variable
!(test
  (replace-symbol-by-variable 𝜑 𝜑)
  $𝜑)
!(test
  (replace-symbol-by-variable 𝜑 (-> (→ 𝜑 (→ 𝜓 𝜒)) 𝜓 𝜑 𝜒))
  (-> (→ $𝜑 (→ 𝜓 𝜒)) 𝜓 $𝜑 𝜒))

;; Replace all greek letters by variables
;; (: replace-greeks-by-variables (-> $a $a))
(= (replace-greeks-by-variables $term)
   (foldr replace-symbol-by-variable $term (𝜑 𝜓 𝜒 𝜃 𝜏 𝜂 𝜁 𝜎 𝜌 𝜇 𝜆 𝜅)))

;; Test replace-greeks-by-variables
!(test
  (replace-greeks-by-variables 𝜑)
  $𝜑)
!(test
  (replace-greeks-by-variables (-> (→ 𝜑 (→ 𝜓 𝜒)) 𝜓 𝜑 𝜒))
  (-> (→ $𝜑 (→ $𝜓 $𝜒)) $𝜓 $𝜑 $𝜒))

;;;;;;;;;;;;;;;
;; Reduction ;;
;;;;;;;;;;;;;;;

;; Define space mapping proof and theorem to label, with
;; representation of the form:
;;
;; (Label PROOF THEOREM LABEL)
!(bind! &labels (new-space))

;; Reduce by pruning.  That is only the candidates in reduced form are
;; kept, the others are pruned.  For now only reducing proof to its
;; label is supported.  Meaning that only a proof of a given theorem
;; not associated to an existing label is allowed.  In other words,
;; instead of rediscovering the proof, it should re-use this label.
;; Note that the theorem must match as well as the proof, to make sure
;; that the corresponding label does not correspond to an overly
;; specialized theorem, otherwise the final proof checking will fail
;; to unify.
(= (prune-reduce (: $x $a))
   (progn
    ;; (logger-tracef "Call: (prune-reduce %w)" ((: $x $a)))
    (case (once (match &labels (Label $x $a $l) $l))
      (($l (progn
            ;; (logger-tracef "%w is not in normal form, prune" ((: $x $a)))
            (empty)))
       (Empty (progn
               ;; (logger-tracef "%w is in normal form, do not prune" ((: $x $a)))
               (: $x $a)))))))

;; The code below, regular not pruning-based reduction, is only kept
;; for documentation or potential future use.

;; Reduce a proof to its label if any, or nothing otherwise.
;; (: reduce-to-label (-> $a (Maybe $a)))
(= (reduce-to-label $x)
   (case (once (match &labels (Label $x $y) $y))
     (($y (Just $y))
      (Empty Nothing))))

;; Apply any reduction rules till a fixed point is reached.  The input
;; is supposed to be closed, that is it does not contain free
;; variables.  Also, in applications such as (f a), f can be assumed
;; not to be reducible due to the lack of higher order rules in
;; propositional calculus.
;; (: reduce-proof (-> $a $a))
(= (reduce-proof $x)
   (if (is-expression $x)
       ;; Recursive steps
       (case $x
         (;; Nullary tuple
          (() ())
          ;; Unary application
          (($f $x1)
           (let $nx1 (reduce-proof $x1)
             (if (== $nx1 $x1)
                 ;; $x1 already reduced, attempt to reduce $x to label
                 (case (reduce-to-label $x)
                   (;; Reduced, return $y
                    ((Just $y) $y)
                    ;; Not reduced, return $x
                    (Nothing $x)))
                 ;; $x1 is reducible, reapply reduction
                 (reduce-proof ($f $nx1)))))
          ;; Binary application
          (($f $x1 $x2)
           (let* (($nx1 (reduce-proof $x1))
                  ($nx2 (reduce-proof $x2)))
             (if (and (== $nx1 $x1)
                      (== $nx2 $x2))
                 ;; $x1 and $x2 are already reduced, attempt to reduce
                 ;; $x to label
                 (case (reduce-to-label $x)
                   (;; Reduced, return $y
                    ((Just $y) $y)
                    ;; Not reduced, return $x
                    (Nothing $x)))
                 ;; $x1 and $x2 are reducible, reapply reduction
                 (reduce-proof ($f $nx1 $nx2)))))
          ;; Ternary application
          (($f $x1 $x2 $x3)
           (let* (($nx1 (reduce-proof $x1))
                  ($nx2 (reduce-proof $x2))
                  ($nx3 (reduce-proof $x3)))
             (if (and (== $nx1 $x1)
                      (and (== $nx2 $x2)
                           (== $nx3 $x3)))
                 ;; All arguments are already reduced, attempt to
                 ;; reduce $x to label
                 (case (reduce-to-label $x)
                   (;; Reduced, return $y
                    ((Just $y) $y)
                    ;; Not reduced, return $x
                    (Nothing $x)))
                 ;; Arguments are reducible, reapply reduction
                 (reduce-proof ($f $nx1 $nx2 $nx3)))))))
       ;; Base case
       (case (reduce-to-label $x)
         (;; Reduced, return $y
          ((Just $y) $y)
          ;; Not reduced, return $x
          (Nothing $x)))))

;; ;; Test reduce
;; !(add-atom &labels (Label (a1i id_) idd))
;; !(add-atom &labels (Label (mpd ax-1 ax-1) id_))
;; !(add-atom &labels (Label (3bitr2i bicom
;;                                    (bibi2i notnotb)
;;                                    notbi)
;;                           con2bi))
;; !(test
;;   (reduce-to-label ax-1)
;;   Nothing)
;; !(test
;;   (reduce-to-label (mpd ax-1 ax-1))
;;   (Just id_))
;; !(test
;;   (reduce-proof ax-1)
;;   ax-1)
;; !(test
;;   (reduce-proof id_)
;;   id_)
;; !(test
;;   (reduce-proof (a1i id_))
;;   idd)
;; !(test
;;   (reduce-proof (mpd ax-1 ax-1))
;;   id_)
;; !(test
;;   (reduce-proof (3bitr2i bicom (bibi2i notnotb) notbi))
;;   con2bi)

;;;;;;;;;;;;;;
;; Callback ;;
;;;;;;;;;;;;;;

;; Callback to be passed to the backward chainer.  It is called over
;; every result, intermediary included, that the backward chainer
;; finds.  For now it used as a reduction pruner, meaning that if the
;; result is recognized as reducible, then it is pruned.
;; (: callback (-> $a $a))
(= (callback (: $x $a)) ; (: $x $a))
   (progn
    ;; (logger-tracef "Call: (callback %w)" ((: $x $a)))
    (if (prune-reduct)
        (prune-reduce (: $x $a))
        (: $x $a))))

;;;;;;;;;;;;;;;;;;;;;;
;; Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Backward Chainer with support for lambda abstraction at the entry
;; point (no recursive search on lambda terms).  The knowledge is
;; decomposed into a rule base and an axiom base because we know we
;; never need to search both at the same time, only one or the other.
;;
;; The arguments of the backward chainer are:
;;
;; * Rule base: reference to a space containing rules in the format
;;
;; (: NAME (-> PREMISE1 ... CONCLUSION))
;;
;; * Axiom base: reference to a space containing axioms in the format
;;
;; (: NAME AXIOM)
;;
;; * Callback: function to be called everytime a result, final or
;;   intermediary is produced.  This function can be used to for
;;   instance store final and intermediary results, or acts as a
;;   filter (by returning (empty) when a condition is met, or any
;;   combinations thereof.
;;
;; * Maximum depth: maximum depth of the generated proof tree.
;;
;; * Query: a metta term of the form (: <PROOF> <THEOREM>) where
;;   <PROOF> and <THEOREM> may contain free variables that may be
;;   filled by the backward chainer.
;;
;; A result is the query with its variables grounded, fully or
;; partially.  If multiple results are possible, they are returned as
;; a superposition.

;; Entry point
;; (: bc (-> $a                            ; Rule base space
;;           $b                            ; Axiom base space
;;           (-> $c $c)                    ; Callback
;;           Nat                           ; Maximum depth
;;           $c                            ; Query
;;           $c))                          ; Result
(= (bc $rb $ab $cb $depth (: $prf $thrm))
   (progn
    (logger-tracef "Call (lambda): (bc %w %w %w %w (: %w %w))"
                   ($rb $ab $cb $depth $prf $thrm))
    (case $depth
      (;; Depth 0
       (Z (_bc $rb $ab $cb () Z (: $prf $thrm)))
       ;; Depth greater than 0 (consider lambda abstraction)
       ((S $k)
        (if (is-expression $prf)
            ;; Proof is an expression, check whether it is a lambda term
            (if (== () $prf)
                ;; Proof is empty and already fully defined
                (: $prf $thrm)
                ;; Proof is not empty
                (if (is-lambda $prf)
                    ;; Proof is a lambda term
                    (let* (;; Get variables, body, premises and conclusion
                           ($xs (get-lambda-variables $prf))
                           ($as (get-arrow-premises $thrm))
                           ($y (get-lambda-body $prf))
                           ($b (get-arrow-conclusion $thrm))
                           ;; Build environment
                           ($env (zip-with : $xs $as))
                           ;; Call _bc to proof conclusion given environment
                           ((: $y $b) (_bc $rb $ab $cb $env $k (: $y $b)))
                           ;; Reconstruct lambda term
                           ($prf (cons-atom λ (concat-atom $xs ($y))))
                           ;; Reconstruct arrow
                           ($thrm (cons-atom -> (concat-atom $as ($b)))))
                      ;; Output
                      (: $prf $thrm))
                    ;; Not a lambda term, merely call _bc
                    (_bc $rb $ab $cb () (S $k) (: $prf $thrm))))
            ;; Proof is not an expression, merely call _bc
            (_bc $rb $ab $cb () (S $k) (: $prf $thrm))))))))

;; Recursive search.  No support for lambda abstraction, but support
;; for environment, which is a tuple of typing relationships such as
;;
;;   ((: x 𝐁𝐨𝐨𝐥) (: y 𝐁𝐨𝐨𝐥))
;;
;; Also, the proof abstraction is only searched shallowly, at depth 0,
;; because they are no higher order inference rules anyway.
;; NEXT: re-enable when fixed
;; (: _bc (-> $a                            ; Rule base space
;;            $b                            ; Axiom base space
;;            (-> $d $d)                    ; Callback
;;            $c                            ; Environment
;;            Nat                           ; Maximum depth
;;            $d                            ; Query
;;            $d))                          ; Result

;; Base cases

;; Match the axiom base
(= (_bc $rb $ab $cb $env $k (: $x $a))
   (progn
    ;; (logger-tracef "Call (ab): (_bc %w %w %w %w %w (: %w %w))"
    ;;                ($rb $ab $cb $env $k $x $a))
    ($cb (get $ab (: $x $a)))))

;; Match the environment
(= (_bc $rb $ab $cb $env $k (: $x $a))
   (progn
    ;; (logger-tracef "Call (env): (_bc %w %w %w %w %w (: %w %w))"
    ;;                ($rb $ab $cb $env $k $x $a))
    ($cb (get' $env (: $x $a)))))

;; Recursive steps

;; Product.  It is used internally by proof application to iterate
;; over premises.  Due to being only used internally, we do not
;; account for its depth.  The product is associative but is assumed
;; here to only take right associative forms like (, x (, y z)).
;;
;; WARNING: decomposing multi-premise recursion using product makes a
;; more elegant code but it is also significantly, like 10x, slower.
(= (_bc_prod $rb $ab $cb $env $k (: (, $x $y) (, $a $b)))
   (progn
    ;; (logger-tracef "Call (prod): (_bc_prod %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env $k (: (, $x $y) (, $a $b))))
    (let* (;; Recurse on first component
           ((: $x $a) (_bc $rb $ab $cb $env $k (: $x $a)))
           ;; Recurse on second component
           ((: $y $b) (if (is-product $y)
                          (_bc_prod $rb $ab $cb $env $k (: $y $b))
                          (_bc $rb $ab $cb $env $k (: $y $b)))))
      (: (, $x $y) (, $a $b)))))

;; The following functions enumerates proof application patterns by
;; arity.  The duplication up to arity is necessary to obtain search
;; branches from the non-determinism.  Maybe it can be simplified
;; further but this would require to implement a macro that would
;; generate them.

;; Unary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x) $b))
   (progn
    ;; (logger-tracef "Call (app-1): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x) $b)))
    (let* (;; Query unary rule
           ((: $f (-> $a $b)) (get $rb (: $f (-> $a $b))))
           ;; Recurse on premise
           ((: $x $a) (_bc $rb $ab $cb $env $k (: $x $a))))
      ($cb (: ($f $x) $b)))))

;; Binary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2) $b))
   (progn
    ;; (logger-tracef "Call (app-2): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2) $b)))
    (let* (;; Query binary rule
           ((: $f (-> $a1 $a2 $b))
            (get $rb (: $f (-> $a1 $a2 $b))))
           ;; Recurse on premises
           ((: (, $x1 $x2) (, $a1 $a2))
            (_bc_prod $rb $ab $cb $env $k (: (, $x1 $x2) (, $a1 $a2)))))
      ($cb (: ($f $x1 $x2) $b)))))

;; Ternary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3) $b))
   (progn
    ;; (logger-tracef "Call (app-3): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3) $b)))
    (let* (;; Query ternary rule
           ((: $f (-> $a1 $a2 $a3 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 $x3)) (, $a1 (, $a2 $a3)))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 $x3)) (, $a1 (, $a2 $a3))))))
      ($cb (: ($f $x1 $x2 $x3) $b)))))

;; Quaternary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4) $b))
   (progn
    ;; (logger-tracef "Call (app-4): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4) $b)))
    (let* (;; Query quaternary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 $x4)))
               (, $a1 (, $a2 (, $a3 $a4))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 $x4)))
                         (, $a1 (, $a2 (, $a3 $a4)))))))
      ($cb (: ($f $x1 $x2 $x3 $x4) $b)))))

;; Quintenary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5) $b))
   (progn
    ;; (logger-tracef "Call (app-5): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5) $b)))
    (let* (;; Query quintenary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $a5 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 (, $x4 $x5))))
               (, $a1 (, $a2 (, $a3 (, $a4 $a5)))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 (, $x4 $x5))))
                         (, $a1 (, $a2 (, $a3 (, $a4 $a5))))))))
      ($cb (: ($f $x1 $x2 $x3 $x4 $x5) $b)))))

;; Senary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b))
   (progn
    ;; (logger-tracef "Call (app-6): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b)))
    (let* (;; Query senary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 $x6)))))
               (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 $a6))))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 $x6)))))
                         (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 $a6)))))))))
      ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b)))))

;; Septenary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b))
   (progn
    ;; (logger-tracef "Call (app-7): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b)))
    (let* (;; Query septenary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 $x7))))))
               (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 $a7)))))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 $x7))))))
                         (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 $a7))))))))))
      ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b)))))

;; Octonary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b))
   (progn
    ;; (logger-tracef "Call (app-8): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b)))
    (let* (;; Query octonary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 $x8)))))))
               (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 $a8))))))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 $x8)))))))
                         (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 $a8)))))))))))
      ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b)))))

;; Nonary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b))
   (progn
    ;; (logger-tracef "Call (app-9): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b)))
    (let* (;; Query nonary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 $x9))))))))
               (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 $a9)))))))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 $x9))))))))
                         (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 $a9))))))))))))
      ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b)))))

;; Denary proof application
(= (_bc $rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b))
   (progn
    ;; (logger-tracef "Call (app-10): (_bc %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env (S $k) (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b)))
    (let* (;; Query denary rule
           ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))
            (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))))
           ;; Recurse on premises
           ((: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 $x9))))))))
               (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 $a9)))))))))
            (_bc_prod $rb $ab $cb $env $k
                      (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 (, $x9 $x10)))))))))
                         (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 (, $a9 $a10)))))))))))))
      ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Optimized Backward chainer ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Like bc but uses proof size instead of depth.  Maybe "optimized" is
;; a misnomer but it has been observed to be much faster this way.

;; ;; Entry point
;; (: obc (-> $a                            ; Rule base space
;;            $b                            ; Axiom base space
;;            (-> $c $c)                    ; Callback
;;            Number                        ; Maximum proof size
;;            $c                            ; Query
;;            $c))                          ; Result
(= (obc $rb $ab $cb $mps (: $prf $thrm))
   (progn
    (logger-tracef "Call (lambda): (obc %w %w %w %w (: %w %w))"
                   ($rb $ab $cb $mps $prf $thrm))
    (if (< 0 $mps)
        (if (is-expression $prf)
            ;; Proof is an expression, check whether it is a lambda term
            (if (== () $prf)
                ;; Proof is empty and already fully defined
                (: $prf $thrm)
                ;; Proof is not empty
                (if (is-lambda $prf)
                    ;; Proof is a lambda term
                    (let* (;; Get variables, body, premises and conclusion
                           ($xs (get-lambda-variables $prf))
                           ($as (get-arrow-premises $thrm))
                           ($y (get-lambda-body $prf))
                           ($b (get-arrow-conclusion $thrm))
                           ;; Build environment
                           ($env (zip-with : $xs $as))
                           ;; Calculate maximum body size (decount λ
                           ;; and variables)
                           ($mbs (- $mps (+ (length $xs) 1)))
                           ;; Call _obc to proof conclusion given environment
                           ((MkSized $bdysize (: $y $b))
                            (_obc $rb $ab $cb $env $mbs (: $y $b)))
                           ;; Reconstruct lambda term
                           ($prf (cons-atom λ (concat-atom $xs ($y))))
                           ;; Reconstruct arrow
                           ($thrm (cons-atom -> (concat-atom $as ($b)))))
                      ;; Output
                      (: $prf $thrm))
                    ;; Not a lambda term, merely call _obc
                    (Sized.object (_obc $rb $ab $cb () $mps (: $prf $thrm)))))
            ;; Proof is not an expression, merely call _obc
            (Sized.object (_obc $rb $ab $cb () $mps (: $prf $thrm))))
        ;; If maximum proof size is 0, then no proof can possibly be found
        (empty))))

;; Like _bc but uses proof size instead of depth, and outputs a sized
;; (: PROOF THEOREM) result.
;;
;; NEXT: re-enable when fixed
;; (: _obc (-> $a                            ; Rule base space
;;             $b                            ; Axiom base space
;;             (-> $c $c)                    ; Callback
;;             (List $b)                     ; Environment
;;             Number                        ; Maximum proof size
;;             $c                            ; Query
;;             (Sized $c)))                  ; Result

;; Base cases

;; Match the axiom base
(= (_obc $rb $ab $cb $env $mps (: $x $a))
   (if (< 0 $mps)
       (progn
        ;; (logger-tracef "Call (ab): (_obc %w %w %w %w %w (: %w %w))"
        ;;                ($rb $ab $cb $env $mps $x $a))
        (MkSized 1 ($cb (get $ab (: $x $a)))))
       (empty)))

;; Match the environment
(= (_obc $rb $ab $cb $env $mps (: $x $a))
   (if (< 0 $mps)
       (progn
        ;; (logger-tracef "Call (env): (_obc %w %w %w %w %w (: %w %w))"
        ;;                ($rb $ab $cb $env $mps $x $a))
        (MkSized 1 ($cb (get' $env (: $x $a)))))
       (empty)))

;; Recursive steps

;; Product.  It is used internally by proof application to iterate
;; over premises.  Due to being only used internally, we do not
;; account for the size of the product itself `,`.  The product is
;; associative but is assumed here to only take right associative
;; forms like (, x (, y z)).
(= (_obc_prod $rb $ab $cb $env $mps (: (, $x $y) (, $a $b)))
   (progn
    ;; (logger-tracef "Call (prod): (_obc_prod %w %w %w %w %w %w)"
    ;;                ($rb $ab $cb $env $mps (: (, $x $y) (, $a $b))))
    (let* (;; Recurse on first component
           ((MkSized $xps (: $x $a)) (_obc $rb $ab $cb $env $mps (: $x $a)))
           ;; Calculate remaining maximum size
           ($rms (- $mps $xps))
           ;; Recurse on second component
           ((MkSized $yps (: $y $b))
            (if (is-product $y)
                (_obc_prod $rb $ab $cb $env $rms (: $y $b))
                (_obc $rb $ab $cb $env $rms (: $y $b)))))
      ;; Output sized proof (sum up sizes of all subproofs)
      (MkSized (+ $xps $yps) (: (, $x $y) (, $a $b))))))

;; Unary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x) $b))
   (if (< 1 $mps)
       (progn
        ;; (logger-tracef "Call (app-1): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x) $b)))
        (let* (;; Query unary rule
               ((: $f (-> $a $b)) (get $rb (: $f (-> $a $b))))
               ;; Recurse on premise
               ((MkSized $xps (: $x $a))
                (_obc $rb $ab $cb $env (- $mps 1) (: $x $a))))
          ;; Output sized proof (size of proof of premise + rule)
          (MkSized (+ $xps 1) ($cb (: ($f $x) $b)))))
       (empty)))

;; Binary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2) $b))
   (if (< 2 $mps)
       (progn
        ;; (logger-tracef "Call (app-2): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2) $b)))
        (let* (;; Query binary rule
               ((: $f (-> $a1 $a2 $b)) (get $rb (: $f (-> $a1 $a2 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 $x2) (, $a1 $a2)))
                (_obc_prod $rb $ab $cb $env (- $mps 1) (: (, $x1 $x2) (, $a1 $a2)))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2) $b)))))
       (empty)))

;; Ternary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3) $b))
   (if (< 3 $mps)
       (progn
        ;; (logger-tracef "Call (app-3): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3) $b)))
        (let* (;; Query ternary rule
               ((: $f (-> $a1 $a2 $a3 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 $x3)) (, $a1 (, $a2 $a3))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 $x3)) (, $a1 (, $a2 $a3))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3) $b)))))
       (empty)))

;; Quaternary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4) $b))
   (if (< 4 $mps)
       (progn
        ;; (logger-tracef "Call (app-4): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4) $b)))
        (let* (;; Query quaternary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 $x4)))
                                 (, $a1 (, $a2 (, $a3 $a4)))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 $x4)))
                              (, $a1 (, $a2 (, $a3 $a4)))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4) $b)))))
       (empty)))

;; Quintenary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5) $b))
   (if (< 5 $mps)
       (progn
        ;; (logger-tracef "Call (app-5): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5) $b)))
        (let* (;; Query quintenary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $a5 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 (, $x4 $x5))))
                                 (, $a1 (, $a2 (, $a3 (, $a4 $a5))))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 (, $x4 $x5))))
                              (, $a1 (, $a2 (, $a3 (, $a4 $a5))))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4 $x5) $b)))))
       (empty)))

;; Senary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b))
   (if (< 6 $mps)
       (progn
        ;; (logger-tracef "Call (app-6): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b)))
        (let* (;; Query senary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 $x6)))))
                                 (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 $a6)))))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 $x6)))))
                              (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 $a6)))))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6) $b)))))
       (empty)))

;; Septenary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b))
   (if (< 7 $mps)
       (progn
        ;; (logger-tracef "Call (app-7): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b)))
        (let* (;; Query septenary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 $x7))))))
                                 (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 $a7))))))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 $x7))))))
                              (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 $a7))))))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7) $b)))))
       (empty)))

;; Octonary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b))
   (if (< 8 $mps)
       (progn
        ;; (logger-tracef "Call (app-8): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b)))
        (let* (;; Query octonary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 $x8)))))))
                                 (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 $a8)))))))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 $x8)))))))
                              (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 $a8)))))))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8) $b)))))
       (empty)))

;; Nonary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b))
   (if (< 9 $mps)
       (progn
        ;; (logger-tracef "Call (app-9): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b)))
        (let* (;; Query nonary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 $x9))))))))
                                 (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 $a9))))))))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 $x9))))))))
                              (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 $a9))))))))))))
          ;; Output sized proof (size of proof of premises + rule)
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9) $b)))))
       (empty)))

;; Denary proof application
(= (_obc $rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b))
   (if (< 10 $mps)
       (progn
        ;; (logger-tracef "Call (app-10): (_obc %w %w %w %w %w %w)"
        ;;                ($rb $ab $cb $env $mps (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b)))
        (let* (;; Query denary rule
               ((: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))
                (get $rb (: $f (-> $a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8 $a9 $a10 $b))))
               ;; Recurse on premises
               ((MkSized $pps (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 $x9))))))))
                                 (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 $a9))))))))))
                (_obc_prod $rb $ab $cb $env (- $mps 1)
                           (: (, $x1 (, $x2 (, $x3 (, $x4 (, $x5 (, $x6 (, $x7 (, $x8 (, $x9 $x10)))))))))
                              (, $a1 (, $a2 (, $a3 (, $a4 (, $a5 (, $a6 (, $a7 (, $a8 (, $a9 $a10)))))))))))))
          (MkSized (+ $pps 1) ($cb (: ($f $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8 $x9 $x10) $b)))))
       (empty)))

;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;; ;;
;; ;; Tests ;; ;;
;; ;;;;;;;;;;; ;;
;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;
;; Helpers ;;
;;;;;;;;;;;;;

;; In case the input number is something, then return True iff it is
;; equal of the maximum index of the propositional calculus indexed
;; corpus.  If the input number is nothing, then return True as well
;; because it means that a verification has failed and thus the
;; experiment should be aborted.
;; (: equal-to-upidx-or-nothing (-> (Maybe Number) Bool))
(= (equal-to-upidx-or-nothing $idxm)
   (case $idxm
     (((Just $idx) (== (up-to-idx) $idx))
      (Nothing True))))

;; Create a propositional calculus rule base, containing type
;; theoretic representation of rules like
;;
;; (: ax-mp (-> (→ $𝜑 $𝜓) $𝜑 $𝜓))
!(bind! &pc-rb (new-space))

;; Create a propositional calculus axiom base, containing type
;; theoretic representation of axioms like
;;
;; (: ax-1 (→ $𝜑 (→ $𝜓 $𝜑)))
;; (: ax-2 (→ (→ $𝜑 (→ $𝜓 $𝜒)) (→ (→ $𝜑 $𝜓) (→ $𝜑 $𝜒))))
;; (: ax-3 (→ (→ (¬ $𝜑) (¬ $𝜓)) (→ $𝜓 $𝜑)))
!(bind! &pc-ab (new-space))

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hot-Knowledge Bases ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Hot rule base: contains all original axiom rules (permanent) plus
;; the latest lemma rules (evictable sliding window).
!(bind! &pc-hot-rb (new-space))

;; Hot axiom base: contains all original axioms (permanent) plus the
;; latest lemma axioms (evictable sliding window).
!(bind! &pc-hot-ab (new-space))

;; Lemma tracking log for hot-KB eviction.  Each entry has the form
;; (HotLemma INDEX LABEL STMT IS-RULE) so we can look up and remove
;; the oldest lemma when the window slides.
!(bind! &hot-lemma-log (new-space))

;; Monotonically increasing lemma counter stored as (Count N).
!(bind! &lemma-counter (new-space))
!(add-atom &lemma-counter (Count 0))

;; Small rule/axiom bases rebuilt per theorem from the LLM's predicted
;; sub-theory (Tier 1).  Searched after a hot-KB miss, before the full KB.
!(bind! &pc-llm-rb (new-space))
!(bind! &pc-llm-ab (new-space))

;; Retry flags: each tracks an idx queued for an isolated retry of the next
;; tier.  () means none pending.
;;
;; Why these exist: obc can only be called ONCE per evaluation and reliably
;; return a result.  A 2nd/3rd obc call in the SAME evaluation fails
;; unpredictably: at iteration 83 (com23) a 3rd call spuriously found
;; nothing even though the proof exists in the full KB, and at iteration
;; 161 (impi, clean-claude run 2026-07-13) even a 2nd call (hot-KB right
;; after an LLM-bases miss) hard-failed SILENTLY, killing the whole until
;; loop mid-evaluation (the runnable's collapse/findall turns a hard Prolog
;; failure into a quiet empty result).  So EVERY tier now runs in its own
;; `until` iteration: a miss sets the flag for the next tier and returns (),
;; process-assertion-m re-runs the SAME idx, and that retry evaluation makes
;; exactly one obc call.
;;
;; full-retry-idx: hot-KB missed          -> retry same idx, timed full KB.
;; llm-retry-idx:  timed full KB TIMED OUT -> retry same idx, LLM rescue.
;; skip-idx:       LLM rescue also missed  -> SKIP this idx (move to idx+1
;;                 without adding the theorem to the KB).
!(bind! full-retry-idx (new-state ()))
!(bind! llm-retry-idx (new-state ()))
!(bind! skip-idx (new-state ()))

;; Enable occurs check to detect cycles in unification (note that it
;; returns a variable, this is normal)
!(translatePredicate (set_prolog_flag occurs_check True))

;; Load the timed-obc Prolog helper (timed_obc_once/7): runs the full-KB
;; obc under a wall-clock limit; returns (found (: P T)) | not_found |
;; timeout.  The path is built from working_dir, the directory of this
;; .metta file, so it resolves wherever run.sh is invoked from.
!(progn (translatePredicate (working_dir $this-dir))
        (translatePredicate (atomic_list_concat ($this-dir "/pc_xp_timed.pl") $timed-pl))
        (translatePredicate (consult $timed-pl)))
;; Register it as a callable so the translator emits a direct Prolog call
;; (must precede the (= (_rediscover-proofs-timed ...)) definition below).
!(translatePredicate (register_fun timed_obc_once))

;; Add assertion to knowledge bases.  If it is an axiom then add it to
;; pc-ab.  If it is a rule then add it to pc-rb.  Additionally replace
;; greek letters by variables.
(= (add-to-kbs $label $stmt)
   (let $stmt-with-vars (replace-greeks-by-variables $stmt)
     (progn
      ;; Mirror the label+type into the LLM bridge so it can build prompts.
      (if (use-llm-theory)
          (py-call (builtins._registerLabel (repr $label) (repr $stmt)))
          ())
      ;; Add to rule base or axiom base
      (if (is-arrow $stmt)
          (add-atom &pc-rb (: $label $stmt-with-vars))
          (add-atom &pc-ab (: $label $stmt-with-vars))))))

;; Add proof and theorem to label mapping to labels space
(= (add-to-labels $proof $theorem $label)
   (progn
    ;; (logger-tracef "Call: (add-to-labels %w %w %w)" ($proof $theorem $label))
    (let $theorem-with-vars (replace-greeks-by-variables $theorem)
      (add-atom &labels (Label $proof $theorem-with-vars $label)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hot-Knowledge Base Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Return current lemma counter value
(= (get-lemma-count) (match &lemma-counter (Count $n) $n))

;; Increment lemma counter and return the new value
(= (inc-lemma-count)
   (let $old (get-lemma-count)
     (let $new (+ $old 1)
       (progn
        (remove-atom &lemma-counter (Count $old))
        (add-atom &lemma-counter (Count $new))
        $new))))

;; Evict the oldest lemma from the hot-KB if we exceed the window size.
;; The lemma at index ($current - hot-kb-size) is removed from the
;; appropriate hot space and from the tracking log.
;; IMPORTANT: must never return (empty) as that kills progn chains.
(= (evict-oldest-hot-lemma $current-idx)
   (let $evict-idx (- $current-idx (hot-kb-size))
     (if (> $evict-idx 0)
         (case (once (match &hot-lemma-log
                            (HotLemma $evict-idx $elabel $estmt $eis-rule)
                            ($elabel $estmt $eis-rule)))
           ((($elabel $estmt $eis-rule)
             (progn
              (if $eis-rule
                  (remove-atom &pc-hot-rb (: $elabel $estmt))
                  (remove-atom &pc-hot-ab (: $elabel $estmt)))
              (remove-atom &hot-lemma-log
                           (HotLemma $evict-idx $elabel $estmt $eis-rule))))
            ($else ())))
         ())))

;; Add an axiom permanently to the hot-KB (axioms are never evicted).
(= (add-axiom-to-hot-kbs $label $stmt)
   (let $stmt-with-vars (replace-greeks-by-variables $stmt)
     (if (is-arrow $stmt)
         (add-atom &pc-hot-rb (: $label $stmt-with-vars))
         (add-atom &pc-hot-ab (: $label $stmt-with-vars)))))

;; Add a proved lemma to the hot-KB with sliding-window eviction.
;; Each lemma is assigned a monotonically increasing index.  When the
;; window exceeds hot-kb-size the oldest lemma is evicted.
(= (add-lemma-to-hot-kbs $label $stmt)
   (let* (($stmt-with-vars (replace-greeks-by-variables $stmt))
          ($is-rule (is-arrow $stmt))
          ($idx (inc-lemma-count)))
     (progn
      ;; Add to hot-KB space
      (if $is-rule
          (add-atom &pc-hot-rb (: $label $stmt-with-vars))
          (add-atom &pc-hot-ab (: $label $stmt-with-vars)))
      ;; Log for future eviction
      (add-atom &hot-lemma-log
                (HotLemma $idx $label $stmt-with-vars $is-rule))
      ;; Evict oldest if over limit
      (evict-oldest-hot-lemma $idx))))

;; Process the axiom of given index, that is insert the axiom into
;; pc-ab and return the next index.
;; NEXT: re-enable when fixed
;; (: process-axiom (-> Number Assertion (Maybe Number)))
(= (process-axiom $idx (MkAxiom $label $axiom))
   (progn
    (logger-infof "Iteration %w: add axiom %w" ($idx $label))
    (add-to-kbs $label $axiom)
    (if (use-hot-kb) (add-axiom-to-hot-kbs $label $axiom) ())
    (Maybe.return (+ $idx 1))))

;; Process the theorem of a given index by checking its proof, if it
;; succeeds then insert it alongside its proof into the propositional
;; knowledge bases and return the next idx, or Nothing if it fails.
;; NEXT: re-enable when fixed (: process-theorem-check (-> Number
;; Number Assertion (Maybe Number)))
;; Helper: attempt to check a proof against a given rule and axiom base.
(= (_check-proof $rb $ab $bound $proof $thrm)
   (let (: $proof $thrm)
     (if (bound-search-by-proof-size)
         (obc $rb $ab callback $bound (: $proof $thrm))
         (bc $rb $ab callback (fromNumber $bound) (: $proof $thrm)))
     (: $proof $thrm)))
;;
(= (process-theorem-check $idx $bound (MkTheorem $label $proof $thrm))
   (progn
    (if (bound-search-by-proof-size)
        (logger-infof "Iteration %w: verify proof of %w up to size %w"
                      ($idx $label $bound))
        (logger-infof "Iteration %w: verify proof of %w up to depth %w"
                      ($idx $label $bound)))
    (let $result
        (if (use-hot-kb)
            ;; Try hot-KB first, fall back to full KB
            (case (_check-proof &pc-hot-rb &pc-hot-ab $bound $proof $thrm)
              (((: $p $t) (: $p $t))
               (Empty (_check-proof &pc-rb &pc-ab $bound $proof $thrm))))
            ;; Hot-KB disabled, use full KB directly
            (_check-proof &pc-rb &pc-ab $bound $proof $thrm))
      (case $result
        (;; Verified
         ((: $proof $thrm)
          (progn (add-to-kbs $label $thrm)
                 (if (use-hot-kb) (add-lemma-to-hot-kbs $label $thrm) ())
                 (Maybe.return (+ $idx 1))))
         ;; Not verified
         (Empty Nothing))))))

;; Rediscover proof(s) of a theorem.  The results are returned as an
;; expression, a tuple of solutions, instead of a superposition to
;; avoid nondeterminism.
;;
;; Helper: run the backward chainer on a given rule and axiom base.
(= (_rediscover-proofs $rb $ab $bound $proof-wo-bdy $thrm)
   (collapse
    (if (bound-search-by-proof-size)
        (if (search-all-proofs)
            (obc $rb $ab callback $bound (: $proof-wo-bdy $thrm))
            (once (obc $rb $ab callback $bound (: $proof-wo-bdy $thrm))))
        (let $pdepth (fromNumber $depth)
          (if (search-all-proofs)
              (bc $rb $ab callback $pdepth (: $proof-wo-bdy $thrm))
              (once (bc $rb $ab callback $pdepth (: $proof-wo-bdy $thrm))))))))
;;
;; ---- LLM sub-theory helpers (Tier 1) ----

;; Remove every atom from a space.
(= (clear-space $spc)
   (let $atoms (collapse (get-atoms $spc))
     (collapse (let $a (superpose $atoms) (remove-atom $spc $a)))))

;; Whether to invoke the LLM predictor for this idx: enabled AND this idx
;; has a queued LLM rescue (i.e. its timed full-KB search just timed out).
(= (use-llm-theory-now $idx)
   (and (use-llm-theory) (== (get-state llm-retry-idx) $idx)))

;; Build the small LLM bases for a goal: clear them, ask the bridge to
;; predict + cache a relevant label set, then copy every predicted label's
;; entry from the full KB into the small bases.  The Python side always
;; includes the core axioms, so the small bases are never empty.
(= (build-llm-theory $idx $label $thrm $bound)
   (progn
    (clear-space &pc-llm-rb)
    (clear-space &pc-llm-ab)
    ;; predict + cache (returns the number of predicted labels).  Pass the
    ;; proof size $bound as a budget: the count of directly-applied labels
    ;; in a proof is bounded by its term size, so the LLM is told to name
    ;; up to $bound labels instead of chronically under-predicting.  The
    ;; label is passed so the per-call reasoning log (pc-xp-llm-reasoning.log,
    ;; written by the bridge) names the theorem each entry belongs to.
    (py-call (builtins._predictTheory (repr $thrm) (llm-model) (llm-timeout) $bound (repr $label)))
    ;; copy predicted rules
    (collapse (match &pc-rb (: $l $t)
                (if (== (py-call (builtins._inPredicted (repr $l))) 1)
                    (add-atom &pc-llm-rb (: $l $t))
                    ())))
    ;; copy predicted axioms
    (collapse (match &pc-ab (: $l $t)
                (if (== (py-call (builtins._inPredicted (repr $l))) 1)
                    (add-atom &pc-llm-ab (: $l $t))
                    ())))
    ;; Commit: cut away any choice points left open by the py-call chain
    ;; above.  Without this, a later failure in the proof search can
    ;; backtrack into this predict-and-filter sequence and replay it.
    (cut)
    (let $smallest (concat-atom (collapse (match &pc-llm-rb (: $l $t) $l))
                                (collapse (match &pc-llm-ab (: $l $t) $l)))
      (logger-infof "Iteration %w: passing LLM sub-theory for %w to obc: %w"
                    ($idx $label $smallest)))))

;; Search the hot-KB under its own wall-clock budget (hot-timeout-seconds);
;; on a miss OR a timeout (or if the hot-KB is disabled) queue the isolated
;; full-KB retry (full-retry-idx) and return () so the until loop re-runs
;; this same idx with the full KB as the ONLY obc call of that evaluation.
;; The hot budget exists because at large proof sizes even the 30-lemma hot
;; space explodes (pm2.61iii at size 13 ground 43+ min here, 2026-07-19).
(= (hot-or-queue-full $idx $bound $proof-wo-bdy $thrm)
   (if (use-hot-kb)
       (let $hot-result
           (timed_obc_once &pc-hot-rb &pc-hot-ab callback $bound
                           (: $proof-wo-bdy $thrm)
                           (hot-timeout-seconds))
         (case $hot-result
           ((timeout
             (progn
              (logger-infof "Hot-KB search timed out after %ws; falling back to full KB"
                            ((hot-timeout-seconds)))
              (change-state! full-retry-idx $idx)
              ()))
            (not_found
             (progn
              (logger-info "Hot-KB: no proof found")
              (change-state! full-retry-idx $idx)
              ()))
            ((found (: $p $t)) (list (: $p $t))))))
       (progn
        (change-state! full-retry-idx $idx)
        ())))

;; Timed full-KB tier: run obc over the full KB under the wall-clock budget
;; (obc-timeout-seconds), via the Prolog helper timed_obc_once/7.
;;   * found     -> singleton proof list (done)
;;   * not_found -> () with no flag queued = genuine failure (loop stops)
;;   * timeout   -> queue the LLM rescue (or, if the LLM is disabled, queue
;;                  a skip) and return ()
;; Only valid on the obc path (bound-search-by-proof-size = True).
(= (_rediscover-proofs-timed $idx $bound $proof-wo-bdy $thrm)
   (let $timed-result
       (timed_obc_once &pc-rb &pc-ab callback $bound
                       (: $proof-wo-bdy $thrm)
                       (obc-timeout-seconds))
     (case $timed-result
       ((timeout
         (progn
          (logger-infof "Full-KB search timed out after %ws; queuing LLM rescue"
                        ((obc-timeout-seconds)))
          (if (use-llm-theory)
              (change-state! llm-retry-idx $idx)
              (change-state! skip-idx $idx))
          ()))
        ;; Search space exhausted within the budget: with skipped lemmas
        ;; accumulating, this usually means the proof NEEDS a lemma we
        ;; skipped earlier.  Skip this theorem too and keep going (the run
        ;; should only end at the corpus end).
        (not_found
         (progn
          (logger-info "Full-KB search exhausted (no proof at this size); skipping theorem")
          (change-state! skip-idx $idx)
          ()))
        ((found (: $p $t)) (list (: $p $t)))))))

;; Entry point.  Timeout-rescue cascade, EXACTLY ONE obc call per
;; evaluation -- every tier miss queues the next tier as a same-idx retry
;; in a fresh until iteration (see the retry-flag comments above):
;;
;;   eval 1 -- hot-KB; miss queues full-retry-idx.
;;   eval 2 -- full KB, wall-clock-capped; timeout queues llm-retry-idx;
;;             an exhausted search (not_found) queues a skip directly.
;;   eval 3 -- LLM-predicted sub-theory; miss queues skip-idx, and
;;             process-assertion-m moves on to the NEXT theorem.
(= (rediscover-proofs $idx $label $bound $proof $thrm)
   (let ;; Replace proof body by variable
       $proof-wo-bdy (replace-body-by-variable $proof)
     (if (use-llm-theory-now $idx)
         ;; --- LLM rescue evaluation (after a full-KB timeout) ---
         (progn
          (change-state! llm-retry-idx ())
          (build-llm-theory $idx $label $thrm $bound)
          (let $llm-result
              (_rediscover-proofs &pc-llm-rb &pc-llm-ab $bound $proof-wo-bdy $thrm)
            (if (== $llm-result ())
                (progn
                 (logger-info "LLM-theory: no proof in predicted sub-theory; skipping theorem")
                 (change-state! skip-idx $idx)
                 ())
                (progn
                 (logger-info "LLM-theory: proof found in predicted sub-theory")
                 $llm-result))))
         (if (== (get-state full-retry-idx) $idx)
             ;; --- Timed full-KB evaluation (after a hot-KB miss) ---
             (progn
              (change-state! full-retry-idx ())
              (logger-info "Retry: searching full KB (timed)")
              (_rediscover-proofs-timed $idx $bound $proof-wo-bdy $thrm))
             ;; --- First evaluation: hot-KB; miss queues the full-KB retry ---
             (hot-or-queue-full $idx $bound $proof-wo-bdy $thrm)))))

;; Process the theorem of a given index by rediscovering its proof, if
;; it succeeds then insert its alongside its proof(s) into the
;; propositional calculus knowledge bases and return the next idx, or
;; Nothing if it fails.
;;
;; NEXT: re-enable when fixed
;; (: process-theorem-search (-> Number Number Assertion (Maybe Number)))
(= (process-theorem-search $idx $bound (MkTheorem $label $proof $thrm))
   (progn
    (if (bound-search-by-proof-size)
        (logger-infof "Iteration %w: search proof of %w up to size %w"
                      ($idx $label $bound))
        (logger-infof "Iteration %w: search proof of %w up to depth %w"
                      ($idx $label $bound)))
    (let $prfs-thrms (rediscover-proofs $idx $label $bound $proof $thrm)
      (if (== $prfs-thrms ())
          ;; No proof this evaluation.  Distinguish the queued follow-ups
          ;; (full-KB retry / LLM rescue / skip) from a genuine miss, so
          ;; the log does not claim defeat prematurely.
          (progn
           (if (== (get-state full-retry-idx) $idx)
               (logger-info "Full-KB retry queued")
               (if (== (get-state llm-retry-idx) $idx)
                   (logger-info "LLM rescue queued (full-KB timeout)")
                   (if (== (get-state skip-idx) $idx)
                       (logger-infof "SKIPPING theorem %w (timeout + LLM miss); it will NOT be in the KB" ($label))
                       (logger-info "No proof found"))))
           Nothing)
          ;; One or more proofs
          (progn
           ;; For each proof add mapping from proof to label
           (collapse
            (let (: $p $t) (superpose $prfs-thrms)
                 (progn
                  (logger-infof "Found proof%w %w" (: $p))
                  (add-to-labels $p $t $label))))
           ;; Add proved theorem as lemma in kbs
           (add-to-kbs $label $thrm)
           ;; Also add to hot-KB for speedy future searches
           (if (use-hot-kb) (add-lemma-to-hot-kbs $label $thrm) ())
           ;; Output next index
           (Just (+ $idx 1)))))))

;; Process the theorem of a given index, that is either check or
;; rediscover its proof, if it succeeds then insert it alongside its
;; proof into the propositional calculus knowledge bases and return
;; the next idx, or Nothing if it fails.
;; NEXT: re-enable when fixed
;; (: process-theorem (-> Number Assertion (Maybe Number)))
(= (process-theorem $idx (MkTheorem $label $proof $thrm))
   (let $bound (if (bound-search-by-proof-size)
                   (term-size $proof)   ; Calculate proof size
                   (term-depth $proof)) ; Calculate proof depth
     (if (search-proof)
         (process-theorem-search $idx
                                 $bound
                                 (MkTheorem $label $proof $thrm))
         (process-theorem-check $idx
                                $bound
                                (MkTheorem $label $proof $thrm)))))

;; Process the assertion corresponding to the given index and return
;; the index of the next assertion to process.  Meaning, if the
;; assertion is an axiom, insert the axiom in the knowledge base, and
;; if the assertion is a theorem, verify or proof the theorem and then
;; insert it in the knowledge base as if it were an axiom.  If it
;; fails to verify or proof then return Nothing instead of the next
;; index.
;; (: process-assertion (-> Number (Maybe Number)))
(= (process-assertion $idx)
   (progn
    (logger-tracef "Call: (process-assertion %w)" ($idx))
    (case (match &pc-idxd (MkIndexed $idx $asrt) $asrt)
      (((MkAxiom $label $axiom) (process-axiom $idx $asrt))
       ((MkTheorem $label $proof $thrm) (process-theorem $idx $asrt))
       ($else Nothing)))))

;; Like process-assertion but wrapped to accept maybe a number, which the
;; until construct needs, and to drive the tier chain:
;;
;;   * full-retry-idx == idx -> re-run same idx (timed full-KB search).
;;   * llm-retry-idx  == idx -> re-run same idx (LLM rescue).
;;   * skip-idx       == idx -> clear the flag and return (Just idx+1):
;;     the theorem is SKIPPED (not in the KB) and the run moves on.
;;   * no flag -> genuine failure; the until loop stops.
;;
;; A retry evaluation clears its own flag on entry, so at most one flag is
;; set at any time.
;; (: process-assertion-m (-> (Maybe Number) (Maybe Number)))
(= (process-assertion-m $midx)
   (case $midx
     (((Just $idx)
       (let $result (process-assertion $idx)
         (case $result
           (((Just $n) (Just $n))
            (Nothing
             (if (== (get-state full-retry-idx) $idx)
                 ;; hot-KB missed -> re-run same idx, timed full KB
                 (Just $idx)
                 (if (== (get-state llm-retry-idx) $idx)
                     ;; full-KB timed out -> re-run same idx, LLM rescue
                     (Just $idx)
                     (if (== (get-state skip-idx) $idx)
                         ;; LLM rescue missed -> skip; continue with NEXT idx
                         (progn
                          (change-state! skip-idx ())
                          (Just (+ $idx 1)))
                         ;; genuine failure
                         Nothing))))))))
      (Nothing Nothing))))

;;;;;;;;;;;;;;;;;;;;;;;
;; Process PC Corpus ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Loop over all assertions of the corpus
!(until equal-to-upidx-or-nothing process-assertion-m (Just 2))

;; Log the content of pc-rb and pc-ab
!(logger-debugf "pc-rb: %w" ((get-atoms &pc-rb)))
!(logger-debugf "pc-ab: %w" ((get-atoms &pc-ab)))

;; Log the content of hot-KBs
!(when (use-hot-kb)
       (progn
        (logger-debugf "pc-hot-rb: %w" ((get-atoms &pc-hot-rb)))
        (logger-debugf "pc-hot-ab: %w" ((get-atoms &pc-hot-ab)))))
!(if (use-hot-kb) (logger-infof "Hot-KB lemma count: %w, window size: %w"
                                ((get-lemma-count) (hot-kb-size))) ())

;; Log LLM-theory content (last predicted sub-theory) and config
!(when (use-llm-theory)
       (progn
        (logger-debugf "pc-llm-rb: %w" ((get-atoms &pc-llm-rb)))
        (logger-debugf "pc-llm-ab: %w" ((get-atoms &pc-llm-ab)))))
!(if (use-llm-theory)
     (logger-infof "Tiers: hot-KB(size %w) -> full-KB(timed %ws) -> LLM(model %w) -> skip"
                   ((hot-kb-size) (obc-timeout-seconds) (llm-model))) ())
