-module(assignment_1).

% Problem:
%   If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
%   Find the sum of all the multiples of 3 or 5 below 1000.

-export([
    simple_solution/1,  % 'hard-coded' solution
    generic_solution/2  % generic solution
]).


simple_solution(Count) when is_integer(Count) ->
    simple_solution(Count-1, 0).

simple_solution(Count, Sum) when Count < 3 ->
    Sum;

simple_solution(Count, Sum) when (Count rem 3 =:= 0) orelse (Count rem 5 =:= 0) ->
    simple_solution(Count - 1, Sum + Count);

simple_solution(Count, Sum) ->
    simple_solution(Count - 1, Sum).


generic_solution(MultipleOf, Count) when is_integer(MultipleOf) andalso is_integer(Count) ->
    generic_solution([MultipleOf], Count);

generic_solution(MultipleOfList, Count) when is_list(MultipleOfList) andalso is_integer(Count) ->
    generic_solution(MultipleOfList, MultipleOfList, Count - 1, 0).

generic_solution(_, _, Count, Sum) when Count < 1 ->
    Sum;

generic_solution(MultipleOfList, [MultipleOf | _RestMultipleOfList], Count, Sum) when (Count rem MultipleOf =:= 0) ->
    generic_solution(MultipleOfList, MultipleOfList, Count - 1, Sum + Count);

generic_solution(MultipleOfList, [_MultipleOf | RestMultipleOfList], Count, Sum) ->
    generic_solution(MultipleOfList, RestMultipleOfList, Count, Sum);

generic_solution(MultipleOfList, [], Count, Sum) ->
    generic_solution(MultipleOfList, MultipleOfList, Count - 1, Sum).
