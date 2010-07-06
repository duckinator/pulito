Comments
============
* /\* \*/   -  Non-documentation comment
* /** */  -  Documentation comment

Lambdas
========
Lambdas are merely a block of code that accepts arguments, if you just need a block, then leave the argument array empty.
Lambdas return the last value.
    :[arg1 arg2]
      /* code */
    ;


Variable Definition
=====================
    .a-list ["abc" "def"]


Function Definition
=======================
Functions are variables defined as a lambda
    /** join /str1/ and /str2/ with a space, and print the resulting string */
    .function1 :[str1 str2]
      .string (join " " [str1 str2])
      print string
    ;

    /** join all items in /list/ with spaces, and print the resulting string */
    .function2 :[list]
      .string (join " " list)
      print string
    ;

Function Calling
====================
    function1 ["foo" "bar"]


Throwing It Together
=====================
    /* Define a-list */
    .a-list ["abc" "def"]
    /* the following combines each item in a-list with a space, and prints them */
    function2 a-list
    /* the following combines each item in ['foo' 'bar'] with a space, and prints them */
    function2 ["foo" "bar"]

AST
===
This is just a quick layout for the AST.

## Function calls ##
    + 1 2
would become
    [:+, 1, 2]

## Lamdas ##
    :[arg1 arg2]
      + arg1 arg2
    ;
would become
    [:lambda, [:arg1, :arg2], [:+, :arg1, :arg2]]

## Variable definitions ##
    .variable-name "value"
would become
    [:define, :'variable-name', "value"]

## Function definitions, aka variables defined as lambdas ##
    .function-name :[arg1 arg2]
      + arg1 arg2
    ;
would become
    [:define, :'funciton-name',
      [:lambda, [:arg1, :arg2],
         [:+, :arg1, :arg2]]]

