#include <pulito.h>

Variable *print(Variable *str) {
  printf("%s", str->string);
  return str;
}

Variable *println(Variable *str) {
  printf("%s\n", str->string);
  return str;
}

Variable *join(Variable *sep, Variable *strings) {
  assert(strlen(sep->string) >= 0);
  assert(strings->type == TYPE_LIST);
  char *ret = malloc(sizeof(char));
  int arrlen = sizeof(strings)/sizeof(Variable*);
  size_t seplen = strlen(sep->string);
  int i = 0;
  int pos = 0;
  size_t tmp, alloclen;

  for(i = 0; i <= arrlen; i ++) {
    assert(strings->list[i]->type == TYPE_STRING);
    tmp = strlen(strings->list[i]->string);
    alloclen = tmp;
    if(i < arrlen) {
      alloclen += seplen;
    }
    ret = realloc(ret, alloclen);
    strcpy((ret+pos), strings->list[i]->string);
    if(i < arrlen) {
      strcpy((ret+pos+tmp), sep->string);
    }
    pos += alloclen;
  }

  Variable *var = (Variable*)malloc(sizeof(Variable));
  var->string = ret;
  var->type = TYPE_STRING;

  return var;
}