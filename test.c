#include <pulito.h>

Variable *test__lambda1(Variable *str1, Variable *str2) {
  Variable *genVar1 = LIST(str1, str2);
  Variable *string = join(STRING(" "), genVar1);

  return println(string);
}

Variable *test__lambda2(Variable *list) {
  Variable *string = join(STRING(" "), list);
  return println(string);
}

int main() {
  Variable *a = STRING("foo");
  Variable *b = STRING("bar");
  Variable *n = NUMBER(345);

  Variable *alist = LIST(STRING("abc"), STRING("def"));

  Variable *function1 = LAMBDA(test__lambda1);
  Variable *function2 = LAMBDA(test__lambda2);

  CALL(function1, STRING("foo"), STRING("bar"));

  CALL(function2, alist);

  Variable *genVar2 = LIST(STRING("foo"), STRING("bar"));
  CALL(function2, genVar2);

  Variable *genVar3 = LIST(a, b);
  println(join(STRING(""), genVar3));

  Variable *genVar4 = LIST(a, b);
  println(join(STRING(""), genVar4));

  println(n);

  return 0;
}
