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
	new(Picture, picture('��������� ������������� �����')), 
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
sentence(X,node(�����������, NP, VP)) --> group_nouns(X,'������������', SP, NP), group_verb(X, SP, VP).

group_nouns(X,CASE,node(���������������������, DETERMINATE, NOUN)) --> determinate_group(X, CASE, DETERMINATE), noun(X, CASE, NOUN).
group_nouns(X,CASE,node(���������������������, NOUN)) --> noun(X, CASE, NOUN).

determinate_group(X, CASE, node(�������������������, DETERMINATE, DETERMINATE_GROUP)) --> determinate(X, CASE, DETERMINATE), determinate_group(X, CASE, DETERMINATE_GROUP).
determinate_group(X, CASE, node(�������������������, DETERMINATE)) --> determinate(X, CASE, DETERMINATE).

group_verb(X, node(��������������, ADVERB, GROUP_VERB)) --> adverb(X, ADVERB), group_verb(X, GROUP_VERB).
group_verb(X, node(��������������, VERB, GROUP_NOUNS)) --> verb(X, VERB), group_next_nouns(X, GROUP_NOUNS). 
group_verb(X, node(��������������, VERB)) --> verb(X, VERB).

group_next_nouns(X, node(���������������������, THIS_NOUN, NEXT_NOUNS)) --> group_other_nouns(X, THIS_NOUN), group_next_nouns(X, NEXT_NOUNS).
group_next_nouns(X, node(���������������������, NOUN)) --> group_other_nouns(X, NOUN).

group_other_nouns(X, node(���������������������, EXCUSE, NOUNS)) --> excuse(X, CASE, EXCUSE), group_nouns(X, CASE, NOUNS).


%rules
excuse(_,'�����������', node(�������, �)) --> [�].
excuse(_,'�����������', node(�������, ��)) --> [��].
excuse(_,'�����������', node(�������, ���)) --> [���].
excuse(_,'�����������', node(�������, ������)) --> [������].
excuse(_,'�����������', node(�������, ���)) --> [���].
excuse(_,'�����������', node(�������, ��)) --> [��].
excuse(_,'�����������', node(�������, ��)) --> [��].
excuse(_,'�����������', node(�������, ��)) --> [��].

excuse(_,'���������', node(�������, �)) --> [�].
excuse(_,'���������', node(�������, ���������)) --> [���������].
excuse(_,'���������', node(�������, ��������)) --> [��������].

excuse(_,'�����������', node(�������, �)) --> [�].
excuse(_,'�����������', node(�������, ���)) --> [���].
excuse(_,'�����������', node(�������, �)) --> [�].
excuse(_,'�����������', node(�������, ��)) --> [��].
excuse(_,'�����������', node(�������, ��)) --> [��].
excuse(_,'�����������', node(�������, ���)) --> [���].
excuse(_,'�����������', node(�������, ������)) --> [������].
excuse(_,'�����������', node(�������, �����)) --> [�����].

excuse(_,'������������', node(�������, �)) --> [�].
excuse(_,'������������', node(�������, ��)) --> [��].
excuse(_,'������������', node(�������, ���)) --> [���].
excuse(_,'������������', node(�������, ��)) --> [��].	
excuse(_,'������������', node(�������, �����)) --> [�����].
excuse(_,'������������', node(�������, ���)) --> [���].
excuse(_,'������������', node(�������, �����)) --> [�����].

excuse(_,'����������', node(�������, �)) --> [�].
excuse(_,'����������', node(�������, ���)) --> [���].
excuse(_,'����������', node(�������, �)) --> [�].


determinate(_,'������������', node(��������������,�����)) --> [�����].
determinate(_,'������������', node(��������������,���������)) --> [���������].
determinate(_,'������������', node(��������������,�������)) --> [�������].
determinate(_,'������������', node(��������������,������)) --> [������].
determinate(_,'������������', node(��������������,����������)) --> [����������].

determinate(_,'�����������', node(��������������,������)) --> [������].
determinate(_,'�����������', node(��������������,����������)) --> [����������].
determinate(_,'�����������', node(��������������,�������)) --> [�������].
determinate(_,'�����������', node(��������������,�������)) --> [�������].
determinate(_,'�����������', node(��������������,�����������)) --> [�����������].

