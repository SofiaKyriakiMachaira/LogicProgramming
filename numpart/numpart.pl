% Sofia Kyriaki Machaira sdi2000125

:- lib(ic).
:- lib(ic_global).

% Use make_domain to make a list with items from 1 to N.
make_domain_num(1, [1]).
make_domain_num(N, Domain) :-
   N > 1,
   N1 is N - 1,
   make_domain_num(N1, RestDomain),
   append(RestDomain, [N], Domain).

% Constraint N and make N/2, add 1 to L1 and then constraint L1 and L2
numpart(N, L1, L2) :-
    N >= 8,
    X1 is N mod 4,
    X1 =:= 0,
    X2 is N mod 2,
    X2 =:= 0,
    HalfN #= eval(N/2),
    length(L1, HalfN),
    make_domain_num(N, L),
    L1 #:: 1..N,
    element(1, L1, 1), % Always place 1 in L1
    ordered_sum(L1, Sum1),
    Sum1 #= eval(N*(N+1)/4), % Ensure ordered sum and squared sum are correct, as mentioned in class
    ic:alldifferent(L1), % Ensure each item in L1 is different
    squared_sum(L1, Sum2),
    eval(Sum2) #= eval(N*(N+1)*(2*N+1)/12), % Also evaluate Sum2 as it has not been evaluated yet
    search(L1, 0, input_order, indomain, complete, []),
    findall(X, (member(X, L), \+member(X, L1)), L2). % Find L2 as every item that is in L and not in L1

% Calculated the sum of each element of the list squared
squared_sum([], 0).
squared_sum([H|L], Sum) :-
    squared_sum(L, Sum1),
    Sum #= (H*H) + Sum1.