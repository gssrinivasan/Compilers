#include <iostream>
#include <stdlib.h>
#include <string>
#include <map>
#include <list>

using namespace std;
class exp_node {
  public:
    virtual void print() = 0;
};

class operator_node : public exp_node {
public:
    exp_node *left;
    exp_node *right;
    operator_node(exp_node *L, exp_node *R);
};
class number_node : public exp_node {
 private:
    float num;

 public:
  number_node(float value);
  void print();
};

class id_node : public exp_node {
protected:
  string id, var_type;

public:
  id_node(String var_type, string value);
  void print();
};

class function_or_var_list: public exp_node {
 protected:
  statement *function, exp_node *function_or_var_list, statement *global_var;
 public:
  func_node(exp_node *function_or_var_list, statement *function);
  void print();
  func_node1(exp_node *function_or_var_list, statement *global_var);
  void print();
};

class function: public statement, id_node, arg_node {
 protected:
 string var_type, id;
 exp_node *arg_node;
 public:
 id_node (var_type, id);
 void print();
 arg_node	(arg_node); //need to be defined
 void print();
};

/*

class number_node : public exp_node {
 private:
    float num;

 public:
  number_node(float value);
  void print();
  //float evaluate();
};

class unary_minus_node : public exp_node {
 protected:
  exp_node *exp;
 public:
  unary_minus_node(exp_node *exp);
  void print();
  //float evaluate();
};

class id_node : public exp_node {
protected:
  string id;

public:
  id_node(string value);
  void print();
  //float evaluate();
};

// plus_node inherits the characteristics of node and adds its own evaluate function
class plus_node : public operator_node {
  public:

  // plus_node's constructor just uses node's constructor
  plus_node(exp_node *L, exp_node *R);
  void print();
  //float evaluate();
};


// minus_node inherits the characteristics of node and adds its own evaluate function
class minus_node : public operator_node {
  public:

  minus_node(exp_node *L, exp_node *R);
  void print();
  //float evaluate();
};


// times_node inherits the characteristics of node and adds its own evaluate function
class times_node : public operator_node {
  public:

  times_node(exp_node *L, exp_node *R);
  void print();
  //float evaluate();
};


// divide_node inherits the characteristics of node and adds its own evaluate function
class divide_node : public operator_node {
  public:

  divide_node(exp_node *L, exp_node *R);
  void print();
  //float evaluate();
};

class statement {
 public:
  virtual void print() {}
  //virtual void evaluate() = 0;
};

class assignment_stmt : public statement {
 protected:
  string id;
  exp_node *exp;
 public:
  assignment_stmt(string name, exp_node *expression);
  void print();
  //void evaluate();
};

class print_stmt: public statement {
 protected:
  exp_node *exp;
 public:
  print_stmt(exp_node *myexp);
  void print();
  //void evaluate();
};

class skip_stmt: public statement {
 public:
  skip_stmt();
  void print();
  //void evaluate();
};


class sequence_stmt: public statement {
 protected:
  statement *stmt1, *stmt2;
 public:
  sequence_stmt(statement *mystmt1, statement *mystmt2);
  void print();
  //void evaluate();
};

*/
// the object at the base of our tree
extern map<string, float> idTable;

