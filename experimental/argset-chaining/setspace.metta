;; A pure MeTTa implementation of lookup_all_subsets for a trie-based set space.
;;
;; A trie node is represented as an expression: (trie <value> <children>)
;; where <value> is an optional atom (use () when there is no value),
;; and <children> is a list of pairs.
;; Each pair is represented as: (list <key> <child>), where <key> is a symbol and <child> is a trie node.

;; Helper function: member?
(: member? (-> $a Expression Bool))
(= (member? $a $lst)
   (if (== $lst ())
       false
       (if (== $a (car-atom $lst))
           true
           (member? $a (cdr-atom $lst)))))

;; Helper function: append two lists
(: append (-> Expression Expression Expression))
(= (append $lst1 $lst2)
   (if (== $lst1 ())
       $lst2
       (cons (car-atom $lst1) (append (cdr-atom $lst1) $lst2))))

;; Main function: lookup_all_subsets
(: lookup-all-subsets (-> Expression Expression Expression))
(= (lookup-all-subsets $trie $query)
   (lookup-all-subsets-traverse $trie $query))

;; Traverse a trie node and collect values from nodes whose keys appear in the query.
(: lookup-all-subsets-traverse (-> Expression Expression Expression))
(= (lookup-all-subsets-traverse $node $query)
   (match $node
     ((trie $value $children)
       (append (if (== $value ())
                   ()
                   (list $value))
               (lookup-all-subsets-children $children $query)))))

;; Traverse the children list of a trie node.
(: lookup-all-subsets-children (-> Expression Expression Expression))
(= (lookup-all-subsets-children $children $query)
   (if (== $children ())
       ()
       (match $children
         ((cons $pair $rest)
           (match $pair
             ((list $key $child)
               (if (member? $key $query)
                   (append (lookup-all-subsets-traverse $child $query)
                           (lookup-all-subsets-children $rest $query))
                   (lookup-all-subsets-children $rest $query))))))))
