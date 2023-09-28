#include "stdlib.h"
#include "generacion.h"


void escribir_cabecera_bss(FILE* fpasm){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"segment .bss\n");
  fprintf(fpasm,"\t__esp resd 64\n");
}


void escribir_subseccion_data(FILE* fpasm){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"segment .data\n");
  fprintf(fpasm,"\tdivision0_err db \"****Error de ejecucion: Division por cero.\", 0\n");
  fprintf(fpasm,"\tindicevector_err db \"****Error de ejecucion: Indice fuera de rango.\", 0\n");
}


void declarar_variable(FILE* fpasm, char * nombre, int tipo, int tamano){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\t_%s resd %d\n", nombre, tamano);
}


void escribir_segmento_codigo(FILE* fpasm){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"segment .text\n");
  fprintf(fpasm,"\tglobal main\n");
  fprintf(fpasm,"\textern print_int, print_boolean, print_string, print_blank, print_endofline, scan_int, scan_boolean\n");
}


void escribir_inicio_main(FILE* fpasm){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"main:\n");
  fprintf(fpasm,"\tmov dword [__esp], esp\n");
}


void escribir_fin(FILE* fpasm){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tjmp fin\n");
  fprintf(fpasm,"cero_div_error:\n");
  fprintf(fpasm,"\tpush dword division0_err\n");
  fprintf(fpasm,"\tcall print_string\n");
  fprintf(fpasm,"\tadd esp, 4\n");
  fprintf(fpasm,"\tcall print_endofline\n");
  fprintf(fpasm,"\tjmp fin\n");
  fprintf(fpasm,"error_vector:\n");
  fprintf(fpasm,"\tpush dword indicevector_err\n");
  fprintf(fpasm,"\tcall print_string\n");
  fprintf(fpasm,"\tadd esp, 4\n");
  fprintf(fpasm,"\tcall print_endofline\n");

  fprintf(fpasm,"fin:\n");
  fprintf(fpasm,"\tmov dword esp, [__esp]\n");
  fprintf(fpasm,"\tret\n");
}


void escribir_operando(FILE* fpasm, char* nombre, int es_variable){
  if(!fpasm){
    return;
  }

  if(es_variable==1){
    fprintf(fpasm,"\tmov dword eax, _%s\n", nombre);
    fprintf(fpasm,"\tpush dword eax\n");
  }else{
    fprintf(fpasm,"\tmov dword eax, %s\n", nombre);
    fprintf(fpasm,"\tpush dword eax\n");
  }
}


void asignar(FILE* fpasm, char* nombre, int es_variable){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");

  if(es_variable==1){
    fprintf(fpasm,"\tmov eax, [eax]\n");
  }

  fprintf(fpasm,"\tmov dword [_%s], eax\n", nombre);
}


