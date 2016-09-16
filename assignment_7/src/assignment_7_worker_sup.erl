-module(assignment_7_worker_sup).

-export([
    start_link/0
    ,init/1
]).


start_link() ->
    supervisor:start_link(?MODULE, []).

init([]) ->
    RestartStrategy = simple_one_for_one,
    MaxRestarts = 1,
    MaxSecondsBetweenRestarts = 10000,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = temporary,
    Shutdown = 5000,
    Type = worker,

    WorkerSpec = {
        'assignment_7_worker',
        {'assignment_7_worker', start_link, []},
        Restart,
        Shutdown,
        Type,
        ['assignment_7_worker']
    },
    {ok, {SupFlags, [WorkerSpec]}}.
