
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ID = 258,
     NUMBER = 259,
     NOTOKEN = 260,
     LPARENT = 261,
     RPARENT = 262,
     LCURLY = 263,
     RCURLY = 264,
     COMA = 265,
     SEMICOLON = 266,
     EQUAL = 267,
     INT = 268,
     FLOAT = 269,
     LONG = 270,
     VOID = 271,
     CHAR = 272,
     CHARSTAR = 273,
     AMPERSAND = 274,
     OROR = 275,
     ANDAND = 276,
     EQUALEQUAL = 277,
     NOTEQUAL = 278,
     LESS = 279,
     GREAT = 280,
     LESSEQUAL = 281,
     GREATEQUAL = 282,
     PLUS = 283,
     MINUS = 284,
     TIMES = 285,
     DIVIDE = 286,
     PERCENT = 287,
     IF = 288,
     ELSE = 289,
     WHILE = 290,
     DO = 291,
     FOR = 292,
     CONTINUE = 293,
     BREAK = 294,
     RETURN = 295,
     LSQUBRACKT = 296,
     RSQUBRACKT = 297,
     LOWER_THAN_ELSE = 298
   };
#endif
/* Tokens.  */
#define ID 258
#define NUMBER 259
#define NOTOKEN 260
#define LPARENT 261
#define RPARENT 262
#define LCURLY 263
#define RCURLY 264
#define COMA 265
#define SEMICOLON 266
#define EQUAL 267
#define INT 268
#define FLOAT 269
#define LONG 270
#define VOID 271
#define CHAR 272
#define CHARSTAR 273
#define AMPERSAND 274
#define OROR 275
#define ANDAND 276
#define EQUALEQUAL 277
#define NOTEQUAL 278
#define LESS 279
#define GREAT 280
#define LESSEQUAL 281
#define GREATEQUAL 282
#define PLUS 283
#define MINUS 284
#define TIMES 285
#define DIVIDE 286
#define PERCENT 287
#define IF 288
#define ELSE 289
#define WHILE 290
#define DO 291
#define FOR 292
#define CONTINUE 293
#define BREAK 294
#define RETURN 295
#define LSQUBRACKT 296
#define RSQUBRACKT 297
#define LOWER_THAN_ELSE 298




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 22 "myc.yacc"

  float num;
  char *id;
  exp_node *exp_node_ptr;
  statement *st;
  int t;



/* Line 1676 of yacc.c  */
#line 148 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


