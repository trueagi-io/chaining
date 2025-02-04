from typing import Dict, List, Set, Tuple, Optional, Any
from collections import defaultdict
from sortedcontainers import SortedSet

class TrieNode:
    def __init__(self, value: Optional[str] = None):
        self.value = value
        self.children: Dict[str, 'TrieNode'] = {}

class SetSpace:
    def __init__(self):
        self.root = TrieNode()
    
    def add(self, elements: Set[str], value: str):
        """Add a set and its associated value to the trie"""
        # Sort elements to ensure consistent insertion order
        sorted_elements = sorted(elements)
        
        current = self.root
        # Add intermediate nodes
        for elem in sorted_elements:
            if elem not in current.children:
                current.children[elem] = TrieNode()
            current = current.children[elem]

        current.value = value
    
    def _find_best_match(self, node: TrieNode, elements: SortedSet, current_path: Set[str]) -> Optional[Tuple[Set[str], str]]:
        """Find the best matching set starting from the current node"""
        if not elements:
            return None

        current_elem = elements[0]  # SortedSet supports indexing
        
        # Try to follow the path for the current element
        if current_elem in node.children:
            child = node.children[current_elem]
            new_path = current_path | {current_elem}
            
            # If this node has a value, it's a potential match
            result = None
            if child.value is not None:
                result = (new_path, child.value)
            
            # Try to find a longer match
            # Create a new SortedSet without the first element
            remaining = SortedSet(elements[1:])
            deeper_match = self._find_best_match(child, remaining, new_path)
            if deeper_match is not None:
                result = deeper_match
                
            return result
            
        return None
    
    def lookup(self, query: Set[str]) -> List[Tuple[frozenset, str]]:
        """
        Find minimal sets that together cover all elements in the query.
        Returns list of (set, value) pairs.
        """
        if not query:
            return []
        
        elements = SortedSet(query)
        result = []
        
        while elements:
            match = self._find_best_match(self.root, elements, set())
            
            if not match:
                break
                
            match_set, match_value = match
            result.append((frozenset(match_set), match_value))
            elements.difference_update(match_set)
            
        return result

def test_setspace():
    # Create test space
    space = SetSpace()
    
    # Add test sets
    space.add({'a', 'b'}, "ab_value")
    space.add({'a'}, "a_value")
    space.add({'b'}, "b_value")
    space.add({'x'}, "x_value")
    space.add({'a', 'b', 'c'}, "abc_value")
    
    # Test cases
    test_queries = [
        {'a', 'b'},      # Should find ab_value
        {'a'},           # Should find a_value
        {'a', 'b', 'c'}, # Should find abc_value
        {'x'},           # Should find x_value
        set(),           # Empty set
        {'y'},           # Non-existent element
        {'a', 'x'},      # Should find a_value and x_value
        {'a', 'b', 'x'}, # Should find ab_value and x_value
    ]
    
    for query in test_queries:
        print("\nQuery:", query)
        result = space.lookup(query)
        print("Result:")
        if result:
            for s, v in result:
                print(f"Set: {s}, Value: {v}")
        else:
            print("No matching sets found")

if __name__ == "__main__":
    test_setspace()
