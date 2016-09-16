# Assignment 7

Implement the task as an Erlang/OTP application each sequence is calculated by servers independently, a supervisor using an application’s setting "maximum number of workers” starts servers, collects results and finds the longest chain. You must not use third-party libraries for the servers pool implementation.

The following iterative sequence is defined for the set of positive integers: 
```
  n → n/2 (n is even) 
  n → 3n + 1 (n is odd) 
```

Using the rule above and starting with 13, we generate the following sequence: 
```
13 → 40 → 20 → 10 → 5 → 16 → 8 → 4 → 2 → 1 
```

It can be seen that this sequence (starting at 13 and finishing at 1) contains 10 terms. Although it has not been proved yet (Collatz Problem), it is thought that all starting numbers finish at 1. Which starting number, under one million, produces the longest chain? NOTE: Once the chain starts the terms are allowed to go above one million.


Usage:

```
3> assignment_7:start_assignment(1000, 1000000). % 1000 workers, 1000000 max starting number
ok
837799
```
