%% pc_xp_timed.pl
%%
%% Prolog helper for the pc-xp experiments: run an obc proof search under a
%% hard wall-clock budget.
%%
%%   timed_obc_once(+RB, +AB, +CB, +Bound, +GoalIn, +TimeLimit, -Result)
%%
%%   obc is the MeTTa function (= (obc $rb $ab $cb $mps (: $prf $thrm)) ...)
%%   which the translator compiles to the Prolog predicate obc/6, where the
%%   final argument is the returned value.  GoalIn is [':', ProofVar, Thrm].
%%   Runs once(obc(RB, AB, CB, Bound, GoalIn, Out)) in a WORKER THREAD and
%%   waits at most TimeLimit seconds for its answer.  Results come back in
%%   MeTTa list form so the caller's (case ...) patterns unify with them:
%%
%%     Result = [found, Out]  -- proof found; Out = [':', Proof, Thrm] bound
%%     Result = not_found     -- search space exhausted; no proof at Bound
%%     Result = timeout       -- TimeLimit elapsed; the worker was aborted
%%
%% WHY A THREAD (and not call_with_time_limit): the alarm-based
%% call_with_time_limit delivers its timeout as a time_limit_exceeded
%% exception thrown into the running goal.  The compiled MeTTa runtime
%% contains catch-alls -- reduce/2's catch(call(G),_,fail) in translator.pl
%% and the match/4 catches in spaces.pl -- that swallow ANY exception and
%% turn it into a plain failure.  So whether the timeout actually stops the
%% search depends on where execution happens to be when the alarm fires:
%% Aborting a worker thread instead delivers unwind(abort), which catch/3 is 
%% REQUIRED to pass through (SWI-Prolog >= 9), so the deadline holds no matter 
%% what the search is executing.  This also keeps the fix entirely outside
%% PeTTa's core sources.
%%
%% Notes:
%% - MeTTa spaces are assertz'd dynamic predicates, which SWI-Prolog shares
%%   between threads, so the worker searches the same knowledge base.
%% - thread_create copies GoalIn; the worker's bindings come back through
%%   the message queue (terms are copied with their bindings).
%% - Threads inherit Prolog flags, including stack_limit (8g via run.sh).
%% - The worker runs pure Prolog only (no janus/Python calls), so aborting
%%   it is safe.

timed_obc_once(RB, AB, CB, Bound, GoalIn, TimeLimit, Result) :-
    message_queue_create(Q),
    thread_create(timed_obc_worker(RB, AB, CB, Bound, GoalIn, Q), Tid, []),
    (   thread_get_message(Q, Msg, [timeout(TimeLimit)])
    ->  Result0 = Msg
    ;   % deadline passed: abort the worker (unwind(abort) cannot be
        % swallowed by the runtime's catch-alls) and report the timeout
        catch(thread_signal(Tid, abort), _, true),
        Result0 = timeout
    ),
    thread_join(Tid, _Status),
    message_queue_destroy(Q),
    Result = Result0.

timed_obc_worker(RB, AB, CB, Bound, GoalIn, Q) :-
    (   catch(once(obc(RB, AB, CB, Bound, GoalIn, Out)), _, fail)
    ->  thread_send_message(Q, [found, Out])
    ;   thread_send_message(Q, not_found)
    ).
