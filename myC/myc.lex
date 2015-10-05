/*
 * simple.l: simple scanner for the simple "myC-" language
 *
 */


%option interactive
%{
/* * * * * * * * * * * *
 * * * DEFINITIONS * * *
 * * * * * * * * * * * */
%}

%{
// Ray Byler, CS560, 23 April 96
// Expression Interpreter, Lexer Portion

// y.tab.h contains the token number values produced by the parser
#include <string.h>
#include "simple.h"
#include "y.tab.h"

extern int line_num;

%}

%option noyywrap

%%

\n 	{
		line_num++;
	}

[ \t\r]	{
		/* Discard newlines, spaces, and tabs */
     	}	

"(" 	{
		return LPARENT;
	}

")" 	{
		return RPARENT;
	}

"[" 	{
		return LBRACE;
	}

"]" 	{
		return RBRACE;
	}

"{" 	{
		return LCURLY;
	}

"}" 	{
		return RCURLY;
	}

"," 	{
		return COMA;
	}

";" 	{
		return SEMICOLON;
	}

"=" 	{
		return EQUAL;
	}

"&" 	{
		return AMPERSAND;
	}

"||"    {
                return OROR;
        }

"&&"    {
                return ANDAND;
        }

"=="    {
                return EQUALEQUAL;
        }

"!="    {
                return NOTEQUAL;
        }

"<"     {
                return LESS;
        }

">"     {
                return GREAT;
        }

"<="    {
                return LESSEQUAL;
        }

">="    {
                return GREATEQUAL;
        }

"+"     {
                return PLUS;
        }

"-"     {
                return MINUS;
        }

"*"     {
                return TIMES;
        }

"/"     {
                return DIVIDE;
        }

"%"     {
                return PERCENT;
        }

"char*" { 
		return CHARSTAR;
	}

"char**" { 
		return CHARSTARSTAR;
	}

"long*" {
		return LONGSTAR;
	}

"long" 	{
		return LONG;
	}
"int" {
   return INT;
}

"float" {
   return FLOAT;
}

"void" 	{
		return VOID;
	}

"if" 	{
		return IF;
	}

"else" 	{
		return ELSE;
	}

"while"	{
		return WHILE;
	}

"do" 	{
		return DO;
	}

"for" 	{
		return FOR;
	}

"continue" {
		return CONTINUE;
	}

"break" {
		return BREAK;
	}

"return" {
		return RETURN;
	}

[A-Za-z][A-Za-z0-9]*  {
		/* Assume that file names have only alpha chars */
		yylval.id = strdup(yytext);
		return WORD;
	}

-?[0-9][0-9]*  {
		/* Assume that file names have only alpha chars */
		yylval.id = strdup(yytext);
		return INTEGER_CONST;
	}

\"[^\"]*\"  {
		/* Assume that file names have only alpha chars */
		yylval.id = strdup(yytext);
		return STRING_CONST;
	}

.	{
		/* Invalid character in input */
		return NOTOKEN;
	}

%%
	
