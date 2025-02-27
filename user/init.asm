
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	91250513          	addi	a0,a0,-1774 # 920 <malloc+0xfc>
  16:	384000ef          	jal	39a <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	3b2000ef          	jal	3d2 <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	3ac000ef          	jal	3d2 <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	8fe90913          	addi	s2,s2,-1794 # 928 <malloc+0x104>
  32:	854a                	mv	a0,s2
  34:	738000ef          	jal	76c <printf>
    pid = fork();
  38:	31a000ef          	jal	352 <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	31c000ef          	jal	362 <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	92650513          	addi	a0,a0,-1754 # 978 <malloc+0x154>
  5a:	712000ef          	jal	76c <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	2fa000ef          	jal	35a <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	8b850513          	addi	a0,a0,-1864 # 920 <malloc+0xfc>
  70:	332000ef          	jal	3a2 <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	8aa50513          	addi	a0,a0,-1878 # 920 <malloc+0xfc>
  7e:	31c000ef          	jal	39a <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	8bc50513          	addi	a0,a0,-1860 # 940 <malloc+0x11c>
  8c:	6e0000ef          	jal	76c <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	2c8000ef          	jal	35a <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	8ba50513          	addi	a0,a0,-1862 # 958 <malloc+0x134>
  a6:	2ec000ef          	jal	392 <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	8b650513          	addi	a0,a0,-1866 # 960 <malloc+0x13c>
  b2:	6ba000ef          	jal	76c <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	2a2000ef          	jal	35a <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c4:	f3dff0ef          	jal	0 <main>
  exit(0);
  c8:	4501                	li	a0,0
  ca:	290000ef          	jal	35a <exit>

00000000000000ce <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e406                	sd	ra,8(sp)
  d2:	e022                	sd	s0,0(sp)
  d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d6:	87aa                	mv	a5,a0
  d8:	0585                	addi	a1,a1,1
  da:	0785                	addi	a5,a5,1
  dc:	fff5c703          	lbu	a4,-1(a1)
  e0:	fee78fa3          	sb	a4,-1(a5)
  e4:	fb75                	bnez	a4,d8 <strcpy+0xa>
    ;
  return os;
}
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e406                	sd	ra,8(sp)
  f2:	e022                	sd	s0,0(sp)
  f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cb91                	beqz	a5,10e <strcmp+0x20>
  fc:	0005c703          	lbu	a4,0(a1)
 100:	00f71763          	bne	a4,a5,10e <strcmp+0x20>
    p++, q++;
 104:	0505                	addi	a0,a0,1
 106:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 108:	00054783          	lbu	a5,0(a0)
 10c:	fbe5                	bnez	a5,fc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 10e:	0005c503          	lbu	a0,0(a1)
}
 112:	40a7853b          	subw	a0,a5,a0
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strlen>:

uint
strlen(const char *s)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cf99                	beqz	a5,148 <strlen+0x2a>
 12c:	0505                	addi	a0,a0,1
 12e:	87aa                	mv	a5,a0
 130:	86be                	mv	a3,a5
 132:	0785                	addi	a5,a5,1
 134:	fff7c703          	lbu	a4,-1(a5)
 138:	ff65                	bnez	a4,130 <strlen+0x12>
 13a:	40a6853b          	subw	a0,a3,a0
 13e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret
  for(n = 0; s[n]; n++)
 148:	4501                	li	a0,0
 14a:	bfdd                	j	140 <strlen+0x22>

000000000000014c <memset>:

