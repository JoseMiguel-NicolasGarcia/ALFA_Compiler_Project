%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "alfa.h"


int es_tipo_funcion = 0;

int tipo_de_funcion;
int declaracion_de_retorno = 0;

int anidacion = 0;    
int parametros_count;   

int etiqueta = 1;//parametro de etiqueta para atributo

//Variables indicadas en el powerPoint:
//Diapositiva 27
int tipo_actual;                                                                
int clase_actual;
int tamanio_vector_actual;

//Diapositiva 36
int num_variables_locales_actual;
int pos_variable_local_actual;
int num_parametros_actual;
int pos_parametro_actual;


extern int numCol;
void yyerror(char *n);
extern FILE* yyout;
extern int yylineno;
extern int yyleng;
extern int yylex();
extern int errorM;
      



%}
%union
{
  tipo_atributos atributo;
}


%token TOK_MAIN
%token TOK_INT
%token TOK_BOOLEAN
%token TOK_ARRAY
%token TOK_FUNCTION
%token TOK_IF
%token TOK_ELSE
%token TOK_WHILE
%token TOK_SCANF
%token TOK_PRINTF
%token TOK_RETURN
%token TOK_PUNTOYCOMA
%token TOK_COMA
%token TOK_PARENTESISIZQUIERDO
%token TOK_PARENTESISDERECHO
%token TOK_CORCHETEIZQUIERDO
%token TOK_CORCHETEDERECHO
%token TOK_LLAVEIZQUIERDA
%token TOK_LLAVEDERECHA
%token TOK_ASIGNACION
%token TOK_MAS
%token TOK_MENOS
%token TOK_DIVISION
%token TOK_ASTERISCO
%token TOK_AND
%token TOK_OR
%token TOK_NOT
%token TOK_IGUAL
%token TOK_DISTINTO
%token TOK_MENORIGUAL
%token TOK_MAYORIGUAL
%token TOK_MENOR
%token TOK_MAYOR

%token <atributo> TOK_IDENTIFICADOR
%token <atributo> TOK_CONSTANTE_ENTERA
%token <atributo> TOK_TRUE
%token <atributo> TOK_FALSE
%type <atributo> elemento_vector
%type <atributo> exp
%type <atributo> constante
%type <atributo> constante_entera
%type <atributo> constante_logica
%type <atributo> identificador
%type <atributo> nombre_funcion
%type <atributo> declaracion_funcion
%type <atributo> funcion_ir
%type <atributo> inicio_bucle
%type <atributo> expresiones_bucle
%type <atributo> comparacion
%type <atributo> condicional
%type <atributo> expresiones_if
%type <atributo> sentencias_if
%type <atributo> sentencias_if_else


%token TOK_ERROR


%left TOK_IGUAL TOK_DISTINTO TOK_MAYORIGUAL TOK_MENORIGUAL TOK_MAYOR TOK_MENOR
%left TOK_OR
%left TOK_AND 
%left TOK_MAS TOK_MENOS
%left TOK_ASTERISCO TOK_DIVISION

%right TOK_NOT

%start axioma

