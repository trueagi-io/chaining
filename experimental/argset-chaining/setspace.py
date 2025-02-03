from typing import Set, Dict, List, Tuple

class SetSpace:
    def __init__(self):
        # Store sets and their associated values
        self.space: Dict[frozenset, str] = {}
    
    def add(self, elements: Set[str], value: str):
        """Add a set and its associated value to the space"""
        self.space[frozenset(elements)] = value
        
    def lookup(self, query: Set[str]) -> List[Tuple[frozenset, str]]:
        """
        Find minimal sets that together cover all elements in the query.
        Returns list of (set, value) pairs.
        """
        query_set = set(query)
        remaining = query_set.copy()
        result = []
        
        # Sort stored sets by size for minimal coverage
        sorted_sets = sorted(self.space.keys(), key=len, reverse=True)
        
        while remaining:
            best_coverage = None
            best_overlap = 0
            
            # Find set with maximum overlap with remaining elements
            for stored_set in sorted_sets:
                overlap = len(remaining & stored_set)
                if overlap > best_overlap:
                    best_overlap = overlap
                    best_coverage = stored_set
            
            if best_coverage is None:
                break
                
            result.append((best_coverage, self.space[best_coverage]))
            remaining -= best_coverage
            
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
    
    # Test lookup
    query = {'f', 'a', 'b'}
    result = space.lookup(query)
    
    print("Query:", query)
    print("Result:")
    for s, v in result:
        print(f"Set: {s}, Value: {v}")

if __name__ == "__main__":
    test_setspace()