void*
memset(void *dst, int c, uint n)
{
 14c:	1141                	addi	sp,sp,-16
 14e:	e406                	sd	ra,8(sp)
 150:	e022                	sd	s0,0(sp)
 152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 154:	ca19                	beqz	a2,16a <memset+0x1e>
 156:	87aa                	mv	a5,a0
 158:	1602                	slli	a2,a2,0x20
 15a:	9201                	srli	a2,a2,0x20
 15c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 164:	0785                	addi	a5,a5,1
 166:	fee79de3          	bne	a5,a4,160 <memset+0x14>
  }
  return dst;
}
 16a:	60a2                	ld	ra,8(sp)
 16c:	6402                	ld	s0,0(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret

0000000000000172 <strchr>:

char*
strchr(const char *s, char c)
{
 172:	1141                	addi	sp,sp,-16
 174:	e406                	sd	ra,8(sp)
 176:	e022                	sd	s0,0(sp)
 178:	0800                	addi	s0,sp,16
  for(; *s; s++)
 17a:	00054783          	lbu	a5,0(a0)
 17e:	cf81                	beqz	a5,196 <strchr+0x24>
    if(*s == c)
 180:	00f58763          	beq	a1,a5,18e <strchr+0x1c>
  for(; *s; s++)
 184:	0505                	addi	a0,a0,1
 186:	00054783          	lbu	a5,0(a0)
 18a:	fbfd                	bnez	a5,180 <strchr+0xe>
      return (char*)s;
  return 0;
 18c:	4501                	li	a0,0
}
 18e:	60a2                	ld	ra,8(sp)
 190:	6402                	ld	s0,0(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret
  return 0;
 196:	4501                	li	a0,0
 198:	bfdd                	j	18e <strchr+0x1c>

000000000000019a <gets>:

char*
gets(char *buf, int max)
{
 19a:	7159                	addi	sp,sp,-112
 19c:	f486                	sd	ra,104(sp)
 19e:	f0a2                	sd	s0,96(sp)
 1a0:	eca6                	sd	s1,88(sp)
 1a2:	e8ca                	sd	s2,80(sp)
 1a4:	e4ce                	sd	s3,72(sp)
 1a6:	e0d2                	sd	s4,64(sp)
 1a8:	fc56                	sd	s5,56(sp)
 1aa:	f85a                	sd	s6,48(sp)
 1ac:	f45e                	sd	s7,40(sp)
 1ae:	f062                	sd	s8,32(sp)
 1b0:	ec66                	sd	s9,24(sp)
 1b2:	e86a                	sd	s10,16(sp)
 1b4:	1880                	addi	s0,sp,112
 1b6:	8caa                	mv	s9,a0
 1b8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ba:	892a                	mv	s2,a0
 1bc:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1be:	f9f40b13          	addi	s6,s0,-97
 1c2:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c4:	4ba9                	li	s7,10
 1c6:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1c8:	8d26                	mv	s10,s1
 1ca:	0014899b          	addiw	s3,s1,1
 1ce:	84ce                	mv	s1,s3
 1d0:	0349d563          	bge	s3,s4,1fa <gets+0x60>
    cc = read(0, &c, 1);
 1d4:	8656                	mv	a2,s5
 1d6:	85da                	mv	a1,s6
 1d8:	4501                	li	a0,0
 1da:	198000ef          	jal	372 <read>
    if(cc < 1)
 1de:	00a05e63          	blez	a0,1fa <gets+0x60>
    buf[i++] = c;
 1e2:	f9f44783          	lbu	a5,-97(s0)
 1e6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ea:	01778763          	beq	a5,s7,1f8 <gets+0x5e>
 1ee:	0905                	addi	s2,s2,1
 1f0:	fd879ce3          	bne	a5,s8,1c8 <gets+0x2e>
    buf[i++] = c;
 1f4:	8d4e                	mv	s10,s3
 1f6:	a011                	j	1fa <gets+0x60>
 1f8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1fa:	9d66                	add	s10,s10,s9
 1fc:	000d0023          	sb	zero,0(s10)
  return buf;
}
 200:	8566                	mv	a0,s9
 202:	70a6                	ld	ra,104(sp)
 204:	7406                	ld	s0,96(sp)
 206:	64e6                	ld	s1,88(sp)
 208:	6946                	ld	s2,80(sp)
 20a:	69a6                	ld	s3,72(sp)
 20c:	6a06                	ld	s4,64(sp)
 20e:	7ae2                	ld	s5,56(sp)
 210:	7b42                	ld	s6,48(sp)
 212:	7ba2                	ld	s7,40(sp)
 214:	7c02                	ld	s8,32(sp)
 216:	6ce2                	ld	s9,24(sp)
 218:	6d42                	ld	s10,16(sp)
 21a:	6165                	addi	sp,sp,112
 21c:	8082                	ret

000000000000021e <stat>:

int
stat(const char *n, struct stat *st)
{
 21e:	1101                	addi	sp,sp,-32
 220:	ec06                	sd	ra,24(sp)
 222:	e822                	sd	s0,16(sp)
 224:	e04a                	sd	s2,0(sp)
 226:	1000                	addi	s0,sp,32
 228:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22a:	4581                	li	a1,0
 22c:	16e000ef          	jal	39a <open>
  if(fd < 0)
 230:	02054263          	bltz	a0,254 <stat+0x36>
 234:	e426                	sd	s1,8(sp)
 236:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 238:	85ca                	mv	a1,s2
 23a:	178000ef          	jal	3b2 <fstat>
 23e:	892a                	mv	s2,a0
  close(fd);
 240:	8526                	mv	a0,s1
 242:	140000ef          	jal	382 <close>
  return r;
 246:	64a2                	ld	s1,8(sp)
}
 248:	854a                	mv	a0,s2
 24a:	60e2                	ld	ra,24(sp)
 24c:	6442                	ld	s0,16(sp)
 24e:	6902                	ld	s2,0(sp)
 250:	6105                	addi	sp,sp,32
 252:	8082                	ret
    return -1;
 254:	597d                	li	s2,-1
 256:	bfcd                	j	248 <stat+0x2a>

0000000000000258 <atoi>:

int
atoi(const char *s)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e406                	sd	ra,8(sp)
 25c:	e022                	sd	s0,0(sp)
 25e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 260:	00054683          	lbu	a3,0(a0)
 264:	fd06879b          	addiw	a5,a3,-48
 268:	0ff7f793          	zext.b	a5,a5
 26c:	4625                	li	a2,9
 26e:	02f66963          	bltu	a2,a5,2a0 <atoi+0x48>
 272:	872a                	mv	a4,a0
  n = 0;
 274:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 276:	0705                	addi	a4,a4,1
 278:	0025179b          	slliw	a5,a0,0x2
 27c:	9fa9                	addw	a5,a5,a0
 27e:	0017979b          	slliw	a5,a5,0x1
 282:	9fb5                	addw	a5,a5,a3
 284:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 288:	00074683          	lbu	a3,0(a4)
 28c:	fd06879b          	addiw	a5,a3,-48
 290:	0ff7f793          	zext.b	a5,a5
 294:	fef671e3          	bgeu	a2,a5,276 <atoi+0x1e>
  return n;
}
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret
  n = 0;
 2a0:	4501                	li	a0,0
 2a2:	bfdd                	j	298 <atoi+0x40>

00000000000002a4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e406                	sd	ra,8(sp)
 2a8:	e022                	sd	s0,0(sp)
 2aa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ac:	02b57563          	bgeu	a0,a1,2d6 <memmove+0x32>
    while(n-- > 0)
 2b0:	00c05f63          	blez	a2,2ce <memmove+0x2a>
 2b4:	1602                	slli	a2,a2,0x20
 2b6:	9201                	srli	a2,a2,0x20
 2b8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2bc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2be:	0585                	addi	a1,a1,1
 2c0:	0705                	addi	a4,a4,1
 2c2:	fff5c683          	lbu	a3,-1(a1)
 2c6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ca:	fee79ae3          	bne	a5,a4,2be <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
    dst += n;
 2d6:	00c50733          	add	a4,a0,a2
    src += n;
 2da:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2dc:	fec059e3          	blez	a2,2ce <memmove+0x2a>
 2e0:	fff6079b          	addiw	a5,a2,-1
 2e4:	1782                	slli	a5,a5,0x20
 2e6:	9381                	srli	a5,a5,0x20
 2e8:	fff7c793          	not	a5,a5
 2ec:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ee:	15fd                	addi	a1,a1,-1
 2f0:	177d                	addi	a4,a4,-1
 2f2:	0005c683          	lbu	a3,0(a1)
 2f6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2fa:	fef71ae3          	bne	a4,a5,2ee <memmove+0x4a>
 2fe:	bfc1                	j	2ce <memmove+0x2a>

0000000000000300 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 308:	ca0d                	beqz	a2,33a <memcmp+0x3a>
 30a:	fff6069b          	addiw	a3,a2,-1
 30e:	1682                	slli	a3,a3,0x20
 310:	9281                	srli	a3,a3,0x20
 312:	0685                	addi	a3,a3,1
 314:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 316:	00054783          	lbu	a5,0(a0)
 31a:	0005c703          	lbu	a4,0(a1)
 31e:	00e79863          	bne	a5,a4,32e <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 322:	0505                	addi	a0,a0,1
    p2++;
 324:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 326:	fed518e3          	bne	a0,a3,316 <memcmp+0x16>
  }
  return 0;
 32a:	4501                	li	a0,0
 32c:	a019                	j	332 <memcmp+0x32>
      return *p1 - *p2;
 32e:	40e7853b          	subw	a0,a5,a4
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret
  return 0;
 33a:	4501                	li	a0,0
 33c:	bfdd                	j	332 <memcmp+0x32>

