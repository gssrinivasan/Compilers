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

#include <string.h>
#include "simple.h"
#include "y.tab.h"

extern int line_num;

%}

%option noyywrap
DIGIT [0-9]
LETTER [a-zA-Z]

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
		return RSQUBRACKT;
	}

"[" 	{
		return LSQUBRACKT;
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
 
"[" 	{
		return LSQUBRACKT;
	}

"[" 	{
		return RSQUBRACKT;
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
        
"main" {
    return MAIN;  
  }
  
"char" { 
		return CHAR;
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
 
print   { return PRINT; }
{DIGIT}+ {
	yylval.num = atof(yytext); return NUMBER;
	}

{LETTER}[0-9a-zA-Z]* {
        yylval.id = strdup(yytext); return ID;
	}

[ \t\f\r]	;		 // ignore white space
//[A-Za-z][A-Za-z0-9]*  {
//		/* Assume that file names have only alpha chars */
//		yylval.id = strdup(yytext);
//		return WORD;
//	}

//-?[0-9][0-9]*  {
//		/* Assume that file names have only alpha chars */
//		yylval.id = strdup(yytext);
//		return INTEGER_CONST;
//	}

// \"[^\"]*\"  {
//		/* Assume that file names have only alpha chars */
//		yylval.id = strdup(yytext);
//		return STRING_CONST;
//	}

.	{
		/* Invalid character in input */
		return NOTOKEN;
	}

%%
	
