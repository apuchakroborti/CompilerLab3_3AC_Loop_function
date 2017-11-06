%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
//#define YYSTYPE char*

int token_no=1;
//void print_temp();
char left[100][100];
char right[100][100];
int left_index=0;
int right_index=0;
//void print_comma_exprs(); 
char global_data[1000];
int newLabel=0;
char lev[10];


/*
void next(char t[]) {
	t[0] = 't';
	sprintf(t+1,"%d",curr++);
}
void nextVar(char* ID)
{
	strcpy(vrs[v],ID);
	v++;
	//printf("Here %d\n",v);
}
void nextExpr(char* expr)
{
	strcpy(ers[e],expr);
	e++;
}
void printVars()
{
	int i;
	printf("total vars = %d\n",v-1);
	for(i=1;i<v;i++)
		printf("%s = %s\n",vrs[i],ers[i]);
}*/

void print(char* path)
{
	int i,len;
	len=strlen(path);
	for(i=0;i<len;i++)
	{
		if(path[i]==';')
			printf("\n");
		else
			printf("%c",path[i]);
	}
	
	memset(global_data,0,sizeof(global_data));
}

char gen(int l)
{
	memset(lev,0,sizeof(lev));
	lev[0]='L';
	sprintf(lev+1,"%d",l);
	//return lev;
}

void print_temp(char str[])
{
	str[0]='t';
	str[1]=token_no+'0';
	str[2]='\0';
	token_no++;
	
}
void print_comma_exprs()
{
	int in=0;
	for(in=0;in<left_index;in++)
	{
	 printf("%s = %s\n",left[in],right[in]);
	}
}


%}

%union{
	char id[10000];
	struct s
	{
		char tru[10];
		char fals[10];
		char next[10];
		char code[10000];
		char temp[10];
	} st;
	//ETYPE eval; 
};


%token <id> INTEGER REAL
%token <id> PLUS MINUS MUL DIV
%token <id> OPEN CLOSE
%token <id> ASSIGN ID SEMICOLON COMMA
%token <id> TRUE FALSE
%token <id> NOT GREATER_EQ GREATER LESS LESS_EQ EQ NOT_EQ OR AND
%token <id> COLON THEN IF FI ELSE DO OD 
%type <st>  program stmts stmt selection alts alt guard assignment iteration
%type <id>  vars exprs expr disjunction conjunction negation relation sum term factor subprogram


%%
program : stmts {}//{p($1.code);}
| {}
;
stmts : stmt {}//{strcpy($$.code,$1.code);}
| stmts SEMICOLON stmt {}
;

stmt : selection { print($1.code); }//{strcpy($$.code,$1.code);}
| iteration {}
| assignment
{
	strcat($$.code,global_data);
	//printf("function %s\nout\n",global_data);
	memset(global_data,0,sizeof(global_data));
}
;

selection : IF alts FI
{
	//strcpy($$.code,$2.code);
	//p($2.code);//chnage
	strcpy($$.code,$2.code);//change
}
;

iteration : DO alts OD 
{
		
	char begin[100];
	gen(newLabel);
	newLabel++;
	strcpy(begin,lev);
	
	strcat($$.code,begin);
	strcat($$.code,":;");
	strcat($$.code,$2.code);
	strcat($$.code,"goto ");
	strcat($$.code,$2.tru);
	strcat($$.code,";");		
	strcat($$.code,"goto ");
	strcat($$.code,begin);
	strcat($$.code,";");
	strcat($$.code,$2.fals);
	strcat($$.code,":;");
	print($$.code);	
}
;
alts : alt
{

	strcpy($$.code,$1.code);
	/*//chnage
	gen(newLabel);
	strcat($1.next,lev);
	newLabel++;
	strcat($$.code,$1.code);
	strcat($$.code,";");	
	strcat($$.code,$1.next);
	strcat($$.code,":;");
	//strcat($$.code,)
	//strcpy($$.code,$1.code);
	//change
	*/
}
| alts COLON alt//$1=alts $2=:: $3=alt 
{
	/*
	gen(newLabel);
	newLabel++;
	strcat($1.tru,lev);
	gen(newLabel);
	newLabel++;
	strcat($1.fals,lev);
	newLabel++;
	strcat($$.code,);
	*/	
}
;

