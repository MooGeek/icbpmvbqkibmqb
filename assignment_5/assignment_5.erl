-module(assignment_5).

% Problem:
%   2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.
%   What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?

-export([
    solution/2
]).


gcd(A, 0) ->
    A;

gcd(A, B) ->
    gcd(B, A rem B).


lcm(A, B) ->
    trunc(A / gcd(A, B) * B).


solution(Start, End) when is_integer(Start) andalso is_integer(End) ->
    solution(
        lists:seq(Start, End),
        Start
    );

solution([], Result) ->
    Result;

solution([Divisor | RestDivisors], Result) ->
    solution(RestDivisors, lcm(Result, Divisor)).