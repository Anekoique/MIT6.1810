
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	2ac000ef          	jal	2b4 <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    sleep(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2aa000ef          	jal	2bc <exit>
    sleep(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	334000ef          	jal	34c <sleep>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	290000ef          	jal	2bc <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e406                	sd	ra,8(sp)
  34:	e022                	sd	s0,0(sp)
  36:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  38:	87aa                	mv	a5,a0
  3a:	0585                	addi	a1,a1,1
  3c:	0785                	addi	a5,a5,1
  3e:	fff5c703          	lbu	a4,-1(a1)
  42:	fee78fa3          	sb	a4,-1(a5)
  46:	fb75                	bnez	a4,3a <strcpy+0xa>
    ;
  return os;
}
  48:	60a2                	ld	ra,8(sp)
  4a:	6402                	ld	s0,0(sp)
  4c:	0141                	addi	sp,sp,16
  4e:	8082                	ret

0000000000000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  58:	00054783          	lbu	a5,0(a0)
  5c:	cb91                	beqz	a5,70 <strcmp+0x20>
  5e:	0005c703          	lbu	a4,0(a1)
  62:	00f71763          	bne	a4,a5,70 <strcmp+0x20>
    p++, q++;
  66:	0505                	addi	a0,a0,1
  68:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	fbe5                	bnez	a5,5e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  70:	0005c503          	lbu	a0,0(a1)
}
  74:	40a7853b          	subw	a0,a5,a0
  78:	60a2                	ld	ra,8(sp)
  7a:	6402                	ld	s0,0(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strlen>:

uint
strlen(const char *s)
{
  80:	1141                	addi	sp,sp,-16
  82:	e406                	sd	ra,8(sp)
  84:	e022                	sd	s0,0(sp)
  86:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cf99                	beqz	a5,aa <strlen+0x2a>
  8e:	0505                	addi	a0,a0,1
  90:	87aa                	mv	a5,a0
  92:	86be                	mv	a3,a5
  94:	0785                	addi	a5,a5,1
  96:	fff7c703          	lbu	a4,-1(a5)
  9a:	ff65                	bnez	a4,92 <strlen+0x12>
  9c:	40a6853b          	subw	a0,a3,a0
  a0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  a2:	60a2                	ld	ra,8(sp)
  a4:	6402                	ld	s0,0(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret
  for(n = 0; s[n]; n++)
  aa:	4501                	li	a0,0
  ac:	bfdd                	j	a2 <strlen+0x22>

00000000000000ae <memset>:

void*
memset(void *dst, int c, uint n)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b6:	ca19                	beqz	a2,cc <memset+0x1e>
  b8:	87aa                	mv	a5,a0
  ba:	1602                	slli	a2,a2,0x20
  bc:	9201                	srli	a2,a2,0x20
  be:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c6:	0785                	addi	a5,a5,1
  c8:	fee79de3          	bne	a5,a4,c2 <memset+0x14>
  }
  return dst;
}
  cc:	60a2                	ld	ra,8(sp)
  ce:	6402                	ld	s0,0(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strchr>:

char*
strchr(const char *s, char c)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e406                	sd	ra,8(sp)
  d8:	e022                	sd	s0,0(sp)
  da:	0800                	addi	s0,sp,16
  for(; *s; s++)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	cf81                	beqz	a5,f8 <strchr+0x24>
    if(*s == c)
  e2:	00f58763          	beq	a1,a5,f0 <strchr+0x1c>
  for(; *s; s++)
  e6:	0505                	addi	a0,a0,1
  e8:	00054783          	lbu	a5,0(a0)
  ec:	fbfd                	bnez	a5,e2 <strchr+0xe>
      return (char*)s;
  return 0;
  ee:	4501                	li	a0,0
}
  f0:	60a2                	ld	ra,8(sp)
  f2:	6402                	ld	s0,0(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  return 0;
  f8:	4501                	li	a0,0
  fa:	bfdd                	j	f0 <strchr+0x1c>

00000000000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	7159                	addi	sp,sp,-112
  fe:	f486                	sd	ra,104(sp)
 100:	f0a2                	sd	s0,96(sp)
 102:	eca6                	sd	s1,88(sp)
 104:	e8ca                	sd	s2,80(sp)
 106:	e4ce                	sd	s3,72(sp)
 108:	e0d2                	sd	s4,64(sp)
 10a:	fc56                	sd	s5,56(sp)
 10c:	f85a                	sd	s6,48(sp)
 10e:	f45e                	sd	s7,40(sp)
 110:	f062                	sd	s8,32(sp)
 112:	ec66                	sd	s9,24(sp)
 114:	e86a                	sd	s10,16(sp)
 116:	1880                	addi	s0,sp,112
 118:	8caa                	mv	s9,a0
 11a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11c:	892a                	mv	s2,a0
 11e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 120:	f9f40b13          	addi	s6,s0,-97
 124:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 126:	4ba9                	li	s7,10
 128:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 12a:	8d26                	mv	s10,s1
 12c:	0014899b          	addiw	s3,s1,1
 130:	84ce                	mv	s1,s3
 132:	0349d563          	bge	s3,s4,15c <gets+0x60>
    cc = read(0, &c, 1);
 136:	8656                	mv	a2,s5
 138:	85da                	mv	a1,s6
 13a:	4501                	li	a0,0
 13c:	198000ef          	jal	2d4 <read>
    if(cc < 1)
 140:	00a05e63          	blez	a0,15c <gets+0x60>
    buf[i++] = c;
 144:	f9f44783          	lbu	a5,-97(s0)
 148:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 14c:	01778763          	beq	a5,s7,15a <gets+0x5e>
 150:	0905                	addi	s2,s2,1
 152:	fd879ce3          	bne	a5,s8,12a <gets+0x2e>
    buf[i++] = c;
 156:	8d4e                	mv	s10,s3
 158:	a011                	j	15c <gets+0x60>
 15a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 15c:	9d66                	add	s10,s10,s9
 15e:	000d0023          	sb	zero,0(s10)
  return buf;
}
 162:	8566                	mv	a0,s9
 164:	70a6                	ld	ra,104(sp)
 166:	7406                	ld	s0,96(sp)
 168:	64e6                	ld	s1,88(sp)
 16a:	6946                	ld	s2,80(sp)
 16c:	69a6                	ld	s3,72(sp)
 16e:	6a06                	ld	s4,64(sp)
 170:	7ae2                	ld	s5,56(sp)
 172:	7b42                	ld	s6,48(sp)
 174:	7ba2                	ld	s7,40(sp)
 176:	7c02                	ld	s8,32(sp)
 178:	6ce2                	ld	s9,24(sp)
 17a:	6d42                	ld	s10,16(sp)
 17c:	6165                	addi	sp,sp,112
 17e:	8082                	ret

0000000000000180 <stat>:

int
stat(const char *n, struct stat *st)
{
 180:	1101                	addi	sp,sp,-32
 182:	ec06                	sd	ra,24(sp)
 184:	e822                	sd	s0,16(sp)
 186:	e04a                	sd	s2,0(sp)
 188:	1000                	addi	s0,sp,32
 18a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18c:	4581                	li	a1,0
 18e:	16e000ef          	jal	2fc <open>
  if(fd < 0)
 192:	02054263          	bltz	a0,1b6 <stat+0x36>
 196:	e426                	sd	s1,8(sp)
 198:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 19a:	85ca                	mv	a1,s2
 19c:	178000ef          	jal	314 <fstat>
 1a0:	892a                	mv	s2,a0
  close(fd);
 1a2:	8526                	mv	a0,s1
 1a4:	140000ef          	jal	2e4 <close>
  return r;
 1a8:	64a2                	ld	s1,8(sp)
}
 1aa:	854a                	mv	a0,s2
 1ac:	60e2                	ld	ra,24(sp)
 1ae:	6442                	ld	s0,16(sp)
 1b0:	6902                	ld	s2,0(sp)
 1b2:	6105                	addi	sp,sp,32
 1b4:	8082                	ret
    return -1;
 1b6:	597d                	li	s2,-1
 1b8:	bfcd                	j	1aa <stat+0x2a>

00000000000001ba <atoi>:

int
atoi(const char *s)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e406                	sd	ra,8(sp)
 1be:	e022                	sd	s0,0(sp)
 1c0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c2:	00054683          	lbu	a3,0(a0)
 1c6:	fd06879b          	addiw	a5,a3,-48
 1ca:	0ff7f793          	zext.b	a5,a5
 1ce:	4625                	li	a2,9
 1d0:	02f66963          	bltu	a2,a5,202 <atoi+0x48>
 1d4:	872a                	mv	a4,a0
  n = 0;
 1d6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d8:	0705                	addi	a4,a4,1
 1da:	0025179b          	slliw	a5,a0,0x2
 1de:	9fa9                	addw	a5,a5,a0
 1e0:	0017979b          	slliw	a5,a5,0x1
 1e4:	9fb5                	addw	a5,a5,a3
 1e6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ea:	00074683          	lbu	a3,0(a4)
 1ee:	fd06879b          	addiw	a5,a3,-48
 1f2:	0ff7f793          	zext.b	a5,a5
 1f6:	fef671e3          	bgeu	a2,a5,1d8 <atoi+0x1e>
  return n;
}
 1fa:	60a2                	ld	ra,8(sp)
 1fc:	6402                	ld	s0,0(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret
  n = 0;
 202:	4501                	li	a0,0
 204:	bfdd                	j	1fa <atoi+0x40>

0000000000000206 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 206:	1141                	addi	sp,sp,-16
 208:	e406                	sd	ra,8(sp)
 20a:	e022                	sd	s0,0(sp)
 20c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 20e:	02b57563          	bgeu	a0,a1,238 <memmove+0x32>
    while(n-- > 0)
 212:	00c05f63          	blez	a2,230 <memmove+0x2a>
 216:	1602                	slli	a2,a2,0x20
 218:	9201                	srli	a2,a2,0x20
 21a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 21e:	872a                	mv	a4,a0
      *dst++ = *src++;
 220:	0585                	addi	a1,a1,1
 222:	0705                	addi	a4,a4,1
 224:	fff5c683          	lbu	a3,-1(a1)
 228:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 230:	60a2                	ld	ra,8(sp)
 232:	6402                	ld	s0,0(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
    dst += n;
 238:	00c50733          	add	a4,a0,a2
    src += n;
 23c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23e:	fec059e3          	blez	a2,230 <memmove+0x2a>
 242:	fff6079b          	addiw	a5,a2,-1
 246:	1782                	slli	a5,a5,0x20
 248:	9381                	srli	a5,a5,0x20
 24a:	fff7c793          	not	a5,a5
 24e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 250:	15fd                	addi	a1,a1,-1
 252:	177d                	addi	a4,a4,-1
 254:	0005c683          	lbu	a3,0(a1)
 258:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25c:	fef71ae3          	bne	a4,a5,250 <memmove+0x4a>
 260:	bfc1                	j	230 <memmove+0x2a>

0000000000000262 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e406                	sd	ra,8(sp)
 266:	e022                	sd	s0,0(sp)
 268:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26a:	ca0d                	beqz	a2,29c <memcmp+0x3a>
 26c:	fff6069b          	addiw	a3,a2,-1
 270:	1682                	slli	a3,a3,0x20
 272:	9281                	srli	a3,a3,0x20
 274:	0685                	addi	a3,a3,1
 276:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 278:	00054783          	lbu	a5,0(a0)
 27c:	0005c703          	lbu	a4,0(a1)
 280:	00e79863          	bne	a5,a4,290 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 284:	0505                	addi	a0,a0,1
    p2++;
 286:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 288:	fed518e3          	bne	a0,a3,278 <memcmp+0x16>
  }
  return 0;
 28c:	4501                	li	a0,0
 28e:	a019                	j	294 <memcmp+0x32>
      return *p1 - *p2;
 290:	40e7853b          	subw	a0,a5,a4
}
 294:	60a2                	ld	ra,8(sp)
 296:	6402                	ld	s0,0(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
  return 0;
 29c:	4501                	li	a0,0
 29e:	bfdd                	j	294 <memcmp+0x32>

00000000000002a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a8:	f5fff0ef          	jal	206 <memmove>
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b4:	4885                	li	a7,1
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2bc:	4889                	li	a7,2
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c4:	488d                	li	a7,3
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2cc:	4891                	li	a7,4
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <read>:
.global read
read:
 li a7, SYS_read
 2d4:	4895                	li	a7,5
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <write>:
.global write
write:
 li a7, SYS_write
 2dc:	48c1                	li	a7,16
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <close>:
.global close
close:
 li a7, SYS_close
 2e4:	48d5                	li	a7,21
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ec:	4899                	li	a7,6
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f4:	489d                	li	a7,7
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <open>:
.global open
open:
 li a7, SYS_open
 2fc:	48bd                	li	a7,15
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 304:	48c5                	li	a7,17
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30c:	48c9                	li	a7,18
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 314:	48a1                	li	a7,8
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <link>:
.global link
link:
 li a7, SYS_link
 31c:	48cd                	li	a7,19
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 324:	48d1                	li	a7,20
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32c:	48a5                	li	a7,9
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <dup>:
.global dup
dup:
 li a7, SYS_dup
 334:	48a9                	li	a7,10
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33c:	48ad                	li	a7,11
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 344:	48b1                	li	a7,12
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34c:	48b5                	li	a7,13
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 354:	48b9                	li	a7,14
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 35c:	48d9                	li	a7,22
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 364:	48dd                	li	a7,23
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 36c:	1101                	addi	sp,sp,-32
 36e:	ec06                	sd	ra,24(sp)
 370:	e822                	sd	s0,16(sp)
 372:	1000                	addi	s0,sp,32
 374:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 378:	4605                	li	a2,1
 37a:	fef40593          	addi	a1,s0,-17
 37e:	f5fff0ef          	jal	2dc <write>
}
 382:	60e2                	ld	ra,24(sp)
 384:	6442                	ld	s0,16(sp)
 386:	6105                	addi	sp,sp,32
 388:	8082                	ret

