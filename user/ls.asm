
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2de000ef          	jal	2ea <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	2b6000ef          	jal	2ea <strlen>
  38:	47b5                	li	a5,13
  3a:	00a7f863          	bgeu	a5,a0,4a <fmtname+0x4a>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  3e:	8526                	mv	a0,s1
  40:	70a2                	ld	ra,40(sp)
  42:	7402                	ld	s0,32(sp)
  44:	64e2                	ld	s1,24(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret
  4a:	e84a                	sd	s2,16(sp)
  4c:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  4e:	8526                	mv	a0,s1
  50:	29a000ef          	jal	2ea <strlen>
  54:	862a                	mv	a2,a0
  56:	00002997          	auipc	s3,0x2
  5a:	fba98993          	addi	s3,s3,-70 # 2010 <buf.0>
  5e:	85a6                	mv	a1,s1
  60:	854e                	mv	a0,s3
  62:	40e000ef          	jal	470 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  66:	8526                	mv	a0,s1
  68:	282000ef          	jal	2ea <strlen>
  6c:	892a                	mv	s2,a0
  6e:	8526                	mv	a0,s1
  70:	27a000ef          	jal	2ea <strlen>
  74:	1902                	slli	s2,s2,0x20
  76:	02095913          	srli	s2,s2,0x20
  7a:	4639                	li	a2,14
  7c:	9e09                	subw	a2,a2,a0
  7e:	02000593          	li	a1,32
  82:	01298533          	add	a0,s3,s2
  86:	292000ef          	jal	318 <memset>
  return buf;
  8a:	84ce                	mv	s1,s3
  8c:	6942                	ld	s2,16(sp)
  8e:	69a2                	ld	s3,8(sp)
  90:	b77d                	j	3e <fmtname+0x3e>

0000000000000092 <ls>:

void
ls(char *path)
{
  92:	d7010113          	addi	sp,sp,-656
  96:	28113423          	sd	ra,648(sp)
  9a:	28813023          	sd	s0,640(sp)
  9e:	27213823          	sd	s2,624(sp)
  a2:	0d00                	addi	s0,sp,656
  a4:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  a6:	4581                	li	a1,0
  a8:	4be000ef          	jal	566 <open>
  ac:	06054363          	bltz	a0,112 <ls+0x80>
  b0:	26913c23          	sd	s1,632(sp)
  b4:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  b6:	d7840593          	addi	a1,s0,-648
  ba:	4c4000ef          	jal	57e <fstat>
  be:	06054363          	bltz	a0,124 <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c2:	d8041783          	lh	a5,-640(s0)
  c6:	4705                	li	a4,1
  c8:	06e78c63          	beq	a5,a4,140 <ls+0xae>
  cc:	37f9                	addiw	a5,a5,-2
  ce:	17c2                	slli	a5,a5,0x30
  d0:	93c1                	srli	a5,a5,0x30
  d2:	02f76263          	bltu	a4,a5,f6 <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  d6:	854a                	mv	a0,s2
  d8:	f29ff0ef          	jal	0 <fmtname>
  dc:	85aa                	mv	a1,a0
  de:	d8842703          	lw	a4,-632(s0)
  e2:	d7c42683          	lw	a3,-644(s0)
  e6:	d8041603          	lh	a2,-640(s0)
  ea:	00001517          	auipc	a0,0x1
  ee:	a3650513          	addi	a0,a0,-1482 # b20 <malloc+0x130>
  f2:	047000ef          	jal	938 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  f6:	8526                	mv	a0,s1
  f8:	456000ef          	jal	54e <close>
  fc:	27813483          	ld	s1,632(sp)
}
 100:	28813083          	ld	ra,648(sp)
 104:	28013403          	ld	s0,640(sp)
 108:	27013903          	ld	s2,624(sp)
 10c:	29010113          	addi	sp,sp,656
 110:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 112:	864a                	mv	a2,s2
 114:	00001597          	auipc	a1,0x1
 118:	9dc58593          	addi	a1,a1,-1572 # af0 <malloc+0x100>
 11c:	4509                	li	a0,2
 11e:	7f0000ef          	jal	90e <fprintf>
    return;
 122:	bff9                	j	100 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 124:	864a                	mv	a2,s2
 126:	00001597          	auipc	a1,0x1
 12a:	9e258593          	addi	a1,a1,-1566 # b08 <malloc+0x118>
 12e:	4509                	li	a0,2
 130:	7de000ef          	jal	90e <fprintf>
    close(fd);
 134:	8526                	mv	a0,s1
 136:	418000ef          	jal	54e <close>
    return;
 13a:	27813483          	ld	s1,632(sp)
 13e:	b7c9                	j	100 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 140:	854a                	mv	a0,s2
 142:	1a8000ef          	jal	2ea <strlen>
 146:	2541                	addiw	a0,a0,16
 148:	20000793          	li	a5,512
 14c:	00a7f963          	bgeu	a5,a0,15e <ls+0xcc>
      printf("ls: path too long\n");
 150:	00001517          	auipc	a0,0x1
 154:	9e050513          	addi	a0,a0,-1568 # b30 <malloc+0x140>
 158:	7e0000ef          	jal	938 <printf>
      break;
 15c:	bf69                	j	f6 <ls+0x64>
 15e:	27313423          	sd	s3,616(sp)
 162:	27413023          	sd	s4,608(sp)
 166:	25513c23          	sd	s5,600(sp)
 16a:	25613823          	sd	s6,592(sp)
 16e:	25713423          	sd	s7,584(sp)
 172:	25813023          	sd	s8,576(sp)
 176:	23913c23          	sd	s9,568(sp)
 17a:	23a13823          	sd	s10,560(sp)
    strcpy(buf, path);
 17e:	da040993          	addi	s3,s0,-608
 182:	85ca                	mv	a1,s2
 184:	854e                	mv	a0,s3
 186:	114000ef          	jal	29a <strcpy>
    p = buf+strlen(buf);
 18a:	854e                	mv	a0,s3
 18c:	15e000ef          	jal	2ea <strlen>
 190:	1502                	slli	a0,a0,0x20
 192:	9101                	srli	a0,a0,0x20
 194:	99aa                	add	s3,s3,a0
    *p++ = '/';
 196:	00198c93          	addi	s9,s3,1
 19a:	02f00793          	li	a5,47
 19e:	00f98023          	sb	a5,0(s3)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a2:	d9040a13          	addi	s4,s0,-624
 1a6:	4941                	li	s2,16
      memmove(p, de.name, DIRSIZ);
 1a8:	d9240c13          	addi	s8,s0,-622
 1ac:	4bb9                	li	s7,14
      if(stat(buf, &st) < 0){
 1ae:	d7840b13          	addi	s6,s0,-648
 1b2:	da040a93          	addi	s5,s0,-608
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1b6:	00001d17          	auipc	s10,0x1
 1ba:	96ad0d13          	addi	s10,s10,-1686 # b20 <malloc+0x130>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1be:	a801                	j	1ce <ls+0x13c>
        printf("ls: cannot stat %s\n", buf);
 1c0:	85d6                	mv	a1,s5
 1c2:	00001517          	auipc	a0,0x1
 1c6:	94650513          	addi	a0,a0,-1722 # b08 <malloc+0x118>
 1ca:	76e000ef          	jal	938 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1ce:	864a                	mv	a2,s2
 1d0:	85d2                	mv	a1,s4
 1d2:	8526                	mv	a0,s1
 1d4:	36a000ef          	jal	53e <read>
 1d8:	05251063          	bne	a0,s2,218 <ls+0x186>
      if(de.inum == 0)
 1dc:	d9045783          	lhu	a5,-624(s0)
 1e0:	d7fd                	beqz	a5,1ce <ls+0x13c>
      memmove(p, de.name, DIRSIZ);
 1e2:	865e                	mv	a2,s7
 1e4:	85e2                	mv	a1,s8
 1e6:	8566                	mv	a0,s9
 1e8:	288000ef          	jal	470 <memmove>
      p[DIRSIZ] = 0;
 1ec:	000987a3          	sb	zero,15(s3)
      if(stat(buf, &st) < 0){
 1f0:	85da                	mv	a1,s6
 1f2:	8556                	mv	a0,s5
 1f4:	1f6000ef          	jal	3ea <stat>
 1f8:	fc0544e3          	bltz	a0,1c0 <ls+0x12e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1fc:	8556                	mv	a0,s5
 1fe:	e03ff0ef          	jal	0 <fmtname>
 202:	85aa                	mv	a1,a0
 204:	d8842703          	lw	a4,-632(s0)
 208:	d7c42683          	lw	a3,-644(s0)
 20c:	d8041603          	lh	a2,-640(s0)
 210:	856a                	mv	a0,s10
 212:	726000ef          	jal	938 <printf>
 216:	bf65                	j	1ce <ls+0x13c>
 218:	26813983          	ld	s3,616(sp)
 21c:	26013a03          	ld	s4,608(sp)
 220:	25813a83          	ld	s5,600(sp)
 224:	25013b03          	ld	s6,592(sp)
 228:	24813b83          	ld	s7,584(sp)
 22c:	24013c03          	ld	s8,576(sp)
 230:	23813c83          	ld	s9,568(sp)
 234:	23013d03          	ld	s10,560(sp)
 238:	bd7d                	j	f6 <ls+0x64>

000000000000023a <main>:

int
main(int argc, char *argv[])
{
 23a:	1101                	addi	sp,sp,-32
 23c:	ec06                	sd	ra,24(sp)
 23e:	e822                	sd	s0,16(sp)
 240:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 242:	4785                	li	a5,1
 244:	02a7d763          	bge	a5,a0,272 <main+0x38>
 248:	e426                	sd	s1,8(sp)
 24a:	e04a                	sd	s2,0(sp)
 24c:	00858493          	addi	s1,a1,8
 250:	ffe5091b          	addiw	s2,a0,-2
 254:	02091793          	slli	a5,s2,0x20
 258:	01d7d913          	srli	s2,a5,0x1d
 25c:	05c1                	addi	a1,a1,16
 25e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 260:	6088                	ld	a0,0(s1)
 262:	e31ff0ef          	jal	92 <ls>
  for(i=1; i<argc; i++)
 266:	04a1                	addi	s1,s1,8
 268:	ff249ce3          	bne	s1,s2,260 <main+0x26>
  exit(0);
 26c:	4501                	li	a0,0
 26e:	2b8000ef          	jal	526 <exit>
 272:	e426                	sd	s1,8(sp)
 274:	e04a                	sd	s2,0(sp)
    ls(".");
 276:	00001517          	auipc	a0,0x1
 27a:	8d250513          	addi	a0,a0,-1838 # b48 <malloc+0x158>
 27e:	e15ff0ef          	jal	92 <ls>
    exit(0);
 282:	4501                	li	a0,0
 284:	2a2000ef          	jal	526 <exit>

0000000000000288 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 290:	fabff0ef          	jal	23a <main>
  exit(0);
 294:	4501                	li	a0,0
 296:	290000ef          	jal	526 <exit>

000000000000029a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a2:	87aa                	mv	a5,a0
 2a4:	0585                	addi	a1,a1,1
 2a6:	0785                	addi	a5,a5,1
 2a8:	fff5c703          	lbu	a4,-1(a1)
 2ac:	fee78fa3          	sb	a4,-1(a5)
 2b0:	fb75                	bnez	a4,2a4 <strcpy+0xa>
    ;
  return os;
}
 2b2:	60a2                	ld	ra,8(sp)
 2b4:	6402                	ld	s0,0(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e406                	sd	ra,8(sp)
 2be:	e022                	sd	s0,0(sp)
 2c0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	cb91                	beqz	a5,2da <strcmp+0x20>
 2c8:	0005c703          	lbu	a4,0(a1)
 2cc:	00f71763          	bne	a4,a5,2da <strcmp+0x20>
    p++, q++;
 2d0:	0505                	addi	a0,a0,1
 2d2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	fbe5                	bnez	a5,2c8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2da:	0005c503          	lbu	a0,0(a1)
}
 2de:	40a7853b          	subw	a0,a5,a0
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <strlen>:

uint
strlen(const char *s)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f2:	00054783          	lbu	a5,0(a0)
 2f6:	cf99                	beqz	a5,314 <strlen+0x2a>
 2f8:	0505                	addi	a0,a0,1
 2fa:	87aa                	mv	a5,a0
 2fc:	86be                	mv	a3,a5
 2fe:	0785                	addi	a5,a5,1
 300:	fff7c703          	lbu	a4,-1(a5)
 304:	ff65                	bnez	a4,2fc <strlen+0x12>
 306:	40a6853b          	subw	a0,a3,a0
 30a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  for(n = 0; s[n]; n++)
 314:	4501                	li	a0,0
 316:	bfdd                	j	30c <strlen+0x22>

0000000000000318 <memset>:

void*
memset(void *dst, int c, uint n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e406                	sd	ra,8(sp)
 31c:	e022                	sd	s0,0(sp)
 31e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 320:	ca19                	beqz	a2,336 <memset+0x1e>
 322:	87aa                	mv	a5,a0
 324:	1602                	slli	a2,a2,0x20
 326:	9201                	srli	a2,a2,0x20
 328:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 32c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 330:	0785                	addi	a5,a5,1
 332:	fee79de3          	bne	a5,a4,32c <memset+0x14>
  }
  return dst;
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <strchr>:

char*
strchr(const char *s, char c)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  for(; *s; s++)
 346:	00054783          	lbu	a5,0(a0)
 34a:	cf81                	beqz	a5,362 <strchr+0x24>
    if(*s == c)
 34c:	00f58763          	beq	a1,a5,35a <strchr+0x1c>
  for(; *s; s++)
 350:	0505                	addi	a0,a0,1
 352:	00054783          	lbu	a5,0(a0)
 356:	fbfd                	bnez	a5,34c <strchr+0xe>
      return (char*)s;
  return 0;
 358:	4501                	li	a0,0
}
 35a:	60a2                	ld	ra,8(sp)
 35c:	6402                	ld	s0,0(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret
  return 0;
 362:	4501                	li	a0,0
 364:	bfdd                	j	35a <strchr+0x1c>

0000000000000366 <gets>:

char*
gets(char *buf, int max)
{
 366:	7159                	addi	sp,sp,-112
 368:	f486                	sd	ra,104(sp)
 36a:	f0a2                	sd	s0,96(sp)
 36c:	eca6                	sd	s1,88(sp)
 36e:	e8ca                	sd	s2,80(sp)
 370:	e4ce                	sd	s3,72(sp)
 372:	e0d2                	sd	s4,64(sp)
 374:	fc56                	sd	s5,56(sp)
 376:	f85a                	sd	s6,48(sp)
 378:	f45e                	sd	s7,40(sp)
 37a:	f062                	sd	s8,32(sp)
 37c:	ec66                	sd	s9,24(sp)
 37e:	e86a                	sd	s10,16(sp)
 380:	1880                	addi	s0,sp,112
 382:	8caa                	mv	s9,a0
 384:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 386:	892a                	mv	s2,a0
 388:	4481                	li	s1,0
    cc = read(0, &c, 1);
 38a:	f9f40b13          	addi	s6,s0,-97
 38e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 390:	4ba9                	li	s7,10
 392:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 394:	8d26                	mv	s10,s1
 396:	0014899b          	addiw	s3,s1,1
 39a:	84ce                	mv	s1,s3
 39c:	0349d563          	bge	s3,s4,3c6 <gets+0x60>
    cc = read(0, &c, 1);
 3a0:	8656                	mv	a2,s5
 3a2:	85da                	mv	a1,s6
 3a4:	4501                	li	a0,0
 3a6:	198000ef          	jal	53e <read>
    if(cc < 1)
 3aa:	00a05e63          	blez	a0,3c6 <gets+0x60>
    buf[i++] = c;
 3ae:	f9f44783          	lbu	a5,-97(s0)
 3b2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b6:	01778763          	beq	a5,s7,3c4 <gets+0x5e>
 3ba:	0905                	addi	s2,s2,1
 3bc:	fd879ce3          	bne	a5,s8,394 <gets+0x2e>
    buf[i++] = c;
 3c0:	8d4e                	mv	s10,s3
 3c2:	a011                	j	3c6 <gets+0x60>
 3c4:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 3c6:	9d66                	add	s10,s10,s9
 3c8:	000d0023          	sb	zero,0(s10)
  return buf;
}
 3cc:	8566                	mv	a0,s9
 3ce:	70a6                	ld	ra,104(sp)
 3d0:	7406                	ld	s0,96(sp)
 3d2:	64e6                	ld	s1,88(sp)
 3d4:	6946                	ld	s2,80(sp)
 3d6:	69a6                	ld	s3,72(sp)
 3d8:	6a06                	ld	s4,64(sp)
 3da:	7ae2                	ld	s5,56(sp)
 3dc:	7b42                	ld	s6,48(sp)
 3de:	7ba2                	ld	s7,40(sp)
 3e0:	7c02                	ld	s8,32(sp)
 3e2:	6ce2                	ld	s9,24(sp)
 3e4:	6d42                	ld	s10,16(sp)
 3e6:	6165                	addi	sp,sp,112
 3e8:	8082                	ret

00000000000003ea <stat>:

int
stat(const char *n, struct stat *st)
{
 3ea:	1101                	addi	sp,sp,-32
 3ec:	ec06                	sd	ra,24(sp)
 3ee:	e822                	sd	s0,16(sp)
 3f0:	e04a                	sd	s2,0(sp)
 3f2:	1000                	addi	s0,sp,32
 3f4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f6:	4581                	li	a1,0
 3f8:	16e000ef          	jal	566 <open>
  if(fd < 0)
 3fc:	02054263          	bltz	a0,420 <stat+0x36>
 400:	e426                	sd	s1,8(sp)
 402:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 404:	85ca                	mv	a1,s2
 406:	178000ef          	jal	57e <fstat>
 40a:	892a                	mv	s2,a0
  close(fd);
 40c:	8526                	mv	a0,s1
 40e:	140000ef          	jal	54e <close>
  return r;
 412:	64a2                	ld	s1,8(sp)
}
 414:	854a                	mv	a0,s2
 416:	60e2                	ld	ra,24(sp)
 418:	6442                	ld	s0,16(sp)
 41a:	6902                	ld	s2,0(sp)
 41c:	6105                	addi	sp,sp,32
 41e:	8082                	ret
    return -1;
 420:	597d                	li	s2,-1
 422:	bfcd                	j	414 <stat+0x2a>

0000000000000424 <atoi>:

int
atoi(const char *s)
{
 424:	1141                	addi	sp,sp,-16
 426:	e406                	sd	ra,8(sp)
 428:	e022                	sd	s0,0(sp)
 42a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 42c:	00054683          	lbu	a3,0(a0)
 430:	fd06879b          	addiw	a5,a3,-48
 434:	0ff7f793          	zext.b	a5,a5
 438:	4625                	li	a2,9
 43a:	02f66963          	bltu	a2,a5,46c <atoi+0x48>
 43e:	872a                	mv	a4,a0
  n = 0;
 440:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 442:	0705                	addi	a4,a4,1
 444:	0025179b          	slliw	a5,a0,0x2
 448:	9fa9                	addw	a5,a5,a0
 44a:	0017979b          	slliw	a5,a5,0x1
 44e:	9fb5                	addw	a5,a5,a3
 450:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 454:	00074683          	lbu	a3,0(a4)
 458:	fd06879b          	addiw	a5,a3,-48
 45c:	0ff7f793          	zext.b	a5,a5
 460:	fef671e3          	bgeu	a2,a5,442 <atoi+0x1e>
  return n;
}
 464:	60a2                	ld	ra,8(sp)
 466:	6402                	ld	s0,0(sp)
 468:	0141                	addi	sp,sp,16
 46a:	8082                	ret
  n = 0;
 46c:	4501                	li	a0,0
 46e:	bfdd                	j	464 <atoi+0x40>

0000000000000470 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 470:	1141                	addi	sp,sp,-16
 472:	e406                	sd	ra,8(sp)
 474:	e022                	sd	s0,0(sp)
 476:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 478:	02b57563          	bgeu	a0,a1,4a2 <memmove+0x32>
    while(n-- > 0)
 47c:	00c05f63          	blez	a2,49a <memmove+0x2a>
 480:	1602                	slli	a2,a2,0x20
 482:	9201                	srli	a2,a2,0x20
 484:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 488:	872a                	mv	a4,a0
      *dst++ = *src++;
 48a:	0585                	addi	a1,a1,1
 48c:	0705                	addi	a4,a4,1
 48e:	fff5c683          	lbu	a3,-1(a1)
 492:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 496:	fee79ae3          	bne	a5,a4,48a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 49a:	60a2                	ld	ra,8(sp)
 49c:	6402                	ld	s0,0(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret
    dst += n;
 4a2:	00c50733          	add	a4,a0,a2
    src += n;
 4a6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4a8:	fec059e3          	blez	a2,49a <memmove+0x2a>
 4ac:	fff6079b          	addiw	a5,a2,-1
 4b0:	1782                	slli	a5,a5,0x20
 4b2:	9381                	srli	a5,a5,0x20
 4b4:	fff7c793          	not	a5,a5
 4b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4ba:	15fd                	addi	a1,a1,-1
 4bc:	177d                	addi	a4,a4,-1
 4be:	0005c683          	lbu	a3,0(a1)
 4c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4c6:	fef71ae3          	bne	a4,a5,4ba <memmove+0x4a>
 4ca:	bfc1                	j	49a <memmove+0x2a>

00000000000004cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e406                	sd	ra,8(sp)
 4d0:	e022                	sd	s0,0(sp)
 4d2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4d4:	ca0d                	beqz	a2,506 <memcmp+0x3a>
 4d6:	fff6069b          	addiw	a3,a2,-1
 4da:	1682                	slli	a3,a3,0x20
 4dc:	9281                	srli	a3,a3,0x20
 4de:	0685                	addi	a3,a3,1
 4e0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4e2:	00054783          	lbu	a5,0(a0)
 4e6:	0005c703          	lbu	a4,0(a1)
 4ea:	00e79863          	bne	a5,a4,4fa <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 4ee:	0505                	addi	a0,a0,1
    p2++;
 4f0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4f2:	fed518e3          	bne	a0,a3,4e2 <memcmp+0x16>
  }
  return 0;
 4f6:	4501                	li	a0,0
 4f8:	a019                	j	4fe <memcmp+0x32>
      return *p1 - *p2;
 4fa:	40e7853b          	subw	a0,a5,a4
}
 4fe:	60a2                	ld	ra,8(sp)
 500:	6402                	ld	s0,0(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret
  return 0;
 506:	4501                	li	a0,0
 508:	bfdd                	j	4fe <memcmp+0x32>

000000000000050a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 50a:	1141                	addi	sp,sp,-16
 50c:	e406                	sd	ra,8(sp)
 50e:	e022                	sd	s0,0(sp)
 510:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 512:	f5fff0ef          	jal	470 <memmove>
}
 516:	60a2                	ld	ra,8(sp)
 518:	6402                	ld	s0,0(sp)
 51a:	0141                	addi	sp,sp,16
 51c:	8082                	ret

000000000000051e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 51e:	4885                	li	a7,1
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <exit>:
.global exit
exit:
 li a7, SYS_exit
 526:	4889                	li	a7,2
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <wait>:
.global wait
wait:
 li a7, SYS_wait
 52e:	488d                	li	a7,3
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 536:	4891                	li	a7,4
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <read>:
.global read
read:
 li a7, SYS_read
 53e:	4895                	li	a7,5
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <write>:
.global write
write:
 li a7, SYS_write
 546:	48c1                	li	a7,16
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <close>:
.global close
close:
 li a7, SYS_close
 54e:	48d5                	li	a7,21
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <kill>:
.global kill
kill:
 li a7, SYS_kill
 556:	4899                	li	a7,6
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <exec>:
.global exec
exec:
 li a7, SYS_exec
 55e:	489d                	li	a7,7
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <open>:
.global open
open:
 li a7, SYS_open
 566:	48bd                	li	a7,15
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 56e:	48c5                	li	a7,17
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 576:	48c9                	li	a7,18
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 57e:	48a1                	li	a7,8
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <link>:
.global link
link:
 li a7, SYS_link
 586:	48cd                	li	a7,19
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 58e:	48d1                	li	a7,20
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 596:	48a5                	li	a7,9
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <dup>:
.global dup
dup:
 li a7, SYS_dup
 59e:	48a9                	li	a7,10
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a6:	48ad                	li	a7,11
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ae:	48b1                	li	a7,12
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5b6:	48b5                	li	a7,13
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5be:	48b9                	li	a7,14
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 5c6:	48d9                	li	a7,22
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 5ce:	48dd                	li	a7,23
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5d6:	1101                	addi	sp,sp,-32
 5d8:	ec06                	sd	ra,24(sp)
 5da:	e822                	sd	s0,16(sp)
 5dc:	1000                	addi	s0,sp,32
 5de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5e2:	4605                	li	a2,1
 5e4:	fef40593          	addi	a1,s0,-17
 5e8:	f5fff0ef          	jal	546 <write>
}
 5ec:	60e2                	ld	ra,24(sp)
 5ee:	6442                	ld	s0,16(sp)
 5f0:	6105                	addi	sp,sp,32
 5f2:	8082                	ret

00000000000005f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f4:	7139                	addi	sp,sp,-64
 5f6:	fc06                	sd	ra,56(sp)
 5f8:	f822                	sd	s0,48(sp)
 5fa:	f426                	sd	s1,40(sp)
 5fc:	f04a                	sd	s2,32(sp)
 5fe:	ec4e                	sd	s3,24(sp)
 600:	0080                	addi	s0,sp,64
 602:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 604:	c299                	beqz	a3,60a <printint+0x16>
 606:	0605ce63          	bltz	a1,682 <printint+0x8e>
  neg = 0;
 60a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 60c:	fc040313          	addi	t1,s0,-64
  neg = 0;
 610:	869a                	mv	a3,t1
  i = 0;
 612:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 614:	00000817          	auipc	a6,0x0
 618:	54480813          	addi	a6,a6,1348 # b58 <digits>
 61c:	88be                	mv	a7,a5
 61e:	0017851b          	addiw	a0,a5,1
 622:	87aa                	mv	a5,a0
 624:	02c5f73b          	remuw	a4,a1,a2
 628:	1702                	slli	a4,a4,0x20
 62a:	9301                	srli	a4,a4,0x20
 62c:	9742                	add	a4,a4,a6
 62e:	00074703          	lbu	a4,0(a4)
 632:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 636:	872e                	mv	a4,a1
 638:	02c5d5bb          	divuw	a1,a1,a2
 63c:	0685                	addi	a3,a3,1
 63e:	fcc77fe3          	bgeu	a4,a2,61c <printint+0x28>
  if(neg)
 642:	000e0c63          	beqz	t3,65a <printint+0x66>
    buf[i++] = '-';
 646:	fd050793          	addi	a5,a0,-48
 64a:	00878533          	add	a0,a5,s0
 64e:	02d00793          	li	a5,45
 652:	fef50823          	sb	a5,-16(a0)
 656:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 65a:	fff7899b          	addiw	s3,a5,-1
 65e:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 662:	fff4c583          	lbu	a1,-1(s1)
 666:	854a                	mv	a0,s2
 668:	f6fff0ef          	jal	5d6 <putc>
  while(--i >= 0)
 66c:	39fd                	addiw	s3,s3,-1
 66e:	14fd                	addi	s1,s1,-1
 670:	fe09d9e3          	bgez	s3,662 <printint+0x6e>
}
 674:	70e2                	ld	ra,56(sp)
 676:	7442                	ld	s0,48(sp)
 678:	74a2                	ld	s1,40(sp)
 67a:	7902                	ld	s2,32(sp)
 67c:	69e2                	ld	s3,24(sp)
 67e:	6121                	addi	sp,sp,64
 680:	8082                	ret
    x = -xx;
 682:	40b005bb          	negw	a1,a1
    neg = 1;
 686:	4e05                	li	t3,1
    x = -xx;
 688:	b751                	j	60c <printint+0x18>

