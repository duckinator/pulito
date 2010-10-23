#ifndef PULITO_TYPES_H
#define PULITO_TYPES_H

#define TYPE_NONE   0
#define TYPE_STRING 1
#define TYPE_NUMBER 2
#define TYPE_LAMBDA 3
#define TYPE_LIST   4

typedef void (*Lambda)();

#define NEW(TYPE, ARGS...) ({                                              \
                              TYPE *tmp = ( TYPE *)malloc(sizeof( TYPE )); \
                              *tmp = ( TYPE ){ ARGS };                     \
                              tmp;                                         \
                            })

#define CALL(LAMBDA, ARGS...) ({                             \
                                assert(LAMBDA->type == TYPE_LAMBDA); \
                                LAMBDA->lambda(ARGS);                \
                              })

#define STRING(x) NEW(Variable, .string = x, .number = 0, .lambda = NULL, .type = TYPE_STRING)
#define NUMBER(x) NEW(Variable, .string = #x, .number = x, .lambda = NULL, .type = TYPE_NUMBER)
#define LAMBDA(x) ({                                                                                        \
                        Variable *tmp = (Variable*)malloc(sizeof(Variable));                                \
                        void (*fn)() = (void*)x;                                                            \
                        *tmp = (Variable){ .string = #x, .number = 0, .lambda = fn, .type = TYPE_LAMBDA };  \
                        tmp;                                                                                \
                  })
#define LIST(ARGS...) ({                                                                 \
                        Variable *tmp = (Variable*)malloc(sizeof(Variable));             \
                        *tmp = (Variable){ .type = TYPE_LIST, .string = "[??]" }; \
                        Variable *li[] = { ARGS };                                       \
                        tmp->list = li;                                                  \
                        tmp;                                                             \
                      })

struct Variable_s {
  char *string;
  int number;
  void (*lambda)();
  int type;
  struct Variable_s **list;
};
typedef struct Variable_s Variable;

#endif