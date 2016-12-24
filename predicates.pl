%Parkin Alexander 424

edge(a,b,4).
edge(a,c,1).
edge(a,d,4).
edge(b,c,3).
edge(c,d,3).
edge(b,e,1).
edge(e,d,1).
edge(c,e,2).
edge(b,f,7).
edge(d,f,15).

connect(X,Y,W):-edge(X,Y,W); edge(Y,X,W).

%N=17(i,i,i),(i,i,o)

path_w(X,Y,L, WEIGHT):-	path1_w(X,Y,[],L,WEIGHT).

path1_w(X,Y,V,[X,Y],W):-	connect(X,Y,W),
							not(member(Y,V)).

path1_w(X,Y,V,[X,Z|L],WEIGHT):-	connect(X,Z,W),
								not(member(Z,V)),
								path1_w(Z,Y,[X|V],
								[Z|L],W1),
								WEIGHT is W+W1.

min_path(X,Y,List):-	findall(Path,path_w(X,Y,Path,Weight),Paths),
						findall(Weight,path_w(X,Y,Path,Weight),Weights), 
						min_list(Weights, Min_weight), 
						m_path(Paths,Weights,Min_weight, List).

m_path([X|_],[Min|_], Min, X).
m_path([X|[]], [Y|[]], Y, X).
m_path([_|XS], [_|YS], Min, Min_path) :- m_path(XS,YS,Min,Min_path). 

path_weight(X,Y,[X,Y],W):-connect(X,Y,W).

path_weight(X,Y,[X,X1|L],W):-	path_weight(X1,Y,[X1|L],W1),
								path_weight(X,X1,[X,X1],W2), 
								W is W1+W2.



%N=18(i,i,i),(i,i,o)

short_path(X, Y, Path) :- s_path(X, [[Y]], Path).

s_path(X, [[X | XS] | F], L) :-	!, length([X | XS], N),
    							find(F, N, Z),
    							member(L, [[X | XS] | Z]),
								first_elem(X, L).

s_path(X, [Y | YS], R) :-	findall(Z, sub_list(Y, Z), L), !,
    						append(YS, L, N),
    						s_path(X, N, R).

s_path(X, [_ | T], R) :- s_path(X, T, R).

find([X | XS], N, [X | L]) :-	length(X, N1),
    							N1 = N, !,
    							find(XS, N, L).

find(_, _, []).

first_elem(X, [X | _]).

sub_list([X | XS], [Y, X | XS]) :- connect(X, Y, _), not(member(Y, XS)).