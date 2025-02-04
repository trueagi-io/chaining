from typing import Dict, List, Set, Tuple, Optional
from collections import defaultdict
from sortedcontainers import SortedSet, SortedDict
from hyperon import Atom, SymbolAtom, MeTTa, OperationAtom
from hyperon.ext import register_atoms

class TrieNode:
    def __init__(self, value: Optional[Atom] = None):
        self.value = value
        self.children: SortedDict[str, 'TrieNode'] = SortedDict()

class SetSpace:
    def __init__(self):
        self.root = TrieNode()
    
    def add(self, elements: List[SymbolAtom], value: Atom):
        """Add a set and its associated value to the trie"""
        # Sort elements to ensure consistent insertion order and convert to strings
        sorted_elements = sorted(str(elem) for elem in elements)
        
        current = self.root
        # Add intermediate nodes
        for elem in sorted_elements:
            if elem not in current.children:
                current.children[elem] = TrieNode()
            current = current.children[elem]

        current.value = value
    
    def _find_best_match(self, node: TrieNode, elements: SortedSet, current_path: Set[str]) -> Optional[Tuple[Set[str], str]]:
        """Find the best matching set starting from the current node"""
        best_match = (current_path, node.value) if node.value is not None else None

        # Process children in order
        for elem, child in node.children.items():
            if elem in elements:
                # Try to find a longer match with remaining elements
                deeper_match = self._find_best_match(child, elements, current_path | {elem})

                if deeper_match and (not best_match or len(deeper_match[0]) > len(best_match[0])):
                    best_match = deeper_match
            
        return best_match
    
    def pretty_print(self, node: Optional[TrieNode] = None, prefix: str = "", is_last: bool = True, elem: str = "") -> None:
        """Pretty print the trie structure"""
        if node is None:
            node = self.root
            print("SetSpace Trie:")
        
        # Print current node
        connector = "└── " if is_last else "├── "
        value_str = f" -> {node.value}" if node.value is not None else ""
        print(f"{prefix}{connector}{elem}{value_str}")
        
        # Print children
        children = list(node.children.items())
        for i, (child_elem, child) in enumerate(children):
            is_last_child = i == len(children) - 1
            new_prefix = prefix + ("    " if is_last else "│   ")
            self.pretty_print(child, new_prefix, is_last_child, child_elem)

    def lookup(self, query: List[SymbolAtom]) -> List[Atom]:
        """
        Find minimal sets that together cover all elements in the query.
        Returns list of (set, value) pairs.
        """
        if not query:
            return []
        
        elements = SortedSet(str(elem) for elem in query)
        result = []
        
        while elements:
            elem = elements.pop(0)
            try:
                match = self._find_best_match(self.root.children[elem], elements, set())
            except KeyError:
                return []

            print(f"Match {match}")
            print(f"Elements {elements}")

            if not match:
                return []
                
            match_set, match_value = match
            result.append(match_value)
            elements.difference_update(match_set)
            
        return result


# Global SetSpace instance
SPACE = SetSpace()

def add_to_space(elements: List[SymbolAtom], value: Atom):
    SPACE.add(elements, value)
    return [value]

def lookup_in_space(query: List[SymbolAtom]):
    return SPACE.lookup(query)

# Create operation atoms
add_atom = OperationAtom("add-to-space", add_to_space, ['List', 'Atom', 'Atom'], unwrap=False)
lookup_atom = OperationAtom("lookup-in-space", lookup_in_space, ['List', 'List'], unwrap=False)

@register_atoms
def my_atoms():
    return {
        "add-to-space": add_atom,
        "lookup-in-space": lookup_atom
    }
