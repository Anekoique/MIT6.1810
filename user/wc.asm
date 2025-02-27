
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
  36:	20000d13          	li	s10,512
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  3a:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  3c:	00001a17          	auipc	s4,0x1
  40:	984a0a13          	addi	s4,s4,-1660 # 9c0 <malloc+0xfc>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  44:	a035                	j	70 <wc+0x70>
      if(strchr(" \r\t\n\v", buf[i]))
  46:	8552                	mv	a0,s4
  48:	1ca000ef          	jal	212 <strchr>
  4c:	c919                	beqz	a0,62 <wc+0x62>
        inword = 0;
  4e:	4901                	li	s2,0
    for(i=0; i<n; i++){
  50:	0485                	addi	s1,s1,1
  52:	01348d63          	beq	s1,s3,6c <wc+0x6c>
      if(buf[i] == '\n')
  56:	0004c583          	lbu	a1,0(s1)
  5a:	ff5596e3          	bne	a1,s5,46 <wc+0x46>
        l++;
  5e:	2b85                	addiw	s7,s7,1
  60:	b7dd                	j	46 <wc+0x46>
      else if(!inword){
  62:	fe0917e3          	bnez	s2,50 <wc+0x50>
        w++;
  66:	2c05                	addiw	s8,s8,1
        inword = 1;
  68:	4905                	li	s2,1
  6a:	b7dd                	j	50 <wc+0x50>
  6c:	019b0cbb          	addw	s9,s6,s9
  while((n = read(fd, buf, sizeof(buf))) > 0){
  70:	866a                	mv	a2,s10
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	39a000ef          	jal	412 <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009b09b3          	add	s3,s6,s1
  8e:	b7e1                	j	56 <wc+0x56>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86e6                	mv	a3,s9
  9a:	8662                	mv	a2,s8
  9c:	85de                	mv	a1,s7
  9e:	00001517          	auipc	a0,0x1
  a2:	94250513          	addi	a0,a0,-1726 # 9e0 <malloc+0x11c>
  a6:	766000ef          	jal	80c <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	90850513          	addi	a0,a0,-1784 # 9d0 <malloc+0x10c>
  d0:	73c000ef          	jal	80c <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	324000ef          	jal	3fa <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	332000ef          	jal	43a <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	306000ef          	jal	422 <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	2d2000ef          	jal	3fa <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	89658593          	addi	a1,a1,-1898 # 9c8 <malloc+0x104>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2b8000ef          	jal	3fa <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	8a650513          	addi	a0,a0,-1882 # 9f0 <malloc+0x12c>
 152:	6ba000ef          	jal	80c <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	2a2000ef          	jal	3fa <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  extern int main();
  main();
 164:	f77ff0ef          	jal	da <main>
  exit(0);
 168:	4501                	li	a0,0
 16a:	290000ef          	jal	3fa <exit>

000000000000016e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 176:	87aa                	mv	a5,a0
 178:	0585                	addi	a1,a1,1
 17a:	0785                	addi	a5,a5,1
 17c:	fff5c703          	lbu	a4,-1(a1)
 180:	fee78fa3          	sb	a4,-1(a5)
 184:	fb75                	bnez	a4,178 <strcpy+0xa>
    ;
  return os;
}
 186:	60a2                	ld	ra,8(sp)
 188:	6402                	ld	s0,0(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret

000000000000018e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e406                	sd	ra,8(sp)
 192:	e022                	sd	s0,0(sp)
 194:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb91                	beqz	a5,1ae <strcmp+0x20>
 19c:	0005c703          	lbu	a4,0(a1)
 1a0:	00f71763          	bne	a4,a5,1ae <strcmp+0x20>
    p++, q++;
 1a4:	0505                	addi	a0,a0,1
 1a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	fbe5                	bnez	a5,19c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1ae:	0005c503          	lbu	a0,0(a1)
}
 1b2:	40a7853b          	subw	a0,a5,a0
 1b6:	60a2                	ld	ra,8(sp)
 1b8:	6402                	ld	s0,0(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret

00000000000001be <strlen>:

uint
strlen(const char *s)
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e406                	sd	ra,8(sp)
 1c2:	e022                	sd	s0,0(sp)
 1c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	cf99                	beqz	a5,1e8 <strlen+0x2a>
 1cc:	0505                	addi	a0,a0,1
 1ce:	87aa                	mv	a5,a0
 1d0:	86be                	mv	a3,a5
 1d2:	0785                	addi	a5,a5,1
 1d4:	fff7c703          	lbu	a4,-1(a5)
 1d8:	ff65                	bnez	a4,1d0 <strlen+0x12>
 1da:	40a6853b          	subw	a0,a3,a0
 1de:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1e0:	60a2                	ld	ra,8(sp)
 1e2:	6402                	ld	s0,0(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  for(n = 0; s[n]; n++)
 1e8:	4501                	li	a0,0
 1ea:	bfdd                	j	1e0 <strlen+0x22>

00000000000001ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e406                	sd	ra,8(sp)
 1f0:	e022                	sd	s0,0(sp)
 1f2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f4:	ca19                	beqz	a2,20a <memset+0x1e>
 1f6:	87aa                	mv	a5,a0
 1f8:	1602                	slli	a2,a2,0x20
 1fa:	9201                	srli	a2,a2,0x20
 1fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 200:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 204:	0785                	addi	a5,a5,1
 206:	fee79de3          	bne	a5,a4,200 <memset+0x14>
  }
  return dst;
}
 20a:	60a2                	ld	ra,8(sp)
 20c:	6402                	ld	s0,0(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret

0000000000000212 <strchr>:

char*
strchr(const char *s, char c)
{
 212:	1141                	addi	sp,sp,-16
 214:	e406                	sd	ra,8(sp)
 216:	e022                	sd	s0,0(sp)
 218:	0800                	addi	s0,sp,16
  for(; *s; s++)
 21a:	00054783          	lbu	a5,0(a0)
 21e:	cf81                	beqz	a5,236 <strchr+0x24>
    if(*s == c)
 220:	00f58763          	beq	a1,a5,22e <strchr+0x1c>
  for(; *s; s++)
 224:	0505                	addi	a0,a0,1
 226:	00054783          	lbu	a5,0(a0)
 22a:	fbfd                	bnez	a5,220 <strchr+0xe>
      return (char*)s;
  return 0;
 22c:	4501                	li	a0,0
}
 22e:	60a2                	ld	ra,8(sp)
 230:	6402                	ld	s0,0(sp)
 232:	0141                	addi	sp,sp,16
 234:	8082                	ret
  return 0;
 236:	4501                	li	a0,0
 238:	bfdd                	j	22e <strchr+0x1c>

000000000000023a <gets>:

char*
gets(char *buf, int max)
{
 23a:	7159                	addi	sp,sp,-112
 23c:	f486                	sd	ra,104(sp)
 23e:	f0a2                	sd	s0,96(sp)
 240:	eca6                	sd	s1,88(sp)
 242:	e8ca                	sd	s2,80(sp)
 244:	e4ce                	sd	s3,72(sp)
 246:	e0d2                	sd	s4,64(sp)
 248:	fc56                	sd	s5,56(sp)
 24a:	f85a                	sd	s6,48(sp)
 24c:	f45e                	sd	s7,40(sp)
 24e:	f062                	sd	s8,32(sp)
 250:	ec66                	sd	s9,24(sp)
 252:	e86a                	sd	s10,16(sp)
 254:	1880                	addi	s0,sp,112
 256:	8caa                	mv	s9,a0
 258:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25a:	892a                	mv	s2,a0
 25c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 25e:	f9f40b13          	addi	s6,s0,-97
 262:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 264:	4ba9                	li	s7,10
 266:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 268:	8d26                	mv	s10,s1
 26a:	0014899b          	addiw	s3,s1,1
 26e:	84ce                	mv	s1,s3
 270:	0349d563          	bge	s3,s4,29a <gets+0x60>
    cc = read(0, &c, 1);
 274:	8656                	mv	a2,s5
 276:	85da                	mv	a1,s6
 278:	4501                	li	a0,0
 27a:	198000ef          	jal	412 <read>
    if(cc < 1)
 27e:	00a05e63          	blez	a0,29a <gets+0x60>
    buf[i++] = c;
 282:	f9f44783          	lbu	a5,-97(s0)
 286:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 28a:	01778763          	beq	a5,s7,298 <gets+0x5e>
 28e:	0905                	addi	s2,s2,1
 290:	fd879ce3          	bne	a5,s8,268 <gets+0x2e>
    buf[i++] = c;
 294:	8d4e                	mv	s10,s3
 296:	a011                	j	29a <gets+0x60>
 298:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 29a:	9d66                	add	s10,s10,s9
 29c:	000d0023          	sb	zero,0(s10)
  return buf;
}
 2a0:	8566                	mv	a0,s9
 2a2:	70a6                	ld	ra,104(sp)
 2a4:	7406                	ld	s0,96(sp)
 2a6:	64e6                	ld	s1,88(sp)
 2a8:	6946                	ld	s2,80(sp)
 2aa:	69a6                	ld	s3,72(sp)
 2ac:	6a06                	ld	s4,64(sp)
 2ae:	7ae2                	ld	s5,56(sp)
 2b0:	7b42                	ld	s6,48(sp)
 2b2:	7ba2                	ld	s7,40(sp)
 2b4:	7c02                	ld	s8,32(sp)
 2b6:	6ce2                	ld	s9,24(sp)
 2b8:	6d42                	ld	s10,16(sp)
 2ba:	6165                	addi	sp,sp,112
 2bc:	8082                	ret

00000000000002be <stat>:

int
stat(const char *n, struct stat *st)
{
 2be:	1101                	addi	sp,sp,-32
 2c0:	ec06                	sd	ra,24(sp)
 2c2:	e822                	sd	s0,16(sp)
 2c4:	e04a                	sd	s2,0(sp)
 2c6:	1000                	addi	s0,sp,32
 2c8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ca:	4581                	li	a1,0
 2cc:	16e000ef          	jal	43a <open>
  if(fd < 0)
 2d0:	02054263          	bltz	a0,2f4 <stat+0x36>
 2d4:	e426                	sd	s1,8(sp)
 2d6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d8:	85ca                	mv	a1,s2
 2da:	178000ef          	jal	452 <fstat>
 2de:	892a                	mv	s2,a0
  close(fd);
 2e0:	8526                	mv	a0,s1
 2e2:	140000ef          	jal	422 <close>
  return r;
 2e6:	64a2                	ld	s1,8(sp)
}
 2e8:	854a                	mv	a0,s2
 2ea:	60e2                	ld	ra,24(sp)
 2ec:	6442                	ld	s0,16(sp)
 2ee:	6902                	ld	s2,0(sp)
 2f0:	6105                	addi	sp,sp,32
 2f2:	8082                	ret
    return -1;
 2f4:	597d                	li	s2,-1
 2f6:	bfcd                	j	2e8 <stat+0x2a>

00000000000002f8 <atoi>:

int
atoi(const char *s)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e406                	sd	ra,8(sp)
 2fc:	e022                	sd	s0,0(sp)
 2fe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 300:	00054683          	lbu	a3,0(a0)
 304:	fd06879b          	addiw	a5,a3,-48
 308:	0ff7f793          	zext.b	a5,a5
 30c:	4625                	li	a2,9
 30e:	02f66963          	bltu	a2,a5,340 <atoi+0x48>
 312:	872a                	mv	a4,a0
  n = 0;
 314:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 316:	0705                	addi	a4,a4,1
 318:	0025179b          	slliw	a5,a0,0x2
 31c:	9fa9                	addw	a5,a5,a0
 31e:	0017979b          	slliw	a5,a5,0x1
 322:	9fb5                	addw	a5,a5,a3
 324:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 328:	00074683          	lbu	a3,0(a4)
 32c:	fd06879b          	addiw	a5,a3,-48
 330:	0ff7f793          	zext.b	a5,a5
 334:	fef671e3          	bgeu	a2,a5,316 <atoi+0x1e>
  return n;
}
 338:	60a2                	ld	ra,8(sp)
 33a:	6402                	ld	s0,0(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret
  n = 0;
 340:	4501                	li	a0,0
 342:	bfdd                	j	338 <atoi+0x40>

0000000000000344 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34c:	02b57563          	bgeu	a0,a1,376 <memmove+0x32>
    while(n-- > 0)
 350:	00c05f63          	blez	a2,36e <memmove+0x2a>
 354:	1602                	slli	a2,a2,0x20
 356:	9201                	srli	a2,a2,0x20
 358:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 35c:	872a                	mv	a4,a0
      *dst++ = *src++;
 35e:	0585                	addi	a1,a1,1
 360:	0705                	addi	a4,a4,1
 362:	fff5c683          	lbu	a3,-1(a1)
 366:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 36a:	fee79ae3          	bne	a5,a4,35e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret
    dst += n;
 376:	00c50733          	add	a4,a0,a2
    src += n;
 37a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 37c:	fec059e3          	blez	a2,36e <memmove+0x2a>
 380:	fff6079b          	addiw	a5,a2,-1
 384:	1782                	slli	a5,a5,0x20
 386:	9381                	srli	a5,a5,0x20
 388:	fff7c793          	not	a5,a5
 38c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 38e:	15fd                	addi	a1,a1,-1
 390:	177d                	addi	a4,a4,-1
 392:	0005c683          	lbu	a3,0(a1)
 396:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 39a:	fef71ae3          	bne	a4,a5,38e <memmove+0x4a>
 39e:	bfc1                	j	36e <memmove+0x2a>

00000000000003a0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e406                	sd	ra,8(sp)
 3a4:	e022                	sd	s0,0(sp)
 3a6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a8:	ca0d                	beqz	a2,3da <memcmp+0x3a>
 3aa:	fff6069b          	addiw	a3,a2,-1
 3ae:	1682                	slli	a3,a3,0x20
 3b0:	9281                	srli	a3,a3,0x20
 3b2:	0685                	addi	a3,a3,1
 3b4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b6:	00054783          	lbu	a5,0(a0)
 3ba:	0005c703          	lbu	a4,0(a1)
 3be:	00e79863          	bne	a5,a4,3ce <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 3c2:	0505                	addi	a0,a0,1
    p2++;
 3c4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c6:	fed518e3          	bne	a0,a3,3b6 <memcmp+0x16>
  }
  return 0;
 3ca:	4501                	li	a0,0
 3cc:	a019                	j	3d2 <memcmp+0x32>
      return *p1 - *p2;
 3ce:	40e7853b          	subw	a0,a5,a4
}
 3d2:	60a2                	ld	ra,8(sp)
 3d4:	6402                	ld	s0,0(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret
  return 0;
 3da:	4501                	li	a0,0
 3dc:	bfdd                	j	3d2 <memcmp+0x32>

00000000000003de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e406                	sd	ra,8(sp)
 3e2:	e022                	sd	s0,0(sp)
 3e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e6:	f5fff0ef          	jal	344 <memmove>
}
 3ea:	60a2                	ld	ra,8(sp)
 3ec:	6402                	ld	s0,0(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret

00000000000003f2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f2:	4885                	li	a7,1
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3fa:	4889                	li	a7,2
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <wait>:
.global wait
wait:
 li a7, SYS_wait
 402:	488d                	li	a7,3
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 40a:	4891                	li	a7,4
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <read>:
.global read
read:
 li a7, SYS_read
 412:	4895                	li	a7,5
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <write>:
.global write
write:
 li a7, SYS_write
 41a:	48c1                	li	a7,16
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <close>:
.global close
close:
 li a7, SYS_close
 422:	48d5                	li	a7,21
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <kill>:
.global kill
kill:
 li a7, SYS_kill
 42a:	4899                	li	a7,6
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <exec>:
.global exec
exec:
 li a7, SYS_exec
 432:	489d                	li	a7,7
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <open>:
.global open
open:
 li a7, SYS_open
 43a:	48bd                	li	a7,15
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 442:	48c5                	li	a7,17
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 44a:	48c9                	li	a7,18
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 452:	48a1                	li	a7,8
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <link>:
.global link
link:
 li a7, SYS_link
 45a:	48cd                	li	a7,19
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 462:	48d1                	li	a7,20
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 46a:	48a5                	li	a7,9
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <dup>:
.global dup
dup:
 li a7, SYS_dup
 472:	48a9                	li	a7,10
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 47a:	48ad                	li	a7,11
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 482:	48b1                	li	a7,12
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 48a:	48b5                	li	a7,13
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 492:	48b9                	li	a7,14
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 49a:	48d9                	li	a7,22
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 4a2:	48dd                	li	a7,23
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4aa:	1101                	addi	sp,sp,-32
 4ac:	ec06                	sd	ra,24(sp)
 4ae:	e822                	sd	s0,16(sp)
 4b0:	1000                	addi	s0,sp,32
 4b2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4b6:	4605                	li	a2,1
 4b8:	fef40593          	addi	a1,s0,-17
 4bc:	f5fff0ef          	jal	41a <write>
}
 4c0:	60e2                	ld	ra,24(sp)
 4c2:	6442                	ld	s0,16(sp)
 4c4:	6105                	addi	sp,sp,32
 4c6:	8082                	ret

00000000000004c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c8:	7139                	addi	sp,sp,-64
 4ca:	fc06                	sd	ra,56(sp)
 4cc:	f822                	sd	s0,48(sp)
 4ce:	f426                	sd	s1,40(sp)
 4d0:	f04a                	sd	s2,32(sp)
 4d2:	ec4e                	sd	s3,24(sp)
 4d4:	0080                	addi	s0,sp,64
 4d6:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d8:	c299                	beqz	a3,4de <printint+0x16>
 4da:	0605ce63          	bltz	a1,556 <printint+0x8e>
  neg = 0;
 4de:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4e0:	fc040313          	addi	t1,s0,-64
  neg = 0;
 4e4:	869a                	mv	a3,t1
  i = 0;
 4e6:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4e8:	00000817          	auipc	a6,0x0
 4ec:	52880813          	addi	a6,a6,1320 # a10 <digits>
 4f0:	88be                	mv	a7,a5
 4f2:	0017851b          	addiw	a0,a5,1
 4f6:	87aa                	mv	a5,a0
 4f8:	02c5f73b          	remuw	a4,a1,a2
 4fc:	1702                	slli	a4,a4,0x20
 4fe:	9301                	srli	a4,a4,0x20
 500:	9742                	add	a4,a4,a6
 502:	00074703          	lbu	a4,0(a4)
 506:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 50a:	872e                	mv	a4,a1
 50c:	02c5d5bb          	divuw	a1,a1,a2
 510:	0685                	addi	a3,a3,1
 512:	fcc77fe3          	bgeu	a4,a2,4f0 <printint+0x28>
  if(neg)
 516:	000e0c63          	beqz	t3,52e <printint+0x66>
    buf[i++] = '-';
 51a:	fd050793          	addi	a5,a0,-48
 51e:	00878533          	add	a0,a5,s0
 522:	02d00793          	li	a5,45
 526:	fef50823          	sb	a5,-16(a0)
 52a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 52e:	fff7899b          	addiw	s3,a5,-1
 532:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 536:	fff4c583          	lbu	a1,-1(s1)
 53a:	854a                	mv	a0,s2
 53c:	f6fff0ef          	jal	4aa <putc>
  while(--i >= 0)
 540:	39fd                	addiw	s3,s3,-1
 542:	14fd                	addi	s1,s1,-1
 544:	fe09d9e3          	bgez	s3,536 <printint+0x6e>
}
 548:	70e2                	ld	ra,56(sp)
 54a:	7442                	ld	s0,48(sp)
 54c:	74a2                	ld	s1,40(sp)
 54e:	7902                	ld	s2,32(sp)
 550:	69e2                	ld	s3,24(sp)
 552:	6121                	addi	sp,sp,64
 554:	8082                	ret
    x = -xx;
 556:	40b005bb          	negw	a1,a1
    neg = 1;
 55a:	4e05                	li	t3,1
    x = -xx;
 55c:	b751                	j	4e0 <printint+0x18>

