from typing import Dict, List, Set, Tuple, Optional, Any
from dataclasses import dataclass
from collections import defaultdict

@dataclass
class TrieNode:
    value: Optional[str] = None
    children: Dict[str, 'TrieNode'] = None
    
    def __post_init__(self):
        if self.children is None:
            self.children = {}

class SetSpace:
    def __init__(self):
        self.root = TrieNode()
    
    def add(self, elements: Set[str], value: str):
        """Add a set and its associated value to the trie"""
        # Sort elements to ensure consistent insertion order
        sorted_elements = sorted(elements)
        
        current = self.root
        # Add intermediate nodes
        for elem in sorted_elements[:-1]:
            if elem not in current.children:
                current.children[elem] = TrieNode()
            current = current.children[elem]
        
        # Add final node with value
        if sorted_elements:
            last_elem = sorted_elements[-1]
            if last_elem not in current.children:
                current.children[last_elem] = TrieNode()
            current.children[last_elem].value = value
    
    def _find_matches(self, node: TrieNode, remaining: Set[str], path: Set[str]) -> List[Tuple[Set[str], str]]:
        """Recursively find all matching sets in the trie"""
        matches = []
        
        # If this node has a value and some elements match our remaining set
        if node.value is not None and path & remaining:
            matches.append((path, node.value))
            
        # Recursively check children that match remaining elements
        for elem, child in node.children.items():
            if elem in remaining:
                new_path = path | {elem}
                matches.extend(self._find_matches(child, remaining, new_path))
                
        return matches
    
    def lookup(self, query: Set[str]) -> List[Tuple[frozenset, str]]:
        """
        Find minimal sets that together cover all elements in the query.
        Returns list of (set, value) pairs.
        """
        if not query:
            return []
        
        remaining = set(query)
        result = []
        
        while remaining:
            # Find all possible matches in the trie
            matches = self._find_matches(self.root, remaining, set())
            
            if not matches:
                break
                
            # Find best match (maximum overlap with remaining elements)
            best_match = max(matches, key=lambda x: len(x[0] & remaining))
            match_set, match_value = best_match
            
            # Add to result and remove covered elements
            result.append((frozenset(match_set), match_value))
            remaining -= match_set
            
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
        {'a', 'x'}       # Should find a_value and x_value
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
