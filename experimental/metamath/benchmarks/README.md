# Benchmark between PeTTa and MORK

## Overview

The goal of this experiment is to understand in which cirtumstances
MORK performs better than PeTTa and vice versa.

In particular we are trying to validate the following hypothesis:

If the search space (here proofs) is dense in solutions and/or the
queried solution set is large, then MORK performs better than PeTTa,
otherwise PeTTa performs better than MORK.

## Notations

Validating this hypothesis requires to be able to vary the density of
solutions in a search space.  We can do that by varying the query,
which in this case can be done by carefully to selecting the theorem
prove.  The lowest possible density is 0, meaning no solution.  The
highest possible density is 1, meaning every accessible proof term is
a solution.  To reach these two extremes we can set up the following
queries

- Density 0:

```
(: $proof (¬ (→ $𝜑 (→ $𝜓 $𝜑))))
```

where `(¬ (→ $𝜑 (→ $𝜓 $𝜑)))` corresponds to the negation of ax-1,
which assuming that our logic is consistent, should have no proof.
Let us call this query `AQ`, for the Absurd Query.

- Density 1:

```
(: $proof $thrm)
```

where all reachable proof terms corresponds to a proof of a theorem.
Let us call this query `UQ`, for the Universal Query.

And then we can have a range of densities between these two extremes
by selecting theorems with more or less proofs.

Given a query `Q` of the form `(: PROOF THEOREM)`, the density of
solutions in the corresponding search space is going to be defined as:

```
D(Q) = |S(Q)| / |S(UQ)|
```

where `S(Q)` is the solution set associated to query `Q`.

## Methodology

The experiment is in three phases.

1. Generate the set of all solutions for any theorem, corresponding to
   the Universal Query `UQ`, up to a certain depth.  This gives us our
   first data point to compare MORK and PeTTa, as well as a gigantic
   corpus of proofs and theorems that we can select from to build
   subsequent queries of different densities.
2. Run MORK and PeTTa over the Absurd Query `AQ`.  This gives us our
   second data point to compare MORK and PeTTa.
3. Sort theorems obtained in step 1 by their densities, and run MORK
   and PeTTa over various queries of various densities to obtain our
   remaining data points.
