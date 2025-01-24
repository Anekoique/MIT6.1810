#include "kernel/types.h"
#include "user/user.h"

int g = 3;
	
int
main(int ac, char **av)
{
  int l = 5;   // local variables don't have a default value
  int *p, *q;
  
  // take address of variable
  p = &g;
  q = &l;
  printf("p %p q %p\n", p, q);

  // assign using pointer
  *p = 11;
  *q = 13;
  printf("g %d l %d\n", g, l);

  // struct
  struct two {
    int a;
    int b;
  } s;
  s.a = 10;
  struct two *ptr = &s;
  printf("%d %d\n", s.a, ptr->a);

  // can take address of any variable
  int **pp;
  pp = &p;    // take address of a pointer variable
  printf("pp %p %p %d\n", pp, *pp, **pp);

  int (*f)(int, char **);
  f = &main;  // take address of a function<
  printf("main: %p\n", f);

  return 0;
}