000000000000038a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38a:	7139                	addi	sp,sp,-64
 38c:	fc06                	sd	ra,56(sp)
 38e:	f822                	sd	s0,48(sp)
 390:	f426                	sd	s1,40(sp)
 392:	f04a                	sd	s2,32(sp)
 394:	ec4e                	sd	s3,24(sp)
 396:	0080                	addi	s0,sp,64
 398:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39a:	c299                	beqz	a3,3a0 <printint+0x16>
 39c:	0605ce63          	bltz	a1,418 <printint+0x8e>
  neg = 0;
 3a0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3a2:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3a6:	869a                	mv	a3,t1
  i = 0;
 3a8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3aa:	00000817          	auipc	a6,0x0
 3ae:	4de80813          	addi	a6,a6,1246 # 888 <digits>
 3b2:	88be                	mv	a7,a5
 3b4:	0017851b          	addiw	a0,a5,1
 3b8:	87aa                	mv	a5,a0
 3ba:	02c5f73b          	remuw	a4,a1,a2
 3be:	1702                	slli	a4,a4,0x20
 3c0:	9301                	srli	a4,a4,0x20
 3c2:	9742                	add	a4,a4,a6
 3c4:	00074703          	lbu	a4,0(a4)
 3c8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3cc:	872e                	mv	a4,a1
 3ce:	02c5d5bb          	divuw	a1,a1,a2
 3d2:	0685                	addi	a3,a3,1
 3d4:	fcc77fe3          	bgeu	a4,a2,3b2 <printint+0x28>
  if(neg)
 3d8:	000e0c63          	beqz	t3,3f0 <printint+0x66>
    buf[i++] = '-';
 3dc:	fd050793          	addi	a5,a0,-48
 3e0:	00878533          	add	a0,a5,s0
 3e4:	02d00793          	li	a5,45
 3e8:	fef50823          	sb	a5,-16(a0)
 3ec:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 3f0:	fff7899b          	addiw	s3,a5,-1
 3f4:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 3f8:	fff4c583          	lbu	a1,-1(s1)
 3fc:	854a                	mv	a0,s2
 3fe:	f6fff0ef          	jal	36c <putc>
  while(--i >= 0)
 402:	39fd                	addiw	s3,s3,-1
 404:	14fd                	addi	s1,s1,-1
 406:	fe09d9e3          	bgez	s3,3f8 <printint+0x6e>
}
 40a:	70e2                	ld	ra,56(sp)
 40c:	7442                	ld	s0,48(sp)
 40e:	74a2                	ld	s1,40(sp)
 410:	7902                	ld	s2,32(sp)
 412:	69e2                	ld	s3,24(sp)
 414:	6121                	addi	sp,sp,64
 416:	8082                	ret
    x = -xx;
 418:	40b005bb          	negw	a1,a1
    neg = 1;
 41c:	4e05                	li	t3,1
    x = -xx;
 41e:	b751                	j	3a2 <printint+0x18>

