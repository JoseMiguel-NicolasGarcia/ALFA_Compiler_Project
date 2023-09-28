.PHONY: alfa clean all

all: clean alfal alfay y.tab.o lex.yy.o tablaSimbolos.o tablaHash.o generacion.o alfa

alfa: y.tab.o lex.yy.o tablaSimbolos.o tablaHash.o generacion.o
	gcc -g  -o alfa alfa.c y.tab.o lex.yy.o tablaSimbolos.o tablaHash.o generacion.o

generacion.o: generacion.c generacion.h
	gcc -g  -c generacion.c

symbolTable.o: tablaSimbolos.c tablaSimbolos.h
	gcc -g  -c tablaSimbolos.c

hashTable.o: tablaHash.c tablaHash.h
	gcc -g  -c tablaHash.c
	
alfay: alfa.y
	bison -d -y -v alfa.y

alfal: alfa.l
	flex alfa.l

lex.yy.o: lex.yy.c
	gcc -g  -c lex.yy.c

y.tab.o: y.tab.h y.tab.c
	gcc -g  -c y.tab.c
	
clean:
	rm -rf  tablaSimbolos.o tablaHash.o generacion.o  y.tab.h y.output *.txt alfa y.tab.o lex.yy.o pruebaSintactico lex.yy.c y.tab.c
