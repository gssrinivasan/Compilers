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

//%token <id> ID

%token NOTOKEN LPARENT RPARENT LBRACE RBRACE LCURLY RCURLY COMA SEMICOLON 

EQUAL STRING_CONST INT FLOAT LONG LONGSTAR VOID CHAR CHARSTARSTAR INTEGER_CONST 

AMPERSAND OROR ANDAND EQUALEQUAL NOTEQUAL LESS GREAT LESSEQUAL GREATEQUAL PLUS 

MINUS TIMES DIVIDE PERCENT IF ELSE WHILE DO FOR CONTINUE BREAK RETURN LSQUBRACKT RSQUBRACKT



%type <st> function

%type <st> global_var

%type <st> call_arg_list

%type <st> call_arguments

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

status: main
        | program
        ;
       
main: compound_statement
      | expression
      | call
       ;
        
program: function_or_var_list {}
        ;

function_or_var_list:

        function_or_var_list function

        | function_or_var_list global_var

        | expression

        | compound_statement 

;

function:
         var_type ID
         {
           $$ = new id_node($1); //$$ = new id_node($1);
	 	 }
        LPARENT arguments RPARENT {
        
        $$ = new function_args($2); // $$ = new function_args($2);
         
		 }
        compound_statement
         {
          
          $$ = new comp_Stat($1); // $$ = new comp_Stat($1);
          
          }
	;

arg_list:
         arg
         {
         $$ = new args_list($1); //$$ = new args_list($1)
         }
         | arg_list COMA arg
         {
         $$ = new args_list1($1,$3); //$$ = new args_list1($1,$3);
         }
	 ;

arguments:
         arg_list
         {
         $$ = new arguments_node($1); //$$ = new arguments_node($1);
         }
	 | /*empty*/
   {
   $$ = new skip_stmt(); //$$ = new skip_stmt();
   }
	 ;

arg: var_type ID SEMICOLON {
          
          $$ = new arg_node($1,$2); //$$ = new arg_node($1,$2)
   };

global_var: 
        var_type global_var_list SEMICOLON {

       $$ = new globalvar_node($1,$2); //$$ = new globalvar_node($1,$2);
		};

global_var_list: ID {

        $$ = new global_list($1); //$$ = new global_list($1)

        }
| global_var_list COMA ID {

  $$ = new global_list1($1,$3); //$$ = new global_list1($1,$3)

}
        ;

var_type: array | CHAR | INT | FLOAT | CHARSTARSTAR | LONG | LONGSTAR | VOID 
  {
  $$ = new vartype_node($1); //$$ = new vartype_node($1);
  };	
; 

array: var_type ID arraylist SEMICOLON

arraylist: LSQUBRACKT NUMBER RSQUBRACKT arraylist
           | 
           ;
 

assignment:
     ID EQUAL expression {
     
     $$ = new assign_node($1,$3); //$$ = new assign_node($1,$3);
	 	
		}
	 | ID LBRACE expression RBRACE EQUAL expression {

       $$ =  new assign_node1($1,$3,$6); //$$ = new assign_node1($1,$3,$6);
                   	 	
	 }
	 ;

call :
	 ID LPARENT  call_arguments RPARENT {
   
   $$ = new call_node($1,$3);//$$ = new call_node($1,$3)
		
	 }
      ;

call_arg_list:
         expression {
         
         $$ = new callarg_node($1); //$$ = new callarg_node($1);
		
	 }
         | call_arg_list COMA expression {
         
         $$ = new callarg_node1($1,$3); //$$ = new callarg_node1($1,$3);
	
	 }

	 ;

call_arguments:
         call_arg_list 
         {
           $$ = new callarg_node2(S1); // $$ = new callarg_node2(S1);
         }
	 | /*empty*/ 
   {
      $$ = new skipStmt();  //$$ = new skipStmt(); chk as it is same fun as above empty stat
         }
	 ;

expression :
         logical_or_expr
         {
         $$ = new exp_or($1); //$$ = new exp_or($1);
         }
	 ;

logical_or_expr:
         logical_and_expr
         {
         $$ = new exp_and($1); //$$ = new exp_and($1);
         }
	 | logical_or_expr OROR logical_and_expr {
   
   $$ = new exp_or1($1,$3); //$$ = new exp_or1($1,$3);
		
	}
	 ;

logical_and_expr:
         equality_expr
         {
         $$ = new equality_node($1); //$$ = new equality_node($1);
         }
	 | logical_and_expr ANDAND equality_expr {
   
   $$ = new exp_and1($1,$3); //$$ = new exp_and1($1,$3);
		
	}
	 ;

equality_expr:
         relational_expr
         {
         $$ = new equality_node1($1); //$$ = new equality_node1($1)
         }
	 | equality_expr EQUALEQUAL relational_expr {
   
   $$ = new equality_node2($1,$3); //$$ = new equality_node2($1,$3);
	 	
	 }
	 | equality_expr NOTEQUAL relational_expr {
   
   $$ = new equality_node3($1,$3); //$$ = new equality_node3($1,$3);
	 	
	 }
	 ;

