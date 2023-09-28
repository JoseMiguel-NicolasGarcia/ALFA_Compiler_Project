#include <stdio.h>

#include "alfa.h"
#include "y.tab.h"



extern int numCol;

extern int yylineno;
extern int yyleng;

extern FILE *yyin;
extern FILE *yyout;

int main(int argc, char *argv[])
{
    int  tabla_simbolos;

    if (argc != 3)
        return 1;

    yyin = fopen(argv[1], "r");
    yyout = fopen(argv[2], "w");
    tabla_simbolos = crearTablaSimbolos();

    if (!yyin || !yyout)
    {
        printf("Ha habido un problema con los ficheros entrada/salida.\n");
        return 1;
    }
    else
    {
        if (tabla_simbolos == -1)
        {
            printf("Ha habido un problema con la tabla de símbolos\n");
            return 1;
        }
        else
        {
        escribir_cabecera_bss(yyout);
        yyparse();
        eliminarTablasSimbolos();
        fclose(yyin);
        fclose(yyout);

        yyin = NULL;
        yyout = NULL;

        return 0;
        }
    }
    return 1;
}
