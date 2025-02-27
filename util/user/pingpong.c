#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int 
main(int argc, char *argv[])
{
  int p[2];
  char byte = 'x';
  char buf;
  pipe(p);
  if (fork() == 0) {
    while (read(p[0], &buf, 1) > 0) {
      close(p[0]);
      printf("%d: received ping\n", getpid());
      write(p[1], &byte, 1);
      close(p[1]);
      exit(0);
    }
  }
  else {
    write(p[1], &byte, 1);
    close(p[1]);
    wait(0);
    while (read(p[0], &buf, 1) > 0) {
      close(p[0]);
      printf("%d: received pong\n", getpid());
    }
  }
  exit(0);
}
