-module(capture_handler).

-export([
    init/3
    ,allowed_methods/2
    ,content_types_provided/2
    ,content_types_accepted/2
]).

-export([
    handle_soap/2
    ,parse_callback/2
]).


-record(state, {
    capture = false
    ,item = []
}).


init(_Transport, _Req, []) ->
    {upgrade, protocol, cowboy_rest}.

allowed_methods(Req, State) ->
    {[<<"POST">>], Req, State}.

content_types_provided(Req, State) ->
    {[
        {{<<"text">>, <<"plain">>, []}, handle_soap}
    ], Req, State}.

content_types_accepted(Req, State) ->
    {[
        {{<<"application">>, <<"soap+xml">>, []}, handle_soap}
    ], Req, State}.


handle_soap(Req, State) ->
    case cowboy_req:has_body(Req) of
        true ->
            {ok, Xml, Req2} = cowboy_req:body(Req),
            try
                {ok, #state{item=Parsed}, _} = erlsom:parse_sax(Xml, [], fun capture_handler:parse_callback/2),
                {ok, Data} = process_input(Parsed),
                {ok, File} = file:open("output.csv", [append]),
                csv_gen:row(File, Data),
                file:close(File),
                {true, Req2, State}
            catch
                _:_ ->
                    {false, Req2, State}
            end;
        false ->
            {false, Req, State}
    end.



parse_callback(Event, []) ->
    parse_callback(Event, #state{});

parse_callback(Event, State = #state{capture = Capture, item = Item}) ->
    case Event of
        {startElement, [], "record", [], Attributes} ->
            Record = parse_record(Attributes),
            case proplists:get_value("dataObjectId", Record) of
                "PACK_BASE_UNIT" ->
                    State#state{capture = true};
                _ ->
                    State
            end;
        {startElement, [], "value", [], Attributes} ->
            case Capture of
                true ->
                    Value = parse_value(Attributes),
                    State#state{item = Item ++ [Value]};
                false ->
                    State
            end;
        {endElement, [], "BaseAttributeValues", []} ->
            State#state{capture = false};
        _ ->
            State
    end.


parse_record(Attributes) ->
    lists:map(
        fun(Att) ->
            {attribute, Type, [], [], Val} = Att,
            {Type, Val}
        end,
        Attributes
    ).

parse_value(Attributes) ->
    CompiledValue = lists:map(
        fun(Att) ->
            {attribute, Type, [], [], Val} = Att,
            {Type, Val}
        end,
        Attributes
    ),
    Key = proplists:get_value("baseAttrId", CompiledValue),
    Value = proplists:get_value("value", CompiledValue),
    {Key, Value}.


process_input(Data) ->
    ProdCoverGtin = proplists:get_value("PROD_COVER_GTIN", Data),
    ProdName = proplists:get_value("PROD_NAME", Data),
    if
        ProdCoverGtin =:= undefined orelse ProdName =:= undefined ->
            {error, invalid_input};
        true ->
            ProdDesc = proplists:get_value("PROD_DESC", Data, ""),
            BrandOwnerName = proplists:get_value("BRAND_OWNER_NAME", Data, ""),
            {ok, [
                unicode:characters_to_binary(ProdCoverGtin), 
                unicode:characters_to_binary(ProdName), 
                unicode:characters_to_binary(ProdDesc), 
                unicode:characters_to_binary(BrandOwnerName)
            ]}
    end.
