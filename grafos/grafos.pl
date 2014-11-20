

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
node(g2,n0).%Segundo grafo
node(g2,n1).
node(g2,n2).
node(g2,n3).
node(g2,n4).
node(g3,n0).%Tercer grafo
node(g3,n1).
node(g3,n2).
node(g4,n0).%Cuarto grafo
node(g4,n1).
node(g4,n2).
node(g4,n3).
node(g4,n4).
node(g4,n5).
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
edge(g2,a,n0,n1). %Segundo grafo.
edge(g2,b,n1,n2). 
edge(g2,e,n0,n2).
edge(g2,c,n2,n3).
edge(g2,d,n3,n0).
edge(g3,a,n0,n1). %Tercer grafo.
edge(g3,b,n1,n2). 
edge(g4,a,n0,n1). %Cuarto grafo
edge(g4,b,n1,n2). %Cuarto grafo
edge(g4,c,n2,n3). %Cuarto grafo
edge(g4,d,n3,n0). %Cuarto grafo
edge(g4,e,n2,n4). %Cuarto grafo
edge(g4,f,n4,n5). %Cuarto grafo
edge(g4,g,n5,n2). %Cuarto grafo
%Grafo para probar una cosa


/*
Buscamos todos los arcos que tienen N como salida, el 1 en findall no sé para q es,
retorno el largo de la lista.
*/

%Graph,Node,MNode,Edge
%N y M son adyacentes
adjacent(G,N,M,E) :-  edge(G,E,N,M);edge(G,E,M,N). 
contains_node(G,N,E) :- edge(G,E,N,_);edge(G,E,_,N).
%Proper edge = not a loop
find_proper_edge(G,N,E,M) :-  adjacent(G,N,M,E),M \= N.

find_loop_edge(G,N,E) :-edge(G,E,N,N).

%Graph,Node,Degree
%Proper degree node: how many proper edges containing that node in total.
%Loop degree node: how many loop edges for that node. Counts twice for every loop.
%Degree node: total degree of that node
find_proper_degree_node(G,N,D) :- node(G,N), findall(1,find_proper_edge(G,N,_,_),L), length(L,D).
find_loop_degree_node(G,N,D) :- node(G,N), 
					findall(1,find_loop_edge(G,N,_),L),
					length(L,K),
					D is K + K.	
find_degree_node(G,N,D) :- find_loop_degree_node(G,N,DL),find_proper_degree_node(G,N,DP),D is DL+DP.

%generate all the degrees and put them in dynamic predicados.
generate_degrees(G) :- 	retractall(degree(_,_,_)), %Borra todos los que tenga para crearlos de nuevo.
						forall(find_degree_node(G,N,D),assert(degree(G,N,D))).
%este lo hice yo para ver la lista de los grados de todos los nodos
list_all_degrees(L):- findall([Node,Degree],degree(g1,Node,Degree),L).

%Ciclos de euler
%
has_euler(G) :- generate_degrees(G),
				forall(degree(G,_,D),0 is mod(D,2)).
:- dynamic stack/1, visited/1, tree/3,visitedEdge/1,routeLoop/3.
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
dfs(_).%End of branch if no match, look for other solutions?
							
is_connected(G) :-	node(G,N),!,dfs(G,N),
					forall(node(G,M),visited(M)). %todos deben haber sido visitados por el dfs.
					
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MY Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
:- dynamic tour/1,drawn/1.%Drawn for edges that are included in the cycle			
%isCycle(+Graph,+InitialNode,+ActualNode,+ListOfEdges).'
isCycle(G,S,[E|R]) :- adjacent(G,S,M,E),isCycle(G,S,M,R). %condicion inicial, la lista no puede estar vacia en este punto.
isCycle(G,S,N,[E|R]) :- adjacent(G,N,M,E),isCycle(G,S,M,R).
isCycle(_,S,S,[]).

%Finds all the loops starting from that point. Has a bug (doesnt find all solutions)
find_loops(G,N) :- retractall(stack(_)),retractall(visited(_)),retractall(visitedEdge(_)),retractall(routeLoop(G,N,_)),
					 assert(stack(N)),find_loops(G,N,[]).