alt : guard THEN stmts//alt=S  $1=B  $2  $3=S1 ;;S->if (B) S1
{	
	strcpy($$.code, $1.code);
	strcat($$.code, $1.tru);
	strcat($$.code, ":");
	strcat($$.code, ";");
	strcat($$.code, $3.code);
	int i;
	for(i=0;i<left_index;i++)
	{
		strcat($$.code, left[i]);
		strcat($$.code, " = ");
		strcat($$.code, right[i]);
		strcat($$.code, ";");
	}
	strcat($$.code, $1.fals);
	strcat($$.code, ":;");
	
	//strcat($$.code, ";");
}
;
guard : expr// $$= guard    $1=expr //simple pass
{
	strcpy($$.code, global_data);
	strcat($$.code, "if ");
	strcat($$.code, $1);
	strcat($$.code, " goto ");
	gen(newLabel);
	strcpy($$.tru,lev);
	newLabel++;
	strcat($$.code, $$.tru);
	strcat($$.code, ";");
	gen(newLabel);
	strcpy($$.fals,lev);
	//
	// 
	newLabel++;
	strcat($$.code,"goto ");
	strcat($$.code,$$.fals);
	strcat($$.code,";");
	memset(global_data,0,sizeof(global_data));
	strcpy($$.temp,$1);
}
;

//printf("%s = %s\n",$1, $3);
assignment:  vars ASSIGN exprs SEMICOLON 
{  
	//printf("vars ASSIGN exprs SEMICOLON\n");
		

	if(left_index!=right_index){
		printf("Invalid input\n");	
	}
	else{
		print_comma_exprs();
	}						
}
| vars ASSIGN subprogram ASSIGN exprs//$1 $2 $3 $4 $5 
{
	//printf("ASSIGN subprogram ASSIGN exprs\n");
	int t_r=left_index;
	int t_p=right_index;
	//char str[1000];
	int in=0;
	char para[100][100];
	for(in=0;in<t_p;in++)
	{	
		char p[10];
		print_temp(p);
		strcpy(para[in],p);
		printf("%s = %s\n",p,right[in]);
		
	}
	for(in=0;in<t_p;in++)
	{	
		//char p[10];
		//print_temp(p);
		
		printf("param %s\n",para[in]);
		
	}

	printf("call %s %d,%d \n",$3,t_p,t_r);
	for(in=0;in<t_r;in++)
	{
		printf("return %s\n",left[in]);
		
	}
}
|ASSIGN subprogram ASSIGN exprs //$2=function name
{
	
	//printf("ASSIGN subprogram ASSIGN exprs\n");
	//int t_r=left_index;
	int t_p=right_index;
	//char str[1000];
	int in=0;
	char para[100][100];
	for(in=0;in<t_p;in++)
	{	
		char p[10];
		print_temp(p);
		strcpy(para[in],p);
		printf("%s = %s\n",p,right[in]);
		
	}
	for(in=0;in<t_p;in++)
	{	
		//char p[10];
		//print_temp(p);
		
		printf("param %s\n",para[in]);
		
	}

	printf("call %s %d\n",$2,t_p);
	
}
|vars ASSIGN subprogram ASSIGN
{
	
	//printf("ASSIGN subprogram ASSIGN exprs\n");
	int t_r=left_index;
	//int t_p=right_index;
	int t_p=0;
	//char str[1000];
	int in=0;
	char para[100][100];
	
	printf("call %s %d,%d \n",$3,t_p,t_r);
	for(in=0;in<t_r;in++)
	{
		printf("return %s\n",left[in]);
		
	}
	//printf("vars ASSIGNOP subprogram ASSIGNOP in\n");
    	char string[1000]={0};
}
|ASSIGN subprogram ASSIGN
{


	//printf("ASSIGN subprogram ASSIGN exprs\n");
	int t_r=0;
	//int t_p=right_index;
	int t_p=0;
	//char str[1000];
	int in=0;
	char para[100][100];
	
	printf("call %s %d,%d \n",$2,t_p,t_r);
}
;

