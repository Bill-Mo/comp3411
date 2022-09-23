% Part 1 Prolog, written by Tianwei Mo, whose zid is z5305298

% Q1.1
% Return ture if X is even, false if X is odd.
is_even(X):-
    X mod 2 =:= 0.

% Base case of sumsq_even: when the list is empty, sum is 0
sumsq_even([], 0).

% Recursive funtion: the sum is the the sum of tail plus the square 
sumsq_even([Head | Tail], Sum):-
    sumsq_even(Tail, TailSum),
    (not(is_even(Head)), Sum is TailSum;
    is_even(Head), Sum is TailSum + Head * Head).

% Q1.2
% State of the robot's world = state(rloc, RHC, SWC, MW, RHM)
% rloc is is one of the coffee shop (cs), Sam's office (off), the mail room (mr), or the laboratory (lab)
% action(Action, State, NewState): Action in State produces NewState

% pickup coffee
action( puc,
    state(cs, false, SWC, MW, RHM),
    state(cs, true, SWC, MW, RHM)).


% deliver coffee
action( dc,
	state(off, true, _, MW, RHM),
	state(off, false, false, MW, RHM)).


% pickup mail
action( pum,
	state(mr, RHC, SWC, true, false),
	state(mr, RHC, SWC, false, true)).


% deliver mail
action( dm,
	state(off, RHC, SWC, MW, true),
	state(off, RHC, SWC, MW, false)).


% move clockwise
action( mc,
	state(cs, RHC, SWC, MW, RHM),
	state(off, RHC, SWC, MW, RHM)).

action( mc,
	state(off, RHC, SWC, MW, RHM),
	state(lab, RHC, SWC, MW, RHM)).

action( mc,
	state(lab, RHC, SWC, MW, RHM),
	state(mr, RHC, SWC, MW, RHM)).

action( mc,
	state(mr, RHC, SWC, MW, RHM),
	state(cs, RHC, SWC, MW, RHM)).


% move counterclockwise
action( mcc,
	state(cs, RHC, SWC, MW, RHM),
	state(mr, RHC, SWC, MW, RHM)).

action( mcc,
	state(mr, RHC, SWC, MW, RHM),
	state(lab, RHC, SWC, MW, RHM)).

action( mcc,
	state(lab, RHC, SWC, MW, RHM),
	state(off, RHC, SWC, MW, RHM)).

action( mcc,
	state(off, RHC, SWC, MW, RHM),
	state(cs, RHC, SWC, MW, RHM)).

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


% Q1.3
:- op(300, xfx, <-).

inter_construction(C1 <- B1, C2 <- B2, C1 <- Z1B, C2 <- Z2B, C <- B) :-
    C1 \= C2,
    intersection(B1, B2, B),
    gensym(z, C),
    subtract(B1, B, B11),
    subtract(B2, B, B12),
    append(B11, [C], Z1B),
    append(B12, [C], Z2B).

% (a)
intra_construction(C1 <- B1, C1 <- B2, C1 <- B11, C <- Z1B, C <- Z2B) :-
    intersection(B1, B2, B),
    gensym(z, C),
    subtract(B1, B, Z1B),
    subtract(B2, B, Z2B),
    append(B, [C], B11).

% (b)
absorption(C1 <- B1, C2 <- B2, C1 <- B, C2 <- B2) :-
    subset(B2, B1),
    subtract(B1, B2, B11),
    append([C2], B11, B).

% (c)
truncation(C1 <- B1, C1 <- B2, C1 <- B) :-
    intersection(B1, B2, B).