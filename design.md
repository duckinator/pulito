Comments
========
* ;   -  Non-documentation comment
* ;;   -  Documentation comment

Lists
=====
    ["a" "b" 3 4]

Lambdas
=======
Lambdas are merely a block of code that accepts arguments, if you just need a block, then leave the argument array empty.
Lambdas return the last value.
    |arg1 arg2|
      ; code
    .


String Interpolation
====================
pultio uses ruby-style string interpolation, ie:
    a = "foo".
    b = "bar".
    print "#{a}#{b}".
is the same as
    a = "foo".
    b = "bar".
    print (join '' a b).

Variable Definition
===================
    a-list = ["abc" "def"].

Operator Overloading
====================
    [ x ] -> list x.
    a + b -> add a b.

Function Definition
===================
Functions are variables defined as a lambda
    ;; joins /str1/ and /str2/ with a space, and print the resulting string
    function1 = |str1 str2|
      string = join " " [str1 str2].
      print string.
    .

    ;; joins all items in /list/ with spaces, and print the resulting string
    function2 = |list|
      string = join " " list.
      print string.
    .

Function Calling
================
    function1 ["foo" "bar"].


Throwing It Together
====================
    ; Define a-list
    a-list = ["abc" "def"].
    
    ; combine each item in a-list with a space, and prints them
    function2 a-list.
    
    ; combine each item in ['foo' 'bar'] with a space, and prints them
    function2 ["foo" "bar"].

AST
===
This is just a quick layout for the AST.

## Lists ##
    ["a" "b" 3 4]
would become
    [:list,
      [:string, "a"],
      [:string, "b"],
      [:number, 3],
      [:number, 4]]

## Function calls ##
    add 1 2.
would become
    [:send, 'add', [:number, 1],
                   [:number, 2]]

## Lamdas ##
    ; we assume "a + b" is defined as "add a b"
    |arg1 arg2|
      arg1 + arg2.
    .
would become
    [:lambda, ['arg1', 'arg2'], [:send, 'add', 'arg1', 'arg2']]

## Variable definitions ##
    variable-name = "value"
would become
    [:define, 'variable-name', "value"]

## Function definitions, aka variables defined as lambdas ##
    function-name |arg1 arg2|
      (+ arg1 arg2)
    .
would become
    [:define, 'function-name',
      [:lambda, ['arg1', 'arg2'],
         [:send, 'add', 'arg1', 'arg2']]]


    ["a" "b" 1 2]
->
    [:list,
      [:string, "a"],
      [:string, "b"],
      [:number, 1],
      [:number, 2]]
