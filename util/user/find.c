#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

void find(char *, char *);
char *fmtname(char *path);

int 
main(int argc, char *argv[])
{
  if (argc < 3) {
    write(2, "Missing parameters\n", 20);
    exit(0);
  }
  else find(argv[1], argv[2]);
  exit(0);
}

char *
fmtname(char *path)
{
  static char buf[DIRSIZ + 1];
  char *p;

  for (p = path + strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  if (strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf + strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}

void
find(char *path, char *target)
{
  int fd;
  struct dirent de;
  struct stat st;

  if ((fd = open(path, O_RDONLY)) < 0) {
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if (fstat(fd, &st) < 0) {
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  if (st.type != T_DIR) {
    fprintf(2, "find: input invalid %s\n", path);
    close(fd);
    return;
  }

  char buf[512], *p;
  strcpy(buf, path);
  p = buf + strlen(buf);
  *p++ = '/';
  while (read(fd, &de, sizeof(de)) == sizeof(de)) {
    if (de.inum == 0)
      continue;
    memmove(p, de.name, DIRSIZ);
    p[DIRSIZ] = 0;
    if (stat(buf, &st) < 0) {
      printf("find: cannot stat %s\n", buf);
      continue;
    }
    switch(st.type) {
      case T_FILE:
        if (!strcmp(de.name, target))
          printf("%s\n", buf);
        break;
      case T_DIR:
        if ((!strcmp(de.name, ".")) || (!strcmp(de.name, ".."))) break;
        find(buf, target);
        break;
    }
  }
}