0000000000000420 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 420:	711d                	addi	sp,sp,-96
 422:	ec86                	sd	ra,88(sp)
 424:	e8a2                	sd	s0,80(sp)
 426:	e4a6                	sd	s1,72(sp)
 428:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 42a:	0005c483          	lbu	s1,0(a1)
 42e:	26048663          	beqz	s1,69a <vprintf+0x27a>
 432:	e0ca                	sd	s2,64(sp)
 434:	fc4e                	sd	s3,56(sp)
 436:	f852                	sd	s4,48(sp)
 438:	f456                	sd	s5,40(sp)
 43a:	f05a                	sd	s6,32(sp)
 43c:	ec5e                	sd	s7,24(sp)
 43e:	e862                	sd	s8,16(sp)
 440:	e466                	sd	s9,8(sp)
 442:	8b2a                	mv	s6,a0
 444:	8a2e                	mv	s4,a1
 446:	8bb2                	mv	s7,a2
  state = 0;
 448:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 44a:	4901                	li	s2,0
 44c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 44e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 452:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 456:	06c00c93          	li	s9,108
 45a:	a00d                	j	47c <vprintf+0x5c>
        putc(fd, c0);
 45c:	85a6                	mv	a1,s1
 45e:	855a                	mv	a0,s6
 460:	f0dff0ef          	jal	36c <putc>
 464:	a019                	j	46a <vprintf+0x4a>
    } else if(state == '%'){
 466:	03598363          	beq	s3,s5,48c <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 46a:	0019079b          	addiw	a5,s2,1
 46e:	893e                	mv	s2,a5
 470:	873e                	mv	a4,a5
 472:	97d2                	add	a5,a5,s4
 474:	0007c483          	lbu	s1,0(a5)
 478:	20048963          	beqz	s1,68a <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 47c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 480:	fe0993e3          	bnez	s3,466 <vprintf+0x46>
      if(c0 == '%'){
 484:	fd579ce3          	bne	a5,s5,45c <vprintf+0x3c>
        state = '%';
 488:	89be                	mv	s3,a5
 48a:	b7c5                	j	46a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 48c:	00ea06b3          	add	a3,s4,a4
 490:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 494:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 496:	c681                	beqz	a3,49e <vprintf+0x7e>
 498:	9752                	add	a4,a4,s4
 49a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 49e:	03878e63          	beq	a5,s8,4da <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4a2:	05978863          	beq	a5,s9,4f2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4a6:	07500713          	li	a4,117
 4aa:	0ee78263          	beq	a5,a4,58e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4ae:	07800713          	li	a4,120
 4b2:	12e78463          	beq	a5,a4,5da <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4b6:	07000713          	li	a4,112
 4ba:	14e78963          	beq	a5,a4,60c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4be:	07300713          	li	a4,115
 4c2:	18e78863          	beq	a5,a4,652 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4c6:	02500713          	li	a4,37
 4ca:	04e79463          	bne	a5,a4,512 <vprintf+0xf2>
        putc(fd, '%');
 4ce:	85ba                	mv	a1,a4
 4d0:	855a                	mv	a0,s6
 4d2:	e9bff0ef          	jal	36c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4d6:	4981                	li	s3,0
 4d8:	bf49                	j	46a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4da:	008b8493          	addi	s1,s7,8
 4de:	4685                	li	a3,1
 4e0:	4629                	li	a2,10
 4e2:	000ba583          	lw	a1,0(s7)
 4e6:	855a                	mv	a0,s6
 4e8:	ea3ff0ef          	jal	38a <printint>
 4ec:	8ba6                	mv	s7,s1
      state = 0;
 4ee:	4981                	li	s3,0
 4f0:	bfad                	j	46a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4f2:	06400793          	li	a5,100
 4f6:	02f68963          	beq	a3,a5,528 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4fa:	06c00793          	li	a5,108
 4fe:	04f68263          	beq	a3,a5,542 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 502:	07500793          	li	a5,117
 506:	0af68063          	beq	a3,a5,5a6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 50a:	07800793          	li	a5,120
 50e:	0ef68263          	beq	a3,a5,5f2 <vprintf+0x1d2>
        putc(fd, '%');
 512:	02500593          	li	a1,37
 516:	855a                	mv	a0,s6
 518:	e55ff0ef          	jal	36c <putc>
        putc(fd, c0);
 51c:	85a6                	mv	a1,s1
 51e:	855a                	mv	a0,s6
 520:	e4dff0ef          	jal	36c <putc>
      state = 0;
 524:	4981                	li	s3,0
 526:	b791                	j	46a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 528:	008b8493          	addi	s1,s7,8
 52c:	4685                	li	a3,1
 52e:	4629                	li	a2,10
 530:	000ba583          	lw	a1,0(s7)
 534:	855a                	mv	a0,s6
 536:	e55ff0ef          	jal	38a <printint>
        i += 1;
 53a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 53c:	8ba6                	mv	s7,s1
      state = 0;
 53e:	4981                	li	s3,0
        i += 1;
 540:	b72d                	j	46a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 542:	06400793          	li	a5,100
 546:	02f60763          	beq	a2,a5,574 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 54a:	07500793          	li	a5,117
 54e:	06f60963          	beq	a2,a5,5c0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 552:	07800793          	li	a5,120
 556:	faf61ee3          	bne	a2,a5,512 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 55a:	008b8493          	addi	s1,s7,8
 55e:	4681                	li	a3,0
 560:	4641                	li	a2,16
 562:	000ba583          	lw	a1,0(s7)
 566:	855a                	mv	a0,s6
 568:	e23ff0ef          	jal	38a <printint>
        i += 2;
 56c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 56e:	8ba6                	mv	s7,s1
      state = 0;
 570:	4981                	li	s3,0
        i += 2;
 572:	bde5                	j	46a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 574:	008b8493          	addi	s1,s7,8
 578:	4685                	li	a3,1
 57a:	4629                	li	a2,10
 57c:	000ba583          	lw	a1,0(s7)
 580:	855a                	mv	a0,s6
 582:	e09ff0ef          	jal	38a <printint>
        i += 2;
 586:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 588:	8ba6                	mv	s7,s1
      state = 0;
 58a:	4981                	li	s3,0
        i += 2;
 58c:	bdf9                	j	46a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 58e:	008b8493          	addi	s1,s7,8
 592:	4681                	li	a3,0
 594:	4629                	li	a2,10
 596:	000ba583          	lw	a1,0(s7)
 59a:	855a                	mv	a0,s6
 59c:	defff0ef          	jal	38a <printint>
 5a0:	8ba6                	mv	s7,s1
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	b5d9                	j	46a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a6:	008b8493          	addi	s1,s7,8
 5aa:	4681                	li	a3,0
 5ac:	4629                	li	a2,10
 5ae:	000ba583          	lw	a1,0(s7)
 5b2:	855a                	mv	a0,s6
 5b4:	dd7ff0ef          	jal	38a <printint>
        i += 1;
 5b8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ba:	8ba6                	mv	s7,s1
      state = 0;
 5bc:	4981                	li	s3,0
        i += 1;
 5be:	b575                	j	46a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c0:	008b8493          	addi	s1,s7,8
 5c4:	4681                	li	a3,0
 5c6:	4629                	li	a2,10
 5c8:	000ba583          	lw	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	dbdff0ef          	jal	38a <printint>
        i += 2;
 5d2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d4:	8ba6                	mv	s7,s1
      state = 0;
 5d6:	4981                	li	s3,0
        i += 2;
 5d8:	bd49                	j	46a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5da:	008b8493          	addi	s1,s7,8
 5de:	4681                	li	a3,0
 5e0:	4641                	li	a2,16
 5e2:	000ba583          	lw	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	da3ff0ef          	jal	38a <printint>
 5ec:	8ba6                	mv	s7,s1
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bdad                	j	46a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f2:	008b8493          	addi	s1,s7,8
 5f6:	4681                	li	a3,0
 5f8:	4641                	li	a2,16
 5fa:	000ba583          	lw	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	d8bff0ef          	jal	38a <printint>
        i += 1;
 604:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 606:	8ba6                	mv	s7,s1
      state = 0;
 608:	4981                	li	s3,0
        i += 1;
 60a:	b585                	j	46a <vprintf+0x4a>
 60c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 60e:	008b8d13          	addi	s10,s7,8
 612:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 616:	03000593          	li	a1,48
 61a:	855a                	mv	a0,s6
 61c:	d51ff0ef          	jal	36c <putc>
  putc(fd, 'x');
 620:	07800593          	li	a1,120
 624:	855a                	mv	a0,s6
 626:	d47ff0ef          	jal	36c <putc>
 62a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 62c:	00000b97          	auipc	s7,0x0
 630:	25cb8b93          	addi	s7,s7,604 # 888 <digits>
 634:	03c9d793          	srli	a5,s3,0x3c
 638:	97de                	add	a5,a5,s7
 63a:	0007c583          	lbu	a1,0(a5)
 63e:	855a                	mv	a0,s6
 640:	d2dff0ef          	jal	36c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 644:	0992                	slli	s3,s3,0x4
 646:	34fd                	addiw	s1,s1,-1
 648:	f4f5                	bnez	s1,634 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 64a:	8bea                	mv	s7,s10
      state = 0;
 64c:	4981                	li	s3,0
 64e:	6d02                	ld	s10,0(sp)
 650:	bd29                	j	46a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 652:	008b8993          	addi	s3,s7,8
 656:	000bb483          	ld	s1,0(s7)
 65a:	cc91                	beqz	s1,676 <vprintf+0x256>
        for(; *s; s++)
 65c:	0004c583          	lbu	a1,0(s1)
 660:	c195                	beqz	a1,684 <vprintf+0x264>
          putc(fd, *s);
 662:	855a                	mv	a0,s6
 664:	d09ff0ef          	jal	36c <putc>
        for(; *s; s++)
 668:	0485                	addi	s1,s1,1
 66a:	0004c583          	lbu	a1,0(s1)
 66e:	f9f5                	bnez	a1,662 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 670:	8bce                	mv	s7,s3
      state = 0;
 672:	4981                	li	s3,0
 674:	bbdd                	j	46a <vprintf+0x4a>
          s = "(null)";
 676:	00000497          	auipc	s1,0x0
 67a:	20a48493          	addi	s1,s1,522 # 880 <malloc+0xfa>
        for(; *s; s++)
 67e:	02800593          	li	a1,40
 682:	b7c5                	j	662 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 684:	8bce                	mv	s7,s3
      state = 0;
 686:	4981                	li	s3,0
 688:	b3cd                	j	46a <vprintf+0x4a>
 68a:	6906                	ld	s2,64(sp)
 68c:	79e2                	ld	s3,56(sp)
 68e:	7a42                	ld	s4,48(sp)
 690:	7aa2                	ld	s5,40(sp)
 692:	7b02                	ld	s6,32(sp)
 694:	6be2                	ld	s7,24(sp)
 696:	6c42                	ld	s8,16(sp)
 698:	6ca2                	ld	s9,8(sp)
    }
  }
}
 69a:	60e6                	ld	ra,88(sp)
 69c:	6446                	ld	s0,80(sp)
 69e:	64a6                	ld	s1,72(sp)
 6a0:	6125                	addi	sp,sp,96
 6a2:	8082                	ret

