#include "tablaHash.h"

/*Funciones de creacion*/
int crearTablaSimbolos();
void eliminarTablasSimbolos();


/*Funciones encargadas del scope*/
int crearScope(char *id, int valor, int tipo);
void borrarScope();


/*Funciones de insercion y busqueda*/
Simbolo* buscarSimboloenTS(char *id);
Simbolo * buscarSimboloenTS_local(char *id);
int insertarSimboloTS(char *id, int tipo_data, int tipo_variable, int categoria, int valor);
