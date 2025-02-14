import random

def random_subset(fact_list, min_count=0, max_count=1):
    """
    Given a list of facts, randomly choose between min_count and max_count facts.
    Returns a set of selected facts.
    """
    if not fact_list:
        return set()
    # Ensure we do not ask for more than available.
    max_possible = min(max_count, len(fact_list))
    # If available facts are fewer than min_count, choose all.
    if max_possible < min_count:
        count = max_possible
    else:
        count = random.randint(min_count, max_possible)
    return set(random.sample(fact_list, count))


def generate_rules(num_rules, width, depth):
    """
    Generate a set of rules.
    
    Each rule is a tuple (premises, conclusions) where both premises and conclusions
    are sets of fact strings.
    
    Parameters:
      num_rules: minimum total number of rules to generate.
      width: controls the "branching" in two ways:
             - When choosing extra premises/conclusions, up to (width-1) additional facts are added.
             - In post-processing, we add extra rules to ensure each fact appears at least `width` times.
      depth: maximum chain length (layers of rules).
      
    Returns:
      A list of rules.
    """
    rules = []
    facts = []  # List of all fact strings.
    fact_counter = 0  # For naming new facts.

    def new_fact():
        nonlocal fact_counter
        f = f"F{fact_counter}"
        fact_counter += 1
        facts.append(f)
        return f

    # Create an initial fact.
    init = new_fact()
    current_layer_facts = [init]
    current_depth = 0

    # Build a chain of rules to ensure the desired depth.
    while current_depth < depth and len(rules) < num_rules:
        next_layer_facts = []
        for fact in current_layer_facts:
            if len(rules) >= num_rules:
                break
            # For the rule, start with the given fact.
            # Also add a random selection (possibly empty) from our current pool.
            extra_premises = random_subset(facts, min_count=0, max_count=width - 1)
            premises = set([fact]) | extra_premises

            # Generate a new fact that will serve as a "bridge" to the next layer.
            new_f = new_fact()
            next_layer_facts.append(new_f)
            # Similarly, for conclusions include the new fact plus some extra facts.
            extra_conclusions = random_subset(facts, min_count=0, max_count=width - 1)
            conclusions = set([new_f]) | extra_conclusions

            rules.append((premises, conclusions))
        current_layer_facts = next_layer_facts
        current_depth += 1

    # If we haven't reached num_rules yet, add extra random rules.
    while len(rules) < num_rules:
        premises = random_subset(facts, min_count=1, max_count=width)
        conclusions = random_subset(facts, min_count=1, max_count=width)
        # Ensure neither set is empty.
        if not premises:
            premises.add(random.choice(facts))
        if not conclusions:
            conclusions.add(random.choice(facts))
        rules.append((premises, conclusions))

    # Finally, adjust the rules so that every fact appears in at least `width` rules.
    rules = adjust_rules_for_width(rules, width, facts, new_fact)
    return rules


def adjust_rules_for_width(rules, min_width, facts, new_fact_func):
    """
    Post-process the rules so that each fact in 'facts' appears at least min_width times
    (either as a premise or a conclusion). If a fact falls short, add extra rules that use it.
    
    Parameters:
      rules: current list of rules.
      min_width: required minimum number of appearances.
      facts: list of all fact strings.
      new_fact_func: a function that generates a new fact and adds it to the facts list.
    
    Returns:
      The augmented list of rules.
    """
    # Count how many times each fact appears.
    occurrence = {}
    for premises, conclusions in rules:
        for f in premises.union(conclusions):
            occurrence[f] = occurrence.get(f, 0) + 1

    extra_rules = []
    # Iterate over a copy of the facts list since it may grow.
    for f in list(facts):
        while occurrence.get(f, 0) < min_width:
            # Add a new rule with f in the premises and a new fact in the conclusions.
            premises = {f}
            new_f = new_fact_func()
            conclusions = {new_f}
            extra_rules.append((premises, conclusions))
            occurrence[f] = occurrence.get(f, 0) + 1
            occurrence[new_f] = 1
    rules.extend(extra_rules)
    return rules


# === Example Usage ===
if __name__ == "__main__":
    # You can adjust these parameters to control the rule set.
    num_rules = 10  # Minimum total number of rules.
    width = 3       # Target "width" (branching factor and minimum appearances per fact).
    depth = 3       # Maximum chain depth.
    
    generated_rules = generate_rules(num_rules, width, depth)
    
    # Print out the generated rules.
    for idx, (premises, conclusions) in enumerate(generated_rules):
        print(f"Rule {idx}: {premises} => {conclusions}")

