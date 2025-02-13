!(import! &self utils)
;; A pure MeTTa implementation of lookup_all_subsets for a trie-based set space.
;;
;; A trie node is represented as an expression: (trie <value> <children>)
;; where <value> is an optional atom (use () when there is no value),
;; and <children> is a expression of pairs.
;; Each pair is represented as: (child <key> <child>), where <key> is a symbol and <child> is a trie node.

;; Create a new setspace. With no arguments, returns an empty setspace.
(= (create-setspace)
   (trie () ()))
;; Alternatively, create a setspace with given children.
(= ((create-setspace) $children)
   (trie () $children))

;; Insert function: insert-setspace
(= (insert-setspace (trie $old_val $children) $keys $new_val)
   (if-decons-expr $keys $key $rest
      (trie $old_val (insert-child $children $key $rest $new_val))
      (trie (cons-atom $new_val $old_val) $children)))

(= (insert-child $children $key $rest $new_val)
   (if-decons-expr $children $old_child $rest_children
      (let (child $k $child) (trace! $old_child $old_child)
      (if (== $k $key)
        (let $new_child (child $k (insert-setspace $child $rest $new_val)) (cons-atom $new_child $rest_children))
        (let $new_tail (insert-child $rest_children $key $rest $new_val) (cons-atom $old_child $new_tail))))
   ((child $key (insert-setspace (create-setspace) $rest $new_val)))))


;; Main function: lookup_all_subsets
(= (lookup-all-subsets (trie $value $children) $query)
   (let $recurse (lookup-all-subsets-children $children $query)
   (union-atom $value $recurse)))

;; Traverse the children list of a trie node.
(= (lookup-all-subsets-children $children $query)
   (if-decons-expr $children $child_expr $rest_children
      (let (child $key $child) $child_expr
         (if (elemB $key $query)
             (let $a (lookup-all-subsets $child $query)
             (let $b (lookup-all-subsets-children $rest_children $query)
               (union-atom $a $b)))
             (lookup-all-subsets-children $rest_children $query)))
      ()))

!(elemB a (a))

!(let* ( ($s1 (create-setspace))
         ($s2 (insert-setspace $s1 (a) A))
         ($s3 (insert-setspace $s2 (b) B))
         ($s4 (insert-setspace $s3 (b c) BC))
         ($r (lookup-all-subsets $s4 (b c)))
       )
   $r)

