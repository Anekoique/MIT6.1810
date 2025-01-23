#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define INT_SIZE sizeof(int)
#define MAX_NUM 280

void
primes(int) __attribute__((noreturn));

int
main(int argc, char *argv[])
{
  int p[2];
  pipe(p);
  if (fork() == 0) {
    close(p[1]);
    primes(p[0]);
  }
  else {
    close(p[0]);
    for (int i = 2; i <= MAX_NUM; i++)
      write(p[1], &i, INT_SIZE);
    close(p[1]);
    wait(0);
  }
  exit(0);
}

void
primes(int pipefd)
{
  int divisor;
  if (read(pipefd, &divisor, INT_SIZE) <= 0) {
    close(pipefd);
    exit(0);
  }
  else printf("primes %d\n", divisor);

  int p[2];
  int num;
  pipe(p);
  if (fork() == 0) {
    close(pipefd);
    close(p[1]);
    primes(p[0]);
  } 
  else {
    close(p[0]);
    while (read(pipefd, &num, INT_SIZE)) 
      if (num % divisor)
        write(p[1], &num, INT_SIZE);
    close(pipefd);
    close(p[1]);
  }
  wait(0);
  exit(0);
}
