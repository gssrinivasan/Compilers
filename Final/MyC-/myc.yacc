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
void yyerror(const char *s);
%}

%start status
 
%union {
  float num;
  char *id;
  exp_node *exp_node_ptr;
  statement *st;
  int t;
}

%error-verbose


%token <id> ID 
%token <num> NUMBER
%token 	NOTOKEN LPARENT RPARENT LCURLY RCURLY COMA SEMICOLON EQUAL INT FLOAT LONG VOID CHAR CHARSTAR AMPERSAND OROR ANDAND EQUALEQUAL NOTEQUAL LESS GREAT LESSEQUAL GREATEQUAL PLUS MINUS TIMES DIVIDE PERCENT IF ELSE WHILE DO FOR CONTINUE BREAK RETURN LSQUBRACKT RSQUBRACKT

%type <st> status
%type <st> program
%type <st> global_var
%type <st> conditional_statement
%type <st> return_stmt
%type <st> statement
%type <st> statement_list
%type <st> compound_stmt
%type <st> assignment
%type <st> function_list
%type <st> function
%type <t> var_type
%type <exp_node_ptr> arguments
%type <exp_node_ptr> arg
%type <exp_node_ptr> arg_list
%type <exp_node_ptr> expression
%type <exp_node_ptr> array
%type <exp_node_ptr> call
%type <exp_node_ptr> call_arg_list 
%type <exp_node_ptr> call_arguments
%type <exp_node_ptr> global_var_list
%type <exp_node_ptr> logical_or_expr
%type <exp_node_ptr> logical_and_expr
%type <exp_node_ptr> equality_expr
%type <exp_node_ptr> relational_expr
%type <exp_node_ptr> additive_expr
%type <exp_node_ptr> multiplicative_expr
%type <exp_node_ptr> primary_expr

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%
status: program 
        {root = $$;} 
  ;
program:
        function_list
       { $$=$1; }        
  ;
         
function_list:
            function_list function
            { 
             $$ = new function_parameter ($1,$2);
            }
            | function_list global_var
            {
             $$ = $$ = new function_parameter ($1,$2);
            }
            | 
            {
             $$ = new skip_stmt();
            }
  ;


function: 
       var_type ID LPARENT arguments RPARENT compound_stmt /* LCURLY statement_list RCURLY */
       {
        $$ = new function_definition ($1, $2, $4, $6);
       } 
  ;

compound_stmt:
             LCURLY statement_list RCURLY
             {
             $$ = $2;
             }
  ;
  
arguments:
         arg_list
         {
          $$ = $1;
         }
         | 
         {
          $$ = new skip_stmt();
         }
  ;
  

arg_list:
          arg
          { $$ = $1;}
          | 
          arg_list COMA arg
          {
          $$ = new arg_node ($1,$3);//reusing the global_var declaration node
          }
  ;
  
            
arg:
   var_type ID
   {
    $$ = new param_node($1,$2);
   }   
  ;
  

global_var: 
        var_type ID global_var_list SEMICOLON 
        {
         $$ = new var_node ( $1,$2,$3);
        }
  ;


global_var_list: 
         global_var_list COMA ID  
         {
          $$ = new var_node ($3,$1);
         }
         |
         {
          $$ = new skip_stmt();
         }         
  ;

var_type:
       CHAR
       | INT
       | FLOAT
       | CHARSTAR
       | LONG
       | VOID
  ;


array: 
     var_type ID LSQUBRACKT NUMBER RSQUBRACKT SEMICOLON
     {
      $$ = new arr1d_var($1,$2,$4);
      }
     | var_type ID LSQUBRACKT NUMBER RSQUBRACKT LSQUBRACKT NUMBER RSQUBRACKT SEMICOLON 
     {
      $$ = new arr2d_var($1,$2,$4,$7);
     }
  ;

	
assignment:
           global_var
           {
           $$ = $1;
           }
           |
           array
           {
           $$ = $1;
            }
           |
           var_type ID EQUAL primary_expr SEMICOLON
           {
	 	       $$ = new assignment_stmt ($1,$2,$4);          
		       }
           | 
           expression SEMICOLON
           {
            $$ = $1;
           }
           | 
           ID EQUAL expression SEMICOLON 
           {
           $$ = new assignment_stmt ($1,$3);
           }         
  ;