subprogram:ID{strcpy($$,$1);}
;


vars:ID { strcpy(left[left_index],$1); left_index++; }
|vars COMMA ID { strcpy(left[left_index],$3); left_index++; }
;
exprs: expr { strcpy(right[right_index],$1); right_index++; }
|exprs COMMA expr { strcpy(right[right_index],$3); right_index++; }
;
expr:disjunction { strcpy($$,$1); }
;
disjunction:conjunction { strcpy($$,$1); }
| disjunction OR conjunction 
{ 
	char str[50]; 
	print_temp(str);
	strcat(global_data,str); 
	strcat(global_data," = "); 
	strcat(global_data,$1); 
	strcat(global_data," | " ); 
	strcat(global_data,$3); 
	strcat(global_data,";");	
	//printf("%s = %s < %s \n",str,$1,$3); 
	strcpy($$,str);  
	printf("%s = %s | %s \n",str,$1,$3); 
	//$$ = strdup(str); 
}
;
conjunction: negation { strcpy($$,$1); }
| conjunction AND negation 
{ 
	char str[50]; 
	print_temp(str); 
	strcat(global_data,str); 
	strcat(global_data," = "); 
	strcat(global_data,$1); 
	strcat(global_data," & " ); 
	strcat(global_data,$3); 
	strcat(global_data,";");	
	//printf("%s = %s < %s \n",str,$1,$3); 
	strcpy($$,str); 	
	printf("%s = %s & %s \n",str,$1,$3);
	//$$ = strdup(str); 
}
negation: relation { strcpy($$,$1) ; }
|NOT relation 
{ 
	char str[50]; 
	print_temp(str);	
	strcat(global_data,str); 
	strcat(global_data," = ");  
	strcat(global_data," ~ " ); 
	strcat(global_data,$2); 
	strcat(global_data,";");	 
	//strcat(str,$2);
	strcpy($$,str); 
	//$$ = strdup(str); 
}
;
relation: sum { strcpy($$,$1) ; }
| sum LESS sum 
{ 
	char str[50]; 
	print_temp(str); 
	strcat(global_data,str); 
	strcat(global_data," = "); 
	strcat(global_data,$1); 
	strcat(global_data," < " ); 
	strcat(global_data,$3); 
	strcat(global_data,";");	
	printf("%s = %s < %s \n",str,$1,$3); 
	strcpy($$,str); 
}
| sum LESS_EQ sum 
{ 
	char str[50]; 
	print_temp(str); 
	strcat(global_data,str); 
	strcat(global_data," = "); 
	strcat(global_data,$1); 
	strcat(global_data," <= " ); 
	strcat(global_data,$3); 
	strcat(global_data,";");			
	printf("%s = %s <= %s \n",str,$1,$3); 
	strcpy($$,str); 
}
| sum EQ sum 
{ 
	char str[50]; 
	print_temp(str);
	strcat(global_data,str); 
	strcat(global_data," = "); 
	strcat(global_data,$1); 
	strcat(global_data," = " ); 
	strcat(global_data,$3); 
	strcat(global_data,";");			
	printf("%s = %s = %s \n",str,$1,$3); 
	strcpy($$,str); 
}
| sum NOT_EQ sum 
{ 
	char str[50]; 
	print_temp(str);
	strcat(global_data,str); 
	strcat(global_data," = "); 
	strcat(global_data,$1); 
	strcat(global_data," ~= " ); 
	strcat(global_data,$3); 
	strcat(global_data,";");			
	printf("%s = %s <= %s \n",str,$1,$3); 
	strcpy($$,str); 
	//printf("%s = %s ~= %s \n",str,$1,$3); 
	//$$ = strdup(str); 
}
| sum GREATER_EQ sum 
{ 
	char str[50]; 
	print_temp(str);
	strcat(global_data,str); 
	strcat(global_data," = "); 
	strcat(global_data,$1); 
	strcat(global_data," >= " ); 
	strcat(global_data,$3); 
	strcat(global_data,";");			
	printf("%s = %s >= %s \n",str,$1,$3); 
	strcpy($$,str); 
	//printf("%s = %s >= %s \n",str,$1,$3);
	//$$ = strdup(str); 
}
| sum GREATER sum 
{ 
	char str[50]; 
	print_temp(str);
	strcat(global_data,str); 
	strcat(global_data," = "); 
	strcat(global_data,$1); 
	strcat(global_data," > " ); 
	strcat(global_data,$3); 
	strcat(global_data,";");			
	printf("%s = %s > %s \n",str,$1,$3); 
	strcpy($$,str); 
	
	//printf("%s = %s > %s \n",str,$1,$3); 
	//$$ = strdup(str); 
}
;
sum: term	{ strcpy($$,$1); }
| MINUS term 
{ 
	char str[5000]; 
	print_temp(str);
	str[0]='-';
	sprintf(str+1,"%s",$2); 
	printf("%s = -%s \n",str,$2); 
	strcpy($$,str); 
}
| sum PLUS term 
{ 
	char str[50]; 
	print_temp(str);
	strcat(global_data,str); 
	strcat(global_data," = "); 
	strcat(global_data,$1); 
	strcat(global_data," + " ); 
	strcat(global_data,$3); 
	strcat(global_data,";");
	printf("%s = %s + %s \n", str, $1, $3); 
	strcpy($$,str); 
} 
| sum MINUS term 
{ 
	char str[50]; 
	print_temp(str);
	strcat(global_data,str); 
	strcat(global_data," = "); 
	strcat(global_data,$1); 
	strcat(global_data," - " ); 
	strcat(global_data,$3); 
	strcat(global_data,";"); 
	printf("%s = %s - %s \n", str, $1, $3); 
	strcpy($$,str); 
} 
;
term: factor { strcpy($$, $1); }
| term MUL factor 
{ 
	char str[50]; 
	print_temp(str); 
	strcat(global_data,str); 
	strcat(global_data," = "); 
	strcat(global_data,$1); 
	strcat(global_data," * " ); 
	strcat(global_data,$3); 
	strcat(global_data,";");
	printf("%s = %s * %s \n", str, $1, $3); 
	strcpy($$,str); 
}
| term DIV factor 
{ 
	char str[50]; print_temp(str);
	strcat(global_data,str); 
	strcat(global_data," = "); 
	strcat(global_data,$1); 
	strcat(global_data," / " ); 
	strcat(global_data,$3); 
	strcat(global_data,";");
	printf("%s = %s / %s \n", str, $1, $3); 
	strcpy($$,str); 
}
; 

factor: INTEGER { strcpy($$, $1); } 	
| ID { strcpy($$, $1); }
| OPEN expr CLOSE { strcpy($$, $2); }
| REAL { strcpy($$, $1); }
| TRUE { strcpy($$,"True"); }
| FALSE { strcpy($$,"False");  }
;
%%
extern int yylex();
extern int yyparse();
extern FILE *yyin;

main()
{

	
	// open a file handle to a particular file:
	FILE *myfile = fopen("input.txt", "r");
	// make sure it is valid:
	if (!myfile) {
		printf("I can't open a.snazzle.file!");
		return -1;
	}
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;
	
	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));
	
	//printf("Enter the expression\n");
  	//yyparse();
  	//return 0;
}

yyerror(char *s)
{
  fprintf(stderr, "error1: %s\n", s);
}