000000000000068a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 68a:	711d                	addi	sp,sp,-96
 68c:	ec86                	sd	ra,88(sp)
 68e:	e8a2                	sd	s0,80(sp)
 690:	e4a6                	sd	s1,72(sp)
 692:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 694:	0005c483          	lbu	s1,0(a1)
 698:	26048663          	beqz	s1,904 <vprintf+0x27a>
 69c:	e0ca                	sd	s2,64(sp)
 69e:	fc4e                	sd	s3,56(sp)
 6a0:	f852                	sd	s4,48(sp)
 6a2:	f456                	sd	s5,40(sp)
 6a4:	f05a                	sd	s6,32(sp)
 6a6:	ec5e                	sd	s7,24(sp)
 6a8:	e862                	sd	s8,16(sp)
 6aa:	e466                	sd	s9,8(sp)
 6ac:	8b2a                	mv	s6,a0
 6ae:	8a2e                	mv	s4,a1
 6b0:	8bb2                	mv	s7,a2
  state = 0;
 6b2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6b4:	4901                	li	s2,0
 6b6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6b8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6bc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6c0:	06c00c93          	li	s9,108
 6c4:	a00d                	j	6e6 <vprintf+0x5c>
        putc(fd, c0);
 6c6:	85a6                	mv	a1,s1
 6c8:	855a                	mv	a0,s6
 6ca:	f0dff0ef          	jal	5d6 <putc>
 6ce:	a019                	j	6d4 <vprintf+0x4a>
    } else if(state == '%'){
 6d0:	03598363          	beq	s3,s5,6f6 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6d4:	0019079b          	addiw	a5,s2,1
 6d8:	893e                	mv	s2,a5
 6da:	873e                	mv	a4,a5
 6dc:	97d2                	add	a5,a5,s4
 6de:	0007c483          	lbu	s1,0(a5)
 6e2:	20048963          	beqz	s1,8f4 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 6e6:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6ea:	fe0993e3          	bnez	s3,6d0 <vprintf+0x46>
      if(c0 == '%'){
 6ee:	fd579ce3          	bne	a5,s5,6c6 <vprintf+0x3c>
        state = '%';
 6f2:	89be                	mv	s3,a5
 6f4:	b7c5                	j	6d4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6f6:	00ea06b3          	add	a3,s4,a4
 6fa:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6fe:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 700:	c681                	beqz	a3,708 <vprintf+0x7e>
 702:	9752                	add	a4,a4,s4
 704:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 708:	03878e63          	beq	a5,s8,744 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 70c:	05978863          	beq	a5,s9,75c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 710:	07500713          	li	a4,117
 714:	0ee78263          	beq	a5,a4,7f8 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 718:	07800713          	li	a4,120
 71c:	12e78463          	beq	a5,a4,844 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 720:	07000713          	li	a4,112
 724:	14e78963          	beq	a5,a4,876 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 728:	07300713          	li	a4,115
 72c:	18e78863          	beq	a5,a4,8bc <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 730:	02500713          	li	a4,37
 734:	04e79463          	bne	a5,a4,77c <vprintf+0xf2>
        putc(fd, '%');
 738:	85ba                	mv	a1,a4
 73a:	855a                	mv	a0,s6
 73c:	e9bff0ef          	jal	5d6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 740:	4981                	li	s3,0
 742:	bf49                	j	6d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 744:	008b8493          	addi	s1,s7,8
 748:	4685                	li	a3,1
 74a:	4629                	li	a2,10
 74c:	000ba583          	lw	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	ea3ff0ef          	jal	5f4 <printint>
 756:	8ba6                	mv	s7,s1
      state = 0;
 758:	4981                	li	s3,0
 75a:	bfad                	j	6d4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 75c:	06400793          	li	a5,100
 760:	02f68963          	beq	a3,a5,792 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 764:	06c00793          	li	a5,108
 768:	04f68263          	beq	a3,a5,7ac <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 76c:	07500793          	li	a5,117
 770:	0af68063          	beq	a3,a5,810 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 774:	07800793          	li	a5,120
 778:	0ef68263          	beq	a3,a5,85c <vprintf+0x1d2>
        putc(fd, '%');
 77c:	02500593          	li	a1,37
 780:	855a                	mv	a0,s6
 782:	e55ff0ef          	jal	5d6 <putc>
        putc(fd, c0);
 786:	85a6                	mv	a1,s1
 788:	855a                	mv	a0,s6
 78a:	e4dff0ef          	jal	5d6 <putc>
      state = 0;
 78e:	4981                	li	s3,0
 790:	b791                	j	6d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 792:	008b8493          	addi	s1,s7,8
 796:	4685                	li	a3,1
 798:	4629                	li	a2,10
 79a:	000ba583          	lw	a1,0(s7)
 79e:	855a                	mv	a0,s6
 7a0:	e55ff0ef          	jal	5f4 <printint>
        i += 1;
 7a4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a6:	8ba6                	mv	s7,s1
      state = 0;
 7a8:	4981                	li	s3,0
        i += 1;
 7aa:	b72d                	j	6d4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7ac:	06400793          	li	a5,100
 7b0:	02f60763          	beq	a2,a5,7de <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7b4:	07500793          	li	a5,117
 7b8:	06f60963          	beq	a2,a5,82a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7bc:	07800793          	li	a5,120
 7c0:	faf61ee3          	bne	a2,a5,77c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c4:	008b8493          	addi	s1,s7,8
 7c8:	4681                	li	a3,0
 7ca:	4641                	li	a2,16
 7cc:	000ba583          	lw	a1,0(s7)
 7d0:	855a                	mv	a0,s6
 7d2:	e23ff0ef          	jal	5f4 <printint>
        i += 2;
 7d6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d8:	8ba6                	mv	s7,s1
      state = 0;
 7da:	4981                	li	s3,0
        i += 2;
 7dc:	bde5                	j	6d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7de:	008b8493          	addi	s1,s7,8
 7e2:	4685                	li	a3,1
 7e4:	4629                	li	a2,10
 7e6:	000ba583          	lw	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	e09ff0ef          	jal	5f4 <printint>
        i += 2;
 7f0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f2:	8ba6                	mv	s7,s1
      state = 0;
 7f4:	4981                	li	s3,0
        i += 2;
 7f6:	bdf9                	j	6d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7f8:	008b8493          	addi	s1,s7,8
 7fc:	4681                	li	a3,0
 7fe:	4629                	li	a2,10
 800:	000ba583          	lw	a1,0(s7)
 804:	855a                	mv	a0,s6
 806:	defff0ef          	jal	5f4 <printint>
 80a:	8ba6                	mv	s7,s1
      state = 0;
 80c:	4981                	li	s3,0
 80e:	b5d9                	j	6d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 810:	008b8493          	addi	s1,s7,8
 814:	4681                	li	a3,0
 816:	4629                	li	a2,10
 818:	000ba583          	lw	a1,0(s7)
 81c:	855a                	mv	a0,s6
 81e:	dd7ff0ef          	jal	5f4 <printint>
        i += 1;
 822:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 824:	8ba6                	mv	s7,s1
      state = 0;
 826:	4981                	li	s3,0
        i += 1;
 828:	b575                	j	6d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 82a:	008b8493          	addi	s1,s7,8
 82e:	4681                	li	a3,0
 830:	4629                	li	a2,10
 832:	000ba583          	lw	a1,0(s7)
 836:	855a                	mv	a0,s6
 838:	dbdff0ef          	jal	5f4 <printint>
        i += 2;
 83c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 83e:	8ba6                	mv	s7,s1
      state = 0;
 840:	4981                	li	s3,0
        i += 2;
 842:	bd49                	j	6d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 844:	008b8493          	addi	s1,s7,8
 848:	4681                	li	a3,0
 84a:	4641                	li	a2,16
 84c:	000ba583          	lw	a1,0(s7)
 850:	855a                	mv	a0,s6
 852:	da3ff0ef          	jal	5f4 <printint>
 856:	8ba6                	mv	s7,s1
      state = 0;
 858:	4981                	li	s3,0
 85a:	bdad                	j	6d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 85c:	008b8493          	addi	s1,s7,8
 860:	4681                	li	a3,0
 862:	4641                	li	a2,16
 864:	000ba583          	lw	a1,0(s7)
 868:	855a                	mv	a0,s6
 86a:	d8bff0ef          	jal	5f4 <printint>
        i += 1;
 86e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 870:	8ba6                	mv	s7,s1
      state = 0;
 872:	4981                	li	s3,0
        i += 1;
 874:	b585                	j	6d4 <vprintf+0x4a>
 876:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 878:	008b8d13          	addi	s10,s7,8
 87c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 880:	03000593          	li	a1,48
 884:	855a                	mv	a0,s6
 886:	d51ff0ef          	jal	5d6 <putc>
  putc(fd, 'x');
 88a:	07800593          	li	a1,120
 88e:	855a                	mv	a0,s6
 890:	d47ff0ef          	jal	5d6 <putc>
 894:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 896:	00000b97          	auipc	s7,0x0
 89a:	2c2b8b93          	addi	s7,s7,706 # b58 <digits>
 89e:	03c9d793          	srli	a5,s3,0x3c
 8a2:	97de                	add	a5,a5,s7
 8a4:	0007c583          	lbu	a1,0(a5)
 8a8:	855a                	mv	a0,s6
 8aa:	d2dff0ef          	jal	5d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8ae:	0992                	slli	s3,s3,0x4
 8b0:	34fd                	addiw	s1,s1,-1
 8b2:	f4f5                	bnez	s1,89e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8b4:	8bea                	mv	s7,s10
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	6d02                	ld	s10,0(sp)
 8ba:	bd29                	j	6d4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8bc:	008b8993          	addi	s3,s7,8
 8c0:	000bb483          	ld	s1,0(s7)
 8c4:	cc91                	beqz	s1,8e0 <vprintf+0x256>
        for(; *s; s++)
 8c6:	0004c583          	lbu	a1,0(s1)
 8ca:	c195                	beqz	a1,8ee <vprintf+0x264>
          putc(fd, *s);
 8cc:	855a                	mv	a0,s6
 8ce:	d09ff0ef          	jal	5d6 <putc>
        for(; *s; s++)
 8d2:	0485                	addi	s1,s1,1
 8d4:	0004c583          	lbu	a1,0(s1)
 8d8:	f9f5                	bnez	a1,8cc <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 8da:	8bce                	mv	s7,s3
      state = 0;
 8dc:	4981                	li	s3,0
 8de:	bbdd                	j	6d4 <vprintf+0x4a>
          s = "(null)";
 8e0:	00000497          	auipc	s1,0x0
 8e4:	27048493          	addi	s1,s1,624 # b50 <malloc+0x160>
        for(; *s; s++)
 8e8:	02800593          	li	a1,40
 8ec:	b7c5                	j	8cc <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 8ee:	8bce                	mv	s7,s3
      state = 0;
 8f0:	4981                	li	s3,0
 8f2:	b3cd                	j	6d4 <vprintf+0x4a>
 8f4:	6906                	ld	s2,64(sp)
 8f6:	79e2                	ld	s3,56(sp)
 8f8:	7a42                	ld	s4,48(sp)
 8fa:	7aa2                	ld	s5,40(sp)
 8fc:	7b02                	ld	s6,32(sp)
 8fe:	6be2                	ld	s7,24(sp)
 900:	6c42                	ld	s8,16(sp)
 902:	6ca2                	ld	s9,8(sp)
    }
  }
}
 904:	60e6                	ld	ra,88(sp)
 906:	6446                	ld	s0,80(sp)
 908:	64a6                	ld	s1,72(sp)
 90a:	6125                	addi	sp,sp,96
 90c:	8082                	ret

