!(import &self utils)
;; A pure MeTTa implementation of lookup_all_subsets for a trie-based set space.
;;
;; A trie node is represented as an expression: (trie <value> <children>)
;; where <value> is an optional atom (use () when there is no value),
;; and <children> is a expression of pairs.
;; Each pair is represented as: (<key> <child>), where <key> is a symbol and <child> is a trie node.

;; Create a new setspace. With no arguments, returns an empty setspace.
(: create-setspace (-> Expression))
(= ((create-setspace) ())
   (trie () ()))
;; Alternatively, create a setspace with given children.
(= ((create-setspace) ($children))
   (trie () $children))

;; Insert function: insert-setspace
(: insert-setspace (-> Expression Expression Expression Expression))
(= (insert-setspace (trie $old_val $children) () $new_val)
   (trie $new_val $children))
(= (insert-setspace (trie $old_val $children) (cons $key $rest) $new_val)
   (trie $old_val (insert-child $children $key $rest $new_val)))

(: insert-child (-> Expression Expression Expression Expression Expression))
(= (insert-child () $key $rest $new_val)
   (cons (list $key (insert-setspace ((create-setspace)) $rest $new_val)) ()))
(= (insert-child (cons (list $k $child) $rest_children) $key $rest $new_val)
   (if (== $k $key)
       (cons (list $k (insert-setspace $child $rest $new_val)) $rest_children)
       (cons (list $k $child) (insert-child $rest_children $key $rest $new_val))))

;; Main function: lookup_all_subsets
(: lookup-all-subsets (-> Expression Expression Expression))
(= (lookup-all-subsets $trie $query)
   (lookup-all-subsets-traverse $trie $query))

;; Traverse a trie node and collect values from nodes whose keys appear in the query.
(: lookup-all-subsets-traverse (-> Expression Expression Expression))
(= (lookup-all-subsets-traverse $node $query)
   (unify $node (trie $value $children)
          (union-atom (if (== $value ())
                          ()
                          (list $value))
                      (lookup-all-subsets-children $children $query))
          (error "lookup-all-subsets-traverse: pattern failed")))

;; Traverse the children list of a trie node.
(: lookup-all-subsets-children (-> Expression Expression Expression))
(= (lookup-all-subsets-children $children $query)
   (if (== $children ())
       ()
       (unify $children (cons $pair $rest)
              (unify $pair (list $key $child)
                     (if (elem $key $query)
                         (append (lookup-all-subsets-traverse $child $query)
                                 (lookup-all-subsets-children $rest $query))
                         (lookup-all-subsets-children $rest $query))
                     (error "lookup-all-subsets-children: inner pair pattern failed"))
              (error "lookup-all-subsets-children: children pattern failed"))))
