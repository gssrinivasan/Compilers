%{


/* This interpreter evaluates arithmetic expressions and assigns
   them to the specified variable names. The grammar is:

   pgm -> stmtlist
   stmtlist -> stmt | stmtlist ; stmt
   stmt -> id = exp 
        |  print id
   exp -> exp + mulexp | exp - mulexp 
   mulexp -> mulexp * primexp | mulexp / primexp
   primexp ->  ( exp ) | ( exp ) | - primexp | id | number 
*/

#include <iostream>
#include <string>
#include <stdlib.h>
#include <stdio.h>
#include <map>
#include <list>
#include "imp.h"



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

%start program

%union {
  float num;
  char *id;
  exp_node *exp_node_ptr;
  statement *st;
}

%error-verbose

%token <num> NUMBER
%token <id> ID
%token SEMICOLON  EQUALS PRINT  PLUS MINUS MUL DIVIDE LOGICAND LOGICOR LOGICNOT TIMES DIVIDE  LPAREN RPAREN LBRACE RBRACE GREATERTHANEQ GREATERTHAN LESSTHANEQ LESSTHAN NOTEQUALS ASSIGN LSQUARE RSQUARE RETURN DO WHILE IF ELSE FOR
%type <exp_node_ptr> strexp
%type <exp_node_ptr> artexp
%type <exp_node_ptr> boolexp 
%type <st> stmtlist
%type <st> stmt
%type <st> program

%%

program : function mainfunction
                   
                    |mainfunction
                      { root = $$; }
;

mainfunction : datatype main LBRACE var_list RBRACE LPAREN function_body RPAREN
               {
			$$ = new main_fun($1,$2,$4,$7);
			}
;
functions : function
            
            {
             $$ = $1;
            }


            |function functions
            {
             $$ = new fun($1,$2);
            }
;

function : function_declaration LBRACE function_body RBRACE 
  
             {
      $$ = new func($1,$3);
              }
;

function_declaration : datatype ID LPAREN var_list RPAREN

			{
				$$ = new func_decl($1,$2,$4);
			}

;
function_body : return_stmt 

                {
             $$ = $1;
              }

                |stmt_list return_stmt

                 {
               $$ = new func_body($1,$2); 
                  }
;

stmt_list : stmt 

            {
             $$ = $1;
            }

            |stmt stmt_list

            {
              $$ = new slist($1,$2);
            }     
;

stmt : var_declaration
        
        {
              $$ = $1;
        }    
       |function_call

         {
              $$ = $1;
        }   
       |assignment_stmt

         {
              $$ = $1;
        }   
       |loop_statement
         {
              $$ = $1;
        }    
       |if_statement

          {
              $$ = $1;
        }   

       |function_call
		{
              $$ = $1;
        	}          
	   |expr

       {
              $$ = $1;
        }   

;
datatype : INT 
           |FLOAT
           |CHAR
           |BOOLEAN
           |STRING
           |array_type 
         {
             $$ = new array($1);
         }
           |ID

           

;

array_type : datatype ID list_dimension

              {
             $$ = new atype($1,$2,$3);
               }

;

list_dimension : LSQUARE ID RSQUARE list_dimension 
                 |
                 

               {
                 $$ = new dim($2,$4);   
               }
             
;

var_declaration : datatype ID var_list

                   {
              $$ = new decl($2,$3);
                    }
                  | datatype ID;
                  | datatype ID
                  

            
;

var_list : var_declaration var_list
             
			 {
                  $$ = new vardecl($1,$2);
                 }
              |
                 { 
                 $$ = new skip_stmt();
	            }


;

return_stmt : RETURN expr;

              {
            $$ = $1;
              }

              |RETURN LPAREN ID RPAREN;

               {
             $$ = $3;
                }
              |RETURN
              |
               { 
               $$ = new skip_stmt1();
               }

              
             
;

function_call : ID LPAREN var_list RPAREN

{
            $$ = new func_call($3);
}
               
			 |var_declaration EQUALS ID LPAREN var_list                          			RPAREN;

{
            $$ = new func_call1($1,$3,$5);
}            

;
assignment_stmt : var_declartion EQUALS factor

                  
                   {
             $$ = new assign_stat1($1,$3);
                    }

                 |var_declaration EQUALS expr;
                     
                   {
             $$ = new assign_stat2($1,$3);
                    }
factor : ID | 
	   -factor 
               {
             $$ = $1;
               }

		  |LPAREN expr RPAREN 

                {
             $$ = $2;
               }

expr : string_expr

           {
             $$ = $1;
           }

        |arithmetic_expr

            {
             $$ = $1;
            }

        |boolean_expr

             {
               $$ = $1;
            }
;

    
   arithmetic_expr : add_operation
   
                       {
               $$ = $1;
                        }

                   |mul_operation

                    {
                  $$ = $1;
                     }
;


    add_operation : factor
              
                     {
                  $$ = $1;
                     }
             
                    | add_operation PLUS mul_operation

                     {
                  $$ = new fact($1,$3);
                     }
;

     
      mul_operation : factor
              
                     {
                  $$ = $1;
                     }
             
                    | mul_operation MUL factor

                     {
                  $$ = new fact($1,$3);
                     }
;


      boolean_expr :  boolean_expr LOGICOR boolean_expr
             
                      {
                  $$ = new bool_exp($1,$3);
                      }

                      |boolean_term
  
                       {
                     $$ = $1;
                       }
;   

       boolean_term :  boolean_term LOGICAND boolean_factor
             
                      {
                  $$ = new bool_exp($1,$3);
                      }

                      |boolean_factor
  
                       {
                     $$ = $1;
                       }
;   
    
    
             
        boolean_factor : ID 
                            
                         | LOGICNOT boolean_factor
                           {
            		       $$=$2;
                           }
                          
                         |LPAREN boolean_expr RPAREN
                           {
            		       $$=$2;
                           }
  
                         |relational_expr 
                           {
            		       $$=$1;
                           }
;

          relational_expr : ID ASSIGN  ID

                             {
                             $$ = new assign_st($1,$3);
                             }

                             |ID NOTEQUALS  ID

                             {
                             $$ = new noteq_st($1,$3);
                             }
                             
                             |ID  LESSTHAN  ID

                             {
                             $$ = new less_st($1,$3);
                             }
                             
                             |ID GREATERTHAN  ID

                             {
                             $$ = new great_st($1,$3);
                             }


                             |ID  GREATERTHANEQ ID
                             {
                             $$ = new greateq_st($1,$3);
                             }

                             |ID  LESSTHANEQ ID
                             {
                             $$ = new lesseq_st($1,$3);
                             }
;

                 
            if_stmt : IF LPAREN expr RPAREN LBRACE stmt_list RBRACE  
                             {
                             $$ = new if_st($3,$6);
                             }

                       |IF LPAREN expr RPAREN LBRACE stmt_list RBRACE ELSE LBRACE stmt_list RBRACE  
 
                             {
                             $$ = new if_st($3,$6,$10);
                             }
;

            loop_stmt : DO LBRACE stmt_list RBRACE WHILE LPAREN boolean_expr RPAREN

                             {
                             $$ = new do_loop($3,$7)
                              }
                           |FOR LPAREN stmt;boolean_expr;expr RPAREN LBRACE stmt_list RBRACE


                          {
              $$ = new for_loop($3,$4,$5,$8);
                           }
;

    

                            

           
                  

stmtlist :  stmt stmtlist
            { // copy up the list and add the stmt to it
              $$ = new sequence_stmt($1,$2);
            }
         | stmtlist SEMICOLON error
	   { // just copy up the stmtlist when an error occurs
             $$ = $1;
             yyclearin; } 
         |  stmt 
	 { $$ = $1;   }
;

stmt: ID EQUALS exp { 
  $$ = new assignment_st($1, $3);
	   }
       
| PRINT exp {
  $$ = new print_stmt($2);
 }

|
{ $$ = new skip_stmt();
}
| LBRACE stmtlist RBRACE { $$=$2; } 
 ;


exp:	exp PLUS mulexp { $$ = new plus_node($1, $3); }

      |	exp MINUS mulexp { $$ = new minus_node($1, $3); }

      |	mulexp {  $$ = $1; }
;



mulexp:	mulexp TIMES primexp {
	  $$ = new times_node($1, $3); }

      | mulexp DIVIDE primexp {
	  $$ = new divide_node($1, $3); }

      | primexp { $$=$1;  }
;



primexp:	MINUS primexp %prec UMINUS { $$ = new unary_minus_node($2); }

      |	LPAREN exp RPAREN  {  $$ = $2; }

      |	NUMBER { $$ = new number_node($1); }

      | ID { $$ = new id_node($1); }
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

void yyerror(char * s)
{
  fprintf(stderr, "line %d: %s\n", line_num, s);
}