000000000000090e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 90e:	715d                	addi	sp,sp,-80
 910:	ec06                	sd	ra,24(sp)
 912:	e822                	sd	s0,16(sp)
 914:	1000                	addi	s0,sp,32
 916:	e010                	sd	a2,0(s0)
 918:	e414                	sd	a3,8(s0)
 91a:	e818                	sd	a4,16(s0)
 91c:	ec1c                	sd	a5,24(s0)
 91e:	03043023          	sd	a6,32(s0)
 922:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 926:	8622                	mv	a2,s0
 928:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 92c:	d5fff0ef          	jal	68a <vprintf>
}
 930:	60e2                	ld	ra,24(sp)
 932:	6442                	ld	s0,16(sp)
 934:	6161                	addi	sp,sp,80
 936:	8082                	ret

0000000000000938 <printf>:

void
printf(const char *fmt, ...)
{
 938:	711d                	addi	sp,sp,-96
 93a:	ec06                	sd	ra,24(sp)
 93c:	e822                	sd	s0,16(sp)
 93e:	1000                	addi	s0,sp,32
 940:	e40c                	sd	a1,8(s0)
 942:	e810                	sd	a2,16(s0)
 944:	ec14                	sd	a3,24(s0)
 946:	f018                	sd	a4,32(s0)
 948:	f41c                	sd	a5,40(s0)
 94a:	03043823          	sd	a6,48(s0)
 94e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 952:	00840613          	addi	a2,s0,8
 956:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 95a:	85aa                	mv	a1,a0
 95c:	4505                	li	a0,1
 95e:	d2dff0ef          	jal	68a <vprintf>
}
 962:	60e2                	ld	ra,24(sp)
 964:	6442                	ld	s0,16(sp)
 966:	6125                	addi	sp,sp,96
 968:	8082                	ret