000000000000033e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 346:	f5fff0ef          	jal	2a4 <memmove>
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret

0000000000000352 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 352:	4885                	li	a7,1
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <exit>:
.global exit
exit:
 li a7, SYS_exit
 35a:	4889                	li	a7,2
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <wait>:
.global wait
wait:
 li a7, SYS_wait
 362:	488d                	li	a7,3
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 36a:	4891                	li	a7,4
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <read>:
.global read
read:
 li a7, SYS_read
 372:	4895                	li	a7,5
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <write>:
.global write
write:
 li a7, SYS_write
 37a:	48c1                	li	a7,16
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <close>:
.global close
close:
 li a7, SYS_close
 382:	48d5                	li	a7,21
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <kill>:
.global kill
kill:
 li a7, SYS_kill
 38a:	4899                	li	a7,6
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <exec>:
.global exec
exec:
 li a7, SYS_exec
 392:	489d                	li	a7,7
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <open>:
.global open
open:
 li a7, SYS_open
 39a:	48bd                	li	a7,15
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a2:	48c5                	li	a7,17
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3aa:	48c9                	li	a7,18
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b2:	48a1                	li	a7,8
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <link>:
.global link
link:
 li a7, SYS_link
 3ba:	48cd                	li	a7,19
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c2:	48d1                	li	a7,20
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ca:	48a5                	li	a7,9
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d2:	48a9                	li	a7,10
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3da:	48ad                	li	a7,11
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3e2:	48b1                	li	a7,12
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ea:	48b5                	li	a7,13
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f2:	48b9                	li	a7,14
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3fa:	48d9                	li	a7,22
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 402:	48dd                	li	a7,23
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40a:	1101                	addi	sp,sp,-32
 40c:	ec06                	sd	ra,24(sp)
 40e:	e822                	sd	s0,16(sp)
 410:	1000                	addi	s0,sp,32
 412:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 416:	4605                	li	a2,1
 418:	fef40593          	addi	a1,s0,-17
 41c:	f5fff0ef          	jal	37a <write>
}
 420:	60e2                	ld	ra,24(sp)
 422:	6442                	ld	s0,16(sp)
 424:	6105                	addi	sp,sp,32
 426:	8082                	ret

