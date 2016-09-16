-module(assignment_7_worker).

-behaviour(gen_server).

-export([
    start_link/1
]).

-export([
    init/1
    ,handle_call/3
    ,handle_cast/2
    ,handle_info/2
    ,code_change/3
    ,terminate/2
]).


-record(state, {
    reply_to
}).


start_link(Number) ->
    gen_server:start_link(?MODULE, {Number}, []).

init({ReplyTo}) ->
    ReplyTo ! {worker_ready, [], self()},
    {ok, #state{reply_to = ReplyTo}}.


handle_call(_Msg, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.


handle_info({start_crunching, Number}, State = #state{reply_to = ReplyTo}) ->
    Sequence = collatz_sequence(Number),
    ReplyTo ! {worker_ready, Sequence, self()},
    {noreply, State};

handle_info({stop}, State) ->
    {stop, normal, State};

handle_info(_Msg, State) ->
    {noreply, State}.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.



collatz_sequence(0) ->
    0;

collatz_sequence(Number) when is_integer(Number) ->
    collatz_sequence(Number, [Number]).

collatz_sequence(1, Sequence) ->
    Sequence;

collatz_sequence(Number, Sequence) when (Number rem 2 =:= 0) ->
    Next = Number div 2,
    collatz_sequence(Number div 2, Sequence ++ [Next]);

collatz_sequence(Number, Sequence) ->
    Next = 3 * Number + 1,
    collatz_sequence(Next, Sequence ++ [Next]).
