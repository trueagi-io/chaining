# Benchmark between PeTTa and MORK

## Overview

The goal of this experiment is to understand in which cirtumstances
MORK performs better than PeTTa and vice versa.

In particular we are trying to validate the following hypothesis:

If the search space (here proofs) is dense in solutions and/or the
queried solution set is large, then MORK performs better than PeTTa,
otherwise PeTTa performs better than MORK.

Unfortunately, due to the backward chainer implementation of MORK
being too slow we have not been able to validate this experiment yet.

What we have discovered however is that for full forward chaining,
MORK greatly outperforms PeTTa.  For low solution density backward
chaining, PeTTa greatly outperforms MORK.

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

## Usage

To benchmark, run

```bash
./benchmark.sh
```

this will produce a `benchmark.csv` file can then be used to render
various plots via the script `render-plots.sh` which will be placed
under the `plots` subfolder.

Both `benchmark.csv` and the plots have been pre-computed and are
already provided.

## Discussion

It takes 75s for MORK to generate all possible 6087113 proofs within a
depth of 4 of all possible theorems (with proofs of depth 4 at most).
This is likely near the optimal speed to generate all these proofs.

It takes about 0.05ms (50μs) in average for PeTTa to discover a proof
of a theorem by going backward, thus we can estimate that generating
all proofs going backward would take 0.00005 * 6087113 = 304s.  This
is only 4 times more than 75s.  So the overhead of PeTTa to go
backward instead of going forward (assuming it would know exactly what
rules to apply, which it does not), is only 4x.  I believe it says
that PeTTa is extremely competitive when it comes to backward
chaining.

10us per solution forward MORK

50us per solution backward PeTTa 4-5x slower than what I would
consider to be the upper limit optimal

## Backward chaining

- impid: (→ (→ 𝜑 𝜓) (→ 𝜑 𝜑))
- id: (→ 𝜑 𝜑)
- 2a1: (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜑)))
- pm2.43: (→ (→ 𝜑 (→ 𝜑 𝜓)) (→ 𝜑 𝜓))
- imim2: (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜑) (→ 𝜒 𝜓)))
- jarr: (→ (→ (→ 𝜑 𝜓) 𝜒) (→ 𝜓 𝜒))
