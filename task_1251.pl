%Parkin Alexander 424

%main function
start(S) :- sentence(TREE,S,_), 
			add_empty(TREE, NORM_TREE), 
			draw_picture(NORM_TREE)
			.

%tree nodes normalize
add_empty(empty,empty):-!.
add_empty(node(X,L,R),node(X,NORML,NORMR)) :- 	parse(L,L2),
												parse(R,R2),
												add_empty(L2,NORML),
												add_empty(R2,NORMR),
												!.

parse(empty,empty).
parse(node(X,L),node(X,L,empty)).
parse(node(X,L,R),node(X,L,R)).
parse(X,node(X,empty,empty)).


%GUI
draw_picture(Tree) :- 
	new(Picture, picture('Обработка естественного языка')), 
	WIDTH is 5000, HEIGHT is 1000,
	send(Picture, width(WIDTH)), 
	send(Picture, height(HEIGHT)),
	draw(Tree, 0, WIDTH, 0, Picture),
	send(Picture, open).

draw(empty, _, _, _, _) :-
	!
	.

draw(node(X, empty, empty), LeftBound, RightBount, Top, Picture) :-
	send(Picture, display, text(X), point((LeftBound + RightBount) / 2 - 30, Top)),
	!
	.

draw(node(X, empty, R), LeftBound, RightBount, Top, Picture) :-
	send(Picture, display, text(X), point((LeftBound + RightBount) / 2 - 30, Top)),
	send(Picture, display, line((LeftBound + RightBount) / 2, Top + 25, (LeftBound + RightBount) / 2, Top + 50)),
	draw(R, LeftBound, RightBount, Top + 50, Picture),
	!
	.

draw(node(X, L, empty), LeftBound, RightBount, Top, Picture) :-
	send(Picture, display, text(X), point((LeftBound + RightBount) / 2 - 30, Top)),
	send(Picture, display, line((LeftBound + RightBount) / 2, Top + 25, (LeftBound + RightBount) / 2, Top + 50)),
	draw(L, LeftBound, RightBount, Top + 50, Picture),
	!
	.

draw(node(X, L, R), LeftBound, RightBount, Top, Picture) :-
	send(Picture, display, text(X), point((LeftBound + RightBount) / 2 - 30, Top)),
	send(Picture, display, line((LeftBound + RightBount) / 2, Top + 25, (3 * LeftBound + RightBount) / 4, Top + 50)),
	send(Picture, display, line((LeftBound + RightBount) / 2, Top + 25, (LeftBound + 3 * RightBount) / 4, Top + 50)),
	draw(L, LeftBound, (LeftBound + RightBount) / 2, Top + 50, Picture),
	draw(R, (LeftBound + RightBount) / 2, RightBount, Top + 50, Picture),
	!
	.


%sentence parsing
sentence(V) --> sentence(_,V).
sentence(X,node(предложение, NP, VP)) --> group_nouns(X,'именительный', SP, NP), group_verb(X, SP, VP).

group_nouns(X,CASE,node(группасуществительных, DETERMINATE, NOUN)) --> determinate_group(X, CASE, DETERMINATE), noun(X, CASE, NOUN).
group_nouns(X,CASE,node(группасуществительных, NOUN)) --> noun(X, CASE, NOUN).

determinate_group(X, CASE, node(группаопределителей, DETERMINATE, DETERMINATE_GROUP)) --> determinate(X, CASE, DETERMINATE), determinate_group(X, CASE, DETERMINATE_GROUP).
determinate_group(X, CASE, node(группаопределителей, DETERMINATE)) --> determinate(X, CASE, DETERMINATE).

group_verb(X, node(группаглаголов, ADVERB, GROUP_VERB)) --> adverb(X, ADVERB), group_verb(X, GROUP_VERB).
group_verb(X, node(группаглаголов, VERB, GROUP_NOUNS)) --> verb(X, VERB), group_next_nouns(X, GROUP_NOUNS). 
group_verb(X, node(группаглаголов, VERB)) --> verb(X, VERB).