determinate(_,'���������', node(��������������,������)) --> [������].
determinate(_,'���������', node(��������������,����������)) --> [����������].
determinate(_,'���������', node(��������������,�������)) --> [�������].
determinate(_,'���������', node(��������������,�������)) --> [�������].
determinate(_,'���������', node(��������������,�����������)) --> [�����������].

determinate(_,'�����������', node(��������������,������)) --> [������].
determinate(_,'�����������', node(��������������,����������)) --> [����������].
determinate(_,'�����������', node(��������������,�������)) --> [�������].
determinate(_,'�����������', node(��������������,�������)) --> [�������].
determinate(_,'�����������', node(��������������,�����������)) --> [�����������].

determinate(_,'������������', node(��������������,�����)) --> [�����].
determinate(_,'������������', node(��������������,���������)) --> [���������].
determinate(_,'������������', node(��������������,�������)) --> [�������].
determinate(_,'������������', node(��������������,������)) --> [������].
determinate(_,'������������', node(��������������,����������)) --> [����������].

determinate(_,'����������', node(��������������,�����)) --> [�����].
determinate(_,'����������', node(��������������,���������)) --> [���������].
determinate(_,'����������', node(��������������,�������)) --> [�������].
determinate(_,'����������', node(��������������,������)) --> [������].
determinate(_,'����������', node(��������������,����������)) --> [����������].

adverb(_, node(�������, �����)) --> [�����].
adverb(_, node(�������, ������)) --> [������].
adverb(_, node(�������, ����������)) --> [����������].
adverb(_, node(�������, �����)) --> [�����].
adverb(_, node(�������, ������)) --> [������].

noun(_,'������������', node(���������������, �������)) --> [�������].
noun(_,'������������', node(���������������, �������)) --> [�������].
noun(_,'������������', node(���������������, ���)) --> [���].
noun(_,'������������', node(���������������, ���)) --> [���].
noun(_,'������������', node(���������������, ������)) --> [������].
noun(_,'������������', node(���������������, �����)) --> [�����].

noun(_,'�����������', node(���������������, ��������)) --> [��������].
noun(_,'�����������', node(���������������, ��������)) --> [��������].
noun(_,'�����������', node(���������������, ����)) --> [����].
noun(_,'�����������', node(���������������, ����)) --> [����].
noun(_,'�����������', node(���������������, ������)) --> [������].
noun(_,'�����������', node(���������������, ������)) --> [������].

noun(_,'���������', node(���������������, ��������)) --> [��������].
noun(_,'���������', node(���������������, ��������)) --> [��������].
noun(_,'���������', node(���������������, ����)) --> [����].
noun(_,'���������', node(���������������, ����)) --> [����].
noun(_,'���������', node(���������������, ������)) --> [������].
noun(_,'���������', node(���������������, ������)) --> [������].

noun(_,'�����������', node(���������������, ��������)) --> [��������].
noun(_,'�����������', node(���������������, ��������)) --> [��������].
noun(_,'�����������', node(���������������, ���)) --> [���].
noun(_,'�����������', node(���������������, ���)) --> [���].
noun(_,'�����������', node(���������������, ������)) --> [������].
noun(_,'�����������', node(���������������, �����)) --> [�����].

noun(_,'������������', node(���������������, ���������)) --> [���������].
noun(_,'������������', node(���������������, ���������)) --> [���������].
noun(_,'������������', node(���������������, �����)) --> [�����].
noun(_,'������������', node(���������������, �����)) --> [�����].
noun(_,'������������', node(���������������, �������)) --> [�������].
noun(_,'������������', node(���������������, �������)) --> [�������].

noun(_,'����������', node(���������������, ��������)) --> [��������].
noun(_,'����������', node(���������������, ��������)) --> [��������].
noun(_,'����������', node(���������������, ����)) --> [����].
noun(_,'����������', node(���������������, ����)) --> [����].
noun(_,'����������', node(���������������, ������)) --> [������].
noun(_,'����������', node(���������������, ������)) --> [������].

verb(_, node(������, �����)) --> [�����].
verb(_, node(������, ��������)) --> [��������].
verb(_, node(������, �����)) --> [�����].
verb(_, node(������, ������)) --> [������].
verb(_, node(verb, ������)) --> [������].
verb(_, node(������, ��������)) --> [��������].