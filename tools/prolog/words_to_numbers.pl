% Copies lines from STDIN to STDOUT rewriting "numbers by words" as "numbers by digits".
% Requires SWI-Prolog.
%
% Author: Kaarel Kaljurand
% Version: 2012-01-03

% Recognizes and rewrites the word representation of Estonian
% numbers that stand for integers (-10^6,10^6) and
% numbers of the form N.M where
% N is an integer (-10^6,10^6) and
% M is an integer [0,10^6) (i.e. M cannot be a string like "007").

% Eelneva arvsõnaga kokku kirjutatakse sõnad -teist(kümmend), -kümmend ja -sada.
% Muud arvsõnad kirjutatakse eelnevast arvsõnast lahku.

% Usage:
% echo "Mustamäe tee sada kolmkümmend üks koma seitseteist kolmas korrus" |
%   swipl -f words_to_numbers.pl -g main -t halt -q
% Mustamäe tee 131.17 kolmas korrus
%
% Generating and printing out all natural numbers (n_N) (~77MB of data):
%
% time swipl -f words_to_numbers.pl -g print_all -t halt -q > out_swi.txt
% time yap -l words_to_numbers.pl -g print_all -q > out_yap.txt
%
% SWI (v5.11.22) = 15sec, Yap (v6.2.1) = 5sec (!!!).
% Although Yap seems to be much faster, we cannot use it yet because
% read_line_to_codes(user_input) on Yap does not
% seem to understand utf8, e.g. ü maps to two codes instead of just one.
% (Note that Yap does not support set_stream/2 yet either.)
%
% Try: yap -l words_to_numbers.pl -g main -q

% Notes:
%
% - supports only the nominative singular case
% - supports: ükssada (100), üks tuhat (1000)
% - "tuhat sada" parses into "1100" rather than "1000 100"

% TODO:
% - investigate the problem of "out of local stack" after 103548, with
% swipl -f words_to_numbers.pl -g print_all -t halt -q | swipl -f words_to_numbers.pl -g main -t halt -q
% - support: yap with tabling (may be much faster)
% - support: rational numbers ("pool", "veerand", "neli kolmandikku")
% - support: numbers in other cases than nominative
% - support: ordinals
% - support: punctuation, i.e. don't consume dots and commas as part of words
% - cleanup: it's probably possible to write this DCG in a nicer/shorter way
%

% The readutil-library provides 'read_line_to_codes'.
% According to the SWI-Prolog manual, the predicates of this library
% perform better if the clib-package is installed because in this case
% the C implementation of these predicates is used.
% Yap also has this library (but it cannot autoload it that is why we declare it here).
:- use_module(library(readutil)).

% The encoding of this file.
:- encoding(utf8).

% In Yap this is by default "fail" which is very confusing.
%:- set_prolog_flag(unknown, error).

% The default encoding of text-streams.
:- set_prolog_flag(encoding, utf8).

main :-
	prompt(_, ''),
	%set_stream_encoding(user_input, utf8),
	%set_stream_encoding(user_output, utf8),
	main_loop.

main_loop :-
	read_line_to_codes(user_input, Codes),
	Codes \= end_of_file,
	phrase(tokens(Tokens), Codes),
	atomic_list_concat(Tokens, ' ', Output),
	format('~w~n', [Output]),
	main_loop ; true.


% There must always be whitespace between two tokens.
tokens([]) --> [].
tokens([T]) --> token(T).
tokens([T1, T2 | Ts]) -->
	ws(_), token(T1), ws(1),
	!,
	tokens([T2 | Ts]).


ws(1) --> [C], { code_type(C, space) }, ws(_).
ws(0) --> [].


token(T) --> n_Q_neg(T).
token(T) --> word(T).

word('.') --> "punkt".
word('?') --> "küsimärk".
word('!') --> "hüüumärk".
word(',') --> "koma".
word(':') --> "koolon".
word(';') --> "semikoolon".
word(Word) --> letters([C | Cs]), { atom_codes(Word, [C | Cs]) }.

letters([C | Cs]) --> letter(C), letters(Cs).
letters([]) --> [].

% letter//1 consumes possibly several codes rewriting them into a single code.
letter(C) --> caron([C]).
letter(C) --> [C], { \+ code_type(C, space) }.

% caron//1 rewrites caron-letters.
% comment out calls to this rule if you do not want this rewriting.
caron("Š") --> "S~".
caron("š") --> "s~".
caron("Ž") --> "Z~".
caron("ž") --> "z~".


% Rule order is important.
% We need to consume the longest number possible.

n_Q_neg(N) --> miinus, space, n_Q(N1), { atomic_list_concat(['-', N1], N) }.
n_Q_neg(N) --> n_Q(N).

n_Q(N) --> n_N(N1), space, koma, space, n_N(N2), { atomic_list_concat([N1, '.', N2], N) }.
n_Q(N) --> n_N(N).

n_N(0) --> "null".
n_N(N) --> n_1_to_999(N1), space, tuhat, space, n_1_to_999(N2), { N is N1 * 1000 + N2 }.
n_N(N) --> n_1_to_999(N1), space, tuhat, { N is N1 * 1000 }.
n_N(N) --> tuhat, space, n_1_to_999(N2), { N is 1000 + N2 }.
n_N(1000) --> tuhat.
n_N(N) --> n_1_to_999(N).

n_1_to_999(N) --> n_1_to_99(N).
n_1_to_999(N) --> sada(S), space, n_1_to_99(N1), { plus(S, N1, N) }.
n_1_to_999(N) --> sada(N).

n_1_to_99(N) --> n_1_9(N).
n_1_to_99(10) --> "kümme".
n_1_to_99(N) --> n_11_19(N).
n_1_to_99(N) --> kymmend(N1), space, n_1_9(N2), { plus(N1, N2, N) }.
n_1_to_99(N) --> kymmend(N).

n_1_9(1) --> "üks".
n_1_9(N) --> n_2_9(N).

n_2_9(2) --> "kaks".
n_2_9(3) --> "kolm".
n_2_9(4) --> "neli".
n_2_9(5) --> "viis".
n_2_9(6) --> "kuus".
n_2_9(7) --> "seitse".
n_2_9(8) --> "kaheksa".
n_2_9(9) --> "üheksa".

n_11_19(N) --> n_1_9(N1), "teist", { plus(N1, 10, N) }.
kymmend(N) --> n_2_9(N1), "kümmend", { N is N1 * 10 }.
sada(N) --> n_1_9(N1), "sada", { N is N1 * 100 }.
sada(100) --> "sada".

tuhat --> "tuhat".
miinus --> "miinus".
koma --> "koma".
space --> " ".


%% print_all
%
% Prints out everything that the grammar can generate.
% Useful for testing.
%
print_all :-
	phrase(n_N(N), Cs),
	atom_codes(A, Cs),
	format('~w\t~w~n', [N, A]),
	fail; true.


%% set_stream_encoding(+Stream, +Enc)
%
% Sets the encoding of the given stream.
%
% @param Enc is in {utf8, ...}
%
set_stream_encoding(Stream, Enc) :-
	set_stream(Stream, encoding(Enc)).
