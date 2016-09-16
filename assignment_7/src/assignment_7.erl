-module(assignment_7).

-behaviour(application).

-export([
    start/2
    ,stop/1
    ,start_assignment/2
]).


start(_StartType, _StartArgs) ->
    assignment_7_sup:start_link().

stop(_State) ->
    ok.


start_assignment(WorkerLimit, MaxNumber) ->
    assignment_7_server:start(WorkerLimit, MaxNumber).
