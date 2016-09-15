-module(assignment_8).

% Problem:
%   Implement a GTIN-14 validator as an Erlang module function validate({gtin, Value}) -> ok |
%   {error, Error}, Value is iolist() or binary(). The related specification can be found
%   here: http://www.gs1.org/barcodes-epcrfid-id-keys/gs1-general-specifications

-export([
    validate/1
]).


validate_checksum(Value) ->
    [CheckDigit | Code] = lists:reverse( [ binary_to_integer(X) || <<X:1/binary>> <= Value] ),
    Multiples = lists:flatten([[3,1] || _ <- lists:seq(1, 9)]),
    Sum = lists:sum([X * Y || {X, Y} <- lists:zip( Code, lists:sublist( Multiples, length(Code) ) )]),
    CheckDigit =:= (10 - Sum rem 10).

validate({gtin, Value}) ->
    try
        true = validate_checksum( iolist_to_binary(Value) ),
        ok
    catch
        _:{badmatch, _} ->
            {error, checksum_mismatch};
        _:badarg ->
            {error, invalid_input};
        _:_ ->
            {error, internal_error}
    end.