#include <iostream>
#include <stdlib.h>
#include <string>
#include <map>
#include <list>

using namespace std;

class exp_node {
  public:

    // print function for pretty printing an expression
    virtual void print() = 0;

    // evaluation function for a leaf, replaced for interior nodes
    virtual float evaluate() = 0;
};

class operator_node : public exp_node {
public:
    exp_node *left;
    exp_node *right;

  // the constructor for node links the node to its children,
  // and stores the character representation of the operator.
    operator_node(exp_node *L, exp_node *R);
};

class number_node : public exp_node {
 private:
    float num;

 public:
  number_node(float value);
  void print();
  float evaluate();
};

class unary_minus_node : public exp_node {
 protected:
  exp_node *exp;
 public:
  unary_minus_node(exp_node *exp);
  void print();
  float evaluate();
};

class id_node : public exp_node {
protected:
  string id;

public:
  id_node(string value);
  void print();
  float evaluate();
};

// plus_node inherits the characteristics of node and adds its own evaluate function
class plus_node : public operator_node {
  public:

  // plus_node's constructor just uses node's constructor
  plus_node(exp_node *L, exp_node *R);
  void print();
  float evaluate();
};


// minus_node inherits the characteristics of node and adds its own evaluate function
class minus_node : public operator_node {
  public:

  minus_node(exp_node *L, exp_node *R);
  void print();
  float evaluate();
};


// times_node inherits the characteristics of node and adds its own evaluate function
class times_node : public operator_node {
  public:

  times_node(exp_node *L, exp_node *R);
  void print();
  float evaluate();
};


// divide_node inherits the characteristics of node and adds its own evaluate function
class divide_node : public operator_node {
  public:

  divide_node(exp_node *L, exp_node *R);
  void print();
  float evaluate();
};

class statement {
 public:
  virtual void print() {}
  virtual void evaluate() = 0;
};

class assignment_stmt : public statement {
 protected:
  string id;
  exp_node *exp;
 public:
  assignment_stmt(string name, exp_node *expression);
  void print();
  void evaluate();
};

class print_stmt: public statement {
 protected:
  exp_node *exp;
 public:
  print_stmt(exp_node *myexp);
  void print();
  void evaluate();
};

class skip_stmt: public statement {
 public:
  skip_stmt();
  void print();
  void evaluate();
};


class sequence_stmt: public statement {
 protected:
  statement *stmt1, *stmt2;
 public:
  sequence_stmt(statement *mystmt1, statement *mystmt2);
  void print();
  void evaluate();
};

// the object at the base of our tree
extern map<string, float> idTable;

