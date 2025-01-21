#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"


uint64
sys_demo(void)
{
  int n;
  argint(0, &n);
  if (n == 1)
    demo1();
  else if (n == 2)
    demo2();
  else if (n == 3)
    demo3();
  else if (n == 4)
    demo4();
  else if (n == 5)
    demo5();
  return 0;
}

