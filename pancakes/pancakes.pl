% Use the given code for is_sorted and between 
is_sorted([]).
is_sorted([_]).
is_sorted([X, Y|L]) :- 
   X =< Y, is_sorted([Y|L]).

between(L, U, L) :-
   L =< U.
between(L, U, X) :-
   L < U, L1 is L + 1, between(L1, U, X).

% Find the nth element in list
my_nth(0, [Y|_], Y) :- 
   !.
my_nth(N, List, Y) :-
   append(L, [Y|_], List),
   length(L, N),
   !.

% Add 2 more parameters to dfs code from slides
dfs(States, Operators, InitialState) :-
   initial_state(InitialState),
   dfs(InitialState, [InitialState], States, Operators, []).

% initial_state is whatever is given and final_state is the initial state sorted.
initial_state(_).
final_state(X):- is_sorted(X).

% modify dfs/3 from slides by adding Operators
dfs(InitialState, States, States, Operators, Operators) :-
   final_state(InitialState).
dfs(State1, SoFarStates, States, Operators, SoFarOperators) :-
   move(State1, State2, X),
   \+ member(State2, SoFarStates),
   append(SoFarStates, [State2], NewSoFarStates),
   append(SoFarOperators, [X], NewSoFarOperators),
   dfs(State2, NewSoFarStates, States, Operators, NewSoFarOperators). 

% Choose a number between 2 and the length of the state to place the spatula
move(State1, State2, X) :-
   length(State1, Length),
   between(2, Length, X1),
   append(OnSpatula, UnderSpatula, State1), % Get a list with the pancakes above the spatula
   length(OnSpatula, X2),
   X2 =:= X1,
   X3 is X1 -1,
   my_nth(X3, State1, X),
   reverse(OnSpatula, ReverseOnSpatula), % Reverse the pancakes
   append(ReverseOnSpatula, UnderSpatula, State2). % Add the pancakes below and you have the new state

% Run pancakes_dfs by calling dfs
pancakes_dfs(InitialState, Operators, States) :- 
   dfs(States, Operators, InitialState).

% Bonus question - runs but finds singular solution only   

% Run pancakes_ids by calling ids, similar to jugsid
pancakes_ids(InitialState, Operators, States) :- 
   initial_state(InitialState),
   ids(0, InitialState, States, Operators).

ids(Lim, InitialState, States, Operators) :-
   ldfs(Lim, InitialState, [InitialState],  States, Operators, []),
   !.
ids(Lim, InitialState, States, Operators) :-
   Lim1 is Lim+1,
   ids(Lim1, InitialState, States, Operators).

ldfs(_, FinalState, States, States, Operators, Operators) :-
   final_state(FinalState).
ldfs(Lim, State1, SoFarStates, States, Operators, SoFarOperators) :-
   Lim > 0,
   Lim1 is Lim - 1,
   move(State1, State2, X),
   \+ member(State2, SoFarStates),
   append(SoFarStates, [State2], NewSoFarStates),
   append(SoFarOperators, [X], NewSoFarOperators),
   ldfs(Lim1, State2, NewSoFarStates, States, Operators, NewSoFarOperators).