0000000000000428 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 428:	7139                	addi	sp,sp,-64
 42a:	fc06                	sd	ra,56(sp)
 42c:	f822                	sd	s0,48(sp)
 42e:	f426                	sd	s1,40(sp)
 430:	f04a                	sd	s2,32(sp)
 432:	ec4e                	sd	s3,24(sp)
 434:	0080                	addi	s0,sp,64
 436:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 438:	c299                	beqz	a3,43e <printint+0x16>
 43a:	0605ce63          	bltz	a1,4b6 <printint+0x8e>
  neg = 0;
 43e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 440:	fc040313          	addi	t1,s0,-64
  neg = 0;
 444:	869a                	mv	a3,t1
  i = 0;
 446:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 448:	00000817          	auipc	a6,0x0
 44c:	55880813          	addi	a6,a6,1368 # 9a0 <digits>
 450:	88be                	mv	a7,a5
 452:	0017851b          	addiw	a0,a5,1
 456:	87aa                	mv	a5,a0
 458:	02c5f73b          	remuw	a4,a1,a2
 45c:	1702                	slli	a4,a4,0x20
 45e:	9301                	srli	a4,a4,0x20
 460:	9742                	add	a4,a4,a6
 462:	00074703          	lbu	a4,0(a4)
 466:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 46a:	872e                	mv	a4,a1
 46c:	02c5d5bb          	divuw	a1,a1,a2
 470:	0685                	addi	a3,a3,1
 472:	fcc77fe3          	bgeu	a4,a2,450 <printint+0x28>
  if(neg)
 476:	000e0c63          	beqz	t3,48e <printint+0x66>
    buf[i++] = '-';
 47a:	fd050793          	addi	a5,a0,-48
 47e:	00878533          	add	a0,a5,s0
 482:	02d00793          	li	a5,45
 486:	fef50823          	sb	a5,-16(a0)
 48a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 48e:	fff7899b          	addiw	s3,a5,-1
 492:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 496:	fff4c583          	lbu	a1,-1(s1)
 49a:	854a                	mv	a0,s2
 49c:	f6fff0ef          	jal	40a <putc>
  while(--i >= 0)
 4a0:	39fd                	addiw	s3,s3,-1
 4a2:	14fd                	addi	s1,s1,-1
 4a4:	fe09d9e3          	bgez	s3,496 <printint+0x6e>
}
 4a8:	70e2                	ld	ra,56(sp)
 4aa:	7442                	ld	s0,48(sp)
 4ac:	74a2                	ld	s1,40(sp)
 4ae:	7902                	ld	s2,32(sp)
 4b0:	69e2                	ld	s3,24(sp)
 4b2:	6121                	addi	sp,sp,64
 4b4:	8082                	ret
    x = -xx;
 4b6:	40b005bb          	negw	a1,a1
    neg = 1;
 4ba:	4e05                	li	t3,1
    x = -xx;
 4bc:	b751                	j	440 <printint+0x18>

