#include "types.h"
#include "riscv.h"
#include "defs.h"

void demo4(void)
{
    printf("demo 4\n");
    for (int i = 1; i < 10; i++)
    {
        printf("Summing up to %d: %d\n", i, sum_to(i));
    }
}
