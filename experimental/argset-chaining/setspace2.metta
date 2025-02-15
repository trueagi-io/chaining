!(import! &self utils)
;; A pure MeTTa implementation of lookup_all_subsets for a trie-based set space.
;;
;; A trie node is represented as an expression: (trie <value> <children>)
;; where <value> is an optional atom (use () when there is no value),
;; and <children> is a expression of pairs.
;; Each pair is represented as: (child <key> <child>), where <key> is a symbol and <child> is a trie node.

;; Create a new setspace. With no arguments, returns an empty setspace.
(= (create-setspace)
 (trie () (new-state (new-space))))

  (= (removeUnify $space $atom)
   (let $nspace (new-space)
    (let $selems (collapse (get-atoms (get-state $space)))
     (let $res (foldl-atom $selems () $accum $selem (let $_ $accum (unify $atom $selem () (add-atom $nspace $selem))))
      (change-state! $space $nspace)))))

(= (add-atom2 $space $atoms)
   (add-atom (get-state $space) $atoms))

;; Insert function: insert-setspace
(= (insert-setspace (trie $old_val $children) $keys $new_val)
 (if-decons-expr $keys $key $rest
  (let $insert (insert-child $children $key $rest $new_val) (trie $old_val $children))
  (trie (cons-atom $new_val $old_val) $children)))

(= (insert-child $children $key $rest $new_val)
(case (sealed $key (let $s (get-state $children) (collapse (unify $s (child $key $child) (child $key $child) Empty))))
 ( (Empty (insert-new-child $children $key $rest $new_val))
   ($matches (insert-possible-match $children $matches $key $rest $new_val))
 )))

(= (insert-possible-match $children $matches $key $rest $new_val)
   (if-decons-expr $matches $match $rest_matches
      (let (child $rkey $child) $match
         (if (=alpha $key $rkey)
            (let $new_child (child $key (insert-setspace $child $rest $new_val))
               (let $rm (removeUnify $children (child $key $child))
                  (add-atom2 $children $new_child)))
            (insert-possible-match $children $rest_matches $key $rest $new_val)))
      (insert-new-child $children $key $rest $new_val)))

(= (insert-new-child $children $key $rest $new_val)
   (let $child (insert-setspace (create-setspace) $rest $new_val)
     (add-atom2 $children (child $key $child))
     ))

(= (sstostring (trie $value $children))
  (trie $value (collapse (let $s (get-state $children) (unify $s (child $key $child) (child $key (sstostring $child)) ())))))

;; Main function: lookup_all_subsets
(= (lookup-all-subsets (trie $value $children) $query)
 (let $recurse (lookup-all-subsets-children $children $query)
  (union-atom $value $recurse)))

;; Traverse the children list of a trie node.
(= (lookup-all-subsets-children $children $query)
 (if-decons-expr $query $key $rest
  (let $a (lookup-all-subsets-children $children $rest)
    (let $b (let $s (get-state $children) (tracem (U $s $key) (collapse (unify $s (child $key $child) (lookup-all-subsets $child $rest) ()))))
      (union-atom $a $b)))
  ()))

;!(time (let* ( ($s1 (create-setspace))
;         ($s2 (insert-setspace $s1 ((: $a1 A)) (: $a1 A1)))
;         ($s3 (insert-setspace $s2 ((: $a2 A)) (: $a2 A2)))
;         ($s4 (insert-setspace $s3 ((: $t $T)) (: $t T)))
;         ($r (lookup-all-subsets $s4 ((: a A))))
;       )
;   ((sstostring $s4) $r)))

