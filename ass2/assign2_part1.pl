%COMP 3411 Assignment2 Part1 Prolog
%Name: Yueyang Gu
%Zid:  z5251261
%Date: 2022/4/19

%Question 1.1: List Processing
even([], 0).
even([Head | Tail], Sum) :-
    0 is Head mod 2->    
    even(Tail, Tail_Sum),
    Sum is Head * Head + Tail_Sum;
    even(Tail, Sum).

sumsq_even(List, Sum) :-
    even(List, Sum).

%Question 1.2: Planning
room(cs, 0).
room(off, 1).
room(lab, 2).
room(mr, 3).

action( mc,
    state(RLoc, RHC, SWC, MW, RHM),
    state(New_RLoc, RHC, SWC, MW, RHM)):-
      room(RLoc, Ori1),
      (Ori1 <3 ->  
      Ori2 is Ori1 +1,
      room(New_RLoc, Ori2);
      Ori2 is 0,
      room(New_RLoc, Ori2)).
  
action( mcc,
    state(RLoc, RHC, SWC, MW, RHM),
    state(New_RLoc,RHC, SWC, MW, RHM)):-
      room(RLoc, Ori1),
      (Ori1 >0->  
      Ori2 is Ori1 -1,
      room(New_RLoc, Ori2);
      Ori2 is 3,
      room(New_RLoc, Ori2)).
action( puc,
    state(cs, false, SWC, MW, RHM),
    state(cs, true, SWC, MW, RHM)).
action( dc,
    state(off, true, _, MW, RHM),
    state(off, false, false, MW, RHM)). 
action( pum,
    state(mr, RHC, SWC, true, false),
    state(mr, RHC, SWC, true, true)).
action( dm,
    state(off, RHC, SWC, MW, true),
    state(off, RHC, SWC, MW, false)).


% plan(StartState, FinalState, Plan)

plan(State, State, []).				% To achieve State from State itself, do nothing

plan(State1, GoalState, [Action1 | RestofPlan]) :-
	action(Action1, State1, State2),		% Make first action resulting in State2
	plan(State2, GoalState, RestofPlan). 		% Find rest of plan

% Iterative deepening planner
% Backtracking to "append" generates lists of increasing length
% Forces "plan" to ceate fixed length plans

id_plan(Start, Goal, Plan) :-
    append(Plan, _, _),
    plan(Start, Goal, Plan).


%Question 1.3: Inductive Logic Programming
:- op(300, xfx, <-).
inter_construction(C1 <- B1, C2 <- B2, C1 <- Z1B, C2 <- Z2B, C <- B) :-
    C1 \= C2,
    intersection(B1, B2, B),
    gensym(z, C),
    subtract(B1, B, B11),
    subtract(B2, B, B12),
    append(B11, [C], Z1B),
    append(B12, [C], Z2B).

%Question 1.3 (a)
intra_construction(C1 <- B1, C1 <- B2, C1 <- Z1B, C <- D, C <- E):-
    intersection(B1, B2, B),
    gensym(z, C),
    append(B, [C], Z1B),
    subtract(B1, B, D),
    subtract(B2, B, E).

%Question 1.3 (b)
absorption(C1 <- B1, C2 <- B2, C1 <- Y1B, C2 <- B2):-
    subset(B2, B1)->  
    subtract(B1, B2, D),
    append([C2], D, Y1B);
    false.

%Question 1.3 (c)
truncation(C1 <- B1, C1 <- B2, C1<- B):-
	intersection(B1, B2, B).
	