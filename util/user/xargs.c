#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h" 

#define MAX_ARG_LEN 20

int
main(int argc, char *argv[])
{
  if (argc < 2) {
    write(2, "Missing parameters\n", 20);
    exit(0);
  }

  char *args[MAXARG];
  char buf[MAX_ARG_LEN];
  int i = 0;
  for (int j = 0; j < argc - 1; j++) {
    args[j] = argv[j+1];
  }
  while (read(0, &buf[i], sizeof(char)) > 0) {
    if (buf[i] == '\n') {
      buf[i] = '\0';
      args[argc - 1] = buf;
      i = 0;
      if (fork() == 0) {
        exec(args[0], args);
        exit(0);
      }
      else {
        wait(0);
      }
    } else i++;
  }
  exit(0);
}