relational_expr:
         additive_expr
         {
         $$ = new rel_node($1);//$$ = new rel_node($1);
         }
	 | relational_expr LESS additive_expr {
	 
   $$ = new rel_node1($1,$3);//$$ = new rel_node1($1,$3);
	 }
	 | relational_expr GREAT additive_expr {
   
   $$ = new rel_node2($1,$3);//$$ = new rel_node2($1,$3);
	 	
	 }
	 | relational_expr LESSEQUAL additive_expr {
   
   $$ = new rel_node3($1,$3);//$$ = new rel_node3($1,$3);
	 	
	 }
	 | relational_expr GREATEQUAL additive_expr {
   
   $$ = new rel_node4($1,$3);//$$ = new rel_node4($1,$3);
	 	
	 }
	 ;

additive_expr:
          multiplicative_expr
          {
          $$ = new add_node($1); //$$ = new add_node($1);
          }
	  | additive_expr PLUS multiplicative_expr {
     
     $$ = new add_node1($1,$3); //$$ = new add_node1($1,$3);
		
	  }
	  | additive_expr MINUS multiplicative_expr {
	  	
                    $$ = new add_node2($1,$3); //$$ = new add_node2($1,$3);
	  }
	  ;

multiplicative_expr:
          primary_expr
          {
          $$ = new mul_node($1); //$$ = new mul_node($1);
          }
	  | multiplicative_expr TIMES primary_expr {
		$$ = new mul_node1($1,$3); //$$ = new mul_node1($1,$3);
      }
	  | multiplicative_expr DIVIDE primary_expr {
     
     $$ = new mul_node2($1,$3); //$$ = new mul_node2($1,$3);
	  	
	  }
	  | multiplicative_expr PERCENT primary_expr {
     
      $$ = new mul_node3($1,$3); //$$ = new mul_node3($1,$3);
	  	
	  }
	  ;

primary_expr:
	  call
     {
     $$ = new priexp_node($1); //$$ = new priexp_node($1);
     }
	| ID {
		 $$ = new priexp_node1($1); //$$ = new priexp_node1($1);
	  }
	  | ID LBRACE expression RBRACE {

	   $$ = new priexp_node2($1,$3); //$$ = new id_node2($1,$3);	
		
	  }
	  
	  | INTEGER_CONST {
		 
     $$ = new priexp_node3($1); //$$ = new priexp_node3($1);
	  }
	  | LPARENT expression RPARENT
     {
     $$ = new priexp_node4($2);//$$ = new priexp_node4($2);
     }
	  ;

compound_statement:
	 LCURLY statement_list RCURLY
   {
   $$ = new cmpd_node($2);//$$ = new cmpd_node($2);
   }
	 ;

statement_list:
         statement_list statement
         {
         $$ = new stat_node($1); //$$ = new stat_node($1);
         }
	 | /*empty*/
   {
   $$ = new skipStmt();  //$$ = new skipStmt(); chk as it is same fun as above empty stat
   }
	 ;

local_var:
        var_type local_var_list SEMICOLON {
        
        $$ = new localvar_node($1,$2); //$$ = new localvar_node($1,$2);
		
		}
		;

local_var_list: ID {
		
   $$ = new localvar_node1($1); //$$ = new localvar_node1($1);
			}
        | local_var_list COMA ID {
			$$ = new localvar_node2($1,$3); //$$ = new localvar_node2($1,$3);
			}
        ;

statement:
         assignment SEMICOLON
         {
         $$ = new stat_node1($1); //$$ = new stat_node1($1);
                  }
	 | call SEMICOLON {
	 	$$ = new stat_node2($1);//$$ = new stat_node2($1);
	 }
	 | local_var
   {
   $$ = new stat_node3($1);//$$ = new stat_node3($1);
   }
	 | compound_statement
   {
   $$ = new stat_node4($1);//$$ = new stat_node4($1);
   }
	 | IF LPARENT expression RPARENT LCURLY statement RCURLY{
   $$ = new stat_node5($3,$6);//$$ = new stat_node5($3,$6);
   }
   | IF LPARENT expression RPARENT LCURLY statement RCURLY ELSE LCURLY statement RCURLY{ 
   $$ = new stat_node6($3,$6,$10);//$$ = new stat_node6($3,$6,$10);
   }
	 | WHILE LPARENT expression RPARENT {
		$$ = new loop_node1($3);//$$ = new loop_node1($3);
         }
         statement {
		$$ = new loop_node2($1);//$$ = new loop_node2($1);
	 }
	 | DO statement WHILE LPARENT expression RPARENT SEMICOLON {
	 	$$ = new loop_node3($2,$5);//$$ = new loop_node3($2,$5);
	 }
	 
	 | FOR LPARENT assignment SEMICOLON expression SEMICOLON assignment RPARENT {
		
	 } statement {
	 	
	 }
	 | jump_statement
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