000000000000096a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 96a:	1141                	addi	sp,sp,-16
 96c:	e406                	sd	ra,8(sp)
 96e:	e022                	sd	s0,0(sp)
 970:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 972:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 976:	00001797          	auipc	a5,0x1
 97a:	68a7b783          	ld	a5,1674(a5) # 2000 <freep>
 97e:	a02d                	j	9a8 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 980:	4618                	lw	a4,8(a2)
 982:	9f2d                	addw	a4,a4,a1
 984:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 988:	6398                	ld	a4,0(a5)
 98a:	6310                	ld	a2,0(a4)
 98c:	a83d                	j	9ca <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 98e:	ff852703          	lw	a4,-8(a0)
 992:	9f31                	addw	a4,a4,a2
 994:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 996:	ff053683          	ld	a3,-16(a0)
 99a:	a091                	j	9de <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99c:	6398                	ld	a4,0(a5)
 99e:	00e7e463          	bltu	a5,a4,9a6 <free+0x3c>
 9a2:	00e6ea63          	bltu	a3,a4,9b6 <free+0x4c>
{
 9a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a8:	fed7fae3          	bgeu	a5,a3,99c <free+0x32>
 9ac:	6398                	ld	a4,0(a5)
 9ae:	00e6e463          	bltu	a3,a4,9b6 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b2:	fee7eae3          	bltu	a5,a4,9a6 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9b6:	ff852583          	lw	a1,-8(a0)
 9ba:	6390                	ld	a2,0(a5)
 9bc:	02059813          	slli	a6,a1,0x20
 9c0:	01c85713          	srli	a4,a6,0x1c
 9c4:	9736                	add	a4,a4,a3
 9c6:	fae60de3          	beq	a2,a4,980 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ce:	4790                	lw	a2,8(a5)
 9d0:	02061593          	slli	a1,a2,0x20
 9d4:	01c5d713          	srli	a4,a1,0x1c
 9d8:	973e                	add	a4,a4,a5
 9da:	fae68ae3          	beq	a3,a4,98e <free+0x24>
    p->s.ptr = bp->s.ptr;
 9de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9e0:	00001717          	auipc	a4,0x1
 9e4:	62f73023          	sd	a5,1568(a4) # 2000 <freep>
}
 9e8:	60a2                	ld	ra,8(sp)
 9ea:	6402                	ld	s0,0(sp)
 9ec:	0141                	addi	sp,sp,16
 9ee:	8082                	ret