00000000000004be <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4be:	711d                	addi	sp,sp,-96
 4c0:	ec86                	sd	ra,88(sp)
 4c2:	e8a2                	sd	s0,80(sp)
 4c4:	e4a6                	sd	s1,72(sp)
 4c6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c8:	0005c483          	lbu	s1,0(a1)
 4cc:	26048663          	beqz	s1,738 <vprintf+0x27a>
 4d0:	e0ca                	sd	s2,64(sp)
 4d2:	fc4e                	sd	s3,56(sp)
 4d4:	f852                	sd	s4,48(sp)
 4d6:	f456                	sd	s5,40(sp)
 4d8:	f05a                	sd	s6,32(sp)
 4da:	ec5e                	sd	s7,24(sp)
 4dc:	e862                	sd	s8,16(sp)
 4de:	e466                	sd	s9,8(sp)
 4e0:	8b2a                	mv	s6,a0
 4e2:	8a2e                	mv	s4,a1
 4e4:	8bb2                	mv	s7,a2
  state = 0;
 4e6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4e8:	4901                	li	s2,0
 4ea:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ec:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4f0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4f4:	06c00c93          	li	s9,108
 4f8:	a00d                	j	51a <vprintf+0x5c>
        putc(fd, c0);
 4fa:	85a6                	mv	a1,s1
 4fc:	855a                	mv	a0,s6
 4fe:	f0dff0ef          	jal	40a <putc>
 502:	a019                	j	508 <vprintf+0x4a>
    } else if(state == '%'){
 504:	03598363          	beq	s3,s5,52a <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 508:	0019079b          	addiw	a5,s2,1
 50c:	893e                	mv	s2,a5
 50e:	873e                	mv	a4,a5
 510:	97d2                	add	a5,a5,s4
 512:	0007c483          	lbu	s1,0(a5)
 516:	20048963          	beqz	s1,728 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 51a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 51e:	fe0993e3          	bnez	s3,504 <vprintf+0x46>
      if(c0 == '%'){
 522:	fd579ce3          	bne	a5,s5,4fa <vprintf+0x3c>
        state = '%';
 526:	89be                	mv	s3,a5
 528:	b7c5                	j	508 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 52a:	00ea06b3          	add	a3,s4,a4
 52e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 532:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 534:	c681                	beqz	a3,53c <vprintf+0x7e>
 536:	9752                	add	a4,a4,s4
 538:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 53c:	03878e63          	beq	a5,s8,578 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 540:	05978863          	beq	a5,s9,590 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 544:	07500713          	li	a4,117
 548:	0ee78263          	beq	a5,a4,62c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 54c:	07800713          	li	a4,120
 550:	12e78463          	beq	a5,a4,678 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 554:	07000713          	li	a4,112
 558:	14e78963          	beq	a5,a4,6aa <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 55c:	07300713          	li	a4,115
 560:	18e78863          	beq	a5,a4,6f0 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 564:	02500713          	li	a4,37
 568:	04e79463          	bne	a5,a4,5b0 <vprintf+0xf2>
        putc(fd, '%');
 56c:	85ba                	mv	a1,a4
 56e:	855a                	mv	a0,s6
 570:	e9bff0ef          	jal	40a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 574:	4981                	li	s3,0
 576:	bf49                	j	508 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 578:	008b8493          	addi	s1,s7,8
 57c:	4685                	li	a3,1
 57e:	4629                	li	a2,10
 580:	000ba583          	lw	a1,0(s7)
 584:	855a                	mv	a0,s6
 586:	ea3ff0ef          	jal	428 <printint>
 58a:	8ba6                	mv	s7,s1
      state = 0;
 58c:	4981                	li	s3,0
 58e:	bfad                	j	508 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 590:	06400793          	li	a5,100
 594:	02f68963          	beq	a3,a5,5c6 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 598:	06c00793          	li	a5,108
 59c:	04f68263          	beq	a3,a5,5e0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5a0:	07500793          	li	a5,117
 5a4:	0af68063          	beq	a3,a5,644 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5a8:	07800793          	li	a5,120
 5ac:	0ef68263          	beq	a3,a5,690 <vprintf+0x1d2>
        putc(fd, '%');
 5b0:	02500593          	li	a1,37
 5b4:	855a                	mv	a0,s6
 5b6:	e55ff0ef          	jal	40a <putc>
        putc(fd, c0);
 5ba:	85a6                	mv	a1,s1
 5bc:	855a                	mv	a0,s6
 5be:	e4dff0ef          	jal	40a <putc>
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b791                	j	508 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c6:	008b8493          	addi	s1,s7,8
 5ca:	4685                	li	a3,1
 5cc:	4629                	li	a2,10
 5ce:	000ba583          	lw	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	e55ff0ef          	jal	428 <printint>
        i += 1;
 5d8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
        i += 1;
 5de:	b72d                	j	508 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5e0:	06400793          	li	a5,100
 5e4:	02f60763          	beq	a2,a5,612 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5e8:	07500793          	li	a5,117
 5ec:	06f60963          	beq	a2,a5,65e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5f0:	07800793          	li	a5,120
 5f4:	faf61ee3          	bne	a2,a5,5b0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4641                	li	a2,16
 600:	000ba583          	lw	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	e23ff0ef          	jal	428 <printint>
        i += 2;
 60a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 60c:	8ba6                	mv	s7,s1
      state = 0;
 60e:	4981                	li	s3,0
        i += 2;
 610:	bde5                	j	508 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 612:	008b8493          	addi	s1,s7,8
 616:	4685                	li	a3,1
 618:	4629                	li	a2,10
 61a:	000ba583          	lw	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	e09ff0ef          	jal	428 <printint>
        i += 2;
 624:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 626:	8ba6                	mv	s7,s1
      state = 0;
 628:	4981                	li	s3,0
        i += 2;
 62a:	bdf9                	j	508 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 62c:	008b8493          	addi	s1,s7,8
 630:	4681                	li	a3,0
 632:	4629                	li	a2,10
 634:	000ba583          	lw	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	defff0ef          	jal	428 <printint>
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
 642:	b5d9                	j	508 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 644:	008b8493          	addi	s1,s7,8
 648:	4681                	li	a3,0
 64a:	4629                	li	a2,10
 64c:	000ba583          	lw	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	dd7ff0ef          	jal	428 <printint>
        i += 1;
 656:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
        i += 1;
 65c:	b575                	j	508 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65e:	008b8493          	addi	s1,s7,8
 662:	4681                	li	a3,0
 664:	4629                	li	a2,10
 666:	000ba583          	lw	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	dbdff0ef          	jal	428 <printint>
        i += 2;
 670:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
        i += 2;
 676:	bd49                	j	508 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 678:	008b8493          	addi	s1,s7,8
 67c:	4681                	li	a3,0
 67e:	4641                	li	a2,16
 680:	000ba583          	lw	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	da3ff0ef          	jal	428 <printint>
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bdad                	j	508 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 690:	008b8493          	addi	s1,s7,8
 694:	4681                	li	a3,0
 696:	4641                	li	a2,16
 698:	000ba583          	lw	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	d8bff0ef          	jal	428 <printint>
        i += 1;
 6a2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
        i += 1;
 6a8:	b585                	j	508 <vprintf+0x4a>
 6aa:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6ac:	008b8d13          	addi	s10,s7,8
 6b0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b4:	03000593          	li	a1,48
 6b8:	855a                	mv	a0,s6
 6ba:	d51ff0ef          	jal	40a <putc>
  putc(fd, 'x');
 6be:	07800593          	li	a1,120
 6c2:	855a                	mv	a0,s6
 6c4:	d47ff0ef          	jal	40a <putc>
 6c8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ca:	00000b97          	auipc	s7,0x0
 6ce:	2d6b8b93          	addi	s7,s7,726 # 9a0 <digits>
 6d2:	03c9d793          	srli	a5,s3,0x3c
 6d6:	97de                	add	a5,a5,s7
 6d8:	0007c583          	lbu	a1,0(a5)
 6dc:	855a                	mv	a0,s6
 6de:	d2dff0ef          	jal	40a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e2:	0992                	slli	s3,s3,0x4
 6e4:	34fd                	addiw	s1,s1,-1
 6e6:	f4f5                	bnez	s1,6d2 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6e8:	8bea                	mv	s7,s10
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	6d02                	ld	s10,0(sp)
 6ee:	bd29                	j	508 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6f0:	008b8993          	addi	s3,s7,8
 6f4:	000bb483          	ld	s1,0(s7)
 6f8:	cc91                	beqz	s1,714 <vprintf+0x256>
        for(; *s; s++)
 6fa:	0004c583          	lbu	a1,0(s1)
 6fe:	c195                	beqz	a1,722 <vprintf+0x264>
          putc(fd, *s);
 700:	855a                	mv	a0,s6
 702:	d09ff0ef          	jal	40a <putc>
        for(; *s; s++)
 706:	0485                	addi	s1,s1,1
 708:	0004c583          	lbu	a1,0(s1)
 70c:	f9f5                	bnez	a1,700 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 70e:	8bce                	mv	s7,s3
      state = 0;
 710:	4981                	li	s3,0
 712:	bbdd                	j	508 <vprintf+0x4a>
          s = "(null)";
 714:	00000497          	auipc	s1,0x0
 718:	28448493          	addi	s1,s1,644 # 998 <malloc+0x174>
        for(; *s; s++)
 71c:	02800593          	li	a1,40
 720:	b7c5                	j	700 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 722:	8bce                	mv	s7,s3
      state = 0;
 724:	4981                	li	s3,0
 726:	b3cd                	j	508 <vprintf+0x4a>
 728:	6906                	ld	s2,64(sp)
 72a:	79e2                	ld	s3,56(sp)
 72c:	7a42                	ld	s4,48(sp)
 72e:	7aa2                	ld	s5,40(sp)
 730:	7b02                	ld	s6,32(sp)
 732:	6be2                	ld	s7,24(sp)
 734:	6c42                	ld	s8,16(sp)
 736:	6ca2                	ld	s9,8(sp)
    }
  }
}
 738:	60e6                	ld	ra,88(sp)
 73a:	6446                	ld	s0,80(sp)
 73c:	64a6                	ld	s1,72(sp)
 73e:	6125                	addi	sp,sp,96
 740:	8082                	ret