000000000000055e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 55e:	711d                	addi	sp,sp,-96
 560:	ec86                	sd	ra,88(sp)
 562:	e8a2                	sd	s0,80(sp)
 564:	e4a6                	sd	s1,72(sp)
 566:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 568:	0005c483          	lbu	s1,0(a1)
 56c:	26048663          	beqz	s1,7d8 <vprintf+0x27a>
 570:	e0ca                	sd	s2,64(sp)
 572:	fc4e                	sd	s3,56(sp)
 574:	f852                	sd	s4,48(sp)
 576:	f456                	sd	s5,40(sp)
 578:	f05a                	sd	s6,32(sp)
 57a:	ec5e                	sd	s7,24(sp)
 57c:	e862                	sd	s8,16(sp)
 57e:	e466                	sd	s9,8(sp)
 580:	8b2a                	mv	s6,a0
 582:	8a2e                	mv	s4,a1
 584:	8bb2                	mv	s7,a2
  state = 0;
 586:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 588:	4901                	li	s2,0
 58a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 58c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 590:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 594:	06c00c93          	li	s9,108
 598:	a00d                	j	5ba <vprintf+0x5c>
        putc(fd, c0);
 59a:	85a6                	mv	a1,s1
 59c:	855a                	mv	a0,s6
 59e:	f0dff0ef          	jal	4aa <putc>
 5a2:	a019                	j	5a8 <vprintf+0x4a>
    } else if(state == '%'){
 5a4:	03598363          	beq	s3,s5,5ca <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 5a8:	0019079b          	addiw	a5,s2,1
 5ac:	893e                	mv	s2,a5
 5ae:	873e                	mv	a4,a5
 5b0:	97d2                	add	a5,a5,s4
 5b2:	0007c483          	lbu	s1,0(a5)
 5b6:	20048963          	beqz	s1,7c8 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 5ba:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5be:	fe0993e3          	bnez	s3,5a4 <vprintf+0x46>
      if(c0 == '%'){
 5c2:	fd579ce3          	bne	a5,s5,59a <vprintf+0x3c>
        state = '%';
 5c6:	89be                	mv	s3,a5
 5c8:	b7c5                	j	5a8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5ca:	00ea06b3          	add	a3,s4,a4
 5ce:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5d2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5d4:	c681                	beqz	a3,5dc <vprintf+0x7e>
 5d6:	9752                	add	a4,a4,s4
 5d8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5dc:	03878e63          	beq	a5,s8,618 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5e0:	05978863          	beq	a5,s9,630 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5e4:	07500713          	li	a4,117
 5e8:	0ee78263          	beq	a5,a4,6cc <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5ec:	07800713          	li	a4,120
 5f0:	12e78463          	beq	a5,a4,718 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5f4:	07000713          	li	a4,112
 5f8:	14e78963          	beq	a5,a4,74a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5fc:	07300713          	li	a4,115
 600:	18e78863          	beq	a5,a4,790 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 604:	02500713          	li	a4,37
 608:	04e79463          	bne	a5,a4,650 <vprintf+0xf2>
        putc(fd, '%');
 60c:	85ba                	mv	a1,a4
 60e:	855a                	mv	a0,s6
 610:	e9bff0ef          	jal	4aa <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 614:	4981                	li	s3,0
 616:	bf49                	j	5a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 618:	008b8493          	addi	s1,s7,8
 61c:	4685                	li	a3,1
 61e:	4629                	li	a2,10
 620:	000ba583          	lw	a1,0(s7)
 624:	855a                	mv	a0,s6
 626:	ea3ff0ef          	jal	4c8 <printint>
 62a:	8ba6                	mv	s7,s1
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bfad                	j	5a8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 630:	06400793          	li	a5,100
 634:	02f68963          	beq	a3,a5,666 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 638:	06c00793          	li	a5,108
 63c:	04f68263          	beq	a3,a5,680 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 640:	07500793          	li	a5,117
 644:	0af68063          	beq	a3,a5,6e4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 648:	07800793          	li	a5,120
 64c:	0ef68263          	beq	a3,a5,730 <vprintf+0x1d2>
        putc(fd, '%');
 650:	02500593          	li	a1,37
 654:	855a                	mv	a0,s6
 656:	e55ff0ef          	jal	4aa <putc>
        putc(fd, c0);
 65a:	85a6                	mv	a1,s1
 65c:	855a                	mv	a0,s6
 65e:	e4dff0ef          	jal	4aa <putc>
      state = 0;
 662:	4981                	li	s3,0
 664:	b791                	j	5a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 666:	008b8493          	addi	s1,s7,8
 66a:	4685                	li	a3,1
 66c:	4629                	li	a2,10
 66e:	000ba583          	lw	a1,0(s7)
 672:	855a                	mv	a0,s6
 674:	e55ff0ef          	jal	4c8 <printint>
        i += 1;
 678:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 67a:	8ba6                	mv	s7,s1
      state = 0;
 67c:	4981                	li	s3,0
        i += 1;
 67e:	b72d                	j	5a8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 680:	06400793          	li	a5,100
 684:	02f60763          	beq	a2,a5,6b2 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 688:	07500793          	li	a5,117
 68c:	06f60963          	beq	a2,a5,6fe <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 690:	07800793          	li	a5,120
 694:	faf61ee3          	bne	a2,a5,650 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 698:	008b8493          	addi	s1,s7,8
 69c:	4681                	li	a3,0
 69e:	4641                	li	a2,16
 6a0:	000ba583          	lw	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	e23ff0ef          	jal	4c8 <printint>
        i += 2;
 6aa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ac:	8ba6                	mv	s7,s1
      state = 0;
 6ae:	4981                	li	s3,0
        i += 2;
 6b0:	bde5                	j	5a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b2:	008b8493          	addi	s1,s7,8
 6b6:	4685                	li	a3,1
 6b8:	4629                	li	a2,10
 6ba:	000ba583          	lw	a1,0(s7)
 6be:	855a                	mv	a0,s6
 6c0:	e09ff0ef          	jal	4c8 <printint>
        i += 2;
 6c4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c6:	8ba6                	mv	s7,s1
      state = 0;
 6c8:	4981                	li	s3,0
        i += 2;
 6ca:	bdf9                	j	5a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6cc:	008b8493          	addi	s1,s7,8
 6d0:	4681                	li	a3,0
 6d2:	4629                	li	a2,10
 6d4:	000ba583          	lw	a1,0(s7)
 6d8:	855a                	mv	a0,s6
 6da:	defff0ef          	jal	4c8 <printint>
 6de:	8ba6                	mv	s7,s1
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b5d9                	j	5a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e4:	008b8493          	addi	s1,s7,8
 6e8:	4681                	li	a3,0
 6ea:	4629                	li	a2,10
 6ec:	000ba583          	lw	a1,0(s7)
 6f0:	855a                	mv	a0,s6
 6f2:	dd7ff0ef          	jal	4c8 <printint>
        i += 1;
 6f6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f8:	8ba6                	mv	s7,s1
      state = 0;
 6fa:	4981                	li	s3,0
        i += 1;
 6fc:	b575                	j	5a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fe:	008b8493          	addi	s1,s7,8
 702:	4681                	li	a3,0
 704:	4629                	li	a2,10
 706:	000ba583          	lw	a1,0(s7)
 70a:	855a                	mv	a0,s6
 70c:	dbdff0ef          	jal	4c8 <printint>
        i += 2;
 710:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 712:	8ba6                	mv	s7,s1
      state = 0;
 714:	4981                	li	s3,0
        i += 2;
 716:	bd49                	j	5a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 718:	008b8493          	addi	s1,s7,8
 71c:	4681                	li	a3,0
 71e:	4641                	li	a2,16
 720:	000ba583          	lw	a1,0(s7)
 724:	855a                	mv	a0,s6
 726:	da3ff0ef          	jal	4c8 <printint>
 72a:	8ba6                	mv	s7,s1
      state = 0;
 72c:	4981                	li	s3,0
 72e:	bdad                	j	5a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 730:	008b8493          	addi	s1,s7,8
 734:	4681                	li	a3,0
 736:	4641                	li	a2,16
 738:	000ba583          	lw	a1,0(s7)
 73c:	855a                	mv	a0,s6
 73e:	d8bff0ef          	jal	4c8 <printint>
        i += 1;
 742:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 744:	8ba6                	mv	s7,s1
      state = 0;
 746:	4981                	li	s3,0
        i += 1;
 748:	b585                	j	5a8 <vprintf+0x4a>
 74a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 74c:	008b8d13          	addi	s10,s7,8
 750:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 754:	03000593          	li	a1,48
 758:	855a                	mv	a0,s6
 75a:	d51ff0ef          	jal	4aa <putc>
  putc(fd, 'x');
 75e:	07800593          	li	a1,120
 762:	855a                	mv	a0,s6
 764:	d47ff0ef          	jal	4aa <putc>
 768:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 76a:	00000b97          	auipc	s7,0x0
 76e:	2a6b8b93          	addi	s7,s7,678 # a10 <digits>
 772:	03c9d793          	srli	a5,s3,0x3c
 776:	97de                	add	a5,a5,s7
 778:	0007c583          	lbu	a1,0(a5)
 77c:	855a                	mv	a0,s6
 77e:	d2dff0ef          	jal	4aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 782:	0992                	slli	s3,s3,0x4
 784:	34fd                	addiw	s1,s1,-1
 786:	f4f5                	bnez	s1,772 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 788:	8bea                	mv	s7,s10
      state = 0;
 78a:	4981                	li	s3,0
 78c:	6d02                	ld	s10,0(sp)
 78e:	bd29                	j	5a8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 790:	008b8993          	addi	s3,s7,8
 794:	000bb483          	ld	s1,0(s7)
 798:	cc91                	beqz	s1,7b4 <vprintf+0x256>
        for(; *s; s++)
 79a:	0004c583          	lbu	a1,0(s1)
 79e:	c195                	beqz	a1,7c2 <vprintf+0x264>
          putc(fd, *s);
 7a0:	855a                	mv	a0,s6
 7a2:	d09ff0ef          	jal	4aa <putc>
        for(; *s; s++)
 7a6:	0485                	addi	s1,s1,1
 7a8:	0004c583          	lbu	a1,0(s1)
 7ac:	f9f5                	bnez	a1,7a0 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 7ae:	8bce                	mv	s7,s3
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	bbdd                	j	5a8 <vprintf+0x4a>
          s = "(null)";
 7b4:	00000497          	auipc	s1,0x0
 7b8:	25448493          	addi	s1,s1,596 # a08 <malloc+0x144>
        for(; *s; s++)
 7bc:	02800593          	li	a1,40
 7c0:	b7c5                	j	7a0 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 7c2:	8bce                	mv	s7,s3
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	b3cd                	j	5a8 <vprintf+0x4a>
 7c8:	6906                	ld	s2,64(sp)
 7ca:	79e2                	ld	s3,56(sp)
 7cc:	7a42                	ld	s4,48(sp)
 7ce:	7aa2                	ld	s5,40(sp)
 7d0:	7b02                	ld	s6,32(sp)
 7d2:	6be2                	ld	s7,24(sp)
 7d4:	6c42                	ld	s8,16(sp)
 7d6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7d8:	60e6                	ld	ra,88(sp)
 7da:	6446                	ld	s0,80(sp)
 7dc:	64a6                	ld	s1,72(sp)
 7de:	6125                	addi	sp,sp,96
 7e0:	8082                	ret

00000000000007e2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e2:	715d                	addi	sp,sp,-80
 7e4:	ec06                	sd	ra,24(sp)
 7e6:	e822                	sd	s0,16(sp)
 7e8:	1000                	addi	s0,sp,32
 7ea:	e010                	sd	a2,0(s0)
 7ec:	e414                	sd	a3,8(s0)
 7ee:	e818                	sd	a4,16(s0)
 7f0:	ec1c                	sd	a5,24(s0)
 7f2:	03043023          	sd	a6,32(s0)
 7f6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7fa:	8622                	mv	a2,s0
 7fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 800:	d5fff0ef          	jal	55e <vprintf>
}
 804:	60e2                	ld	ra,24(sp)
 806:	6442                	ld	s0,16(sp)
 808:	6161                	addi	sp,sp,80
 80a:	8082                	ret

000000000000080c <printf>:

void
printf(const char *fmt, ...)
{
 80c:	711d                	addi	sp,sp,-96
 80e:	ec06                	sd	ra,24(sp)
 810:	e822                	sd	s0,16(sp)
 812:	1000                	addi	s0,sp,32
 814:	e40c                	sd	a1,8(s0)
 816:	e810                	sd	a2,16(s0)
 818:	ec14                	sd	a3,24(s0)
 81a:	f018                	sd	a4,32(s0)
 81c:	f41c                	sd	a5,40(s0)
 81e:	03043823          	sd	a6,48(s0)
 822:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 826:	00840613          	addi	a2,s0,8
 82a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 82e:	85aa                	mv	a1,a0
 830:	4505                	li	a0,1
 832:	d2dff0ef          	jal	55e <vprintf>
}
 836:	60e2                	ld	ra,24(sp)
 838:	6442                	ld	s0,16(sp)
 83a:	6125                	addi	sp,sp,96
 83c:	8082                	ret

000000000000083e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83e:	1141                	addi	sp,sp,-16
 840:	e406                	sd	ra,8(sp)
 842:	e022                	sd	s0,0(sp)
 844:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 846:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84a:	00000797          	auipc	a5,0x0
 84e:	7b67b783          	ld	a5,1974(a5) # 1000 <freep>
 852:	a02d                	j	87c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 854:	4618                	lw	a4,8(a2)
 856:	9f2d                	addw	a4,a4,a1
 858:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 85c:	6398                	ld	a4,0(a5)
 85e:	6310                	ld	a2,0(a4)
 860:	a83d                	j	89e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 862:	ff852703          	lw	a4,-8(a0)
 866:	9f31                	addw	a4,a4,a2
 868:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 86a:	ff053683          	ld	a3,-16(a0)
 86e:	a091                	j	8b2 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 870:	6398                	ld	a4,0(a5)
 872:	00e7e463          	bltu	a5,a4,87a <free+0x3c>
 876:	00e6ea63          	bltu	a3,a4,88a <free+0x4c>
{
 87a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87c:	fed7fae3          	bgeu	a5,a3,870 <free+0x32>
 880:	6398                	ld	a4,0(a5)
 882:	00e6e463          	bltu	a3,a4,88a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 886:	fee7eae3          	bltu	a5,a4,87a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 88a:	ff852583          	lw	a1,-8(a0)
 88e:	6390                	ld	a2,0(a5)
 890:	02059813          	slli	a6,a1,0x20
 894:	01c85713          	srli	a4,a6,0x1c
 898:	9736                	add	a4,a4,a3
 89a:	fae60de3          	beq	a2,a4,854 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 89e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8a2:	4790                	lw	a2,8(a5)
 8a4:	02061593          	slli	a1,a2,0x20
 8a8:	01c5d713          	srli	a4,a1,0x1c
 8ac:	973e                	add	a4,a4,a5
 8ae:	fae68ae3          	beq	a3,a4,862 <free+0x24>
    p->s.ptr = bp->s.ptr;
 8b2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8b4:	00000717          	auipc	a4,0x0
 8b8:	74f73623          	sd	a5,1868(a4) # 1000 <freep>
}
 8bc:	60a2                	ld	ra,8(sp)
 8be:	6402                	ld	s0,0(sp)
 8c0:	0141                	addi	sp,sp,16
 8c2:	8082                	ret

00000000000008c4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c4:	7139                	addi	sp,sp,-64
 8c6:	fc06                	sd	ra,56(sp)
 8c8:	f822                	sd	s0,48(sp)
 8ca:	f04a                	sd	s2,32(sp)
 8cc:	ec4e                	sd	s3,24(sp)
 8ce:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d0:	02051993          	slli	s3,a0,0x20
 8d4:	0209d993          	srli	s3,s3,0x20
 8d8:	09bd                	addi	s3,s3,15
 8da:	0049d993          	srli	s3,s3,0x4
 8de:	2985                	addiw	s3,s3,1
 8e0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8e2:	00000517          	auipc	a0,0x0
 8e6:	71e53503          	ld	a0,1822(a0) # 1000 <freep>
 8ea:	c905                	beqz	a0,91a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ee:	4798                	lw	a4,8(a5)
 8f0:	09377663          	bgeu	a4,s3,97c <malloc+0xb8>
 8f4:	f426                	sd	s1,40(sp)
 8f6:	e852                	sd	s4,16(sp)
 8f8:	e456                	sd	s5,8(sp)
 8fa:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8fc:	8a4e                	mv	s4,s3
 8fe:	6705                	lui	a4,0x1
 900:	00e9f363          	bgeu	s3,a4,906 <malloc+0x42>
 904:	6a05                	lui	s4,0x1
 906:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 90a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 90e:	00000497          	auipc	s1,0x0
 912:	6f248493          	addi	s1,s1,1778 # 1000 <freep>
  if(p == (char*)-1)
 916:	5afd                	li	s5,-1
 918:	a83d                	j	956 <malloc+0x92>
 91a:	f426                	sd	s1,40(sp)
 91c:	e852                	sd	s4,16(sp)
 91e:	e456                	sd	s5,8(sp)
 920:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 922:	00001797          	auipc	a5,0x1
 926:	8ee78793          	addi	a5,a5,-1810 # 1210 <base>
 92a:	00000717          	auipc	a4,0x0
 92e:	6cf73b23          	sd	a5,1750(a4) # 1000 <freep>
 932:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 934:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 938:	b7d1                	j	8fc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 93a:	6398                	ld	a4,0(a5)
 93c:	e118                	sd	a4,0(a0)
 93e:	a899                	j	994 <malloc+0xd0>
  hp->s.size = nu;
 940:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 944:	0541                	addi	a0,a0,16
 946:	ef9ff0ef          	jal	83e <free>
  return freep;
 94a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 94c:	c125                	beqz	a0,9ac <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 950:	4798                	lw	a4,8(a5)
 952:	03277163          	bgeu	a4,s2,974 <malloc+0xb0>
    if(p == freep)
 956:	6098                	ld	a4,0(s1)
 958:	853e                	mv	a0,a5
 95a:	fef71ae3          	bne	a4,a5,94e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 95e:	8552                	mv	a0,s4
 960:	b23ff0ef          	jal	482 <sbrk>
  if(p == (char*)-1)
 964:	fd551ee3          	bne	a0,s5,940 <malloc+0x7c>
        return 0;
 968:	4501                	li	a0,0
 96a:	74a2                	ld	s1,40(sp)
 96c:	6a42                	ld	s4,16(sp)
 96e:	6aa2                	ld	s5,8(sp)
 970:	6b02                	ld	s6,0(sp)
 972:	a03d                	j	9a0 <malloc+0xdc>
 974:	74a2                	ld	s1,40(sp)
 976:	6a42                	ld	s4,16(sp)
 978:	6aa2                	ld	s5,8(sp)
 97a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 97c:	fae90fe3          	beq	s2,a4,93a <malloc+0x76>
        p->s.size -= nunits;
 980:	4137073b          	subw	a4,a4,s3
 984:	c798                	sw	a4,8(a5)
        p += p->s.size;
 986:	02071693          	slli	a3,a4,0x20
 98a:	01c6d713          	srli	a4,a3,0x1c
 98e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 990:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 994:	00000717          	auipc	a4,0x0
 998:	66a73623          	sd	a0,1644(a4) # 1000 <freep>
      return (void*)(p + 1);
 99c:	01078513          	addi	a0,a5,16
  }
}
 9a0:	70e2                	ld	ra,56(sp)
 9a2:	7442                	ld	s0,48(sp)
 9a4:	7902                	ld	s2,32(sp)
 9a6:	69e2                	ld	s3,24(sp)
 9a8:	6121                	addi	sp,sp,64
 9aa:	8082                	ret
 9ac:	74a2                	ld	s1,40(sp)
 9ae:	6a42                	ld	s4,16(sp)
 9b0:	6aa2                	ld	s5,8(sp)
 9b2:	6b02                	ld	s6,0(sp)
 9b4:	b7f5                	j	9a0 <malloc+0xdc>
