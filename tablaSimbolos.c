#include <stdio.h>
#include "tablaHash.h"

//Variables globales (las dos tablas que necesitamos)
TablaHash *tablaGlobal = NULL; //Instancia de la tabla global

TablaHash *tablaLocal = NULL; //Instancia de la tabla local

int crearTablaSimbolos()
{
    if (tablaGlobal == NULL)
    {
        tablaGlobal = crearTablaHash(CANTIDAD_MAXIMA);

        if (tablaGlobal == NULL)
        {
            return -1;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
    return -1;
}

int crearScope(char *id, int valor, int tipo)
{

    if (( tipo != 1  &&tipo != 0 )|| tablaLocal != NULL || id==NULL || valor > -1)
    { 
        return -1;
    }

    tablaLocal = crearTablaHash(CANTIDAD_MAXIMA);
    if (tablaLocal == NULL)
    {
        return -1;
    }

    Simbolo *scope;
    Simbolo *aux = NULL;
    int out, out2;

    scope = crearSimbolo(FUNCION, tipo, ESCALAR_TH, id, 0, 0, valor, 0, 0);
    aux = crearSimbolo(FUNCION, tipo, ESCALAR_TH, id, 0, 0, valor, 0, 0);

    
    if (scope == NULL || aux == NULL)
    {
        return -1;
    }
    
    out = insertarTabla(tablaLocal, scope);
    out2 = insertarTabla(tablaGlobal, aux);

    if (out == -1 || out2 == -1)
        {
            return -1;
        }
    

    return 0;
}


int insertarSimboloTS(char *id, int tipo_data, int tipo_variable, int categoria, int valor)
{   
     if (id == NULL || valor <= -1 || tablaGlobal == NULL)
    {
        return -1;
    }
    else
    {
        Simbolo *simbolo = crearSimbolo(categoria, tipo_data, tipo_variable, id, -1, -1, valor, -1, -1);
        
        if (simbolo == NULL)
        {
            return -1;
        }
        else
        {
            if (tablaLocal != NULL)
            {
                return insertarTabla(tablaLocal, simbolo);
            }

            return insertarTabla(tablaGlobal, simbolo);
        }
    }

    return -1;

}

Simbolo *buscarSimboloenTS(char *id)
{
    if (id == NULL)
    {
        return NULL;
    }
    else
    {

        Simbolo *simbolo;
        /*1- Buscamos el simbolo en la tabla local*/
        if (tablaLocal != NULL)
        {
            simbolo = buscarenTabla(id, tablaLocal);
            if (simbolo != NULL)
            {
                return simbolo;
            }
        }
        /*2- Si no esta en local buscamos el simbolo en la tabla Global*/
        if (tablaGlobal != NULL)
        {
            simbolo = buscarenTabla(id, tablaGlobal);
            if (simbolo != NULL)
            {
                return simbolo;
            }
        }
    }

    return NULL;
}

Simbolo *buscarSimboloenTS_local(char *id)
{
    if (id == NULL)
    {
        return NULL;
    }
    else
    {
        Simbolo *simbolo;
        /*1- Buscamos el simbolo en la tabla local*/
        if (tablaLocal != NULL)
        {
            simbolo = buscarenTabla(id, tablaLocal);
            if (simbolo != NULL)
            {
                return simbolo;
            }
        }

        return NULL;
    }
}

void eliminarTablasSimbolos() //Elimina ambas
{
    if (tablaLocal != NULL) //1-Liberamos la local
    {
        liberarTablaHash(tablaLocal);
        tablaLocal = NULL;
    }
    if (tablaGlobal != NULL) //2- Desues la global
    {
        liberarTablaHash(tablaGlobal);
        tablaGlobal = NULL;
    }
}

void borrarScope()
{
    if (tablaLocal == NULL)
    {
        return;
    }

    liberarTablaHash(tablaLocal);
    tablaLocal = NULL;
}
