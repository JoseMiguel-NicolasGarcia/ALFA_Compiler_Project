//Constantes de utilidad
#define CANTIDAD_MAXIMA 6000

//Categorias
#define VARIABLE 1
#define PARAMETRO 2
#define FUNCION 3

//Tipo de dato
#define INT_TH 0
#define BOOLEAN 1


//Tipo variable
#define ESCALAR_TH 0
#define VECTOR_TH 1


typedef struct _Simbolo
{
  int categoria;
  int tipo_data;
  int tipo_variable;
  char *id;
  int posicion; //posicion que ocupan las variables
  int posicion_parametros;
  int numero_parametros;
  int numero_variables;

  int valor; // Esto sirve para diversas cosas

} Simbolo;
typedef struct _ColumnaSimbolo
{
    int elementos_columna;
    Simbolo **columna;

} ColumnaSimbolo;

typedef struct _TablaHash
{
    
    int elementos_tabla;
    ColumnaSimbolo **tabla;

} TablaHash;


/*FUNCIONES DE CREACIÓN*/
Simbolo *crearSimbolo(int categoria, int tipo_data, int tipo_variable, char *id, int posicion, int numero_variables, int valor,int numero_parametros, int posicion_parametros);
ColumnaSimbolo *crearColumnaSimbolo();
TablaHash *crearTablaHash(int elementos_tabla);

/*FUNCIONES DE LIBERACIÓN*/
void liberarSimbolo(Simbolo *simb);
void liberarColumnaSimbolo(ColumnaSimbolo *columna);
void liberarTablaHash(TablaHash *tabla);


/*FUNCIONES HASH*/
long funcionHash(unsigned char *str);


/*FUNCIONES DE BUSQUEDA*/
int buscarSimbolo(char *id, ColumnaSimbolo *columna);
Simbolo *buscarenTabla(char *simbolo, TablaHash *tabla);


/* FUNCIONES DE INSERCIÓN*/
int insertarSimbolo(ColumnaSimbolo *columna, Simbolo *simbolo);
int insertarTabla(TablaHash *table, Simbolo *simbolo);
