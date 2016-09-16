-module(assignment_7_server).

-behaviour(gen_server).

-export([
    start_link/1
    ,start/2
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
    alive_workers = 0
    ,worker_limit = 1
    ,numbers = queue:new()
    ,longest_chain = []
    ,worker_supervisor
}).


-define(WORKER_SPEC,
    {
        'assignment_7_worker_sup',
        {'assignment_7_worker_sup', start_link, []},
        temporary,
        10000,
        supervisor,
        ['assignment_7_worker_sup']
    }
).


start(WorkerLimit, MaxNumber) ->
    gen_server:call(?MODULE, {start_workers, {WorkerLimit, MaxNumber}}).


start_link(Supervisor) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, {Supervisor}, []).

init({Supervisor}) ->
    self() ! {post_init, Supervisor},
    {ok, #state{}}.


handle_call({start_workers, {WorkerLimit, MaxNumber}}, _From, State = #state{worker_supervisor = WorkerSupervisor}) ->
    _Workers = [supervisor:start_child(WorkerSupervisor, [self()]) || _ <- lists:seq(1, WorkerLimit)],
    Numbers = lists:seq(1, MaxNumber),
    {reply, ok, State#state{
        numbers = queue:from_list(Numbers)
        ,alive_workers = WorkerLimit
        }
    };

handle_call(_Msg, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({post_init, Supervisor}, State) ->
    {ok, WorkerSupervisorPid} = supervisor:start_child(Supervisor, ?WORKER_SPEC),
    link(WorkerSupervisorPid),
    {noreply, State#state{worker_supervisor = WorkerSupervisorPid}};

handle_info({worker_ready, Result, Worker}, State = #state{longest_chain = LongestChain, numbers = Numbers, alive_workers = AliveWorkers}) ->
    NewLongestChain = case (length(Result) > length(LongestChain)) of
        true ->
            Result;
        false ->
            LongestChain
    end,
    case queue:out(Numbers) of
        {{value, Number}, RestNumbers} ->
            Worker ! {start_crunching, Number},
            {noreply, State#state{
                longest_chain = NewLongestChain
                ,numbers = RestNumbers
                }
            };
        {empty, _} ->
            Worker ! {stop},
            case (AliveWorkers > 1) of
                true ->
                    {noreply, State#state{
                            longest_chain = NewLongestChain
                            ,alive_workers = AliveWorkers - 1
                        }
                    };
                false ->
                    [StartingNumber | Rest] = NewLongestChain,
                    io:format("~p~n", [StartingNumber]),
                    {noreply, State#state{alive_workers = 0, longest_chain = []}}
            end
    end;

handle_info(_Msg, State) ->
    {noreply, State}.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.
