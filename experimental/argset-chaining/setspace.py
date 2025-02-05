from typing import Dict, List, Set, Tuple, Optional
from collections import defaultdict
from sortedcontainers import SortedSet, SortedDict
from hyperon import Atom, SymbolAtom, ExpressionAtom, MeTTa, OperationAtom, E, S
import uuid
from hyperon.ext import register_atoms

class TrieNode:
    def __init__(self, value: Optional[Atom] = None):
        self.value = value
        self.children: SortedDict[str, 'TrieNode'] = SortedDict()

class SetSpace:
    def __init__(self):
        self.root = TrieNode()
    
    def add(self, expr: ExpressionAtom, value: Atom):
        """Add a set and its associated value to the trie"""
        # Get elements from expression and sort them
        elements = expr.get_children()
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

    def get_all_elements(self) -> List[ExpressionAtom]:
        """Get all unique element combinations that have values, only returning longest paths"""
        def collect_values(node: TrieNode, depth: int) -> List[Tuple[Atom, int]]:
            results = []
            if node.value is not None:
                results.append((node.value, depth))
            
            for child in node.children.values():
                results.extend(collect_values(child, depth + 1))
            return results
        
        # Get all values with their depths
        values_with_depth = collect_values(self.root, 0)
        
        # Find maximum depth
        max_depth = max(depth for _, depth in values_with_depth) if values_with_depth else 0
        
        # Only keep values from the longest paths
        longest_values = [value for value, depth in values_with_depth if depth == max_depth]
        
        return [E(*longest_values)]

    def lookup(self, query: ExpressionAtom) -> List[Atom]:
        """
        Find minimal sets that together cover all elements in the query.
        Returns list of (set, value) pairs.
        """
        if not query:
            return []
        
        elements = SortedSet(str(elem) for elem in query.get_children())
        result = []
        
        while elements:
            elem = elements.pop(0)
            try:
                match = self._find_best_match(self.root.children[elem], elements, set())
            except KeyError:
                return []

            if not match:
                return []
                
            match_set, match_value = match
            result.append(match_value)
            elements.difference_update(match_set)
            
        return result


class SpaceManager:
    def __init__(self):
        self.spaces: Dict[str, SetSpace] = {}
    
    def create_space(self) -> List[Atom]:
        space_name = f"space_{uuid.uuid4().hex[:8]}"
        name = S(space_name)
        self.spaces[space_name] = SetSpace()
        return [name]
    
    def get_space(self, name: SymbolAtom) -> Optional[SetSpace]:
        return self.spaces.get(str(name))
    
    def add_to_space(self, space_name: SymbolAtom, elements: ExpressionAtom, value: Atom) -> List[Atom]:
        space = self.get_space(space_name)
        if space:
            space.add(elements, value)
            return [value]
        return []
    
    def lookup_in_space(self, space_name: SymbolAtom, query: ExpressionAtom) -> List[ExpressionAtom]:
        space = self.get_space(space_name)
        if space:
            results = space.lookup(query)
            return [E(*results)] if results else []
        return []
    
    def get_space_elements(self, space_name: SymbolAtom) -> List[ExpressionAtom]:
        space = self.get_space(space_name)
        if space:
            return space.get_all_elements()
        return []

# Global SpaceManager instance
MANAGER = SpaceManager()

# Create operation atoms
create_space_atom = OperationAtom("create-setspace", MANAGER.create_space, ['Atom'], unwrap=False)
add_atom = OperationAtom("add-to-setspace", MANAGER.add_to_space, ['Atom', 'Expression', 'Atom', 'Atom'], unwrap=False)
lookup_atom = OperationAtom("lookup-in-setspace", MANAGER.lookup_in_space, ['Atom', 'Expression', 'Expression'], unwrap=False)
elements_atom = OperationAtom("get-setspace-elements", MANAGER.get_space_elements, ['Atom', 'Expression'], unwrap=False)

@register_atoms
def my_atoms():
    return {
        "create-setspace": create_space_atom,
        "add-to-setspace": add_atom,
        "lookup-in-setspace": lookup_atom,
        "get-setspace-elements": elements_atom
    }
