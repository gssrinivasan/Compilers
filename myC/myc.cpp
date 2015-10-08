#include <iostream>
#include <stdlib.h>
#include <string>
#include <map>
#include <list>
#include "myc.h"

using namespace std;

 operator_node::operator_node(exp_node *L, exp_node *R) {
    left    = L;
    right   = R;
  }

//for global variable
var_node:: var_node(string value, exp_node *list)
: list(list), id(value) {}
void var_node:: print() 
{
  cout << "GLOBAL VARIABLE : ";
  cout << "\n";
  cout << id << "\n";
  list->print();
}

//for 1D array
arr1d_var:: arr1d_var(string id, float value)
:id (id), value (value) {}
void arr1d_var:: print()
{
cout << "1D Array :";
cout << "\n";
cout << id << "[" << value << "]" << "\n";
}

//for 2D array
arr2d_var:: arr2d_var(string id, float value1, float value2)
:id (id), value1 (value1), value2 (value2) {}
void arr2d_var:: print()
{
cout << "2D Array :";
cout << "\n";
cout <<id << "[" << value1 << "]" << "[" << value2 << "]" << "\n";
}


//assignment statement
assignment_stmt:: assignment_stmt(string id, exp_node *expr)
: id (id), expr(expr) {}
void assignment_stmt:: print()
{
cout << "Assignment Statement: ";
cout << "\n";
cout << id << "=" ;
expr->print();
cout << "\n";
}


//logical_oror
logical_oror:: logical_oror (exp_node *expr1, exp_node *expr2)
: expr1(expr1), expr2(expr2) {} 
void logical_oror:: print()
{
cout << "Logical OR: ";
cout << "\n";
expr1->print();
cout << "OR OR";
expr2->print();
cout << "\n";
}

//logical_andand
logical_andand:: logical_andand (exp_node *expr1, exp_node *expr2)
: expr1(expr1), expr2(expr2) {} 
void logical_andand:: print()
{
cout << "Logical AND: ";
cout << "\n";
expr1->print();
cout << "AND AND";
expr2->print();
cout << "\n";
}

//logical_equalequal
logical_equalequal:: logical_equalequal(exp_node *expr1, exp_node *expr2)
: expr1(expr1), expr2(expr2) {} 
void logical_equalequal:: print()
{
cout << "Logical EQUALITY: ";
cout << "\n";
expr1->print();
cout << "EQUAL EQUAL";
expr2->print();
cout << "\n";
}

//logical_notequal
logical_notequal:: logical_notequal(exp_node *expr1, exp_node *expr2)
: expr1(expr1), expr2(expr2) {} 
void logical_notequal:: print()
{
cout << "Logical NON-EQUALITY: ";
cout << "\n";
expr1->print();
cout << "NOT EQUAL";
expr2->print();
cout << "\n";
}

//logical_less
logical_less:: logical_less(exp_node *expr1, exp_node *expr2)
: expr1(expr1), expr2(expr2) {} 
void logical_less:: print()
{
cout << "Logical LESS THAN: ";
cout << "\n";
expr1->print();
cout << "LESS THAN";
expr2->print();
cout << "\n";
}

//logical_great
logical_great:: logical_great(exp_node *expr1, exp_node *expr2)
: expr1(expr1), expr2(expr2) {} 
void logical_great:: print()
{
cout << "Logical GREATER THAN: ";
cout << "\n";
expr1->print();
cout << "GREATER THAN";
expr2->print();
cout << "\n";
}

//logical_lessequal
logical_lessequal:: logical_lessequal(exp_node *expr1, exp_node *expr2)
: expr1(expr1), expr2(expr2) {} 
void logical_lessequal:: print()
{
cout << "Logical LESS THAN OR EQUAL TO: ";
cout << "\n";
expr1->print();
cout << "LESS THAN OR EQUAL TO";
expr2->print();
cout << "\n";
}

//logical_greatequal
logical_greatequal:: logical_greatequal(exp_node *expr1, exp_node *expr2)
: expr1(expr1), expr2(expr2) {} 
void logical_greatequal:: print()
{
cout << "Logical GREATER THAN OR EQUAL TO: ";
cout << "\n";
expr1->print();
cout << "GREATER THAN OR EQUAL TO";
expr2->print();
cout << "\n";
}


