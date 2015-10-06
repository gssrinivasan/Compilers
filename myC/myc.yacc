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

%start status
 
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

%type <st> status
%type <st> function
%type <st> global_var
%type <st> call_arg_list
%type <st> call_arguments
%type <exp_node_ptr> program
%type <exp_node_ptr> main
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
status:
          main
        {
         root = $$;
        }
        | program
        {
         $$ = $1;
        }
        ;
       
main: compound_statement
        {
        $$ = $1;
        }
      | expression
        {
         $$ = $1;
        }
      | call
        {
       $$ = $1; 
        }
  ;
        
program: function_or_var_list 
        {  
        $$ = $1;
        }
  ;


function_or_var_list:
        function_or_var_list function
        //new
        | function_or_var_list global_var
        //new
        | expression
         {$$ = $1;}
        | compound_statement
        {$$ = $1;}
	;

function:
         var_type ID LPARENT arguments RPARENT compound_statement
         {
          //new
          //new
          $$ = $6;
         }
	;

arg_list:
         arg 
         {
          $$ = $1;
         }
         | arg_list COMA arg 
         {
          //new
         }
  ;

arguments:
         arg_list
         {
          $$ = $1
         }
	       | /*empty*/
  ;

arg: 
    var_type ID SEMICOLON 
    {
     //new    
    }
  ;

global_var: 
        var_type global_var_list SEMICOLON 
        {
         //new
        }
  ;

global_var_list: 
         ID 
         {
          //new
         }
         | global_var_list COMA ID 
         {
          //new
         }
  ;

var_type: CHAR | INT | FLOAT | CHARSTARSTAR | LONG | LONGSTAR | VOID
  
  ;
		
assignment:
          ID EQUAL expression 
           {
	 	        //new
		       }
	         | ID LBRACE expression RBRACE EQUAL expression 
           {
           //new
           $$ = $3;
           //new
           $$ = $6;
           }
  ;

call:
	  ID LPARENT  call_arguments RPARENT 
    {
		 //new
      $$ = $3;
    }
      ;

call_arg_list:
           expression 
           {
		        $$ = $1 ;
	         }
           |call_arg_list COMA expression 
           {
	          //new
           }

	 ;

call_arguments:
            call_arg_list 
            {
             $$ = $1;
            }
	          | /*empty*/ 
	 ;

expression:
          logical_or_expr
          {
          $$ = $1;
          }	 
  ;

logical_or_expr:
              logical_and_expr
              {
               $$ = $1;
              }
	            | logical_or_expr OROR logical_and_expr 
              {
		           //new
              }
	 ;

logical_and_expr:
               equality_expr
               {
                $$ = $1;
               }
	             | logical_and_expr ANDAND equality_expr 
               {
	              //new
               }
	 ;

equality_expr:
            relational_expr
            {
             $$ = $1;
            }
	          | equality_expr EQUALEQUAL relational_expr 
            {
             //new
	 	        }
	          | equality_expr NOTEQUAL relational_expr 
            {
             //new
            }
  ;

relational_expr:
              additive_expr
              {
               $$ = $1;
              }
	            | relational_expr LESS additive_expr 
              {
               //new
	            }
	            | relational_expr GREAT additive_expr 
              {
	 	           //new
	            }
              | relational_expr LESSEQUAL additive_expr 
              {
	 	           //new
              }
	            | relational_expr GREATEQUAL additive_expr 
              {
	 	           //new
	            }
  ;

additive_expr:
            multiplicative_expr
            {
             $$ = $1;
            }
            | additive_expr PLUS multiplicative_expr 
            {
		          //new
            }
	          | additive_expr MINUS multiplicative_expr 
            {
	  	       //new
            }
  ;

multiplicative_expr:
                  primary_expr
                  {
                   $$ = $1;
                  }
	                | multiplicative_expr TIMES primary_expr 
                  {
                   //new
		              }
	                | multiplicative_expr DIVIDE primary_expr 
                  {
                   //new
  	              }
	                | multiplicative_expr PERCENT primary_expr 
                  {
                   //new
  	              }
  ;

primary_expr:
	          call
            {
             $$ = $1;
            }         
	          | ID 
            {
             $$ = $1;
		        }
	          | ID LBRACE expression RBRACE 
            {
              //new
            }
	          | LPARENT expression RPARENT
            {
             $$ = $2;
            }         
  ;

compound_statement:
	               LCURLY statement_list RCURLY
                 {
                  $$ = $2;
                 }                        
  ;

statement_list:
            statement_list statement
            {
             //new
            }
            | /*empty*/
  ;

local_var:
        var_type local_var_list SEMICOLON 
        {
	       //new
        }
  ;

local_var_list: 
              ID 
              {
		            $$ = $1;
              }
              | local_var_list COMA ID 
              {
			         //new
              }
  ;

statement:
         assignment SEMICOLON
         {
          $$ = $1;
         }
	       | call SEMICOLON 
         {
          $$ = $1;
	 	     }
	       | local_var
         {
          $$ = $1;
         }      
	       | compound_statement
         {
          $$ = $1;
         }      
	       | IF LPARENT expression RPARENT LCURLY statement RCURLY
         {
          //new
          $$ = $6
         }
         | IF LPARENT expression RPARENT LCURLY statement RCURLY ELSE LCURLY statement RCURLY
         {
          //new
          $$ = $6 || $$ = $10; 
         }
	       | WHILE LPARENT expression RPARENT LCURLY statement RCURLY
         {
		      //new
          $$ = $6;      
         }
         | DO statement WHILE LPARENT expression RPARENT SEMICOLON 
         {
          $$ = $2 ;
          //new
	 	     }
	       | FOR LPARENT assignment SEMICOLON expression SEMICOLON assignment RPARENT LCURLY statement RCURLY
         {
	 	      //new
          //new
          //new
          $$ = $10;           
	       }
	       | jump_statement
         {
          $$ = $1;
         }      
	 ;


jump_statement:
       CONTINUE SEMICOLON 
       {
        //new
		   }
	     | BREAK SEMICOLON 
       {
        //new
	     }
	     | RETURN expression SEMICOLON 
       {
        //new
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
