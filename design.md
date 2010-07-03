Comments
============
* /\* \*/
* //
* #

Lambdas
========
    [arg1 arg2]:
      // code
    ;


Variable Definition
=====================
    .a-list ["abc" "def"]


Function Definition
=======================
Functions are variables defined as a lambda
    .function1 [str1 str2]:
      .string (join " " [str1 str2])
      print string
    ;

    .function2 [list]:
      .string (join " " list)
      print string
    ;

Function Calling
====================
    function1 ["foo" "bar"]


Throwing It Together
=====================
    # Define a-list
    .a-list ["abc" "def"]
    /* the following combines each item in a-list with a space, and prints them */
    function2 a-list
    /* the following combines each item in ['foo' 'bar'] with a space, and prints them */
    function2 ["foo" "bar"]

