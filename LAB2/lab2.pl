/*---------------------------------------------------------------*/
/* Telecom Paris- J-L. Dessalles 2023                            */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/


% adapted from I. Bratko - "Prolog - Programming for Artificial Intelligence"
%              Addison Wesley 1990

% An ape is expected to form a plan to grasp a hanging banana using a box.
% Possible actions are 'walk', 'climb (on the box)', 'push (the box)',
% 'grasp (the banana)'

% description of actions - The current state is stored using a functor 'state'
% with 4 arguments:
%	- horizontal position of the ape
%	- vertical position of the ape
%	- position of the box
%	- status of the banana
% 'action' has three arguments:
%	- Initial state
%	- Final state
%	- act
%

:- use_module(library(lists)).

action(state(middle,on_box,X,not_holding), grasp, state(middle,on_box,X,holding)).
action(state(X,floor,X,Y), climb, state(X,on_box,X,Y)).
action(state(X,floor,X,Z), push(X,Y), state(Y,floor,Y,Z)).
action(state(X,floor,T,Z), walk(X,Y), state(Y,floor,T,Z)).


success( state(_,_, _, holding), Plan):-
	write(Plan).
success( State1, Plan) :-
	action(State1, A, State2),
        write('Action : '), write(A), nl, write(' --> '), write(State2), nl,
	append(Plan, [A], L),
	success(State2, L).

go(Plan) :-
	success(state(door, floor, window, not_holding), Plan).

mirror2(Left, Right) :-
    invert(Left, [ ], Right).
invert([X|L1], L2, L3) :-    % the list is 'poured'
    invert(L1, [X|L2], L3).    % into the second argument
invert([ ], L, L).        % at the deepest level, the result L is merely copied

palindrome(P):-
	mirror2(P, R),
	P==R.

palindrome2(P):-
	invert2(P, []).
invert2([X|L1], L2):-
	invert2(L1, [X|L2]).
invert2(L,L).

myprint :-
    retract(item(X)), % reussit tant qu'il y a des items
    write(X),nl,
    fail.
myprint.

empty(X):-
	retract(X),
	fail.

findany(Var, Pred):-
	Pred,
	assert(found(Var)),
	fail.

collect_found([X|L]):-
	retract(found(X)),
	!,
	collect_found(L).
collect_found([]).
