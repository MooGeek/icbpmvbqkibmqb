-module(assignment_7_sup).

-behaviour(supervisor).

-export([
    start_link/0
    ,init/1
]).


start_link() ->
    supervisor:start_link({local, assignment_7}, ?MODULE, []).

init([]) ->
    RestartStrategy = one_for_all,
    MaxRestarts = 1,
    MaxSecondsBetweenRestarts = 10000,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = permanent,
    Shutdown = 5000,
    Type = worker,

    ServerSpec = {
        'assignment_7_server',
        {'assignment_7_server', start_link, [self()]},
        Restart,
        Shutdown,
        Type,
        ['assignment_7_server']
    },
    {ok, {SupFlags, [ServerSpec]}}.