00000000000006a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6a4:	715d                	addi	sp,sp,-80
 6a6:	ec06                	sd	ra,24(sp)
 6a8:	e822                	sd	s0,16(sp)
 6aa:	1000                	addi	s0,sp,32
 6ac:	e010                	sd	a2,0(s0)
 6ae:	e414                	sd	a3,8(s0)
 6b0:	e818                	sd	a4,16(s0)
 6b2:	ec1c                	sd	a5,24(s0)
 6b4:	03043023          	sd	a6,32(s0)
 6b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6bc:	8622                	mv	a2,s0
 6be:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6c2:	d5fff0ef          	jal	420 <vprintf>
}
 6c6:	60e2                	ld	ra,24(sp)
 6c8:	6442                	ld	s0,16(sp)
 6ca:	6161                	addi	sp,sp,80
 6cc:	8082                	ret

00000000000006ce <printf>:

void
printf(const char *fmt, ...)
{
 6ce:	711d                	addi	sp,sp,-96
 6d0:	ec06                	sd	ra,24(sp)
 6d2:	e822                	sd	s0,16(sp)
 6d4:	1000                	addi	s0,sp,32
 6d6:	e40c                	sd	a1,8(s0)
 6d8:	e810                	sd	a2,16(s0)
 6da:	ec14                	sd	a3,24(s0)
 6dc:	f018                	sd	a4,32(s0)
 6de:	f41c                	sd	a5,40(s0)
 6e0:	03043823          	sd	a6,48(s0)
 6e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6e8:	00840613          	addi	a2,s0,8
 6ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6f0:	85aa                	mv	a1,a0
 6f2:	4505                	li	a0,1
 6f4:	d2dff0ef          	jal	420 <vprintf>
}
 6f8:	60e2                	ld	ra,24(sp)
 6fa:	6442                	ld	s0,16(sp)
 6fc:	6125                	addi	sp,sp,96
 6fe:	8082                	ret

