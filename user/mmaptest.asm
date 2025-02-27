
user/_mmaptest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:
  exit(0);
}

void
err(char *why)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	1000                	addi	s0,sp,32
       a:	84aa                	mv	s1,a0
  printf("mmaptest failure: %s, pid=%d\n", why, getpid());
       c:	00c010ef          	jal	1018 <getpid>
      10:	862a                	mv	a2,a0
      12:	85a6                	mv	a1,s1
      14:	00001517          	auipc	a0,0x1
      18:	54c50513          	addi	a0,a0,1356 # 1560 <malloc+0xfe>
      1c:	38e010ef          	jal	13aa <printf>
  exit(1);
      20:	4505                	li	a0,1
      22:	777000ef          	jal	f98 <exit>

0000000000000026 <_v1>:
//
// check the content of the two mapped pages.
//
void
_v1(char *p)
{
      26:	1141                	addi	sp,sp,-16
      28:	e406                	sd	ra,8(sp)
      2a:	e022                	sd	s0,0(sp)
      2c:	0800                	addi	s0,sp,16
  int i;
  for (i = 0; i < PGSIZE*2; i++) {
      2e:	4581                	li	a1,0
    if (i < PGSIZE + (PGSIZE/2)) {
      30:	6785                	lui	a5,0x1
      32:	7ff78793          	addi	a5,a5,2047 # 17ff <malloc+0x39d>
  for (i = 0; i < PGSIZE*2; i++) {
      36:	6689                	lui	a3,0x2
      if (p[i] != 'A') {
      38:	04100713          	li	a4,65
      3c:	a025                	j	64 <_v1+0x3e>
        printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
      3e:	00001517          	auipc	a0,0x1
      42:	54a50513          	addi	a0,a0,1354 # 1588 <malloc+0x126>
      46:	364010ef          	jal	13aa <printf>
        err("v1 mismatch (1)");
      4a:	00001517          	auipc	a0,0x1
      4e:	56650513          	addi	a0,a0,1382 # 15b0 <malloc+0x14e>
      52:	fafff0ef          	jal	0 <err>
      }
    } else {
      if (p[i] != 0) {
      56:	00054603          	lbu	a2,0(a0)
      5a:	ee11                	bnez	a2,76 <_v1+0x50>
  for (i = 0; i < PGSIZE*2; i++) {
      5c:	2585                	addiw	a1,a1,1
      5e:	0505                	addi	a0,a0,1
      60:	02d58763          	beq	a1,a3,8e <_v1+0x68>
    if (i < PGSIZE + (PGSIZE/2)) {
      64:	feb7c9e3          	blt	a5,a1,56 <_v1+0x30>
      if (p[i] != 'A') {
      68:	00054603          	lbu	a2,0(a0)
      6c:	fce619e3          	bne	a2,a4,3e <_v1+0x18>
  for (i = 0; i < PGSIZE*2; i++) {
      70:	2585                	addiw	a1,a1,1
      72:	0505                	addi	a0,a0,1
      74:	bfc5                	j	64 <_v1+0x3e>
        printf("mismatch at %d, wanted zero, got 0x%x\n", i, p[i]);
      76:	00001517          	auipc	a0,0x1
      7a:	54a50513          	addi	a0,a0,1354 # 15c0 <malloc+0x15e>
      7e:	32c010ef          	jal	13aa <printf>
        err("v1 mismatch (2)");
      82:	00001517          	auipc	a0,0x1
      86:	56650513          	addi	a0,a0,1382 # 15e8 <malloc+0x186>
      8a:	f77ff0ef          	jal	0 <err>
      }
    }
  }
}
      8e:	60a2                	ld	ra,8(sp)
      90:	6402                	ld	s0,0(sp)
      92:	0141                	addi	sp,sp,16
      94:	8082                	ret

0000000000000096 <makefile>:
// create a file to be mapped, containing
// 1.5 pages of 'A' and half a page of zeros.
//
void
makefile(const char *f)
{
      96:	7179                	addi	sp,sp,-48
      98:	f406                	sd	ra,40(sp)
      9a:	f022                	sd	s0,32(sp)
      9c:	ec26                	sd	s1,24(sp)
      9e:	e84a                	sd	s2,16(sp)
      a0:	e44e                	sd	s3,8(sp)
      a2:	e052                	sd	s4,0(sp)
      a4:	1800                	addi	s0,sp,48
      a6:	84aa                	mv	s1,a0
  int i;
  int n = PGSIZE/BSIZE;

  unlink(f);
      a8:	741000ef          	jal	fe8 <unlink>
  int fd = open(f, O_WRONLY | O_CREATE);
      ac:	20100593          	li	a1,513
      b0:	8526                	mv	a0,s1
      b2:	727000ef          	jal	fd8 <open>
  if (fd == -1)
      b6:	57fd                	li	a5,-1
      b8:	04f50b63          	beq	a0,a5,10e <makefile+0x78>
      bc:	89aa                	mv	s3,a0
    err("open");
  memset(buf, 'A', BSIZE);
      be:	40000613          	li	a2,1024
      c2:	04100593          	li	a1,65
      c6:	00003517          	auipc	a0,0x3
      ca:	f4a50513          	addi	a0,a0,-182 # 3010 <buf>
      ce:	4bd000ef          	jal	d8a <memset>
      d2:	4499                	li	s1,6
  // write 1.5 page
  for (i = 0; i < n + n/2; i++) {
    if (write(fd, buf, BSIZE) != BSIZE)
      d4:	40000913          	li	s2,1024
      d8:	00003a17          	auipc	s4,0x3
      dc:	f38a0a13          	addi	s4,s4,-200 # 3010 <buf>
      e0:	864a                	mv	a2,s2
      e2:	85d2                	mv	a1,s4
      e4:	854e                	mv	a0,s3
      e6:	6d3000ef          	jal	fb8 <write>
      ea:	03251863          	bne	a0,s2,11a <makefile+0x84>
  for (i = 0; i < n + n/2; i++) {
      ee:	34fd                	addiw	s1,s1,-1
      f0:	f8e5                	bnez	s1,e0 <makefile+0x4a>
      err("write 0 makefile");
  }
  if (close(fd) == -1)
      f2:	854e                	mv	a0,s3
      f4:	6cd000ef          	jal	fc0 <close>
      f8:	57fd                	li	a5,-1
      fa:	02f50663          	beq	a0,a5,126 <makefile+0x90>
    err("close");
}
      fe:	70a2                	ld	ra,40(sp)
     100:	7402                	ld	s0,32(sp)
     102:	64e2                	ld	s1,24(sp)
     104:	6942                	ld	s2,16(sp)
     106:	69a2                	ld	s3,8(sp)
     108:	6a02                	ld	s4,0(sp)
     10a:	6145                	addi	sp,sp,48
     10c:	8082                	ret
    err("open");
     10e:	00001517          	auipc	a0,0x1
     112:	4ea50513          	addi	a0,a0,1258 # 15f8 <malloc+0x196>
     116:	eebff0ef          	jal	0 <err>
      err("write 0 makefile");
     11a:	00001517          	auipc	a0,0x1
     11e:	4e650513          	addi	a0,a0,1254 # 1600 <malloc+0x19e>
     122:	edfff0ef          	jal	0 <err>
    err("close");
     126:	00001517          	auipc	a0,0x1
     12a:	4f250513          	addi	a0,a0,1266 # 1618 <malloc+0x1b6>
     12e:	ed3ff0ef          	jal	0 <err>

0000000000000132 <mmap_test>:

void
mmap_test(void)
{
     132:	7179                	addi	sp,sp,-48
     134:	f406                	sd	ra,40(sp)
     136:	f022                	sd	s0,32(sp)
     138:	ec26                	sd	s1,24(sp)
     13a:	e84a                	sd	s2,16(sp)
     13c:	e44e                	sd	s3,8(sp)
     13e:	1800                	addi	s0,sp,48
  //
  // create a file with known content, map it into memory, check that
  // the mapped memory has the same bytes as originally written to the
  // file.
  //
  makefile(f);
     140:	00001517          	auipc	a0,0x1
     144:	4e050513          	addi	a0,a0,1248 # 1620 <malloc+0x1be>
     148:	f4fff0ef          	jal	96 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     14c:	4581                	li	a1,0
     14e:	00001517          	auipc	a0,0x1
     152:	4d250513          	addi	a0,a0,1234 # 1620 <malloc+0x1be>
     156:	683000ef          	jal	fd8 <open>
     15a:	57fd                	li	a5,-1
     15c:	4af50a63          	beq	a0,a5,610 <mmap_test+0x4de>
     160:	84aa                	mv	s1,a0
    err("open (1)");

  printf("test basic mmap\n");
     162:	00001517          	auipc	a0,0x1
     166:	4de50513          	addi	a0,a0,1246 # 1640 <malloc+0x1de>
     16a:	240010ef          	jal	13aa <printf>
  // same file (of course in this case updates are prohibited
  // due to PROT_READ). the fifth argument is the file descriptor
  // of the file to be mapped. the last argument is the starting
  // offset in the file.
  //
  char *p = mmap(0, PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
     16e:	4781                	li	a5,0
     170:	8726                	mv	a4,s1
     172:	4689                	li	a3,2
     174:	4605                	li	a2,1
     176:	6589                	lui	a1,0x2
     178:	4501                	li	a0,0
     17a:	6bf000ef          	jal	1038 <mmap>
     17e:	892a                	mv	s2,a0
  if (p == MAP_FAILED)
     180:	57fd                	li	a5,-1
     182:	48f50d63          	beq	a0,a5,61c <mmap_test+0x4ea>
    err("mmap (1)");
  _v1(p);
     186:	ea1ff0ef          	jal	26 <_v1>
  if (munmap(p, PGSIZE*2) == -1)
     18a:	6589                	lui	a1,0x2
     18c:	854a                	mv	a0,s2
     18e:	6b3000ef          	jal	1040 <munmap>
     192:	57fd                	li	a5,-1
     194:	48f50a63          	beq	a0,a5,628 <mmap_test+0x4f6>
    err("munmap (1)");

  printf("test basic mmap: OK\n");
     198:	00001517          	auipc	a0,0x1
     19c:	4e050513          	addi	a0,a0,1248 # 1678 <malloc+0x216>
     1a0:	20a010ef          	jal	13aa <printf>

  printf("test mmap private\n");
     1a4:	00001517          	auipc	a0,0x1
     1a8:	4ec50513          	addi	a0,a0,1260 # 1690 <malloc+0x22e>
     1ac:	1fe010ef          	jal	13aa <printf>
  // should be able to map file opened read-only with private writable
  // mapping
  p = mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
     1b0:	4781                	li	a5,0
     1b2:	8726                	mv	a4,s1
     1b4:	4689                	li	a3,2
     1b6:	460d                	li	a2,3
     1b8:	6589                	lui	a1,0x2
     1ba:	4501                	li	a0,0
     1bc:	67d000ef          	jal	1038 <mmap>
     1c0:	892a                	mv	s2,a0
  if (p == MAP_FAILED)
     1c2:	57fd                	li	a5,-1
     1c4:	46f50863          	beq	a0,a5,634 <mmap_test+0x502>
    err("mmap (2)");
  if (close(fd) == -1)
     1c8:	8526                	mv	a0,s1
     1ca:	5f7000ef          	jal	fc0 <close>
     1ce:	57fd                	li	a5,-1
     1d0:	46f50863          	beq	a0,a5,640 <mmap_test+0x50e>
    err("close (1)");
  _v1(p);
     1d4:	854a                	mv	a0,s2
     1d6:	e51ff0ef          	jal	26 <_v1>
  for (i = 0; i < PGSIZE*2; i++)
     1da:	87ca                	mv	a5,s2
     1dc:	6709                	lui	a4,0x2
     1de:	974a                	add	a4,a4,s2
    p[i] = 'Z';
     1e0:	05a00693          	li	a3,90
     1e4:	00d78023          	sb	a3,0(a5)
  for (i = 0; i < PGSIZE*2; i++)
     1e8:	0785                	addi	a5,a5,1
     1ea:	fef71de3          	bne	a4,a5,1e4 <mmap_test+0xb2>
  if (munmap(p, PGSIZE*2) == -1)
     1ee:	6589                	lui	a1,0x2
     1f0:	854a                	mv	a0,s2
     1f2:	64f000ef          	jal	1040 <munmap>
     1f6:	57fd                	li	a5,-1
     1f8:	44f50a63          	beq	a0,a5,64c <mmap_test+0x51a>
    err("munmap (2)");
  close(fd);
     1fc:	8526                	mv	a0,s1
     1fe:	5c3000ef          	jal	fc0 <close>

  // file should not have been modified.
  if((fd = open(f, O_RDONLY)) < 0) err("open");
     202:	4581                	li	a1,0
     204:	00001517          	auipc	a0,0x1
     208:	41c50513          	addi	a0,a0,1052 # 1620 <malloc+0x1be>
     20c:	5cd000ef          	jal	fd8 <open>
     210:	84aa                	mv	s1,a0
     212:	44054363          	bltz	a0,658 <mmap_test+0x526>
  if(read(fd, buf, PGSIZE) != PGSIZE) err("read");
     216:	6605                	lui	a2,0x1
     218:	00003597          	auipc	a1,0x3
     21c:	df858593          	addi	a1,a1,-520 # 3010 <buf>
     220:	591000ef          	jal	fb0 <read>
     224:	6785                	lui	a5,0x1
     226:	42f51f63          	bne	a0,a5,664 <mmap_test+0x532>
  if(buf[0] != 'A')
     22a:	00003717          	auipc	a4,0x3
     22e:	de674703          	lbu	a4,-538(a4) # 3010 <buf>
     232:	04100793          	li	a5,65
     236:	42f71d63          	bne	a4,a5,670 <mmap_test+0x53e>
    err("write to MAP_PRIVATE was written to file");
  if(read(fd, buf, PGSIZE) != PGSIZE/2) err("read");
     23a:	6605                	lui	a2,0x1
     23c:	00003597          	auipc	a1,0x3
     240:	dd458593          	addi	a1,a1,-556 # 3010 <buf>
     244:	8526                	mv	a0,s1
     246:	56b000ef          	jal	fb0 <read>
     24a:	8005079b          	addiw	a5,a0,-2048
     24e:	42079763          	bnez	a5,67c <mmap_test+0x54a>
  if(buf[0] != 'A')
     252:	00003717          	auipc	a4,0x3
     256:	dbe74703          	lbu	a4,-578(a4) # 3010 <buf>
     25a:	04100793          	li	a5,65
     25e:	42f71563          	bne	a4,a5,688 <mmap_test+0x556>
    err("write to MAP_PRIVATE was written to file");
  close(fd);
     262:	8526                	mv	a0,s1
     264:	55d000ef          	jal	fc0 <close>

  printf("test mmap private: OK\n");
     268:	00001517          	auipc	a0,0x1
     26c:	4a850513          	addi	a0,a0,1192 # 1710 <malloc+0x2ae>
     270:	13a010ef          	jal	13aa <printf>

  printf("test mmap read-only\n");
     274:	00001517          	auipc	a0,0x1
     278:	4b450513          	addi	a0,a0,1204 # 1728 <malloc+0x2c6>
     27c:	12e010ef          	jal	13aa <printf>

  // check that mmap doesn't allow read/write mapping of a
  // file opened read-only.
  if ((fd = open(f, O_RDONLY)) == -1)
     280:	4581                	li	a1,0
     282:	00001517          	auipc	a0,0x1
     286:	39e50513          	addi	a0,a0,926 # 1620 <malloc+0x1be>
     28a:	54f000ef          	jal	fd8 <open>
     28e:	84aa                	mv	s1,a0
     290:	57fd                	li	a5,-1
     292:	40f50163          	beq	a0,a5,694 <mmap_test+0x562>
    err("open (2)");
  p = mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     296:	4781                	li	a5,0
     298:	872a                	mv	a4,a0
     29a:	4685                	li	a3,1
     29c:	460d                	li	a2,3
     29e:	6589                	lui	a1,0x2
     2a0:	4501                	li	a0,0
     2a2:	597000ef          	jal	1038 <mmap>
  if (p != MAP_FAILED)
     2a6:	57fd                	li	a5,-1
     2a8:	3ef51c63          	bne	a0,a5,6a0 <mmap_test+0x56e>
    err("mmap (3)");
  if (close(fd) == -1)
     2ac:	8526                	mv	a0,s1
     2ae:	513000ef          	jal	fc0 <close>
     2b2:	57fd                	li	a5,-1
     2b4:	3ef50c63          	beq	a0,a5,6ac <mmap_test+0x57a>
    err("close (2)");

  printf("test mmap read-only: OK\n");
     2b8:	00001517          	auipc	a0,0x1
     2bc:	4b850513          	addi	a0,a0,1208 # 1770 <malloc+0x30e>
     2c0:	0ea010ef          	jal	13aa <printf>

  printf("test mmap read/write\n");
     2c4:	00001517          	auipc	a0,0x1
     2c8:	4cc50513          	addi	a0,a0,1228 # 1790 <malloc+0x32e>
     2cc:	0de010ef          	jal	13aa <printf>

  // check that mmap does allow read/write mapping of a
  // file opened read/write.
  if ((fd = open(f, O_RDWR)) == -1)
     2d0:	4589                	li	a1,2
     2d2:	00001517          	auipc	a0,0x1
     2d6:	34e50513          	addi	a0,a0,846 # 1620 <malloc+0x1be>
     2da:	4ff000ef          	jal	fd8 <open>
     2de:	84aa                	mv	s1,a0
     2e0:	57fd                	li	a5,-1
     2e2:	3cf50b63          	beq	a0,a5,6b8 <mmap_test+0x586>
    err("open (3)");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     2e6:	4781                	li	a5,0
     2e8:	872a                	mv	a4,a0
     2ea:	4685                	li	a3,1
     2ec:	460d                	li	a2,3
     2ee:	658d                	lui	a1,0x3
     2f0:	4501                	li	a0,0
     2f2:	547000ef          	jal	1038 <mmap>
     2f6:	892a                	mv	s2,a0
  if (p == MAP_FAILED)
     2f8:	57fd                	li	a5,-1
     2fa:	3cf50563          	beq	a0,a5,6c4 <mmap_test+0x592>
    err("mmap (4)");
  if (close(fd) == -1)
     2fe:	8526                	mv	a0,s1
     300:	4c1000ef          	jal	fc0 <close>
     304:	57fd                	li	a5,-1
     306:	3cf50563          	beq	a0,a5,6d0 <mmap_test+0x59e>
    err("close (3)");

  // check that the mapping still works after close(fd).
  _v1(p);
     30a:	854a                	mv	a0,s2
     30c:	d1bff0ef          	jal	26 <_v1>

  // write the mapped memory.
  for (i = 0; i < PGSIZE; i++)
     310:	6705                	lui	a4,0x1
     312:	974a                	add	a4,a4,s2
  _v1(p);
     314:	87ca                	mv	a5,s2
    p[i] = 'B';
     316:	04200693          	li	a3,66
     31a:	00d78023          	sb	a3,0(a5) # 1000 <mkdir>
  for (i = 0; i < PGSIZE; i++)
     31e:	0785                	addi	a5,a5,1
     320:	fef71de3          	bne	a4,a5,31a <mmap_test+0x1e8>
     324:	6785                	lui	a5,0x1
     326:	97ca                	add	a5,a5,s2
     328:	6709                	lui	a4,0x2
     32a:	974a                	add	a4,a4,s2
  for (i = PGSIZE; i < PGSIZE*2; i++)
    p[i] = 'C';
     32c:	04300693          	li	a3,67
     330:	00d78023          	sb	a3,0(a5) # 1000 <mkdir>
  for (i = PGSIZE; i < PGSIZE*2; i++)
     334:	0785                	addi	a5,a5,1
     336:	fef71de3          	bne	a4,a5,330 <mmap_test+0x1fe>

  // unmap just the first two of three pages of mapped memory.
  if (munmap(p, PGSIZE*2) == -1)
     33a:	6589                	lui	a1,0x2
     33c:	854a                	mv	a0,s2
     33e:	503000ef          	jal	1040 <munmap>
     342:	57fd                	li	a5,-1
     344:	38f50c63          	beq	a0,a5,6dc <mmap_test+0x5aa>
    err("munmap (3)");

  printf("test mmap read/write: OK\n");
     348:	00001517          	auipc	a0,0x1
     34c:	4a050513          	addi	a0,a0,1184 # 17e8 <malloc+0x386>
     350:	05a010ef          	jal	13aa <printf>

  printf("test mmap dirty\n");
     354:	00001517          	auipc	a0,0x1
     358:	4b450513          	addi	a0,a0,1204 # 1808 <malloc+0x3a6>
     35c:	04e010ef          	jal	13aa <printf>

  // check that the writes to the mapped memory were
  // written to the file.
  if ((fd = open(f, O_RDONLY)) == -1)
     360:	4581                	li	a1,0
     362:	00001517          	auipc	a0,0x1
     366:	2be50513          	addi	a0,a0,702 # 1620 <malloc+0x1be>
     36a:	46f000ef          	jal	fd8 <open>
     36e:	89aa                	mv	s3,a0
     370:	57fd                	li	a5,-1
     372:	36f50b63          	beq	a0,a5,6e8 <mmap_test+0x5b6>
    err("open (4)");
  if(read(fd, buf, PGSIZE) != PGSIZE)
     376:	6605                	lui	a2,0x1
     378:	00003597          	auipc	a1,0x3
     37c:	c9858593          	addi	a1,a1,-872 # 3010 <buf>
     380:	431000ef          	jal	fb0 <read>
     384:	6785                	lui	a5,0x1
     386:	36f51763          	bne	a0,a5,6f4 <mmap_test+0x5c2>
     38a:	00003497          	auipc	s1,0x3
     38e:	c8648493          	addi	s1,s1,-890 # 3010 <buf>
     392:	00004617          	auipc	a2,0x4
     396:	c7e60613          	addi	a2,a2,-898 # 4010 <base>
     39a:	87a6                	mv	a5,s1
    err("dirty read #1");
  for (i = 0; i < PGSIZE; i++){
    if (buf[i] != 'B')
     39c:	04200693          	li	a3,66
     3a0:	0007c703          	lbu	a4,0(a5) # 1000 <mkdir>
     3a4:	34d71e63          	bne	a4,a3,700 <mmap_test+0x5ce>
  for (i = 0; i < PGSIZE; i++){
     3a8:	0785                	addi	a5,a5,1
     3aa:	fec79be3          	bne	a5,a2,3a0 <mmap_test+0x26e>
      err("file page 0 does not contain modifications");
  }
  if(read(fd, buf, PGSIZE) != PGSIZE/2)
     3ae:	6605                	lui	a2,0x1
     3b0:	00003597          	auipc	a1,0x3
     3b4:	c6058593          	addi	a1,a1,-928 # 3010 <buf>
     3b8:	854e                	mv	a0,s3
     3ba:	3f7000ef          	jal	fb0 <read>
     3be:	8005079b          	addiw	a5,a0,-2048
     3c2:	6705                	lui	a4,0x1
     3c4:	80070713          	addi	a4,a4,-2048 # 800 <mmap_test+0x6ce>
     3c8:	9726                	add	a4,a4,s1
    err("dirty read #2");
  for (i = 0; i < PGSIZE/2; i++){
    if (buf[i] != 'C')
     3ca:	04300693          	li	a3,67
  if(read(fd, buf, PGSIZE) != PGSIZE/2)
     3ce:	32079f63          	bnez	a5,70c <mmap_test+0x5da>
    if (buf[i] != 'C')
     3d2:	0004c783          	lbu	a5,0(s1)
     3d6:	34d79163          	bne	a5,a3,718 <mmap_test+0x5e6>
  for (i = 0; i < PGSIZE/2; i++){
     3da:	0485                	addi	s1,s1,1
     3dc:	fee49be3          	bne	s1,a4,3d2 <mmap_test+0x2a0>
      err("file page 1 does not contain modifications");
  }
  if (close(fd) == -1)
     3e0:	854e                	mv	a0,s3
     3e2:	3df000ef          	jal	fc0 <close>
     3e6:	57fd                	li	a5,-1
     3e8:	32f50e63          	beq	a0,a5,724 <mmap_test+0x5f2>
    err("close (4)");

  printf("test mmap dirty: OK\n");
     3ec:	00001517          	auipc	a0,0x1
     3f0:	4d450513          	addi	a0,a0,1236 # 18c0 <malloc+0x45e>
     3f4:	7b7000ef          	jal	13aa <printf>

  printf("test not-mapped unmap\n");
     3f8:	00001517          	auipc	a0,0x1
     3fc:	4e050513          	addi	a0,a0,1248 # 18d8 <malloc+0x476>
     400:	7ab000ef          	jal	13aa <printf>

  // unmap the rest of the mapped memory.
  if (munmap(p+PGSIZE*2, PGSIZE) == -1)
     404:	6585                	lui	a1,0x1
     406:	6509                	lui	a0,0x2
     408:	954a                	add	a0,a0,s2
     40a:	437000ef          	jal	1040 <munmap>
     40e:	57fd                	li	a5,-1
     410:	32f50063          	beq	a0,a5,730 <mmap_test+0x5fe>
    err("munmap (4)");

  printf("test not-mapped unmap: OK\n");
     414:	00001517          	auipc	a0,0x1
     418:	4ec50513          	addi	a0,a0,1260 # 1900 <malloc+0x49e>
     41c:	78f000ef          	jal	13aa <printf>

  printf("test lazy access\n");
     420:	00001517          	auipc	a0,0x1
     424:	50050513          	addi	a0,a0,1280 # 1920 <malloc+0x4be>
     428:	783000ef          	jal	13aa <printf>

  if(unlink(f) != 0) err("unlink");
     42c:	00001517          	auipc	a0,0x1
     430:	1f450513          	addi	a0,a0,500 # 1620 <malloc+0x1be>
     434:	3b5000ef          	jal	fe8 <unlink>
     438:	30051263          	bnez	a0,73c <mmap_test+0x60a>
  makefile(f);
     43c:	00001517          	auipc	a0,0x1
     440:	1e450513          	addi	a0,a0,484 # 1620 <malloc+0x1be>
     444:	c53ff0ef          	jal	96 <makefile>

  if ((fd = open(f, O_RDWR)) == -1)
     448:	4589                	li	a1,2
     44a:	00001517          	auipc	a0,0x1
     44e:	1d650513          	addi	a0,a0,470 # 1620 <malloc+0x1be>
     452:	387000ef          	jal	fd8 <open>
     456:	892a                	mv	s2,a0
     458:	57fd                	li	a5,-1
     45a:	2ef50763          	beq	a0,a5,748 <mmap_test+0x616>
    err("open");
  p = mmap(0, PGSIZE*2, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
     45e:	4781                	li	a5,0
     460:	872a                	mv	a4,a0
     462:	4685                	li	a3,1
     464:	460d                	li	a2,3
     466:	6589                	lui	a1,0x2
     468:	4501                	li	a0,0
     46a:	3cf000ef          	jal	1038 <mmap>
     46e:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     470:	57fd                	li	a5,-1
     472:	2ef50163          	beq	a0,a5,754 <mmap_test+0x622>
    err("mmap");
  close(fd);
     476:	854a                	mv	a0,s2
     478:	349000ef          	jal	fc0 <close>
  // mmap() should not have read the file at this point,
  // so that the file modification we're about to make
  // ought to be visible to a subsequent read of the
  // mapped memory.

  if((fd = open(f, O_RDWR)) == -1)
     47c:	4589                	li	a1,2
     47e:	00001517          	auipc	a0,0x1
     482:	1a250513          	addi	a0,a0,418 # 1620 <malloc+0x1be>
     486:	353000ef          	jal	fd8 <open>
     48a:	892a                	mv	s2,a0
     48c:	57fd                	li	a5,-1
     48e:	2cf50963          	beq	a0,a5,760 <mmap_test+0x62e>
    err("open");
  if(write(fd, "m", 1) != 1)
     492:	4605                	li	a2,1
     494:	00001597          	auipc	a1,0x1
     498:	4b458593          	addi	a1,a1,1204 # 1948 <malloc+0x4e6>
     49c:	31d000ef          	jal	fb8 <write>
     4a0:	4785                	li	a5,1
     4a2:	2cf51563          	bne	a0,a5,76c <mmap_test+0x63a>
    err("write");
  close(fd);
     4a6:	854a                	mv	a0,s2
     4a8:	319000ef          	jal	fc0 <close>

  if(*p != 'm')
     4ac:	0004c703          	lbu	a4,0(s1)
     4b0:	06d00793          	li	a5,109
     4b4:	2cf71263          	bne	a4,a5,778 <mmap_test+0x646>
    err("read was not lazy");

  if(munmap(p, PGSIZE*2) == -1)
     4b8:	6589                	lui	a1,0x2
     4ba:	8526                	mv	a0,s1
     4bc:	385000ef          	jal	1040 <munmap>
     4c0:	57fd                	li	a5,-1
     4c2:	2cf50163          	beq	a0,a5,784 <mmap_test+0x652>
    err("munmap");

  printf("test lazy access: OK\n");
     4c6:	00001517          	auipc	a0,0x1
     4ca:	4b250513          	addi	a0,a0,1202 # 1978 <malloc+0x516>
     4ce:	6dd000ef          	jal	13aa <printf>

  printf("test mmap two files\n");
     4d2:	00001517          	auipc	a0,0x1
     4d6:	4be50513          	addi	a0,a0,1214 # 1990 <malloc+0x52e>
     4da:	6d1000ef          	jal	13aa <printf>

  //
  // mmap two different files at the same time.
  //
  int fd1;
  if((fd1 = open("mmap1", O_RDWR|O_CREATE)) < 0)
     4de:	20200593          	li	a1,514
     4e2:	00001517          	auipc	a0,0x1
     4e6:	4c650513          	addi	a0,a0,1222 # 19a8 <malloc+0x546>
     4ea:	2ef000ef          	jal	fd8 <open>
     4ee:	84aa                	mv	s1,a0
     4f0:	2a054063          	bltz	a0,790 <mmap_test+0x65e>
    err("open (5)");
  if(write(fd1, "12345", 5) != 5)
     4f4:	4615                	li	a2,5
     4f6:	00001597          	auipc	a1,0x1
     4fa:	4ca58593          	addi	a1,a1,1226 # 19c0 <malloc+0x55e>
     4fe:	2bb000ef          	jal	fb8 <write>
     502:	4795                	li	a5,5
     504:	28f51c63          	bne	a0,a5,79c <mmap_test+0x66a>
    err("write (1)");
  char *p1 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
     508:	4781                	li	a5,0
     50a:	8726                	mv	a4,s1
     50c:	4689                	li	a3,2
     50e:	4605                	li	a2,1
     510:	6585                	lui	a1,0x1
     512:	4501                	li	a0,0
     514:	325000ef          	jal	1038 <mmap>
     518:	89aa                	mv	s3,a0
  if(p1 == MAP_FAILED)
     51a:	57fd                	li	a5,-1
     51c:	28f50663          	beq	a0,a5,7a8 <mmap_test+0x676>
    err("mmap (5)");
  if (close(fd1) == -1)
     520:	8526                	mv	a0,s1
     522:	29f000ef          	jal	fc0 <close>
     526:	57fd                	li	a5,-1
     528:	28f50663          	beq	a0,a5,7b4 <mmap_test+0x682>
    err("close (5)");
  if (unlink("mmap1") == -1)
     52c:	00001517          	auipc	a0,0x1
     530:	47c50513          	addi	a0,a0,1148 # 19a8 <malloc+0x546>
     534:	2b5000ef          	jal	fe8 <unlink>
     538:	57fd                	li	a5,-1
     53a:	28f50363          	beq	a0,a5,7c0 <mmap_test+0x68e>
    err("unlink (1)");

  int fd2;
  if((fd2 = open("mmap2", O_RDWR|O_CREATE)) < 0)
     53e:	20200593          	li	a1,514
     542:	00001517          	auipc	a0,0x1
     546:	4c650513          	addi	a0,a0,1222 # 1a08 <malloc+0x5a6>
     54a:	28f000ef          	jal	fd8 <open>
     54e:	892a                	mv	s2,a0
     550:	26054e63          	bltz	a0,7cc <mmap_test+0x69a>
    err("open (6)");
  if(write(fd2, "67890", 5) != 5)
     554:	4615                	li	a2,5
     556:	00001597          	auipc	a1,0x1
     55a:	4ca58593          	addi	a1,a1,1226 # 1a20 <malloc+0x5be>
     55e:	25b000ef          	jal	fb8 <write>
     562:	4795                	li	a5,5
     564:	26f51a63          	bne	a0,a5,7d8 <mmap_test+0x6a6>
    err("write (2)");
  char *p2 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
     568:	4781                	li	a5,0
     56a:	874a                	mv	a4,s2
     56c:	4689                	li	a3,2
     56e:	4605                	li	a2,1
     570:	6585                	lui	a1,0x1
     572:	4501                	li	a0,0
     574:	2c5000ef          	jal	1038 <mmap>
     578:	84aa                	mv	s1,a0
  if(p2 == MAP_FAILED)
     57a:	57fd                	li	a5,-1
     57c:	26f50463          	beq	a0,a5,7e4 <mmap_test+0x6b2>
    err("mmap (6)");
  if (close(fd2) == -1)
     580:	854a                	mv	a0,s2
     582:	23f000ef          	jal	fc0 <close>
     586:	57fd                	li	a5,-1
     588:	26f50463          	beq	a0,a5,7f0 <mmap_test+0x6be>
    err("close (6)");
  if (unlink("mmap2") == -1)
     58c:	00001517          	auipc	a0,0x1
     590:	47c50513          	addi	a0,a0,1148 # 1a08 <malloc+0x5a6>
     594:	255000ef          	jal	fe8 <unlink>
     598:	57fd                	li	a5,-1
     59a:	26f50163          	beq	a0,a5,7fc <mmap_test+0x6ca>
    err("unlink (2)");

  if(memcmp(p1, "12345", 5) != 0)
     59e:	4615                	li	a2,5
     5a0:	00001597          	auipc	a1,0x1
     5a4:	42058593          	addi	a1,a1,1056 # 19c0 <malloc+0x55e>
     5a8:	854e                	mv	a0,s3
     5aa:	195000ef          	jal	f3e <memcmp>
     5ae:	24051d63          	bnez	a0,808 <mmap_test+0x6d6>
    err("mmap1 mismatch");
  if(memcmp(p2, "67890", 5) != 0)
     5b2:	4615                	li	a2,5
     5b4:	00001597          	auipc	a1,0x1
     5b8:	46c58593          	addi	a1,a1,1132 # 1a20 <malloc+0x5be>
     5bc:	8526                	mv	a0,s1
     5be:	181000ef          	jal	f3e <memcmp>
     5c2:	24051963          	bnez	a0,814 <mmap_test+0x6e2>
    err("mmap2 mismatch");

  if (munmap(p1, PGSIZE) == -1)
     5c6:	6585                	lui	a1,0x1
     5c8:	854e                	mv	a0,s3
     5ca:	277000ef          	jal	1040 <munmap>
     5ce:	57fd                	li	a5,-1
     5d0:	24f50863          	beq	a0,a5,820 <mmap_test+0x6ee>
    err("munmap (5)");
  if(memcmp(p2, "67890", 5) != 0)
     5d4:	4615                	li	a2,5
     5d6:	00001597          	auipc	a1,0x1
     5da:	44a58593          	addi	a1,a1,1098 # 1a20 <malloc+0x5be>
     5de:	8526                	mv	a0,s1
     5e0:	15f000ef          	jal	f3e <memcmp>
     5e4:	24051463          	bnez	a0,82c <mmap_test+0x6fa>
    err("mmap2 mismatch (2)");
  if (munmap(p2, PGSIZE) == -1)
     5e8:	6585                	lui	a1,0x1
     5ea:	8526                	mv	a0,s1
     5ec:	255000ef          	jal	1040 <munmap>
     5f0:	57fd                	li	a5,-1
     5f2:	24f50363          	beq	a0,a5,838 <mmap_test+0x706>
    err("munmap (6)");

  printf("test mmap two files: OK\n");
     5f6:	00001517          	auipc	a0,0x1
     5fa:	4ca50513          	addi	a0,a0,1226 # 1ac0 <malloc+0x65e>
     5fe:	5ad000ef          	jal	13aa <printf>
}
     602:	70a2                	ld	ra,40(sp)
     604:	7402                	ld	s0,32(sp)
     606:	64e2                	ld	s1,24(sp)
     608:	6942                	ld	s2,16(sp)
     60a:	69a2                	ld	s3,8(sp)
     60c:	6145                	addi	sp,sp,48
     60e:	8082                	ret
    err("open (1)");
     610:	00001517          	auipc	a0,0x1
     614:	02050513          	addi	a0,a0,32 # 1630 <malloc+0x1ce>
     618:	9e9ff0ef          	jal	0 <err>
    err("mmap (1)");
     61c:	00001517          	auipc	a0,0x1
     620:	03c50513          	addi	a0,a0,60 # 1658 <malloc+0x1f6>
     624:	9ddff0ef          	jal	0 <err>
    err("munmap (1)");
     628:	00001517          	auipc	a0,0x1
     62c:	04050513          	addi	a0,a0,64 # 1668 <malloc+0x206>
     630:	9d1ff0ef          	jal	0 <err>
    err("mmap (2)");
     634:	00001517          	auipc	a0,0x1
     638:	07450513          	addi	a0,a0,116 # 16a8 <malloc+0x246>
     63c:	9c5ff0ef          	jal	0 <err>
    err("close (1)");
     640:	00001517          	auipc	a0,0x1
     644:	07850513          	addi	a0,a0,120 # 16b8 <malloc+0x256>
     648:	9b9ff0ef          	jal	0 <err>
    err("munmap (2)");
     64c:	00001517          	auipc	a0,0x1
     650:	07c50513          	addi	a0,a0,124 # 16c8 <malloc+0x266>
     654:	9adff0ef          	jal	0 <err>
  if((fd = open(f, O_RDONLY)) < 0) err("open");
     658:	00001517          	auipc	a0,0x1
     65c:	fa050513          	addi	a0,a0,-96 # 15f8 <malloc+0x196>
     660:	9a1ff0ef          	jal	0 <err>
  if(read(fd, buf, PGSIZE) != PGSIZE) err("read");
     664:	00001517          	auipc	a0,0x1
     668:	07450513          	addi	a0,a0,116 # 16d8 <malloc+0x276>
     66c:	995ff0ef          	jal	0 <err>
    err("write to MAP_PRIVATE was written to file");
     670:	00001517          	auipc	a0,0x1
     674:	07050513          	addi	a0,a0,112 # 16e0 <malloc+0x27e>
     678:	989ff0ef          	jal	0 <err>
  if(read(fd, buf, PGSIZE) != PGSIZE/2) err("read");
     67c:	00001517          	auipc	a0,0x1
     680:	05c50513          	addi	a0,a0,92 # 16d8 <malloc+0x276>
     684:	97dff0ef          	jal	0 <err>
    err("write to MAP_PRIVATE was written to file");
     688:	00001517          	auipc	a0,0x1
     68c:	05850513          	addi	a0,a0,88 # 16e0 <malloc+0x27e>
     690:	971ff0ef          	jal	0 <err>
    err("open (2)");
     694:	00001517          	auipc	a0,0x1
     698:	0ac50513          	addi	a0,a0,172 # 1740 <malloc+0x2de>
     69c:	965ff0ef          	jal	0 <err>
    err("mmap (3)");
     6a0:	00001517          	auipc	a0,0x1
     6a4:	0b050513          	addi	a0,a0,176 # 1750 <malloc+0x2ee>
     6a8:	959ff0ef          	jal	0 <err>
    err("close (2)");
     6ac:	00001517          	auipc	a0,0x1
     6b0:	0b450513          	addi	a0,a0,180 # 1760 <malloc+0x2fe>
     6b4:	94dff0ef          	jal	0 <err>
    err("open (3)");
     6b8:	00001517          	auipc	a0,0x1
     6bc:	0f050513          	addi	a0,a0,240 # 17a8 <malloc+0x346>
     6c0:	941ff0ef          	jal	0 <err>
    err("mmap (4)");
     6c4:	00001517          	auipc	a0,0x1
     6c8:	0f450513          	addi	a0,a0,244 # 17b8 <malloc+0x356>
     6cc:	935ff0ef          	jal	0 <err>
    err("close (3)");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	0f850513          	addi	a0,a0,248 # 17c8 <malloc+0x366>
     6d8:	929ff0ef          	jal	0 <err>
    err("munmap (3)");
     6dc:	00001517          	auipc	a0,0x1
     6e0:	0fc50513          	addi	a0,a0,252 # 17d8 <malloc+0x376>
     6e4:	91dff0ef          	jal	0 <err>
    err("open (4)");
     6e8:	00001517          	auipc	a0,0x1
     6ec:	13850513          	addi	a0,a0,312 # 1820 <malloc+0x3be>
     6f0:	911ff0ef          	jal	0 <err>
    err("dirty read #1");
     6f4:	00001517          	auipc	a0,0x1
     6f8:	13c50513          	addi	a0,a0,316 # 1830 <malloc+0x3ce>
     6fc:	905ff0ef          	jal	0 <err>
      err("file page 0 does not contain modifications");
     700:	00001517          	auipc	a0,0x1
     704:	14050513          	addi	a0,a0,320 # 1840 <malloc+0x3de>
     708:	8f9ff0ef          	jal	0 <err>
    err("dirty read #2");
     70c:	00001517          	auipc	a0,0x1
     710:	16450513          	addi	a0,a0,356 # 1870 <malloc+0x40e>
     714:	8edff0ef          	jal	0 <err>
      err("file page 1 does not contain modifications");
     718:	00001517          	auipc	a0,0x1
     71c:	16850513          	addi	a0,a0,360 # 1880 <malloc+0x41e>
     720:	8e1ff0ef          	jal	0 <err>
    err("close (4)");
     724:	00001517          	auipc	a0,0x1
     728:	18c50513          	addi	a0,a0,396 # 18b0 <malloc+0x44e>
     72c:	8d5ff0ef          	jal	0 <err>
    err("munmap (4)");
     730:	00001517          	auipc	a0,0x1
     734:	1c050513          	addi	a0,a0,448 # 18f0 <malloc+0x48e>
     738:	8c9ff0ef          	jal	0 <err>
  if(unlink(f) != 0) err("unlink");
     73c:	00001517          	auipc	a0,0x1
     740:	1fc50513          	addi	a0,a0,508 # 1938 <malloc+0x4d6>
     744:	8bdff0ef          	jal	0 <err>
    err("open");
     748:	00001517          	auipc	a0,0x1
     74c:	eb050513          	addi	a0,a0,-336 # 15f8 <malloc+0x196>
     750:	8b1ff0ef          	jal	0 <err>
    err("mmap");
     754:	00001517          	auipc	a0,0x1
     758:	1ec50513          	addi	a0,a0,492 # 1940 <malloc+0x4de>
     75c:	8a5ff0ef          	jal	0 <err>
    err("open");
     760:	00001517          	auipc	a0,0x1
     764:	e9850513          	addi	a0,a0,-360 # 15f8 <malloc+0x196>
     768:	899ff0ef          	jal	0 <err>
    err("write");
     76c:	00001517          	auipc	a0,0x1
     770:	1e450513          	addi	a0,a0,484 # 1950 <malloc+0x4ee>
     774:	88dff0ef          	jal	0 <err>
    err("read was not lazy");
     778:	00001517          	auipc	a0,0x1
     77c:	1e050513          	addi	a0,a0,480 # 1958 <malloc+0x4f6>
     780:	881ff0ef          	jal	0 <err>
    err("munmap");
     784:	00001517          	auipc	a0,0x1
     788:	1ec50513          	addi	a0,a0,492 # 1970 <malloc+0x50e>
     78c:	875ff0ef          	jal	0 <err>
    err("open (5)");
     790:	00001517          	auipc	a0,0x1
     794:	22050513          	addi	a0,a0,544 # 19b0 <malloc+0x54e>
     798:	869ff0ef          	jal	0 <err>
    err("write (1)");
     79c:	00001517          	auipc	a0,0x1
     7a0:	22c50513          	addi	a0,a0,556 # 19c8 <malloc+0x566>
     7a4:	85dff0ef          	jal	0 <err>
    err("mmap (5)");
     7a8:	00001517          	auipc	a0,0x1
     7ac:	23050513          	addi	a0,a0,560 # 19d8 <malloc+0x576>
     7b0:	851ff0ef          	jal	0 <err>
    err("close (5)");
     7b4:	00001517          	auipc	a0,0x1
     7b8:	23450513          	addi	a0,a0,564 # 19e8 <malloc+0x586>
     7bc:	845ff0ef          	jal	0 <err>
    err("unlink (1)");
     7c0:	00001517          	auipc	a0,0x1
     7c4:	23850513          	addi	a0,a0,568 # 19f8 <malloc+0x596>
     7c8:	839ff0ef          	jal	0 <err>
    err("open (6)");
     7cc:	00001517          	auipc	a0,0x1
     7d0:	24450513          	addi	a0,a0,580 # 1a10 <malloc+0x5ae>
     7d4:	82dff0ef          	jal	0 <err>
    err("write (2)");
     7d8:	00001517          	auipc	a0,0x1
     7dc:	25050513          	addi	a0,a0,592 # 1a28 <malloc+0x5c6>
     7e0:	821ff0ef          	jal	0 <err>
    err("mmap (6)");
     7e4:	00001517          	auipc	a0,0x1
     7e8:	25450513          	addi	a0,a0,596 # 1a38 <malloc+0x5d6>
     7ec:	815ff0ef          	jal	0 <err>
    err("close (6)");
     7f0:	00001517          	auipc	a0,0x1
     7f4:	25850513          	addi	a0,a0,600 # 1a48 <malloc+0x5e6>
     7f8:	809ff0ef          	jal	0 <err>
    err("unlink (2)");
     7fc:	00001517          	auipc	a0,0x1
     800:	25c50513          	addi	a0,a0,604 # 1a58 <malloc+0x5f6>
     804:	ffcff0ef          	jal	0 <err>
    err("mmap1 mismatch");
     808:	00001517          	auipc	a0,0x1
     80c:	26050513          	addi	a0,a0,608 # 1a68 <malloc+0x606>
     810:	ff0ff0ef          	jal	0 <err>
    err("mmap2 mismatch");
     814:	00001517          	auipc	a0,0x1
     818:	26450513          	addi	a0,a0,612 # 1a78 <malloc+0x616>
     81c:	fe4ff0ef          	jal	0 <err>
    err("munmap (5)");
     820:	00001517          	auipc	a0,0x1
     824:	26850513          	addi	a0,a0,616 # 1a88 <malloc+0x626>
     828:	fd8ff0ef          	jal	0 <err>
    err("mmap2 mismatch (2)");
     82c:	00001517          	auipc	a0,0x1
     830:	26c50513          	addi	a0,a0,620 # 1a98 <malloc+0x636>
     834:	fccff0ef          	jal	0 <err>
    err("munmap (6)");
     838:	00001517          	auipc	a0,0x1
     83c:	27850513          	addi	a0,a0,632 # 1ab0 <malloc+0x64e>
     840:	fc0ff0ef          	jal	0 <err>

0000000000000844 <fork_test>:
// mmap a file, then fork.
// check that the child sees the mapped file.
//
void
fork_test(void)
{
     844:	7179                	addi	sp,sp,-48
     846:	f406                	sd	ra,40(sp)
     848:	f022                	sd	s0,32(sp)
     84a:	ec26                	sd	s1,24(sp)
     84c:	e84a                	sd	s2,16(sp)
     84e:	1800                	addi	s0,sp,48
  int fd;
  int pid;
  const char * const f = "mmap.dur";

  printf("test fork\n");
     850:	00001517          	auipc	a0,0x1
     854:	29050513          	addi	a0,a0,656 # 1ae0 <malloc+0x67e>
     858:	353000ef          	jal	13aa <printf>

  // mmap the file twice.
  makefile(f);
     85c:	00001517          	auipc	a0,0x1
     860:	dc450513          	addi	a0,a0,-572 # 1620 <malloc+0x1be>
     864:	833ff0ef          	jal	96 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     868:	4581                	li	a1,0
     86a:	00001517          	auipc	a0,0x1
     86e:	db650513          	addi	a0,a0,-586 # 1620 <malloc+0x1be>
     872:	766000ef          	jal	fd8 <open>
     876:	57fd                	li	a5,-1
     878:	06f50e63          	beq	a0,a5,8f4 <fork_test+0xb0>
     87c:	892a                	mv	s2,a0
    err("open (7)");
  if (unlink(f) == -1)
     87e:	00001517          	auipc	a0,0x1
     882:	da250513          	addi	a0,a0,-606 # 1620 <malloc+0x1be>
     886:	762000ef          	jal	fe8 <unlink>
     88a:	57fd                	li	a5,-1
     88c:	06f50a63          	beq	a0,a5,900 <fork_test+0xbc>
    err("unlink (3)");
  char *p1 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     890:	4781                	li	a5,0
     892:	874a                	mv	a4,s2
     894:	4685                	li	a3,1
     896:	8636                	mv	a2,a3
     898:	6589                	lui	a1,0x2
     89a:	4501                	li	a0,0
     89c:	79c000ef          	jal	1038 <mmap>
     8a0:	84aa                	mv	s1,a0
  if (p1 == MAP_FAILED)
     8a2:	57fd                	li	a5,-1
     8a4:	06f50463          	beq	a0,a5,90c <fork_test+0xc8>
    err("mmap (7)");
  char *p2 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     8a8:	4781                	li	a5,0
     8aa:	874a                	mv	a4,s2
     8ac:	4685                	li	a3,1
     8ae:	8636                	mv	a2,a3
     8b0:	6589                	lui	a1,0x2
     8b2:	4501                	li	a0,0
     8b4:	784000ef          	jal	1038 <mmap>
     8b8:	892a                	mv	s2,a0
  if (p2 == MAP_FAILED)
     8ba:	57fd                	li	a5,-1
     8bc:	04f50e63          	beq	a0,a5,918 <fork_test+0xd4>
    err("mmap (8)");

  // read just 2nd page.
  if(*(p1+PGSIZE) != 'A')
     8c0:	6785                	lui	a5,0x1
     8c2:	97a6                	add	a5,a5,s1
     8c4:	0007c703          	lbu	a4,0(a5) # 1000 <mkdir>
     8c8:	04100793          	li	a5,65
     8cc:	04f71c63          	bne	a4,a5,924 <fork_test+0xe0>
    err("fork mismatch (1)");

  if((pid = fork()) < 0)
     8d0:	6c0000ef          	jal	f90 <fork>
     8d4:	04054e63          	bltz	a0,930 <fork_test+0xec>
    err("fork");
  if (pid == 0) {
     8d8:	e925                	bnez	a0,948 <fork_test+0x104>
    _v1(p1);
     8da:	8526                	mv	a0,s1
     8dc:	f4aff0ef          	jal	26 <_v1>
    if (munmap(p1, PGSIZE) == -1) // just the first page
     8e0:	6585                	lui	a1,0x1
     8e2:	8526                	mv	a0,s1
     8e4:	75c000ef          	jal	1040 <munmap>
     8e8:	57fd                	li	a5,-1
     8ea:	04f50963          	beq	a0,a5,93c <fork_test+0xf8>
      err("munmap (7)");
    exit(0); // tell the parent that the mapping looks OK.
     8ee:	4501                	li	a0,0
     8f0:	6a8000ef          	jal	f98 <exit>
    err("open (7)");
     8f4:	00001517          	auipc	a0,0x1
     8f8:	1fc50513          	addi	a0,a0,508 # 1af0 <malloc+0x68e>
     8fc:	f04ff0ef          	jal	0 <err>
    err("unlink (3)");
     900:	00001517          	auipc	a0,0x1
     904:	20050513          	addi	a0,a0,512 # 1b00 <malloc+0x69e>
     908:	ef8ff0ef          	jal	0 <err>
    err("mmap (7)");
     90c:	00001517          	auipc	a0,0x1
     910:	20450513          	addi	a0,a0,516 # 1b10 <malloc+0x6ae>
     914:	eecff0ef          	jal	0 <err>
    err("mmap (8)");
     918:	00001517          	auipc	a0,0x1
     91c:	20850513          	addi	a0,a0,520 # 1b20 <malloc+0x6be>
     920:	ee0ff0ef          	jal	0 <err>
    err("fork mismatch (1)");
     924:	00001517          	auipc	a0,0x1
     928:	20c50513          	addi	a0,a0,524 # 1b30 <malloc+0x6ce>
     92c:	ed4ff0ef          	jal	0 <err>
    err("fork");
     930:	00001517          	auipc	a0,0x1
     934:	21850513          	addi	a0,a0,536 # 1b48 <malloc+0x6e6>
     938:	ec8ff0ef          	jal	0 <err>
      err("munmap (7)");
     93c:	00001517          	auipc	a0,0x1
     940:	21450513          	addi	a0,a0,532 # 1b50 <malloc+0x6ee>
     944:	ebcff0ef          	jal	0 <err>
  }

  int status = -1;
     948:	57fd                	li	a5,-1
     94a:	fcf42e23          	sw	a5,-36(s0)
  wait(&status);
     94e:	fdc40513          	addi	a0,s0,-36
     952:	64e000ef          	jal	fa0 <wait>

  if(status != 0){
     956:	fdc42783          	lw	a5,-36(s0)
     95a:	e39d                	bnez	a5,980 <fork_test+0x13c>
    printf("fork_test failed\n");
    exit(1);
  }

  // check that the parent's mappings are still there.
  _v1(p1);
     95c:	8526                	mv	a0,s1
     95e:	ec8ff0ef          	jal	26 <_v1>
  _v1(p2);
     962:	854a                	mv	a0,s2
     964:	ec2ff0ef          	jal	26 <_v1>

  printf("test fork: OK\n");
     968:	00001517          	auipc	a0,0x1
     96c:	21050513          	addi	a0,a0,528 # 1b78 <malloc+0x716>
     970:	23b000ef          	jal	13aa <printf>
}
     974:	70a2                	ld	ra,40(sp)
     976:	7402                	ld	s0,32(sp)
     978:	64e2                	ld	s1,24(sp)
     97a:	6942                	ld	s2,16(sp)
     97c:	6145                	addi	sp,sp,48
     97e:	8082                	ret
    printf("fork_test failed\n");
     980:	00001517          	auipc	a0,0x1
     984:	1e050513          	addi	a0,a0,480 # 1b60 <malloc+0x6fe>
     988:	223000ef          	jal	13aa <printf>
    exit(1);
     98c:	4505                	li	a0,1
     98e:	60a000ef          	jal	f98 <exit>

0000000000000992 <more_test>:

void
more_test()
{
     992:	7179                	addi	sp,sp,-48
     994:	f406                	sd	ra,40(sp)
     996:	f022                	sd	s0,32(sp)
     998:	ec26                	sd	s1,24(sp)
     99a:	e84a                	sd	s2,16(sp)
     99c:	1800                	addi	s0,sp,48
  int fd, pid;
  char *p;
  const char * const f = "mmap.dur";
  
  printf("test munmap prevents access\n");
     99e:	00001517          	auipc	a0,0x1
     9a2:	1ea50513          	addi	a0,a0,490 # 1b88 <malloc+0x726>
     9a6:	205000ef          	jal	13aa <printf>
  
  makefile(f);
     9aa:	00001517          	auipc	a0,0x1
     9ae:	c7650513          	addi	a0,a0,-906 # 1620 <malloc+0x1be>
     9b2:	ee4ff0ef          	jal	96 <makefile>
  if ((fd = open(f, O_RDWR)) == -1)
     9b6:	4589                	li	a1,2
     9b8:	00001517          	auipc	a0,0x1
     9bc:	c6850513          	addi	a0,a0,-920 # 1620 <malloc+0x1be>
     9c0:	618000ef          	jal	fd8 <open>
     9c4:	57fd                	li	a5,-1
     9c6:	06f50e63          	beq	a0,a5,a42 <more_test+0xb0>
     9ca:	892a                	mv	s2,a0
    err("open");
  p = mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     9cc:	4781                	li	a5,0
     9ce:	872a                	mv	a4,a0
     9d0:	4685                	li	a3,1
     9d2:	460d                	li	a2,3
     9d4:	6589                	lui	a1,0x2
     9d6:	4501                	li	a0,0
     9d8:	660000ef          	jal	1038 <mmap>
     9dc:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     9de:	57fd                	li	a5,-1
     9e0:	06f50763          	beq	a0,a5,a4e <more_test+0xbc>
    err("mmap");
  close(fd);
     9e4:	854a                	mv	a0,s2
     9e6:	5da000ef          	jal	fc0 <close>

  *p = 'X';
     9ea:	05800793          	li	a5,88
     9ee:	00f48023          	sb	a5,0(s1)
  *(p+PGSIZE) = 'Y';
     9f2:	6785                	lui	a5,0x1
     9f4:	97a6                	add	a5,a5,s1
     9f6:	05900713          	li	a4,89
     9fa:	00e78023          	sb	a4,0(a5) # 1000 <mkdir>

  pid = fork();
     9fe:	592000ef          	jal	f90 <fork>
  if(pid < 0) err("fork");
     a02:	04054c63          	bltz	a0,a5a <more_test+0xc8>
  if(pid == 0){
     a06:	e535                	bnez	a0,a72 <more_test+0xe0>
    *p = 'a';
     a08:	06100793          	li	a5,97
     a0c:	00f48023          	sb	a5,0(s1)
    *(p+PGSIZE) = 'b';
     a10:	6585                	lui	a1,0x1
     a12:	00b48533          	add	a0,s1,a1
     a16:	06200793          	li	a5,98
     a1a:	00f50023          	sb	a5,0(a0)
    if(munmap(p+PGSIZE, PGSIZE) == -1)
     a1e:	622000ef          	jal	1040 <munmap>
     a22:	57fd                	li	a5,-1
     a24:	04f50163          	beq	a0,a5,a66 <more_test+0xd4>
      err("munmap");
    // this should cause a fatal fault
    printf("*(p+PGSIZE) = %x\n", *(p+PGSIZE));
     a28:	6785                	lui	a5,0x1
     a2a:	97a6                	add	a5,a5,s1
     a2c:	0007c583          	lbu	a1,0(a5) # 1000 <mkdir>
     a30:	00001517          	auipc	a0,0x1
     a34:	17850513          	addi	a0,a0,376 # 1ba8 <malloc+0x746>
     a38:	173000ef          	jal	13aa <printf>
    exit(0);
     a3c:	4501                	li	a0,0
     a3e:	55a000ef          	jal	f98 <exit>
    err("open");
     a42:	00001517          	auipc	a0,0x1
     a46:	bb650513          	addi	a0,a0,-1098 # 15f8 <malloc+0x196>
     a4a:	db6ff0ef          	jal	0 <err>
    err("mmap");
     a4e:	00001517          	auipc	a0,0x1
     a52:	ef250513          	addi	a0,a0,-270 # 1940 <malloc+0x4de>
     a56:	daaff0ef          	jal	0 <err>
  if(pid < 0) err("fork");
     a5a:	00001517          	auipc	a0,0x1
     a5e:	0ee50513          	addi	a0,a0,238 # 1b48 <malloc+0x6e6>
     a62:	d9eff0ef          	jal	0 <err>
      err("munmap");
     a66:	00001517          	auipc	a0,0x1
     a6a:	f0a50513          	addi	a0,a0,-246 # 1970 <malloc+0x50e>
     a6e:	d92ff0ef          	jal	0 <err>
  }
  int st = 0;
     a72:	fc042e23          	sw	zero,-36(s0)
  wait(&st);
     a76:	fdc40513          	addi	a0,s0,-36
     a7a:	526000ef          	jal	fa0 <wait>
  if(st != -1)
     a7e:	fdc42703          	lw	a4,-36(s0)
     a82:	57fd                	li	a5,-1
     a84:	04f71363          	bne	a4,a5,aca <more_test+0x138>
    err("child #1 read unmapped memory");

  pid = fork();
     a88:	508000ef          	jal	f90 <fork>
  if(pid < 0) err("fork");
     a8c:	04054563          	bltz	a0,ad6 <more_test+0x144>
  if(pid == 0){
     a90:	ed39                	bnez	a0,aee <more_test+0x15c>
    *p = 'c';
     a92:	06300793          	li	a5,99
     a96:	00f48023          	sb	a5,0(s1)
    *(p+PGSIZE) = 'd';
     a9a:	6585                	lui	a1,0x1
     a9c:	00b487b3          	add	a5,s1,a1
     aa0:	06400713          	li	a4,100
     aa4:	00e78023          	sb	a4,0(a5)
    if(munmap(p, PGSIZE) == -1)
     aa8:	8526                	mv	a0,s1
     aaa:	596000ef          	jal	1040 <munmap>
     aae:	57fd                	li	a5,-1
     ab0:	02f50963          	beq	a0,a5,ae2 <more_test+0x150>
      err("munmap");
    // this should cause a fatal fault
    printf("*p = %x\n", *p);
     ab4:	0004c583          	lbu	a1,0(s1)
     ab8:	00001517          	auipc	a0,0x1
     abc:	12850513          	addi	a0,a0,296 # 1be0 <malloc+0x77e>
     ac0:	0eb000ef          	jal	13aa <printf>
    exit(0);
     ac4:	4501                	li	a0,0
     ac6:	4d2000ef          	jal	f98 <exit>
    err("child #1 read unmapped memory");
     aca:	00001517          	auipc	a0,0x1
     ace:	0f650513          	addi	a0,a0,246 # 1bc0 <malloc+0x75e>
     ad2:	d2eff0ef          	jal	0 <err>
  if(pid < 0) err("fork");
     ad6:	00001517          	auipc	a0,0x1
     ada:	07250513          	addi	a0,a0,114 # 1b48 <malloc+0x6e6>
     ade:	d22ff0ef          	jal	0 <err>
      err("munmap");
     ae2:	00001517          	auipc	a0,0x1
     ae6:	e8e50513          	addi	a0,a0,-370 # 1970 <malloc+0x50e>
     aea:	d16ff0ef          	jal	0 <err>
  }
  st = 0;
     aee:	fc042e23          	sw	zero,-36(s0)
  wait(&st);
     af2:	fdc40513          	addi	a0,s0,-36
     af6:	4aa000ef          	jal	fa0 <wait>
  if(st != -1)
     afa:	fdc42703          	lw	a4,-36(s0)
     afe:	57fd                	li	a5,-1
     b00:	10f71b63          	bne	a4,a5,c16 <more_test+0x284>
    err("child #2 read unmapped memory");

  // parent should still be able to access the memory.
  *p = 'P';
     b04:	05000793          	li	a5,80
     b08:	00f48023          	sb	a5,0(s1)
  *(p+PGSIZE) = 'Q';
     b0c:	6585                	lui	a1,0x1
     b0e:	00b487b3          	add	a5,s1,a1
     b12:	05100713          	li	a4,81
     b16:	00e78023          	sb	a4,0(a5)

  if(munmap(p, PGSIZE) == -1)
     b1a:	8526                	mv	a0,s1
     b1c:	524000ef          	jal	1040 <munmap>
     b20:	57fd                	li	a5,-1
     b22:	10f50063          	beq	a0,a5,c22 <more_test+0x290>
    err("munmap");

  *(p+PGSIZE) = 'R';
     b26:	6585                	lui	a1,0x1
     b28:	00b48533          	add	a0,s1,a1
     b2c:	05200793          	li	a5,82
     b30:	00f50023          	sb	a5,0(a0)
  if(munmap(p+PGSIZE, PGSIZE) == -1)
     b34:	50c000ef          	jal	1040 <munmap>
     b38:	57fd                	li	a5,-1
     b3a:	0ef50a63          	beq	a0,a5,c2e <more_test+0x29c>
    err("munmap");

  // read the file, check that the first page starts
  // with P and the second page with R.
  fd = open(f, O_RDONLY);
     b3e:	4581                	li	a1,0
     b40:	00001517          	auipc	a0,0x1
     b44:	ae050513          	addi	a0,a0,-1312 # 1620 <malloc+0x1be>
     b48:	490000ef          	jal	fd8 <open>
     b4c:	84aa                	mv	s1,a0
  if(fd < 0) err("open");
     b4e:	0e054663          	bltz	a0,c3a <more_test+0x2a8>
  if(read(fd, buf, PGSIZE) != PGSIZE) err("read");
     b52:	6605                	lui	a2,0x1
     b54:	00002597          	auipc	a1,0x2
     b58:	4bc58593          	addi	a1,a1,1212 # 3010 <buf>
     b5c:	454000ef          	jal	fb0 <read>
     b60:	6785                	lui	a5,0x1
     b62:	0ef51263          	bne	a0,a5,c46 <more_test+0x2b4>
  if(buf[0] != 'P') err("first byte of file is wrong");
     b66:	00002717          	auipc	a4,0x2
     b6a:	4aa74703          	lbu	a4,1194(a4) # 3010 <buf>
     b6e:	05000793          	li	a5,80
     b72:	0ef71063          	bne	a4,a5,c52 <more_test+0x2c0>
  if(read(fd, buf, PGSIZE) != PGSIZE/2) err("read");
     b76:	6605                	lui	a2,0x1
     b78:	00002597          	auipc	a1,0x2
     b7c:	49858593          	addi	a1,a1,1176 # 3010 <buf>
     b80:	8526                	mv	a0,s1
     b82:	42e000ef          	jal	fb0 <read>
     b86:	8005051b          	addiw	a0,a0,-2048
     b8a:	0c051a63          	bnez	a0,c5e <more_test+0x2cc>
  if(buf[0] != 'R') err("first byte of 2nd page of file is wrong");
     b8e:	00002717          	auipc	a4,0x2
     b92:	48274703          	lbu	a4,1154(a4) # 3010 <buf>
     b96:	05200793          	li	a5,82
     b9a:	0cf71863          	bne	a4,a5,c6a <more_test+0x2d8>
  close(fd);
     b9e:	8526                	mv	a0,s1
     ba0:	420000ef          	jal	fc0 <close>

  printf("test munmap prevents access: OK\n");
     ba4:	00001517          	auipc	a0,0x1
     ba8:	0b450513          	addi	a0,a0,180 # 1c58 <malloc+0x7f6>
     bac:	7fe000ef          	jal	13aa <printf>

  printf("test writes to read-only mapped memory\n");
     bb0:	00001517          	auipc	a0,0x1
     bb4:	0d050513          	addi	a0,a0,208 # 1c80 <malloc+0x81e>
     bb8:	7f2000ef          	jal	13aa <printf>

  makefile(f);
     bbc:	00001517          	auipc	a0,0x1
     bc0:	a6450513          	addi	a0,a0,-1436 # 1620 <malloc+0x1be>
     bc4:	cd2ff0ef          	jal	96 <makefile>

  pid = fork();
     bc8:	3c8000ef          	jal	f90 <fork>
  if(pid < 0) err("fork");
     bcc:	0a054563          	bltz	a0,c76 <more_test+0x2e4>
  if(pid == 0){
     bd0:	0c051563          	bnez	a0,c9a <more_test+0x308>
    if ((fd = open(f, O_RDWR)) == -1)
     bd4:	4589                	li	a1,2
     bd6:	00001517          	auipc	a0,0x1
     bda:	a4a50513          	addi	a0,a0,-1462 # 1620 <malloc+0x1be>
     bde:	3fa000ef          	jal	fd8 <open>
     be2:	872a                	mv	a4,a0
     be4:	57fd                	li	a5,-1
     be6:	08f50e63          	beq	a0,a5,c82 <more_test+0x2f0>
      err("open");
    p = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     bea:	4781                	li	a5,0
     bec:	4685                	li	a3,1
     bee:	8636                	mv	a2,a3
     bf0:	6589                	lui	a1,0x2
     bf2:	4501                	li	a0,0
     bf4:	444000ef          	jal	1038 <mmap>
     bf8:	84aa                	mv	s1,a0
    if (p == MAP_FAILED)
     bfa:	57fd                	li	a5,-1
     bfc:	08f50963          	beq	a0,a5,c8e <more_test+0x2fc>
      err("mmap");
    printf("here\n");
     c00:	00001517          	auipc	a0,0x1
     c04:	0a850513          	addi	a0,a0,168 # 1ca8 <malloc+0x846>
     c08:	7a2000ef          	jal	13aa <printf>
    // this should cause a fatal fault
    *p = 0;
     c0c:	00048023          	sb	zero,0(s1)
    exit(*p);
     c10:	4501                	li	a0,0
     c12:	386000ef          	jal	f98 <exit>
    err("child #2 read unmapped memory");
     c16:	00001517          	auipc	a0,0x1
     c1a:	fda50513          	addi	a0,a0,-38 # 1bf0 <malloc+0x78e>
     c1e:	be2ff0ef          	jal	0 <err>
    err("munmap");
     c22:	00001517          	auipc	a0,0x1
     c26:	d4e50513          	addi	a0,a0,-690 # 1970 <malloc+0x50e>
     c2a:	bd6ff0ef          	jal	0 <err>
    err("munmap");
     c2e:	00001517          	auipc	a0,0x1
     c32:	d4250513          	addi	a0,a0,-702 # 1970 <malloc+0x50e>
     c36:	bcaff0ef          	jal	0 <err>
  if(fd < 0) err("open");
     c3a:	00001517          	auipc	a0,0x1
     c3e:	9be50513          	addi	a0,a0,-1602 # 15f8 <malloc+0x196>
     c42:	bbeff0ef          	jal	0 <err>
  if(read(fd, buf, PGSIZE) != PGSIZE) err("read");
     c46:	00001517          	auipc	a0,0x1
     c4a:	a9250513          	addi	a0,a0,-1390 # 16d8 <malloc+0x276>
     c4e:	bb2ff0ef          	jal	0 <err>
  if(buf[0] != 'P') err("first byte of file is wrong");
     c52:	00001517          	auipc	a0,0x1
     c56:	fbe50513          	addi	a0,a0,-66 # 1c10 <malloc+0x7ae>
     c5a:	ba6ff0ef          	jal	0 <err>
  if(read(fd, buf, PGSIZE) != PGSIZE/2) err("read");
     c5e:	00001517          	auipc	a0,0x1
     c62:	a7a50513          	addi	a0,a0,-1414 # 16d8 <malloc+0x276>
     c66:	b9aff0ef          	jal	0 <err>
  if(buf[0] != 'R') err("first byte of 2nd page of file is wrong");
     c6a:	00001517          	auipc	a0,0x1
     c6e:	fc650513          	addi	a0,a0,-58 # 1c30 <malloc+0x7ce>
     c72:	b8eff0ef          	jal	0 <err>
  if(pid < 0) err("fork");
     c76:	00001517          	auipc	a0,0x1
     c7a:	ed250513          	addi	a0,a0,-302 # 1b48 <malloc+0x6e6>
     c7e:	b82ff0ef          	jal	0 <err>
      err("open");
     c82:	00001517          	auipc	a0,0x1
     c86:	97650513          	addi	a0,a0,-1674 # 15f8 <malloc+0x196>
     c8a:	b76ff0ef          	jal	0 <err>
      err("mmap");
     c8e:	00001517          	auipc	a0,0x1
     c92:	cb250513          	addi	a0,a0,-846 # 1940 <malloc+0x4de>
     c96:	b6aff0ef          	jal	0 <err>
  }

  st = 0;
     c9a:	fc042e23          	sw	zero,-36(s0)
  wait(&st);
     c9e:	fdc40513          	addi	a0,s0,-36
     ca2:	2fe000ef          	jal	fa0 <wait>
  if(st != -1)
     ca6:	fdc42703          	lw	a4,-36(s0)
     caa:	57fd                	li	a5,-1
     cac:	00f71e63          	bne	a4,a5,cc8 <more_test+0x336>
    err("child wrote read-only mapping");

  printf("test writes to read-only mapped memory: OK\n");
     cb0:	00001517          	auipc	a0,0x1
     cb4:	02050513          	addi	a0,a0,32 # 1cd0 <malloc+0x86e>
     cb8:	6f2000ef          	jal	13aa <printf>
}
     cbc:	70a2                	ld	ra,40(sp)
     cbe:	7402                	ld	s0,32(sp)
     cc0:	64e2                	ld	s1,24(sp)
     cc2:	6942                	ld	s2,16(sp)
     cc4:	6145                	addi	sp,sp,48
     cc6:	8082                	ret
    err("child wrote read-only mapping");
     cc8:	00001517          	auipc	a0,0x1
     ccc:	fe850513          	addi	a0,a0,-24 # 1cb0 <malloc+0x84e>
     cd0:	b30ff0ef          	jal	0 <err>

0000000000000cd4 <main>:
{
     cd4:	1141                	addi	sp,sp,-16
     cd6:	e406                	sd	ra,8(sp)
     cd8:	e022                	sd	s0,0(sp)
     cda:	0800                	addi	s0,sp,16
  mmap_test();
     cdc:	c56ff0ef          	jal	132 <mmap_test>
  fork_test();
     ce0:	b65ff0ef          	jal	844 <fork_test>
  more_test();
     ce4:	cafff0ef          	jal	992 <more_test>
  printf("mmaptest: all tests succeeded\n");
     ce8:	00001517          	auipc	a0,0x1
     cec:	01850513          	addi	a0,a0,24 # 1d00 <malloc+0x89e>
     cf0:	6ba000ef          	jal	13aa <printf>
  exit(0);
     cf4:	4501                	li	a0,0
     cf6:	2a2000ef          	jal	f98 <exit>

0000000000000cfa <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     cfa:	1141                	addi	sp,sp,-16
     cfc:	e406                	sd	ra,8(sp)
     cfe:	e022                	sd	s0,0(sp)
     d00:	0800                	addi	s0,sp,16
  extern int main();
  main();
     d02:	fd3ff0ef          	jal	cd4 <main>
  exit(0);
     d06:	4501                	li	a0,0
     d08:	290000ef          	jal	f98 <exit>

0000000000000d0c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     d0c:	1141                	addi	sp,sp,-16
     d0e:	e406                	sd	ra,8(sp)
     d10:	e022                	sd	s0,0(sp)
     d12:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     d14:	87aa                	mv	a5,a0
     d16:	0585                	addi	a1,a1,1 # 2001 <digits+0x2d9>
     d18:	0785                	addi	a5,a5,1 # 1001 <mkdir+0x1>
     d1a:	fff5c703          	lbu	a4,-1(a1)
     d1e:	fee78fa3          	sb	a4,-1(a5)
     d22:	fb75                	bnez	a4,d16 <strcpy+0xa>
    ;
  return os;
}
     d24:	60a2                	ld	ra,8(sp)
     d26:	6402                	ld	s0,0(sp)
     d28:	0141                	addi	sp,sp,16
     d2a:	8082                	ret

0000000000000d2c <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d2c:	1141                	addi	sp,sp,-16
     d2e:	e406                	sd	ra,8(sp)
     d30:	e022                	sd	s0,0(sp)
     d32:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     d34:	00054783          	lbu	a5,0(a0)
     d38:	cb91                	beqz	a5,d4c <strcmp+0x20>
     d3a:	0005c703          	lbu	a4,0(a1)
     d3e:	00f71763          	bne	a4,a5,d4c <strcmp+0x20>
    p++, q++;
     d42:	0505                	addi	a0,a0,1
     d44:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     d46:	00054783          	lbu	a5,0(a0)
     d4a:	fbe5                	bnez	a5,d3a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     d4c:	0005c503          	lbu	a0,0(a1)
}
     d50:	40a7853b          	subw	a0,a5,a0
     d54:	60a2                	ld	ra,8(sp)
     d56:	6402                	ld	s0,0(sp)
     d58:	0141                	addi	sp,sp,16
     d5a:	8082                	ret

0000000000000d5c <strlen>:

uint
strlen(const char *s)
{
     d5c:	1141                	addi	sp,sp,-16
     d5e:	e406                	sd	ra,8(sp)
     d60:	e022                	sd	s0,0(sp)
     d62:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     d64:	00054783          	lbu	a5,0(a0)
     d68:	cf99                	beqz	a5,d86 <strlen+0x2a>
     d6a:	0505                	addi	a0,a0,1
     d6c:	87aa                	mv	a5,a0
     d6e:	86be                	mv	a3,a5
     d70:	0785                	addi	a5,a5,1
     d72:	fff7c703          	lbu	a4,-1(a5)
     d76:	ff65                	bnez	a4,d6e <strlen+0x12>
     d78:	40a6853b          	subw	a0,a3,a0
     d7c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     d7e:	60a2                	ld	ra,8(sp)
     d80:	6402                	ld	s0,0(sp)
     d82:	0141                	addi	sp,sp,16
     d84:	8082                	ret
  for(n = 0; s[n]; n++)
     d86:	4501                	li	a0,0
     d88:	bfdd                	j	d7e <strlen+0x22>

0000000000000d8a <memset>:

void*
memset(void *dst, int c, uint n)
{
     d8a:	1141                	addi	sp,sp,-16
     d8c:	e406                	sd	ra,8(sp)
     d8e:	e022                	sd	s0,0(sp)
     d90:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     d92:	ca19                	beqz	a2,da8 <memset+0x1e>
     d94:	87aa                	mv	a5,a0
     d96:	1602                	slli	a2,a2,0x20
     d98:	9201                	srli	a2,a2,0x20
     d9a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     d9e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     da2:	0785                	addi	a5,a5,1
     da4:	fee79de3          	bne	a5,a4,d9e <memset+0x14>
  }
  return dst;
}
     da8:	60a2                	ld	ra,8(sp)
     daa:	6402                	ld	s0,0(sp)
     dac:	0141                	addi	sp,sp,16
     dae:	8082                	ret

0000000000000db0 <strchr>:

char*
strchr(const char *s, char c)
{
     db0:	1141                	addi	sp,sp,-16
     db2:	e406                	sd	ra,8(sp)
     db4:	e022                	sd	s0,0(sp)
     db6:	0800                	addi	s0,sp,16
  for(; *s; s++)
     db8:	00054783          	lbu	a5,0(a0)
     dbc:	cf81                	beqz	a5,dd4 <strchr+0x24>
    if(*s == c)
     dbe:	00f58763          	beq	a1,a5,dcc <strchr+0x1c>
  for(; *s; s++)
     dc2:	0505                	addi	a0,a0,1
     dc4:	00054783          	lbu	a5,0(a0)
     dc8:	fbfd                	bnez	a5,dbe <strchr+0xe>
      return (char*)s;
  return 0;
     dca:	4501                	li	a0,0
}
     dcc:	60a2                	ld	ra,8(sp)
     dce:	6402                	ld	s0,0(sp)
     dd0:	0141                	addi	sp,sp,16
     dd2:	8082                	ret
  return 0;
     dd4:	4501                	li	a0,0
     dd6:	bfdd                	j	dcc <strchr+0x1c>

0000000000000dd8 <gets>:

char*
gets(char *buf, int max)
{
     dd8:	7159                	addi	sp,sp,-112
     dda:	f486                	sd	ra,104(sp)
     ddc:	f0a2                	sd	s0,96(sp)
     dde:	eca6                	sd	s1,88(sp)
     de0:	e8ca                	sd	s2,80(sp)
     de2:	e4ce                	sd	s3,72(sp)
     de4:	e0d2                	sd	s4,64(sp)
     de6:	fc56                	sd	s5,56(sp)
     de8:	f85a                	sd	s6,48(sp)
     dea:	f45e                	sd	s7,40(sp)
     dec:	f062                	sd	s8,32(sp)
     dee:	ec66                	sd	s9,24(sp)
     df0:	e86a                	sd	s10,16(sp)
     df2:	1880                	addi	s0,sp,112
     df4:	8caa                	mv	s9,a0
     df6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     df8:	892a                	mv	s2,a0
     dfa:	4481                	li	s1,0
    cc = read(0, &c, 1);
     dfc:	f9f40b13          	addi	s6,s0,-97
     e00:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     e02:	4ba9                	li	s7,10
     e04:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     e06:	8d26                	mv	s10,s1
     e08:	0014899b          	addiw	s3,s1,1
     e0c:	84ce                	mv	s1,s3
     e0e:	0349d563          	bge	s3,s4,e38 <gets+0x60>
    cc = read(0, &c, 1);
     e12:	8656                	mv	a2,s5
     e14:	85da                	mv	a1,s6
     e16:	4501                	li	a0,0
     e18:	198000ef          	jal	fb0 <read>
    if(cc < 1)
     e1c:	00a05e63          	blez	a0,e38 <gets+0x60>
    buf[i++] = c;
     e20:	f9f44783          	lbu	a5,-97(s0)
     e24:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     e28:	01778763          	beq	a5,s7,e36 <gets+0x5e>
     e2c:	0905                	addi	s2,s2,1
     e2e:	fd879ce3          	bne	a5,s8,e06 <gets+0x2e>
    buf[i++] = c;
     e32:	8d4e                	mv	s10,s3
     e34:	a011                	j	e38 <gets+0x60>
     e36:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     e38:	9d66                	add	s10,s10,s9
     e3a:	000d0023          	sb	zero,0(s10)
  return buf;
}
     e3e:	8566                	mv	a0,s9
     e40:	70a6                	ld	ra,104(sp)
     e42:	7406                	ld	s0,96(sp)
     e44:	64e6                	ld	s1,88(sp)
     e46:	6946                	ld	s2,80(sp)
     e48:	69a6                	ld	s3,72(sp)
     e4a:	6a06                	ld	s4,64(sp)
     e4c:	7ae2                	ld	s5,56(sp)
     e4e:	7b42                	ld	s6,48(sp)
     e50:	7ba2                	ld	s7,40(sp)
     e52:	7c02                	ld	s8,32(sp)
     e54:	6ce2                	ld	s9,24(sp)
     e56:	6d42                	ld	s10,16(sp)
     e58:	6165                	addi	sp,sp,112
     e5a:	8082                	ret

0000000000000e5c <stat>:

int
stat(const char *n, struct stat *st)
{
     e5c:	1101                	addi	sp,sp,-32
     e5e:	ec06                	sd	ra,24(sp)
     e60:	e822                	sd	s0,16(sp)
     e62:	e04a                	sd	s2,0(sp)
     e64:	1000                	addi	s0,sp,32
     e66:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e68:	4581                	li	a1,0
     e6a:	16e000ef          	jal	fd8 <open>
  if(fd < 0)
     e6e:	02054263          	bltz	a0,e92 <stat+0x36>
     e72:	e426                	sd	s1,8(sp)
     e74:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     e76:	85ca                	mv	a1,s2
     e78:	178000ef          	jal	ff0 <fstat>
     e7c:	892a                	mv	s2,a0
  close(fd);
     e7e:	8526                	mv	a0,s1
     e80:	140000ef          	jal	fc0 <close>
  return r;
     e84:	64a2                	ld	s1,8(sp)
}
     e86:	854a                	mv	a0,s2
     e88:	60e2                	ld	ra,24(sp)
     e8a:	6442                	ld	s0,16(sp)
     e8c:	6902                	ld	s2,0(sp)
     e8e:	6105                	addi	sp,sp,32
     e90:	8082                	ret
    return -1;
     e92:	597d                	li	s2,-1
     e94:	bfcd                	j	e86 <stat+0x2a>

0000000000000e96 <atoi>:

int
atoi(const char *s)
{
     e96:	1141                	addi	sp,sp,-16
     e98:	e406                	sd	ra,8(sp)
     e9a:	e022                	sd	s0,0(sp)
     e9c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e9e:	00054683          	lbu	a3,0(a0)
     ea2:	fd06879b          	addiw	a5,a3,-48 # 1fd0 <digits+0x2a8>
     ea6:	0ff7f793          	zext.b	a5,a5
     eaa:	4625                	li	a2,9
     eac:	02f66963          	bltu	a2,a5,ede <atoi+0x48>
     eb0:	872a                	mv	a4,a0
  n = 0;
     eb2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     eb4:	0705                	addi	a4,a4,1
     eb6:	0025179b          	slliw	a5,a0,0x2
     eba:	9fa9                	addw	a5,a5,a0
     ebc:	0017979b          	slliw	a5,a5,0x1
     ec0:	9fb5                	addw	a5,a5,a3
     ec2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     ec6:	00074683          	lbu	a3,0(a4)
     eca:	fd06879b          	addiw	a5,a3,-48
     ece:	0ff7f793          	zext.b	a5,a5
     ed2:	fef671e3          	bgeu	a2,a5,eb4 <atoi+0x1e>
  return n;
}
     ed6:	60a2                	ld	ra,8(sp)
     ed8:	6402                	ld	s0,0(sp)
     eda:	0141                	addi	sp,sp,16
     edc:	8082                	ret
  n = 0;
     ede:	4501                	li	a0,0
     ee0:	bfdd                	j	ed6 <atoi+0x40>

0000000000000ee2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     ee2:	1141                	addi	sp,sp,-16
     ee4:	e406                	sd	ra,8(sp)
     ee6:	e022                	sd	s0,0(sp)
     ee8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     eea:	02b57563          	bgeu	a0,a1,f14 <memmove+0x32>
    while(n-- > 0)
     eee:	00c05f63          	blez	a2,f0c <memmove+0x2a>
     ef2:	1602                	slli	a2,a2,0x20
     ef4:	9201                	srli	a2,a2,0x20
     ef6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     efa:	872a                	mv	a4,a0
      *dst++ = *src++;
     efc:	0585                	addi	a1,a1,1
     efe:	0705                	addi	a4,a4,1
     f00:	fff5c683          	lbu	a3,-1(a1)
     f04:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     f08:	fee79ae3          	bne	a5,a4,efc <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     f0c:	60a2                	ld	ra,8(sp)
     f0e:	6402                	ld	s0,0(sp)
     f10:	0141                	addi	sp,sp,16
     f12:	8082                	ret
    dst += n;
     f14:	00c50733          	add	a4,a0,a2
    src += n;
     f18:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     f1a:	fec059e3          	blez	a2,f0c <memmove+0x2a>
     f1e:	fff6079b          	addiw	a5,a2,-1 # fff <link+0x7>
     f22:	1782                	slli	a5,a5,0x20
     f24:	9381                	srli	a5,a5,0x20
     f26:	fff7c793          	not	a5,a5
     f2a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     f2c:	15fd                	addi	a1,a1,-1
     f2e:	177d                	addi	a4,a4,-1
     f30:	0005c683          	lbu	a3,0(a1)
     f34:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     f38:	fef71ae3          	bne	a4,a5,f2c <memmove+0x4a>
     f3c:	bfc1                	j	f0c <memmove+0x2a>

0000000000000f3e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     f3e:	1141                	addi	sp,sp,-16
     f40:	e406                	sd	ra,8(sp)
     f42:	e022                	sd	s0,0(sp)
     f44:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     f46:	ca0d                	beqz	a2,f78 <memcmp+0x3a>
     f48:	fff6069b          	addiw	a3,a2,-1
     f4c:	1682                	slli	a3,a3,0x20
     f4e:	9281                	srli	a3,a3,0x20
     f50:	0685                	addi	a3,a3,1
     f52:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     f54:	00054783          	lbu	a5,0(a0)
     f58:	0005c703          	lbu	a4,0(a1)
     f5c:	00e79863          	bne	a5,a4,f6c <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     f60:	0505                	addi	a0,a0,1
    p2++;
     f62:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     f64:	fed518e3          	bne	a0,a3,f54 <memcmp+0x16>
  }
  return 0;
     f68:	4501                	li	a0,0
     f6a:	a019                	j	f70 <memcmp+0x32>
      return *p1 - *p2;
     f6c:	40e7853b          	subw	a0,a5,a4
}
     f70:	60a2                	ld	ra,8(sp)
     f72:	6402                	ld	s0,0(sp)
     f74:	0141                	addi	sp,sp,16
     f76:	8082                	ret
  return 0;
     f78:	4501                	li	a0,0
     f7a:	bfdd                	j	f70 <memcmp+0x32>

0000000000000f7c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     f7c:	1141                	addi	sp,sp,-16
     f7e:	e406                	sd	ra,8(sp)
     f80:	e022                	sd	s0,0(sp)
     f82:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     f84:	f5fff0ef          	jal	ee2 <memmove>
}
     f88:	60a2                	ld	ra,8(sp)
     f8a:	6402                	ld	s0,0(sp)
     f8c:	0141                	addi	sp,sp,16
     f8e:	8082                	ret

0000000000000f90 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     f90:	4885                	li	a7,1
 ecall
     f92:	00000073          	ecall
 ret
     f96:	8082                	ret

0000000000000f98 <exit>:
.global exit
exit:
 li a7, SYS_exit
     f98:	4889                	li	a7,2
 ecall
     f9a:	00000073          	ecall
 ret
     f9e:	8082                	ret

0000000000000fa0 <wait>:
.global wait
wait:
 li a7, SYS_wait
     fa0:	488d                	li	a7,3
 ecall
     fa2:	00000073          	ecall
 ret
     fa6:	8082                	ret

0000000000000fa8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     fa8:	4891                	li	a7,4
 ecall
     faa:	00000073          	ecall
 ret
     fae:	8082                	ret

0000000000000fb0 <read>:
.global read
read:
 li a7, SYS_read
     fb0:	4895                	li	a7,5
 ecall
     fb2:	00000073          	ecall
 ret
     fb6:	8082                	ret

0000000000000fb8 <write>:
.global write
write:
 li a7, SYS_write
     fb8:	48c1                	li	a7,16
 ecall
     fba:	00000073          	ecall
 ret
     fbe:	8082                	ret

0000000000000fc0 <close>:
.global close
close:
 li a7, SYS_close
     fc0:	48d5                	li	a7,21
 ecall
     fc2:	00000073          	ecall
 ret
     fc6:	8082                	ret

0000000000000fc8 <kill>:
.global kill
kill:
 li a7, SYS_kill
     fc8:	4899                	li	a7,6
 ecall
     fca:	00000073          	ecall
 ret
     fce:	8082                	ret

0000000000000fd0 <exec>:
.global exec
exec:
 li a7, SYS_exec
     fd0:	489d                	li	a7,7
 ecall
     fd2:	00000073          	ecall
 ret
     fd6:	8082                	ret

0000000000000fd8 <open>:
.global open
open:
 li a7, SYS_open
     fd8:	48bd                	li	a7,15
 ecall
     fda:	00000073          	ecall
 ret
     fde:	8082                	ret

0000000000000fe0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     fe0:	48c5                	li	a7,17
 ecall
     fe2:	00000073          	ecall
 ret
     fe6:	8082                	ret

0000000000000fe8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     fe8:	48c9                	li	a7,18
 ecall
     fea:	00000073          	ecall
 ret
     fee:	8082                	ret

0000000000000ff0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ff0:	48a1                	li	a7,8
 ecall
     ff2:	00000073          	ecall
 ret
     ff6:	8082                	ret

0000000000000ff8 <link>:
.global link
link:
 li a7, SYS_link
     ff8:	48cd                	li	a7,19
 ecall
     ffa:	00000073          	ecall
 ret
     ffe:	8082                	ret

0000000000001000 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1000:	48d1                	li	a7,20
 ecall
    1002:	00000073          	ecall
 ret
    1006:	8082                	ret

0000000000001008 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1008:	48a5                	li	a7,9
 ecall
    100a:	00000073          	ecall
 ret
    100e:	8082                	ret

0000000000001010 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1010:	48a9                	li	a7,10
 ecall
    1012:	00000073          	ecall
 ret
    1016:	8082                	ret

0000000000001018 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1018:	48ad                	li	a7,11
 ecall
    101a:	00000073          	ecall
 ret
    101e:	8082                	ret

0000000000001020 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1020:	48b1                	li	a7,12
 ecall
    1022:	00000073          	ecall
 ret
    1026:	8082                	ret

0000000000001028 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1028:	48b5                	li	a7,13
 ecall
    102a:	00000073          	ecall
 ret
    102e:	8082                	ret

0000000000001030 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1030:	48b9                	li	a7,14
 ecall
    1032:	00000073          	ecall
 ret
    1036:	8082                	ret

0000000000001038 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
    1038:	48d9                	li	a7,22
 ecall
    103a:	00000073          	ecall
 ret
    103e:	8082                	ret

0000000000001040 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
    1040:	48dd                	li	a7,23
 ecall
    1042:	00000073          	ecall
 ret
    1046:	8082                	ret

0000000000001048 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1048:	1101                	addi	sp,sp,-32
    104a:	ec06                	sd	ra,24(sp)
    104c:	e822                	sd	s0,16(sp)
    104e:	1000                	addi	s0,sp,32
    1050:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1054:	4605                	li	a2,1
    1056:	fef40593          	addi	a1,s0,-17
    105a:	f5fff0ef          	jal	fb8 <write>
}
    105e:	60e2                	ld	ra,24(sp)
    1060:	6442                	ld	s0,16(sp)
    1062:	6105                	addi	sp,sp,32
    1064:	8082                	ret

0000000000001066 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1066:	7139                	addi	sp,sp,-64
    1068:	fc06                	sd	ra,56(sp)
    106a:	f822                	sd	s0,48(sp)
    106c:	f426                	sd	s1,40(sp)
    106e:	f04a                	sd	s2,32(sp)
    1070:	ec4e                	sd	s3,24(sp)
    1072:	0080                	addi	s0,sp,64
    1074:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1076:	c299                	beqz	a3,107c <printint+0x16>
    1078:	0605ce63          	bltz	a1,10f4 <printint+0x8e>
  neg = 0;
    107c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    107e:	fc040313          	addi	t1,s0,-64
  neg = 0;
    1082:	869a                	mv	a3,t1
  i = 0;
    1084:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
    1086:	00001817          	auipc	a6,0x1
    108a:	ca280813          	addi	a6,a6,-862 # 1d28 <digits>
    108e:	88be                	mv	a7,a5
    1090:	0017851b          	addiw	a0,a5,1
    1094:	87aa                	mv	a5,a0
    1096:	02c5f73b          	remuw	a4,a1,a2
    109a:	1702                	slli	a4,a4,0x20
    109c:	9301                	srli	a4,a4,0x20
    109e:	9742                	add	a4,a4,a6
    10a0:	00074703          	lbu	a4,0(a4)
    10a4:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
    10a8:	872e                	mv	a4,a1
    10aa:	02c5d5bb          	divuw	a1,a1,a2
    10ae:	0685                	addi	a3,a3,1
    10b0:	fcc77fe3          	bgeu	a4,a2,108e <printint+0x28>
  if(neg)
    10b4:	000e0c63          	beqz	t3,10cc <printint+0x66>
    buf[i++] = '-';
    10b8:	fd050793          	addi	a5,a0,-48
    10bc:	00878533          	add	a0,a5,s0
    10c0:	02d00793          	li	a5,45
    10c4:	fef50823          	sb	a5,-16(a0)
    10c8:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    10cc:	fff7899b          	addiw	s3,a5,-1
    10d0:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
    10d4:	fff4c583          	lbu	a1,-1(s1)
    10d8:	854a                	mv	a0,s2
    10da:	f6fff0ef          	jal	1048 <putc>
  while(--i >= 0)
    10de:	39fd                	addiw	s3,s3,-1
    10e0:	14fd                	addi	s1,s1,-1
    10e2:	fe09d9e3          	bgez	s3,10d4 <printint+0x6e>
}
    10e6:	70e2                	ld	ra,56(sp)
    10e8:	7442                	ld	s0,48(sp)
    10ea:	74a2                	ld	s1,40(sp)
    10ec:	7902                	ld	s2,32(sp)
    10ee:	69e2                	ld	s3,24(sp)
    10f0:	6121                	addi	sp,sp,64
    10f2:	8082                	ret
    x = -xx;
    10f4:	40b005bb          	negw	a1,a1
    neg = 1;
    10f8:	4e05                	li	t3,1
    x = -xx;
    10fa:	b751                	j	107e <printint+0x18>

00000000000010fc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    10fc:	711d                	addi	sp,sp,-96
    10fe:	ec86                	sd	ra,88(sp)
    1100:	e8a2                	sd	s0,80(sp)
    1102:	e4a6                	sd	s1,72(sp)
    1104:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1106:	0005c483          	lbu	s1,0(a1)
    110a:	26048663          	beqz	s1,1376 <vprintf+0x27a>
    110e:	e0ca                	sd	s2,64(sp)
    1110:	fc4e                	sd	s3,56(sp)
    1112:	f852                	sd	s4,48(sp)
    1114:	f456                	sd	s5,40(sp)
    1116:	f05a                	sd	s6,32(sp)
    1118:	ec5e                	sd	s7,24(sp)
    111a:	e862                	sd	s8,16(sp)
    111c:	e466                	sd	s9,8(sp)
    111e:	8b2a                	mv	s6,a0
    1120:	8a2e                	mv	s4,a1
    1122:	8bb2                	mv	s7,a2
  state = 0;
    1124:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    1126:	4901                	li	s2,0
    1128:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    112a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    112e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    1132:	06c00c93          	li	s9,108
    1136:	a00d                	j	1158 <vprintf+0x5c>
        putc(fd, c0);
    1138:	85a6                	mv	a1,s1
    113a:	855a                	mv	a0,s6
    113c:	f0dff0ef          	jal	1048 <putc>
    1140:	a019                	j	1146 <vprintf+0x4a>
    } else if(state == '%'){
    1142:	03598363          	beq	s3,s5,1168 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
    1146:	0019079b          	addiw	a5,s2,1
    114a:	893e                	mv	s2,a5
    114c:	873e                	mv	a4,a5
    114e:	97d2                	add	a5,a5,s4
    1150:	0007c483          	lbu	s1,0(a5)
    1154:	20048963          	beqz	s1,1366 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
    1158:	0004879b          	sext.w	a5,s1
    if(state == 0){
    115c:	fe0993e3          	bnez	s3,1142 <vprintf+0x46>
      if(c0 == '%'){
    1160:	fd579ce3          	bne	a5,s5,1138 <vprintf+0x3c>
        state = '%';
    1164:	89be                	mv	s3,a5
    1166:	b7c5                	j	1146 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    1168:	00ea06b3          	add	a3,s4,a4
    116c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    1170:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    1172:	c681                	beqz	a3,117a <vprintf+0x7e>
    1174:	9752                	add	a4,a4,s4
    1176:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    117a:	03878e63          	beq	a5,s8,11b6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    117e:	05978863          	beq	a5,s9,11ce <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1182:	07500713          	li	a4,117
    1186:	0ee78263          	beq	a5,a4,126a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    118a:	07800713          	li	a4,120
    118e:	12e78463          	beq	a5,a4,12b6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1192:	07000713          	li	a4,112
    1196:	14e78963          	beq	a5,a4,12e8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    119a:	07300713          	li	a4,115
    119e:	18e78863          	beq	a5,a4,132e <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    11a2:	02500713          	li	a4,37
    11a6:	04e79463          	bne	a5,a4,11ee <vprintf+0xf2>
        putc(fd, '%');
    11aa:	85ba                	mv	a1,a4
    11ac:	855a                	mv	a0,s6
    11ae:	e9bff0ef          	jal	1048 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    11b2:	4981                	li	s3,0
    11b4:	bf49                	j	1146 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    11b6:	008b8493          	addi	s1,s7,8
    11ba:	4685                	li	a3,1
    11bc:	4629                	li	a2,10
    11be:	000ba583          	lw	a1,0(s7)
    11c2:	855a                	mv	a0,s6
    11c4:	ea3ff0ef          	jal	1066 <printint>
    11c8:	8ba6                	mv	s7,s1
      state = 0;
    11ca:	4981                	li	s3,0
    11cc:	bfad                	j	1146 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    11ce:	06400793          	li	a5,100
    11d2:	02f68963          	beq	a3,a5,1204 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    11d6:	06c00793          	li	a5,108
    11da:	04f68263          	beq	a3,a5,121e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    11de:	07500793          	li	a5,117
    11e2:	0af68063          	beq	a3,a5,1282 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    11e6:	07800793          	li	a5,120
    11ea:	0ef68263          	beq	a3,a5,12ce <vprintf+0x1d2>
        putc(fd, '%');
    11ee:	02500593          	li	a1,37
    11f2:	855a                	mv	a0,s6
    11f4:	e55ff0ef          	jal	1048 <putc>
        putc(fd, c0);
    11f8:	85a6                	mv	a1,s1
    11fa:	855a                	mv	a0,s6
    11fc:	e4dff0ef          	jal	1048 <putc>
      state = 0;
    1200:	4981                	li	s3,0
    1202:	b791                	j	1146 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1204:	008b8493          	addi	s1,s7,8
    1208:	4685                	li	a3,1
    120a:	4629                	li	a2,10
    120c:	000ba583          	lw	a1,0(s7)
    1210:	855a                	mv	a0,s6
    1212:	e55ff0ef          	jal	1066 <printint>
        i += 1;
    1216:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1218:	8ba6                	mv	s7,s1
      state = 0;
    121a:	4981                	li	s3,0
        i += 1;
    121c:	b72d                	j	1146 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    121e:	06400793          	li	a5,100
    1222:	02f60763          	beq	a2,a5,1250 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1226:	07500793          	li	a5,117
    122a:	06f60963          	beq	a2,a5,129c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    122e:	07800793          	li	a5,120
    1232:	faf61ee3          	bne	a2,a5,11ee <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1236:	008b8493          	addi	s1,s7,8
    123a:	4681                	li	a3,0
    123c:	4641                	li	a2,16
    123e:	000ba583          	lw	a1,0(s7)
    1242:	855a                	mv	a0,s6
    1244:	e23ff0ef          	jal	1066 <printint>
        i += 2;
    1248:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    124a:	8ba6                	mv	s7,s1
      state = 0;
    124c:	4981                	li	s3,0
        i += 2;
    124e:	bde5                	j	1146 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1250:	008b8493          	addi	s1,s7,8
    1254:	4685                	li	a3,1
    1256:	4629                	li	a2,10
    1258:	000ba583          	lw	a1,0(s7)
    125c:	855a                	mv	a0,s6
    125e:	e09ff0ef          	jal	1066 <printint>
        i += 2;
    1262:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    1264:	8ba6                	mv	s7,s1
      state = 0;
    1266:	4981                	li	s3,0
        i += 2;
    1268:	bdf9                	j	1146 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    126a:	008b8493          	addi	s1,s7,8
    126e:	4681                	li	a3,0
    1270:	4629                	li	a2,10
    1272:	000ba583          	lw	a1,0(s7)
    1276:	855a                	mv	a0,s6
    1278:	defff0ef          	jal	1066 <printint>
    127c:	8ba6                	mv	s7,s1
      state = 0;
    127e:	4981                	li	s3,0
    1280:	b5d9                	j	1146 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1282:	008b8493          	addi	s1,s7,8
    1286:	4681                	li	a3,0
    1288:	4629                	li	a2,10
    128a:	000ba583          	lw	a1,0(s7)
    128e:	855a                	mv	a0,s6
    1290:	dd7ff0ef          	jal	1066 <printint>
        i += 1;
    1294:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1296:	8ba6                	mv	s7,s1
      state = 0;
    1298:	4981                	li	s3,0
        i += 1;
    129a:	b575                	j	1146 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    129c:	008b8493          	addi	s1,s7,8
    12a0:	4681                	li	a3,0
    12a2:	4629                	li	a2,10
    12a4:	000ba583          	lw	a1,0(s7)
    12a8:	855a                	mv	a0,s6
    12aa:	dbdff0ef          	jal	1066 <printint>
        i += 2;
    12ae:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    12b0:	8ba6                	mv	s7,s1
      state = 0;
    12b2:	4981                	li	s3,0
        i += 2;
    12b4:	bd49                	j	1146 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    12b6:	008b8493          	addi	s1,s7,8
    12ba:	4681                	li	a3,0
    12bc:	4641                	li	a2,16
    12be:	000ba583          	lw	a1,0(s7)
    12c2:	855a                	mv	a0,s6
    12c4:	da3ff0ef          	jal	1066 <printint>
    12c8:	8ba6                	mv	s7,s1
      state = 0;
    12ca:	4981                	li	s3,0
    12cc:	bdad                	j	1146 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    12ce:	008b8493          	addi	s1,s7,8
    12d2:	4681                	li	a3,0
    12d4:	4641                	li	a2,16
    12d6:	000ba583          	lw	a1,0(s7)
    12da:	855a                	mv	a0,s6
    12dc:	d8bff0ef          	jal	1066 <printint>
        i += 1;
    12e0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    12e2:	8ba6                	mv	s7,s1
      state = 0;
    12e4:	4981                	li	s3,0
        i += 1;
    12e6:	b585                	j	1146 <vprintf+0x4a>
    12e8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    12ea:	008b8d13          	addi	s10,s7,8
    12ee:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    12f2:	03000593          	li	a1,48
    12f6:	855a                	mv	a0,s6
    12f8:	d51ff0ef          	jal	1048 <putc>
  putc(fd, 'x');
    12fc:	07800593          	li	a1,120
    1300:	855a                	mv	a0,s6
    1302:	d47ff0ef          	jal	1048 <putc>
    1306:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1308:	00001b97          	auipc	s7,0x1
    130c:	a20b8b93          	addi	s7,s7,-1504 # 1d28 <digits>
    1310:	03c9d793          	srli	a5,s3,0x3c
    1314:	97de                	add	a5,a5,s7
    1316:	0007c583          	lbu	a1,0(a5)
    131a:	855a                	mv	a0,s6
    131c:	d2dff0ef          	jal	1048 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1320:	0992                	slli	s3,s3,0x4
    1322:	34fd                	addiw	s1,s1,-1
    1324:	f4f5                	bnez	s1,1310 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    1326:	8bea                	mv	s7,s10
      state = 0;
    1328:	4981                	li	s3,0
    132a:	6d02                	ld	s10,0(sp)
    132c:	bd29                	j	1146 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    132e:	008b8993          	addi	s3,s7,8
    1332:	000bb483          	ld	s1,0(s7)
    1336:	cc91                	beqz	s1,1352 <vprintf+0x256>
        for(; *s; s++)
    1338:	0004c583          	lbu	a1,0(s1)
    133c:	c195                	beqz	a1,1360 <vprintf+0x264>
          putc(fd, *s);
    133e:	855a                	mv	a0,s6
    1340:	d09ff0ef          	jal	1048 <putc>
        for(; *s; s++)
    1344:	0485                	addi	s1,s1,1
    1346:	0004c583          	lbu	a1,0(s1)
    134a:	f9f5                	bnez	a1,133e <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
    134c:	8bce                	mv	s7,s3
      state = 0;
    134e:	4981                	li	s3,0
    1350:	bbdd                	j	1146 <vprintf+0x4a>
          s = "(null)";
    1352:	00001497          	auipc	s1,0x1
    1356:	9ce48493          	addi	s1,s1,-1586 # 1d20 <malloc+0x8be>
        for(; *s; s++)
    135a:	02800593          	li	a1,40
    135e:	b7c5                	j	133e <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
    1360:	8bce                	mv	s7,s3
      state = 0;
    1362:	4981                	li	s3,0
    1364:	b3cd                	j	1146 <vprintf+0x4a>
    1366:	6906                	ld	s2,64(sp)
    1368:	79e2                	ld	s3,56(sp)
    136a:	7a42                	ld	s4,48(sp)
    136c:	7aa2                	ld	s5,40(sp)
    136e:	7b02                	ld	s6,32(sp)
    1370:	6be2                	ld	s7,24(sp)
    1372:	6c42                	ld	s8,16(sp)
    1374:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1376:	60e6                	ld	ra,88(sp)
    1378:	6446                	ld	s0,80(sp)
    137a:	64a6                	ld	s1,72(sp)
    137c:	6125                	addi	sp,sp,96
    137e:	8082                	ret

0000000000001380 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1380:	715d                	addi	sp,sp,-80
    1382:	ec06                	sd	ra,24(sp)
    1384:	e822                	sd	s0,16(sp)
    1386:	1000                	addi	s0,sp,32
    1388:	e010                	sd	a2,0(s0)
    138a:	e414                	sd	a3,8(s0)
    138c:	e818                	sd	a4,16(s0)
    138e:	ec1c                	sd	a5,24(s0)
    1390:	03043023          	sd	a6,32(s0)
    1394:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1398:	8622                	mv	a2,s0
    139a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    139e:	d5fff0ef          	jal	10fc <vprintf>
}
    13a2:	60e2                	ld	ra,24(sp)
    13a4:	6442                	ld	s0,16(sp)
    13a6:	6161                	addi	sp,sp,80
    13a8:	8082                	ret

00000000000013aa <printf>:

void
printf(const char *fmt, ...)
{
    13aa:	711d                	addi	sp,sp,-96
    13ac:	ec06                	sd	ra,24(sp)
    13ae:	e822                	sd	s0,16(sp)
    13b0:	1000                	addi	s0,sp,32
    13b2:	e40c                	sd	a1,8(s0)
    13b4:	e810                	sd	a2,16(s0)
    13b6:	ec14                	sd	a3,24(s0)
    13b8:	f018                	sd	a4,32(s0)
    13ba:	f41c                	sd	a5,40(s0)
    13bc:	03043823          	sd	a6,48(s0)
    13c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    13c4:	00840613          	addi	a2,s0,8
    13c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    13cc:	85aa                	mv	a1,a0
    13ce:	4505                	li	a0,1
    13d0:	d2dff0ef          	jal	10fc <vprintf>
}
    13d4:	60e2                	ld	ra,24(sp)
    13d6:	6442                	ld	s0,16(sp)
    13d8:	6125                	addi	sp,sp,96
    13da:	8082                	ret

00000000000013dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    13dc:	1141                	addi	sp,sp,-16
    13de:	e406                	sd	ra,8(sp)
    13e0:	e022                	sd	s0,0(sp)
    13e2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    13e4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    13e8:	00002797          	auipc	a5,0x2
    13ec:	c187b783          	ld	a5,-1000(a5) # 3000 <freep>
    13f0:	a02d                	j	141a <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    13f2:	4618                	lw	a4,8(a2)
    13f4:	9f2d                	addw	a4,a4,a1
    13f6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    13fa:	6398                	ld	a4,0(a5)
    13fc:	6310                	ld	a2,0(a4)
    13fe:	a83d                	j	143c <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1400:	ff852703          	lw	a4,-8(a0)
    1404:	9f31                	addw	a4,a4,a2
    1406:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1408:	ff053683          	ld	a3,-16(a0)
    140c:	a091                	j	1450 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    140e:	6398                	ld	a4,0(a5)
    1410:	00e7e463          	bltu	a5,a4,1418 <free+0x3c>
    1414:	00e6ea63          	bltu	a3,a4,1428 <free+0x4c>
{
    1418:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    141a:	fed7fae3          	bgeu	a5,a3,140e <free+0x32>
    141e:	6398                	ld	a4,0(a5)
    1420:	00e6e463          	bltu	a3,a4,1428 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1424:	fee7eae3          	bltu	a5,a4,1418 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    1428:	ff852583          	lw	a1,-8(a0)
    142c:	6390                	ld	a2,0(a5)
    142e:	02059813          	slli	a6,a1,0x20
    1432:	01c85713          	srli	a4,a6,0x1c
    1436:	9736                	add	a4,a4,a3
    1438:	fae60de3          	beq	a2,a4,13f2 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    143c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1440:	4790                	lw	a2,8(a5)
    1442:	02061593          	slli	a1,a2,0x20
    1446:	01c5d713          	srli	a4,a1,0x1c
    144a:	973e                	add	a4,a4,a5
    144c:	fae68ae3          	beq	a3,a4,1400 <free+0x24>
    p->s.ptr = bp->s.ptr;
    1450:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1452:	00002717          	auipc	a4,0x2
    1456:	baf73723          	sd	a5,-1106(a4) # 3000 <freep>
}
    145a:	60a2                	ld	ra,8(sp)
    145c:	6402                	ld	s0,0(sp)
    145e:	0141                	addi	sp,sp,16
    1460:	8082                	ret

0000000000001462 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1462:	7139                	addi	sp,sp,-64
    1464:	fc06                	sd	ra,56(sp)
    1466:	f822                	sd	s0,48(sp)
    1468:	f04a                	sd	s2,32(sp)
    146a:	ec4e                	sd	s3,24(sp)
    146c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    146e:	02051993          	slli	s3,a0,0x20
    1472:	0209d993          	srli	s3,s3,0x20
    1476:	09bd                	addi	s3,s3,15
    1478:	0049d993          	srli	s3,s3,0x4
    147c:	2985                	addiw	s3,s3,1
    147e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1480:	00002517          	auipc	a0,0x2
    1484:	b8053503          	ld	a0,-1152(a0) # 3000 <freep>
    1488:	c905                	beqz	a0,14b8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    148a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    148c:	4798                	lw	a4,8(a5)
    148e:	09377663          	bgeu	a4,s3,151a <malloc+0xb8>
    1492:	f426                	sd	s1,40(sp)
    1494:	e852                	sd	s4,16(sp)
    1496:	e456                	sd	s5,8(sp)
    1498:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    149a:	8a4e                	mv	s4,s3
    149c:	6705                	lui	a4,0x1
    149e:	00e9f363          	bgeu	s3,a4,14a4 <malloc+0x42>
    14a2:	6a05                	lui	s4,0x1
    14a4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    14a8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    14ac:	00002497          	auipc	s1,0x2
    14b0:	b5448493          	addi	s1,s1,-1196 # 3000 <freep>
  if(p == (char*)-1)
    14b4:	5afd                	li	s5,-1
    14b6:	a83d                	j	14f4 <malloc+0x92>
    14b8:	f426                	sd	s1,40(sp)
    14ba:	e852                	sd	s4,16(sp)
    14bc:	e456                	sd	s5,8(sp)
    14be:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    14c0:	00003797          	auipc	a5,0x3
    14c4:	b5078793          	addi	a5,a5,-1200 # 4010 <base>
    14c8:	00002717          	auipc	a4,0x2
    14cc:	b2f73c23          	sd	a5,-1224(a4) # 3000 <freep>
    14d0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    14d2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    14d6:	b7d1                	j	149a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    14d8:	6398                	ld	a4,0(a5)
    14da:	e118                	sd	a4,0(a0)
    14dc:	a899                	j	1532 <malloc+0xd0>
  hp->s.size = nu;
    14de:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    14e2:	0541                	addi	a0,a0,16
    14e4:	ef9ff0ef          	jal	13dc <free>
  return freep;
    14e8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    14ea:	c125                	beqz	a0,154a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    14ee:	4798                	lw	a4,8(a5)
    14f0:	03277163          	bgeu	a4,s2,1512 <malloc+0xb0>
    if(p == freep)
    14f4:	6098                	ld	a4,0(s1)
    14f6:	853e                	mv	a0,a5
    14f8:	fef71ae3          	bne	a4,a5,14ec <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    14fc:	8552                	mv	a0,s4
    14fe:	b23ff0ef          	jal	1020 <sbrk>
  if(p == (char*)-1)
    1502:	fd551ee3          	bne	a0,s5,14de <malloc+0x7c>
        return 0;
    1506:	4501                	li	a0,0
    1508:	74a2                	ld	s1,40(sp)
    150a:	6a42                	ld	s4,16(sp)
    150c:	6aa2                	ld	s5,8(sp)
    150e:	6b02                	ld	s6,0(sp)
    1510:	a03d                	j	153e <malloc+0xdc>
    1512:	74a2                	ld	s1,40(sp)
    1514:	6a42                	ld	s4,16(sp)
    1516:	6aa2                	ld	s5,8(sp)
    1518:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    151a:	fae90fe3          	beq	s2,a4,14d8 <malloc+0x76>
        p->s.size -= nunits;
    151e:	4137073b          	subw	a4,a4,s3
    1522:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1524:	02071693          	slli	a3,a4,0x20
    1528:	01c6d713          	srli	a4,a3,0x1c
    152c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    152e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1532:	00002717          	auipc	a4,0x2
    1536:	aca73723          	sd	a0,-1330(a4) # 3000 <freep>
      return (void*)(p + 1);
    153a:	01078513          	addi	a0,a5,16
  }
}
    153e:	70e2                	ld	ra,56(sp)
    1540:	7442                	ld	s0,48(sp)
    1542:	7902                	ld	s2,32(sp)
    1544:	69e2                	ld	s3,24(sp)
    1546:	6121                	addi	sp,sp,64
    1548:	8082                	ret
    154a:	74a2                	ld	s1,40(sp)
    154c:	6a42                	ld	s4,16(sp)
    154e:	6aa2                	ld	s5,8(sp)
    1550:	6b02                	ld	s6,0(sp)
    1552:	b7f5                	j	153e <malloc+0xdc>
