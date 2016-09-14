-module(assignment_3).

% Problem:
%   The prime factors of 13195 are 5, 7, 13 and 29.
%   What is the largest prime factor of the number 600851475143 ?

-export([
    solution/1
]).


solution(N) when is_integer(N) ->
    solution(N, 2, 0).

solution(N, Current, _Largest) when (N =:= Current) ->
    Current;

solution(N, Current, _Largest) when (N rem Current =:= 0) ->
    solution(trunc(N / Current), 2, Current);

solution(N, Current, _Largest) when ( Current > (N/2) ) ->
    N;

solution(N, Current, Largest) ->
    solution(N, Current + 1, Largest).