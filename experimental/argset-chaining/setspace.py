from typing import Set, Dict, List, Tuple, Optional
from collections import defaultdict

class SetSpace:
    def __init__(self):
        # Store sets and their associated values
        self.space: Dict[frozenset, str] = {}
        # Index mapping elements to sets containing them
        self.element_index: Dict[str, Set[frozenset]] = defaultdict(set)
        # Cache of sorted sets
        self._sorted_sets: Optional[List[frozenset]] = None
    
    def add(self, elements: Set[str], value: str):
        """Add a set and its associated value to the space"""
        frozen = frozenset(elements)
        self.space[frozen] = value
        # Update element index
        for elem in elements:
            self.element_index[elem].add(frozen)
        # Invalidate cache
        self._sorted_sets = None
        
    def lookup(self, query: Set[str]) -> List[Tuple[frozenset, str]]:
        """
        Find minimal sets that together cover all elements in the query.
        Returns list of (set, value) pairs.
        """
        if not query:
            return []
            
        # Get candidate sets that contain any query elements
        candidates = set()
        for elem in query:
            candidates.update(self.element_index[elem])
            
        if not candidates:
            return []
            
        query_set = set(query)
        remaining = query_set.copy()
        result = []
        
        # Use cached sorted sets, filtering to candidates
        if self._sorted_sets is None:
            self._sorted_sets = sorted(self.space.keys(), key=len, reverse=True)
        
        candidate_sets = [s for s in self._sorted_sets if s in candidates]
        
        while remaining:
            best_coverage = None
            best_overlap = 0
            best_size = float('inf')
            
            # Find set with maximum overlap and minimum size
            for stored_set in candidate_sets:
                overlap = len(remaining & stored_set)
                if overlap > 0:  # Only consider sets with some overlap
                    if overlap > best_overlap or (overlap == best_overlap and len(stored_set) < best_size):
                        best_overlap = overlap
                        best_size = len(stored_set)
                        best_coverage = stored_set
            
            if best_coverage is None:
                break
                
            result.append((best_coverage, self.space[best_coverage]))
            remaining -= best_coverage
            # Remove used set from candidates
            candidate_sets.remove(best_coverage)
            
        return result

def test_setspace():
    # Create test space
    space = SetSpace()
    
    # Add test sets
    space.add({'f', 'a'}, "fa_value")
    space.add({'f'}, "f_value") 
    space.add({'a'}, "a_value")
    space.add({'x'}, "x_value")
    space.add({'b'}, "b_value")
    space.add({'f', 'a', 'b'}, "fab_value")
    
    # Test cases
    test_queries = [
        {'f', 'a', 'b'},  # Should prefer larger overlapping set
        {'x'},            # Single element
        set(),           # Empty set
        {'y'},           # Non-existent element
        {'f', 'a', 'x'}  # Multiple sets needed
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