group_next_nouns(X, node(группасуществительных, THIS_NOUN, NEXT_NOUNS)) --> group_other_nouns(X, THIS_NOUN), group_next_nouns(X, NEXT_NOUNS).
group_next_nouns(X, node(группасуществительных, NOUN)) --> group_other_nouns(X, NOUN).

group_other_nouns(X, node(группасуществительных, EXCUSE, NOUNS)) --> excuse(X, CASE, EXCUSE), group_nouns(X, CASE, NOUNS).


%rules
excuse(_,'родительный', node(предлог, с)) --> [с].
excuse(_,'родительный', node(предлог, по)) --> [по].
excuse(_,'родительный', node(предлог, без)) --> [без].
excuse(_,'родительный', node(предлог, вокруг)) --> [вокруг].
excuse(_,'родительный', node(предлог, для)) --> [для].
excuse(_,'родительный', node(предлог, до)) --> [до].
excuse(_,'родительный', node(предлог, из)) --> [из].
excuse(_,'родительный', node(предлог, от)) --> [от].

excuse(_,'дательный', node(предлог, к)) --> [к].
excuse(_,'дательный', node(предлог, благодаря)) --> [благодаря].
excuse(_,'дательный', node(предлог, согласно)) --> [согласно].

excuse(_,'винительный', node(предлог, в)) --> [в].
excuse(_,'винительный', node(предлог, под)) --> [под].
excuse(_,'винительный', node(предлог, с)) --> [с].
excuse(_,'винительный', node(предлог, по)) --> [по].
excuse(_,'винительный', node(предлог, за)) --> [за].
excuse(_,'винительный', node(предлог, про)) --> [про].
excuse(_,'винительный', node(предлог, сквозь)) --> [сквозь].
excuse(_,'винительный', node(предлог, через)) --> [через].

excuse(_,'творительный', node(предлог, с)) --> [с].
excuse(_,'творительный', node(предлог, по)) --> [по].
excuse(_,'творительный', node(предлог, под)) --> [под].
excuse(_,'творительный', node(предлог, за)) --> [за].	
excuse(_,'творительный', node(предлог, между)) --> [между].
excuse(_,'творительный', node(предлог, над)) --> [над].
excuse(_,'творительный', node(предлог, перед)) --> [перед].

excuse(_,'предложный', node(предлог, о)) --> [о].
excuse(_,'предложный', node(предлог, при)) --> [при].
excuse(_,'предложный', node(предлог, в)) --> [в].


determinate(_,'именительный', node(прилагательное,тупой)) --> [тупой].
determinate(_,'именительный', node(прилагательное,маленький)) --> [маленький].
determinate(_,'именительный', node(прилагательное,большая)) --> [большая].
determinate(_,'именительный', node(прилагательное,мягкий)) --> [мягкий].
determinate(_,'именительный', node(прилагательное,интересный)) --> [интересный].

determinate(_,'родительный', node(прилагательное,тупого)) --> [тупого].
determinate(_,'родительный', node(прилагательное,маленького)) --> [маленького].
determinate(_,'родительный', node(прилагательное,большой)) --> [большой].
determinate(_,'родительный', node(прилагательное,мягкого)) --> [мягкого].
determinate(_,'родительный', node(прилагательное,интересного)) --> [интересного].

determinate(_,'дательный', node(прилагательное,тупому)) --> [тупому].
determinate(_,'дательный', node(прилагательное,маленькому)) --> [маленькому].
determinate(_,'дательный', node(прилагательное,большой)) --> [большой].
determinate(_,'дательный', node(прилагательное,мягкому)) --> [мягкому].
determinate(_,'дательный', node(прилагательное,интересному)) --> [интересному].

determinate(_,'винительный', node(прилагательное,тупого)) --> [тупого].
determinate(_,'винительный', node(прилагательное,маленького)) --> [маленького].
determinate(_,'винительный', node(прилагательное,большую)) --> [большую].
determinate(_,'винительный', node(прилагательное,мягкого)) --> [мягкого].
determinate(_,'винительный', node(прилагательное,интересного)) --> [интересного].