%%
  axioma: TOK_MAIN TOK_LLAVEIZQUIERDA declaraciones escritura1 funciones escritura2 sentencias TOK_LLAVEDERECHA { escribir_fin(yyout); fprintf(yyout, ";R1:\t<programa> ::= main { <declaraciones> <funciones> <sentencias> }\n"); };

  escritura1:{ escribir_subseccion_data(yyout); escribir_segmento_codigo(yyout);};

  escritura2:{ escribir_inicio_main(yyout);};

  declaraciones: declaracion { fprintf(yyout, ";R2:\t<declaraciones> ::= <declaracion>\n"); } | declaracion declaraciones { fprintf(yyout, ";R3:\t<declaraciones> ::= <declaracion> <declaraciones>\n"); };

  declaracion:  clase identificadores TOK_PUNTOYCOMA { fprintf(yyout, ";R4:\t<declaracion> ::= <clase> <identificadores> ;\n"); };

  clase:  clase_escalar { clase_actual=ESCALAR; fprintf(yyout, ";R5:\t<clase> ::= <clase_escalar>\n"); } | clase_vector { clase_actual=VECTOR; fprintf(yyout, ";R7:\t<clase> ::= <clase_vector>\n"); };

  clase_escalar:   tipo { fprintf(yyout, ";R9:\t<clase_escalar> ::= <tipo>\n"); };

  tipo:   TOK_INT { tipo_actual = INT; fprintf(yyout, ";R10:\t<tipo> ::= int\n"); } | TOK_BOOLEAN { tipo_actual = BOOLEAN; fprintf(yyout, ";R11:\t<tipo> ::= boolean\n"); };

  clase_vector:   TOK_ARRAY tipo TOK_CORCHETEIZQUIERDO TOK_CONSTANTE_ENTERA TOK_CORCHETEDERECHO { 
    if(($4.valor_entero > MAX_TAMANIO_VECTOR) || ($4.valor_entero < 1)){

      fprintf(stderr, "****Error semantico en lin %d: El tamanyo del vector <nombre_vector> excede los limites permitidos (1,64).\n", yylineno);

      return TOK_ERROR;
    }
    else{
      if(es_tipo_funcion){
        fprintf(stderr, "****Error semantico en lin %d: Declaracion de vector en funcion no permitida.\n", yylineno);
        return TOK_ERROR;   
        }
      else{
        tamanio_vector_actual = $4.valor_entero; fprintf(yyout, ";R15:\t<clase_vector> ::= array <tipo> [ <constante_entera> ]\n"); 
        }
    }
  };    
       

  identificadores:  identificador { fprintf(yyout, ";R18:\t<identificadores> ::= <identificador>\n"); } |  identificador TOK_COMA identificadores { fprintf(yyout, ";R19:\t<identificadores> ::= <identificador> , <identificadores>\n"); };
  
  funciones:  funcion funciones { fprintf(yyout, ";R20:\t<funciones> ::= <funcion> <funciones>\n"); } | { fprintf(yyout, ";R21:\t<funciones> ::=\n"); };

  funcion: declaracion_funcion sentencias TOK_LLAVEDERECHA { 
   if(!declaracion_de_retorno) {
        fprintf(stderr,"****Error semantico en lin %d: Funcion %s sin sentencia de retorno.\n", yylineno, $1.lexema);
		return TOK_ERROR;
    }
    else{
      Simbolo* simb = NULL;
      borrarScope();
      declaracion_de_retorno = 0;
      es_tipo_funcion = 0;
      simb = buscarSimboloenTS($1.lexema);


      if(simb != NULL){
        
        simb->numero_parametros = num_parametros_actual; fprintf(yyout, ";R22:\t<funcion> ::= function <tipo> <identificador> ( <parametros_funcion> ) { <declaraciones_funcion> <sentencias> }\n");
      }
     else{
       fprintf(stderr,"****Error semantico en lin %d: Acceso a variable no declarada (%s).\n", yylineno, $1.lexema);
        return TOK_ERROR;
      }
    }

  };

  
  nombre_funcion: TOK_FUNCTION tipo TOK_IDENTIFICADOR {

    if(crearScope($3.lexema, -2, tipo_actual)){ 
        fprintf(stderr, "****Error semantico en lin %d: Declaracion duplicada.", yylineno);
    }

    $$.tipo = tipo_actual;
    tipo_de_funcion = tipo_actual;
    strcpy($$.lexema, $3.lexema);

    num_variables_locales_actual = 0; 
    pos_variable_local_actual = 1;
    num_parametros_actual = 0;
    pos_parametro_actual = 0;
    es_tipo_funcion = 1;};
  
  declaracion_funcion: nombre_funcion TOK_PARENTESISIZQUIERDO parametros_funcion TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA declaraciones_funcion {

    Simbolo* simb = buscarSimboloenTS($1.lexema);
    if (simb != NULL)
    {

      simb->numero_parametros = num_parametros_actual;
      $$.tipo = tipo_actual;
      strcpy($$.lexema, $1.lexema);
      declararFuncion(yyout, $1.lexema, num_variables_locales_actual);   

    }
    else{

    fprintf(stderr, "****Error semantico en lin %d: Acceso a variable no declarada (%s).\n", yylineno, $1.lexema);
    return TOK_ERROR;

    }

  };

  parametros_funcion: parametro_funcion resto_parametros_funcion { fprintf(yyout, ";R23:\t<parametros_funcion> ::= <parametro_funcion> <resto_parametros_funcion>\n"); } | { fprintf(yyout, ";R24:\t<parametros_funcion> ::=\n"); };

  resto_parametros_funcion: TOK_PUNTOYCOMA parametro_funcion resto_parametros_funcion { fprintf(yyout, ";R25:\t<resto_parametros_funcion> ::= <parametro_funcion> <resto_parametros_funcion>\n"); } | { fprintf(yyout, ";R26:\t<resto_parametros_funcion> ::=\n"); };

  parametro_funcion: tipo fn_identifier { 

    num_parametros_actual++;
    pos_parametro_actual++; 

    fprintf(yyout, ";R27:\t<parametro_funcion> ::= <tipo> <identificador>"); 
  };

  fn_identifier: TOK_IDENTIFICADOR {
    Simbolo *simb = buscarSimboloenTS_local($1.lexema);

    if(simb == NULL) {
      insertarSimboloTS($1.lexema, tipo_actual, clase_actual, PARAMETRO, $1.valor_entero);

      simb = buscarSimboloenTS_local($1.lexema);
      simb->numero_parametros = num_parametros_actual;
    }
    else{
      fprintf(stderr,"****Error semantico en lin %d: Declaracion duplicada.\n", yylineno);
      return TOK_ERROR;
    }
  };

  declaraciones_funcion: declaraciones { fprintf(yyout, ";R28:\t<declaraciones_funcion> ::= <declaraciones>\n"); } | { fprintf(yyout, ";R29:\t<declaraciones_funcion> ::=\n"); };

  sentencias: sentencia { fprintf(yyout, ";R30:\t<sentencias> ::= <sentencia>\n"); } | sentencia sentencias { fprintf(yyout, ";R31:\t<sentencias> ::= <sentencia> <sentencias>\n"); };

  sentencia: sentencia_simple TOK_PUNTOYCOMA { fprintf(yyout, ";R32:\t<sentencia> ::= <sentencia_simple> ;\n"); } | bloque { fprintf(yyout, ";R33:\t<sentencia> ::= <bloque>\n"); };

  sentencia_simple: asignacion { fprintf(yyout, ";R34:\t<sentencia_simple> ::= <asignacion>\n"); } | lectura { fprintf(yyout, ";R35:\t<sentencia_simple> ::= <lectura>\n"); } | escritura { fprintf(yyout, ";R36:\t<sentencia_simple> ::= <escritura>\n"); } | retorno_funcion { fprintf(yyout, ";R38:\t<sentencia_simple> ::= <retorno_funcion> \n"); };

  bloque:  condicional { fprintf(yyout, ";R40:\t<bloque> ::= <condicional>\n"); } | bucle { fprintf(yyout, ";R41:\t<bloque> ::= <bucle>\n"); };

  asignacion: TOK_IDENTIFICADOR TOK_ASIGNACION exp { 

    Simbolo* simb = buscarSimboloenTS($1.lexema);    


    if (simb == NULL){//Caso 1- No declarado
      fprintf(stderr, "****Error semantico en lin %d: Acceso a variable no declarada (%s).\n", yylineno, $1.lexema);
      return TOK_ERROR;
    }else{
       if (simb->categoria == FUNCION){//Caso 2- Funcion

        fprintf(stderr, "****Error semantico en lin %d: Asignacion incompatible.\n", yylineno);
        return TOK_ERROR;

      }
      else{
          if (simb->tipo_data != $3.tipo){ //Caso 3- No se puede asignar ese tipo
            fprintf(stderr, "****Error semantico en lin %d: Asignacion incompatible.\n", yylineno);
            return TOK_ERROR;
          }
          else{ //Caso 4- Caso correcto
            if(es_tipo_funcion) {
              if(simb->categoria != PARAMETRO) {
                escribirVariableLocal(yyout, simb->numero_variables + 1);
                
              }
              else {
                escribirParametro(yyout, simb->numero_parametros, num_parametros_actual);
              }
              asignarDestinoEnPila(yyout, $3.es_direccion);
            }
          else {
            asignar(yyout, $1.lexema, $3.es_direccion);
            fprintf(yyout, ";R43:\t<asignacion> ::= <identificador> = <exp>\n"); }
        }
      }
    
    }
    }
   

  | elemento_vector TOK_ASIGNACION exp { 
    
    Simbolo* simb = buscarSimboloenTS($1.lexema);

    if($1.tipo == $3.tipo){
      asignarVectorEnPila(yyout, $3.es_direccion);     
      fprintf(yyout, ";R44:\t<asignacion> ::= <elemento_vector> = <exp>\n"); 
        
    }
    else{
      fprintf(stderr, "****Error semantico en lin %d: Asignacion incompatible.\n", yylineno);
      return TOK_ERROR;
    }

    
  };




  elemento_vector: TOK_IDENTIFICADOR TOK_CORCHETEIZQUIERDO exp TOK_CORCHETEDERECHO { 
    Simbolo* simb = buscarSimboloenTS($1.lexema);

    if(simb->categoria == FUNCION) {

        fprintf(stderr, "****Error semantico en lin %d: Asignacion incompatible.\n", yylineno);
        return TOK_ERROR;

    }
    else{

      if (simb->tipo_variable != VECTOR)
      {

        fprintf(stderr, "****Error semantico en lin %d: Intento de indexacion de una variable que no es de tipo vector.\n", yylineno);
        return TOK_ERROR;

      }
      else{

        if($3.tipo != INT) { 

            fprintf(stderr, "****Error semantico en lin %d: El indice en una operacion de indexacion tiene que ser de tipo entero.\n", yylineno);
            return TOK_ERROR;

        }
        else{//Caso correcto

          $$.es_direccion = 1;
          strcpy($$.lexema, $1.lexema);

          $$.tipo = simb->tipo_data;
          escribir_elemento_vector(yyout, $1.lexema, simb->valor, $3.es_direccion);

          fprintf(yyout, ";R48:\t<elemento_vector> ::= <identificador> [ <exp> ]\n"); 
        }
      }

    }
        
        
  };

  condicional: sentencias_if TOK_LLAVEDERECHA { ifthen_fin(yyout, $1.etiqueta); fprintf(yyout, ";R50:\t<condicional> ::= if ( <exp> ) { <sentencias> }\n"); } | sentencias_if_else sentencias TOK_LLAVEDERECHA{ ifthenelse_fin(yyout, $1.etiqueta); fprintf(yyout, ";R51:\t<condicional> ::= if ( <exp> ) { <sentencias> } else { <sentencias> }\n"); };

  sentencias_if:	expresiones_if sentencias {$$.etiqueta = $1.etiqueta;};

  sentencias_if_else: sentencias_if TOK_LLAVEDERECHA TOK_ELSE TOK_LLAVEIZQUIERDA { ifthenelse_fin_then(yyout, $1.etiqueta); $$.etiqueta = $1.etiqueta;};

  expresiones_if: TOK_IF TOK_PARENTESISIZQUIERDO exp TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA {
    if($3.tipo == BOOLEAN){
      
      $$.etiqueta = etiqueta++; 

      ifthenelse_inicio(yyout, $3.es_direccion, $$.etiqueta);
      
    }
    else{

      fprintf(stderr, "****Error semantico en lin %d: Condicional con condicion de tipo int.\n", yylineno);
      return TOK_ERROR;

    }
            
            
  };

  bucle: expresiones_bucle sentencias TOK_LLAVEDERECHA { while_fin(yyout, $1.etiqueta); fprintf(yyout, ";R52:\t<bucle> ::= while ( <exp> ) { <sentencias> }\n"); };

  inicio_bucle: TOK_WHILE TOK_PARENTESISIZQUIERDO{ $$.etiqueta = etiqueta++; while_inicio(yyout, $$.etiqueta); };

  expresiones_bucle: inicio_bucle exp TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA {
    if($2.tipo != BOOLEAN){
      fprintf(stderr, "****Error semantico en lin %d: Bucle con condicion de tipo int.\n", yylineno);
      return TOK_ERROR;
    }
    while_exp_pila(yyout, $1.es_direccion, $$.etiqueta);
  };


  lectura: TOK_SCANF TOK_IDENTIFICADOR { 

    Simbolo* simb = buscarSimboloenTS($2.lexema);

    if(simb != NULL){ 

      if(simb->tipo_variable != ESCALAR) { 

        fprintf(stderr, "****Error semantico en lin %d: Asignacion incompatible.\n", yylineno);
        return TOK_ERROR;
      }
      else if(simb->categoria != VARIABLE) { 

          fprintf(stderr, "****Error semantico en lin %d: Asignacion incompatible.\n", yylineno);
          return TOK_ERROR;
      }
      else{

        leer(yyout, $2.lexema, $2.tipo);
        fprintf(yyout, ";R54:\t<lectura> ::= scanf <identificador>\n"); 

      }
    }
    else{
      fprintf(stderr,"****Error semantico en lin %d: Acceso a variable no declarada (%s).\n", yylineno, $2.lexema);
      return TOK_ERROR;
    }     
  };



  escritura: TOK_PRINTF exp { escribir(yyout, $2.es_direccion, $2.tipo); fprintf(yyout, ";R56:\t<escritura> ::= printf <exp>\n"); };

  retorno_funcion: TOK_RETURN exp { 

    if(!es_tipo_funcion){

      fprintf(stderr, "****Error semantico en lin %d: Sentencia de retorno fuera del cuerpo de una función.\n", yylineno);
      return TOK_ERROR;

    }else{

      if(tipo_de_funcion == $2.tipo) {
        declaracion_de_retorno = 1;
        retornarFuncion(yyout, $2.es_direccion);
        fprintf(yyout, ";R61:\t<retorno_funcion> ::= return <exp>\n");
      }
      else{

        fprintf(stderr, "****Error semantico en lin %d: Sentencia de retorno con distinto tipo que la función.\n", yylineno);
        return TOK_ERROR;
      }
    }
  };

  exp: exp TOK_MAS exp {

    if ($1.tipo == BOOLEAN)
    {
        fprintf(stderr, "****Error semantico en lin %d: Operacion aritmetica con operandos boolean.\n", yylineno);
        return TOK_ERROR;
    }
    else if ($3.tipo == BOOLEAN){

       fprintf(stderr, "****Error semantico en lin %d: Operacion aritmetica con operandos boolean.\n", yylineno);
        return TOK_ERROR;
    }
    else{

      if (($1.tipo == INT) && ($3.tipo == INT))
      {
        sumar(yyout, $1.es_direccion, $3.es_direccion);
        $$.tipo = INT;
        $$.es_direccion = 0;
      }
      fprintf(yyout, ";R72:\t<exp> ::= <exp> + <exp>\n");
    }
    } 

    | exp TOK_MENOS exp { 
     if ($1.tipo == BOOLEAN)
    {
      fprintf(stderr, "****Error semantico en lin %d: Operacion aritmetica con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else if ($3.tipo == BOOLEAN){

      fprintf(stderr, "****Error semantico en lin %d: Operacion aritmetica con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else{
                
      if (($1.tipo == INT) && ($3.tipo == INT))
      {
          restar(yyout, $1.es_direccion, $3.es_direccion);
          $$.tipo = INT;
          $$.es_direccion = 0;
      }
      
      fprintf(yyout, ";R73:\t<exp> ::= <exp> - <exp>\n");
    }
    }
    | exp TOK_DIVISION exp {
    if ($1.tipo == BOOLEAN)
    {
      fprintf(stderr, "****Error semantico en lin %d: Operacion aritmetica con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else if ($3.tipo == BOOLEAN){

      fprintf(stderr, "****Error semantico en lin %d: Operacion aritmetica con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else{
           
      if (($1.tipo == INT) && ($3.tipo == INT))
      {
          dividir(yyout, $1.es_direccion, $3.es_direccion);
          $$.tipo = INT;
          $$.es_direccion = 0;
      } 
    
     fprintf(yyout, ";R74:\t<exp> ::= <exp> / <exp>\n"); 
    }
    }

    | exp TOK_ASTERISCO exp { 

    if ($1.tipo == BOOLEAN)
    {
        fprintf(stderr, "****Error semantico en lin %d: Operacion aritmetica con operandos boolean.\n", yylineno);
        return TOK_ERROR;
    }
    else if ($3.tipo == BOOLEAN){

      fprintf(stderr, "****Error semantico en lin %d: Operacion aritmetica con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else{
              
      if (($1.tipo == INT) && ($3.tipo == INT))
      {

          multiplicar(yyout, $1.es_direccion, $3.es_direccion);
          $$.tipo = INT;
          $$.es_direccion = 0;

      }
      fprintf(yyout, ";R75:\t<exp> ::= <exp> * <exp>\n"); 
      } 
      }
    | TOK_MENOS exp { 

    if ($2.tipo == BOOLEAN){

      fprintf(stderr, "****Error semantico en lin %d: Operacion aritmetica con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else{
      if ($2.tipo == INT)
      {
        cambiar_signo(yyout, $2.es_direccion);
        $$.tipo = INT;
        $$.es_direccion = 0;
      }
    fprintf(yyout, ";R76:\t<exp> ::= - <exp>\n"); 
    } 
    }

    | exp TOK_AND exp { 

    if ($1.tipo == INT)
    {
      fprintf(stderr, "****Error semantico en lin %d: Operacion logica con operandos int.\n", yylineno);
      return TOK_ERROR;
    }
    else if ($3.tipo == INT){
      fprintf(stderr, "****Error semantico en lin %d: Operacion logica con operandos int.\n", yylineno);
      return TOK_ERROR;
    }
    else{
      if (($1.tipo == BOOLEAN) && ($3.tipo == BOOLEAN))
      {

        y(yyout, $1.es_direccion, $3.es_direccion);
        $$.tipo = BOOLEAN;
        $$.es_direccion = 0;
      }
    fprintf(yyout, ";R77:\t<exp> ::= <exp> && <exp>\n"); 
    }
    }

    | exp TOK_OR exp { 

    if ($1.tipo == INT)
    {
      fprintf(stderr, "****Error semantico en lin %d: Operacion logica con operandos int.\n", yylineno);
      return TOK_ERROR;
    }
    else if ($3.tipo == INT){
      fprintf(stderr, "****Error semantico en lin %d: Operacion logica con operandos int.\n", yylineno);
      return TOK_ERROR;
    }
    else{ 
      if (($1.tipo == BOOLEAN) && ($3.tipo == BOOLEAN))
      {
        o(yyout, $1.es_direccion, $3.es_direccion);
        $$.tipo = BOOLEAN;
        $$.es_direccion = 0;
      }
      fprintf(yyout, ";R78:\t<exp> ::= <exp> || <exp>\n");
    }
    } 

    | TOK_NOT exp {

    if ($2.tipo == INT)
    {
      fprintf(stderr, "****Error semantico en lin %d: Operacion logica con operandos int.\n", yylineno);
      return TOK_ERROR;
    }
    else{
      if ($2.tipo == BOOLEAN)
      {
        no(yyout, $2.es_direccion, etiqueta);
        etiqueta++;
        $$.tipo = BOOLEAN;
        $$.es_direccion = 0;
      }
      fprintf(yyout, ";R79:\t<exp> ::= ! <exp>\n");
    } 
    } 

    | TOK_IDENTIFICADOR { 
  
    Simbolo* simb = buscarSimboloenTS($1.lexema);
    if (simb != NULL)
    {
      if(es_tipo_funcion) {
        if(simb->categoria == PARAMETRO) {

            escribirParametro(yyout, simb->numero_parametros, num_parametros_actual);
        }
        else {

            escribirVariableLocal(yyout, simb->numero_variables + 1); 
        }
      } 
      else {
        escribir_operando(yyout, $1.lexema, 1); 
      }

    strcpy($$.lexema, $1.lexema);
    $$.tipo = simb->tipo_data;
    $$.es_direccion = 1;   
    fprintf(yyout, ";R80:\t<exp> ::= <identificador>\n");

    }
    else{

      fprintf(stderr, "****Error semantico en lin %d: Acceso a variable no declarada (%s).\n", yylineno, $1.lexema);
      return TOK_ERROR;
    }
    } 

    | constante { $$.tipo = $1.tipo; $$.es_direccion = $1.es_direccion; fprintf(yyout, ";R81:\t<exp> ::= <constante>\n"); } 
    | TOK_PARENTESISIZQUIERDO exp TOK_PARENTESISDERECHO { $$.tipo = $2.tipo; $$.es_direccion = $2.es_direccion; fprintf(yyout, ";R82:\t<exp> ::= ( <exp> )\n"); } 
    | TOK_PARENTESISIZQUIERDO comparacion TOK_PARENTESISDERECHO { $$.tipo = $2.tipo; $$.es_direccion = $2.es_direccion; fprintf(yyout, ";R83:\t<exp> ::= ( <comparacion> )\n"); } 
    | elemento_vector { fprintf(yyout, ";R85:\t<exp> ::= <elemento_vector>\n"); } 

    | funcion_ir lista_expresiones TOK_PARENTESISDERECHO {
    Simbolo *simb = buscarSimboloenTS($1.lexema);

    if(simb==NULL) {

        fprintf(stderr, "****Error semantico en lin %d: Funcion no declarada (%s).\n", yylineno, $1.lexema);
        return TOK_ERROR;
    }
    else{
      if(simb->categoria != FUNCION){

        fprintf(stderr, "****Error semantico en lin %d: El identificador no es una funcion (%s).\n", yylineno, $1.lexema);
        return TOK_ERROR;
      }
      else{
        if(simb->numero_parametros != parametros_count) {

        fprintf(stderr, "****Error semantico en lin %d: Numero incorrecto de parametros en llamada a funcion.\n", yylineno);
        return TOK_ERROR;
        }
        else{

          anidacion = 0;
          $$.tipo = simb->tipo_data;
          llamarFuncion(yyout, $1.lexema, simb->numero_parametros);
          fprintf(yyout, ";R88:\t<exp> ::= ( <lista_expresiones> )\n");
        }
      }
    }
  };

  funcion_ir: TOK_IDENTIFICADOR TOK_PARENTESISIZQUIERDO {

    if(anidacion){ //variable que hemos creado para comprobar posibles anidaciones no permitidas
        fprintf(stderr, "****Error semantico en lin %d: No esta permitido el uso de llamadas a funciones como parametros de otras funciones.\n", yylineno);
        return TOK_ERROR;
    }else{
       anidacion = 1;
      parametros_count = 0;
      strcpy($$.lexema, $1.lexema);
    } 
  };

  lista_expresiones: exp_hacer_push resto_lista_expresiones { anidacion = 0; parametros_count++; fprintf(yyout, ";R89:\t<lista_expresiones> ::= <exp> <resto_lista_expresiones>\n"); } | { anidacion = 0; fprintf(yyout, ";R90:\t<lista_expresiones> ::=\n"); };
  
  resto_lista_expresiones: TOK_COMA exp_hacer_push resto_lista_expresiones { parametros_count++; fprintf(yyout, ";R91:\t<resto_lista_expresiones> ::= , <exp> <resto_lista_expresiones>\n"); } | { fprintf(yyout, ";R92:\t<resto_lista_expresiones> ::=\n"); };

  exp_hacer_push: exp { operandoEnPilaAArgumento(yyout, $1.es_direccion);};

  comparacion: exp TOK_IGUAL exp { 

    if ($1.tipo == BOOLEAN)
    {
      fprintf(stderr, "****Error semantico en lin %d: Comparacion con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else if ($3.tipo == BOOLEAN){
      fprintf(stderr, "****Error semantico en lin %d: Comparacion con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else{
      if (($1.tipo == INT) && ($3.tipo == INT))
      {
        igual(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
        etiqueta++;
        $$.tipo = BOOLEAN;
        $$.es_direccion = 0;
      }
      fprintf(yyout, ";R93:\t<comparacion> ::= <exp> == <exp>\n"); 
    }
    } 

    | exp TOK_DISTINTO exp { 

    if ($1.tipo == BOOLEAN)
    {

      fprintf(stderr, "****Error semantico en lin %d: Comparacion con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else if ($3.tipo == BOOLEAN){

      fprintf(stderr, "****Error semantico en lin %d: Comparacion con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else{

      if (($1.tipo == INT) && ($3.tipo == INT))
      {
          distinto(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
          etiqueta++;
          $$.tipo = BOOLEAN;
          $$.es_direccion = 0;
      }

      fprintf(yyout, ";R94:\t<comparacion> ::= <exp> != <exp>\n");
     } 
    }
    | exp TOK_MENORIGUAL exp { 

    if ($1.tipo == BOOLEAN)
    {
      fprintf(stderr, "****Error semantico en lin %d: Comparacion con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else if ($3.tipo == BOOLEAN){
      fprintf(stderr, "****Error semantico en lin %d: Comparacion con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else{
      if (($1.tipo == INT) && ($3.tipo == INT))
      {
          menor_igual(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
          etiqueta++;
          $$.tipo = BOOLEAN;
          $$.es_direccion = 0;
      }
      fprintf(yyout, ";R95:\t<comparacion> ::= <exp> <= <exp>\n"); 
    }
    }  
   | exp TOK_MAYORIGUAL exp {

     if ($1.tipo == BOOLEAN)
    {

      fprintf(stderr, "****Error semantico en lin %d: Comparacion con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else if ($3.tipo == BOOLEAN){

      fprintf(stderr, "****Error semantico en lin %d: Comparacion con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else{

      if (($1.tipo == INT) && ($3.tipo == INT))
      {
          mayor_igual(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
          etiqueta++;
          $$.tipo = BOOLEAN;
          $$.es_direccion = 0;
      }
      fprintf(yyout, ";R96:\t<comparacion> ::= <exp> >= <exp>\n"); } 
    }
    | exp TOK_MENOR exp {

    if ($1.tipo == BOOLEAN)
    {
      fprintf(stderr, "****Error semantico en lin %d: Comparacion con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else if ($3.tipo == BOOLEAN){
      fprintf(stderr, "****Error semantico en lin %d: Comparacion con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else{

      if (($1.tipo == INT) && ($3.tipo == INT))
      {
          menor(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
          etiqueta++;
          $$.tipo = BOOLEAN;
          $$.es_direccion = 0;
      }
      fprintf(yyout, ";R97:\t<comparacion> ::= <exp> < <exp>\n"); 
      } 
      }

    | exp TOK_MAYOR exp { 

    if ($1.tipo == BOOLEAN)
    {

      fprintf(stderr, "****Error semantico en lin %d: Comparacion con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else if ($3.tipo == BOOLEAN){

      fprintf(stderr, "****Error semantico en lin %d: Comparacion con operandos boolean.\n", yylineno);
      return TOK_ERROR;
    }
    else{

      if (($1.tipo == INT) && ($3.tipo == INT))
      {
        mayor(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
        etiqueta++;
        $$.tipo = BOOLEAN;
        $$.es_direccion = 0;
      }  

    fprintf(yyout, ";R98:\t<comparacion> ::= <exp> > <exp>\n"); 
    }
  };

  constante: constante_logica { fprintf(yyout, ";R99:\t<constante> ::= <constante_logica>\n"); } | constante_entera { $$.tipo = $1.tipo; $$.es_direccion = $1.es_direccion; fprintf(yyout, ";R100:\t<constante> ::= <constante_entera>\n"); };

  constante_logica: TOK_TRUE { 
    char cadena[50];
    $$.tipo = BOOLEAN;
    $$.es_direccion = 0;
    sprintf(cadena, "%d", 1);
    escribir_operando(yyout, (char *)(cadena), $$.es_direccion);
    fprintf(yyout, ";R102:\t<constante_logica> ::= true\n"); 
    } 

    | TOK_FALSE { 
    char cadena[50];
    $$.tipo = BOOLEAN;
    $$.es_direccion = 0;
    sprintf(cadena, "%d", 0);
    escribir_operando(yyout, (char *)(cadena), $$.es_direccion);
    fprintf(yyout, ";R103:\t<constante_logica> ::= false\n"); 
  };

  constante_entera: TOK_CONSTANTE_ENTERA { 
    char cadena[50];
    $$.tipo = INT;
    $$.es_direccion = 0;
    $$.valor_entero = $1.valor_entero;
    sprintf(cadena, "%d", $1.valor_entero);
    escribir_operando(yyout, (char *)(cadena), $$.es_direccion);
    fprintf(yyout, ";R104:\t<constante_entera> ::= TOK_CONSTANTE_ENTERA\n"); 
  };

  identificador: TOK_IDENTIFICADOR { 

    Simbolo* simb = buscarSimboloenTS($1.lexema);
    if( (simb != NULL) && (simb->categoria != FUNCION) ){ 

      fprintf(stderr,"****Error semantico en lin %d: Declaracion duplicada.\n", yylineno);
      return TOK_ERROR;

    }else{

      insertarSimboloTS($1.lexema, tipo_actual, clase_actual, VARIABLE, $1.valor_entero);
      if(es_tipo_funcion) {

        simb = buscarSimboloenTS($1.lexema);

        if(clase_actual != VECTOR) {

          simb->numero_variables = num_variables_locales_actual;
          simb->numero_parametros = num_parametros_actual;
          num_variables_locales_actual++;
          pos_variable_local_actual++;
        }else{

          fprintf(stderr, "****Error semantico en lin %d: Variable local de tipo no escalar.\n", yylineno);
          return TOK_ERROR;
        }
      }
      else {

        int tamanio_vector_actual_aux = 1;
        if(clase_actual == VECTOR) {
            tamanio_vector_actual_aux = tamanio_vector_actual;
        }

        declarar_variable(yyout, $1.lexema, tipo_actual, tamanio_vector_actual_aux);
    }
    
    fprintf(yyout, ";R108:\t<identificador> ::= TOK_IDENTIFICADOR\n"); };}

%%

void yyerror(char *n){
  int col = 0;

  if(errorM){
    errorM = 0;
  }else{
    col = numCol-yyleng;
    fprintf(stderr, "****Error sintactico en [lin %d, col %d]\n", yylineno, col);
  }
}
