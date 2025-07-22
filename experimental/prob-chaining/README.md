# Probabilistic Backward Chainer

Contains a [probabilistic backward chainer](prob-chaining.metta),
inspired by Problog and created during a call with Abdulrahman Omar,
Jonathan Warrell, Matt Ikle, Douglas Miles and Mike Duncan.  It is
basically a regular backward chainer but the search is
probabilistically pruned when reasoning the axioms and inference
rules.  This has the effect of emulating a sampling procedure in
Problog.

Also contains a [categorical sampler](categorical-sampler.metta),
unrelated to the probabilistic backward chainer other than the fact
that it is another experiment about sampling.
