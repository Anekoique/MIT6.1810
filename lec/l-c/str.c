#include "kernel/types.h"
#include "user/user.h"

char *s = "123";
	
int
main(int ac, char **av)
{
  char s1[4] = {'1', '2', '3', '\0'}; 

  // s and s1 are strings
  printf("s %s s1 %s\n", s, s1);

  // can use index or pointer access
  printf("%c %c\n", s[0], *s);
  printf("%c %c\n", s[2], *(s+2));

  // read beyond str end; DON'T DO THIS
  printf("%x %p %p\n", s1[4], s1, &s1[4]);

  // write beyond str end; DON'T DO THIS
  s1[4] = 'D';
  
  return 0;
}
