-module(assignment_6_app).

-behaviour(application).

-export([
    start/2
    ,stop/1
]).


start(_StartType, _StartArgs) ->
    application:ensure_all_started(cowboy),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/capture", capture_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_http(http, 100, [{port, 9090}], [
        {env, [{dispatch, Dispatch}]}
    ]),
    assignment_6_sup:start_link().

stop(_State) ->
    ok.
