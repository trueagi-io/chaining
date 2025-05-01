# PLN Inference Control Experiments

Experiments of PLN carrying out inference control.  It does this by
converting any chaining queries into PLN statements such that holes in
the queries have been existentially quantified in the PLN statements.
PLN reasoning then is supposed to take place to evaluate whether a
particular query is likely to be fruitful.  Because the chainer
produces a superposition of competing recursive calls, we can apply
the same process to prune the recursive calls that are unlikely to be
fruitful.

For now this directory contains two experiments

- [rnd-inf-ctl.metta](rnd-inf-ctl.metta) which builds the needed infra
  structure to control chaining with an estimator of query viability,
  which is merely random in this experiment.

- [pln-inf-ctl.metta](pln-inf-ctl.metta) which defines an early
  prototype of PLN, a converter from chaining query to PLN, and a PLN
  based estimator of query viability.

Both experiments uses Propositional Calculus from
[Metamath](https://us.metamath.org/) as corpus of theorems.
