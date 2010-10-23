#ifndef PULITO_MISC_H
#define PULITO_MISC_H

#include "types.h"

extern Variable *print(Variable *str);
extern Variable *println(Variable *str);
extern Variable *join(Variable *sep, Variable *strings);

#endif