0000000000000742 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 742:	715d                	addi	sp,sp,-80
 744:	ec06                	sd	ra,24(sp)
 746:	e822                	sd	s0,16(sp)
 748:	1000                	addi	s0,sp,32
 74a:	e010                	sd	a2,0(s0)
 74c:	e414                	sd	a3,8(s0)
 74e:	e818                	sd	a4,16(s0)
 750:	ec1c                	sd	a5,24(s0)
 752:	03043023          	sd	a6,32(s0)
 756:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75a:	8622                	mv	a2,s0
 75c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 760:	d5fff0ef          	jal	4be <vprintf>
}
 764:	60e2                	ld	ra,24(sp)
 766:	6442                	ld	s0,16(sp)
 768:	6161                	addi	sp,sp,80
 76a:	8082                	ret

000000000000076c <printf>:

void
printf(const char *fmt, ...)
{
 76c:	711d                	addi	sp,sp,-96
 76e:	ec06                	sd	ra,24(sp)
 770:	e822                	sd	s0,16(sp)
 772:	1000                	addi	s0,sp,32
 774:	e40c                	sd	a1,8(s0)
 776:	e810                	sd	a2,16(s0)
 778:	ec14                	sd	a3,24(s0)
 77a:	f018                	sd	a4,32(s0)
 77c:	f41c                	sd	a5,40(s0)
 77e:	03043823          	sd	a6,48(s0)
 782:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 786:	00840613          	addi	a2,s0,8
 78a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 78e:	85aa                	mv	a1,a0
 790:	4505                	li	a0,1
 792:	d2dff0ef          	jal	4be <vprintf>
}
 796:	60e2                	ld	ra,24(sp)
 798:	6442                	ld	s0,16(sp)
 79a:	6125                	addi	sp,sp,96
 79c:	8082                	ret

