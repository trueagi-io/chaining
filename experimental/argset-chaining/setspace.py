from typing import Dict, List, Set, Tuple, Optional, Any
from collections import defaultdict
from sortedcontainers import SortedSet, SortedDict

class TrieNode:
    def __init__(self, value: Optional[str] = None):
        self.value = value
        self.children: SortedDict[str, 'TrieNode'] = SortedDict()

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
        if not elements or not node.children:
            return None

        # Get the first available child that matches any remaining element
        for elem in elements:
            if elem in node.children:
                child = node.children[elem]
                new_path = current_path | {elem}
                
                # If this node has a value, it's a potential match
                result = (new_path, child.value) if child.value is not None else None

                # Try to find a longer match using remaining elements
                remaining = SortedSet(x for x in elements if x > elem)
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
    space.add({'a', 'x'}, "ax_value")
    space.add({'b'}, "x_value")
    
    # Test cases
    test_queries = [
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
