#include "types.h"
#include "riscv.h"
#include "defs.h"

void internal_dummy_main(int argc, char *argv[])
{
    for (int i = 0; i < argc; i++)
    {
        printf("Argument %d: %s\n", i, argv[i]); 
    }
}

void demo3(void)
{
    printf("demo 3\n");
    char *args[] = {"i", "love", "trampoline.S"};
    internal_dummy_main(3, args);
}