000000000000079e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79e:	1141                	addi	sp,sp,-16
 7a0:	e406                	sd	ra,8(sp)
 7a2:	e022                	sd	s0,0(sp)
 7a4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	00001797          	auipc	a5,0x1
 7ae:	8667b783          	ld	a5,-1946(a5) # 1010 <freep>
 7b2:	a02d                	j	7dc <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7b4:	4618                	lw	a4,8(a2)
 7b6:	9f2d                	addw	a4,a4,a1
 7b8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7bc:	6398                	ld	a4,0(a5)
 7be:	6310                	ld	a2,0(a4)
 7c0:	a83d                	j	7fe <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7c2:	ff852703          	lw	a4,-8(a0)
 7c6:	9f31                	addw	a4,a4,a2
 7c8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ca:	ff053683          	ld	a3,-16(a0)
 7ce:	a091                	j	812 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	6398                	ld	a4,0(a5)
 7d2:	00e7e463          	bltu	a5,a4,7da <free+0x3c>
 7d6:	00e6ea63          	bltu	a3,a4,7ea <free+0x4c>
{
 7da:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dc:	fed7fae3          	bgeu	a5,a3,7d0 <free+0x32>
 7e0:	6398                	ld	a4,0(a5)
 7e2:	00e6e463          	bltu	a3,a4,7ea <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e6:	fee7eae3          	bltu	a5,a4,7da <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7ea:	ff852583          	lw	a1,-8(a0)
 7ee:	6390                	ld	a2,0(a5)
 7f0:	02059813          	slli	a6,a1,0x20
 7f4:	01c85713          	srli	a4,a6,0x1c
 7f8:	9736                	add	a4,a4,a3
 7fa:	fae60de3          	beq	a2,a4,7b4 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7fe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 802:	4790                	lw	a2,8(a5)
 804:	02061593          	slli	a1,a2,0x20
 808:	01c5d713          	srli	a4,a1,0x1c
 80c:	973e                	add	a4,a4,a5
 80e:	fae68ae3          	beq	a3,a4,7c2 <free+0x24>
    p->s.ptr = bp->s.ptr;
 812:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 814:	00000717          	auipc	a4,0x0
 818:	7ef73e23          	sd	a5,2044(a4) # 1010 <freep>
}
 81c:	60a2                	ld	ra,8(sp)
 81e:	6402                	ld	s0,0(sp)
 820:	0141                	addi	sp,sp,16
 822:	8082                	ret

