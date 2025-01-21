#include "types.h"
#include "riscv.h"
#include "defs.h"

struct Class {
    int old_number;
    int new_number;
};

void print_class(struct Class *class) {
    printf("Class %d (formely %d)", class->new_number, class->old_number);
}

void demo5(void)
{
    printf("demo 5\n");
    struct Class class;
    class.old_number = 6828;
    class.new_number = 61810;
    print_class(&class);
}
