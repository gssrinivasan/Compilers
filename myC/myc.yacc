%{
#include <iostream>
#include <string>
#include <stdlib.h>
#include <stdio.h>
#include <map>
#include <list>
#include "myc.h"

using namespace std;

 extern FILE *yyin;

// the root of the abstract syntax tree
 statement *root;

// for keeping track of line numbers in the program we are parsing
  int line_num = 1;

// function prototypes, we need the yylex return prototype so C++ won't complain
int yylex();
void yyerror(char * s);
%}

//%start main

%token START_main START_program;

%start pickone;

%union {
  float num;
  char *id;
  exp_node *exp_node_ptr;
  statement *st;
}
%error-verbose

%token <num> NUMBER
%token <id> ID
//%token	<id> ID
%token 	NOTOKEN LPARENT RPARENT LBRACE RBRACE LCURLY RCURLY COMA SEMICOLON EQUAL STRING_CONST INT FLOAT LONG LONGSTAR VOID CHAR CHARSTARSTAR INTEGER_CONST AMPERSAND OROR ANDAND EQUALEQUAL NOTEQUAL LESS GREAT LESSEQUAL GREATEQUAL PLUS MINUS TIMES DIVIDE PERCENT IF ELSE WHILE DO FOR CONTINUE BREAK RETURN 


%type <st> function//c
%type <st> global_var//c
%type <st> call_arg_list//c
%type <st> call_arguments//c
%type <exp_node_ptr> main
%type <exp_node_ptr> program
%type <exp_node_ptr> arguments
%type <exp_node_ptr> arg_list
%type <exp_node_ptr> function_or_var_list
%type <exp_node_ptr> statement
%type <exp_node_ptr> assignment
%type <exp_node_ptr> local_var
%type <exp_node_ptr> compound_statement
%type <exp_node_ptr> statement_list
%type <exp_node_ptr> arg
%type <exp_node_ptr> global_var_list
%type <exp_node_ptr> call
%type <exp_node_ptr> expression
%type <exp_node_ptr> logical_or_expr
%type <exp_node_ptr> logical_and_expr
%type <exp_node_ptr> equality_expr
%type <exp_node_ptr> relational_expr
%type <exp_node_ptr> additive_expr
%type <exp_node_ptr> multiplicative_expr
%type <exp_node_ptr> primary_expr
%type <exp_node_ptr> local_var_list
%type <exp_node_ptr> jump_statement

%%


pickone:
  START_main main
| START_program program;


main : call
       | assignment 
       | statement
       | expression
       | primary_expr
       | compound_statement

program : function_or_var_list {}
        ;

function_or_var_list:
        function_or_var_list function
        | function_or_var_list global_var
        | expression
	;

function:
         var_type ID
         {

	 	 }
        LPARENT arguments RPARENT {
         
		 }
        compound_statement
         {
   
         }
	;

arg_list:
         arg
         | arg_list COMA arg
	 ;

arguments:
         arg_list
	 | /*empty*/
	 ;

arg: var_type ID SEMICOLON {
   };

global_var: 
        var_type global_var_list SEMICOLON {

		};

global_var_list: ID {

        }
| global_var_list COMA ID {

}
        ;

var_type: CHAR | INT | FLOAT | CHARSTARSTAR | LONG | LONGSTAR | VOID
		;
		
assignment:
     ID EQUAL expression {
	 	
		}
	 | ID LBRACE expression RBRACE EQUAL expression {

	 	
	 }
	 ;

call :
	 ID LPARENT  call_arguments RPARENT {
		
	 }
      ;

call_arg_list:
         expression {
		
	 }
         | call_arg_list COMA expression {
	
	 }

	 ;

call_arguments:
         call_arg_list 
	 | /*empty*/ 
	 ;

expression :
         logical_or_expr
	 ;

logical_or_expr:
         logical_and_expr
	 | logical_or_expr OROR logical_and_expr {
		
	}
	 ;

logical_and_expr:
         equality_expr
	 | logical_and_expr ANDAND equality_expr {
		
	}
	 ;

equality_expr:
         relational_expr
	 | equality_expr EQUALEQUAL relational_expr {
	 	
	 }
	 | equality_expr NOTEQUAL relational_expr {
	 	
	 }
	 ;

relational_expr:
         additive_expr
	 | relational_expr LESS additive_expr {
	 
	 }
	 | relational_expr GREAT additive_expr {
	 	
	 }
	 | relational_expr LESSEQUAL additive_expr {
	 	
	 }
	 | relational_expr GREATEQUAL additive_expr {
	 	
	 }
	 ;

additive_expr:
          multiplicative_expr
	  | additive_expr PLUS multiplicative_expr {
		
	  }
	  | additive_expr MINUS multiplicative_expr {
	  	
	  }
	  ;

multiplicative_expr:
          primary_expr
	  | multiplicative_expr TIMES primary_expr {
		
      }
	  | multiplicative_expr DIVIDE primary_expr {
	  	
	  }
	  | multiplicative_expr PERCENT primary_expr {
	  	
	  }
	  ;

primary_expr:
	  call
	| ID {
		 
	  }
	  | ID LBRACE expression RBRACE {

	  	
		
	  }
	  
	  | INTEGER_CONST {
		  
	  }
	  | LPARENT expression RPARENT
	  ;

compound_statement:
	 LCURLY statement_list RCURLY
	 ;

statement_list:
         statement_list statement
	 | /*empty*/
	 ;

local_var:
        var_type local_var_list SEMICOLON {
		
		}
		;

local_var_list: ID {
		
			}
        | local_var_list COMA ID {
			
			}
        ;

statement:
         assignment SEMICOLON
	 | call SEMICOLON {
	 	
	 }
	 | local_var
	 | compound_statement
	 | IF LPARENT expression RPARENT {

	 
	 } statement {
	 	

	 } 
               else_optional {
	 	
	 }
	 | WHILE LPARENT expression RPARENT {
		
         }
         statement {
		
	 }
	 | DO statement WHILE LPARENT expression RPARENT SEMICOLON {
	 	
	 }
	 
	 | FOR LPARENT assignment SEMICOLON expression SEMICOLON assignment RPARENT {
		
	 } statement {
	 	
	 }
	 | jump_statement
	 ;

else_optional:
         ELSE  statement
	 | /* empty */
         ;

jump_statement:
       CONTINUE SEMICOLON {
		
     }
	 | BREAK SEMICOLON {
	 
	 }
	 | RETURN expression SEMICOLON {
		 
	 }
	 ;

%%




int main(int argc, char **argv)
{ 
  if (argc>1) yyin=fopen(argv[1],"r");

  //  yydebug = 1;
  yyparse();

  cout << "---------- list of input program------------" << endl << endl;

  root -> print();

  cout << "---------- exeuction of input program------------" << endl << endl;
  

  root->evaluate();
}

void yyerror(const char * s)
{
	fprintf(stderr,"%s:%d: %s\n",line_num, s);
}