0000000000000824 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 824:	7139                	addi	sp,sp,-64
 826:	fc06                	sd	ra,56(sp)
 828:	f822                	sd	s0,48(sp)
 82a:	f04a                	sd	s2,32(sp)
 82c:	ec4e                	sd	s3,24(sp)
 82e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 830:	02051993          	slli	s3,a0,0x20
 834:	0209d993          	srli	s3,s3,0x20
 838:	09bd                	addi	s3,s3,15
 83a:	0049d993          	srli	s3,s3,0x4
 83e:	2985                	addiw	s3,s3,1
 840:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 842:	00000517          	auipc	a0,0x0
 846:	7ce53503          	ld	a0,1998(a0) # 1010 <freep>
 84a:	c905                	beqz	a0,87a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84e:	4798                	lw	a4,8(a5)
 850:	09377663          	bgeu	a4,s3,8dc <malloc+0xb8>
 854:	f426                	sd	s1,40(sp)
 856:	e852                	sd	s4,16(sp)
 858:	e456                	sd	s5,8(sp)
 85a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 85c:	8a4e                	mv	s4,s3
 85e:	6705                	lui	a4,0x1
 860:	00e9f363          	bgeu	s3,a4,866 <malloc+0x42>
 864:	6a05                	lui	s4,0x1
 866:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 86a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86e:	00000497          	auipc	s1,0x0
 872:	7a248493          	addi	s1,s1,1954 # 1010 <freep>
  if(p == (char*)-1)
 876:	5afd                	li	s5,-1
 878:	a83d                	j	8b6 <malloc+0x92>
 87a:	f426                	sd	s1,40(sp)
 87c:	e852                	sd	s4,16(sp)
 87e:	e456                	sd	s5,8(sp)
 880:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 882:	00000797          	auipc	a5,0x0
 886:	79e78793          	addi	a5,a5,1950 # 1020 <base>
 88a:	00000717          	auipc	a4,0x0
 88e:	78f73323          	sd	a5,1926(a4) # 1010 <freep>
 892:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 894:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 898:	b7d1                	j	85c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 89a:	6398                	ld	a4,0(a5)
 89c:	e118                	sd	a4,0(a0)
 89e:	a899                	j	8f4 <malloc+0xd0>
  hp->s.size = nu;
 8a0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a4:	0541                	addi	a0,a0,16
 8a6:	ef9ff0ef          	jal	79e <free>
  return freep;
 8aa:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8ac:	c125                	beqz	a0,90c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b0:	4798                	lw	a4,8(a5)
 8b2:	03277163          	bgeu	a4,s2,8d4 <malloc+0xb0>
    if(p == freep)
 8b6:	6098                	ld	a4,0(s1)
 8b8:	853e                	mv	a0,a5
 8ba:	fef71ae3          	bne	a4,a5,8ae <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8be:	8552                	mv	a0,s4
 8c0:	b23ff0ef          	jal	3e2 <sbrk>
  if(p == (char*)-1)
 8c4:	fd551ee3          	bne	a0,s5,8a0 <malloc+0x7c>
        return 0;
 8c8:	4501                	li	a0,0
 8ca:	74a2                	ld	s1,40(sp)
 8cc:	6a42                	ld	s4,16(sp)
 8ce:	6aa2                	ld	s5,8(sp)
 8d0:	6b02                	ld	s6,0(sp)
 8d2:	a03d                	j	900 <malloc+0xdc>
 8d4:	74a2                	ld	s1,40(sp)
 8d6:	6a42                	ld	s4,16(sp)
 8d8:	6aa2                	ld	s5,8(sp)
 8da:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8dc:	fae90fe3          	beq	s2,a4,89a <malloc+0x76>
        p->s.size -= nunits;
 8e0:	4137073b          	subw	a4,a4,s3
 8e4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e6:	02071693          	slli	a3,a4,0x20
 8ea:	01c6d713          	srli	a4,a3,0x1c
 8ee:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f4:	00000717          	auipc	a4,0x0
 8f8:	70a73e23          	sd	a0,1820(a4) # 1010 <freep>
      return (void*)(p + 1);
 8fc:	01078513          	addi	a0,a5,16
  }
}
 900:	70e2                	ld	ra,56(sp)
 902:	7442                	ld	s0,48(sp)
 904:	7902                	ld	s2,32(sp)
 906:	69e2                	ld	s3,24(sp)
 908:	6121                	addi	sp,sp,64
 90a:	8082                	ret
 90c:	74a2                	ld	s1,40(sp)
 90e:	6a42                	ld	s4,16(sp)
 910:	6aa2                	ld	s5,8(sp)
 912:	6b02                	ld	s6,0(sp)
 914:	b7f5                	j	900 <malloc+0xdc>