determinate(_,'творительный', node(прилагательное,тупым)) --> [тупым].
determinate(_,'творительный', node(прилагательное,маленьким)) --> [маленьким].
determinate(_,'творительный', node(прилагательное,большой)) --> [большой].
determinate(_,'творительный', node(прилагательное,мягким)) --> [мягким].
determinate(_,'творительный', node(прилагательное,интересным)) --> [интересным].

determinate(_,'предложный', node(прилагательное,тупом)) --> [тупом].
determinate(_,'предложный', node(прилагательное,маленьком)) --> [маленьком].
determinate(_,'предложный', node(прилагательное,большом)) --> [большом].
determinate(_,'предложный', node(прилагательное,мягком)) --> [мягком].
determinate(_,'предложный', node(прилагательное,интересном)) --> [интересном].

adverb(_, node(наречие, долго)) --> [долго].
adverb(_, node(наречие, быстро)) --> [быстро].
adverb(_, node(наречие, неожиданно)) --> [неожиданно].
adverb(_, node(наречие, прямо)) --> [прямо].
adverb(_, node(наречие, весело)) --> [весело].

noun(_,'именительный', node(существительное, мальчик)) --> [мальчик].
noun(_,'именительный', node(существительное, студент)) --> [студент].
noun(_,'именительный', node(существительное, код)) --> [код].
noun(_,'именительный', node(существительное, сад)) --> [сад].
noun(_,'именительный', node(существительное, собака)) --> [собака].
noun(_,'именительный', node(существительное, зачет)) --> [зачет].

noun(_,'родительный', node(существительное, мальчика)) --> [мальчика].
noun(_,'родительный', node(существительное, студента)) --> [студента].
noun(_,'родительный', node(существительное, кода)) --> [кода].
noun(_,'родительный', node(существительное, сада)) --> [сада].
noun(_,'родительный', node(существительное, собаки)) --> [собаки].
noun(_,'родительный', node(существительное, зачета)) --> [зачета].

noun(_,'дательный', node(существительное, мальчику)) --> [мальчику].
noun(_,'дательный', node(существительное, студенту)) --> [студенту].
noun(_,'дательный', node(существительное, коду)) --> [коду].
noun(_,'дательный', node(существительное, саду)) --> [саду].
noun(_,'дательный', node(существительное, собаке)) --> [собаке].
noun(_,'дательный', node(существительное, зачету)) --> [зачету].

noun(_,'винительный', node(существительное, мальчика)) --> [мальчика].
noun(_,'винительный', node(существительное, студента)) --> [студента].
noun(_,'винительный', node(существительное, код)) --> [код].
noun(_,'винительный', node(существительное, сад)) --> [сад].
noun(_,'винительный', node(существительное, собаку)) --> [собаку].
noun(_,'винительный', node(существительное, зачет)) --> [зачет].

noun(_,'творительный', node(существительное, мальчиком)) --> [мальчиком].
noun(_,'творительный', node(существительное, студентом)) --> [студентом].
noun(_,'творительный', node(существительное, кодом)) --> [кодом].
noun(_,'творительный', node(существительное, садом)) --> [садом].
noun(_,'творительный', node(существительное, собакой)) --> [собакой].
noun(_,'творительный', node(существительное, зачетом)) --> [зачетом].

noun(_,'предложный', node(существительное, мальчике)) --> [мальчике].
noun(_,'предложный', node(существительное, студенте)) --> [студенте].
noun(_,'предложный', node(существительное, коде)) --> [коде].
noun(_,'предложный', node(существительное, саду)) --> [саду].
noun(_,'предложный', node(существительное, собаке)) --> [собаке].
noun(_,'предложный', node(существительное, зачете)) --> [зачете].

verb(_, node(глагол, пишет)) --> [пишет].
verb(_, node(глагол, мучается)) --> [мучается].
verb(_, node(глагол, сдает)) --> [сдает].
verb(_, node(глагол, бегает)) --> [бегает].
verb(_, node(verb, играет)) --> [играет].
verb(_, node(глагол, помогает)) --> [помогает].