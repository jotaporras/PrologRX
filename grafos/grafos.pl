

%Esto es como suponiendo que ya me lo están pasando decodificado del JSON.

:- dynamic edge/4, node/2, degree/3.
%node(grafo,nombre)
%edge(grafo,arco,izquierdo,derecho)
%degree(grafo,nodo,d)
%Defínase grado como la cantidad de arcos que tiene.

%nodos
node(g1,n0).
node(g1,n1).
node(g1,n2).
node(g1,n3).
node(g1,n4).
node(g1,n5).

%nodo aislado para probar is_connected.
%node(g1,n6).

%11 arcos
edge(g1,l,n0,n0). 
edge(g1,m,n0,n0). 


edge(g1,b,n0,n1).
edge(g1,e,n0,n2).
edge(g1,d,n0,n4).
edge(g1,a,n0,n5).
edge(g1,f,n1,n2).
edge(g1,g,n1,n3).
edge(g1,c,n1,n4).
edge(g1,h,n2,n3).
edge(g1,i,n2,n4).
edge(g1,j,n3,n4).
edge(g1,k,n3,n5).

/*
Buscamos todos los arcos que tienen N como salida, el 1 en findall no sé para q es,
retorno el largo de la lista.
*/

%Graph,Node,MNode,Edge
adjacent(G,N,M,E) :-  edge(G,E,N,M);edge(G,E,M,N). 
find_proper_edge(G,N,E,M) :-  adjacent(G,N,M,E),M \= N.

find_loop_edge(G,N,E) :-edge(G,E,N,N).

%Graph,Node,Degree
find_proper_degree_node(G,N,D) :- node(G,N), findall(1,find_proper_edge(G,N,_,_),L), length(L,D).
find_loop_degree_node(G,N,D) :- node(G,N), 
					findall(1,find_loop_edge(G,N,_),L),
					length(L,K),
					D is K + K.
find_degree_node(G,N,D) :- find_loop_degree_node(G,N,DL),find_proper_degree_node(G,N,DP),D is DL+DP.

generate_degrees(G) :- 	retractall(degree(_,_,_)), %Borra todos los que tenga para crearlos de nuevo.
						forall(find_degree_node(G,N,D),assert(degree(G,N,D))).
%este lo hice yo para ver la lista de los grados de todos los nodos
list_all_degrees(L):- findall([Node,Degree],degree(g1,Node,Degree),L).

%Ciclos de euler
has_euler(G) :- generate_degrees(G),
				forall(degree(G,_,D),0 is mod(D,2)).
:- dynamic stack/1, visited/1, tree/3.
%depth first search
dfs(G,N) :- retractall(stack(_)), retractall(visited(_)), retractall(tree(_,_,_)),
			assert(stack(N)),	
			dfs(G).
dfs(G) :- 	retract(stack(N)),
			not(visited(N)),assert(visited(N)),
			forall( (adjacent(G,N,M,_) , not(visited(M)) ),
				(asserta(stack(M)),assert(tree(G,N,M)))
			),
			dfs(G). %el fail no funcionaria aca si estoy usando el retract. es una optimizacion.
dfs(_).
				
				
is_connected(G) :-	node(G,N),!,dfs(G,N),
					forall(node(G,M),visited(M)). %todos deben haber sido visitados por el dfs.
					



  
