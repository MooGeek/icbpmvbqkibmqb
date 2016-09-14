-module(assignment_4).

% Problem:
%   A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 * 99.
%   Find the largest palindrome made from the product of two 3-digit numbers.

-export([
    solution/1
]).


% :)
%cheatIsPalindrome(N) when is_integer(N) ->
%    integer_to_list(N) =:= lists:reverse( integer_to_list(N) ).


isPalindrome(N) when N < 9 ->
    false;

isPalindrome(N) ->
    N == isPalindrome(N, 0).

isPalindrome(0, ReverseN) ->
    ReverseN;

isPalindrome(N, ReverseN) ->
    isPalindrome(trunc(N / 10), ReverseN * 10 + (N rem 10)).


solution(Size) when Size < 2 ->
    0;

% can overflow
solution(Size) when is_integer(Size)->
    High = trunc(math:pow(10, Size) - 1),
    Low = High - trunc( math:pow(10, Size - 1) - 1),
    solution(Low, High).

solution(Low, High) ->
    solution(Low, Low, Low, High, 0).

solution(FirstN, _SecondN, _Low, High, Result) when (FirstN > High) ->
    Result;

solution(FirstN, SecondN, Low, High, Result) when (SecondN > High) ->
    solution(FirstN + 1, Low, Low, High, Result);

solution(FirstN, SecondN, Low, High, Result) ->
    case isPalindrome(FirstN * SecondN) of
        true ->
            solution(FirstN, SecondN + 1, Low, High, FirstN * SecondN);
        _ ->
            solution(FirstN, SecondN + 1, Low, High, Result)
    end.