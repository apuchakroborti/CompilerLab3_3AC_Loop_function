/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INTEGER = 258,
    REAL = 259,
    PLUS = 260,
    MINUS = 261,
    MUL = 262,
    DIV = 263,
    OPEN = 264,
    CLOSE = 265,
    ASSIGN = 266,
    ID = 267,
    SEMICOLON = 268,
    COMMA = 269,
    TRUE = 270,
    FALSE = 271,
    NOT = 272,
    GREATER_EQ = 273,
    GREATER = 274,
    LESS = 275,
    LESS_EQ = 276,
    EQ = 277,
    NOT_EQ = 278,
    OR = 279,
    AND = 280,
    COLON = 281,
    THEN = 282,
    IF = 283,
    FI = 284,
    ELSE = 285,
    DO = 286,
    OD = 287
  };
#endif
/* Tokens.  */
#define INTEGER 258
#define REAL 259
#define PLUS 260
#define MINUS 261
#define MUL 262
#define DIV 263
#define OPEN 264
#define CLOSE 265
#define ASSIGN 266
#define ID 267
#define SEMICOLON 268
#define COMMA 269
#define TRUE 270
#define FALSE 271
#define NOT 272
#define GREATER_EQ 273
#define GREATER 274
#define LESS 275
#define LESS_EQ 276
#define EQ 277
#define NOT_EQ 278
#define OR 279
#define AND 280
#define COLON 281
#define THEN 282
#define IF 283
#define FI 284
#define ELSE 285
#define DO 286
#define OD 287

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 87 "ass.y" /* yacc.c:1909  */

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

#line 131 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
