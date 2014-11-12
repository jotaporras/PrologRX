PrologRX
========

Proyecto Paradigmas PrologRX 2014


10/11/14 - Jota

	Bueno gente con esto montamos la versión inicial del proyecto.
Basicamente lo que se tiene es todo lo que el profe ha dado, que sería:

** El servidor web de prolog
** La página HTML con las librerías para JQUERY y RXJS 
	la página la modifiqué para que ya sirviera lo de 
	crear arcos. Faltaría que pueda borrar arcos y obviamente
	que pueda hacer los requests ajax al servidor para ver si tiene
	los ciclos de Euler, esta es la parte complicadilla.
	Hay que usar el Framework RX para que cada vez que uno haga un 
	cambio en el canvas, envíe un request Ajax y revise si ahora sí hay
	un ciclo.
** La página HTML que hace todo lo que el canvas debería hacer (sin ajax obvio)
	esta la estuve analizando un poco y le puse bastantes comentarios
	talvez esto ayude a entender un poco mejor cómo funciona la vara.
** El archivo grafos.pl (segun el video) que prácticamente tiene los predicados necesarios
	para recibir el grafo a partir del objeto JSON y analizarlo para ver sitiene ciclos de Euler.
	
Esto sería lo que tenemos para empezar. Como ya le comenté a luis estos días 
voy a tener que hacer las tareas de algoritmos entre otras cosas, entonces talvez retome
el proyecto por ahí del viernes o sábado. Sería bueno que vayan avanzando mientras.	

******** Pablo - 11/11/14 *********
Sorry por la tardanza, metí un ejemplo de como crear un evento y el request de ajax, lo que nos importa es el archivo testHint.html, está muy simple pero podría funcionarnos para generar el nuestro, la diferencia sería que en este ejemplo es con el keyup, en nuestro caso sería con el release del mouse (no sé como se llamaba ese), puse todo el ejemplo, está en PHP para que sea más fácil correrlo. *No sé que tanto vieron ustedes de esto en progra 4*

