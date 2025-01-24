# No-depth

Experiment to see if one can eliminate the need for the depth argument
when running the backward chainer using MeTTaLog.  Instead of having a
depth argument inside the `bc` call, the `bc` call is wrapped around
`limit` call.

Results: it works, however if the limit if greater than the number of
available results then it runs forever.