//plus_expression
plus_expression:: plus_expression(exp_node *expr1, exp_node *expr2)
: expr1(expr1), expr2(expr2) {} 
void plus_expression:: print()
{
cout << "ADDITION Expression: ";
cout << "\n";
expr1->print();
cout << "+";
expr2->print();
cout << "\n";
}

//minus_expression
minus_expression:: minus_expression(exp_node *expr1, exp_node *expr2)
: expr1(expr1), expr2(expr2) {} 
void minus_expression:: print()
{
cout << "MINUS Expression: ";
cout << "\n";
expr1->print();
cout << "-";
expr2->print();
cout << "\n";
}

//times_expression
times_expression:: times_expression(exp_node *expr1, exp_node *expr2)
: expr1(expr1), expr2(expr2) {} 
void times_expression:: print()
{
cout << "MULTIPLICATION Expression: ";
cout << "\n";
expr1->print();
cout << "*";
expr2->print();
cout << "\n";
}

//divide_expression
divide_expression:: divide_expression(exp_node *expr1, exp_node *expr2)
: expr1(expr1), expr2(expr2) {} 
void divide_expression:: print()
{
cout << "DIVIDE Expression: ";
cout << "\n";
expr1->print();
cout << "/";
expr2->print();
cout << "\n";
}

//modulo_expression
modulo_expression:: modulo_expression(exp_node *expr1, exp_node *expr2)
: expr1(expr1), expr2(expr2) {} 
void modulo_expression:: print()
{
cout << "MODULO Expression: ";
cout << "\n";
expr1->print();
cout << "%";
expr2->print();
cout << "\n";
}

//if_then_stmt
if_then_stmt:: if_then_stmt(exp_node *expr, statement *st)
: expr(expr), st(st) {} 
void if_then_stmt:: print()
{
cout << "IF_THEN Statement:";
cout << "\n";
cout <<"if";
expr->print();
cout << "then";
st->print();
cout << "\n";
}

//if_then_else_stmt
if_then_else_stmt:: if_then_else_stmt(exp_node *expr, statement *st1, statement *st2)
: expr(expr), st1(st1), st2(st2) {} 
void if_then_else_stmt:: print()
{
cout << "IF_THEN_ELSE Statement:";
cout << "\n";
cout <<"if";
expr->print();
cout << "then \n";
st1->print();
cout << "else \n";
st2->print();
cout << "\n";
}

//while_stmt
while_stmt:: while_stmt(exp_node *expr, statement *st)
: expr(expr), st(st) {} 
void while_stmt:: print()
{
cout << "WHILE Statement:";
cout << "\n";
cout <<"while";
expr->print();
cout << "then";
st->print();
cout << "\n";
}

//do_while_stmt
do_while_stmt:: do_while_stmt( statement *st, exp_node *expr)
: expr(expr), st(st) {} 
void do_while_stmt:: print()
{
cout << "DO_WHILE Statement:";
cout << "\n";
cout <<"do";
st->print();
cout << "while";
expr->print();
cout << "\n";
}

//for_statement
for_stmt:: for_stmt(statement *initialization, exp_node *condition, statement *incrementation, statement *st)
: initializaton(initializaton), condition(condition), incrementation(incrementation), st(st) {} 
void for_stmt:: print()
{
cout << "FOR Statement:";
cout << "\n";
cout <<"for (";
initializaton->print();
cout << ";" ;
condition->print();
cout << ";" ;
incrementation->print();
cout << ")";
cout << "{";
st->print();
cout << "}";
cout << "\n";
}

// id_node code
id_node::id_node (string value)
: id (value) {}
void id_node:: print()
{
cout << "\"" <<"id node:";
cout << id <<"\"" << "\n";
}

// number node
number_node::number_node(float value) { num = value; }
void number_node:: print() 
{
cout << num;
}

//skip statement
skip_stmt::skip_stmt ()  {}
void skip_stmt::print() {}

map<string, float> idTable;