00000000000009f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9f0:	7139                	addi	sp,sp,-64
 9f2:	fc06                	sd	ra,56(sp)
 9f4:	f822                	sd	s0,48(sp)
 9f6:	f04a                	sd	s2,32(sp)
 9f8:	ec4e                	sd	s3,24(sp)
 9fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9fc:	02051993          	slli	s3,a0,0x20
 a00:	0209d993          	srli	s3,s3,0x20
 a04:	09bd                	addi	s3,s3,15
 a06:	0049d993          	srli	s3,s3,0x4
 a0a:	2985                	addiw	s3,s3,1
 a0c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a0e:	00001517          	auipc	a0,0x1
 a12:	5f253503          	ld	a0,1522(a0) # 2000 <freep>
 a16:	c905                	beqz	a0,a46 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a18:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a1a:	4798                	lw	a4,8(a5)
 a1c:	09377663          	bgeu	a4,s3,aa8 <malloc+0xb8>
 a20:	f426                	sd	s1,40(sp)
 a22:	e852                	sd	s4,16(sp)
 a24:	e456                	sd	s5,8(sp)
 a26:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a28:	8a4e                	mv	s4,s3
 a2a:	6705                	lui	a4,0x1
 a2c:	00e9f363          	bgeu	s3,a4,a32 <malloc+0x42>
 a30:	6a05                	lui	s4,0x1
 a32:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a36:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a3a:	00001497          	auipc	s1,0x1
 a3e:	5c648493          	addi	s1,s1,1478 # 2000 <freep>
  if(p == (char*)-1)
 a42:	5afd                	li	s5,-1
 a44:	a83d                	j	a82 <malloc+0x92>
 a46:	f426                	sd	s1,40(sp)
 a48:	e852                	sd	s4,16(sp)
 a4a:	e456                	sd	s5,8(sp)
 a4c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a4e:	00001797          	auipc	a5,0x1
 a52:	5d278793          	addi	a5,a5,1490 # 2020 <base>
 a56:	00001717          	auipc	a4,0x1
 a5a:	5af73523          	sd	a5,1450(a4) # 2000 <freep>
 a5e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a60:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a64:	b7d1                	j	a28 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a66:	6398                	ld	a4,0(a5)
 a68:	e118                	sd	a4,0(a0)
 a6a:	a899                	j	ac0 <malloc+0xd0>
  hp->s.size = nu;
 a6c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a70:	0541                	addi	a0,a0,16
 a72:	ef9ff0ef          	jal	96a <free>
  return freep;
 a76:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a78:	c125                	beqz	a0,ad8 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a7c:	4798                	lw	a4,8(a5)
 a7e:	03277163          	bgeu	a4,s2,aa0 <malloc+0xb0>
    if(p == freep)
 a82:	6098                	ld	a4,0(s1)
 a84:	853e                	mv	a0,a5
 a86:	fef71ae3          	bne	a4,a5,a7a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a8a:	8552                	mv	a0,s4
 a8c:	b23ff0ef          	jal	5ae <sbrk>
  if(p == (char*)-1)
 a90:	fd551ee3          	bne	a0,s5,a6c <malloc+0x7c>
        return 0;
 a94:	4501                	li	a0,0
 a96:	74a2                	ld	s1,40(sp)
 a98:	6a42                	ld	s4,16(sp)
 a9a:	6aa2                	ld	s5,8(sp)
 a9c:	6b02                	ld	s6,0(sp)
 a9e:	a03d                	j	acc <malloc+0xdc>
 aa0:	74a2                	ld	s1,40(sp)
 aa2:	6a42                	ld	s4,16(sp)
 aa4:	6aa2                	ld	s5,8(sp)
 aa6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aa8:	fae90fe3          	beq	s2,a4,a66 <malloc+0x76>
        p->s.size -= nunits;
 aac:	4137073b          	subw	a4,a4,s3
 ab0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ab2:	02071693          	slli	a3,a4,0x20
 ab6:	01c6d713          	srli	a4,a3,0x1c
 aba:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 abc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ac0:	00001717          	auipc	a4,0x1
 ac4:	54a73023          	sd	a0,1344(a4) # 2000 <freep>
      return (void*)(p + 1);
 ac8:	01078513          	addi	a0,a5,16
  }
}
 acc:	70e2                	ld	ra,56(sp)
 ace:	7442                	ld	s0,48(sp)
 ad0:	7902                	ld	s2,32(sp)
 ad2:	69e2                	ld	s3,24(sp)
 ad4:	6121                	addi	sp,sp,64
 ad6:	8082                	ret
 ad8:	74a2                	ld	s1,40(sp)
 ada:	6a42                	ld	s4,16(sp)
 adc:	6aa2                	ld	s5,8(sp)
 ade:	6b02                	ld	s6,0(sp)
 ae0:	b7f5                	j	acc <malloc+0xdc>