primary_expr:
             ID 
            {
             $$=new id_node($1);
		        }
	          | ID LSQUBRACKT NUMBER RSQUBRACKT
            {
             $$ = new arr1d_var($1,$3);
            }
            | ID LSQUBRACKT NUMBER RSQUBRACKT LSQUBRACKT NUMBER RSQUBRACKT
            {
             $$ = new arr2d_var($1,$3,$6);
            }
            |NUMBER
            {
            $$= new number_node ($1);
            }
	          | LPARENT expression RPARENT         
            {
             $$ = $2;
            }
            
                         
  ;
  
call:
    ID LPARENT call_arguments RPARENT
    {
     $$ = new call_stmt ($1,$3);
    }
  ;

call_arguments:
             call_arg_list
             {
              $$ = $1;
             }
             |
             {
              $$ = new skip_stmt();
             }    
  ;

call_arg_list:
             primary_expr
             {
              $$ = $1;
             }
             |
             call_arg_list COMA primary_expr
             {
              $$ = new call_list ($1,$3);
             } 
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
		           $$ = new logical_oror ($1,$3);
              }
	 ;

logical_and_expr:
               equality_expr
               {
                $$ = $1;
               }
	             | logical_and_expr ANDAND equality_expr 
               {
	              $$ = new logical_andand ($1,$3);
               }
	 ;

equality_expr:
            relational_expr
            {
             $$ = $1;
            }
	          | equality_expr EQUALEQUAL relational_expr 
            {
             $$ = new logical_equalequal($1,$3);
	 	        }
	          | equality_expr NOTEQUAL relational_expr 
            {
             $$ = new logical_notequal($1,$3);
            }
  ;

relational_expr:
              additive_expr
              {
               $$ = $1;
              }
	            | relational_expr LESS additive_expr 
              {
               $$ = new logical_less($1,$3);
	            }
	            | relational_expr GREAT additive_expr 
              {
	 	           $$ = new logical_great($1,$3);
	            }
              | relational_expr LESSEQUAL additive_expr 
              {
	 	           $$ = new logical_lessequal($1,$3);
              }
	            | relational_expr GREATEQUAL additive_expr 
              {
	 	           $$ = new logical_greatequal($1,$3);
	            }
  ;

additive_expr:
            multiplicative_expr
            {
             $$ = $1;
            }
            | additive_expr PLUS multiplicative_expr 
            {
		          $$ = new plus_expression($1,$3);
            }
	          | additive_expr MINUS multiplicative_expr 
            {
	  	       $$ = new minus_expression($1,$3);
            }
  ;

multiplicative_expr:
                  primary_expr
                  {
                   $$ = $1;
                  }
	                | multiplicative_expr TIMES primary_expr 
                  {
                   $$ = new times_expression($1,$3);
		              }
	                | multiplicative_expr DIVIDE primary_expr 
                  {
                   $$ = new divide_expression($1,$3);
  	              }
	                | multiplicative_expr PERCENT primary_expr 
                  {
                   $$ = new modulo_expression($1,$3);
  	              }
  ;


statement_list:
            statement statement_list
            {
             $$ = new statement_list($1,$2);
            }
            | return_stmt
         {
          $$ = $1;
         }
            | /*empty*/
            {
             $$ = new skip_stmt();
            } 
  ;


statement:
         assignment
         {
          $$ = $1;
         }
         |call SEMICOLON
         {
          $$=$1;
         } 
         | conditional_statement
         {
          $$ = $1;
         }
         ;
         
return_stmt:
          RETURN LPARENT primary_expr RPARENT SEMICOLON
          {
           $$ = new return_stmt($3);
          }
          ;
                   
conditional_statement:              
	        IF LPARENT expression RPARENT  LCURLY statement_list RCURLY  %prec LOWER_THAN_ELSE
         {
          $$ = new if_then_stmt($3,$6);
         }
         | IF LPARENT expression RPARENT LCURLY statement_list RCURLY ELSE LCURLY statement_list RCURLY  %prec ELSE
         {
           $$ = new if_then_else_stmt($3,$6,$10);
         }
	       | WHILE LPARENT expression RPARENT LCURLY statement_list RCURLY
         {
		      $$ = new while_stmt($3,$6);      
         }
         | DO LCURLY statement_list RCURLY WHILE LPARENT expression RPARENT SEMICOLON 
         {
          $$ = new do_while_stmt($3,$7); 
	 	     }
	       | FOR LPARENT ID SEMICOLON expression SEMICOLON expression RPARENT LCURLY statement_list RCURLY
       {
	 	      $$ = new for_stmt($3,$5,$7,$10);            
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
  

  cout << "---------- end of input program------------" << endl << endl;
  

  //root->evaluate();
}

void yyerror( const char *s)
{
  fprintf(stderr, "line %d: %s\n", line_num, s);
}