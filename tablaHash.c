#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include "tablaHash.h"

/*FUNCIONES DE CREACIÓN*/

Simbolo *crearSimbolo(int categoria, int tipo_data, int tipo_variable, char *id, int posicion, int numero_variables, int valor,int numero_parametros, int posicion_parametros)
{
    Simbolo *simb = (Simbolo *)malloc(sizeof(Simbolo));
    if (simb == NULL)
    {
        printf("Ha habido un error en la reserva de memoria del simbolo.\n");
        return NULL;
    }

    if (id == NULL)
    {
        printf("No has pasado un identificador.\n");
        return NULL;
    }
    else
    {
        simb->id = strdup(id);
        if (!simb->id)
        {
            printf("Fallo al hacer strdrup del id.\n");
            return NULL;
        }

        simb->categoria = categoria;
        simb->tipo_data = tipo_data;
        simb->tipo_variable = tipo_variable;
        simb->posicion = posicion;
        simb->numero_variables = numero_variables;
        simb->posicion_parametros=posicion_parametros;
        simb->valor = valor;
        simb->numero_parametros;
    }
    return simb;
}

ColumnaSimbolo *crearColumnaSimbolo()
{
    ColumnaSimbolo *columnaSimbolo = (ColumnaSimbolo *)malloc(sizeof(ColumnaSimbolo));
    if (columnaSimbolo == NULL)
    {
        printf("Ha habido un error en la reserva de memoria de la columna.\n");
        return NULL;
    }
    else
    {
        columnaSimbolo->elementos_columna = 0;
        columnaSimbolo->columna = NULL;
    }

    return columnaSimbolo;
}


TablaHash *crearTablaHash(int elementos_tabla)
{
    int j = 0;

    TablaHash *tablaHash = (TablaHash *)malloc(sizeof(TablaHash));
    if (tablaHash == NULL)
    {
        printf("Fallo en la reserva de la memoria de la Tabla Hash\n");
        return NULL;
    }
    else
    {
        tablaHash->tabla = (ColumnaSimbolo **)malloc(sizeof(ColumnaSimbolo *) * elementos_tabla);
        tablaHash->elementos_tabla = elementos_tabla;

        if (tablaHash->tabla == NULL)
        {
            return NULL;
        }
        else
        {
            for (j = 0; j < tablaHash->elementos_tabla; ++j)
            {
                tablaHash->tabla[j] = crearColumnaSimbolo();
            }
        }
    }

    return tablaHash;
}

/*FUNCIONES DE LIBERACIÓN*/


void liberarSimbolo(Simbolo *simb)
{
 if (simb == NULL)
    {
        return;
    }
    if (simb->id != NULL)
    {
        free(simb->id);
        simb->id = NULL;
    }

    free(simb);
}

void liberarColumnaSimbolo(ColumnaSimbolo *columna)
{
   int j = 0;

    if (columna == NULL)
    {
        return;
    }
    else
    {

        for (j = 0; j < columna->elementos_columna; ++j)
        {
            liberarSimbolo(columna->columna[j]);
            columna->columna[j] = NULL;
        }

        free(columna->columna);
        free(columna);
    }
}



void liberarTablaHash(TablaHash *tabla)
{
  int j = 0;

    if (tabla == NULL)
    {
        return;
    }
    else
    {
        for (j = 0; j < tabla->elementos_tabla; ++j)
        {
            tabla->tabla[j] = NULL;
            liberarColumnaSimbolo(tabla->tabla[j]);
        }

        free(tabla->tabla);
        free(tabla);
    }
    return;
}

/*FUNCIONES HASH*/

/*Funcion de creacion codigo hash busada en internet*/
/*it-swarm-es.com*/
long funcionHash(unsigned char *str)
{
    unsigned long clave_hash = CANTIDAD_MAXIMA;
    long out;
    int aux;

    while (aux = *str++)
    {
        clave_hash = ((clave_hash << 5) + clave_hash) + aux;
    }
    out = clave_hash % CANTIDAD_MAXIMA;

    return out;
}

/*FUNCIONES DE BUSQUEDA*/
int buscarSimbolo(char *id, ColumnaSimbolo *columna)
{
    int j = 0;

    if (id != NULL && columna != NULL)
    {
        for (j = 0; j < columna->elementos_columna; ++j)
        {
            if (strcmp(id, (columna->columna[j]->id)) == 0)
            {
                return j;
            }
        }
    }

    return -1;
}

Simbolo *buscarenTabla(char *simbolo, TablaHash *tabla)
{
    int hash, i;

    if (tabla != NULL && simbolo != NULL)
    {

        hash = funcionHash(simbolo);

        ColumnaSimbolo *columna = tabla->tabla[hash];
        i = buscarSimbolo(simbolo, columna);

        if (i == -1)
        {
            return NULL;
        }

        return columna->columna[i];
    }

    return NULL;
}

/* FUNCIONES DE INSERCIÓN*/

int insertarSimbolo(ColumnaSimbolo *columna, Simbolo *simbolo)
{
   if (simbolo != NULL && columna != NULL)
    {
        if ((columna->columna) != NULL)
        { //Por si ya contuviese algo, se añade otro elemento

            columna->columna = (Simbolo **)realloc(columna->columna, sizeof(Simbolo *) * (columna->elementos_columna + 1));
        }
        else //En caso de que este vacia simplemente se inicializa
        {
            columna->columna = (Simbolo **)malloc(sizeof(Simbolo *));
        }

        if (!columna->columna) //Comprobamos que se haya iniciado bien
        {
            return -1;
        }

        columna->columna[columna->elementos_columna] = simbolo;

        ++(columna->elementos_columna);

        return 0;
    }
    return -1;
}


int insertarTabla(TablaHash *tabla, Simbolo *simbolo)
{
    int i = 0;

    if (tabla != NULL && simbolo != NULL)
    {
        i = funcionHash(simbolo->id);

       ColumnaSimbolo *columna = tabla->tabla[i];

        if (buscarSimbolo(simbolo->id, columna) == -1)
        {
            insertarSimbolo(columna, simbolo);
            return 0;
        }
        else
        {
            liberarSimbolo(simbolo);
            
        }
    }

    return -1;
}