0000000000000700 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 700:	1141                	addi	sp,sp,-16
 702:	e406                	sd	ra,8(sp)
 704:	e022                	sd	s0,0(sp)
 706:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 708:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70c:	00001797          	auipc	a5,0x1
 710:	8f47b783          	ld	a5,-1804(a5) # 1000 <freep>
 714:	a02d                	j	73e <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 716:	4618                	lw	a4,8(a2)
 718:	9f2d                	addw	a4,a4,a1
 71a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 71e:	6398                	ld	a4,0(a5)
 720:	6310                	ld	a2,0(a4)
 722:	a83d                	j	760 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 724:	ff852703          	lw	a4,-8(a0)
 728:	9f31                	addw	a4,a4,a2
 72a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 72c:	ff053683          	ld	a3,-16(a0)
 730:	a091                	j	774 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 732:	6398                	ld	a4,0(a5)
 734:	00e7e463          	bltu	a5,a4,73c <free+0x3c>
 738:	00e6ea63          	bltu	a3,a4,74c <free+0x4c>
{
 73c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73e:	fed7fae3          	bgeu	a5,a3,732 <free+0x32>
 742:	6398                	ld	a4,0(a5)
 744:	00e6e463          	bltu	a3,a4,74c <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 748:	fee7eae3          	bltu	a5,a4,73c <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 74c:	ff852583          	lw	a1,-8(a0)
 750:	6390                	ld	a2,0(a5)
 752:	02059813          	slli	a6,a1,0x20
 756:	01c85713          	srli	a4,a6,0x1c
 75a:	9736                	add	a4,a4,a3
 75c:	fae60de3          	beq	a2,a4,716 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 760:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 764:	4790                	lw	a2,8(a5)
 766:	02061593          	slli	a1,a2,0x20
 76a:	01c5d713          	srli	a4,a1,0x1c
 76e:	973e                	add	a4,a4,a5
 770:	fae68ae3          	beq	a3,a4,724 <free+0x24>
    p->s.ptr = bp->s.ptr;
 774:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 776:	00001717          	auipc	a4,0x1
 77a:	88f73523          	sd	a5,-1910(a4) # 1000 <freep>
}
 77e:	60a2                	ld	ra,8(sp)
 780:	6402                	ld	s0,0(sp)
 782:	0141                	addi	sp,sp,16
 784:	8082                	ret

