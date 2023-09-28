%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "alfa.h"
#include "y.tab.h"

#define LENGTH_MAX 100

int numCol = 1;
int errorM = 0;

%}
%option yylineno
%option noyywrap



DIGITO [0-9]*
IDENTIFICADOR [a-zA-Z][a-zA-Z0-9]*
NEWLINE "\n"
ESPACIO " "
TABULADOR "\t"
COMENTARIO "//".*
ERROR .


/**Cambiamos cada uno para copiar el atributo.lexema en yytext**/
%%  

"main" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_MAIN;
}

"int" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_INT;
}

"boolean" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_BOOLEAN;
}

"array" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_ARRAY;
}

"function" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_FUNCTION;
}

"if" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_IF;
}

"else" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_ELSE;
}

"while" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_WHILE;
}

"scanf" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_SCANF;
}

"printf" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_PRINTF;
}

"return" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_RETURN;
}

";" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_PUNTOYCOMA;
}

"," {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_COMA;
}

"(" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_PARENTESISIZQUIERDO;
}

")" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_PARENTESISDERECHO;
}

"[" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_CORCHETEIZQUIERDO;
}

"]" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_CORCHETEDERECHO;
}

"{" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_LLAVEIZQUIERDA;
}

"}" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_LLAVEDERECHA;
}

"=" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_ASIGNACION;
}

"+" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_MAS;
}

"-" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_MENOS;
}

"/" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_DIVISION;
}

"*" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_ASTERISCO;
}

"&&" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_AND;
}

"||" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_OR;
}

"!" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_NOT;
}

"==" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_IGUAL;
}

"!=" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_DISTINTO;
}

"<=" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_MENORIGUAL;
}

">=" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_MAYORIGUAL;
}

"<" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_MENOR;
}

">" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_MAYOR;
}

{DIGITO} {
    //En este caso es el valor_entero
    yylval.atributo.valor_entero = atoi(yytext);

    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_CONSTANTE_ENTERA;
}

"true" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_TRUE;
}

"false" {
    
    strcpy(yylval.atributo.lexema, yytext);
    fprintf(yyout, ";D:\t%s\n", yytext);
    return TOK_FALSE;
}

{IDENTIFICADOR} {
    
    strcpy(yylval.atributo.lexema, yytext);

    if(yyleng > LENGTH_MAX){

        fprintf(stderr,"****Error en [lin %d, col %d]: identificador demasiado largo (%s)\n", yylineno, numCol-yyleng, yytext);
        return TOK_ERROR;

    }else{
        fprintf(yyout, ";D:\t%s\n", yytext);
        return TOK_IDENTIFICADOR;
        
    }
}

{COMENTARIO} {

    numCol = 1;

}

{TABULADOR} {

    yyleng = yyleng + 4;
  
}

{ESPACIO} {

    yyleng+=1;
    
}

{NEWLINE} {
    numCol = 1;

}
{ERROR} {
    fprintf(stderr,"****Error en [lin %d, col %d]: simbolo no permitido (%s)\n", yylineno, numCol-yyleng, yytext);
    
    errorM = 1;
    return TOK_ERROR;
}

%%


