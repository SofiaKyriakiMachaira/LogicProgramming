% Use given code from class
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

% Find the head of a list
head([H|_], H).

% To help create list ASP, find all activities done by a specific person
create_ASP(_, _, 0, []).
create_ASP(ASA, NP, PId, [Z|Y]) :-
   PId > 0, % PId must be positive
   findall(X, member(X-PId, ASA), Z), % Gather every activity of PId
   NewPId is PId - 1,
   create_ASP(ASA, NP, NewPId, Y). % Repeat for next PId (NewPId)

add_num([], _, []).
add_num([List|Rest], PId, [PId-List-Time|Results]) :-
   calculate_time(List, 0, Time), % Calculate activities time of a specific person with time counter starting at 0
   NewPId is PId + 1,
   add_num(Rest, NewPId, Results).

% Calculate activities time using a counter
calculate_time([], Time, Time).
calculate_time([APId|Rest], SoFarTime, Time) :-
   activity(APId, act(Ab, Ae)),
   NewSoFarTime is (SoFarTime + (Ae - Ab)),
   calculate_time(Rest, NewSoFarTime, Time).

% Enhance template shown in class
assignment(NP, MT, ASP, ASA) :-
   findall(X, activity(X, _), AIds), % Gather all activities in list AIds
   assign(AIds, NP, ASA, MT),
   create_ASP(ASA, NP, NP, Results), % Make the reverse ASP
   reverse(Results, FinalResults), % Place ASP in the right order
   add_num(FinalResults, 1, ASP). % Add the number of the person assigned and time they worked

assign([], _, [], _).
assign([AId|AIds], NPersons, [AId-PId|Assignment], MT) :-
   assign(AIds, NPersons, Assignment, MT),
   findall(PId1, (between(1, NPersons, PId1), \+member(_-PId1, Assignment)), X1), % To limit search space, select a list of people that are not in Assignment
   findall(PId2, (between(1, NPersons, PId2), \+member(PId2, X1)), X2), % Select a list of people that are not in X1
   (head(X1, PId); member(PId, X2)), % Select a person PId for activity AId without symmetrical solutions
   activity(AId, act(Ab, Ae)),
   findall(M, member(M-PId, Assignment), APIds), % Gather in list APIds so far activities of PId
   Y is (Ae - Ab),
   valid(Ab, Ae, APIds, Y, MT). % Is current assignment consistent with previous ones?

valid(_, _, [], _, _).
valid(Ab1, Ae1, [APId|APIds], SoFarTime, MT) :-
   activity(APId, act(Ab2, Ae2)),
   NewSoFarTime is (SoFarTime + (Ae2 - Ab2)),
   NewSoFarTime =< MT, % Ensure maximum time has not been exceeded
   Ab2 >= (Ae1 + 1), % Ensure there is no overlap
   valid(Ab1, Ae1, APIds, NewSoFarTime, MT).