0000000000000786 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 786:	7139                	addi	sp,sp,-64
 788:	fc06                	sd	ra,56(sp)
 78a:	f822                	sd	s0,48(sp)
 78c:	f04a                	sd	s2,32(sp)
 78e:	ec4e                	sd	s3,24(sp)
 790:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 792:	02051993          	slli	s3,a0,0x20
 796:	0209d993          	srli	s3,s3,0x20
 79a:	09bd                	addi	s3,s3,15
 79c:	0049d993          	srli	s3,s3,0x4
 7a0:	2985                	addiw	s3,s3,1
 7a2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7a4:	00001517          	auipc	a0,0x1
 7a8:	85c53503          	ld	a0,-1956(a0) # 1000 <freep>
 7ac:	c905                	beqz	a0,7dc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b0:	4798                	lw	a4,8(a5)
 7b2:	09377663          	bgeu	a4,s3,83e <malloc+0xb8>
 7b6:	f426                	sd	s1,40(sp)
 7b8:	e852                	sd	s4,16(sp)
 7ba:	e456                	sd	s5,8(sp)
 7bc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7be:	8a4e                	mv	s4,s3
 7c0:	6705                	lui	a4,0x1
 7c2:	00e9f363          	bgeu	s3,a4,7c8 <malloc+0x42>
 7c6:	6a05                	lui	s4,0x1
 7c8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7cc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7d0:	00001497          	auipc	s1,0x1
 7d4:	83048493          	addi	s1,s1,-2000 # 1000 <freep>
  if(p == (char*)-1)
 7d8:	5afd                	li	s5,-1
 7da:	a83d                	j	818 <malloc+0x92>
 7dc:	f426                	sd	s1,40(sp)
 7de:	e852                	sd	s4,16(sp)
 7e0:	e456                	sd	s5,8(sp)
 7e2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7e4:	00001797          	auipc	a5,0x1
 7e8:	82c78793          	addi	a5,a5,-2004 # 1010 <base>
 7ec:	00001717          	auipc	a4,0x1
 7f0:	80f73a23          	sd	a5,-2028(a4) # 1000 <freep>
 7f4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7f6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7fa:	b7d1                	j	7be <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7fc:	6398                	ld	a4,0(a5)
 7fe:	e118                	sd	a4,0(a0)
 800:	a899                	j	856 <malloc+0xd0>
  hp->s.size = nu;
 802:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 806:	0541                	addi	a0,a0,16
 808:	ef9ff0ef          	jal	700 <free>
  return freep;
 80c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 80e:	c125                	beqz	a0,86e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 810:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 812:	4798                	lw	a4,8(a5)
 814:	03277163          	bgeu	a4,s2,836 <malloc+0xb0>
    if(p == freep)
 818:	6098                	ld	a4,0(s1)
 81a:	853e                	mv	a0,a5
 81c:	fef71ae3          	bne	a4,a5,810 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 820:	8552                	mv	a0,s4
 822:	b23ff0ef          	jal	344 <sbrk>
  if(p == (char*)-1)
 826:	fd551ee3          	bne	a0,s5,802 <malloc+0x7c>
        return 0;
 82a:	4501                	li	a0,0
 82c:	74a2                	ld	s1,40(sp)
 82e:	6a42                	ld	s4,16(sp)
 830:	6aa2                	ld	s5,8(sp)
 832:	6b02                	ld	s6,0(sp)
 834:	a03d                	j	862 <malloc+0xdc>
 836:	74a2                	ld	s1,40(sp)
 838:	6a42                	ld	s4,16(sp)
 83a:	6aa2                	ld	s5,8(sp)
 83c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 83e:	fae90fe3          	beq	s2,a4,7fc <malloc+0x76>
        p->s.size -= nunits;
 842:	4137073b          	subw	a4,a4,s3
 846:	c798                	sw	a4,8(a5)
        p += p->s.size;
 848:	02071693          	slli	a3,a4,0x20
 84c:	01c6d713          	srli	a4,a3,0x1c
 850:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 852:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 856:	00000717          	auipc	a4,0x0
 85a:	7aa73523          	sd	a0,1962(a4) # 1000 <freep>
      return (void*)(p + 1);
 85e:	01078513          	addi	a0,a5,16
  }
}
 862:	70e2                	ld	ra,56(sp)
 864:	7442                	ld	s0,48(sp)
 866:	7902                	ld	s2,32(sp)
 868:	69e2                	ld	s3,24(sp)
 86a:	6121                	addi	sp,sp,64
 86c:	8082                	ret
 86e:	74a2                	ld	s1,40(sp)
 870:	6a42                	ld	s4,16(sp)
 872:	6aa2                	ld	s5,8(sp)
 874:	6b02                	ld	s6,0(sp)
 876:	b7f5                	j	862 <malloc+0xdc>
