%{
#include "y.tab.h"
#include<string.h>
%}

%%
[ \t\n]   { /* White space and new line will be ignore */ }

"+"	{ return PLUS; }
"-"	{ return MINUS; }
"*"	{ return MUL; }
"/"	{ return DIV; }
":="	{ return ASSIGN; }
","	{ return COMMA; }
";"	{ return SEMICOLON; }
"?"	{return THEN; }
"::"	{return COLON; }

"("     { return OPEN; }
")"     { return CLOSE; }
"True"  { return TRUE; }
"False" { return FALSE; }
"~" 	{return NOT; }
"<" 	{return LESS; }
"<=" 	{return LESS_EQ; }
"=" 	{return EQ; }
"~=" 	{return NOT_EQ; }
">=" 	{return GREATER_EQ; }
">" 	{return GREATER; }
"|" 	{return OR; }
"&" 	{return AND ; }
"if" 	{ return IF; }
"fi" 	{ return FI; }
"else"	{ return ELSE; }
"do"	{ return DO;}
"od"	{ return OD; }

[A-Za-z]+([0-9]*[a-zA-Z]*)* { strcpy(yylval.id,yytext); return ID; }
[0-9]+	{ strcpy(yylval.id,yytext); return INTEGER; }
[0-9]+"."[0-9]+	{ strcpy(yylval.id,yytext); return REAL; }

%%
