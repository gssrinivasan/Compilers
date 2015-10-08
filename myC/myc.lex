/*
 *scanner for the simple "myC-" language
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
#include "myc.h"
#include "y.tab.h"

extern int line_num;

%}

%option noyywrap
DIGIT [0-9]
LETTER [a-zA-Z]

%x ERROR

%%

\n      
{ 
line_num++;
YY_FLUSH_BUFFER;
 }

"(" 	{
		return LPARENT;
	}

")" 	{
		return RPARENT;
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

"]" 	{
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
 
{DIGIT}+ {
	yylval.num = atof(yytext); return NUMBER;
	}

{LETTER}[0-9a-zA-Z]* {
        yylval.id = strdup(yytext); return ID;
	}

[ \t\f\r]	;		 // ignore white space

. { BEGIN(ERROR); yymore(); }
<ERROR>[^{DIGIT}{LETTER}+\-\*(){}= \t\n\f\r] { yymore(); }
<ERROR>(.|\n) { yyless(yyleng-1); printf("error token: %s on line %d\n", yytext, line_num); 
           BEGIN(INITIAL); }
           
%%
	