void sumar(FILE* fpasm, int es_variable_1, int es_variable_2){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");
  fprintf(fpasm,"\tpop dword ebx\n");

  if(es_variable_1){
    fprintf(fpasm,"\tmov dword ebx, [ebx]\n");
  }

  if(es_variable_2){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  fprintf(fpasm,"\tadd eax, ebx\n");
  fprintf(fpasm,"\tpush dword eax\n");
}

void restar(FILE* fpasm, int es_variable_1, int es_variable_2){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");
  fprintf(fpasm,"\tpop dword ebx\n");

  if(es_variable_1){
    fprintf(fpasm,"\tmov dword ebx, [ebx]\n");
  }

  if(es_variable_2){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  fprintf(fpasm,"\tsub ebx, eax\n");
  fprintf(fpasm,"\tpush dword ebx\n");
}

void multiplicar(FILE* fpasm, int es_variable_1, int es_variable_2){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");
  fprintf(fpasm,"\tpop dword ebx\n");

  if(es_variable_1){
    fprintf(fpasm,"\tmov dword ebx, [ebx]\n");
  }

  if(es_variable_2){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  fprintf(fpasm,"\timul ebx\n");
  fprintf(fpasm,"\tpush dword eax\n");
}

void dividir(FILE* fpasm, int es_variable_1, int es_variable_2){
  if (!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword ebx\n");
  fprintf(fpasm,"\tpop dword ecx\n");


  if(es_variable_1){
    fprintf(fpasm,"\tmov dword ecx, [ecx]\n");
  }

  if(es_variable_2){
    fprintf(fpasm,"\tmov dword ebx, [ebx]\n");
  }

  fprintf(fpasm,"\tmov dword eax, ecx\n");
  fprintf(fpasm,"\tmov dword ecx, ebx\n");


  fprintf(fpasm,"\tcmp ecx, 0\n");
  fprintf(fpasm,"\tjne no_error\n");
  fprintf(fpasm,"\tjmp cero_div_error\n");
  fprintf(fpasm,"no_error:\n");
  fprintf(fpasm,"\tcdq\n");

  fprintf(fpasm,"\tidiv ecx\n");
  fprintf(fpasm,"\tpush dword eax\n");
}

void o(FILE* fpasm, int es_variable_1, int es_variable_2){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");
  fprintf(fpasm,"\tpop dword ebx\n");

  if(es_variable_1){
    fprintf(fpasm,"\tmov dword ebx, [ebx]\n");
  }

  if(es_variable_2){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  fprintf(fpasm,"\tor eax, ebx\n");
  fprintf(fpasm,"\tpush dword eax\n");
}

void y(FILE* fpasm, int es_variable_1, int es_variable_2){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");
  fprintf(fpasm,"\tpop dword ebx\n");

  if(es_variable_1){
    fprintf(fpasm,"\tmov dword ebx, [ebx]\n");
  }

  if(es_variable_2){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  fprintf(fpasm,"\tand eax, ebx\n");
  fprintf(fpasm,"\tpush dword eax\n");
}

void cambiar_signo(FILE* fpasm, int es_variable){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");
  if(es_variable==1){
    fprintf(fpasm,"\tmov eax, [eax]\n");
  }

  fprintf(fpasm,"\tneg eax\n");
  fprintf(fpasm,"\tpush dword eax\n");
}

void no(FILE* fpasm, int es_variable, int cuantos_no){
  if (!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");
  if(es_variable){
    fprintf(fpasm,"\tmov eax, [eax]\n");
  }

  fprintf(fpasm,"\tcmp dword eax, 0\n");
  fprintf(fpasm,"\tje case_zero_%d\n", cuantos_no);

  fprintf(fpasm,"\tmov dword ebx, 0\n");
  fprintf(fpasm,"\tjmp case_continue_%d\n", cuantos_no);

  fprintf(fpasm,"case_zero_%d:\n", cuantos_no);
  fprintf(fpasm,"\tmov dword ebx, 1\n");

  fprintf(fpasm,"case_continue_%d:\n", cuantos_no);
  fprintf(fpasm,"\tmov eax, ebx\n");
  fprintf(fpasm,"\tpush dword eax\n");
}


void igual(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword ebx\n");
  fprintf(fpasm,"\tpop dword eax\n");

  if(es_variable2){
    fprintf(fpasm,"\tmov dword ebx, [ebx]\n");
  }

  if(es_variable1){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  fprintf(fpasm,"\tcmp eax, ebx\n");
  fprintf(fpasm,"\tjz equal_%d\n", etiqueta);

  fprintf(fpasm,"\tmov dword ecx, 0\n");
  fprintf(fpasm,"\tjmp not_equal_%d\n", etiqueta);

  fprintf(fpasm,"equal_%d:\n", etiqueta);
  fprintf(fpasm,"\tmov dword ecx, 1\n");
  fprintf(fpasm,"not_equal_%d:\n", etiqueta);
  fprintf(fpasm,"\tpush dword ecx\n");
}

void distinto(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword ebx\n");
  fprintf(fpasm,"\tpop dword eax\n");

  if(es_variable2){
    fprintf(fpasm,"\tmov dword ebx, [ebx]\n");
  }

  if(es_variable1){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  fprintf(fpasm,"\tcmp eax, ebx\n");
  fprintf(fpasm,"\tjz equal2_%d\n", etiqueta);

  fprintf(fpasm,"\tmov dword ecx, 1\n");
  fprintf(fpasm,"\tjmp not_equal2_%d\n", etiqueta);

  fprintf(fpasm,"equal2_%d:\n", etiqueta);
  fprintf(fpasm,"\tmov dword ecx, 0\n");
  fprintf(fpasm,"not_equal2_%d:\n", etiqueta);
  fprintf(fpasm,"\tpush dword ecx\n");
}

void menor_igual(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");
  fprintf(fpasm,"\tpop dword ebx\n");

  if(es_variable2){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  if(es_variable1){
    fprintf(fpasm,"\tmov dword ebx, [ebx]\n");
  }

  fprintf(fpasm,"\tcmp ebx, eax\n");
  fprintf(fpasm,"\tjle less_equal_%d\n", etiqueta);

  fprintf(fpasm,"\tmov dword eax, 0\n");
  fprintf(fpasm,"\tjmp not_less_equal_%d\n", etiqueta);

  fprintf(fpasm,"less_equal_%d:\n", etiqueta);
  fprintf(fpasm,"\tmov dword eax, 1\n");
  fprintf(fpasm,"not_less_equal_%d:\n", etiqueta);
  fprintf(fpasm,"\tpush dword eax\n");
}

void mayor_igual(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");
  fprintf(fpasm,"\tpop dword ebx\n");

  if(es_variable2){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  if(es_variable1){
    fprintf(fpasm,"\tmov dword ebx, [ebx]\n");
  }

  fprintf(fpasm,"\tcmp ebx, eax\n");
  fprintf(fpasm,"\tjnl more_equal_%d\n", etiqueta);

  fprintf(fpasm,"\tmov dword eax, 0\n");
  fprintf(fpasm,"\tjmp not_more_equal_%d\n", etiqueta);

  fprintf(fpasm,"more_equal_%d:\n", etiqueta);
  fprintf(fpasm,"\tmov dword eax, 1\n");
  fprintf(fpasm,"not_more_equal_%d:\n", etiqueta);
  fprintf(fpasm,"\tpush dword eax\n");
}

void menor(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");
  fprintf(fpasm,"\tpop dword ebx\n");

  if(es_variable2){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  if(es_variable1){
    fprintf(fpasm,"\tmov dword ebx, [ebx]\n");
  }

  fprintf(fpasm,"\tcmp ebx, eax\n");
  fprintf(fpasm,"\tjl less_%d\n", etiqueta);

  fprintf(fpasm,"\tmov dword eax, 0\n");
  fprintf(fpasm,"\tjmp not_less_%d\n", etiqueta);

  fprintf(fpasm,"less_%d:\n", etiqueta);
  fprintf(fpasm,"\tmov dword eax, 1\n");
  fprintf(fpasm,"not_less_%d:\n", etiqueta);
  fprintf(fpasm,"\tpush dword eax\n");
}

void mayor(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");
  fprintf(fpasm,"\tpop dword ebx\n");

  if(es_variable2){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  if(es_variable1){
    fprintf(fpasm,"\tmov dword ebx, [ebx]\n");
  }

  fprintf(fpasm,"\tcmp ebx, eax\n");
  fprintf(fpasm,"\tjg more_%d\n", etiqueta);

  fprintf(fpasm,"\tmov dword eax, 0\n");
  fprintf(fpasm,"\tjmp not_more_%d\n", etiqueta);

  fprintf(fpasm,"more_%d:\n", etiqueta);
  fprintf(fpasm,"\tmov dword eax, 1\n");
  fprintf(fpasm,"not_more_%d:\n", etiqueta);
  fprintf(fpasm,"\tpush dword eax\n");
}

void leer(FILE* fpasm, char* nombre, int tipo){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpush _%s\n", nombre);
  if (tipo == BOOLEANO){
    fprintf(fpasm,"\tcall scan_boolean\n");
  }else{
    fprintf(fpasm,"\tcall scan_int\n");
  }

  fprintf(fpasm,"\tadd esp, 4\n");
}

void escribir(FILE* fpasm, int es_variable, int tipo){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");

  if(es_variable==1){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  fprintf(fpasm,"\tpush dword eax\n");

  if (tipo==BOOLEANO){
    fprintf(fpasm,"\tcall print_boolean\n");
  }else{
    fprintf(fpasm,"\tcall print_int\n");
  }

  fprintf(fpasm,"\tadd esp, 4\n");
  fprintf(fpasm,"\tcall print_endofline\n");
}

void ifthenelse_inicio(FILE* fpasm, int exp_es_variable, int etiqueta){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");

  if (exp_es_variable){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  fprintf(fpasm,"\tcmp dword eax, 1\n");
  fprintf(fpasm,"\tjne fin_si_%d\n", etiqueta);
}

void ifthen_inicio(FILE* fpasm, int exp_es_variable, int etiqueta){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");

  if (exp_es_variable){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  fprintf(fpasm,"\tcmp dword eax, 1\n");
  fprintf(fpasm,"\tjne fin_si_%d\n", etiqueta);
}


void ifthenelse_fin(FILE* fpasm, int etiqueta){
  if (!fpasm){
    return;
  }

  fprintf(fpasm,"fin_sino_%d:\n", etiqueta);
}


void ifthen_fin(FILE* fpasm, int etiqueta){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"fin_si_%d:\n", etiqueta);
}


void ifthenelse_fin_then(FILE* fpasm, int etiqueta){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tjmp fin_sino_%d\n", etiqueta);
  fprintf(fpasm,"fin_si_%d:\n", etiqueta);
}


void while_inicio(FILE* fpasm, int etiqueta){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"while_inicio_%d:\n", etiqueta);
}


void while_exp_pila(FILE* fpasm, int exp_es_variable, int etiqueta){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");

  if (exp_es_variable){
    fprintf(fpasm,"\tmov dword eax, [eax]\n");
  }

  fprintf(fpasm,"\tcmp dword eax, 1\n");
  fprintf(fpasm,"\tjne fin_while_%d\n", etiqueta);
}

void while_fin(FILE* fpasm, int etiqueta){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tjmp while_inicio_%d\n", etiqueta);
  fprintf(fpasm,"fin_while_%d:\n", etiqueta);
}

void escribir_elemento_vector(FILE* fpasm, char * nombre_vector,
                              int tam_max, int exp_es_direccion){
  if (!fpasm)
    return;

  fprintf(fpasm,"\tpop dword eax\n");

  if (exp_es_direccion == 1)
  {
    fprintf(fpasm,"\tmov eax, [eax]\n");
  }

  fprintf(fpasm,"\tcmp eax, 0\n");
  fprintf(fpasm,"\tjl error_vector\n");//cambia

  fprintf(fpasm,"\tcmp eax, %d\n", tam_max);
  fprintf(fpasm,"\tjge error_vector\n");//cambiar


  fprintf(fpasm,"\tmov dword ebx, _%s\n", nombre_vector);//antes ebx estaba con edx
  fprintf(fpasm,"\tlea eax, [ebx + eax*4]\n");
  fprintf(fpasm,"\tpush dword eax\n");
}


void declararFuncion(FILE* fd_asm, char * nombre_funcion, int num_var_loc){
  if(!fd_asm){
    return;
  }

  fprintf(fd_asm,"_%s:\n", nombre_funcion);
  fprintf(fd_asm,"\tpush ebp\n");
  fprintf(fd_asm,"\tmov ebp, esp\n");
  fprintf(fd_asm,"\tsub dword esp, %d\n", 4 * num_var_loc);
}


void retornarFuncion(FILE* fd_asm, int es_variable){
  if(!fd_asm){
    return;
  }

  fprintf(fd_asm,"\tpop dword eax\n");

  if(es_variable){
    fprintf(fd_asm,"\tmov eax, [eax]\n");
  }

  fprintf(fd_asm,"\tmov esp, ebp\n");
  fprintf(fd_asm,"\tpop dword ebp\n");
  fprintf(fd_asm,"\tret\n");
}


void escribirParametro(FILE* fpasm, int pos_parametro, int num_total_parametros){
  if (!fpasm){
    return;
  }

  int d_ebp;
  d_ebp = 4 * (1 + (num_total_parametros - pos_parametro));

  fprintf(fpasm,"\tlea eax, [ebp + %d]\n", d_ebp);
  fprintf(fpasm,"\tpush dword eax\n");
}


void escribirVariableLocal(FILE* fpasm, int posicion_variable_local){
  if(!fpasm){
    return;
  }

  int d_ebp;
  d_ebp = 4 * posicion_variable_local;

  fprintf(fpasm,"\tlea eax, [ebp - %d]\n", d_ebp);
  fprintf(fpasm,"\tpush dword eax\n");
}


void asignarDestinoEnPila(FILE* fpasm, int es_variable){
  if(!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword eax\n");
  fprintf(fpasm,"\tpop dword ebx\n");

  if (es_variable){
    fprintf(fpasm,"\tmov ebx, [ebx]\n");
  }

  fprintf(fpasm,"\tmov [eax], ebx\n");
}

void asignarVectorEnPila(FILE* fpasm, int es_variable){
  if (!fpasm){
    return;
  }

  fprintf(fpasm,"\tpop dword ebx\n");
  fprintf(fpasm,"\tpop dword eax\n");

  if(es_variable){
    fprintf(fpasm,"\tmov ebx, [ebx]\n");
  }

  fprintf(fpasm,"\tmov [eax], ebx\n");
}


void operandoEnPilaAArgumento(FILE* fd_asm, int es_variable){
  if(!fd_asm){
    return;
  }

  if(es_variable){
    fprintf(fd_asm,"\tpop dword eax\n");
    fprintf(fd_asm,"\tmov eax, [eax]\n");
    fprintf(fd_asm,"\tpush dword eax\n");
  }
}


void llamarFuncion(FILE* fd_asm, char * nombre_funcion, int num_argumentos){
  if (!fd_asm){
    return;
  }

  fprintf(fd_asm,"\tcall _%s\n", nombre_funcion);
  limpiarPila(fd_asm, num_argumentos);
  fprintf(fd_asm,"\tpush dword eax\n");
}

void limpiarPila(FILE* fd_asm, int num_argumentos){
  if (!fd_asm){
    return;
  }

  
}
