% Name: Jingyi Song 
% zid: z5338222

% 1.1
even(N) :- 0 is N mod 2.

even_seq([], []).
    
even_seq([A | B], [C | SubList]):-
    even_seq(B, SubList),
    (   even(A),
    C is A;
    C is 0).

sumsq([], 0).

sumsq([A | B], Sum):-
	sumsq(B, SubSum),
	Sum is SubSum + A * A.

sumsq_even(Seq, Sum):-
    even_seq(Seq, EvenSeq),
    sumsq(EvenSeq, Sum).

% 1.2
action( puc,
	state(cs, false, SWC, MW, RHM),
	state(cs, true, SWC, MW, RHM)).

action( dc,
	state(off, true, _, MW, RHM),
	state(off, false, false, MW, RHM)).

action( pum,
	state(mr, RHC, SWC, true, false),
	state(mr, RHC, SWC, false, true)).

action( dm,
	state(off, RHC, SWC, MW, true),
	state(off, RHC, SWC, MW, false)).

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

% 1.3
:- op(300, xfx, <-).

intra_construction(C1 <- B1, C1 <- B2, C1 <- B11, C <- B12, C <- B13) :-
    intersection(B1, B2, B),
    gensym(z, C),
    subtract(B1, B, B12),
    subtract(B2, B, B13),
    append(B, [C], B11).

absorption(C1 <- B1, C2 <- B2, C1 <- B, C2 <- B2) :-
    subset(B2, B1),
    subtract(B1, B2, B11),
    append([C2], B11, B).

truncation(C1 <- B1, C1 <- B2, C1 <- B) :-
    intersection(B1, B2, B).