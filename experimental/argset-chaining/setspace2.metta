!(import! &self utils)
;; A pure MeTTa implementation of lookup_all_subsets for a trie-based set space.
;;
;; A trie node is represented as an expression: (trie <value> <children>)
;; where <value> is an optional atom (use () when there is no value),
;; and <children> is a expression of pairs.
;; Each pair is represented as: (child <key> <child>), where <key> is a symbol and <child> is a trie node.

;; Create a new setspace. With no arguments, returns an empty setspace.
(= (create-setspace)
 (trie () (new-space)))

;; Insert function: insert-setspace
(= (insert-setspace (trie $old_val $children) $keys $new_val)
 (if-decons-expr $keys $key $rest
  (let $sideeffect (insert-child $children $key $rest $new_val) (trie $old_val $children))
  (trie (cons-atom $new_val $old_val) $children)))

(= (insert-child $children $key $rest $new_val)
 (let (child $rkey $child) (sealed $key (unify $children (child $key $child) (child $key $child) (child $key (create-setspace))))
  (if (=alpha $key $rkey)
   (let $new_child (child $key (insert-setspace $child $rest $new_val))
    (let $rm (remove-atom $children (child $key $child))
     (add-atom $children $new_child)))
   (add-atom $children (child $key (insert-setspace (create-setspace) $rest $new_val))))))


;; Main function: lookup_all_subsets
(= (lookup-all-subsets (trie $value $children) $query)
   (if-decons-expr $query $key $rest
      (let $recurse (lookup-all-subsets-children $children $key $rest)
        (union-atom $value $recurse))
      $value))

;; Traverse the children list of a trie node.
(= (lookup-all-subsets-children $children $key $rest)
  (unify $children (child $key $child)
    (lookup-all-subsets $child $res)
    (lookup-all-subsets-children $children $res)))

!(let* ( ($s1 (create-setspace))
         ($s2 (insert-setspace $s1 (a) A))
         ($s3 (insert-setspace $s2 (b) B))
         ;($s4 (insert-setspace $s3 (b c) BC))
         ($r (lookup-all-subsets $s2 (a b)))
       )
   $r)