find_loops(G,S,Aux) :- isCycle(G,S,Aux),reverse(Aux,D),assert(routeLoop(G,S,D)),!.
find_loops(G,S,[]) :- retract(stack(N)),(find_proper_edge(G,N,E,M);find_proper_edge(G,M,E,N)),assert(visited(N)),asserta(stack(M)),find_loops(G,S,[E]).
find_loops(G,S,[P|Aux]) :- retract(stack(N)),
						(find_proper_edge(G,N,_,_);find_proper_edge(G,_,_,N)),
						not(visited(N)),assert(visited(N)),
						forall((find_proper_edge(G,N,E,M),(not(visited(M));M = S),not(visitedEdge(E)),E\=P,not(drawn(E))),
							(asserta(stack(M)),assert(visitedEdge(E)),find_loops(G,S,[E|[P|Aux]]),retract(visitedEdge(E)),retract(visited(M)))
						).
						

has_all_edges(G,R) :- 	forall(edge(G,E,_,_),(
							edge(G,E,_,_),member(E,R)
)).
%has_all_edges(G,[]) :- not(edge(G,_,_,_)).

%add_tour(+Graph,+RouteCycle) --NOT TESTED

add_tour(G,R) :-	retractall(tour(_)), 
					forall((member(E,R),edge(G,E,N,_),not(tour(N))),
					(assert(tour(N)),assert(drawn(e)))
				).

%find a cycle of undrawn edges starting from N and put between the two edges that contain N.
%[a,b,c,d] [x,y,z]--> [a,b,c,[x,y,z],d] --> [a,b,x,y,z,d]
insert_between(G,Node,SCirc,[E|[R|RLCirc]],[E|Out]) :- not(((edge(G,E,Node,_);edge(G,E,_,Node)),(edge(G,R,_,Node);(edge(G,R,Node,_))))),!,insert_between(G,Node,SCirc,[R|RLCirc],Out).
insert_between(_,_,SCirc,[E|RLCirc],Aux2) :- Aux=[E|[SCirc|RLCirc]], flatten(Aux,Aux2).


%extend_list(G,N,D) :-

%Where do you want it to start.
generate_euler_cycle(G,N,L) :- retractall(drawn(_)),find_euler_cycle(G,N,L).
find_euler_cycle(G,N,L) :-  find_loops(G,N),
							retractall(visited(_)),retractall(visitedEdge(_)),retractall(stack(_)),%limpiando las variables despues de loop.
							retract(routeLoop(G,S,[FE|D]),
							add_tour(G,[FE|D]),
							fetch_tour_nodes(ListTourNodes),
							expand_tour(G,N,FE,ListTourNodes,L).

fetch_tour_nodes(ListTourNodes) :- 	findall(NodoTour,tour(NodoTour),ListTourNodes).					
							
expand_tour(G,N,_,L) :- 		fetch_tour_nodes(LTour), has_all_edges(G,LTour), L = LTour.					.
expand_tour(G,N,FE,L) :- 		find_loops(G,M),retract(routeLoop(G,M,D)),
								fetch_tour_nodes(LTour),
								insert_between(G,M,D,LTour,Out),add_tour(G,Out)
								expand_tour(G,N,L).

								forall(member(M,LTour),(	
										find_loops(G,M),
										retract(routeLoop(G,M,D)),
										add_tour(G,D),insert_between(G,M,D,ListaTour,Out)
									)
								).						
						%,hierholzer_concat(G,N,D,L).
%hierholzer_concat(+Graph,+Node,+Decoy Cycle,-L)
/*
hierholzer_concat(G,N,D,L) :- has_all_edges(G,D),!, L is D.%FALTA.
hierholzer_concat(G,N,D,L) :- 	retract(tour(M)),
								find_proper_edge(G,E,M,_),not(drawn(e)),
								find_loops(G,M),extend_list(G,M,D).


*/