
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	55013103          	ld	sp,1360(sp) # 8000a550 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	306050ef          	jal	8000531c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	0002e797          	auipc	a5,0x2e
    80000034:	8a078793          	addi	a5,a5,-1888 # 8002d8d0 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	55490913          	addi	s2,s2,1364 # 8000a5a0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	52f050ef          	jal	80005d84 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	5b3050ef          	jal	80005e18 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	1d9050ef          	jal	80005a56 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	89be                	mv	s3,a5
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	4c650513          	addi	a0,a0,1222 # 8000a5a0 <kmem>
    800000e2:	41f050ef          	jal	80005d00 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	0002d517          	auipc	a0,0x2d
    800000ee:	7e650513          	addi	a0,a0,2022 # 8002d8d0 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	49848493          	addi	s1,s1,1176 # 8000a5a0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	473050ef          	jal	80005d84 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	48450513          	addi	a0,a0,1156 # 8000a5a0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	4f3050ef          	jal	80005e18 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	46050513          	addi	a0,a0,1120 # 8000a5a0 <kmem>
    80000148:	4d1050ef          	jal	80005e18 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e406                	sd	ra,8(sp)
    80000152:	e022                	sd	s0,0(sp)
    80000154:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000156:	ca19                	beqz	a2,8000016c <memset+0x1e>
    80000158:	87aa                	mv	a5,a0
    8000015a:	1602                	slli	a2,a2,0x20
    8000015c:	9201                	srli	a2,a2,0x20
    8000015e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000162:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000166:	0785                	addi	a5,a5,1
    80000168:	fee79de3          	bne	a5,a4,80000162 <memset+0x14>
  }
  return dst;
}
    8000016c:	60a2                	ld	ra,8(sp)
    8000016e:	6402                	ld	s0,0(sp)
    80000170:	0141                	addi	sp,sp,16
    80000172:	8082                	ret

0000000080000174 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000174:	1141                	addi	sp,sp,-16
    80000176:	e406                	sd	ra,8(sp)
    80000178:	e022                	sd	s0,0(sp)
    8000017a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000017c:	ca0d                	beqz	a2,800001ae <memcmp+0x3a>
    8000017e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000182:	1682                	slli	a3,a3,0x20
    80000184:	9281                	srli	a3,a3,0x20
    80000186:	0685                	addi	a3,a3,1
    80000188:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000018a:	00054783          	lbu	a5,0(a0)
    8000018e:	0005c703          	lbu	a4,0(a1)
    80000192:	00e79863          	bne	a5,a4,800001a2 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000196:	0505                	addi	a0,a0,1
    80000198:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000019a:	fed518e3          	bne	a0,a3,8000018a <memcmp+0x16>
  }

  return 0;
    8000019e:	4501                	li	a0,0
    800001a0:	a019                	j	800001a6 <memcmp+0x32>
      return *s1 - *s2;
    800001a2:	40e7853b          	subw	a0,a5,a4
}
    800001a6:	60a2                	ld	ra,8(sp)
    800001a8:	6402                	ld	s0,0(sp)
    800001aa:	0141                	addi	sp,sp,16
    800001ac:	8082                	ret
  return 0;
    800001ae:	4501                	li	a0,0
    800001b0:	bfdd                	j	800001a6 <memcmp+0x32>

00000000800001b2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001b2:	1141                	addi	sp,sp,-16
    800001b4:	e406                	sd	ra,8(sp)
    800001b6:	e022                	sd	s0,0(sp)
    800001b8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001ba:	c205                	beqz	a2,800001da <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001bc:	02a5e363          	bltu	a1,a0,800001e2 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001c0:	1602                	slli	a2,a2,0x20
    800001c2:	9201                	srli	a2,a2,0x20
    800001c4:	00c587b3          	add	a5,a1,a2
{
    800001c8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ca:	0585                	addi	a1,a1,1
    800001cc:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd1731>
    800001ce:	fff5c683          	lbu	a3,-1(a1)
    800001d2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001d6:	feb79ae3          	bne	a5,a1,800001ca <memmove+0x18>

  return dst;
}
    800001da:	60a2                	ld	ra,8(sp)
    800001dc:	6402                	ld	s0,0(sp)
    800001de:	0141                	addi	sp,sp,16
    800001e0:	8082                	ret
  if(s < d && s + n > d){
    800001e2:	02061693          	slli	a3,a2,0x20
    800001e6:	9281                	srli	a3,a3,0x20
    800001e8:	00d58733          	add	a4,a1,a3
    800001ec:	fce57ae3          	bgeu	a0,a4,800001c0 <memmove+0xe>
    d += n;
    800001f0:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	fff7c793          	not	a5,a5
    800001fe:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000200:	177d                	addi	a4,a4,-1
    80000202:	16fd                	addi	a3,a3,-1
    80000204:	00074603          	lbu	a2,0(a4)
    80000208:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000020c:	fee79ae3          	bne	a5,a4,80000200 <memmove+0x4e>
    80000210:	b7e9                	j	800001da <memmove+0x28>

0000000080000212 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000212:	1141                	addi	sp,sp,-16
    80000214:	e406                	sd	ra,8(sp)
    80000216:	e022                	sd	s0,0(sp)
    80000218:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000021a:	f99ff0ef          	jal	800001b2 <memmove>
}
    8000021e:	60a2                	ld	ra,8(sp)
    80000220:	6402                	ld	s0,0(sp)
    80000222:	0141                	addi	sp,sp,16
    80000224:	8082                	ret

0000000080000226 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000226:	1141                	addi	sp,sp,-16
    80000228:	e406                	sd	ra,8(sp)
    8000022a:	e022                	sd	s0,0(sp)
    8000022c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000022e:	ce11                	beqz	a2,8000024a <strncmp+0x24>
    80000230:	00054783          	lbu	a5,0(a0)
    80000234:	cf89                	beqz	a5,8000024e <strncmp+0x28>
    80000236:	0005c703          	lbu	a4,0(a1)
    8000023a:	00f71a63          	bne	a4,a5,8000024e <strncmp+0x28>
    n--, p++, q++;
    8000023e:	367d                	addiw	a2,a2,-1
    80000240:	0505                	addi	a0,a0,1
    80000242:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000244:	f675                	bnez	a2,80000230 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000246:	4501                	li	a0,0
    80000248:	a801                	j	80000258 <strncmp+0x32>
    8000024a:	4501                	li	a0,0
    8000024c:	a031                	j	80000258 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000024e:	00054503          	lbu	a0,0(a0)
    80000252:	0005c783          	lbu	a5,0(a1)
    80000256:	9d1d                	subw	a0,a0,a5
}
    80000258:	60a2                	ld	ra,8(sp)
    8000025a:	6402                	ld	s0,0(sp)
    8000025c:	0141                	addi	sp,sp,16
    8000025e:	8082                	ret

0000000080000260 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000260:	1141                	addi	sp,sp,-16
    80000262:	e406                	sd	ra,8(sp)
    80000264:	e022                	sd	s0,0(sp)
    80000266:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000268:	87aa                	mv	a5,a0
    8000026a:	86b2                	mv	a3,a2
    8000026c:	367d                	addiw	a2,a2,-1
    8000026e:	02d05563          	blez	a3,80000298 <strncpy+0x38>
    80000272:	0785                	addi	a5,a5,1
    80000274:	0005c703          	lbu	a4,0(a1)
    80000278:	fee78fa3          	sb	a4,-1(a5)
    8000027c:	0585                	addi	a1,a1,1
    8000027e:	f775                	bnez	a4,8000026a <strncpy+0xa>
    ;
  while(n-- > 0)
    80000280:	873e                	mv	a4,a5
    80000282:	00c05b63          	blez	a2,80000298 <strncpy+0x38>
    80000286:	9fb5                	addw	a5,a5,a3
    80000288:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000028a:	0705                	addi	a4,a4,1
    8000028c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000290:	40e786bb          	subw	a3,a5,a4
    80000294:	fed04be3          	bgtz	a3,8000028a <strncpy+0x2a>
  return os;
}
    80000298:	60a2                	ld	ra,8(sp)
    8000029a:	6402                	ld	s0,0(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret

00000000800002a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e406                	sd	ra,8(sp)
    800002a4:	e022                	sd	s0,0(sp)
    800002a6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002a8:	02c05363          	blez	a2,800002ce <safestrcpy+0x2e>
    800002ac:	fff6069b          	addiw	a3,a2,-1
    800002b0:	1682                	slli	a3,a3,0x20
    800002b2:	9281                	srli	a3,a3,0x20
    800002b4:	96ae                	add	a3,a3,a1
    800002b6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002b8:	00d58963          	beq	a1,a3,800002ca <safestrcpy+0x2a>
    800002bc:	0585                	addi	a1,a1,1
    800002be:	0785                	addi	a5,a5,1
    800002c0:	fff5c703          	lbu	a4,-1(a1)
    800002c4:	fee78fa3          	sb	a4,-1(a5)
    800002c8:	fb65                	bnez	a4,800002b8 <safestrcpy+0x18>
    ;
  *s = 0;
    800002ca:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ce:	60a2                	ld	ra,8(sp)
    800002d0:	6402                	ld	s0,0(sp)
    800002d2:	0141                	addi	sp,sp,16
    800002d4:	8082                	ret

00000000800002d6 <strlen>:

int
strlen(const char *s)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e406                	sd	ra,8(sp)
    800002da:	e022                	sd	s0,0(sp)
    800002dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002de:	00054783          	lbu	a5,0(a0)
    800002e2:	cf99                	beqz	a5,80000300 <strlen+0x2a>
    800002e4:	0505                	addi	a0,a0,1
    800002e6:	87aa                	mv	a5,a0
    800002e8:	86be                	mv	a3,a5
    800002ea:	0785                	addi	a5,a5,1
    800002ec:	fff7c703          	lbu	a4,-1(a5)
    800002f0:	ff65                	bnez	a4,800002e8 <strlen+0x12>
    800002f2:	40a6853b          	subw	a0,a3,a0
    800002f6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002f8:	60a2                	ld	ra,8(sp)
    800002fa:	6402                	ld	s0,0(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret
  for(n = 0; s[n]; n++)
    80000300:	4501                	li	a0,0
    80000302:	bfdd                	j	800002f8 <strlen+0x22>

0000000080000304 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000304:	1141                	addi	sp,sp,-16
    80000306:	e406                	sd	ra,8(sp)
    80000308:	e022                	sd	s0,0(sp)
    8000030a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000030c:	2cb000ef          	jal	80000dd6 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000310:	0000a717          	auipc	a4,0xa
    80000314:	26070713          	addi	a4,a4,608 # 8000a570 <started>
  if(cpuid() == 0){
    80000318:	c51d                	beqz	a0,80000346 <main+0x42>
    while(started == 0)
    8000031a:	431c                	lw	a5,0(a4)
    8000031c:	2781                	sext.w	a5,a5
    8000031e:	dff5                	beqz	a5,8000031a <main+0x16>
      ;
    __sync_synchronize();
    80000320:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000324:	2b3000ef          	jal	80000dd6 <cpuid>
    80000328:	85aa                	mv	a1,a0
    8000032a:	00007517          	auipc	a0,0x7
    8000032e:	d0e50513          	addi	a0,a0,-754 # 80007038 <etext+0x38>
    80000332:	454050ef          	jal	80005786 <printf>
    kvminithart();    // turn on paging
    80000336:	080000ef          	jal	800003b6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000033a:	644010ef          	jal	8000197e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000033e:	22b040ef          	jal	80004d68 <plicinithart>
  }

  scheduler();        
    80000342:	741000ef          	jal	80001282 <scheduler>
    consoleinit();
    80000346:	372050ef          	jal	800056b8 <consoleinit>
    printfinit();
    8000034a:	746050ef          	jal	80005a90 <printfinit>
    printf("\n");
    8000034e:	00007517          	auipc	a0,0x7
    80000352:	cca50513          	addi	a0,a0,-822 # 80007018 <etext+0x18>
    80000356:	430050ef          	jal	80005786 <printf>
    printf("xv6 kernel is booting\n");
    8000035a:	00007517          	auipc	a0,0x7
    8000035e:	cc650513          	addi	a0,a0,-826 # 80007020 <etext+0x20>
    80000362:	424050ef          	jal	80005786 <printf>
    printf("\n");
    80000366:	00007517          	auipc	a0,0x7
    8000036a:	cb250513          	addi	a0,a0,-846 # 80007018 <etext+0x18>
    8000036e:	418050ef          	jal	80005786 <printf>
    kinit();         // physical page allocator
    80000372:	d59ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    80000376:	2ce000ef          	jal	80000644 <kvminit>
    kvminithart();   // turn on paging
    8000037a:	03c000ef          	jal	800003b6 <kvminithart>
    procinit();      // process table
    8000037e:	1a9000ef          	jal	80000d26 <procinit>
    trapinit();      // trap vectors
    80000382:	5d8010ef          	jal	8000195a <trapinit>
    trapinithart();  // install kernel trap vector
    80000386:	5f8010ef          	jal	8000197e <trapinithart>
    plicinit();      // set up interrupt controller
    8000038a:	1c5040ef          	jal	80004d4e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000038e:	1db040ef          	jal	80004d68 <plicinithart>
    binit();         // buffer cache
    80000392:	5c3010ef          	jal	80002154 <binit>
    iinit();         // inode table
    80000396:	38e020ef          	jal	80002724 <iinit>
    fileinit();      // file table
    8000039a:	15c030ef          	jal	800034f6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000039e:	2bb040ef          	jal	80004e58 <virtio_disk_init>
    userinit();      // first user process
    800003a2:	4d1000ef          	jal	80001072 <userinit>
    __sync_synchronize();
    800003a6:	0330000f          	fence	rw,rw
    started = 1;
    800003aa:	4785                	li	a5,1
    800003ac:	0000a717          	auipc	a4,0xa
    800003b0:	1cf72223          	sw	a5,452(a4) # 8000a570 <started>
    800003b4:	b779                	j	80000342 <main+0x3e>

00000000800003b6 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003b6:	1141                	addi	sp,sp,-16
    800003b8:	e406                	sd	ra,8(sp)
    800003ba:	e022                	sd	s0,0(sp)
    800003bc:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003be:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003c2:	0000a797          	auipc	a5,0xa
    800003c6:	1b67b783          	ld	a5,438(a5) # 8000a578 <kernel_pagetable>
    800003ca:	83b1                	srli	a5,a5,0xc
    800003cc:	577d                	li	a4,-1
    800003ce:	177e                	slli	a4,a4,0x3f
    800003d0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003d2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003d6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003da:	60a2                	ld	ra,8(sp)
    800003dc:	6402                	ld	s0,0(sp)
    800003de:	0141                	addi	sp,sp,16
    800003e0:	8082                	ret

00000000800003e2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003e2:	7139                	addi	sp,sp,-64
    800003e4:	fc06                	sd	ra,56(sp)
    800003e6:	f822                	sd	s0,48(sp)
    800003e8:	f426                	sd	s1,40(sp)
    800003ea:	f04a                	sd	s2,32(sp)
    800003ec:	ec4e                	sd	s3,24(sp)
    800003ee:	e852                	sd	s4,16(sp)
    800003f0:	e456                	sd	s5,8(sp)
    800003f2:	e05a                	sd	s6,0(sp)
    800003f4:	0080                	addi	s0,sp,64
    800003f6:	84aa                	mv	s1,a0
    800003f8:	89ae                	mv	s3,a1
    800003fa:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003fc:	57fd                	li	a5,-1
    800003fe:	83e9                	srli	a5,a5,0x1a
    80000400:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000402:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000404:	04b7e263          	bltu	a5,a1,80000448 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000408:	0149d933          	srl	s2,s3,s4
    8000040c:	1ff97913          	andi	s2,s2,511
    80000410:	090e                	slli	s2,s2,0x3
    80000412:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000414:	00093483          	ld	s1,0(s2)
    80000418:	0014f793          	andi	a5,s1,1
    8000041c:	cf85                	beqz	a5,80000454 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000041e:	80a9                	srli	s1,s1,0xa
    80000420:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000422:	3a5d                	addiw	s4,s4,-9
    80000424:	ff6a12e3          	bne	s4,s6,80000408 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000428:	00c9d513          	srli	a0,s3,0xc
    8000042c:	1ff57513          	andi	a0,a0,511
    80000430:	050e                	slli	a0,a0,0x3
    80000432:	9526                	add	a0,a0,s1
}
    80000434:	70e2                	ld	ra,56(sp)
    80000436:	7442                	ld	s0,48(sp)
    80000438:	74a2                	ld	s1,40(sp)
    8000043a:	7902                	ld	s2,32(sp)
    8000043c:	69e2                	ld	s3,24(sp)
    8000043e:	6a42                	ld	s4,16(sp)
    80000440:	6aa2                	ld	s5,8(sp)
    80000442:	6b02                	ld	s6,0(sp)
    80000444:	6121                	addi	sp,sp,64
    80000446:	8082                	ret
    panic("walk");
    80000448:	00007517          	auipc	a0,0x7
    8000044c:	c0850513          	addi	a0,a0,-1016 # 80007050 <etext+0x50>
    80000450:	606050ef          	jal	80005a56 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000454:	020a8263          	beqz	s5,80000478 <walk+0x96>
    80000458:	ca7ff0ef          	jal	800000fe <kalloc>
    8000045c:	84aa                	mv	s1,a0
    8000045e:	d979                	beqz	a0,80000434 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000460:	6605                	lui	a2,0x1
    80000462:	4581                	li	a1,0
    80000464:	cebff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000468:	00c4d793          	srli	a5,s1,0xc
    8000046c:	07aa                	slli	a5,a5,0xa
    8000046e:	0017e793          	ori	a5,a5,1
    80000472:	00f93023          	sd	a5,0(s2)
    80000476:	b775                	j	80000422 <walk+0x40>
        return 0;
    80000478:	4501                	li	a0,0
    8000047a:	bf6d                	j	80000434 <walk+0x52>

000000008000047c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000047c:	57fd                	li	a5,-1
    8000047e:	83e9                	srli	a5,a5,0x1a
    80000480:	00b7f463          	bgeu	a5,a1,80000488 <walkaddr+0xc>
    return 0;
    80000484:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000486:	8082                	ret
{
    80000488:	1141                	addi	sp,sp,-16
    8000048a:	e406                	sd	ra,8(sp)
    8000048c:	e022                	sd	s0,0(sp)
    8000048e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000490:	4601                	li	a2,0
    80000492:	f51ff0ef          	jal	800003e2 <walk>
  if(pte == 0)
    80000496:	c105                	beqz	a0,800004b6 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000498:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000049a:	0117f693          	andi	a3,a5,17
    8000049e:	4745                	li	a4,17
    return 0;
    800004a0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004a2:	00e68663          	beq	a3,a4,800004ae <walkaddr+0x32>
}
    800004a6:	60a2                	ld	ra,8(sp)
    800004a8:	6402                	ld	s0,0(sp)
    800004aa:	0141                	addi	sp,sp,16
    800004ac:	8082                	ret
  pa = PTE2PA(*pte);
    800004ae:	83a9                	srli	a5,a5,0xa
    800004b0:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004b4:	bfcd                	j	800004a6 <walkaddr+0x2a>
    return 0;
    800004b6:	4501                	li	a0,0
    800004b8:	b7fd                	j	800004a6 <walkaddr+0x2a>

00000000800004ba <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004ba:	715d                	addi	sp,sp,-80
    800004bc:	e486                	sd	ra,72(sp)
    800004be:	e0a2                	sd	s0,64(sp)
    800004c0:	fc26                	sd	s1,56(sp)
    800004c2:	f84a                	sd	s2,48(sp)
    800004c4:	f44e                	sd	s3,40(sp)
    800004c6:	f052                	sd	s4,32(sp)
    800004c8:	ec56                	sd	s5,24(sp)
    800004ca:	e85a                	sd	s6,16(sp)
    800004cc:	e45e                	sd	s7,8(sp)
    800004ce:	e062                	sd	s8,0(sp)
    800004d0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004d2:	03459793          	slli	a5,a1,0x34
    800004d6:	e7b1                	bnez	a5,80000522 <mappages+0x68>
    800004d8:	8aaa                	mv	s5,a0
    800004da:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004dc:	03461793          	slli	a5,a2,0x34
    800004e0:	e7b9                	bnez	a5,8000052e <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    800004e2:	ce21                	beqz	a2,8000053a <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004e4:	77fd                	lui	a5,0xfffff
    800004e6:	963e                	add	a2,a2,a5
    800004e8:	00b609b3          	add	s3,a2,a1
  a = va;
    800004ec:	892e                	mv	s2,a1
    800004ee:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800004f2:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004f4:	6c05                	lui	s8,0x1
    800004f6:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fa:	865e                	mv	a2,s7
    800004fc:	85ca                	mv	a1,s2
    800004fe:	8556                	mv	a0,s5
    80000500:	ee3ff0ef          	jal	800003e2 <walk>
    80000504:	c539                	beqz	a0,80000552 <mappages+0x98>
    if(*pte & PTE_V)
    80000506:	611c                	ld	a5,0(a0)
    80000508:	8b85                	andi	a5,a5,1
    8000050a:	ef95                	bnez	a5,80000546 <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000050c:	80b1                	srli	s1,s1,0xc
    8000050e:	04aa                	slli	s1,s1,0xa
    80000510:	0164e4b3          	or	s1,s1,s6
    80000514:	0014e493          	ori	s1,s1,1
    80000518:	e104                	sd	s1,0(a0)
    if(a == last)
    8000051a:	05390963          	beq	s2,s3,8000056c <mappages+0xb2>
    a += PGSIZE;
    8000051e:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80000520:	bfd9                	j	800004f6 <mappages+0x3c>
    panic("mappages: va not aligned");
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b3650513          	addi	a0,a0,-1226 # 80007058 <etext+0x58>
    8000052a:	52c050ef          	jal	80005a56 <panic>
    panic("mappages: size not aligned");
    8000052e:	00007517          	auipc	a0,0x7
    80000532:	b4a50513          	addi	a0,a0,-1206 # 80007078 <etext+0x78>
    80000536:	520050ef          	jal	80005a56 <panic>
    panic("mappages: size");
    8000053a:	00007517          	auipc	a0,0x7
    8000053e:	b5e50513          	addi	a0,a0,-1186 # 80007098 <etext+0x98>
    80000542:	514050ef          	jal	80005a56 <panic>
      panic("mappages: remap");
    80000546:	00007517          	auipc	a0,0x7
    8000054a:	b6250513          	addi	a0,a0,-1182 # 800070a8 <etext+0xa8>
    8000054e:	508050ef          	jal	80005a56 <panic>
      return -1;
    80000552:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000554:	60a6                	ld	ra,72(sp)
    80000556:	6406                	ld	s0,64(sp)
    80000558:	74e2                	ld	s1,56(sp)
    8000055a:	7942                	ld	s2,48(sp)
    8000055c:	79a2                	ld	s3,40(sp)
    8000055e:	7a02                	ld	s4,32(sp)
    80000560:	6ae2                	ld	s5,24(sp)
    80000562:	6b42                	ld	s6,16(sp)
    80000564:	6ba2                	ld	s7,8(sp)
    80000566:	6c02                	ld	s8,0(sp)
    80000568:	6161                	addi	sp,sp,80
    8000056a:	8082                	ret
  return 0;
    8000056c:	4501                	li	a0,0
    8000056e:	b7dd                	j	80000554 <mappages+0x9a>

0000000080000570 <kvmmap>:
{
    80000570:	1141                	addi	sp,sp,-16
    80000572:	e406                	sd	ra,8(sp)
    80000574:	e022                	sd	s0,0(sp)
    80000576:	0800                	addi	s0,sp,16
    80000578:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000057a:	86b2                	mv	a3,a2
    8000057c:	863e                	mv	a2,a5
    8000057e:	f3dff0ef          	jal	800004ba <mappages>
    80000582:	e509                	bnez	a0,8000058c <kvmmap+0x1c>
}
    80000584:	60a2                	ld	ra,8(sp)
    80000586:	6402                	ld	s0,0(sp)
    80000588:	0141                	addi	sp,sp,16
    8000058a:	8082                	ret
    panic("kvmmap");
    8000058c:	00007517          	auipc	a0,0x7
    80000590:	b2c50513          	addi	a0,a0,-1236 # 800070b8 <etext+0xb8>
    80000594:	4c2050ef          	jal	80005a56 <panic>

0000000080000598 <kvmmake>:
{
    80000598:	1101                	addi	sp,sp,-32
    8000059a:	ec06                	sd	ra,24(sp)
    8000059c:	e822                	sd	s0,16(sp)
    8000059e:	e426                	sd	s1,8(sp)
    800005a0:	e04a                	sd	s2,0(sp)
    800005a2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005a4:	b5bff0ef          	jal	800000fe <kalloc>
    800005a8:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005aa:	6605                	lui	a2,0x1
    800005ac:	4581                	li	a1,0
    800005ae:	ba1ff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005b2:	4719                	li	a4,6
    800005b4:	6685                	lui	a3,0x1
    800005b6:	10000637          	lui	a2,0x10000
    800005ba:	85b2                	mv	a1,a2
    800005bc:	8526                	mv	a0,s1
    800005be:	fb3ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005c2:	4719                	li	a4,6
    800005c4:	6685                	lui	a3,0x1
    800005c6:	10001637          	lui	a2,0x10001
    800005ca:	85b2                	mv	a1,a2
    800005cc:	8526                	mv	a0,s1
    800005ce:	fa3ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005d2:	4719                	li	a4,6
    800005d4:	040006b7          	lui	a3,0x4000
    800005d8:	0c000637          	lui	a2,0xc000
    800005dc:	85b2                	mv	a1,a2
    800005de:	8526                	mv	a0,s1
    800005e0:	f91ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005e4:	00007917          	auipc	s2,0x7
    800005e8:	a1c90913          	addi	s2,s2,-1508 # 80007000 <etext>
    800005ec:	4729                	li	a4,10
    800005ee:	80007697          	auipc	a3,0x80007
    800005f2:	a1268693          	addi	a3,a3,-1518 # 7000 <_entry-0x7fff9000>
    800005f6:	4605                	li	a2,1
    800005f8:	067e                	slli	a2,a2,0x1f
    800005fa:	85b2                	mv	a1,a2
    800005fc:	8526                	mv	a0,s1
    800005fe:	f73ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000602:	4719                	li	a4,6
    80000604:	46c5                	li	a3,17
    80000606:	06ee                	slli	a3,a3,0x1b
    80000608:	412686b3          	sub	a3,a3,s2
    8000060c:	864a                	mv	a2,s2
    8000060e:	85ca                	mv	a1,s2
    80000610:	8526                	mv	a0,s1
    80000612:	f5fff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000616:	4729                	li	a4,10
    80000618:	6685                	lui	a3,0x1
    8000061a:	00006617          	auipc	a2,0x6
    8000061e:	9e660613          	addi	a2,a2,-1562 # 80006000 <_trampoline>
    80000622:	040005b7          	lui	a1,0x4000
    80000626:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000628:	05b2                	slli	a1,a1,0xc
    8000062a:	8526                	mv	a0,s1
    8000062c:	f45ff0ef          	jal	80000570 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000630:	8526                	mv	a0,s1
    80000632:	656000ef          	jal	80000c88 <proc_mapstacks>
}
    80000636:	8526                	mv	a0,s1
    80000638:	60e2                	ld	ra,24(sp)
    8000063a:	6442                	ld	s0,16(sp)
    8000063c:	64a2                	ld	s1,8(sp)
    8000063e:	6902                	ld	s2,0(sp)
    80000640:	6105                	addi	sp,sp,32
    80000642:	8082                	ret

0000000080000644 <kvminit>:
{
    80000644:	1141                	addi	sp,sp,-16
    80000646:	e406                	sd	ra,8(sp)
    80000648:	e022                	sd	s0,0(sp)
    8000064a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000064c:	f4dff0ef          	jal	80000598 <kvmmake>
    80000650:	0000a797          	auipc	a5,0xa
    80000654:	f2a7b423          	sd	a0,-216(a5) # 8000a578 <kernel_pagetable>
}
    80000658:	60a2                	ld	ra,8(sp)
    8000065a:	6402                	ld	s0,0(sp)
    8000065c:	0141                	addi	sp,sp,16
    8000065e:	8082                	ret

0000000080000660 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000660:	715d                	addi	sp,sp,-80
    80000662:	e486                	sd	ra,72(sp)
    80000664:	e0a2                	sd	s0,64(sp)
    80000666:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000668:	03459793          	slli	a5,a1,0x34
    8000066c:	e39d                	bnez	a5,80000692 <uvmunmap+0x32>
    8000066e:	f84a                	sd	s2,48(sp)
    80000670:	f44e                	sd	s3,40(sp)
    80000672:	f052                	sd	s4,32(sp)
    80000674:	ec56                	sd	s5,24(sp)
    80000676:	e85a                	sd	s6,16(sp)
    80000678:	e45e                	sd	s7,8(sp)
    8000067a:	8a2a                	mv	s4,a0
    8000067c:	892e                	mv	s2,a1
    8000067e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000680:	0632                	slli	a2,a2,0xc
    80000682:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000686:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000688:	6b05                	lui	s6,0x1
    8000068a:	0735ff63          	bgeu	a1,s3,80000708 <uvmunmap+0xa8>
    8000068e:	fc26                	sd	s1,56(sp)
    80000690:	a0a9                	j	800006da <uvmunmap+0x7a>
    80000692:	fc26                	sd	s1,56(sp)
    80000694:	f84a                	sd	s2,48(sp)
    80000696:	f44e                	sd	s3,40(sp)
    80000698:	f052                	sd	s4,32(sp)
    8000069a:	ec56                	sd	s5,24(sp)
    8000069c:	e85a                	sd	s6,16(sp)
    8000069e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006a0:	00007517          	auipc	a0,0x7
    800006a4:	a2050513          	addi	a0,a0,-1504 # 800070c0 <etext+0xc0>
    800006a8:	3ae050ef          	jal	80005a56 <panic>
      panic("uvmunmap: walk");
    800006ac:	00007517          	auipc	a0,0x7
    800006b0:	a2c50513          	addi	a0,a0,-1492 # 800070d8 <etext+0xd8>
    800006b4:	3a2050ef          	jal	80005a56 <panic>
      panic("uvmunmap: not mapped");
    800006b8:	00007517          	auipc	a0,0x7
    800006bc:	a3050513          	addi	a0,a0,-1488 # 800070e8 <etext+0xe8>
    800006c0:	396050ef          	jal	80005a56 <panic>
      panic("uvmunmap: not a leaf");
    800006c4:	00007517          	auipc	a0,0x7
    800006c8:	a3c50513          	addi	a0,a0,-1476 # 80007100 <etext+0x100>
    800006cc:	38a050ef          	jal	80005a56 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006d0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006d4:	995a                	add	s2,s2,s6
    800006d6:	03397863          	bgeu	s2,s3,80000706 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006da:	4601                	li	a2,0
    800006dc:	85ca                	mv	a1,s2
    800006de:	8552                	mv	a0,s4
    800006e0:	d03ff0ef          	jal	800003e2 <walk>
    800006e4:	84aa                	mv	s1,a0
    800006e6:	d179                	beqz	a0,800006ac <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    800006e8:	6108                	ld	a0,0(a0)
    800006ea:	00157793          	andi	a5,a0,1
    800006ee:	d7e9                	beqz	a5,800006b8 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006f0:	3ff57793          	andi	a5,a0,1023
    800006f4:	fd7788e3          	beq	a5,s7,800006c4 <uvmunmap+0x64>
    if(do_free){
    800006f8:	fc0a8ce3          	beqz	s5,800006d0 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    800006fc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800006fe:	0532                	slli	a0,a0,0xc
    80000700:	91dff0ef          	jal	8000001c <kfree>
    80000704:	b7f1                	j	800006d0 <uvmunmap+0x70>
    80000706:	74e2                	ld	s1,56(sp)
    80000708:	7942                	ld	s2,48(sp)
    8000070a:	79a2                	ld	s3,40(sp)
    8000070c:	7a02                	ld	s4,32(sp)
    8000070e:	6ae2                	ld	s5,24(sp)
    80000710:	6b42                	ld	s6,16(sp)
    80000712:	6ba2                	ld	s7,8(sp)
  }
}
    80000714:	60a6                	ld	ra,72(sp)
    80000716:	6406                	ld	s0,64(sp)
    80000718:	6161                	addi	sp,sp,80
    8000071a:	8082                	ret

000000008000071c <vmaunmap>:

void 
vmaunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000071c:	715d                	addi	sp,sp,-80
    8000071e:	e486                	sd	ra,72(sp)
    80000720:	e0a2                	sd	s0,64(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e39d                	bnez	a5,8000074e <vmaunmap+0x32>
    8000072a:	f84a                	sd	s2,48(sp)
    8000072c:	f44e                	sd	s3,40(sp)
    8000072e:	f052                	sd	s4,32(sp)
    80000730:	ec56                	sd	s5,24(sp)
    80000732:	e85a                	sd	s6,16(sp)
    80000734:	e45e                	sd	s7,8(sp)
    80000736:	8a2a                	mv	s4,a0
    80000738:	892e                	mv	s2,a1
    8000073a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000073c:	0632                	slli	a2,a2,0xc
    8000073e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      return;
    if((*pte & PTE_V) == 0)
      return;
    if(PTE_FLAGS(*pte) == PTE_V)
    80000742:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000744:	6b05                	lui	s6,0x1
    80000746:	0735f663          	bgeu	a1,s3,800007b2 <vmaunmap+0x96>
    8000074a:	fc26                	sd	s1,56(sp)
    8000074c:	a80d                	j	8000077e <vmaunmap+0x62>
    8000074e:	fc26                	sd	s1,56(sp)
    80000750:	f84a                	sd	s2,48(sp)
    80000752:	f44e                	sd	s3,40(sp)
    80000754:	f052                	sd	s4,32(sp)
    80000756:	ec56                	sd	s5,24(sp)
    80000758:	e85a                	sd	s6,16(sp)
    8000075a:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000075c:	00007517          	auipc	a0,0x7
    80000760:	96450513          	addi	a0,a0,-1692 # 800070c0 <etext+0xc0>
    80000764:	2f2050ef          	jal	80005a56 <panic>
      panic("uvmunmap: not a leaf");
    80000768:	00007517          	auipc	a0,0x7
    8000076c:	99850513          	addi	a0,a0,-1640 # 80007100 <etext+0x100>
    80000770:	2e6050ef          	jal	80005a56 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000774:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000778:	995a                	add	s2,s2,s6
    8000077a:	03397963          	bgeu	s2,s3,800007ac <vmaunmap+0x90>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000077e:	4601                	li	a2,0
    80000780:	85ca                	mv	a1,s2
    80000782:	8552                	mv	a0,s4
    80000784:	c5fff0ef          	jal	800003e2 <walk>
    80000788:	84aa                	mv	s1,a0
    8000078a:	c11d                	beqz	a0,800007b0 <vmaunmap+0x94>
    if((*pte & PTE_V) == 0)
    8000078c:	611c                	ld	a5,0(a0)
    8000078e:	0017f713          	andi	a4,a5,1
    80000792:	cb15                	beqz	a4,800007c6 <vmaunmap+0xaa>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000794:	3ff7f713          	andi	a4,a5,1023
    80000798:	fd7708e3          	beq	a4,s7,80000768 <vmaunmap+0x4c>
    if(do_free){
    8000079c:	fc0a8ce3          	beqz	s5,80000774 <vmaunmap+0x58>
      uint64 pa = PTE2PA(*pte);
    800007a0:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800007a2:	00c79513          	slli	a0,a5,0xc
    800007a6:	877ff0ef          	jal	8000001c <kfree>
    800007aa:	b7e9                	j	80000774 <vmaunmap+0x58>
    800007ac:	74e2                	ld	s1,56(sp)
    800007ae:	a011                	j	800007b2 <vmaunmap+0x96>
    800007b0:	74e2                	ld	s1,56(sp)
    800007b2:	7942                	ld	s2,48(sp)
    800007b4:	79a2                	ld	s3,40(sp)
    800007b6:	7a02                	ld	s4,32(sp)
    800007b8:	6ae2                	ld	s5,24(sp)
    800007ba:	6b42                	ld	s6,16(sp)
    800007bc:	6ba2                	ld	s7,8(sp)
  }

}
    800007be:	60a6                	ld	ra,72(sp)
    800007c0:	6406                	ld	s0,64(sp)
    800007c2:	6161                	addi	sp,sp,80
    800007c4:	8082                	ret
    800007c6:	74e2                	ld	s1,56(sp)
    800007c8:	b7ed                	j	800007b2 <vmaunmap+0x96>

00000000800007ca <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ca:	1101                	addi	sp,sp,-32
    800007cc:	ec06                	sd	ra,24(sp)
    800007ce:	e822                	sd	s0,16(sp)
    800007d0:	e426                	sd	s1,8(sp)
    800007d2:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d4:	92bff0ef          	jal	800000fe <kalloc>
    800007d8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007da:	c509                	beqz	a0,800007e4 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007dc:	6605                	lui	a2,0x1
    800007de:	4581                	li	a1,0
    800007e0:	96fff0ef          	jal	8000014e <memset>
  return pagetable;
}
    800007e4:	8526                	mv	a0,s1
    800007e6:	60e2                	ld	ra,24(sp)
    800007e8:	6442                	ld	s0,16(sp)
    800007ea:	64a2                	ld	s1,8(sp)
    800007ec:	6105                	addi	sp,sp,32
    800007ee:	8082                	ret

00000000800007f0 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f0:	7179                	addi	sp,sp,-48
    800007f2:	f406                	sd	ra,40(sp)
    800007f4:	f022                	sd	s0,32(sp)
    800007f6:	ec26                	sd	s1,24(sp)
    800007f8:	e84a                	sd	s2,16(sp)
    800007fa:	e44e                	sd	s3,8(sp)
    800007fc:	e052                	sd	s4,0(sp)
    800007fe:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000800:	6785                	lui	a5,0x1
    80000802:	04f67063          	bgeu	a2,a5,80000842 <uvmfirst+0x52>
    80000806:	8a2a                	mv	s4,a0
    80000808:	89ae                	mv	s3,a1
    8000080a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000080c:	8f3ff0ef          	jal	800000fe <kalloc>
    80000810:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000812:	6605                	lui	a2,0x1
    80000814:	4581                	li	a1,0
    80000816:	939ff0ef          	jal	8000014e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000081a:	4779                	li	a4,30
    8000081c:	86ca                	mv	a3,s2
    8000081e:	6605                	lui	a2,0x1
    80000820:	4581                	li	a1,0
    80000822:	8552                	mv	a0,s4
    80000824:	c97ff0ef          	jal	800004ba <mappages>
  memmove(mem, src, sz);
    80000828:	8626                	mv	a2,s1
    8000082a:	85ce                	mv	a1,s3
    8000082c:	854a                	mv	a0,s2
    8000082e:	985ff0ef          	jal	800001b2 <memmove>
}
    80000832:	70a2                	ld	ra,40(sp)
    80000834:	7402                	ld	s0,32(sp)
    80000836:	64e2                	ld	s1,24(sp)
    80000838:	6942                	ld	s2,16(sp)
    8000083a:	69a2                	ld	s3,8(sp)
    8000083c:	6a02                	ld	s4,0(sp)
    8000083e:	6145                	addi	sp,sp,48
    80000840:	8082                	ret
    panic("uvmfirst: more than a page");
    80000842:	00007517          	auipc	a0,0x7
    80000846:	8d650513          	addi	a0,a0,-1834 # 80007118 <etext+0x118>
    8000084a:	20c050ef          	jal	80005a56 <panic>

000000008000084e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000084e:	1101                	addi	sp,sp,-32
    80000850:	ec06                	sd	ra,24(sp)
    80000852:	e822                	sd	s0,16(sp)
    80000854:	e426                	sd	s1,8(sp)
    80000856:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000858:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000085a:	00b67d63          	bgeu	a2,a1,80000874 <uvmdealloc+0x26>
    8000085e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000860:	6785                	lui	a5,0x1
    80000862:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000864:	00f60733          	add	a4,a2,a5
    80000868:	76fd                	lui	a3,0xfffff
    8000086a:	8f75                	and	a4,a4,a3
    8000086c:	97ae                	add	a5,a5,a1
    8000086e:	8ff5                	and	a5,a5,a3
    80000870:	00f76863          	bltu	a4,a5,80000880 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000874:	8526                	mv	a0,s1
    80000876:	60e2                	ld	ra,24(sp)
    80000878:	6442                	ld	s0,16(sp)
    8000087a:	64a2                	ld	s1,8(sp)
    8000087c:	6105                	addi	sp,sp,32
    8000087e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000880:	8f99                	sub	a5,a5,a4
    80000882:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000884:	4685                	li	a3,1
    80000886:	0007861b          	sext.w	a2,a5
    8000088a:	85ba                	mv	a1,a4
    8000088c:	dd5ff0ef          	jal	80000660 <uvmunmap>
    80000890:	b7d5                	j	80000874 <uvmdealloc+0x26>

0000000080000892 <uvmalloc>:
  if(newsz < oldsz)
    80000892:	0ab66363          	bltu	a2,a1,80000938 <uvmalloc+0xa6>
{
    80000896:	715d                	addi	sp,sp,-80
    80000898:	e486                	sd	ra,72(sp)
    8000089a:	e0a2                	sd	s0,64(sp)
    8000089c:	f052                	sd	s4,32(sp)
    8000089e:	ec56                	sd	s5,24(sp)
    800008a0:	e85a                	sd	s6,16(sp)
    800008a2:	0880                	addi	s0,sp,80
    800008a4:	8b2a                	mv	s6,a0
    800008a6:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    800008a8:	6785                	lui	a5,0x1
    800008aa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008ac:	95be                	add	a1,a1,a5
    800008ae:	77fd                	lui	a5,0xfffff
    800008b0:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008b4:	08ca7463          	bgeu	s4,a2,8000093c <uvmalloc+0xaa>
    800008b8:	fc26                	sd	s1,56(sp)
    800008ba:	f84a                	sd	s2,48(sp)
    800008bc:	f44e                	sd	s3,40(sp)
    800008be:	e45e                	sd	s7,8(sp)
    800008c0:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    800008c2:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008c4:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    800008c8:	837ff0ef          	jal	800000fe <kalloc>
    800008cc:	84aa                	mv	s1,a0
    if(mem == 0){
    800008ce:	c515                	beqz	a0,800008fa <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800008d0:	864e                	mv	a2,s3
    800008d2:	4581                	li	a1,0
    800008d4:	87bff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008d8:	875e                	mv	a4,s7
    800008da:	86a6                	mv	a3,s1
    800008dc:	864e                	mv	a2,s3
    800008de:	85ca                	mv	a1,s2
    800008e0:	855a                	mv	a0,s6
    800008e2:	bd9ff0ef          	jal	800004ba <mappages>
    800008e6:	e91d                	bnez	a0,8000091c <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e8:	994e                	add	s2,s2,s3
    800008ea:	fd596fe3          	bltu	s2,s5,800008c8 <uvmalloc+0x36>
  return newsz;
    800008ee:	8556                	mv	a0,s5
    800008f0:	74e2                	ld	s1,56(sp)
    800008f2:	7942                	ld	s2,48(sp)
    800008f4:	79a2                	ld	s3,40(sp)
    800008f6:	6ba2                	ld	s7,8(sp)
    800008f8:	a819                	j	8000090e <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    800008fa:	8652                	mv	a2,s4
    800008fc:	85ca                	mv	a1,s2
    800008fe:	855a                	mv	a0,s6
    80000900:	f4fff0ef          	jal	8000084e <uvmdealloc>
      return 0;
    80000904:	4501                	li	a0,0
    80000906:	74e2                	ld	s1,56(sp)
    80000908:	7942                	ld	s2,48(sp)
    8000090a:	79a2                	ld	s3,40(sp)
    8000090c:	6ba2                	ld	s7,8(sp)
}
    8000090e:	60a6                	ld	ra,72(sp)
    80000910:	6406                	ld	s0,64(sp)
    80000912:	7a02                	ld	s4,32(sp)
    80000914:	6ae2                	ld	s5,24(sp)
    80000916:	6b42                	ld	s6,16(sp)
    80000918:	6161                	addi	sp,sp,80
    8000091a:	8082                	ret
      kfree(mem);
    8000091c:	8526                	mv	a0,s1
    8000091e:	efeff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000922:	8652                	mv	a2,s4
    80000924:	85ca                	mv	a1,s2
    80000926:	855a                	mv	a0,s6
    80000928:	f27ff0ef          	jal	8000084e <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
    8000092e:	74e2                	ld	s1,56(sp)
    80000930:	7942                	ld	s2,48(sp)
    80000932:	79a2                	ld	s3,40(sp)
    80000934:	6ba2                	ld	s7,8(sp)
    80000936:	bfe1                	j	8000090e <uvmalloc+0x7c>
    return oldsz;
    80000938:	852e                	mv	a0,a1
}
    8000093a:	8082                	ret
  return newsz;
    8000093c:	8532                	mv	a0,a2
    8000093e:	bfc1                	j	8000090e <uvmalloc+0x7c>

0000000080000940 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000940:	7179                	addi	sp,sp,-48
    80000942:	f406                	sd	ra,40(sp)
    80000944:	f022                	sd	s0,32(sp)
    80000946:	ec26                	sd	s1,24(sp)
    80000948:	e84a                	sd	s2,16(sp)
    8000094a:	e44e                	sd	s3,8(sp)
    8000094c:	e052                	sd	s4,0(sp)
    8000094e:	1800                	addi	s0,sp,48
    80000950:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000952:	84aa                	mv	s1,a0
    80000954:	6905                	lui	s2,0x1
    80000956:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000958:	4985                	li	s3,1
    8000095a:	a819                	j	80000970 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000095c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000095e:	00c79513          	slli	a0,a5,0xc
    80000962:	fdfff0ef          	jal	80000940 <freewalk>
      pagetable[i] = 0;
    80000966:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000096a:	04a1                	addi	s1,s1,8
    8000096c:	01248f63          	beq	s1,s2,8000098a <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80000970:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000972:	00f7f713          	andi	a4,a5,15
    80000976:	ff3703e3          	beq	a4,s3,8000095c <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000097a:	8b85                	andi	a5,a5,1
    8000097c:	d7fd                	beqz	a5,8000096a <freewalk+0x2a>
      panic("freewalk: leaf");
    8000097e:	00006517          	auipc	a0,0x6
    80000982:	7ba50513          	addi	a0,a0,1978 # 80007138 <etext+0x138>
    80000986:	0d0050ef          	jal	80005a56 <panic>
    }
  }
  kfree((void*)pagetable);
    8000098a:	8552                	mv	a0,s4
    8000098c:	e90ff0ef          	jal	8000001c <kfree>
}
    80000990:	70a2                	ld	ra,40(sp)
    80000992:	7402                	ld	s0,32(sp)
    80000994:	64e2                	ld	s1,24(sp)
    80000996:	6942                	ld	s2,16(sp)
    80000998:	69a2                	ld	s3,8(sp)
    8000099a:	6a02                	ld	s4,0(sp)
    8000099c:	6145                	addi	sp,sp,48
    8000099e:	8082                	ret

00000000800009a0 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009a0:	1101                	addi	sp,sp,-32
    800009a2:	ec06                	sd	ra,24(sp)
    800009a4:	e822                	sd	s0,16(sp)
    800009a6:	e426                	sd	s1,8(sp)
    800009a8:	1000                	addi	s0,sp,32
    800009aa:	84aa                	mv	s1,a0
  if(sz > 0)
    800009ac:	e989                	bnez	a1,800009be <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009ae:	8526                	mv	a0,s1
    800009b0:	f91ff0ef          	jal	80000940 <freewalk>
}
    800009b4:	60e2                	ld	ra,24(sp)
    800009b6:	6442                	ld	s0,16(sp)
    800009b8:	64a2                	ld	s1,8(sp)
    800009ba:	6105                	addi	sp,sp,32
    800009bc:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009be:	6785                	lui	a5,0x1
    800009c0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009c2:	95be                	add	a1,a1,a5
    800009c4:	4685                	li	a3,1
    800009c6:	00c5d613          	srli	a2,a1,0xc
    800009ca:	4581                	li	a1,0
    800009cc:	c95ff0ef          	jal	80000660 <uvmunmap>
    800009d0:	bff9                	j	800009ae <uvmfree+0xe>

00000000800009d2 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009d2:	ca4d                	beqz	a2,80000a84 <uvmcopy+0xb2>
{
    800009d4:	715d                	addi	sp,sp,-80
    800009d6:	e486                	sd	ra,72(sp)
    800009d8:	e0a2                	sd	s0,64(sp)
    800009da:	fc26                	sd	s1,56(sp)
    800009dc:	f84a                	sd	s2,48(sp)
    800009de:	f44e                	sd	s3,40(sp)
    800009e0:	f052                	sd	s4,32(sp)
    800009e2:	ec56                	sd	s5,24(sp)
    800009e4:	e85a                	sd	s6,16(sp)
    800009e6:	e45e                	sd	s7,8(sp)
    800009e8:	e062                	sd	s8,0(sp)
    800009ea:	0880                	addi	s0,sp,80
    800009ec:	8baa                	mv	s7,a0
    800009ee:	8b2e                	mv	s6,a1
    800009f0:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    800009f2:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800009f4:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    800009f6:	4601                	li	a2,0
    800009f8:	85ce                	mv	a1,s3
    800009fa:	855e                	mv	a0,s7
    800009fc:	9e7ff0ef          	jal	800003e2 <walk>
    80000a00:	cd1d                	beqz	a0,80000a3e <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    80000a02:	6118                	ld	a4,0(a0)
    80000a04:	00177793          	andi	a5,a4,1
    80000a08:	c3a9                	beqz	a5,80000a4a <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    80000a0a:	00a75593          	srli	a1,a4,0xa
    80000a0e:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a12:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a16:	ee8ff0ef          	jal	800000fe <kalloc>
    80000a1a:	892a                	mv	s2,a0
    80000a1c:	c121                	beqz	a0,80000a5c <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    80000a1e:	8652                	mv	a2,s4
    80000a20:	85e2                	mv	a1,s8
    80000a22:	f90ff0ef          	jal	800001b2 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a26:	8726                	mv	a4,s1
    80000a28:	86ca                	mv	a3,s2
    80000a2a:	8652                	mv	a2,s4
    80000a2c:	85ce                	mv	a1,s3
    80000a2e:	855a                	mv	a0,s6
    80000a30:	a8bff0ef          	jal	800004ba <mappages>
    80000a34:	e10d                	bnez	a0,80000a56 <uvmcopy+0x84>
  for(i = 0; i < sz; i += PGSIZE){
    80000a36:	99d2                	add	s3,s3,s4
    80000a38:	fb59efe3          	bltu	s3,s5,800009f6 <uvmcopy+0x24>
    80000a3c:	a805                	j	80000a6c <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    80000a3e:	00006517          	auipc	a0,0x6
    80000a42:	70a50513          	addi	a0,a0,1802 # 80007148 <etext+0x148>
    80000a46:	010050ef          	jal	80005a56 <panic>
      panic("uvmcopy: page not present");
    80000a4a:	00006517          	auipc	a0,0x6
    80000a4e:	71e50513          	addi	a0,a0,1822 # 80007168 <etext+0x168>
    80000a52:	004050ef          	jal	80005a56 <panic>
      kfree(mem);
    80000a56:	854a                	mv	a0,s2
    80000a58:	dc4ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a5c:	4685                	li	a3,1
    80000a5e:	00c9d613          	srli	a2,s3,0xc
    80000a62:	4581                	li	a1,0
    80000a64:	855a                	mv	a0,s6
    80000a66:	bfbff0ef          	jal	80000660 <uvmunmap>
  return -1;
    80000a6a:	557d                	li	a0,-1
}
    80000a6c:	60a6                	ld	ra,72(sp)
    80000a6e:	6406                	ld	s0,64(sp)
    80000a70:	74e2                	ld	s1,56(sp)
    80000a72:	7942                	ld	s2,48(sp)
    80000a74:	79a2                	ld	s3,40(sp)
    80000a76:	7a02                	ld	s4,32(sp)
    80000a78:	6ae2                	ld	s5,24(sp)
    80000a7a:	6b42                	ld	s6,16(sp)
    80000a7c:	6ba2                	ld	s7,8(sp)
    80000a7e:	6c02                	ld	s8,0(sp)
    80000a80:	6161                	addi	sp,sp,80
    80000a82:	8082                	ret
  return 0;
    80000a84:	4501                	li	a0,0
}
    80000a86:	8082                	ret

0000000080000a88 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000a88:	1141                	addi	sp,sp,-16
    80000a8a:	e406                	sd	ra,8(sp)
    80000a8c:	e022                	sd	s0,0(sp)
    80000a8e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000a90:	4601                	li	a2,0
    80000a92:	951ff0ef          	jal	800003e2 <walk>
  if(pte == 0)
    80000a96:	c901                	beqz	a0,80000aa6 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000a98:	611c                	ld	a5,0(a0)
    80000a9a:	9bbd                	andi	a5,a5,-17
    80000a9c:	e11c                	sd	a5,0(a0)
}
    80000a9e:	60a2                	ld	ra,8(sp)
    80000aa0:	6402                	ld	s0,0(sp)
    80000aa2:	0141                	addi	sp,sp,16
    80000aa4:	8082                	ret
    panic("uvmclear");
    80000aa6:	00006517          	auipc	a0,0x6
    80000aaa:	6e250513          	addi	a0,a0,1762 # 80007188 <etext+0x188>
    80000aae:	7a9040ef          	jal	80005a56 <panic>

0000000080000ab2 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000ab2:	c2d9                	beqz	a3,80000b38 <copyout+0x86>
{
    80000ab4:	711d                	addi	sp,sp,-96
    80000ab6:	ec86                	sd	ra,88(sp)
    80000ab8:	e8a2                	sd	s0,80(sp)
    80000aba:	e4a6                	sd	s1,72(sp)
    80000abc:	e0ca                	sd	s2,64(sp)
    80000abe:	fc4e                	sd	s3,56(sp)
    80000ac0:	f852                	sd	s4,48(sp)
    80000ac2:	f456                	sd	s5,40(sp)
    80000ac4:	f05a                	sd	s6,32(sp)
    80000ac6:	ec5e                	sd	s7,24(sp)
    80000ac8:	e862                	sd	s8,16(sp)
    80000aca:	e466                	sd	s9,8(sp)
    80000acc:	e06a                	sd	s10,0(sp)
    80000ace:	1080                	addi	s0,sp,96
    80000ad0:	8c2a                	mv	s8,a0
    80000ad2:	892e                	mv	s2,a1
    80000ad4:	8ab2                	mv	s5,a2
    80000ad6:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000ad8:	7cfd                	lui	s9,0xfffff
    if(va0 >= MAXVA)
    80000ada:	5bfd                	li	s7,-1
    80000adc:	01abdb93          	srli	s7,s7,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000ae0:	4d55                	li	s10,21
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    80000ae2:	6b05                	lui	s6,0x1
    80000ae4:	a015                	j	80000b08 <copyout+0x56>
    pa0 = PTE2PA(*pte);
    80000ae6:	83a9                	srli	a5,a5,0xa
    80000ae8:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000aea:	41390533          	sub	a0,s2,s3
    80000aee:	0004861b          	sext.w	a2,s1
    80000af2:	85d6                	mv	a1,s5
    80000af4:	953e                	add	a0,a0,a5
    80000af6:	ebcff0ef          	jal	800001b2 <memmove>

    len -= n;
    80000afa:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000afe:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000b00:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000b04:	020a0863          	beqz	s4,80000b34 <copyout+0x82>
    va0 = PGROUNDDOWN(dstva);
    80000b08:	019979b3          	and	s3,s2,s9
    if(va0 >= MAXVA)
    80000b0c:	033be863          	bltu	s7,s3,80000b3c <copyout+0x8a>
    pte = walk(pagetable, va0, 0);
    80000b10:	4601                	li	a2,0
    80000b12:	85ce                	mv	a1,s3
    80000b14:	8562                	mv	a0,s8
    80000b16:	8cdff0ef          	jal	800003e2 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b1a:	c121                	beqz	a0,80000b5a <copyout+0xa8>
    80000b1c:	611c                	ld	a5,0(a0)
    80000b1e:	0157f713          	andi	a4,a5,21
    80000b22:	03a71e63          	bne	a4,s10,80000b5e <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    80000b26:	412984b3          	sub	s1,s3,s2
    80000b2a:	94da                	add	s1,s1,s6
    if(n > len)
    80000b2c:	fa9a7de3          	bgeu	s4,s1,80000ae6 <copyout+0x34>
    80000b30:	84d2                	mv	s1,s4
    80000b32:	bf55                	j	80000ae6 <copyout+0x34>
  }
  return 0;
    80000b34:	4501                	li	a0,0
    80000b36:	a021                	j	80000b3e <copyout+0x8c>
    80000b38:	4501                	li	a0,0
}
    80000b3a:	8082                	ret
      return -1;
    80000b3c:	557d                	li	a0,-1
}
    80000b3e:	60e6                	ld	ra,88(sp)
    80000b40:	6446                	ld	s0,80(sp)
    80000b42:	64a6                	ld	s1,72(sp)
    80000b44:	6906                	ld	s2,64(sp)
    80000b46:	79e2                	ld	s3,56(sp)
    80000b48:	7a42                	ld	s4,48(sp)
    80000b4a:	7aa2                	ld	s5,40(sp)
    80000b4c:	7b02                	ld	s6,32(sp)
    80000b4e:	6be2                	ld	s7,24(sp)
    80000b50:	6c42                	ld	s8,16(sp)
    80000b52:	6ca2                	ld	s9,8(sp)
    80000b54:	6d02                	ld	s10,0(sp)
    80000b56:	6125                	addi	sp,sp,96
    80000b58:	8082                	ret
      return -1;
    80000b5a:	557d                	li	a0,-1
    80000b5c:	b7cd                	j	80000b3e <copyout+0x8c>
    80000b5e:	557d                	li	a0,-1
    80000b60:	bff9                	j	80000b3e <copyout+0x8c>

0000000080000b62 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b62:	c6a5                	beqz	a3,80000bca <copyin+0x68>
{
    80000b64:	715d                	addi	sp,sp,-80
    80000b66:	e486                	sd	ra,72(sp)
    80000b68:	e0a2                	sd	s0,64(sp)
    80000b6a:	fc26                	sd	s1,56(sp)
    80000b6c:	f84a                	sd	s2,48(sp)
    80000b6e:	f44e                	sd	s3,40(sp)
    80000b70:	f052                	sd	s4,32(sp)
    80000b72:	ec56                	sd	s5,24(sp)
    80000b74:	e85a                	sd	s6,16(sp)
    80000b76:	e45e                	sd	s7,8(sp)
    80000b78:	e062                	sd	s8,0(sp)
    80000b7a:	0880                	addi	s0,sp,80
    80000b7c:	8b2a                	mv	s6,a0
    80000b7e:	8a2e                	mv	s4,a1
    80000b80:	8c32                	mv	s8,a2
    80000b82:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b84:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b86:	6a85                	lui	s5,0x1
    80000b88:	a00d                	j	80000baa <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b8a:	018505b3          	add	a1,a0,s8
    80000b8e:	0004861b          	sext.w	a2,s1
    80000b92:	412585b3          	sub	a1,a1,s2
    80000b96:	8552                	mv	a0,s4
    80000b98:	e1aff0ef          	jal	800001b2 <memmove>

    len -= n;
    80000b9c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000ba0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000ba2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ba6:	02098063          	beqz	s3,80000bc6 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000baa:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bae:	85ca                	mv	a1,s2
    80000bb0:	855a                	mv	a0,s6
    80000bb2:	8cbff0ef          	jal	8000047c <walkaddr>
    if(pa0 == 0)
    80000bb6:	cd01                	beqz	a0,80000bce <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000bb8:	418904b3          	sub	s1,s2,s8
    80000bbc:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bbe:	fc99f6e3          	bgeu	s3,s1,80000b8a <copyin+0x28>
    80000bc2:	84ce                	mv	s1,s3
    80000bc4:	b7d9                	j	80000b8a <copyin+0x28>
  }
  return 0;
    80000bc6:	4501                	li	a0,0
    80000bc8:	a021                	j	80000bd0 <copyin+0x6e>
    80000bca:	4501                	li	a0,0
}
    80000bcc:	8082                	ret
      return -1;
    80000bce:	557d                	li	a0,-1
}
    80000bd0:	60a6                	ld	ra,72(sp)
    80000bd2:	6406                	ld	s0,64(sp)
    80000bd4:	74e2                	ld	s1,56(sp)
    80000bd6:	7942                	ld	s2,48(sp)
    80000bd8:	79a2                	ld	s3,40(sp)
    80000bda:	7a02                	ld	s4,32(sp)
    80000bdc:	6ae2                	ld	s5,24(sp)
    80000bde:	6b42                	ld	s6,16(sp)
    80000be0:	6ba2                	ld	s7,8(sp)
    80000be2:	6c02                	ld	s8,0(sp)
    80000be4:	6161                	addi	sp,sp,80
    80000be6:	8082                	ret

0000000080000be8 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000be8:	715d                	addi	sp,sp,-80
    80000bea:	e486                	sd	ra,72(sp)
    80000bec:	e0a2                	sd	s0,64(sp)
    80000bee:	fc26                	sd	s1,56(sp)
    80000bf0:	f84a                	sd	s2,48(sp)
    80000bf2:	f44e                	sd	s3,40(sp)
    80000bf4:	f052                	sd	s4,32(sp)
    80000bf6:	ec56                	sd	s5,24(sp)
    80000bf8:	e85a                	sd	s6,16(sp)
    80000bfa:	e45e                	sd	s7,8(sp)
    80000bfc:	0880                	addi	s0,sp,80
    80000bfe:	8aaa                	mv	s5,a0
    80000c00:	89ae                	mv	s3,a1
    80000c02:	8bb2                	mv	s7,a2
    80000c04:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80000c06:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c08:	6a05                	lui	s4,0x1
    80000c0a:	a02d                	j	80000c34 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c0c:	00078023          	sb	zero,0(a5)
    80000c10:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c12:	0017c793          	xori	a5,a5,1
    80000c16:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c1a:	60a6                	ld	ra,72(sp)
    80000c1c:	6406                	ld	s0,64(sp)
    80000c1e:	74e2                	ld	s1,56(sp)
    80000c20:	7942                	ld	s2,48(sp)
    80000c22:	79a2                	ld	s3,40(sp)
    80000c24:	7a02                	ld	s4,32(sp)
    80000c26:	6ae2                	ld	s5,24(sp)
    80000c28:	6b42                	ld	s6,16(sp)
    80000c2a:	6ba2                	ld	s7,8(sp)
    80000c2c:	6161                	addi	sp,sp,80
    80000c2e:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c30:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000c34:	c4b1                	beqz	s1,80000c80 <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80000c36:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000c3a:	85ca                	mv	a1,s2
    80000c3c:	8556                	mv	a0,s5
    80000c3e:	83fff0ef          	jal	8000047c <walkaddr>
    if(pa0 == 0)
    80000c42:	c129                	beqz	a0,80000c84 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    80000c44:	41790633          	sub	a2,s2,s7
    80000c48:	9652                	add	a2,a2,s4
    if(n > max)
    80000c4a:	00c4f363          	bgeu	s1,a2,80000c50 <copyinstr+0x68>
    80000c4e:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c50:	412b8bb3          	sub	s7,s7,s2
    80000c54:	9baa                	add	s7,s7,a0
    while(n > 0){
    80000c56:	de69                	beqz	a2,80000c30 <copyinstr+0x48>
    80000c58:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80000c5a:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80000c5e:	964e                	add	a2,a2,s3
    80000c60:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000c62:	00f68733          	add	a4,a3,a5
    80000c66:	00074703          	lbu	a4,0(a4)
    80000c6a:	d34d                	beqz	a4,80000c0c <copyinstr+0x24>
        *dst = *p;
    80000c6c:	00e78023          	sb	a4,0(a5)
      dst++;
    80000c70:	0785                	addi	a5,a5,1
    while(n > 0){
    80000c72:	fec797e3          	bne	a5,a2,80000c60 <copyinstr+0x78>
    80000c76:	14fd                	addi	s1,s1,-1
    80000c78:	94ce                	add	s1,s1,s3
      --max;
    80000c7a:	8c8d                	sub	s1,s1,a1
    80000c7c:	89be                	mv	s3,a5
    80000c7e:	bf4d                	j	80000c30 <copyinstr+0x48>
    80000c80:	4781                	li	a5,0
    80000c82:	bf41                	j	80000c12 <copyinstr+0x2a>
      return -1;
    80000c84:	557d                	li	a0,-1
    80000c86:	bf51                	j	80000c1a <copyinstr+0x32>

0000000080000c88 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c88:	715d                	addi	sp,sp,-80
    80000c8a:	e486                	sd	ra,72(sp)
    80000c8c:	e0a2                	sd	s0,64(sp)
    80000c8e:	fc26                	sd	s1,56(sp)
    80000c90:	f84a                	sd	s2,48(sp)
    80000c92:	f44e                	sd	s3,40(sp)
    80000c94:	f052                	sd	s4,32(sp)
    80000c96:	ec56                	sd	s5,24(sp)
    80000c98:	e85a                	sd	s6,16(sp)
    80000c9a:	e45e                	sd	s7,8(sp)
    80000c9c:	e062                	sd	s8,0(sp)
    80000c9e:	0880                	addi	s0,sp,80
    80000ca0:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ca2:	0000a497          	auipc	s1,0xa
    80000ca6:	d4e48493          	addi	s1,s1,-690 # 8000a9f0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000caa:	8c26                	mv	s8,s1
    80000cac:	26e987b7          	lui	a5,0x26e98
    80000cb0:	8d578793          	addi	a5,a5,-1835 # 26e978d5 <_entry-0x5916872b>
    80000cb4:	1cac1937          	lui	s2,0x1cac1
    80000cb8:	83190913          	addi	s2,s2,-1999 # 1cac0831 <_entry-0x6353f7cf>
    80000cbc:	1902                	slli	s2,s2,0x20
    80000cbe:	993e                	add	s2,s2,a5
    80000cc0:	040009b7          	lui	s3,0x4000
    80000cc4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000cc6:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000cc8:	4b99                	li	s7,6
    80000cca:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ccc:	00019a97          	auipc	s5,0x19
    80000cd0:	724a8a93          	addi	s5,s5,1828 # 8001a3f0 <tickslock>
    char *pa = kalloc();
    80000cd4:	c2aff0ef          	jal	800000fe <kalloc>
    80000cd8:	862a                	mv	a2,a0
    if(pa == 0)
    80000cda:	c121                	beqz	a0,80000d1a <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000cdc:	418485b3          	sub	a1,s1,s8
    80000ce0:	858d                	srai	a1,a1,0x3
    80000ce2:	032585b3          	mul	a1,a1,s2
    80000ce6:	2585                	addiw	a1,a1,1
    80000ce8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000cec:	875e                	mv	a4,s7
    80000cee:	86da                	mv	a3,s6
    80000cf0:	40b985b3          	sub	a1,s3,a1
    80000cf4:	8552                	mv	a0,s4
    80000cf6:	87bff0ef          	jal	80000570 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cfa:	3e848493          	addi	s1,s1,1000
    80000cfe:	fd549be3          	bne	s1,s5,80000cd4 <proc_mapstacks+0x4c>
  }
}
    80000d02:	60a6                	ld	ra,72(sp)
    80000d04:	6406                	ld	s0,64(sp)
    80000d06:	74e2                	ld	s1,56(sp)
    80000d08:	7942                	ld	s2,48(sp)
    80000d0a:	79a2                	ld	s3,40(sp)
    80000d0c:	7a02                	ld	s4,32(sp)
    80000d0e:	6ae2                	ld	s5,24(sp)
    80000d10:	6b42                	ld	s6,16(sp)
    80000d12:	6ba2                	ld	s7,8(sp)
    80000d14:	6c02                	ld	s8,0(sp)
    80000d16:	6161                	addi	sp,sp,80
    80000d18:	8082                	ret
      panic("kalloc");
    80000d1a:	00006517          	auipc	a0,0x6
    80000d1e:	47e50513          	addi	a0,a0,1150 # 80007198 <etext+0x198>
    80000d22:	535040ef          	jal	80005a56 <panic>

0000000080000d26 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d26:	7139                	addi	sp,sp,-64
    80000d28:	fc06                	sd	ra,56(sp)
    80000d2a:	f822                	sd	s0,48(sp)
    80000d2c:	f426                	sd	s1,40(sp)
    80000d2e:	f04a                	sd	s2,32(sp)
    80000d30:	ec4e                	sd	s3,24(sp)
    80000d32:	e852                	sd	s4,16(sp)
    80000d34:	e456                	sd	s5,8(sp)
    80000d36:	e05a                	sd	s6,0(sp)
    80000d38:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d3a:	00006597          	auipc	a1,0x6
    80000d3e:	46658593          	addi	a1,a1,1126 # 800071a0 <etext+0x1a0>
    80000d42:	0000a517          	auipc	a0,0xa
    80000d46:	87e50513          	addi	a0,a0,-1922 # 8000a5c0 <pid_lock>
    80000d4a:	7b7040ef          	jal	80005d00 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d4e:	00006597          	auipc	a1,0x6
    80000d52:	45a58593          	addi	a1,a1,1114 # 800071a8 <etext+0x1a8>
    80000d56:	0000a517          	auipc	a0,0xa
    80000d5a:	88250513          	addi	a0,a0,-1918 # 8000a5d8 <wait_lock>
    80000d5e:	7a3040ef          	jal	80005d00 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d62:	0000a497          	auipc	s1,0xa
    80000d66:	c8e48493          	addi	s1,s1,-882 # 8000a9f0 <proc>
      initlock(&p->lock, "proc");
    80000d6a:	00006b17          	auipc	s6,0x6
    80000d6e:	44eb0b13          	addi	s6,s6,1102 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d72:	8aa6                	mv	s5,s1
    80000d74:	26e987b7          	lui	a5,0x26e98
    80000d78:	8d578793          	addi	a5,a5,-1835 # 26e978d5 <_entry-0x5916872b>
    80000d7c:	1cac1937          	lui	s2,0x1cac1
    80000d80:	83190913          	addi	s2,s2,-1999 # 1cac0831 <_entry-0x6353f7cf>
    80000d84:	1902                	slli	s2,s2,0x20
    80000d86:	993e                	add	s2,s2,a5
    80000d88:	040009b7          	lui	s3,0x4000
    80000d8c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d8e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d90:	00019a17          	auipc	s4,0x19
    80000d94:	660a0a13          	addi	s4,s4,1632 # 8001a3f0 <tickslock>
      initlock(&p->lock, "proc");
    80000d98:	85da                	mv	a1,s6
    80000d9a:	8526                	mv	a0,s1
    80000d9c:	765040ef          	jal	80005d00 <initlock>
      p->state = UNUSED;
    80000da0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000da4:	415487b3          	sub	a5,s1,s5
    80000da8:	878d                	srai	a5,a5,0x3
    80000daa:	032787b3          	mul	a5,a5,s2
    80000dae:	2785                	addiw	a5,a5,1
    80000db0:	00d7979b          	slliw	a5,a5,0xd
    80000db4:	40f987b3          	sub	a5,s3,a5
    80000db8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dba:	3e848493          	addi	s1,s1,1000
    80000dbe:	fd449de3          	bne	s1,s4,80000d98 <procinit+0x72>
  }
}
    80000dc2:	70e2                	ld	ra,56(sp)
    80000dc4:	7442                	ld	s0,48(sp)
    80000dc6:	74a2                	ld	s1,40(sp)
    80000dc8:	7902                	ld	s2,32(sp)
    80000dca:	69e2                	ld	s3,24(sp)
    80000dcc:	6a42                	ld	s4,16(sp)
    80000dce:	6aa2                	ld	s5,8(sp)
    80000dd0:	6b02                	ld	s6,0(sp)
    80000dd2:	6121                	addi	sp,sp,64
    80000dd4:	8082                	ret

0000000080000dd6 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000dd6:	1141                	addi	sp,sp,-16
    80000dd8:	e406                	sd	ra,8(sp)
    80000dda:	e022                	sd	s0,0(sp)
    80000ddc:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000dde:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000de0:	2501                	sext.w	a0,a0
    80000de2:	60a2                	ld	ra,8(sp)
    80000de4:	6402                	ld	s0,0(sp)
    80000de6:	0141                	addi	sp,sp,16
    80000de8:	8082                	ret

0000000080000dea <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000dea:	1141                	addi	sp,sp,-16
    80000dec:	e406                	sd	ra,8(sp)
    80000dee:	e022                	sd	s0,0(sp)
    80000df0:	0800                	addi	s0,sp,16
    80000df2:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000df4:	2781                	sext.w	a5,a5
    80000df6:	079e                	slli	a5,a5,0x7
  return c;
}
    80000df8:	00009517          	auipc	a0,0x9
    80000dfc:	7f850513          	addi	a0,a0,2040 # 8000a5f0 <cpus>
    80000e00:	953e                	add	a0,a0,a5
    80000e02:	60a2                	ld	ra,8(sp)
    80000e04:	6402                	ld	s0,0(sp)
    80000e06:	0141                	addi	sp,sp,16
    80000e08:	8082                	ret

0000000080000e0a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e0a:	1101                	addi	sp,sp,-32
    80000e0c:	ec06                	sd	ra,24(sp)
    80000e0e:	e822                	sd	s0,16(sp)
    80000e10:	e426                	sd	s1,8(sp)
    80000e12:	1000                	addi	s0,sp,32
  push_off();
    80000e14:	731040ef          	jal	80005d44 <push_off>
    80000e18:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e1a:	2781                	sext.w	a5,a5
    80000e1c:	079e                	slli	a5,a5,0x7
    80000e1e:	00009717          	auipc	a4,0x9
    80000e22:	7a270713          	addi	a4,a4,1954 # 8000a5c0 <pid_lock>
    80000e26:	97ba                	add	a5,a5,a4
    80000e28:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e2a:	79f040ef          	jal	80005dc8 <pop_off>
  return p;
}
    80000e2e:	8526                	mv	a0,s1
    80000e30:	60e2                	ld	ra,24(sp)
    80000e32:	6442                	ld	s0,16(sp)
    80000e34:	64a2                	ld	s1,8(sp)
    80000e36:	6105                	addi	sp,sp,32
    80000e38:	8082                	ret

0000000080000e3a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e3a:	1141                	addi	sp,sp,-16
    80000e3c:	e406                	sd	ra,8(sp)
    80000e3e:	e022                	sd	s0,0(sp)
    80000e40:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e42:	fc9ff0ef          	jal	80000e0a <myproc>
    80000e46:	7d3040ef          	jal	80005e18 <release>

  if (first) {
    80000e4a:	00009797          	auipc	a5,0x9
    80000e4e:	6b67a783          	lw	a5,1718(a5) # 8000a500 <first.1>
    80000e52:	e799                	bnez	a5,80000e60 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000e54:	4c5000ef          	jal	80001b18 <usertrapret>
}
    80000e58:	60a2                	ld	ra,8(sp)
    80000e5a:	6402                	ld	s0,0(sp)
    80000e5c:	0141                	addi	sp,sp,16
    80000e5e:	8082                	ret
    fsinit(ROOTDEV);
    80000e60:	4505                	li	a0,1
    80000e62:	057010ef          	jal	800026b8 <fsinit>
    first = 0;
    80000e66:	00009797          	auipc	a5,0x9
    80000e6a:	6807ad23          	sw	zero,1690(a5) # 8000a500 <first.1>
    __sync_synchronize();
    80000e6e:	0330000f          	fence	rw,rw
    80000e72:	b7cd                	j	80000e54 <forkret+0x1a>

0000000080000e74 <allocpid>:
{
    80000e74:	1101                	addi	sp,sp,-32
    80000e76:	ec06                	sd	ra,24(sp)
    80000e78:	e822                	sd	s0,16(sp)
    80000e7a:	e426                	sd	s1,8(sp)
    80000e7c:	e04a                	sd	s2,0(sp)
    80000e7e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e80:	00009917          	auipc	s2,0x9
    80000e84:	74090913          	addi	s2,s2,1856 # 8000a5c0 <pid_lock>
    80000e88:	854a                	mv	a0,s2
    80000e8a:	6fb040ef          	jal	80005d84 <acquire>
  pid = nextpid;
    80000e8e:	00009797          	auipc	a5,0x9
    80000e92:	67678793          	addi	a5,a5,1654 # 8000a504 <nextpid>
    80000e96:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e98:	0014871b          	addiw	a4,s1,1
    80000e9c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e9e:	854a                	mv	a0,s2
    80000ea0:	779040ef          	jal	80005e18 <release>
}
    80000ea4:	8526                	mv	a0,s1
    80000ea6:	60e2                	ld	ra,24(sp)
    80000ea8:	6442                	ld	s0,16(sp)
    80000eaa:	64a2                	ld	s1,8(sp)
    80000eac:	6902                	ld	s2,0(sp)
    80000eae:	6105                	addi	sp,sp,32
    80000eb0:	8082                	ret

0000000080000eb2 <proc_pagetable>:
{
    80000eb2:	1101                	addi	sp,sp,-32
    80000eb4:	ec06                	sd	ra,24(sp)
    80000eb6:	e822                	sd	s0,16(sp)
    80000eb8:	e426                	sd	s1,8(sp)
    80000eba:	e04a                	sd	s2,0(sp)
    80000ebc:	1000                	addi	s0,sp,32
    80000ebe:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000ec0:	90bff0ef          	jal	800007ca <uvmcreate>
    80000ec4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000ec6:	cd05                	beqz	a0,80000efe <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000ec8:	4729                	li	a4,10
    80000eca:	00005697          	auipc	a3,0x5
    80000ece:	13668693          	addi	a3,a3,310 # 80006000 <_trampoline>
    80000ed2:	6605                	lui	a2,0x1
    80000ed4:	040005b7          	lui	a1,0x4000
    80000ed8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eda:	05b2                	slli	a1,a1,0xc
    80000edc:	ddeff0ef          	jal	800004ba <mappages>
    80000ee0:	02054663          	bltz	a0,80000f0c <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000ee4:	4719                	li	a4,6
    80000ee6:	05893683          	ld	a3,88(s2)
    80000eea:	6605                	lui	a2,0x1
    80000eec:	020005b7          	lui	a1,0x2000
    80000ef0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ef2:	05b6                	slli	a1,a1,0xd
    80000ef4:	8526                	mv	a0,s1
    80000ef6:	dc4ff0ef          	jal	800004ba <mappages>
    80000efa:	00054f63          	bltz	a0,80000f18 <proc_pagetable+0x66>
}
    80000efe:	8526                	mv	a0,s1
    80000f00:	60e2                	ld	ra,24(sp)
    80000f02:	6442                	ld	s0,16(sp)
    80000f04:	64a2                	ld	s1,8(sp)
    80000f06:	6902                	ld	s2,0(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f0c:	4581                	li	a1,0
    80000f0e:	8526                	mv	a0,s1
    80000f10:	a91ff0ef          	jal	800009a0 <uvmfree>
    return 0;
    80000f14:	4481                	li	s1,0
    80000f16:	b7e5                	j	80000efe <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f18:	4681                	li	a3,0
    80000f1a:	4605                	li	a2,1
    80000f1c:	040005b7          	lui	a1,0x4000
    80000f20:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f22:	05b2                	slli	a1,a1,0xc
    80000f24:	8526                	mv	a0,s1
    80000f26:	f3aff0ef          	jal	80000660 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f2a:	4581                	li	a1,0
    80000f2c:	8526                	mv	a0,s1
    80000f2e:	a73ff0ef          	jal	800009a0 <uvmfree>
    return 0;
    80000f32:	4481                	li	s1,0
    80000f34:	b7e9                	j	80000efe <proc_pagetable+0x4c>

0000000080000f36 <proc_freepagetable>:
{
    80000f36:	1101                	addi	sp,sp,-32
    80000f38:	ec06                	sd	ra,24(sp)
    80000f3a:	e822                	sd	s0,16(sp)
    80000f3c:	e426                	sd	s1,8(sp)
    80000f3e:	e04a                	sd	s2,0(sp)
    80000f40:	1000                	addi	s0,sp,32
    80000f42:	84aa                	mv	s1,a0
    80000f44:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f46:	4681                	li	a3,0
    80000f48:	4605                	li	a2,1
    80000f4a:	040005b7          	lui	a1,0x4000
    80000f4e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f50:	05b2                	slli	a1,a1,0xc
    80000f52:	f0eff0ef          	jal	80000660 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f56:	4681                	li	a3,0
    80000f58:	4605                	li	a2,1
    80000f5a:	020005b7          	lui	a1,0x2000
    80000f5e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f60:	05b6                	slli	a1,a1,0xd
    80000f62:	8526                	mv	a0,s1
    80000f64:	efcff0ef          	jal	80000660 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f68:	85ca                	mv	a1,s2
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	a35ff0ef          	jal	800009a0 <uvmfree>
}
    80000f70:	60e2                	ld	ra,24(sp)
    80000f72:	6442                	ld	s0,16(sp)
    80000f74:	64a2                	ld	s1,8(sp)
    80000f76:	6902                	ld	s2,0(sp)
    80000f78:	6105                	addi	sp,sp,32
    80000f7a:	8082                	ret

0000000080000f7c <freeproc>:
{
    80000f7c:	1101                	addi	sp,sp,-32
    80000f7e:	ec06                	sd	ra,24(sp)
    80000f80:	e822                	sd	s0,16(sp)
    80000f82:	e426                	sd	s1,8(sp)
    80000f84:	1000                	addi	s0,sp,32
    80000f86:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f88:	6d28                	ld	a0,88(a0)
    80000f8a:	c119                	beqz	a0,80000f90 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f8c:	890ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f90:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f94:	68a8                	ld	a0,80(s1)
    80000f96:	c501                	beqz	a0,80000f9e <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f98:	64ac                	ld	a1,72(s1)
    80000f9a:	f9dff0ef          	jal	80000f36 <proc_freepagetable>
  p->pagetable = 0;
    80000f9e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000fa2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000fa6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000faa:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000fae:	3c048c23          	sb	zero,984(s1)
  p->chan = 0;
    80000fb2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000fb6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000fba:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000fbe:	0004ac23          	sw	zero,24(s1)
}
    80000fc2:	60e2                	ld	ra,24(sp)
    80000fc4:	6442                	ld	s0,16(sp)
    80000fc6:	64a2                	ld	s1,8(sp)
    80000fc8:	6105                	addi	sp,sp,32
    80000fca:	8082                	ret

0000000080000fcc <allocproc>:
{
    80000fcc:	1101                	addi	sp,sp,-32
    80000fce:	ec06                	sd	ra,24(sp)
    80000fd0:	e822                	sd	s0,16(sp)
    80000fd2:	e426                	sd	s1,8(sp)
    80000fd4:	e04a                	sd	s2,0(sp)
    80000fd6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fd8:	0000a497          	auipc	s1,0xa
    80000fdc:	a1848493          	addi	s1,s1,-1512 # 8000a9f0 <proc>
    80000fe0:	00019917          	auipc	s2,0x19
    80000fe4:	41090913          	addi	s2,s2,1040 # 8001a3f0 <tickslock>
    acquire(&p->lock);
    80000fe8:	8526                	mv	a0,s1
    80000fea:	59b040ef          	jal	80005d84 <acquire>
    if(p->state == UNUSED) {
    80000fee:	4c9c                	lw	a5,24(s1)
    80000ff0:	cb91                	beqz	a5,80001004 <allocproc+0x38>
      release(&p->lock);
    80000ff2:	8526                	mv	a0,s1
    80000ff4:	625040ef          	jal	80005e18 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ff8:	3e848493          	addi	s1,s1,1000
    80000ffc:	ff2496e3          	bne	s1,s2,80000fe8 <allocproc+0x1c>
  return 0;
    80001000:	4481                	li	s1,0
    80001002:	a089                	j	80001044 <allocproc+0x78>
  p->pid = allocpid();
    80001004:	e71ff0ef          	jal	80000e74 <allocpid>
    80001008:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000100a:	4785                	li	a5,1
    8000100c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000100e:	8f0ff0ef          	jal	800000fe <kalloc>
    80001012:	892a                	mv	s2,a0
    80001014:	eca8                	sd	a0,88(s1)
    80001016:	cd15                	beqz	a0,80001052 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001018:	8526                	mv	a0,s1
    8000101a:	e99ff0ef          	jal	80000eb2 <proc_pagetable>
    8000101e:	892a                	mv	s2,a0
    80001020:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001022:	c121                	beqz	a0,80001062 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001024:	07000613          	li	a2,112
    80001028:	4581                	li	a1,0
    8000102a:	06048513          	addi	a0,s1,96
    8000102e:	920ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80001032:	00000797          	auipc	a5,0x0
    80001036:	e0878793          	addi	a5,a5,-504 # 80000e3a <forkret>
    8000103a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000103c:	60bc                	ld	a5,64(s1)
    8000103e:	6705                	lui	a4,0x1
    80001040:	97ba                	add	a5,a5,a4
    80001042:	f4bc                	sd	a5,104(s1)
}
    80001044:	8526                	mv	a0,s1
    80001046:	60e2                	ld	ra,24(sp)
    80001048:	6442                	ld	s0,16(sp)
    8000104a:	64a2                	ld	s1,8(sp)
    8000104c:	6902                	ld	s2,0(sp)
    8000104e:	6105                	addi	sp,sp,32
    80001050:	8082                	ret
    freeproc(p);
    80001052:	8526                	mv	a0,s1
    80001054:	f29ff0ef          	jal	80000f7c <freeproc>
    release(&p->lock);
    80001058:	8526                	mv	a0,s1
    8000105a:	5bf040ef          	jal	80005e18 <release>
    return 0;
    8000105e:	84ca                	mv	s1,s2
    80001060:	b7d5                	j	80001044 <allocproc+0x78>
    freeproc(p);
    80001062:	8526                	mv	a0,s1
    80001064:	f19ff0ef          	jal	80000f7c <freeproc>
    release(&p->lock);
    80001068:	8526                	mv	a0,s1
    8000106a:	5af040ef          	jal	80005e18 <release>
    return 0;
    8000106e:	84ca                	mv	s1,s2
    80001070:	bfd1                	j	80001044 <allocproc+0x78>

0000000080001072 <userinit>:
{
    80001072:	1101                	addi	sp,sp,-32
    80001074:	ec06                	sd	ra,24(sp)
    80001076:	e822                	sd	s0,16(sp)
    80001078:	e426                	sd	s1,8(sp)
    8000107a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000107c:	f51ff0ef          	jal	80000fcc <allocproc>
    80001080:	84aa                	mv	s1,a0
  initproc = p;
    80001082:	00009797          	auipc	a5,0x9
    80001086:	4ea7bf23          	sd	a0,1278(a5) # 8000a580 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000108a:	03400613          	li	a2,52
    8000108e:	00009597          	auipc	a1,0x9
    80001092:	48258593          	addi	a1,a1,1154 # 8000a510 <initcode>
    80001096:	6928                	ld	a0,80(a0)
    80001098:	f58ff0ef          	jal	800007f0 <uvmfirst>
  p->sz = PGSIZE;
    8000109c:	6785                	lui	a5,0x1
    8000109e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800010a0:	6cb8                	ld	a4,88(s1)
    800010a2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800010a6:	6cb8                	ld	a4,88(s1)
    800010a8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800010aa:	4641                	li	a2,16
    800010ac:	00006597          	auipc	a1,0x6
    800010b0:	11458593          	addi	a1,a1,276 # 800071c0 <etext+0x1c0>
    800010b4:	3d848513          	addi	a0,s1,984
    800010b8:	9e8ff0ef          	jal	800002a0 <safestrcpy>
  p->cwd = namei("/");
    800010bc:	00006517          	auipc	a0,0x6
    800010c0:	11450513          	addi	a0,a0,276 # 800071d0 <etext+0x1d0>
    800010c4:	719010ef          	jal	80002fdc <namei>
    800010c8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800010cc:	478d                	li	a5,3
    800010ce:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800010d0:	8526                	mv	a0,s1
    800010d2:	547040ef          	jal	80005e18 <release>
}
    800010d6:	60e2                	ld	ra,24(sp)
    800010d8:	6442                	ld	s0,16(sp)
    800010da:	64a2                	ld	s1,8(sp)
    800010dc:	6105                	addi	sp,sp,32
    800010de:	8082                	ret

00000000800010e0 <growproc>:
{
    800010e0:	1101                	addi	sp,sp,-32
    800010e2:	ec06                	sd	ra,24(sp)
    800010e4:	e822                	sd	s0,16(sp)
    800010e6:	e426                	sd	s1,8(sp)
    800010e8:	e04a                	sd	s2,0(sp)
    800010ea:	1000                	addi	s0,sp,32
    800010ec:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800010ee:	d1dff0ef          	jal	80000e0a <myproc>
    800010f2:	84aa                	mv	s1,a0
  sz = p->sz;
    800010f4:	652c                	ld	a1,72(a0)
  if(n > 0){
    800010f6:	01204c63          	bgtz	s2,8000110e <growproc+0x2e>
  } else if(n < 0){
    800010fa:	02094463          	bltz	s2,80001122 <growproc+0x42>
  p->sz = sz;
    800010fe:	e4ac                	sd	a1,72(s1)
  return 0;
    80001100:	4501                	li	a0,0
}
    80001102:	60e2                	ld	ra,24(sp)
    80001104:	6442                	ld	s0,16(sp)
    80001106:	64a2                	ld	s1,8(sp)
    80001108:	6902                	ld	s2,0(sp)
    8000110a:	6105                	addi	sp,sp,32
    8000110c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000110e:	4691                	li	a3,4
    80001110:	00b90633          	add	a2,s2,a1
    80001114:	6928                	ld	a0,80(a0)
    80001116:	f7cff0ef          	jal	80000892 <uvmalloc>
    8000111a:	85aa                	mv	a1,a0
    8000111c:	f16d                	bnez	a0,800010fe <growproc+0x1e>
      return -1;
    8000111e:	557d                	li	a0,-1
    80001120:	b7cd                	j	80001102 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001122:	00b90633          	add	a2,s2,a1
    80001126:	6928                	ld	a0,80(a0)
    80001128:	f26ff0ef          	jal	8000084e <uvmdealloc>
    8000112c:	85aa                	mv	a1,a0
    8000112e:	bfc1                	j	800010fe <growproc+0x1e>

0000000080001130 <fork>:
{
    80001130:	7139                	addi	sp,sp,-64
    80001132:	fc06                	sd	ra,56(sp)
    80001134:	f822                	sd	s0,48(sp)
    80001136:	f04a                	sd	s2,32(sp)
    80001138:	e456                	sd	s5,8(sp)
    8000113a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000113c:	ccfff0ef          	jal	80000e0a <myproc>
    80001140:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001142:	e8bff0ef          	jal	80000fcc <allocproc>
    80001146:	12050c63          	beqz	a0,8000127e <fork+0x14e>
    8000114a:	e852                	sd	s4,16(sp)
    8000114c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000114e:	048ab603          	ld	a2,72(s5)
    80001152:	692c                	ld	a1,80(a0)
    80001154:	050ab503          	ld	a0,80(s5)
    80001158:	87bff0ef          	jal	800009d2 <uvmcopy>
    8000115c:	04054a63          	bltz	a0,800011b0 <fork+0x80>
    80001160:	f426                	sd	s1,40(sp)
    80001162:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001164:	048ab783          	ld	a5,72(s5)
    80001168:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000116c:	058ab683          	ld	a3,88(s5)
    80001170:	87b6                	mv	a5,a3
    80001172:	058a3703          	ld	a4,88(s4)
    80001176:	12068693          	addi	a3,a3,288
    8000117a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000117e:	6788                	ld	a0,8(a5)
    80001180:	6b8c                	ld	a1,16(a5)
    80001182:	6f90                	ld	a2,24(a5)
    80001184:	01073023          	sd	a6,0(a4)
    80001188:	e708                	sd	a0,8(a4)
    8000118a:	eb0c                	sd	a1,16(a4)
    8000118c:	ef10                	sd	a2,24(a4)
    8000118e:	02078793          	addi	a5,a5,32
    80001192:	02070713          	addi	a4,a4,32
    80001196:	fed792e3          	bne	a5,a3,8000117a <fork+0x4a>
  np->trapframe->a0 = 0;
    8000119a:	058a3783          	ld	a5,88(s4)
    8000119e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800011a2:	0d0a8493          	addi	s1,s5,208
    800011a6:	0d0a0913          	addi	s2,s4,208
    800011aa:	150a8993          	addi	s3,s5,336
    800011ae:	a831                	j	800011ca <fork+0x9a>
    freeproc(np);
    800011b0:	8552                	mv	a0,s4
    800011b2:	dcbff0ef          	jal	80000f7c <freeproc>
    release(&np->lock);
    800011b6:	8552                	mv	a0,s4
    800011b8:	461040ef          	jal	80005e18 <release>
    return -1;
    800011bc:	597d                	li	s2,-1
    800011be:	6a42                	ld	s4,16(sp)
    800011c0:	a845                	j	80001270 <fork+0x140>
  for(i = 0; i < NOFILE; i++)
    800011c2:	04a1                	addi	s1,s1,8
    800011c4:	0921                	addi	s2,s2,8
    800011c6:	01348963          	beq	s1,s3,800011d8 <fork+0xa8>
    if(p->ofile[i])
    800011ca:	6088                	ld	a0,0(s1)
    800011cc:	d97d                	beqz	a0,800011c2 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    800011ce:	3aa020ef          	jal	80003578 <filedup>
    800011d2:	00a93023          	sd	a0,0(s2)
    800011d6:	b7f5                	j	800011c2 <fork+0x92>
    800011d8:	158a8493          	addi	s1,s5,344
    800011dc:	158a0913          	addi	s2,s4,344
    800011e0:	3d8a8993          	addi	s3,s5,984
    800011e4:	a039                	j	800011f2 <fork+0xc2>
  for (i = 0; i < NVMA; i++) {
    800011e6:	02848493          	addi	s1,s1,40
    800011ea:	02890913          	addi	s2,s2,40
    800011ee:	03348763          	beq	s1,s3,8000121c <fork+0xec>
    if (vma->len) {
    800011f2:	409c                	lw	a5,0(s1)
    800011f4:	dbed                	beqz	a5,800011e6 <fork+0xb6>
      np->vmas[i] = *vma;
    800011f6:	608c                	ld	a1,0(s1)
    800011f8:	6490                	ld	a2,8(s1)
    800011fa:	6894                	ld	a3,16(s1)
    800011fc:	6c98                	ld	a4,24(s1)
    800011fe:	709c                	ld	a5,32(s1)
    80001200:	00b93023          	sd	a1,0(s2)
    80001204:	00c93423          	sd	a2,8(s2)
    80001208:	00d93823          	sd	a3,16(s2)
    8000120c:	00e93c23          	sd	a4,24(s2)
    80001210:	02f93023          	sd	a5,32(s2)
      filedup(vma->f);
    80001214:	7088                	ld	a0,32(s1)
    80001216:	362020ef          	jal	80003578 <filedup>
    8000121a:	b7f1                	j	800011e6 <fork+0xb6>
  np->cwd = idup(p->cwd);
    8000121c:	150ab503          	ld	a0,336(s5)
    80001220:	696010ef          	jal	800028b6 <idup>
    80001224:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001228:	4641                	li	a2,16
    8000122a:	3d8a8593          	addi	a1,s5,984
    8000122e:	3d8a0513          	addi	a0,s4,984
    80001232:	86eff0ef          	jal	800002a0 <safestrcpy>
  pid = np->pid;
    80001236:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000123a:	8552                	mv	a0,s4
    8000123c:	3dd040ef          	jal	80005e18 <release>
  acquire(&wait_lock);
    80001240:	00009497          	auipc	s1,0x9
    80001244:	39848493          	addi	s1,s1,920 # 8000a5d8 <wait_lock>
    80001248:	8526                	mv	a0,s1
    8000124a:	33b040ef          	jal	80005d84 <acquire>
  np->parent = p;
    8000124e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001252:	8526                	mv	a0,s1
    80001254:	3c5040ef          	jal	80005e18 <release>
  acquire(&np->lock);
    80001258:	8552                	mv	a0,s4
    8000125a:	32b040ef          	jal	80005d84 <acquire>
  np->state = RUNNABLE;
    8000125e:	478d                	li	a5,3
    80001260:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001264:	8552                	mv	a0,s4
    80001266:	3b3040ef          	jal	80005e18 <release>
  return pid;
    8000126a:	74a2                	ld	s1,40(sp)
    8000126c:	69e2                	ld	s3,24(sp)
    8000126e:	6a42                	ld	s4,16(sp)
}
    80001270:	854a                	mv	a0,s2
    80001272:	70e2                	ld	ra,56(sp)
    80001274:	7442                	ld	s0,48(sp)
    80001276:	7902                	ld	s2,32(sp)
    80001278:	6aa2                	ld	s5,8(sp)
    8000127a:	6121                	addi	sp,sp,64
    8000127c:	8082                	ret
    return -1;
    8000127e:	597d                	li	s2,-1
    80001280:	bfc5                	j	80001270 <fork+0x140>

0000000080001282 <scheduler>:
{
    80001282:	715d                	addi	sp,sp,-80
    80001284:	e486                	sd	ra,72(sp)
    80001286:	e0a2                	sd	s0,64(sp)
    80001288:	fc26                	sd	s1,56(sp)
    8000128a:	f84a                	sd	s2,48(sp)
    8000128c:	f44e                	sd	s3,40(sp)
    8000128e:	f052                	sd	s4,32(sp)
    80001290:	ec56                	sd	s5,24(sp)
    80001292:	e85a                	sd	s6,16(sp)
    80001294:	e45e                	sd	s7,8(sp)
    80001296:	e062                	sd	s8,0(sp)
    80001298:	0880                	addi	s0,sp,80
    8000129a:	8792                	mv	a5,tp
  int id = r_tp();
    8000129c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000129e:	00779b13          	slli	s6,a5,0x7
    800012a2:	00009717          	auipc	a4,0x9
    800012a6:	31e70713          	addi	a4,a4,798 # 8000a5c0 <pid_lock>
    800012aa:	975a                	add	a4,a4,s6
    800012ac:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800012b0:	00009717          	auipc	a4,0x9
    800012b4:	34870713          	addi	a4,a4,840 # 8000a5f8 <cpus+0x8>
    800012b8:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800012ba:	4c11                	li	s8,4
        c->proc = p;
    800012bc:	079e                	slli	a5,a5,0x7
    800012be:	00009a17          	auipc	s4,0x9
    800012c2:	302a0a13          	addi	s4,s4,770 # 8000a5c0 <pid_lock>
    800012c6:	9a3e                	add	s4,s4,a5
        found = 1;
    800012c8:	4b85                	li	s7,1
    800012ca:	a0a9                	j	80001314 <scheduler+0x92>
      release(&p->lock);
    800012cc:	8526                	mv	a0,s1
    800012ce:	34b040ef          	jal	80005e18 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800012d2:	3e848493          	addi	s1,s1,1000
    800012d6:	03248563          	beq	s1,s2,80001300 <scheduler+0x7e>
      acquire(&p->lock);
    800012da:	8526                	mv	a0,s1
    800012dc:	2a9040ef          	jal	80005d84 <acquire>
      if(p->state == RUNNABLE) {
    800012e0:	4c9c                	lw	a5,24(s1)
    800012e2:	ff3795e3          	bne	a5,s3,800012cc <scheduler+0x4a>
        p->state = RUNNING;
    800012e6:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800012ea:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800012ee:	06048593          	addi	a1,s1,96
    800012f2:	855a                	mv	a0,s6
    800012f4:	5fc000ef          	jal	800018f0 <swtch>
        c->proc = 0;
    800012f8:	020a3823          	sd	zero,48(s4)
        found = 1;
    800012fc:	8ade                	mv	s5,s7
    800012fe:	b7f9                	j	800012cc <scheduler+0x4a>
    if(found == 0) {
    80001300:	000a9a63          	bnez	s5,80001314 <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001304:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001308:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000130c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001310:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001314:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001318:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000131c:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001320:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001322:	00009497          	auipc	s1,0x9
    80001326:	6ce48493          	addi	s1,s1,1742 # 8000a9f0 <proc>
      if(p->state == RUNNABLE) {
    8000132a:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    8000132c:	00019917          	auipc	s2,0x19
    80001330:	0c490913          	addi	s2,s2,196 # 8001a3f0 <tickslock>
    80001334:	b75d                	j	800012da <scheduler+0x58>

0000000080001336 <sched>:
{
    80001336:	7179                	addi	sp,sp,-48
    80001338:	f406                	sd	ra,40(sp)
    8000133a:	f022                	sd	s0,32(sp)
    8000133c:	ec26                	sd	s1,24(sp)
    8000133e:	e84a                	sd	s2,16(sp)
    80001340:	e44e                	sd	s3,8(sp)
    80001342:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001344:	ac7ff0ef          	jal	80000e0a <myproc>
    80001348:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000134a:	1d1040ef          	jal	80005d1a <holding>
    8000134e:	c92d                	beqz	a0,800013c0 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001350:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001352:	2781                	sext.w	a5,a5
    80001354:	079e                	slli	a5,a5,0x7
    80001356:	00009717          	auipc	a4,0x9
    8000135a:	26a70713          	addi	a4,a4,618 # 8000a5c0 <pid_lock>
    8000135e:	97ba                	add	a5,a5,a4
    80001360:	0a87a703          	lw	a4,168(a5)
    80001364:	4785                	li	a5,1
    80001366:	06f71363          	bne	a4,a5,800013cc <sched+0x96>
  if(p->state == RUNNING)
    8000136a:	4c98                	lw	a4,24(s1)
    8000136c:	4791                	li	a5,4
    8000136e:	06f70563          	beq	a4,a5,800013d8 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001372:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001376:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001378:	e7b5                	bnez	a5,800013e4 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000137a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000137c:	00009917          	auipc	s2,0x9
    80001380:	24490913          	addi	s2,s2,580 # 8000a5c0 <pid_lock>
    80001384:	2781                	sext.w	a5,a5
    80001386:	079e                	slli	a5,a5,0x7
    80001388:	97ca                	add	a5,a5,s2
    8000138a:	0ac7a983          	lw	s3,172(a5)
    8000138e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001390:	2781                	sext.w	a5,a5
    80001392:	079e                	slli	a5,a5,0x7
    80001394:	00009597          	auipc	a1,0x9
    80001398:	26458593          	addi	a1,a1,612 # 8000a5f8 <cpus+0x8>
    8000139c:	95be                	add	a1,a1,a5
    8000139e:	06048513          	addi	a0,s1,96
    800013a2:	54e000ef          	jal	800018f0 <swtch>
    800013a6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800013a8:	2781                	sext.w	a5,a5
    800013aa:	079e                	slli	a5,a5,0x7
    800013ac:	993e                	add	s2,s2,a5
    800013ae:	0b392623          	sw	s3,172(s2)
}
    800013b2:	70a2                	ld	ra,40(sp)
    800013b4:	7402                	ld	s0,32(sp)
    800013b6:	64e2                	ld	s1,24(sp)
    800013b8:	6942                	ld	s2,16(sp)
    800013ba:	69a2                	ld	s3,8(sp)
    800013bc:	6145                	addi	sp,sp,48
    800013be:	8082                	ret
    panic("sched p->lock");
    800013c0:	00006517          	auipc	a0,0x6
    800013c4:	e1850513          	addi	a0,a0,-488 # 800071d8 <etext+0x1d8>
    800013c8:	68e040ef          	jal	80005a56 <panic>
    panic("sched locks");
    800013cc:	00006517          	auipc	a0,0x6
    800013d0:	e1c50513          	addi	a0,a0,-484 # 800071e8 <etext+0x1e8>
    800013d4:	682040ef          	jal	80005a56 <panic>
    panic("sched running");
    800013d8:	00006517          	auipc	a0,0x6
    800013dc:	e2050513          	addi	a0,a0,-480 # 800071f8 <etext+0x1f8>
    800013e0:	676040ef          	jal	80005a56 <panic>
    panic("sched interruptible");
    800013e4:	00006517          	auipc	a0,0x6
    800013e8:	e2450513          	addi	a0,a0,-476 # 80007208 <etext+0x208>
    800013ec:	66a040ef          	jal	80005a56 <panic>

00000000800013f0 <yield>:
{
    800013f0:	1101                	addi	sp,sp,-32
    800013f2:	ec06                	sd	ra,24(sp)
    800013f4:	e822                	sd	s0,16(sp)
    800013f6:	e426                	sd	s1,8(sp)
    800013f8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800013fa:	a11ff0ef          	jal	80000e0a <myproc>
    800013fe:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001400:	185040ef          	jal	80005d84 <acquire>
  p->state = RUNNABLE;
    80001404:	478d                	li	a5,3
    80001406:	cc9c                	sw	a5,24(s1)
  sched();
    80001408:	f2fff0ef          	jal	80001336 <sched>
  release(&p->lock);
    8000140c:	8526                	mv	a0,s1
    8000140e:	20b040ef          	jal	80005e18 <release>
}
    80001412:	60e2                	ld	ra,24(sp)
    80001414:	6442                	ld	s0,16(sp)
    80001416:	64a2                	ld	s1,8(sp)
    80001418:	6105                	addi	sp,sp,32
    8000141a:	8082                	ret

000000008000141c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000141c:	7179                	addi	sp,sp,-48
    8000141e:	f406                	sd	ra,40(sp)
    80001420:	f022                	sd	s0,32(sp)
    80001422:	ec26                	sd	s1,24(sp)
    80001424:	e84a                	sd	s2,16(sp)
    80001426:	e44e                	sd	s3,8(sp)
    80001428:	1800                	addi	s0,sp,48
    8000142a:	89aa                	mv	s3,a0
    8000142c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000142e:	9ddff0ef          	jal	80000e0a <myproc>
    80001432:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001434:	151040ef          	jal	80005d84 <acquire>
  release(lk);
    80001438:	854a                	mv	a0,s2
    8000143a:	1df040ef          	jal	80005e18 <release>

  // Go to sleep.
  p->chan = chan;
    8000143e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001442:	4789                	li	a5,2
    80001444:	cc9c                	sw	a5,24(s1)

  sched();
    80001446:	ef1ff0ef          	jal	80001336 <sched>

  // Tidy up.
  p->chan = 0;
    8000144a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000144e:	8526                	mv	a0,s1
    80001450:	1c9040ef          	jal	80005e18 <release>
  acquire(lk);
    80001454:	854a                	mv	a0,s2
    80001456:	12f040ef          	jal	80005d84 <acquire>
}
    8000145a:	70a2                	ld	ra,40(sp)
    8000145c:	7402                	ld	s0,32(sp)
    8000145e:	64e2                	ld	s1,24(sp)
    80001460:	6942                	ld	s2,16(sp)
    80001462:	69a2                	ld	s3,8(sp)
    80001464:	6145                	addi	sp,sp,48
    80001466:	8082                	ret

0000000080001468 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001468:	7139                	addi	sp,sp,-64
    8000146a:	fc06                	sd	ra,56(sp)
    8000146c:	f822                	sd	s0,48(sp)
    8000146e:	f426                	sd	s1,40(sp)
    80001470:	f04a                	sd	s2,32(sp)
    80001472:	ec4e                	sd	s3,24(sp)
    80001474:	e852                	sd	s4,16(sp)
    80001476:	e456                	sd	s5,8(sp)
    80001478:	0080                	addi	s0,sp,64
    8000147a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000147c:	00009497          	auipc	s1,0x9
    80001480:	57448493          	addi	s1,s1,1396 # 8000a9f0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001484:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001486:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001488:	00019917          	auipc	s2,0x19
    8000148c:	f6890913          	addi	s2,s2,-152 # 8001a3f0 <tickslock>
    80001490:	a801                	j	800014a0 <wakeup+0x38>
      }
      release(&p->lock);
    80001492:	8526                	mv	a0,s1
    80001494:	185040ef          	jal	80005e18 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001498:	3e848493          	addi	s1,s1,1000
    8000149c:	03248263          	beq	s1,s2,800014c0 <wakeup+0x58>
    if(p != myproc()){
    800014a0:	96bff0ef          	jal	80000e0a <myproc>
    800014a4:	fea48ae3          	beq	s1,a0,80001498 <wakeup+0x30>
      acquire(&p->lock);
    800014a8:	8526                	mv	a0,s1
    800014aa:	0db040ef          	jal	80005d84 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800014ae:	4c9c                	lw	a5,24(s1)
    800014b0:	ff3791e3          	bne	a5,s3,80001492 <wakeup+0x2a>
    800014b4:	709c                	ld	a5,32(s1)
    800014b6:	fd479ee3          	bne	a5,s4,80001492 <wakeup+0x2a>
        p->state = RUNNABLE;
    800014ba:	0154ac23          	sw	s5,24(s1)
    800014be:	bfd1                	j	80001492 <wakeup+0x2a>
    }
  }
}
    800014c0:	70e2                	ld	ra,56(sp)
    800014c2:	7442                	ld	s0,48(sp)
    800014c4:	74a2                	ld	s1,40(sp)
    800014c6:	7902                	ld	s2,32(sp)
    800014c8:	69e2                	ld	s3,24(sp)
    800014ca:	6a42                	ld	s4,16(sp)
    800014cc:	6aa2                	ld	s5,8(sp)
    800014ce:	6121                	addi	sp,sp,64
    800014d0:	8082                	ret

00000000800014d2 <reparent>:
{
    800014d2:	7179                	addi	sp,sp,-48
    800014d4:	f406                	sd	ra,40(sp)
    800014d6:	f022                	sd	s0,32(sp)
    800014d8:	ec26                	sd	s1,24(sp)
    800014da:	e84a                	sd	s2,16(sp)
    800014dc:	e44e                	sd	s3,8(sp)
    800014de:	e052                	sd	s4,0(sp)
    800014e0:	1800                	addi	s0,sp,48
    800014e2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800014e4:	00009497          	auipc	s1,0x9
    800014e8:	50c48493          	addi	s1,s1,1292 # 8000a9f0 <proc>
      pp->parent = initproc;
    800014ec:	00009a17          	auipc	s4,0x9
    800014f0:	094a0a13          	addi	s4,s4,148 # 8000a580 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800014f4:	00019997          	auipc	s3,0x19
    800014f8:	efc98993          	addi	s3,s3,-260 # 8001a3f0 <tickslock>
    800014fc:	a029                	j	80001506 <reparent+0x34>
    800014fe:	3e848493          	addi	s1,s1,1000
    80001502:	01348b63          	beq	s1,s3,80001518 <reparent+0x46>
    if(pp->parent == p){
    80001506:	7c9c                	ld	a5,56(s1)
    80001508:	ff279be3          	bne	a5,s2,800014fe <reparent+0x2c>
      pp->parent = initproc;
    8000150c:	000a3503          	ld	a0,0(s4)
    80001510:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001512:	f57ff0ef          	jal	80001468 <wakeup>
    80001516:	b7e5                	j	800014fe <reparent+0x2c>
}
    80001518:	70a2                	ld	ra,40(sp)
    8000151a:	7402                	ld	s0,32(sp)
    8000151c:	64e2                	ld	s1,24(sp)
    8000151e:	6942                	ld	s2,16(sp)
    80001520:	69a2                	ld	s3,8(sp)
    80001522:	6a02                	ld	s4,0(sp)
    80001524:	6145                	addi	sp,sp,48
    80001526:	8082                	ret

0000000080001528 <exit>:
{
    80001528:	7139                	addi	sp,sp,-64
    8000152a:	fc06                	sd	ra,56(sp)
    8000152c:	f822                	sd	s0,48(sp)
    8000152e:	f426                	sd	s1,40(sp)
    80001530:	f04a                	sd	s2,32(sp)
    80001532:	ec4e                	sd	s3,24(sp)
    80001534:	e852                	sd	s4,16(sp)
    80001536:	e456                	sd	s5,8(sp)
    80001538:	0080                	addi	s0,sp,64
    8000153a:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    8000153c:	8cfff0ef          	jal	80000e0a <myproc>
    80001540:	89aa                	mv	s3,a0
  struct VMA *vma = p->vmas;
    80001542:	15850493          	addi	s1,a0,344
  if(p == initproc)
    80001546:	00009797          	auipc	a5,0x9
    8000154a:	03a7b783          	ld	a5,58(a5) # 8000a580 <initproc>
    8000154e:	0d050913          	addi	s2,a0,208
    80001552:	15050a13          	addi	s4,a0,336
    80001556:	00a78463          	beq	a5,a0,8000155e <exit+0x36>
    8000155a:	e05a                	sd	s6,0(sp)
    8000155c:	a819                	j	80001572 <exit+0x4a>
    8000155e:	e05a                	sd	s6,0(sp)
    panic("init exiting");
    80001560:	00006517          	auipc	a0,0x6
    80001564:	cc050513          	addi	a0,a0,-832 # 80007220 <etext+0x220>
    80001568:	4ee040ef          	jal	80005a56 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000156c:	0921                	addi	s2,s2,8
    8000156e:	01490a63          	beq	s2,s4,80001582 <exit+0x5a>
    if(p->ofile[fd]){
    80001572:	00093503          	ld	a0,0(s2)
    80001576:	d97d                	beqz	a0,8000156c <exit+0x44>
      fileclose(f);
    80001578:	046020ef          	jal	800035be <fileclose>
      p->ofile[fd] = 0;
    8000157c:	00093023          	sd	zero,0(s2)
    80001580:	b7f5                	j	8000156c <exit+0x44>
  for (; vma <= &p->vmas[NVMA-1]; vma++) {
    80001582:	3d898913          	addi	s2,s3,984
      vmaunmap(p->pagetable, vma->addr, PGROUNDUP(vma->len) / PGSIZE, 1);
    80001586:	6a05                	lui	s4,0x1
    80001588:	3a7d                	addiw	s4,s4,-1 # fff <_entry-0x7ffff001>
    8000158a:	4b05                	li	s6,1
    8000158c:	a029                	j	80001596 <exit+0x6e>
  for (; vma <= &p->vmas[NVMA-1]; vma++) {
    8000158e:	02848493          	addi	s1,s1,40
    80001592:	02990463          	beq	s2,s1,800015ba <exit+0x92>
    if (vma->len) {
    80001596:	4090                	lw	a2,0(s1)
    80001598:	da7d                	beqz	a2,8000158e <exit+0x66>
      vmaunmap(p->pagetable, vma->addr, PGROUNDUP(vma->len) / PGSIZE, 1);
    8000159a:	0146063b          	addw	a2,a2,s4
    8000159e:	86da                	mv	a3,s6
    800015a0:	40c6561b          	sraiw	a2,a2,0xc
    800015a4:	688c                	ld	a1,16(s1)
    800015a6:	0509b503          	ld	a0,80(s3)
    800015aa:	972ff0ef          	jal	8000071c <vmaunmap>
      fileclose(vma->f);
    800015ae:	7088                	ld	a0,32(s1)
    800015b0:	00e020ef          	jal	800035be <fileclose>
      vma->len = 0;
    800015b4:	0004a023          	sw	zero,0(s1)
    800015b8:	bfd9                	j	8000158e <exit+0x66>
  begin_op();
    800015ba:	3e5010ef          	jal	8000319e <begin_op>
  iput(p->cwd);
    800015be:	1509b503          	ld	a0,336(s3)
    800015c2:	4ac010ef          	jal	80002a6e <iput>
  end_op();
    800015c6:	443010ef          	jal	80003208 <end_op>
  p->cwd = 0;
    800015ca:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800015ce:	00009497          	auipc	s1,0x9
    800015d2:	00a48493          	addi	s1,s1,10 # 8000a5d8 <wait_lock>
    800015d6:	8526                	mv	a0,s1
    800015d8:	7ac040ef          	jal	80005d84 <acquire>
  reparent(p);
    800015dc:	854e                	mv	a0,s3
    800015de:	ef5ff0ef          	jal	800014d2 <reparent>
  wakeup(p->parent);
    800015e2:	0389b503          	ld	a0,56(s3)
    800015e6:	e83ff0ef          	jal	80001468 <wakeup>
  acquire(&p->lock);
    800015ea:	854e                	mv	a0,s3
    800015ec:	798040ef          	jal	80005d84 <acquire>
  p->xstate = status;
    800015f0:	0359a623          	sw	s5,44(s3)
  p->state = ZOMBIE;
    800015f4:	4795                	li	a5,5
    800015f6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800015fa:	8526                	mv	a0,s1
    800015fc:	01d040ef          	jal	80005e18 <release>
  sched();
    80001600:	d37ff0ef          	jal	80001336 <sched>
  panic("zombie exit");
    80001604:	00006517          	auipc	a0,0x6
    80001608:	c2c50513          	addi	a0,a0,-980 # 80007230 <etext+0x230>
    8000160c:	44a040ef          	jal	80005a56 <panic>

0000000080001610 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001610:	7179                	addi	sp,sp,-48
    80001612:	f406                	sd	ra,40(sp)
    80001614:	f022                	sd	s0,32(sp)
    80001616:	ec26                	sd	s1,24(sp)
    80001618:	e84a                	sd	s2,16(sp)
    8000161a:	e44e                	sd	s3,8(sp)
    8000161c:	1800                	addi	s0,sp,48
    8000161e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001620:	00009497          	auipc	s1,0x9
    80001624:	3d048493          	addi	s1,s1,976 # 8000a9f0 <proc>
    80001628:	00019997          	auipc	s3,0x19
    8000162c:	dc898993          	addi	s3,s3,-568 # 8001a3f0 <tickslock>
    acquire(&p->lock);
    80001630:	8526                	mv	a0,s1
    80001632:	752040ef          	jal	80005d84 <acquire>
    if(p->pid == pid){
    80001636:	589c                	lw	a5,48(s1)
    80001638:	01278b63          	beq	a5,s2,8000164e <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000163c:	8526                	mv	a0,s1
    8000163e:	7da040ef          	jal	80005e18 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001642:	3e848493          	addi	s1,s1,1000
    80001646:	ff3495e3          	bne	s1,s3,80001630 <kill+0x20>
  }
  return -1;
    8000164a:	557d                	li	a0,-1
    8000164c:	a819                	j	80001662 <kill+0x52>
      p->killed = 1;
    8000164e:	4785                	li	a5,1
    80001650:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001652:	4c98                	lw	a4,24(s1)
    80001654:	4789                	li	a5,2
    80001656:	00f70d63          	beq	a4,a5,80001670 <kill+0x60>
      release(&p->lock);
    8000165a:	8526                	mv	a0,s1
    8000165c:	7bc040ef          	jal	80005e18 <release>
      return 0;
    80001660:	4501                	li	a0,0
}
    80001662:	70a2                	ld	ra,40(sp)
    80001664:	7402                	ld	s0,32(sp)
    80001666:	64e2                	ld	s1,24(sp)
    80001668:	6942                	ld	s2,16(sp)
    8000166a:	69a2                	ld	s3,8(sp)
    8000166c:	6145                	addi	sp,sp,48
    8000166e:	8082                	ret
        p->state = RUNNABLE;
    80001670:	478d                	li	a5,3
    80001672:	cc9c                	sw	a5,24(s1)
    80001674:	b7dd                	j	8000165a <kill+0x4a>

0000000080001676 <setkilled>:

void
setkilled(struct proc *p)
{
    80001676:	1101                	addi	sp,sp,-32
    80001678:	ec06                	sd	ra,24(sp)
    8000167a:	e822                	sd	s0,16(sp)
    8000167c:	e426                	sd	s1,8(sp)
    8000167e:	1000                	addi	s0,sp,32
    80001680:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001682:	702040ef          	jal	80005d84 <acquire>
  p->killed = 1;
    80001686:	4785                	li	a5,1
    80001688:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000168a:	8526                	mv	a0,s1
    8000168c:	78c040ef          	jal	80005e18 <release>
}
    80001690:	60e2                	ld	ra,24(sp)
    80001692:	6442                	ld	s0,16(sp)
    80001694:	64a2                	ld	s1,8(sp)
    80001696:	6105                	addi	sp,sp,32
    80001698:	8082                	ret

000000008000169a <killed>:

int
killed(struct proc *p)
{
    8000169a:	1101                	addi	sp,sp,-32
    8000169c:	ec06                	sd	ra,24(sp)
    8000169e:	e822                	sd	s0,16(sp)
    800016a0:	e426                	sd	s1,8(sp)
    800016a2:	e04a                	sd	s2,0(sp)
    800016a4:	1000                	addi	s0,sp,32
    800016a6:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800016a8:	6dc040ef          	jal	80005d84 <acquire>
  k = p->killed;
    800016ac:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800016b0:	8526                	mv	a0,s1
    800016b2:	766040ef          	jal	80005e18 <release>
  return k;
}
    800016b6:	854a                	mv	a0,s2
    800016b8:	60e2                	ld	ra,24(sp)
    800016ba:	6442                	ld	s0,16(sp)
    800016bc:	64a2                	ld	s1,8(sp)
    800016be:	6902                	ld	s2,0(sp)
    800016c0:	6105                	addi	sp,sp,32
    800016c2:	8082                	ret

00000000800016c4 <wait>:
{
    800016c4:	715d                	addi	sp,sp,-80
    800016c6:	e486                	sd	ra,72(sp)
    800016c8:	e0a2                	sd	s0,64(sp)
    800016ca:	fc26                	sd	s1,56(sp)
    800016cc:	f84a                	sd	s2,48(sp)
    800016ce:	f44e                	sd	s3,40(sp)
    800016d0:	f052                	sd	s4,32(sp)
    800016d2:	ec56                	sd	s5,24(sp)
    800016d4:	e85a                	sd	s6,16(sp)
    800016d6:	e45e                	sd	s7,8(sp)
    800016d8:	0880                	addi	s0,sp,80
    800016da:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016dc:	f2eff0ef          	jal	80000e0a <myproc>
    800016e0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016e2:	00009517          	auipc	a0,0x9
    800016e6:	ef650513          	addi	a0,a0,-266 # 8000a5d8 <wait_lock>
    800016ea:	69a040ef          	jal	80005d84 <acquire>
        if(pp->state == ZOMBIE){
    800016ee:	4a15                	li	s4,5
        havekids = 1;
    800016f0:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016f2:	00019997          	auipc	s3,0x19
    800016f6:	cfe98993          	addi	s3,s3,-770 # 8001a3f0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016fa:	00009b97          	auipc	s7,0x9
    800016fe:	edeb8b93          	addi	s7,s7,-290 # 8000a5d8 <wait_lock>
    80001702:	a869                	j	8000179c <wait+0xd8>
          pid = pp->pid;
    80001704:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001708:	000b0c63          	beqz	s6,80001720 <wait+0x5c>
    8000170c:	4691                	li	a3,4
    8000170e:	02c48613          	addi	a2,s1,44
    80001712:	85da                	mv	a1,s6
    80001714:	05093503          	ld	a0,80(s2)
    80001718:	b9aff0ef          	jal	80000ab2 <copyout>
    8000171c:	02054a63          	bltz	a0,80001750 <wait+0x8c>
          freeproc(pp);
    80001720:	8526                	mv	a0,s1
    80001722:	85bff0ef          	jal	80000f7c <freeproc>
          release(&pp->lock);
    80001726:	8526                	mv	a0,s1
    80001728:	6f0040ef          	jal	80005e18 <release>
          release(&wait_lock);
    8000172c:	00009517          	auipc	a0,0x9
    80001730:	eac50513          	addi	a0,a0,-340 # 8000a5d8 <wait_lock>
    80001734:	6e4040ef          	jal	80005e18 <release>
}
    80001738:	854e                	mv	a0,s3
    8000173a:	60a6                	ld	ra,72(sp)
    8000173c:	6406                	ld	s0,64(sp)
    8000173e:	74e2                	ld	s1,56(sp)
    80001740:	7942                	ld	s2,48(sp)
    80001742:	79a2                	ld	s3,40(sp)
    80001744:	7a02                	ld	s4,32(sp)
    80001746:	6ae2                	ld	s5,24(sp)
    80001748:	6b42                	ld	s6,16(sp)
    8000174a:	6ba2                	ld	s7,8(sp)
    8000174c:	6161                	addi	sp,sp,80
    8000174e:	8082                	ret
            release(&pp->lock);
    80001750:	8526                	mv	a0,s1
    80001752:	6c6040ef          	jal	80005e18 <release>
            release(&wait_lock);
    80001756:	00009517          	auipc	a0,0x9
    8000175a:	e8250513          	addi	a0,a0,-382 # 8000a5d8 <wait_lock>
    8000175e:	6ba040ef          	jal	80005e18 <release>
            return -1;
    80001762:	59fd                	li	s3,-1
    80001764:	bfd1                	j	80001738 <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001766:	3e848493          	addi	s1,s1,1000
    8000176a:	03348063          	beq	s1,s3,8000178a <wait+0xc6>
      if(pp->parent == p){
    8000176e:	7c9c                	ld	a5,56(s1)
    80001770:	ff279be3          	bne	a5,s2,80001766 <wait+0xa2>
        acquire(&pp->lock);
    80001774:	8526                	mv	a0,s1
    80001776:	60e040ef          	jal	80005d84 <acquire>
        if(pp->state == ZOMBIE){
    8000177a:	4c9c                	lw	a5,24(s1)
    8000177c:	f94784e3          	beq	a5,s4,80001704 <wait+0x40>
        release(&pp->lock);
    80001780:	8526                	mv	a0,s1
    80001782:	696040ef          	jal	80005e18 <release>
        havekids = 1;
    80001786:	8756                	mv	a4,s5
    80001788:	bff9                	j	80001766 <wait+0xa2>
    if(!havekids || killed(p)){
    8000178a:	cf19                	beqz	a4,800017a8 <wait+0xe4>
    8000178c:	854a                	mv	a0,s2
    8000178e:	f0dff0ef          	jal	8000169a <killed>
    80001792:	e919                	bnez	a0,800017a8 <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001794:	85de                	mv	a1,s7
    80001796:	854a                	mv	a0,s2
    80001798:	c85ff0ef          	jal	8000141c <sleep>
    havekids = 0;
    8000179c:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000179e:	00009497          	auipc	s1,0x9
    800017a2:	25248493          	addi	s1,s1,594 # 8000a9f0 <proc>
    800017a6:	b7e1                	j	8000176e <wait+0xaa>
      release(&wait_lock);
    800017a8:	00009517          	auipc	a0,0x9
    800017ac:	e3050513          	addi	a0,a0,-464 # 8000a5d8 <wait_lock>
    800017b0:	668040ef          	jal	80005e18 <release>
      return -1;
    800017b4:	59fd                	li	s3,-1
    800017b6:	b749                	j	80001738 <wait+0x74>

00000000800017b8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800017b8:	7179                	addi	sp,sp,-48
    800017ba:	f406                	sd	ra,40(sp)
    800017bc:	f022                	sd	s0,32(sp)
    800017be:	ec26                	sd	s1,24(sp)
    800017c0:	e84a                	sd	s2,16(sp)
    800017c2:	e44e                	sd	s3,8(sp)
    800017c4:	e052                	sd	s4,0(sp)
    800017c6:	1800                	addi	s0,sp,48
    800017c8:	84aa                	mv	s1,a0
    800017ca:	892e                	mv	s2,a1
    800017cc:	89b2                	mv	s3,a2
    800017ce:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800017d0:	e3aff0ef          	jal	80000e0a <myproc>
  if(user_dst){
    800017d4:	cc99                	beqz	s1,800017f2 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800017d6:	86d2                	mv	a3,s4
    800017d8:	864e                	mv	a2,s3
    800017da:	85ca                	mv	a1,s2
    800017dc:	6928                	ld	a0,80(a0)
    800017de:	ad4ff0ef          	jal	80000ab2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800017e2:	70a2                	ld	ra,40(sp)
    800017e4:	7402                	ld	s0,32(sp)
    800017e6:	64e2                	ld	s1,24(sp)
    800017e8:	6942                	ld	s2,16(sp)
    800017ea:	69a2                	ld	s3,8(sp)
    800017ec:	6a02                	ld	s4,0(sp)
    800017ee:	6145                	addi	sp,sp,48
    800017f0:	8082                	ret
    memmove((char *)dst, src, len);
    800017f2:	000a061b          	sext.w	a2,s4
    800017f6:	85ce                	mv	a1,s3
    800017f8:	854a                	mv	a0,s2
    800017fa:	9b9fe0ef          	jal	800001b2 <memmove>
    return 0;
    800017fe:	8526                	mv	a0,s1
    80001800:	b7cd                	j	800017e2 <either_copyout+0x2a>

0000000080001802 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001802:	7179                	addi	sp,sp,-48
    80001804:	f406                	sd	ra,40(sp)
    80001806:	f022                	sd	s0,32(sp)
    80001808:	ec26                	sd	s1,24(sp)
    8000180a:	e84a                	sd	s2,16(sp)
    8000180c:	e44e                	sd	s3,8(sp)
    8000180e:	e052                	sd	s4,0(sp)
    80001810:	1800                	addi	s0,sp,48
    80001812:	892a                	mv	s2,a0
    80001814:	84ae                	mv	s1,a1
    80001816:	89b2                	mv	s3,a2
    80001818:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000181a:	df0ff0ef          	jal	80000e0a <myproc>
  if(user_src){
    8000181e:	cc99                	beqz	s1,8000183c <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001820:	86d2                	mv	a3,s4
    80001822:	864e                	mv	a2,s3
    80001824:	85ca                	mv	a1,s2
    80001826:	6928                	ld	a0,80(a0)
    80001828:	b3aff0ef          	jal	80000b62 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000182c:	70a2                	ld	ra,40(sp)
    8000182e:	7402                	ld	s0,32(sp)
    80001830:	64e2                	ld	s1,24(sp)
    80001832:	6942                	ld	s2,16(sp)
    80001834:	69a2                	ld	s3,8(sp)
    80001836:	6a02                	ld	s4,0(sp)
    80001838:	6145                	addi	sp,sp,48
    8000183a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000183c:	000a061b          	sext.w	a2,s4
    80001840:	85ce                	mv	a1,s3
    80001842:	854a                	mv	a0,s2
    80001844:	96ffe0ef          	jal	800001b2 <memmove>
    return 0;
    80001848:	8526                	mv	a0,s1
    8000184a:	b7cd                	j	8000182c <either_copyin+0x2a>

000000008000184c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000184c:	715d                	addi	sp,sp,-80
    8000184e:	e486                	sd	ra,72(sp)
    80001850:	e0a2                	sd	s0,64(sp)
    80001852:	fc26                	sd	s1,56(sp)
    80001854:	f84a                	sd	s2,48(sp)
    80001856:	f44e                	sd	s3,40(sp)
    80001858:	f052                	sd	s4,32(sp)
    8000185a:	ec56                	sd	s5,24(sp)
    8000185c:	e85a                	sd	s6,16(sp)
    8000185e:	e45e                	sd	s7,8(sp)
    80001860:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001862:	00005517          	auipc	a0,0x5
    80001866:	7b650513          	addi	a0,a0,1974 # 80007018 <etext+0x18>
    8000186a:	71d030ef          	jal	80005786 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000186e:	00009497          	auipc	s1,0x9
    80001872:	55a48493          	addi	s1,s1,1370 # 8000adc8 <proc+0x3d8>
    80001876:	00019917          	auipc	s2,0x19
    8000187a:	f5290913          	addi	s2,s2,-174 # 8001a7c8 <bcache+0x3c0>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000187e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001880:	00006997          	auipc	s3,0x6
    80001884:	9c098993          	addi	s3,s3,-1600 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001888:	00006a97          	auipc	s5,0x6
    8000188c:	9c0a8a93          	addi	s5,s5,-1600 # 80007248 <etext+0x248>
    printf("\n");
    80001890:	00005a17          	auipc	s4,0x5
    80001894:	788a0a13          	addi	s4,s4,1928 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001898:	00006b97          	auipc	s7,0x6
    8000189c:	fe8b8b93          	addi	s7,s7,-24 # 80007880 <states.0>
    800018a0:	a829                	j	800018ba <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800018a2:	c586a583          	lw	a1,-936(a3)
    800018a6:	8556                	mv	a0,s5
    800018a8:	6df030ef          	jal	80005786 <printf>
    printf("\n");
    800018ac:	8552                	mv	a0,s4
    800018ae:	6d9030ef          	jal	80005786 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800018b2:	3e848493          	addi	s1,s1,1000
    800018b6:	03248263          	beq	s1,s2,800018da <procdump+0x8e>
    if(p->state == UNUSED)
    800018ba:	86a6                	mv	a3,s1
    800018bc:	c404a783          	lw	a5,-960(s1)
    800018c0:	dbed                	beqz	a5,800018b2 <procdump+0x66>
      state = "???";
    800018c2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800018c4:	fcfb6fe3          	bltu	s6,a5,800018a2 <procdump+0x56>
    800018c8:	02079713          	slli	a4,a5,0x20
    800018cc:	01d75793          	srli	a5,a4,0x1d
    800018d0:	97de                	add	a5,a5,s7
    800018d2:	6390                	ld	a2,0(a5)
    800018d4:	f679                	bnez	a2,800018a2 <procdump+0x56>
      state = "???";
    800018d6:	864e                	mv	a2,s3
    800018d8:	b7e9                	j	800018a2 <procdump+0x56>
  }
}
    800018da:	60a6                	ld	ra,72(sp)
    800018dc:	6406                	ld	s0,64(sp)
    800018de:	74e2                	ld	s1,56(sp)
    800018e0:	7942                	ld	s2,48(sp)
    800018e2:	79a2                	ld	s3,40(sp)
    800018e4:	7a02                	ld	s4,32(sp)
    800018e6:	6ae2                	ld	s5,24(sp)
    800018e8:	6b42                	ld	s6,16(sp)
    800018ea:	6ba2                	ld	s7,8(sp)
    800018ec:	6161                	addi	sp,sp,80
    800018ee:	8082                	ret

00000000800018f0 <swtch>:
    800018f0:	00153023          	sd	ra,0(a0)
    800018f4:	00253423          	sd	sp,8(a0)
    800018f8:	e900                	sd	s0,16(a0)
    800018fa:	ed04                	sd	s1,24(a0)
    800018fc:	03253023          	sd	s2,32(a0)
    80001900:	03353423          	sd	s3,40(a0)
    80001904:	03453823          	sd	s4,48(a0)
    80001908:	03553c23          	sd	s5,56(a0)
    8000190c:	05653023          	sd	s6,64(a0)
    80001910:	05753423          	sd	s7,72(a0)
    80001914:	05853823          	sd	s8,80(a0)
    80001918:	05953c23          	sd	s9,88(a0)
    8000191c:	07a53023          	sd	s10,96(a0)
    80001920:	07b53423          	sd	s11,104(a0)
    80001924:	0005b083          	ld	ra,0(a1)
    80001928:	0085b103          	ld	sp,8(a1)
    8000192c:	6980                	ld	s0,16(a1)
    8000192e:	6d84                	ld	s1,24(a1)
    80001930:	0205b903          	ld	s2,32(a1)
    80001934:	0285b983          	ld	s3,40(a1)
    80001938:	0305ba03          	ld	s4,48(a1)
    8000193c:	0385ba83          	ld	s5,56(a1)
    80001940:	0405bb03          	ld	s6,64(a1)
    80001944:	0485bb83          	ld	s7,72(a1)
    80001948:	0505bc03          	ld	s8,80(a1)
    8000194c:	0585bc83          	ld	s9,88(a1)
    80001950:	0605bd03          	ld	s10,96(a1)
    80001954:	0685bd83          	ld	s11,104(a1)
    80001958:	8082                	ret

000000008000195a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000195a:	1141                	addi	sp,sp,-16
    8000195c:	e406                	sd	ra,8(sp)
    8000195e:	e022                	sd	s0,0(sp)
    80001960:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001962:	00006597          	auipc	a1,0x6
    80001966:	92658593          	addi	a1,a1,-1754 # 80007288 <etext+0x288>
    8000196a:	00019517          	auipc	a0,0x19
    8000196e:	a8650513          	addi	a0,a0,-1402 # 8001a3f0 <tickslock>
    80001972:	38e040ef          	jal	80005d00 <initlock>
}
    80001976:	60a2                	ld	ra,8(sp)
    80001978:	6402                	ld	s0,0(sp)
    8000197a:	0141                	addi	sp,sp,16
    8000197c:	8082                	ret

000000008000197e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000197e:	1141                	addi	sp,sp,-16
    80001980:	e406                	sd	ra,8(sp)
    80001982:	e022                	sd	s0,0(sp)
    80001984:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001986:	00003797          	auipc	a5,0x3
    8000198a:	36a78793          	addi	a5,a5,874 # 80004cf0 <kernelvec>
    8000198e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001992:	60a2                	ld	ra,8(sp)
    80001994:	6402                	ld	s0,0(sp)
    80001996:	0141                	addi	sp,sp,16
    80001998:	8082                	ret

000000008000199a <conflictdet>:
  usertrapret();
}

int
conflictdet(struct VMA *vmas, uint64 va, int len)
{
    8000199a:	1141                	addi	sp,sp,-16
    8000199c:	e406                	sd	ra,8(sp)
    8000199e:	e022                	sd	s0,0(sp)
    800019a0:	0800                	addi	s0,sp,16
  for (int i = 0; i < NVMA; i++) {
    800019a2:	87aa                	mv	a5,a0
    800019a4:	4501                	li	a0,0
    if (vmas[i].len) {
      uint64 left = vmas[i].addr;
      uint64 right = vmas[i].addr + vmas[i].len;
      if (va < right && va+len >= left)
    800019a6:	962e                	add	a2,a2,a1
  for (int i = 0; i < NVMA; i++) {
    800019a8:	4841                	li	a6,16
    800019aa:	a031                	j	800019b6 <conflictdet+0x1c>
    800019ac:	2505                	addiw	a0,a0,1
    800019ae:	02878793          	addi	a5,a5,40
    800019b2:	01050b63          	beq	a0,a6,800019c8 <conflictdet+0x2e>
    if (vmas[i].len) {
    800019b6:	4398                	lw	a4,0(a5)
    800019b8:	db75                	beqz	a4,800019ac <conflictdet+0x12>
      uint64 left = vmas[i].addr;
    800019ba:	6b94                	ld	a3,16(a5)
      uint64 right = vmas[i].addr + vmas[i].len;
    800019bc:	9736                	add	a4,a4,a3
      if (va < right && va+len >= left)
    800019be:	fee5f7e3          	bgeu	a1,a4,800019ac <conflictdet+0x12>
    800019c2:	fed665e3          	bltu	a2,a3,800019ac <conflictdet+0x12>
    800019c6:	a011                	j	800019ca <conflictdet+0x30>
        return i;
    }
  }
  return -1;
    800019c8:	557d                	li	a0,-1
}
    800019ca:	60a2                	ld	ra,8(sp)
    800019cc:	6402                	ld	s0,0(sp)
    800019ce:	0141                	addi	sp,sp,16
    800019d0:	8082                	ret

00000000800019d2 <pagefaulthandler>:

int
pagefaulthandler(uint64 fault_addr)
{
    800019d2:	7139                	addi	sp,sp,-64
    800019d4:	fc06                	sd	ra,56(sp)
    800019d6:	f822                	sd	s0,48(sp)
    800019d8:	f426                	sd	s1,40(sp)
    800019da:	f04a                	sd	s2,32(sp)
    800019dc:	ec4e                	sd	s3,24(sp)
    800019de:	0080                	addi	s0,sp,64
    800019e0:	892a                	mv	s2,a0
  int n;
  uint64 va;
  uint64 pa;
  char *mem;
  struct VMA *vma;
  struct proc *p = myproc();
    800019e2:	c28ff0ef          	jal	80000e0a <myproc>
    800019e6:	89aa                	mv	s3,a0


  printf("fault.addr: %p\n", (void *)fault_addr);
    800019e8:	85ca                	mv	a1,s2
    800019ea:	00006517          	auipc	a0,0x6
    800019ee:	8a650513          	addi	a0,a0,-1882 # 80007290 <etext+0x290>
    800019f2:	595030ef          	jal	80005786 <printf>
  int index;
  if ((index = conflictdet(p->vmas, fault_addr, 0)) == -1) {
    800019f6:	4601                	li	a2,0
    800019f8:	85ca                	mv	a1,s2
    800019fa:	15898513          	addi	a0,s3,344
    800019fe:	f9dff0ef          	jal	8000199a <conflictdet>
    80001a02:	84aa                	mv	s1,a0
    80001a04:	57fd                	li	a5,-1
    80001a06:	0af50963          	beq	a0,a5,80001ab8 <pagefaulthandler+0xe6>
    80001a0a:	e456                	sd	s5,8(sp)
    printf("page fault: addr not assigned\n");
    return -1;
  }
  vma = &p->vmas[index];
  va = PGROUNDDOWN(fault_addr);
    80001a0c:	7afd                	lui	s5,0xfffff
    80001a0e:	01597ab3          	and	s5,s2,s5

  if ((pa = walkaddr(p->pagetable, fault_addr)) != 0) 
    80001a12:	85ca                	mv	a1,s2
    80001a14:	0509b503          	ld	a0,80(s3)
    80001a18:	a65fe0ef          	jal	8000047c <walkaddr>
    80001a1c:	0e051b63          	bnez	a0,80001b12 <pagefaulthandler+0x140>
    80001a20:	e852                	sd	s4,16(sp)
    if (!(PA2PTE(pa) & PTE_W))
      return -1;

  if ((mem = kalloc()) == 0) {
    80001a22:	edcfe0ef          	jal	800000fe <kalloc>
    80001a26:	8a2a                	mv	s4,a0
    80001a28:	cd59                	beqz	a0,80001ac6 <pagefaulthandler+0xf4>
    printf("page fault: Page Fault: no free memory\n");
    return -1;
  }
  memset(mem, 0, PGSIZE);
    80001a2a:	6605                	lui	a2,0x1
    80001a2c:	4581                	li	a1,0
    80001a2e:	f20fe0ef          	jal	8000014e <memset>

  ilock(vma->f->ip);
    80001a32:	00249913          	slli	s2,s1,0x2
    80001a36:	9926                	add	s2,s2,s1
    80001a38:	090e                	slli	s2,s2,0x3
    80001a3a:	994e                	add	s2,s2,s3
    80001a3c:	17893783          	ld	a5,376(s2)
    80001a40:	6f88                	ld	a0,24(a5)
    80001a42:	6ab000ef          	jal	800028ec <ilock>
  if ((n = readi(vma->f->ip, 0, (uint64)mem, vma->offset + va - vma->addr, PGSIZE)) < 0) {
    80001a46:	16492783          	lw	a5,356(s2)
    80001a4a:	015787bb          	addw	a5,a5,s5
    80001a4e:	16893683          	ld	a3,360(s2)
    80001a52:	17893503          	ld	a0,376(s2)
    80001a56:	6705                	lui	a4,0x1
    80001a58:	40d786bb          	subw	a3,a5,a3
    80001a5c:	8652                	mv	a2,s4
    80001a5e:	4581                	li	a1,0
    80001a60:	6d08                	ld	a0,24(a0)
    80001a62:	0e2010ef          	jal	80002b44 <readi>
    80001a66:	06054a63          	bltz	a0,80001ada <pagefaulthandler+0x108>
    printf("page fault: read file fail\n");
    iunlock(vma->f->ip);
    return -1;
  }
  iunlock(vma->f->ip);
    80001a6a:	00249913          	slli	s2,s1,0x2
    80001a6e:	009907b3          	add	a5,s2,s1
    80001a72:	078e                	slli	a5,a5,0x3
    80001a74:	97ce                	add	a5,a5,s3
    80001a76:	1787b783          	ld	a5,376(a5)
    80001a7a:	6f88                	ld	a0,24(a5)
    80001a7c:	71f000ef          	jal	8000299a <iunlock>
  if (mappages(p->pagetable, va, PGSIZE, (uint64)mem, PTE_U | (vma->prot << 1)) != 0) {
    80001a80:	9926                	add	s2,s2,s1
    80001a82:	090e                	slli	s2,s2,0x3
    80001a84:	994e                	add	s2,s2,s3
    80001a86:	15c92703          	lw	a4,348(s2)
    80001a8a:	0017171b          	slliw	a4,a4,0x1
    80001a8e:	01076713          	ori	a4,a4,16
    80001a92:	86d2                	mv	a3,s4
    80001a94:	6605                	lui	a2,0x1
    80001a96:	85d6                	mv	a1,s5
    80001a98:	0509b503          	ld	a0,80(s3)
    80001a9c:	a1ffe0ef          	jal	800004ba <mappages>
    80001aa0:	84aa                	mv	s1,a0
    80001aa2:	e939                	bnez	a0,80001af8 <pagefaulthandler+0x126>
    80001aa4:	6a42                	ld	s4,16(sp)
    80001aa6:	6aa2                	ld	s5,8(sp)
    kfree(mem);
    printf("Page Fault: mmap map fault\n");
    return -1;
  }
  return 0;
}
    80001aa8:	8526                	mv	a0,s1
    80001aaa:	70e2                	ld	ra,56(sp)
    80001aac:	7442                	ld	s0,48(sp)
    80001aae:	74a2                	ld	s1,40(sp)
    80001ab0:	7902                	ld	s2,32(sp)
    80001ab2:	69e2                	ld	s3,24(sp)
    80001ab4:	6121                	addi	sp,sp,64
    80001ab6:	8082                	ret
    printf("page fault: addr not assigned\n");
    80001ab8:	00005517          	auipc	a0,0x5
    80001abc:	7e850513          	addi	a0,a0,2024 # 800072a0 <etext+0x2a0>
    80001ac0:	4c7030ef          	jal	80005786 <printf>
    return -1;
    80001ac4:	b7d5                	j	80001aa8 <pagefaulthandler+0xd6>
    printf("page fault: Page Fault: no free memory\n");
    80001ac6:	00005517          	auipc	a0,0x5
    80001aca:	7fa50513          	addi	a0,a0,2042 # 800072c0 <etext+0x2c0>
    80001ace:	4b9030ef          	jal	80005786 <printf>
    return -1;
    80001ad2:	54fd                	li	s1,-1
    80001ad4:	6a42                	ld	s4,16(sp)
    80001ad6:	6aa2                	ld	s5,8(sp)
    80001ad8:	bfc1                	j	80001aa8 <pagefaulthandler+0xd6>
    printf("page fault: read file fail\n");
    80001ada:	00006517          	auipc	a0,0x6
    80001ade:	80e50513          	addi	a0,a0,-2034 # 800072e8 <etext+0x2e8>
    80001ae2:	4a5030ef          	jal	80005786 <printf>
    iunlock(vma->f->ip);
    80001ae6:	17893783          	ld	a5,376(s2)
    80001aea:	6f88                	ld	a0,24(a5)
    80001aec:	6af000ef          	jal	8000299a <iunlock>
    return -1;
    80001af0:	54fd                	li	s1,-1
    80001af2:	6a42                	ld	s4,16(sp)
    80001af4:	6aa2                	ld	s5,8(sp)
    80001af6:	bf4d                	j	80001aa8 <pagefaulthandler+0xd6>
    kfree(mem);
    80001af8:	8552                	mv	a0,s4
    80001afa:	d22fe0ef          	jal	8000001c <kfree>
    printf("Page Fault: mmap map fault\n");
    80001afe:	00006517          	auipc	a0,0x6
    80001b02:	80a50513          	addi	a0,a0,-2038 # 80007308 <etext+0x308>
    80001b06:	481030ef          	jal	80005786 <printf>
    return -1;
    80001b0a:	54fd                	li	s1,-1
    80001b0c:	6a42                	ld	s4,16(sp)
    80001b0e:	6aa2                	ld	s5,8(sp)
    80001b10:	bf61                	j	80001aa8 <pagefaulthandler+0xd6>
      return -1;
    80001b12:	54fd                	li	s1,-1
    80001b14:	6aa2                	ld	s5,8(sp)
    80001b16:	bf49                	j	80001aa8 <pagefaulthandler+0xd6>

0000000080001b18 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b18:	1141                	addi	sp,sp,-16
    80001b1a:	e406                	sd	ra,8(sp)
    80001b1c:	e022                	sd	s0,0(sp)
    80001b1e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b20:	aeaff0ef          	jal	80000e0a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b28:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b2a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b2e:	00004697          	auipc	a3,0x4
    80001b32:	4d268693          	addi	a3,a3,1234 # 80006000 <_trampoline>
    80001b36:	00004717          	auipc	a4,0x4
    80001b3a:	4ca70713          	addi	a4,a4,1226 # 80006000 <_trampoline>
    80001b3e:	8f15                	sub	a4,a4,a3
    80001b40:	040007b7          	lui	a5,0x4000
    80001b44:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b46:	07b2                	slli	a5,a5,0xc
    80001b48:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b4a:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b4e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b50:	18002673          	csrr	a2,satp
    80001b54:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b56:	6d30                	ld	a2,88(a0)
    80001b58:	6138                	ld	a4,64(a0)
    80001b5a:	6585                	lui	a1,0x1
    80001b5c:	972e                	add	a4,a4,a1
    80001b5e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b60:	6d38                	ld	a4,88(a0)
    80001b62:	00000617          	auipc	a2,0x0
    80001b66:	11060613          	addi	a2,a2,272 # 80001c72 <usertrap>
    80001b6a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b6c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b6e:	8612                	mv	a2,tp
    80001b70:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b72:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b76:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b7a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b7e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b82:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b84:	6f18                	ld	a4,24(a4)
    80001b86:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b8a:	6928                	ld	a0,80(a0)
    80001b8c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b8e:	00004717          	auipc	a4,0x4
    80001b92:	50e70713          	addi	a4,a4,1294 # 8000609c <userret>
    80001b96:	8f15                	sub	a4,a4,a3
    80001b98:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b9a:	577d                	li	a4,-1
    80001b9c:	177e                	slli	a4,a4,0x3f
    80001b9e:	8d59                	or	a0,a0,a4
    80001ba0:	9782                	jalr	a5
}
    80001ba2:	60a2                	ld	ra,8(sp)
    80001ba4:	6402                	ld	s0,0(sp)
    80001ba6:	0141                	addi	sp,sp,16
    80001ba8:	8082                	ret

0000000080001baa <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001baa:	1101                	addi	sp,sp,-32
    80001bac:	ec06                	sd	ra,24(sp)
    80001bae:	e822                	sd	s0,16(sp)
    80001bb0:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001bb2:	a24ff0ef          	jal	80000dd6 <cpuid>
    80001bb6:	cd11                	beqz	a0,80001bd2 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001bb8:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001bbc:	000f4737          	lui	a4,0xf4
    80001bc0:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001bc4:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001bc6:	14d79073          	csrw	stimecmp,a5
}
    80001bca:	60e2                	ld	ra,24(sp)
    80001bcc:	6442                	ld	s0,16(sp)
    80001bce:	6105                	addi	sp,sp,32
    80001bd0:	8082                	ret
    80001bd2:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001bd4:	00019497          	auipc	s1,0x19
    80001bd8:	81c48493          	addi	s1,s1,-2020 # 8001a3f0 <tickslock>
    80001bdc:	8526                	mv	a0,s1
    80001bde:	1a6040ef          	jal	80005d84 <acquire>
    ticks++;
    80001be2:	00009517          	auipc	a0,0x9
    80001be6:	9a650513          	addi	a0,a0,-1626 # 8000a588 <ticks>
    80001bea:	411c                	lw	a5,0(a0)
    80001bec:	2785                	addiw	a5,a5,1
    80001bee:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001bf0:	879ff0ef          	jal	80001468 <wakeup>
    release(&tickslock);
    80001bf4:	8526                	mv	a0,s1
    80001bf6:	222040ef          	jal	80005e18 <release>
    80001bfa:	64a2                	ld	s1,8(sp)
    80001bfc:	bf75                	j	80001bb8 <clockintr+0xe>

0000000080001bfe <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001bfe:	1101                	addi	sp,sp,-32
    80001c00:	ec06                	sd	ra,24(sp)
    80001c02:	e822                	sd	s0,16(sp)
    80001c04:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c06:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001c0a:	57fd                	li	a5,-1
    80001c0c:	17fe                	slli	a5,a5,0x3f
    80001c0e:	07a5                	addi	a5,a5,9
    80001c10:	00f70c63          	beq	a4,a5,80001c28 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001c14:	57fd                	li	a5,-1
    80001c16:	17fe                	slli	a5,a5,0x3f
    80001c18:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001c1a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001c1c:	04f70763          	beq	a4,a5,80001c6a <devintr+0x6c>
  }
}
    80001c20:	60e2                	ld	ra,24(sp)
    80001c22:	6442                	ld	s0,16(sp)
    80001c24:	6105                	addi	sp,sp,32
    80001c26:	8082                	ret
    80001c28:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c2a:	172030ef          	jal	80004d9c <plic_claim>
    80001c2e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c30:	47a9                	li	a5,10
    80001c32:	00f50963          	beq	a0,a5,80001c44 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001c36:	4785                	li	a5,1
    80001c38:	00f50963          	beq	a0,a5,80001c4a <devintr+0x4c>
    return 1;
    80001c3c:	4505                	li	a0,1
    } else if(irq){
    80001c3e:	e889                	bnez	s1,80001c50 <devintr+0x52>
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	bff9                	j	80001c20 <devintr+0x22>
      uartintr();
    80001c44:	080040ef          	jal	80005cc4 <uartintr>
    if(irq)
    80001c48:	a819                	j	80001c5e <devintr+0x60>
      virtio_disk_intr();
    80001c4a:	5e2030ef          	jal	8000522c <virtio_disk_intr>
    if(irq)
    80001c4e:	a801                	j	80001c5e <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c50:	85a6                	mv	a1,s1
    80001c52:	00005517          	auipc	a0,0x5
    80001c56:	6d650513          	addi	a0,a0,1750 # 80007328 <etext+0x328>
    80001c5a:	32d030ef          	jal	80005786 <printf>
      plic_complete(irq);
    80001c5e:	8526                	mv	a0,s1
    80001c60:	15c030ef          	jal	80004dbc <plic_complete>
    return 1;
    80001c64:	4505                	li	a0,1
    80001c66:	64a2                	ld	s1,8(sp)
    80001c68:	bf65                	j	80001c20 <devintr+0x22>
    clockintr();
    80001c6a:	f41ff0ef          	jal	80001baa <clockintr>
    return 2;
    80001c6e:	4509                	li	a0,2
    80001c70:	bf45                	j	80001c20 <devintr+0x22>

0000000080001c72 <usertrap>:
{
    80001c72:	1101                	addi	sp,sp,-32
    80001c74:	ec06                	sd	ra,24(sp)
    80001c76:	e822                	sd	s0,16(sp)
    80001c78:	e426                	sd	s1,8(sp)
    80001c7a:	e04a                	sd	s2,0(sp)
    80001c7c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c82:	1007f793          	andi	a5,a5,256
    80001c86:	efa1                	bnez	a5,80001cde <usertrap+0x6c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c88:	00003797          	auipc	a5,0x3
    80001c8c:	06878793          	addi	a5,a5,104 # 80004cf0 <kernelvec>
    80001c90:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c94:	976ff0ef          	jal	80000e0a <myproc>
    80001c98:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c9a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c9c:	14102773          	csrr	a4,sepc
    80001ca0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ca2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ca6:	47a1                	li	a5,8
    80001ca8:	04f70163          	beq	a4,a5,80001cea <usertrap+0x78>
  } else if((which_dev = devintr()) != 0){
    80001cac:	f53ff0ef          	jal	80001bfe <devintr>
    80001cb0:	892a                	mv	s2,a0
    80001cb2:	e155                	bnez	a0,80001d56 <usertrap+0xe4>
    80001cb4:	14202773          	csrr	a4,scause
  } else if (r_scause() == 13 || r_scause() == 15) {
    80001cb8:	47b5                	li	a5,13
    80001cba:	00f70763          	beq	a4,a5,80001cc8 <usertrap+0x56>
    80001cbe:	14202773          	csrr	a4,scause
    80001cc2:	47bd                	li	a5,15
    80001cc4:	06f71263          	bne	a4,a5,80001d28 <usertrap+0xb6>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cc8:	14302573          	csrr	a0,stval
    if (pagefaulthandler(r_stval()) == -1)
    80001ccc:	d07ff0ef          	jal	800019d2 <pagefaulthandler>
    80001cd0:	57fd                	li	a5,-1
    80001cd2:	02f51b63          	bne	a0,a5,80001d08 <usertrap+0x96>
      setkilled(p);
    80001cd6:	8526                	mv	a0,s1
    80001cd8:	99fff0ef          	jal	80001676 <setkilled>
    80001cdc:	a035                	j	80001d08 <usertrap+0x96>
    panic("usertrap: not from user mode");
    80001cde:	00005517          	auipc	a0,0x5
    80001ce2:	66a50513          	addi	a0,a0,1642 # 80007348 <etext+0x348>
    80001ce6:	571030ef          	jal	80005a56 <panic>
    if(killed(p))
    80001cea:	9b1ff0ef          	jal	8000169a <killed>
    80001cee:	e90d                	bnez	a0,80001d20 <usertrap+0xae>
    p->trapframe->epc += 4;
    80001cf0:	6cb8                	ld	a4,88(s1)
    80001cf2:	6f1c                	ld	a5,24(a4)
    80001cf4:	0791                	addi	a5,a5,4
    80001cf6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cfc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d00:	10079073          	csrw	sstatus,a5
    syscall();
    80001d04:	24a000ef          	jal	80001f4e <syscall>
  if(killed(p))
    80001d08:	8526                	mv	a0,s1
    80001d0a:	991ff0ef          	jal	8000169a <killed>
    80001d0e:	e929                	bnez	a0,80001d60 <usertrap+0xee>
  usertrapret();
    80001d10:	e09ff0ef          	jal	80001b18 <usertrapret>
}
    80001d14:	60e2                	ld	ra,24(sp)
    80001d16:	6442                	ld	s0,16(sp)
    80001d18:	64a2                	ld	s1,8(sp)
    80001d1a:	6902                	ld	s2,0(sp)
    80001d1c:	6105                	addi	sp,sp,32
    80001d1e:	8082                	ret
      exit(-1);
    80001d20:	557d                	li	a0,-1
    80001d22:	807ff0ef          	jal	80001528 <exit>
    80001d26:	b7e9                	j	80001cf0 <usertrap+0x7e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d28:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001d2c:	5890                	lw	a2,48(s1)
    80001d2e:	00005517          	auipc	a0,0x5
    80001d32:	63a50513          	addi	a0,a0,1594 # 80007368 <etext+0x368>
    80001d36:	251030ef          	jal	80005786 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d3a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d3e:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001d42:	00005517          	auipc	a0,0x5
    80001d46:	65650513          	addi	a0,a0,1622 # 80007398 <etext+0x398>
    80001d4a:	23d030ef          	jal	80005786 <printf>
    setkilled(p);
    80001d4e:	8526                	mv	a0,s1
    80001d50:	927ff0ef          	jal	80001676 <setkilled>
    80001d54:	bf55                	j	80001d08 <usertrap+0x96>
  if(killed(p))
    80001d56:	8526                	mv	a0,s1
    80001d58:	943ff0ef          	jal	8000169a <killed>
    80001d5c:	c511                	beqz	a0,80001d68 <usertrap+0xf6>
    80001d5e:	a011                	j	80001d62 <usertrap+0xf0>
    80001d60:	4901                	li	s2,0
    exit(-1);
    80001d62:	557d                	li	a0,-1
    80001d64:	fc4ff0ef          	jal	80001528 <exit>
  if(which_dev == 2)
    80001d68:	4789                	li	a5,2
    80001d6a:	faf913e3          	bne	s2,a5,80001d10 <usertrap+0x9e>
    yield();
    80001d6e:	e82ff0ef          	jal	800013f0 <yield>
    80001d72:	bf79                	j	80001d10 <usertrap+0x9e>

0000000080001d74 <kerneltrap>:
{
    80001d74:	7179                	addi	sp,sp,-48
    80001d76:	f406                	sd	ra,40(sp)
    80001d78:	f022                	sd	s0,32(sp)
    80001d7a:	ec26                	sd	s1,24(sp)
    80001d7c:	e84a                	sd	s2,16(sp)
    80001d7e:	e44e                	sd	s3,8(sp)
    80001d80:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d82:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d86:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d8a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d8e:	1004f793          	andi	a5,s1,256
    80001d92:	c795                	beqz	a5,80001dbe <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d94:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d98:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d9a:	eb85                	bnez	a5,80001dca <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001d9c:	e63ff0ef          	jal	80001bfe <devintr>
    80001da0:	c91d                	beqz	a0,80001dd6 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001da2:	4789                	li	a5,2
    80001da4:	04f50a63          	beq	a0,a5,80001df8 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001da8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dac:	10049073          	csrw	sstatus,s1
}
    80001db0:	70a2                	ld	ra,40(sp)
    80001db2:	7402                	ld	s0,32(sp)
    80001db4:	64e2                	ld	s1,24(sp)
    80001db6:	6942                	ld	s2,16(sp)
    80001db8:	69a2                	ld	s3,8(sp)
    80001dba:	6145                	addi	sp,sp,48
    80001dbc:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dbe:	00005517          	auipc	a0,0x5
    80001dc2:	60250513          	addi	a0,a0,1538 # 800073c0 <etext+0x3c0>
    80001dc6:	491030ef          	jal	80005a56 <panic>
    panic("kerneltrap: interrupts enabled");
    80001dca:	00005517          	auipc	a0,0x5
    80001dce:	61e50513          	addi	a0,a0,1566 # 800073e8 <etext+0x3e8>
    80001dd2:	485030ef          	jal	80005a56 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dd6:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dda:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001dde:	85ce                	mv	a1,s3
    80001de0:	00005517          	auipc	a0,0x5
    80001de4:	62850513          	addi	a0,a0,1576 # 80007408 <etext+0x408>
    80001de8:	19f030ef          	jal	80005786 <printf>
    panic("kerneltrap");
    80001dec:	00005517          	auipc	a0,0x5
    80001df0:	64450513          	addi	a0,a0,1604 # 80007430 <etext+0x430>
    80001df4:	463030ef          	jal	80005a56 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001df8:	812ff0ef          	jal	80000e0a <myproc>
    80001dfc:	d555                	beqz	a0,80001da8 <kerneltrap+0x34>
    yield();
    80001dfe:	df2ff0ef          	jal	800013f0 <yield>
    80001e02:	b75d                	j	80001da8 <kerneltrap+0x34>

0000000080001e04 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e04:	1101                	addi	sp,sp,-32
    80001e06:	ec06                	sd	ra,24(sp)
    80001e08:	e822                	sd	s0,16(sp)
    80001e0a:	e426                	sd	s1,8(sp)
    80001e0c:	1000                	addi	s0,sp,32
    80001e0e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e10:	ffbfe0ef          	jal	80000e0a <myproc>
  switch (n) {
    80001e14:	4795                	li	a5,5
    80001e16:	0497e163          	bltu	a5,s1,80001e58 <argraw+0x54>
    80001e1a:	048a                	slli	s1,s1,0x2
    80001e1c:	00006717          	auipc	a4,0x6
    80001e20:	a9470713          	addi	a4,a4,-1388 # 800078b0 <states.0+0x30>
    80001e24:	94ba                	add	s1,s1,a4
    80001e26:	409c                	lw	a5,0(s1)
    80001e28:	97ba                	add	a5,a5,a4
    80001e2a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e2c:	6d3c                	ld	a5,88(a0)
    80001e2e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e30:	60e2                	ld	ra,24(sp)
    80001e32:	6442                	ld	s0,16(sp)
    80001e34:	64a2                	ld	s1,8(sp)
    80001e36:	6105                	addi	sp,sp,32
    80001e38:	8082                	ret
    return p->trapframe->a1;
    80001e3a:	6d3c                	ld	a5,88(a0)
    80001e3c:	7fa8                	ld	a0,120(a5)
    80001e3e:	bfcd                	j	80001e30 <argraw+0x2c>
    return p->trapframe->a2;
    80001e40:	6d3c                	ld	a5,88(a0)
    80001e42:	63c8                	ld	a0,128(a5)
    80001e44:	b7f5                	j	80001e30 <argraw+0x2c>
    return p->trapframe->a3;
    80001e46:	6d3c                	ld	a5,88(a0)
    80001e48:	67c8                	ld	a0,136(a5)
    80001e4a:	b7dd                	j	80001e30 <argraw+0x2c>
    return p->trapframe->a4;
    80001e4c:	6d3c                	ld	a5,88(a0)
    80001e4e:	6bc8                	ld	a0,144(a5)
    80001e50:	b7c5                	j	80001e30 <argraw+0x2c>
    return p->trapframe->a5;
    80001e52:	6d3c                	ld	a5,88(a0)
    80001e54:	6fc8                	ld	a0,152(a5)
    80001e56:	bfe9                	j	80001e30 <argraw+0x2c>
  panic("argraw");
    80001e58:	00005517          	auipc	a0,0x5
    80001e5c:	5e850513          	addi	a0,a0,1512 # 80007440 <etext+0x440>
    80001e60:	3f7030ef          	jal	80005a56 <panic>

0000000080001e64 <fetchaddr>:
{
    80001e64:	1101                	addi	sp,sp,-32
    80001e66:	ec06                	sd	ra,24(sp)
    80001e68:	e822                	sd	s0,16(sp)
    80001e6a:	e426                	sd	s1,8(sp)
    80001e6c:	e04a                	sd	s2,0(sp)
    80001e6e:	1000                	addi	s0,sp,32
    80001e70:	84aa                	mv	s1,a0
    80001e72:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e74:	f97fe0ef          	jal	80000e0a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001e78:	653c                	ld	a5,72(a0)
    80001e7a:	02f4f663          	bgeu	s1,a5,80001ea6 <fetchaddr+0x42>
    80001e7e:	00848713          	addi	a4,s1,8
    80001e82:	02e7e463          	bltu	a5,a4,80001eaa <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e86:	46a1                	li	a3,8
    80001e88:	8626                	mv	a2,s1
    80001e8a:	85ca                	mv	a1,s2
    80001e8c:	6928                	ld	a0,80(a0)
    80001e8e:	cd5fe0ef          	jal	80000b62 <copyin>
    80001e92:	00a03533          	snez	a0,a0
    80001e96:	40a0053b          	negw	a0,a0
}
    80001e9a:	60e2                	ld	ra,24(sp)
    80001e9c:	6442                	ld	s0,16(sp)
    80001e9e:	64a2                	ld	s1,8(sp)
    80001ea0:	6902                	ld	s2,0(sp)
    80001ea2:	6105                	addi	sp,sp,32
    80001ea4:	8082                	ret
    return -1;
    80001ea6:	557d                	li	a0,-1
    80001ea8:	bfcd                	j	80001e9a <fetchaddr+0x36>
    80001eaa:	557d                	li	a0,-1
    80001eac:	b7fd                	j	80001e9a <fetchaddr+0x36>

0000000080001eae <fetchstr>:
{
    80001eae:	7179                	addi	sp,sp,-48
    80001eb0:	f406                	sd	ra,40(sp)
    80001eb2:	f022                	sd	s0,32(sp)
    80001eb4:	ec26                	sd	s1,24(sp)
    80001eb6:	e84a                	sd	s2,16(sp)
    80001eb8:	e44e                	sd	s3,8(sp)
    80001eba:	1800                	addi	s0,sp,48
    80001ebc:	892a                	mv	s2,a0
    80001ebe:	84ae                	mv	s1,a1
    80001ec0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ec2:	f49fe0ef          	jal	80000e0a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001ec6:	86ce                	mv	a3,s3
    80001ec8:	864a                	mv	a2,s2
    80001eca:	85a6                	mv	a1,s1
    80001ecc:	6928                	ld	a0,80(a0)
    80001ece:	d1bfe0ef          	jal	80000be8 <copyinstr>
    80001ed2:	00054c63          	bltz	a0,80001eea <fetchstr+0x3c>
  return strlen(buf);
    80001ed6:	8526                	mv	a0,s1
    80001ed8:	bfefe0ef          	jal	800002d6 <strlen>
}
    80001edc:	70a2                	ld	ra,40(sp)
    80001ede:	7402                	ld	s0,32(sp)
    80001ee0:	64e2                	ld	s1,24(sp)
    80001ee2:	6942                	ld	s2,16(sp)
    80001ee4:	69a2                	ld	s3,8(sp)
    80001ee6:	6145                	addi	sp,sp,48
    80001ee8:	8082                	ret
    return -1;
    80001eea:	557d                	li	a0,-1
    80001eec:	bfc5                	j	80001edc <fetchstr+0x2e>

0000000080001eee <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001eee:	1101                	addi	sp,sp,-32
    80001ef0:	ec06                	sd	ra,24(sp)
    80001ef2:	e822                	sd	s0,16(sp)
    80001ef4:	e426                	sd	s1,8(sp)
    80001ef6:	1000                	addi	s0,sp,32
    80001ef8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001efa:	f0bff0ef          	jal	80001e04 <argraw>
    80001efe:	c088                	sw	a0,0(s1)
}
    80001f00:	60e2                	ld	ra,24(sp)
    80001f02:	6442                	ld	s0,16(sp)
    80001f04:	64a2                	ld	s1,8(sp)
    80001f06:	6105                	addi	sp,sp,32
    80001f08:	8082                	ret

0000000080001f0a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f0a:	1101                	addi	sp,sp,-32
    80001f0c:	ec06                	sd	ra,24(sp)
    80001f0e:	e822                	sd	s0,16(sp)
    80001f10:	e426                	sd	s1,8(sp)
    80001f12:	1000                	addi	s0,sp,32
    80001f14:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f16:	eefff0ef          	jal	80001e04 <argraw>
    80001f1a:	e088                	sd	a0,0(s1)
}
    80001f1c:	60e2                	ld	ra,24(sp)
    80001f1e:	6442                	ld	s0,16(sp)
    80001f20:	64a2                	ld	s1,8(sp)
    80001f22:	6105                	addi	sp,sp,32
    80001f24:	8082                	ret

0000000080001f26 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f26:	1101                	addi	sp,sp,-32
    80001f28:	ec06                	sd	ra,24(sp)
    80001f2a:	e822                	sd	s0,16(sp)
    80001f2c:	e426                	sd	s1,8(sp)
    80001f2e:	e04a                	sd	s2,0(sp)
    80001f30:	1000                	addi	s0,sp,32
    80001f32:	84ae                	mv	s1,a1
    80001f34:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f36:	ecfff0ef          	jal	80001e04 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001f3a:	864a                	mv	a2,s2
    80001f3c:	85a6                	mv	a1,s1
    80001f3e:	f71ff0ef          	jal	80001eae <fetchstr>
}
    80001f42:	60e2                	ld	ra,24(sp)
    80001f44:	6442                	ld	s0,16(sp)
    80001f46:	64a2                	ld	s1,8(sp)
    80001f48:	6902                	ld	s2,0(sp)
    80001f4a:	6105                	addi	sp,sp,32
    80001f4c:	8082                	ret

0000000080001f4e <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    80001f4e:	1101                	addi	sp,sp,-32
    80001f50:	ec06                	sd	ra,24(sp)
    80001f52:	e822                	sd	s0,16(sp)
    80001f54:	e426                	sd	s1,8(sp)
    80001f56:	e04a                	sd	s2,0(sp)
    80001f58:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001f5a:	eb1fe0ef          	jal	80000e0a <myproc>
    80001f5e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001f60:	05853903          	ld	s2,88(a0)
    80001f64:	0a893783          	ld	a5,168(s2)
    80001f68:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001f6c:	37fd                	addiw	a5,a5,-1
    80001f6e:	4759                	li	a4,22
    80001f70:	00f76f63          	bltu	a4,a5,80001f8e <syscall+0x40>
    80001f74:	00369713          	slli	a4,a3,0x3
    80001f78:	00006797          	auipc	a5,0x6
    80001f7c:	95078793          	addi	a5,a5,-1712 # 800078c8 <syscalls>
    80001f80:	97ba                	add	a5,a5,a4
    80001f82:	639c                	ld	a5,0(a5)
    80001f84:	c789                	beqz	a5,80001f8e <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001f86:	9782                	jalr	a5
    80001f88:	06a93823          	sd	a0,112(s2)
    80001f8c:	a829                	j	80001fa6 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001f8e:	3d848613          	addi	a2,s1,984
    80001f92:	588c                	lw	a1,48(s1)
    80001f94:	00005517          	auipc	a0,0x5
    80001f98:	4b450513          	addi	a0,a0,1204 # 80007448 <etext+0x448>
    80001f9c:	7ea030ef          	jal	80005786 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001fa0:	6cbc                	ld	a5,88(s1)
    80001fa2:	577d                	li	a4,-1
    80001fa4:	fbb8                	sd	a4,112(a5)
  }
}
    80001fa6:	60e2                	ld	ra,24(sp)
    80001fa8:	6442                	ld	s0,16(sp)
    80001faa:	64a2                	ld	s1,8(sp)
    80001fac:	6902                	ld	s2,0(sp)
    80001fae:	6105                	addi	sp,sp,32
    80001fb0:	8082                	ret

0000000080001fb2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001fb2:	1101                	addi	sp,sp,-32
    80001fb4:	ec06                	sd	ra,24(sp)
    80001fb6:	e822                	sd	s0,16(sp)
    80001fb8:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001fba:	fec40593          	addi	a1,s0,-20
    80001fbe:	4501                	li	a0,0
    80001fc0:	f2fff0ef          	jal	80001eee <argint>
  exit(n);
    80001fc4:	fec42503          	lw	a0,-20(s0)
    80001fc8:	d60ff0ef          	jal	80001528 <exit>
  return 0;  // not reached
}
    80001fcc:	4501                	li	a0,0
    80001fce:	60e2                	ld	ra,24(sp)
    80001fd0:	6442                	ld	s0,16(sp)
    80001fd2:	6105                	addi	sp,sp,32
    80001fd4:	8082                	ret

0000000080001fd6 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001fd6:	1141                	addi	sp,sp,-16
    80001fd8:	e406                	sd	ra,8(sp)
    80001fda:	e022                	sd	s0,0(sp)
    80001fdc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001fde:	e2dfe0ef          	jal	80000e0a <myproc>
}
    80001fe2:	5908                	lw	a0,48(a0)
    80001fe4:	60a2                	ld	ra,8(sp)
    80001fe6:	6402                	ld	s0,0(sp)
    80001fe8:	0141                	addi	sp,sp,16
    80001fea:	8082                	ret

0000000080001fec <sys_fork>:

uint64
sys_fork(void)
{
    80001fec:	1141                	addi	sp,sp,-16
    80001fee:	e406                	sd	ra,8(sp)
    80001ff0:	e022                	sd	s0,0(sp)
    80001ff2:	0800                	addi	s0,sp,16
  return fork();
    80001ff4:	93cff0ef          	jal	80001130 <fork>
}
    80001ff8:	60a2                	ld	ra,8(sp)
    80001ffa:	6402                	ld	s0,0(sp)
    80001ffc:	0141                	addi	sp,sp,16
    80001ffe:	8082                	ret

0000000080002000 <sys_wait>:

uint64
sys_wait(void)
{
    80002000:	1101                	addi	sp,sp,-32
    80002002:	ec06                	sd	ra,24(sp)
    80002004:	e822                	sd	s0,16(sp)
    80002006:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002008:	fe840593          	addi	a1,s0,-24
    8000200c:	4501                	li	a0,0
    8000200e:	efdff0ef          	jal	80001f0a <argaddr>
  return wait(p);
    80002012:	fe843503          	ld	a0,-24(s0)
    80002016:	eaeff0ef          	jal	800016c4 <wait>
}
    8000201a:	60e2                	ld	ra,24(sp)
    8000201c:	6442                	ld	s0,16(sp)
    8000201e:	6105                	addi	sp,sp,32
    80002020:	8082                	ret

0000000080002022 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002022:	7179                	addi	sp,sp,-48
    80002024:	f406                	sd	ra,40(sp)
    80002026:	f022                	sd	s0,32(sp)
    80002028:	ec26                	sd	s1,24(sp)
    8000202a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000202c:	fdc40593          	addi	a1,s0,-36
    80002030:	4501                	li	a0,0
    80002032:	ebdff0ef          	jal	80001eee <argint>
  addr = myproc()->sz;
    80002036:	dd5fe0ef          	jal	80000e0a <myproc>
    8000203a:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000203c:	fdc42503          	lw	a0,-36(s0)
    80002040:	8a0ff0ef          	jal	800010e0 <growproc>
    80002044:	00054863          	bltz	a0,80002054 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002048:	8526                	mv	a0,s1
    8000204a:	70a2                	ld	ra,40(sp)
    8000204c:	7402                	ld	s0,32(sp)
    8000204e:	64e2                	ld	s1,24(sp)
    80002050:	6145                	addi	sp,sp,48
    80002052:	8082                	ret
    return -1;
    80002054:	54fd                	li	s1,-1
    80002056:	bfcd                	j	80002048 <sys_sbrk+0x26>

0000000080002058 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002058:	7139                	addi	sp,sp,-64
    8000205a:	fc06                	sd	ra,56(sp)
    8000205c:	f822                	sd	s0,48(sp)
    8000205e:	f04a                	sd	s2,32(sp)
    80002060:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002062:	fcc40593          	addi	a1,s0,-52
    80002066:	4501                	li	a0,0
    80002068:	e87ff0ef          	jal	80001eee <argint>
  if(n < 0)
    8000206c:	fcc42783          	lw	a5,-52(s0)
    80002070:	0607c763          	bltz	a5,800020de <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002074:	00018517          	auipc	a0,0x18
    80002078:	37c50513          	addi	a0,a0,892 # 8001a3f0 <tickslock>
    8000207c:	509030ef          	jal	80005d84 <acquire>
  ticks0 = ticks;
    80002080:	00008917          	auipc	s2,0x8
    80002084:	50892903          	lw	s2,1288(s2) # 8000a588 <ticks>
  while(ticks - ticks0 < n){
    80002088:	fcc42783          	lw	a5,-52(s0)
    8000208c:	cf8d                	beqz	a5,800020c6 <sys_sleep+0x6e>
    8000208e:	f426                	sd	s1,40(sp)
    80002090:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002092:	00018997          	auipc	s3,0x18
    80002096:	35e98993          	addi	s3,s3,862 # 8001a3f0 <tickslock>
    8000209a:	00008497          	auipc	s1,0x8
    8000209e:	4ee48493          	addi	s1,s1,1262 # 8000a588 <ticks>
    if(killed(myproc())){
    800020a2:	d69fe0ef          	jal	80000e0a <myproc>
    800020a6:	df4ff0ef          	jal	8000169a <killed>
    800020aa:	ed0d                	bnez	a0,800020e4 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    800020ac:	85ce                	mv	a1,s3
    800020ae:	8526                	mv	a0,s1
    800020b0:	b6cff0ef          	jal	8000141c <sleep>
  while(ticks - ticks0 < n){
    800020b4:	409c                	lw	a5,0(s1)
    800020b6:	412787bb          	subw	a5,a5,s2
    800020ba:	fcc42703          	lw	a4,-52(s0)
    800020be:	fee7e2e3          	bltu	a5,a4,800020a2 <sys_sleep+0x4a>
    800020c2:	74a2                	ld	s1,40(sp)
    800020c4:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800020c6:	00018517          	auipc	a0,0x18
    800020ca:	32a50513          	addi	a0,a0,810 # 8001a3f0 <tickslock>
    800020ce:	54b030ef          	jal	80005e18 <release>
  return 0;
    800020d2:	4501                	li	a0,0
}
    800020d4:	70e2                	ld	ra,56(sp)
    800020d6:	7442                	ld	s0,48(sp)
    800020d8:	7902                	ld	s2,32(sp)
    800020da:	6121                	addi	sp,sp,64
    800020dc:	8082                	ret
    n = 0;
    800020de:	fc042623          	sw	zero,-52(s0)
    800020e2:	bf49                	j	80002074 <sys_sleep+0x1c>
      release(&tickslock);
    800020e4:	00018517          	auipc	a0,0x18
    800020e8:	30c50513          	addi	a0,a0,780 # 8001a3f0 <tickslock>
    800020ec:	52d030ef          	jal	80005e18 <release>
      return -1;
    800020f0:	557d                	li	a0,-1
    800020f2:	74a2                	ld	s1,40(sp)
    800020f4:	69e2                	ld	s3,24(sp)
    800020f6:	bff9                	j	800020d4 <sys_sleep+0x7c>

00000000800020f8 <sys_kill>:

uint64
sys_kill(void)
{
    800020f8:	1101                	addi	sp,sp,-32
    800020fa:	ec06                	sd	ra,24(sp)
    800020fc:	e822                	sd	s0,16(sp)
    800020fe:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002100:	fec40593          	addi	a1,s0,-20
    80002104:	4501                	li	a0,0
    80002106:	de9ff0ef          	jal	80001eee <argint>
  return kill(pid);
    8000210a:	fec42503          	lw	a0,-20(s0)
    8000210e:	d02ff0ef          	jal	80001610 <kill>
}
    80002112:	60e2                	ld	ra,24(sp)
    80002114:	6442                	ld	s0,16(sp)
    80002116:	6105                	addi	sp,sp,32
    80002118:	8082                	ret

000000008000211a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000211a:	1101                	addi	sp,sp,-32
    8000211c:	ec06                	sd	ra,24(sp)
    8000211e:	e822                	sd	s0,16(sp)
    80002120:	e426                	sd	s1,8(sp)
    80002122:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002124:	00018517          	auipc	a0,0x18
    80002128:	2cc50513          	addi	a0,a0,716 # 8001a3f0 <tickslock>
    8000212c:	459030ef          	jal	80005d84 <acquire>
  xticks = ticks;
    80002130:	00008497          	auipc	s1,0x8
    80002134:	4584a483          	lw	s1,1112(s1) # 8000a588 <ticks>
  release(&tickslock);
    80002138:	00018517          	auipc	a0,0x18
    8000213c:	2b850513          	addi	a0,a0,696 # 8001a3f0 <tickslock>
    80002140:	4d9030ef          	jal	80005e18 <release>
  return xticks;
}
    80002144:	02049513          	slli	a0,s1,0x20
    80002148:	9101                	srli	a0,a0,0x20
    8000214a:	60e2                	ld	ra,24(sp)
    8000214c:	6442                	ld	s0,16(sp)
    8000214e:	64a2                	ld	s1,8(sp)
    80002150:	6105                	addi	sp,sp,32
    80002152:	8082                	ret

0000000080002154 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002154:	7179                	addi	sp,sp,-48
    80002156:	f406                	sd	ra,40(sp)
    80002158:	f022                	sd	s0,32(sp)
    8000215a:	ec26                	sd	s1,24(sp)
    8000215c:	e84a                	sd	s2,16(sp)
    8000215e:	e44e                	sd	s3,8(sp)
    80002160:	e052                	sd	s4,0(sp)
    80002162:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002164:	00005597          	auipc	a1,0x5
    80002168:	30458593          	addi	a1,a1,772 # 80007468 <etext+0x468>
    8000216c:	00018517          	auipc	a0,0x18
    80002170:	29c50513          	addi	a0,a0,668 # 8001a408 <bcache>
    80002174:	38d030ef          	jal	80005d00 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002178:	00020797          	auipc	a5,0x20
    8000217c:	29078793          	addi	a5,a5,656 # 80022408 <bcache+0x8000>
    80002180:	00020717          	auipc	a4,0x20
    80002184:	4f070713          	addi	a4,a4,1264 # 80022670 <bcache+0x8268>
    80002188:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000218c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002190:	00018497          	auipc	s1,0x18
    80002194:	29048493          	addi	s1,s1,656 # 8001a420 <bcache+0x18>
    b->next = bcache.head.next;
    80002198:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000219a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000219c:	00005a17          	auipc	s4,0x5
    800021a0:	2d4a0a13          	addi	s4,s4,724 # 80007470 <etext+0x470>
    b->next = bcache.head.next;
    800021a4:	2b893783          	ld	a5,696(s2)
    800021a8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800021aa:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800021ae:	85d2                	mv	a1,s4
    800021b0:	01048513          	addi	a0,s1,16
    800021b4:	244010ef          	jal	800033f8 <initsleeplock>
    bcache.head.next->prev = b;
    800021b8:	2b893783          	ld	a5,696(s2)
    800021bc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800021be:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800021c2:	45848493          	addi	s1,s1,1112
    800021c6:	fd349fe3          	bne	s1,s3,800021a4 <binit+0x50>
  }
}
    800021ca:	70a2                	ld	ra,40(sp)
    800021cc:	7402                	ld	s0,32(sp)
    800021ce:	64e2                	ld	s1,24(sp)
    800021d0:	6942                	ld	s2,16(sp)
    800021d2:	69a2                	ld	s3,8(sp)
    800021d4:	6a02                	ld	s4,0(sp)
    800021d6:	6145                	addi	sp,sp,48
    800021d8:	8082                	ret

00000000800021da <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800021da:	7179                	addi	sp,sp,-48
    800021dc:	f406                	sd	ra,40(sp)
    800021de:	f022                	sd	s0,32(sp)
    800021e0:	ec26                	sd	s1,24(sp)
    800021e2:	e84a                	sd	s2,16(sp)
    800021e4:	e44e                	sd	s3,8(sp)
    800021e6:	1800                	addi	s0,sp,48
    800021e8:	892a                	mv	s2,a0
    800021ea:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800021ec:	00018517          	auipc	a0,0x18
    800021f0:	21c50513          	addi	a0,a0,540 # 8001a408 <bcache>
    800021f4:	391030ef          	jal	80005d84 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800021f8:	00020497          	auipc	s1,0x20
    800021fc:	4c84b483          	ld	s1,1224(s1) # 800226c0 <bcache+0x82b8>
    80002200:	00020797          	auipc	a5,0x20
    80002204:	47078793          	addi	a5,a5,1136 # 80022670 <bcache+0x8268>
    80002208:	02f48b63          	beq	s1,a5,8000223e <bread+0x64>
    8000220c:	873e                	mv	a4,a5
    8000220e:	a021                	j	80002216 <bread+0x3c>
    80002210:	68a4                	ld	s1,80(s1)
    80002212:	02e48663          	beq	s1,a4,8000223e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002216:	449c                	lw	a5,8(s1)
    80002218:	ff279ce3          	bne	a5,s2,80002210 <bread+0x36>
    8000221c:	44dc                	lw	a5,12(s1)
    8000221e:	ff3799e3          	bne	a5,s3,80002210 <bread+0x36>
      b->refcnt++;
    80002222:	40bc                	lw	a5,64(s1)
    80002224:	2785                	addiw	a5,a5,1
    80002226:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002228:	00018517          	auipc	a0,0x18
    8000222c:	1e050513          	addi	a0,a0,480 # 8001a408 <bcache>
    80002230:	3e9030ef          	jal	80005e18 <release>
      acquiresleep(&b->lock);
    80002234:	01048513          	addi	a0,s1,16
    80002238:	1f6010ef          	jal	8000342e <acquiresleep>
      return b;
    8000223c:	a889                	j	8000228e <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000223e:	00020497          	auipc	s1,0x20
    80002242:	47a4b483          	ld	s1,1146(s1) # 800226b8 <bcache+0x82b0>
    80002246:	00020797          	auipc	a5,0x20
    8000224a:	42a78793          	addi	a5,a5,1066 # 80022670 <bcache+0x8268>
    8000224e:	00f48863          	beq	s1,a5,8000225e <bread+0x84>
    80002252:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002254:	40bc                	lw	a5,64(s1)
    80002256:	cb91                	beqz	a5,8000226a <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002258:	64a4                	ld	s1,72(s1)
    8000225a:	fee49de3          	bne	s1,a4,80002254 <bread+0x7a>
  panic("bget: no buffers");
    8000225e:	00005517          	auipc	a0,0x5
    80002262:	21a50513          	addi	a0,a0,538 # 80007478 <etext+0x478>
    80002266:	7f0030ef          	jal	80005a56 <panic>
      b->dev = dev;
    8000226a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000226e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002272:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002276:	4785                	li	a5,1
    80002278:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000227a:	00018517          	auipc	a0,0x18
    8000227e:	18e50513          	addi	a0,a0,398 # 8001a408 <bcache>
    80002282:	397030ef          	jal	80005e18 <release>
      acquiresleep(&b->lock);
    80002286:	01048513          	addi	a0,s1,16
    8000228a:	1a4010ef          	jal	8000342e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000228e:	409c                	lw	a5,0(s1)
    80002290:	cb89                	beqz	a5,800022a2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002292:	8526                	mv	a0,s1
    80002294:	70a2                	ld	ra,40(sp)
    80002296:	7402                	ld	s0,32(sp)
    80002298:	64e2                	ld	s1,24(sp)
    8000229a:	6942                	ld	s2,16(sp)
    8000229c:	69a2                	ld	s3,8(sp)
    8000229e:	6145                	addi	sp,sp,48
    800022a0:	8082                	ret
    virtio_disk_rw(b, 0);
    800022a2:	4581                	li	a1,0
    800022a4:	8526                	mv	a0,s1
    800022a6:	57b020ef          	jal	80005020 <virtio_disk_rw>
    b->valid = 1;
    800022aa:	4785                	li	a5,1
    800022ac:	c09c                	sw	a5,0(s1)
  return b;
    800022ae:	b7d5                	j	80002292 <bread+0xb8>

00000000800022b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800022b0:	1101                	addi	sp,sp,-32
    800022b2:	ec06                	sd	ra,24(sp)
    800022b4:	e822                	sd	s0,16(sp)
    800022b6:	e426                	sd	s1,8(sp)
    800022b8:	1000                	addi	s0,sp,32
    800022ba:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800022bc:	0541                	addi	a0,a0,16
    800022be:	1ee010ef          	jal	800034ac <holdingsleep>
    800022c2:	c911                	beqz	a0,800022d6 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800022c4:	4585                	li	a1,1
    800022c6:	8526                	mv	a0,s1
    800022c8:	559020ef          	jal	80005020 <virtio_disk_rw>
}
    800022cc:	60e2                	ld	ra,24(sp)
    800022ce:	6442                	ld	s0,16(sp)
    800022d0:	64a2                	ld	s1,8(sp)
    800022d2:	6105                	addi	sp,sp,32
    800022d4:	8082                	ret
    panic("bwrite");
    800022d6:	00005517          	auipc	a0,0x5
    800022da:	1ba50513          	addi	a0,a0,442 # 80007490 <etext+0x490>
    800022de:	778030ef          	jal	80005a56 <panic>

00000000800022e2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800022e2:	1101                	addi	sp,sp,-32
    800022e4:	ec06                	sd	ra,24(sp)
    800022e6:	e822                	sd	s0,16(sp)
    800022e8:	e426                	sd	s1,8(sp)
    800022ea:	e04a                	sd	s2,0(sp)
    800022ec:	1000                	addi	s0,sp,32
    800022ee:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800022f0:	01050913          	addi	s2,a0,16
    800022f4:	854a                	mv	a0,s2
    800022f6:	1b6010ef          	jal	800034ac <holdingsleep>
    800022fa:	c125                	beqz	a0,8000235a <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    800022fc:	854a                	mv	a0,s2
    800022fe:	176010ef          	jal	80003474 <releasesleep>

  acquire(&bcache.lock);
    80002302:	00018517          	auipc	a0,0x18
    80002306:	10650513          	addi	a0,a0,262 # 8001a408 <bcache>
    8000230a:	27b030ef          	jal	80005d84 <acquire>
  b->refcnt--;
    8000230e:	40bc                	lw	a5,64(s1)
    80002310:	37fd                	addiw	a5,a5,-1
    80002312:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002314:	e79d                	bnez	a5,80002342 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002316:	68b8                	ld	a4,80(s1)
    80002318:	64bc                	ld	a5,72(s1)
    8000231a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000231c:	68b8                	ld	a4,80(s1)
    8000231e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002320:	00020797          	auipc	a5,0x20
    80002324:	0e878793          	addi	a5,a5,232 # 80022408 <bcache+0x8000>
    80002328:	2b87b703          	ld	a4,696(a5)
    8000232c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000232e:	00020717          	auipc	a4,0x20
    80002332:	34270713          	addi	a4,a4,834 # 80022670 <bcache+0x8268>
    80002336:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002338:	2b87b703          	ld	a4,696(a5)
    8000233c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000233e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002342:	00018517          	auipc	a0,0x18
    80002346:	0c650513          	addi	a0,a0,198 # 8001a408 <bcache>
    8000234a:	2cf030ef          	jal	80005e18 <release>
}
    8000234e:	60e2                	ld	ra,24(sp)
    80002350:	6442                	ld	s0,16(sp)
    80002352:	64a2                	ld	s1,8(sp)
    80002354:	6902                	ld	s2,0(sp)
    80002356:	6105                	addi	sp,sp,32
    80002358:	8082                	ret
    panic("brelse");
    8000235a:	00005517          	auipc	a0,0x5
    8000235e:	13e50513          	addi	a0,a0,318 # 80007498 <etext+0x498>
    80002362:	6f4030ef          	jal	80005a56 <panic>

0000000080002366 <bpin>:

void
bpin(struct buf *b) {
    80002366:	1101                	addi	sp,sp,-32
    80002368:	ec06                	sd	ra,24(sp)
    8000236a:	e822                	sd	s0,16(sp)
    8000236c:	e426                	sd	s1,8(sp)
    8000236e:	1000                	addi	s0,sp,32
    80002370:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002372:	00018517          	auipc	a0,0x18
    80002376:	09650513          	addi	a0,a0,150 # 8001a408 <bcache>
    8000237a:	20b030ef          	jal	80005d84 <acquire>
  b->refcnt++;
    8000237e:	40bc                	lw	a5,64(s1)
    80002380:	2785                	addiw	a5,a5,1
    80002382:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002384:	00018517          	auipc	a0,0x18
    80002388:	08450513          	addi	a0,a0,132 # 8001a408 <bcache>
    8000238c:	28d030ef          	jal	80005e18 <release>
}
    80002390:	60e2                	ld	ra,24(sp)
    80002392:	6442                	ld	s0,16(sp)
    80002394:	64a2                	ld	s1,8(sp)
    80002396:	6105                	addi	sp,sp,32
    80002398:	8082                	ret

000000008000239a <bunpin>:

void
bunpin(struct buf *b) {
    8000239a:	1101                	addi	sp,sp,-32
    8000239c:	ec06                	sd	ra,24(sp)
    8000239e:	e822                	sd	s0,16(sp)
    800023a0:	e426                	sd	s1,8(sp)
    800023a2:	1000                	addi	s0,sp,32
    800023a4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800023a6:	00018517          	auipc	a0,0x18
    800023aa:	06250513          	addi	a0,a0,98 # 8001a408 <bcache>
    800023ae:	1d7030ef          	jal	80005d84 <acquire>
  b->refcnt--;
    800023b2:	40bc                	lw	a5,64(s1)
    800023b4:	37fd                	addiw	a5,a5,-1
    800023b6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800023b8:	00018517          	auipc	a0,0x18
    800023bc:	05050513          	addi	a0,a0,80 # 8001a408 <bcache>
    800023c0:	259030ef          	jal	80005e18 <release>
}
    800023c4:	60e2                	ld	ra,24(sp)
    800023c6:	6442                	ld	s0,16(sp)
    800023c8:	64a2                	ld	s1,8(sp)
    800023ca:	6105                	addi	sp,sp,32
    800023cc:	8082                	ret

00000000800023ce <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800023ce:	1101                	addi	sp,sp,-32
    800023d0:	ec06                	sd	ra,24(sp)
    800023d2:	e822                	sd	s0,16(sp)
    800023d4:	e426                	sd	s1,8(sp)
    800023d6:	e04a                	sd	s2,0(sp)
    800023d8:	1000                	addi	s0,sp,32
    800023da:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800023dc:	00d5d79b          	srliw	a5,a1,0xd
    800023e0:	00020597          	auipc	a1,0x20
    800023e4:	7045a583          	lw	a1,1796(a1) # 80022ae4 <sb+0x1c>
    800023e8:	9dbd                	addw	a1,a1,a5
    800023ea:	df1ff0ef          	jal	800021da <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800023ee:	0074f713          	andi	a4,s1,7
    800023f2:	4785                	li	a5,1
    800023f4:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800023f8:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800023fa:	90d9                	srli	s1,s1,0x36
    800023fc:	00950733          	add	a4,a0,s1
    80002400:	05874703          	lbu	a4,88(a4)
    80002404:	00e7f6b3          	and	a3,a5,a4
    80002408:	c29d                	beqz	a3,8000242e <bfree+0x60>
    8000240a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000240c:	94aa                	add	s1,s1,a0
    8000240e:	fff7c793          	not	a5,a5
    80002412:	8f7d                	and	a4,a4,a5
    80002414:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002418:	711000ef          	jal	80003328 <log_write>
  brelse(bp);
    8000241c:	854a                	mv	a0,s2
    8000241e:	ec5ff0ef          	jal	800022e2 <brelse>
}
    80002422:	60e2                	ld	ra,24(sp)
    80002424:	6442                	ld	s0,16(sp)
    80002426:	64a2                	ld	s1,8(sp)
    80002428:	6902                	ld	s2,0(sp)
    8000242a:	6105                	addi	sp,sp,32
    8000242c:	8082                	ret
    panic("freeing free block");
    8000242e:	00005517          	auipc	a0,0x5
    80002432:	07250513          	addi	a0,a0,114 # 800074a0 <etext+0x4a0>
    80002436:	620030ef          	jal	80005a56 <panic>

000000008000243a <balloc>:
{
    8000243a:	715d                	addi	sp,sp,-80
    8000243c:	e486                	sd	ra,72(sp)
    8000243e:	e0a2                	sd	s0,64(sp)
    80002440:	fc26                	sd	s1,56(sp)
    80002442:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002444:	00020797          	auipc	a5,0x20
    80002448:	6887a783          	lw	a5,1672(a5) # 80022acc <sb+0x4>
    8000244c:	0e078863          	beqz	a5,8000253c <balloc+0x102>
    80002450:	f84a                	sd	s2,48(sp)
    80002452:	f44e                	sd	s3,40(sp)
    80002454:	f052                	sd	s4,32(sp)
    80002456:	ec56                	sd	s5,24(sp)
    80002458:	e85a                	sd	s6,16(sp)
    8000245a:	e45e                	sd	s7,8(sp)
    8000245c:	e062                	sd	s8,0(sp)
    8000245e:	8baa                	mv	s7,a0
    80002460:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002462:	00020b17          	auipc	s6,0x20
    80002466:	666b0b13          	addi	s6,s6,1638 # 80022ac8 <sb>
      m = 1 << (bi % 8);
    8000246a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000246c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000246e:	6c09                	lui	s8,0x2
    80002470:	a09d                	j	800024d6 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002472:	97ca                	add	a5,a5,s2
    80002474:	8e55                	or	a2,a2,a3
    80002476:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000247a:	854a                	mv	a0,s2
    8000247c:	6ad000ef          	jal	80003328 <log_write>
        brelse(bp);
    80002480:	854a                	mv	a0,s2
    80002482:	e61ff0ef          	jal	800022e2 <brelse>
  bp = bread(dev, bno);
    80002486:	85a6                	mv	a1,s1
    80002488:	855e                	mv	a0,s7
    8000248a:	d51ff0ef          	jal	800021da <bread>
    8000248e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002490:	40000613          	li	a2,1024
    80002494:	4581                	li	a1,0
    80002496:	05850513          	addi	a0,a0,88
    8000249a:	cb5fd0ef          	jal	8000014e <memset>
  log_write(bp);
    8000249e:	854a                	mv	a0,s2
    800024a0:	689000ef          	jal	80003328 <log_write>
  brelse(bp);
    800024a4:	854a                	mv	a0,s2
    800024a6:	e3dff0ef          	jal	800022e2 <brelse>
}
    800024aa:	7942                	ld	s2,48(sp)
    800024ac:	79a2                	ld	s3,40(sp)
    800024ae:	7a02                	ld	s4,32(sp)
    800024b0:	6ae2                	ld	s5,24(sp)
    800024b2:	6b42                	ld	s6,16(sp)
    800024b4:	6ba2                	ld	s7,8(sp)
    800024b6:	6c02                	ld	s8,0(sp)
}
    800024b8:	8526                	mv	a0,s1
    800024ba:	60a6                	ld	ra,72(sp)
    800024bc:	6406                	ld	s0,64(sp)
    800024be:	74e2                	ld	s1,56(sp)
    800024c0:	6161                	addi	sp,sp,80
    800024c2:	8082                	ret
    brelse(bp);
    800024c4:	854a                	mv	a0,s2
    800024c6:	e1dff0ef          	jal	800022e2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800024ca:	015c0abb          	addw	s5,s8,s5
    800024ce:	004b2783          	lw	a5,4(s6)
    800024d2:	04fafe63          	bgeu	s5,a5,8000252e <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    800024d6:	41fad79b          	sraiw	a5,s5,0x1f
    800024da:	0137d79b          	srliw	a5,a5,0x13
    800024de:	015787bb          	addw	a5,a5,s5
    800024e2:	40d7d79b          	sraiw	a5,a5,0xd
    800024e6:	01cb2583          	lw	a1,28(s6)
    800024ea:	9dbd                	addw	a1,a1,a5
    800024ec:	855e                	mv	a0,s7
    800024ee:	cedff0ef          	jal	800021da <bread>
    800024f2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800024f4:	004b2503          	lw	a0,4(s6)
    800024f8:	84d6                	mv	s1,s5
    800024fa:	4701                	li	a4,0
    800024fc:	fca4f4e3          	bgeu	s1,a0,800024c4 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002500:	00777693          	andi	a3,a4,7
    80002504:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002508:	41f7579b          	sraiw	a5,a4,0x1f
    8000250c:	01d7d79b          	srliw	a5,a5,0x1d
    80002510:	9fb9                	addw	a5,a5,a4
    80002512:	4037d79b          	sraiw	a5,a5,0x3
    80002516:	00f90633          	add	a2,s2,a5
    8000251a:	05864603          	lbu	a2,88(a2)
    8000251e:	00c6f5b3          	and	a1,a3,a2
    80002522:	d9a1                	beqz	a1,80002472 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002524:	2705                	addiw	a4,a4,1
    80002526:	2485                	addiw	s1,s1,1
    80002528:	fd471ae3          	bne	a4,s4,800024fc <balloc+0xc2>
    8000252c:	bf61                	j	800024c4 <balloc+0x8a>
    8000252e:	7942                	ld	s2,48(sp)
    80002530:	79a2                	ld	s3,40(sp)
    80002532:	7a02                	ld	s4,32(sp)
    80002534:	6ae2                	ld	s5,24(sp)
    80002536:	6b42                	ld	s6,16(sp)
    80002538:	6ba2                	ld	s7,8(sp)
    8000253a:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000253c:	00005517          	auipc	a0,0x5
    80002540:	f7c50513          	addi	a0,a0,-132 # 800074b8 <etext+0x4b8>
    80002544:	242030ef          	jal	80005786 <printf>
  return 0;
    80002548:	4481                	li	s1,0
    8000254a:	b7bd                	j	800024b8 <balloc+0x7e>

000000008000254c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000254c:	7179                	addi	sp,sp,-48
    8000254e:	f406                	sd	ra,40(sp)
    80002550:	f022                	sd	s0,32(sp)
    80002552:	ec26                	sd	s1,24(sp)
    80002554:	e84a                	sd	s2,16(sp)
    80002556:	e44e                	sd	s3,8(sp)
    80002558:	1800                	addi	s0,sp,48
    8000255a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000255c:	47ad                	li	a5,11
    8000255e:	02b7e363          	bltu	a5,a1,80002584 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80002562:	02059793          	slli	a5,a1,0x20
    80002566:	01e7d593          	srli	a1,a5,0x1e
    8000256a:	00b504b3          	add	s1,a0,a1
    8000256e:	0504a903          	lw	s2,80(s1)
    80002572:	06091363          	bnez	s2,800025d8 <bmap+0x8c>
      addr = balloc(ip->dev);
    80002576:	4108                	lw	a0,0(a0)
    80002578:	ec3ff0ef          	jal	8000243a <balloc>
    8000257c:	892a                	mv	s2,a0
      if(addr == 0)
    8000257e:	cd29                	beqz	a0,800025d8 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    80002580:	c8a8                	sw	a0,80(s1)
    80002582:	a899                	j	800025d8 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002584:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80002588:	0ff00793          	li	a5,255
    8000258c:	0697e963          	bltu	a5,s1,800025fe <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002590:	08052903          	lw	s2,128(a0)
    80002594:	00091b63          	bnez	s2,800025aa <bmap+0x5e>
      addr = balloc(ip->dev);
    80002598:	4108                	lw	a0,0(a0)
    8000259a:	ea1ff0ef          	jal	8000243a <balloc>
    8000259e:	892a                	mv	s2,a0
      if(addr == 0)
    800025a0:	cd05                	beqz	a0,800025d8 <bmap+0x8c>
    800025a2:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800025a4:	08a9a023          	sw	a0,128(s3)
    800025a8:	a011                	j	800025ac <bmap+0x60>
    800025aa:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800025ac:	85ca                	mv	a1,s2
    800025ae:	0009a503          	lw	a0,0(s3)
    800025b2:	c29ff0ef          	jal	800021da <bread>
    800025b6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800025b8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800025bc:	02049713          	slli	a4,s1,0x20
    800025c0:	01e75593          	srli	a1,a4,0x1e
    800025c4:	00b784b3          	add	s1,a5,a1
    800025c8:	0004a903          	lw	s2,0(s1)
    800025cc:	00090e63          	beqz	s2,800025e8 <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800025d0:	8552                	mv	a0,s4
    800025d2:	d11ff0ef          	jal	800022e2 <brelse>
    return addr;
    800025d6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800025d8:	854a                	mv	a0,s2
    800025da:	70a2                	ld	ra,40(sp)
    800025dc:	7402                	ld	s0,32(sp)
    800025de:	64e2                	ld	s1,24(sp)
    800025e0:	6942                	ld	s2,16(sp)
    800025e2:	69a2                	ld	s3,8(sp)
    800025e4:	6145                	addi	sp,sp,48
    800025e6:	8082                	ret
      addr = balloc(ip->dev);
    800025e8:	0009a503          	lw	a0,0(s3)
    800025ec:	e4fff0ef          	jal	8000243a <balloc>
    800025f0:	892a                	mv	s2,a0
      if(addr){
    800025f2:	dd79                	beqz	a0,800025d0 <bmap+0x84>
        a[bn] = addr;
    800025f4:	c088                	sw	a0,0(s1)
        log_write(bp);
    800025f6:	8552                	mv	a0,s4
    800025f8:	531000ef          	jal	80003328 <log_write>
    800025fc:	bfd1                	j	800025d0 <bmap+0x84>
    800025fe:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002600:	00005517          	auipc	a0,0x5
    80002604:	ed050513          	addi	a0,a0,-304 # 800074d0 <etext+0x4d0>
    80002608:	44e030ef          	jal	80005a56 <panic>

000000008000260c <iget>:
{
    8000260c:	7179                	addi	sp,sp,-48
    8000260e:	f406                	sd	ra,40(sp)
    80002610:	f022                	sd	s0,32(sp)
    80002612:	ec26                	sd	s1,24(sp)
    80002614:	e84a                	sd	s2,16(sp)
    80002616:	e44e                	sd	s3,8(sp)
    80002618:	e052                	sd	s4,0(sp)
    8000261a:	1800                	addi	s0,sp,48
    8000261c:	89aa                	mv	s3,a0
    8000261e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002620:	00020517          	auipc	a0,0x20
    80002624:	4c850513          	addi	a0,a0,1224 # 80022ae8 <itable>
    80002628:	75c030ef          	jal	80005d84 <acquire>
  empty = 0;
    8000262c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000262e:	00020497          	auipc	s1,0x20
    80002632:	4d248493          	addi	s1,s1,1234 # 80022b00 <itable+0x18>
    80002636:	00022697          	auipc	a3,0x22
    8000263a:	f5a68693          	addi	a3,a3,-166 # 80024590 <log>
    8000263e:	a039                	j	8000264c <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002640:	02090963          	beqz	s2,80002672 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002644:	08848493          	addi	s1,s1,136
    80002648:	02d48863          	beq	s1,a3,80002678 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000264c:	449c                	lw	a5,8(s1)
    8000264e:	fef059e3          	blez	a5,80002640 <iget+0x34>
    80002652:	4098                	lw	a4,0(s1)
    80002654:	ff3716e3          	bne	a4,s3,80002640 <iget+0x34>
    80002658:	40d8                	lw	a4,4(s1)
    8000265a:	ff4713e3          	bne	a4,s4,80002640 <iget+0x34>
      ip->ref++;
    8000265e:	2785                	addiw	a5,a5,1
    80002660:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002662:	00020517          	auipc	a0,0x20
    80002666:	48650513          	addi	a0,a0,1158 # 80022ae8 <itable>
    8000266a:	7ae030ef          	jal	80005e18 <release>
      return ip;
    8000266e:	8926                	mv	s2,s1
    80002670:	a02d                	j	8000269a <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002672:	fbe9                	bnez	a5,80002644 <iget+0x38>
      empty = ip;
    80002674:	8926                	mv	s2,s1
    80002676:	b7f9                	j	80002644 <iget+0x38>
  if(empty == 0)
    80002678:	02090a63          	beqz	s2,800026ac <iget+0xa0>
  ip->dev = dev;
    8000267c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002680:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002684:	4785                	li	a5,1
    80002686:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000268a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000268e:	00020517          	auipc	a0,0x20
    80002692:	45a50513          	addi	a0,a0,1114 # 80022ae8 <itable>
    80002696:	782030ef          	jal	80005e18 <release>
}
    8000269a:	854a                	mv	a0,s2
    8000269c:	70a2                	ld	ra,40(sp)
    8000269e:	7402                	ld	s0,32(sp)
    800026a0:	64e2                	ld	s1,24(sp)
    800026a2:	6942                	ld	s2,16(sp)
    800026a4:	69a2                	ld	s3,8(sp)
    800026a6:	6a02                	ld	s4,0(sp)
    800026a8:	6145                	addi	sp,sp,48
    800026aa:	8082                	ret
    panic("iget: no inodes");
    800026ac:	00005517          	auipc	a0,0x5
    800026b0:	e3c50513          	addi	a0,a0,-452 # 800074e8 <etext+0x4e8>
    800026b4:	3a2030ef          	jal	80005a56 <panic>

00000000800026b8 <fsinit>:
fsinit(int dev) {
    800026b8:	7179                	addi	sp,sp,-48
    800026ba:	f406                	sd	ra,40(sp)
    800026bc:	f022                	sd	s0,32(sp)
    800026be:	ec26                	sd	s1,24(sp)
    800026c0:	e84a                	sd	s2,16(sp)
    800026c2:	e44e                	sd	s3,8(sp)
    800026c4:	1800                	addi	s0,sp,48
    800026c6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800026c8:	4585                	li	a1,1
    800026ca:	b11ff0ef          	jal	800021da <bread>
    800026ce:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800026d0:	00020997          	auipc	s3,0x20
    800026d4:	3f898993          	addi	s3,s3,1016 # 80022ac8 <sb>
    800026d8:	02000613          	li	a2,32
    800026dc:	05850593          	addi	a1,a0,88
    800026e0:	854e                	mv	a0,s3
    800026e2:	ad1fd0ef          	jal	800001b2 <memmove>
  brelse(bp);
    800026e6:	8526                	mv	a0,s1
    800026e8:	bfbff0ef          	jal	800022e2 <brelse>
  if(sb.magic != FSMAGIC)
    800026ec:	0009a703          	lw	a4,0(s3)
    800026f0:	102037b7          	lui	a5,0x10203
    800026f4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800026f8:	02f71063          	bne	a4,a5,80002718 <fsinit+0x60>
  initlog(dev, &sb);
    800026fc:	00020597          	auipc	a1,0x20
    80002700:	3cc58593          	addi	a1,a1,972 # 80022ac8 <sb>
    80002704:	854a                	mv	a0,s2
    80002706:	215000ef          	jal	8000311a <initlog>
}
    8000270a:	70a2                	ld	ra,40(sp)
    8000270c:	7402                	ld	s0,32(sp)
    8000270e:	64e2                	ld	s1,24(sp)
    80002710:	6942                	ld	s2,16(sp)
    80002712:	69a2                	ld	s3,8(sp)
    80002714:	6145                	addi	sp,sp,48
    80002716:	8082                	ret
    panic("invalid file system");
    80002718:	00005517          	auipc	a0,0x5
    8000271c:	de050513          	addi	a0,a0,-544 # 800074f8 <etext+0x4f8>
    80002720:	336030ef          	jal	80005a56 <panic>

0000000080002724 <iinit>:
{
    80002724:	7179                	addi	sp,sp,-48
    80002726:	f406                	sd	ra,40(sp)
    80002728:	f022                	sd	s0,32(sp)
    8000272a:	ec26                	sd	s1,24(sp)
    8000272c:	e84a                	sd	s2,16(sp)
    8000272e:	e44e                	sd	s3,8(sp)
    80002730:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002732:	00005597          	auipc	a1,0x5
    80002736:	dde58593          	addi	a1,a1,-546 # 80007510 <etext+0x510>
    8000273a:	00020517          	auipc	a0,0x20
    8000273e:	3ae50513          	addi	a0,a0,942 # 80022ae8 <itable>
    80002742:	5be030ef          	jal	80005d00 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002746:	00020497          	auipc	s1,0x20
    8000274a:	3ca48493          	addi	s1,s1,970 # 80022b10 <itable+0x28>
    8000274e:	00022997          	auipc	s3,0x22
    80002752:	e5298993          	addi	s3,s3,-430 # 800245a0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002756:	00005917          	auipc	s2,0x5
    8000275a:	dc290913          	addi	s2,s2,-574 # 80007518 <etext+0x518>
    8000275e:	85ca                	mv	a1,s2
    80002760:	8526                	mv	a0,s1
    80002762:	497000ef          	jal	800033f8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002766:	08848493          	addi	s1,s1,136
    8000276a:	ff349ae3          	bne	s1,s3,8000275e <iinit+0x3a>
}
    8000276e:	70a2                	ld	ra,40(sp)
    80002770:	7402                	ld	s0,32(sp)
    80002772:	64e2                	ld	s1,24(sp)
    80002774:	6942                	ld	s2,16(sp)
    80002776:	69a2                	ld	s3,8(sp)
    80002778:	6145                	addi	sp,sp,48
    8000277a:	8082                	ret

000000008000277c <ialloc>:
{
    8000277c:	7139                	addi	sp,sp,-64
    8000277e:	fc06                	sd	ra,56(sp)
    80002780:	f822                	sd	s0,48(sp)
    80002782:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002784:	00020717          	auipc	a4,0x20
    80002788:	35072703          	lw	a4,848(a4) # 80022ad4 <sb+0xc>
    8000278c:	4785                	li	a5,1
    8000278e:	06e7f063          	bgeu	a5,a4,800027ee <ialloc+0x72>
    80002792:	f426                	sd	s1,40(sp)
    80002794:	f04a                	sd	s2,32(sp)
    80002796:	ec4e                	sd	s3,24(sp)
    80002798:	e852                	sd	s4,16(sp)
    8000279a:	e456                	sd	s5,8(sp)
    8000279c:	e05a                	sd	s6,0(sp)
    8000279e:	8aaa                	mv	s5,a0
    800027a0:	8b2e                	mv	s6,a1
    800027a2:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800027a4:	00020a17          	auipc	s4,0x20
    800027a8:	324a0a13          	addi	s4,s4,804 # 80022ac8 <sb>
    800027ac:	00495593          	srli	a1,s2,0x4
    800027b0:	018a2783          	lw	a5,24(s4)
    800027b4:	9dbd                	addw	a1,a1,a5
    800027b6:	8556                	mv	a0,s5
    800027b8:	a23ff0ef          	jal	800021da <bread>
    800027bc:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800027be:	05850993          	addi	s3,a0,88
    800027c2:	00f97793          	andi	a5,s2,15
    800027c6:	079a                	slli	a5,a5,0x6
    800027c8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800027ca:	00099783          	lh	a5,0(s3)
    800027ce:	cb9d                	beqz	a5,80002804 <ialloc+0x88>
    brelse(bp);
    800027d0:	b13ff0ef          	jal	800022e2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800027d4:	0905                	addi	s2,s2,1
    800027d6:	00ca2703          	lw	a4,12(s4)
    800027da:	0009079b          	sext.w	a5,s2
    800027de:	fce7e7e3          	bltu	a5,a4,800027ac <ialloc+0x30>
    800027e2:	74a2                	ld	s1,40(sp)
    800027e4:	7902                	ld	s2,32(sp)
    800027e6:	69e2                	ld	s3,24(sp)
    800027e8:	6a42                	ld	s4,16(sp)
    800027ea:	6aa2                	ld	s5,8(sp)
    800027ec:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800027ee:	00005517          	auipc	a0,0x5
    800027f2:	d3250513          	addi	a0,a0,-718 # 80007520 <etext+0x520>
    800027f6:	791020ef          	jal	80005786 <printf>
  return 0;
    800027fa:	4501                	li	a0,0
}
    800027fc:	70e2                	ld	ra,56(sp)
    800027fe:	7442                	ld	s0,48(sp)
    80002800:	6121                	addi	sp,sp,64
    80002802:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002804:	04000613          	li	a2,64
    80002808:	4581                	li	a1,0
    8000280a:	854e                	mv	a0,s3
    8000280c:	943fd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002810:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002814:	8526                	mv	a0,s1
    80002816:	313000ef          	jal	80003328 <log_write>
      brelse(bp);
    8000281a:	8526                	mv	a0,s1
    8000281c:	ac7ff0ef          	jal	800022e2 <brelse>
      return iget(dev, inum);
    80002820:	0009059b          	sext.w	a1,s2
    80002824:	8556                	mv	a0,s5
    80002826:	de7ff0ef          	jal	8000260c <iget>
    8000282a:	74a2                	ld	s1,40(sp)
    8000282c:	7902                	ld	s2,32(sp)
    8000282e:	69e2                	ld	s3,24(sp)
    80002830:	6a42                	ld	s4,16(sp)
    80002832:	6aa2                	ld	s5,8(sp)
    80002834:	6b02                	ld	s6,0(sp)
    80002836:	b7d9                	j	800027fc <ialloc+0x80>

0000000080002838 <iupdate>:
{
    80002838:	1101                	addi	sp,sp,-32
    8000283a:	ec06                	sd	ra,24(sp)
    8000283c:	e822                	sd	s0,16(sp)
    8000283e:	e426                	sd	s1,8(sp)
    80002840:	e04a                	sd	s2,0(sp)
    80002842:	1000                	addi	s0,sp,32
    80002844:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002846:	415c                	lw	a5,4(a0)
    80002848:	0047d79b          	srliw	a5,a5,0x4
    8000284c:	00020597          	auipc	a1,0x20
    80002850:	2945a583          	lw	a1,660(a1) # 80022ae0 <sb+0x18>
    80002854:	9dbd                	addw	a1,a1,a5
    80002856:	4108                	lw	a0,0(a0)
    80002858:	983ff0ef          	jal	800021da <bread>
    8000285c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000285e:	05850793          	addi	a5,a0,88
    80002862:	40d8                	lw	a4,4(s1)
    80002864:	8b3d                	andi	a4,a4,15
    80002866:	071a                	slli	a4,a4,0x6
    80002868:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000286a:	04449703          	lh	a4,68(s1)
    8000286e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002872:	04649703          	lh	a4,70(s1)
    80002876:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000287a:	04849703          	lh	a4,72(s1)
    8000287e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002882:	04a49703          	lh	a4,74(s1)
    80002886:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000288a:	44f8                	lw	a4,76(s1)
    8000288c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000288e:	03400613          	li	a2,52
    80002892:	05048593          	addi	a1,s1,80
    80002896:	00c78513          	addi	a0,a5,12
    8000289a:	919fd0ef          	jal	800001b2 <memmove>
  log_write(bp);
    8000289e:	854a                	mv	a0,s2
    800028a0:	289000ef          	jal	80003328 <log_write>
  brelse(bp);
    800028a4:	854a                	mv	a0,s2
    800028a6:	a3dff0ef          	jal	800022e2 <brelse>
}
    800028aa:	60e2                	ld	ra,24(sp)
    800028ac:	6442                	ld	s0,16(sp)
    800028ae:	64a2                	ld	s1,8(sp)
    800028b0:	6902                	ld	s2,0(sp)
    800028b2:	6105                	addi	sp,sp,32
    800028b4:	8082                	ret

00000000800028b6 <idup>:
{
    800028b6:	1101                	addi	sp,sp,-32
    800028b8:	ec06                	sd	ra,24(sp)
    800028ba:	e822                	sd	s0,16(sp)
    800028bc:	e426                	sd	s1,8(sp)
    800028be:	1000                	addi	s0,sp,32
    800028c0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028c2:	00020517          	auipc	a0,0x20
    800028c6:	22650513          	addi	a0,a0,550 # 80022ae8 <itable>
    800028ca:	4ba030ef          	jal	80005d84 <acquire>
  ip->ref++;
    800028ce:	449c                	lw	a5,8(s1)
    800028d0:	2785                	addiw	a5,a5,1
    800028d2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800028d4:	00020517          	auipc	a0,0x20
    800028d8:	21450513          	addi	a0,a0,532 # 80022ae8 <itable>
    800028dc:	53c030ef          	jal	80005e18 <release>
}
    800028e0:	8526                	mv	a0,s1
    800028e2:	60e2                	ld	ra,24(sp)
    800028e4:	6442                	ld	s0,16(sp)
    800028e6:	64a2                	ld	s1,8(sp)
    800028e8:	6105                	addi	sp,sp,32
    800028ea:	8082                	ret

00000000800028ec <ilock>:
{
    800028ec:	1101                	addi	sp,sp,-32
    800028ee:	ec06                	sd	ra,24(sp)
    800028f0:	e822                	sd	s0,16(sp)
    800028f2:	e426                	sd	s1,8(sp)
    800028f4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800028f6:	cd19                	beqz	a0,80002914 <ilock+0x28>
    800028f8:	84aa                	mv	s1,a0
    800028fa:	451c                	lw	a5,8(a0)
    800028fc:	00f05c63          	blez	a5,80002914 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002900:	0541                	addi	a0,a0,16
    80002902:	32d000ef          	jal	8000342e <acquiresleep>
  if(ip->valid == 0){
    80002906:	40bc                	lw	a5,64(s1)
    80002908:	cf89                	beqz	a5,80002922 <ilock+0x36>
}
    8000290a:	60e2                	ld	ra,24(sp)
    8000290c:	6442                	ld	s0,16(sp)
    8000290e:	64a2                	ld	s1,8(sp)
    80002910:	6105                	addi	sp,sp,32
    80002912:	8082                	ret
    80002914:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002916:	00005517          	auipc	a0,0x5
    8000291a:	c2250513          	addi	a0,a0,-990 # 80007538 <etext+0x538>
    8000291e:	138030ef          	jal	80005a56 <panic>
    80002922:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002924:	40dc                	lw	a5,4(s1)
    80002926:	0047d79b          	srliw	a5,a5,0x4
    8000292a:	00020597          	auipc	a1,0x20
    8000292e:	1b65a583          	lw	a1,438(a1) # 80022ae0 <sb+0x18>
    80002932:	9dbd                	addw	a1,a1,a5
    80002934:	4088                	lw	a0,0(s1)
    80002936:	8a5ff0ef          	jal	800021da <bread>
    8000293a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000293c:	05850593          	addi	a1,a0,88
    80002940:	40dc                	lw	a5,4(s1)
    80002942:	8bbd                	andi	a5,a5,15
    80002944:	079a                	slli	a5,a5,0x6
    80002946:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002948:	00059783          	lh	a5,0(a1)
    8000294c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002950:	00259783          	lh	a5,2(a1)
    80002954:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002958:	00459783          	lh	a5,4(a1)
    8000295c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002960:	00659783          	lh	a5,6(a1)
    80002964:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002968:	459c                	lw	a5,8(a1)
    8000296a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000296c:	03400613          	li	a2,52
    80002970:	05b1                	addi	a1,a1,12
    80002972:	05048513          	addi	a0,s1,80
    80002976:	83dfd0ef          	jal	800001b2 <memmove>
    brelse(bp);
    8000297a:	854a                	mv	a0,s2
    8000297c:	967ff0ef          	jal	800022e2 <brelse>
    ip->valid = 1;
    80002980:	4785                	li	a5,1
    80002982:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002984:	04449783          	lh	a5,68(s1)
    80002988:	c399                	beqz	a5,8000298e <ilock+0xa2>
    8000298a:	6902                	ld	s2,0(sp)
    8000298c:	bfbd                	j	8000290a <ilock+0x1e>
      panic("ilock: no type");
    8000298e:	00005517          	auipc	a0,0x5
    80002992:	bb250513          	addi	a0,a0,-1102 # 80007540 <etext+0x540>
    80002996:	0c0030ef          	jal	80005a56 <panic>

000000008000299a <iunlock>:
{
    8000299a:	1101                	addi	sp,sp,-32
    8000299c:	ec06                	sd	ra,24(sp)
    8000299e:	e822                	sd	s0,16(sp)
    800029a0:	e426                	sd	s1,8(sp)
    800029a2:	e04a                	sd	s2,0(sp)
    800029a4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800029a6:	c505                	beqz	a0,800029ce <iunlock+0x34>
    800029a8:	84aa                	mv	s1,a0
    800029aa:	01050913          	addi	s2,a0,16
    800029ae:	854a                	mv	a0,s2
    800029b0:	2fd000ef          	jal	800034ac <holdingsleep>
    800029b4:	cd09                	beqz	a0,800029ce <iunlock+0x34>
    800029b6:	449c                	lw	a5,8(s1)
    800029b8:	00f05b63          	blez	a5,800029ce <iunlock+0x34>
  releasesleep(&ip->lock);
    800029bc:	854a                	mv	a0,s2
    800029be:	2b7000ef          	jal	80003474 <releasesleep>
}
    800029c2:	60e2                	ld	ra,24(sp)
    800029c4:	6442                	ld	s0,16(sp)
    800029c6:	64a2                	ld	s1,8(sp)
    800029c8:	6902                	ld	s2,0(sp)
    800029ca:	6105                	addi	sp,sp,32
    800029cc:	8082                	ret
    panic("iunlock");
    800029ce:	00005517          	auipc	a0,0x5
    800029d2:	b8250513          	addi	a0,a0,-1150 # 80007550 <etext+0x550>
    800029d6:	080030ef          	jal	80005a56 <panic>

00000000800029da <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800029da:	7179                	addi	sp,sp,-48
    800029dc:	f406                	sd	ra,40(sp)
    800029de:	f022                	sd	s0,32(sp)
    800029e0:	ec26                	sd	s1,24(sp)
    800029e2:	e84a                	sd	s2,16(sp)
    800029e4:	e44e                	sd	s3,8(sp)
    800029e6:	1800                	addi	s0,sp,48
    800029e8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800029ea:	05050493          	addi	s1,a0,80
    800029ee:	08050913          	addi	s2,a0,128
    800029f2:	a021                	j	800029fa <itrunc+0x20>
    800029f4:	0491                	addi	s1,s1,4
    800029f6:	01248b63          	beq	s1,s2,80002a0c <itrunc+0x32>
    if(ip->addrs[i]){
    800029fa:	408c                	lw	a1,0(s1)
    800029fc:	dde5                	beqz	a1,800029f4 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800029fe:	0009a503          	lw	a0,0(s3)
    80002a02:	9cdff0ef          	jal	800023ce <bfree>
      ip->addrs[i] = 0;
    80002a06:	0004a023          	sw	zero,0(s1)
    80002a0a:	b7ed                	j	800029f4 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002a0c:	0809a583          	lw	a1,128(s3)
    80002a10:	ed89                	bnez	a1,80002a2a <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002a12:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002a16:	854e                	mv	a0,s3
    80002a18:	e21ff0ef          	jal	80002838 <iupdate>
}
    80002a1c:	70a2                	ld	ra,40(sp)
    80002a1e:	7402                	ld	s0,32(sp)
    80002a20:	64e2                	ld	s1,24(sp)
    80002a22:	6942                	ld	s2,16(sp)
    80002a24:	69a2                	ld	s3,8(sp)
    80002a26:	6145                	addi	sp,sp,48
    80002a28:	8082                	ret
    80002a2a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002a2c:	0009a503          	lw	a0,0(s3)
    80002a30:	faaff0ef          	jal	800021da <bread>
    80002a34:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002a36:	05850493          	addi	s1,a0,88
    80002a3a:	45850913          	addi	s2,a0,1112
    80002a3e:	a021                	j	80002a46 <itrunc+0x6c>
    80002a40:	0491                	addi	s1,s1,4
    80002a42:	01248963          	beq	s1,s2,80002a54 <itrunc+0x7a>
      if(a[j])
    80002a46:	408c                	lw	a1,0(s1)
    80002a48:	dde5                	beqz	a1,80002a40 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002a4a:	0009a503          	lw	a0,0(s3)
    80002a4e:	981ff0ef          	jal	800023ce <bfree>
    80002a52:	b7fd                	j	80002a40 <itrunc+0x66>
    brelse(bp);
    80002a54:	8552                	mv	a0,s4
    80002a56:	88dff0ef          	jal	800022e2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002a5a:	0809a583          	lw	a1,128(s3)
    80002a5e:	0009a503          	lw	a0,0(s3)
    80002a62:	96dff0ef          	jal	800023ce <bfree>
    ip->addrs[NDIRECT] = 0;
    80002a66:	0809a023          	sw	zero,128(s3)
    80002a6a:	6a02                	ld	s4,0(sp)
    80002a6c:	b75d                	j	80002a12 <itrunc+0x38>

0000000080002a6e <iput>:
{
    80002a6e:	1101                	addi	sp,sp,-32
    80002a70:	ec06                	sd	ra,24(sp)
    80002a72:	e822                	sd	s0,16(sp)
    80002a74:	e426                	sd	s1,8(sp)
    80002a76:	1000                	addi	s0,sp,32
    80002a78:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a7a:	00020517          	auipc	a0,0x20
    80002a7e:	06e50513          	addi	a0,a0,110 # 80022ae8 <itable>
    80002a82:	302030ef          	jal	80005d84 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002a86:	4498                	lw	a4,8(s1)
    80002a88:	4785                	li	a5,1
    80002a8a:	02f70063          	beq	a4,a5,80002aaa <iput+0x3c>
  ip->ref--;
    80002a8e:	449c                	lw	a5,8(s1)
    80002a90:	37fd                	addiw	a5,a5,-1
    80002a92:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a94:	00020517          	auipc	a0,0x20
    80002a98:	05450513          	addi	a0,a0,84 # 80022ae8 <itable>
    80002a9c:	37c030ef          	jal	80005e18 <release>
}
    80002aa0:	60e2                	ld	ra,24(sp)
    80002aa2:	6442                	ld	s0,16(sp)
    80002aa4:	64a2                	ld	s1,8(sp)
    80002aa6:	6105                	addi	sp,sp,32
    80002aa8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002aaa:	40bc                	lw	a5,64(s1)
    80002aac:	d3ed                	beqz	a5,80002a8e <iput+0x20>
    80002aae:	04a49783          	lh	a5,74(s1)
    80002ab2:	fff1                	bnez	a5,80002a8e <iput+0x20>
    80002ab4:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002ab6:	01048913          	addi	s2,s1,16
    80002aba:	854a                	mv	a0,s2
    80002abc:	173000ef          	jal	8000342e <acquiresleep>
    release(&itable.lock);
    80002ac0:	00020517          	auipc	a0,0x20
    80002ac4:	02850513          	addi	a0,a0,40 # 80022ae8 <itable>
    80002ac8:	350030ef          	jal	80005e18 <release>
    itrunc(ip);
    80002acc:	8526                	mv	a0,s1
    80002ace:	f0dff0ef          	jal	800029da <itrunc>
    ip->type = 0;
    80002ad2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ad6:	8526                	mv	a0,s1
    80002ad8:	d61ff0ef          	jal	80002838 <iupdate>
    ip->valid = 0;
    80002adc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ae0:	854a                	mv	a0,s2
    80002ae2:	193000ef          	jal	80003474 <releasesleep>
    acquire(&itable.lock);
    80002ae6:	00020517          	auipc	a0,0x20
    80002aea:	00250513          	addi	a0,a0,2 # 80022ae8 <itable>
    80002aee:	296030ef          	jal	80005d84 <acquire>
    80002af2:	6902                	ld	s2,0(sp)
    80002af4:	bf69                	j	80002a8e <iput+0x20>

0000000080002af6 <iunlockput>:
{
    80002af6:	1101                	addi	sp,sp,-32
    80002af8:	ec06                	sd	ra,24(sp)
    80002afa:	e822                	sd	s0,16(sp)
    80002afc:	e426                	sd	s1,8(sp)
    80002afe:	1000                	addi	s0,sp,32
    80002b00:	84aa                	mv	s1,a0
  iunlock(ip);
    80002b02:	e99ff0ef          	jal	8000299a <iunlock>
  iput(ip);
    80002b06:	8526                	mv	a0,s1
    80002b08:	f67ff0ef          	jal	80002a6e <iput>
}
    80002b0c:	60e2                	ld	ra,24(sp)
    80002b0e:	6442                	ld	s0,16(sp)
    80002b10:	64a2                	ld	s1,8(sp)
    80002b12:	6105                	addi	sp,sp,32
    80002b14:	8082                	ret

0000000080002b16 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002b16:	1141                	addi	sp,sp,-16
    80002b18:	e406                	sd	ra,8(sp)
    80002b1a:	e022                	sd	s0,0(sp)
    80002b1c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002b1e:	411c                	lw	a5,0(a0)
    80002b20:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002b22:	415c                	lw	a5,4(a0)
    80002b24:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002b26:	04451783          	lh	a5,68(a0)
    80002b2a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002b2e:	04a51783          	lh	a5,74(a0)
    80002b32:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002b36:	04c56783          	lwu	a5,76(a0)
    80002b3a:	e99c                	sd	a5,16(a1)
}
    80002b3c:	60a2                	ld	ra,8(sp)
    80002b3e:	6402                	ld	s0,0(sp)
    80002b40:	0141                	addi	sp,sp,16
    80002b42:	8082                	ret

0000000080002b44 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b44:	457c                	lw	a5,76(a0)
    80002b46:	0ed7e663          	bltu	a5,a3,80002c32 <readi+0xee>
{
    80002b4a:	7159                	addi	sp,sp,-112
    80002b4c:	f486                	sd	ra,104(sp)
    80002b4e:	f0a2                	sd	s0,96(sp)
    80002b50:	eca6                	sd	s1,88(sp)
    80002b52:	e0d2                	sd	s4,64(sp)
    80002b54:	fc56                	sd	s5,56(sp)
    80002b56:	f85a                	sd	s6,48(sp)
    80002b58:	f45e                	sd	s7,40(sp)
    80002b5a:	1880                	addi	s0,sp,112
    80002b5c:	8b2a                	mv	s6,a0
    80002b5e:	8bae                	mv	s7,a1
    80002b60:	8a32                	mv	s4,a2
    80002b62:	84b6                	mv	s1,a3
    80002b64:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002b66:	9f35                	addw	a4,a4,a3
    return 0;
    80002b68:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002b6a:	0ad76b63          	bltu	a4,a3,80002c20 <readi+0xdc>
    80002b6e:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002b70:	00e7f463          	bgeu	a5,a4,80002b78 <readi+0x34>
    n = ip->size - off;
    80002b74:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b78:	080a8b63          	beqz	s5,80002c0e <readi+0xca>
    80002b7c:	e8ca                	sd	s2,80(sp)
    80002b7e:	f062                	sd	s8,32(sp)
    80002b80:	ec66                	sd	s9,24(sp)
    80002b82:	e86a                	sd	s10,16(sp)
    80002b84:	e46e                	sd	s11,8(sp)
    80002b86:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b88:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002b8c:	5c7d                	li	s8,-1
    80002b8e:	a80d                	j	80002bc0 <readi+0x7c>
    80002b90:	020d1d93          	slli	s11,s10,0x20
    80002b94:	020ddd93          	srli	s11,s11,0x20
    80002b98:	05890613          	addi	a2,s2,88
    80002b9c:	86ee                	mv	a3,s11
    80002b9e:	963e                	add	a2,a2,a5
    80002ba0:	85d2                	mv	a1,s4
    80002ba2:	855e                	mv	a0,s7
    80002ba4:	c15fe0ef          	jal	800017b8 <either_copyout>
    80002ba8:	05850363          	beq	a0,s8,80002bee <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002bac:	854a                	mv	a0,s2
    80002bae:	f34ff0ef          	jal	800022e2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002bb2:	013d09bb          	addw	s3,s10,s3
    80002bb6:	009d04bb          	addw	s1,s10,s1
    80002bba:	9a6e                	add	s4,s4,s11
    80002bbc:	0559f363          	bgeu	s3,s5,80002c02 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002bc0:	00a4d59b          	srliw	a1,s1,0xa
    80002bc4:	855a                	mv	a0,s6
    80002bc6:	987ff0ef          	jal	8000254c <bmap>
    80002bca:	85aa                	mv	a1,a0
    if(addr == 0)
    80002bcc:	c139                	beqz	a0,80002c12 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002bce:	000b2503          	lw	a0,0(s6)
    80002bd2:	e08ff0ef          	jal	800021da <bread>
    80002bd6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bd8:	3ff4f793          	andi	a5,s1,1023
    80002bdc:	40fc873b          	subw	a4,s9,a5
    80002be0:	413a86bb          	subw	a3,s5,s3
    80002be4:	8d3a                	mv	s10,a4
    80002be6:	fae6f5e3          	bgeu	a3,a4,80002b90 <readi+0x4c>
    80002bea:	8d36                	mv	s10,a3
    80002bec:	b755                	j	80002b90 <readi+0x4c>
      brelse(bp);
    80002bee:	854a                	mv	a0,s2
    80002bf0:	ef2ff0ef          	jal	800022e2 <brelse>
      tot = -1;
    80002bf4:	59fd                	li	s3,-1
      break;
    80002bf6:	6946                	ld	s2,80(sp)
    80002bf8:	7c02                	ld	s8,32(sp)
    80002bfa:	6ce2                	ld	s9,24(sp)
    80002bfc:	6d42                	ld	s10,16(sp)
    80002bfe:	6da2                	ld	s11,8(sp)
    80002c00:	a831                	j	80002c1c <readi+0xd8>
    80002c02:	6946                	ld	s2,80(sp)
    80002c04:	7c02                	ld	s8,32(sp)
    80002c06:	6ce2                	ld	s9,24(sp)
    80002c08:	6d42                	ld	s10,16(sp)
    80002c0a:	6da2                	ld	s11,8(sp)
    80002c0c:	a801                	j	80002c1c <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002c0e:	89d6                	mv	s3,s5
    80002c10:	a031                	j	80002c1c <readi+0xd8>
    80002c12:	6946                	ld	s2,80(sp)
    80002c14:	7c02                	ld	s8,32(sp)
    80002c16:	6ce2                	ld	s9,24(sp)
    80002c18:	6d42                	ld	s10,16(sp)
    80002c1a:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002c1c:	854e                	mv	a0,s3
    80002c1e:	69a6                	ld	s3,72(sp)
}
    80002c20:	70a6                	ld	ra,104(sp)
    80002c22:	7406                	ld	s0,96(sp)
    80002c24:	64e6                	ld	s1,88(sp)
    80002c26:	6a06                	ld	s4,64(sp)
    80002c28:	7ae2                	ld	s5,56(sp)
    80002c2a:	7b42                	ld	s6,48(sp)
    80002c2c:	7ba2                	ld	s7,40(sp)
    80002c2e:	6165                	addi	sp,sp,112
    80002c30:	8082                	ret
    return 0;
    80002c32:	4501                	li	a0,0
}
    80002c34:	8082                	ret

0000000080002c36 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002c36:	457c                	lw	a5,76(a0)
    80002c38:	0ed7eb63          	bltu	a5,a3,80002d2e <writei+0xf8>
{
    80002c3c:	7159                	addi	sp,sp,-112
    80002c3e:	f486                	sd	ra,104(sp)
    80002c40:	f0a2                	sd	s0,96(sp)
    80002c42:	e8ca                	sd	s2,80(sp)
    80002c44:	e0d2                	sd	s4,64(sp)
    80002c46:	fc56                	sd	s5,56(sp)
    80002c48:	f85a                	sd	s6,48(sp)
    80002c4a:	f45e                	sd	s7,40(sp)
    80002c4c:	1880                	addi	s0,sp,112
    80002c4e:	8aaa                	mv	s5,a0
    80002c50:	8bae                	mv	s7,a1
    80002c52:	8a32                	mv	s4,a2
    80002c54:	8936                	mv	s2,a3
    80002c56:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002c58:	00e687bb          	addw	a5,a3,a4
    80002c5c:	0cd7eb63          	bltu	a5,a3,80002d32 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002c60:	00043737          	lui	a4,0x43
    80002c64:	0cf76963          	bltu	a4,a5,80002d36 <writei+0x100>
    80002c68:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c6a:	0a0b0a63          	beqz	s6,80002d1e <writei+0xe8>
    80002c6e:	eca6                	sd	s1,88(sp)
    80002c70:	f062                	sd	s8,32(sp)
    80002c72:	ec66                	sd	s9,24(sp)
    80002c74:	e86a                	sd	s10,16(sp)
    80002c76:	e46e                	sd	s11,8(sp)
    80002c78:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c7a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002c7e:	5c7d                	li	s8,-1
    80002c80:	a825                	j	80002cb8 <writei+0x82>
    80002c82:	020d1d93          	slli	s11,s10,0x20
    80002c86:	020ddd93          	srli	s11,s11,0x20
    80002c8a:	05848513          	addi	a0,s1,88
    80002c8e:	86ee                	mv	a3,s11
    80002c90:	8652                	mv	a2,s4
    80002c92:	85de                	mv	a1,s7
    80002c94:	953e                	add	a0,a0,a5
    80002c96:	b6dfe0ef          	jal	80001802 <either_copyin>
    80002c9a:	05850663          	beq	a0,s8,80002ce6 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002c9e:	8526                	mv	a0,s1
    80002ca0:	688000ef          	jal	80003328 <log_write>
    brelse(bp);
    80002ca4:	8526                	mv	a0,s1
    80002ca6:	e3cff0ef          	jal	800022e2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002caa:	013d09bb          	addw	s3,s10,s3
    80002cae:	012d093b          	addw	s2,s10,s2
    80002cb2:	9a6e                	add	s4,s4,s11
    80002cb4:	0369fc63          	bgeu	s3,s6,80002cec <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002cb8:	00a9559b          	srliw	a1,s2,0xa
    80002cbc:	8556                	mv	a0,s5
    80002cbe:	88fff0ef          	jal	8000254c <bmap>
    80002cc2:	85aa                	mv	a1,a0
    if(addr == 0)
    80002cc4:	c505                	beqz	a0,80002cec <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002cc6:	000aa503          	lw	a0,0(s5) # fffffffffffff000 <end+0xffffffff7ffd1730>
    80002cca:	d10ff0ef          	jal	800021da <bread>
    80002cce:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002cd0:	3ff97793          	andi	a5,s2,1023
    80002cd4:	40fc873b          	subw	a4,s9,a5
    80002cd8:	413b06bb          	subw	a3,s6,s3
    80002cdc:	8d3a                	mv	s10,a4
    80002cde:	fae6f2e3          	bgeu	a3,a4,80002c82 <writei+0x4c>
    80002ce2:	8d36                	mv	s10,a3
    80002ce4:	bf79                	j	80002c82 <writei+0x4c>
      brelse(bp);
    80002ce6:	8526                	mv	a0,s1
    80002ce8:	dfaff0ef          	jal	800022e2 <brelse>
  }

  if(off > ip->size)
    80002cec:	04caa783          	lw	a5,76(s5)
    80002cf0:	0327f963          	bgeu	a5,s2,80002d22 <writei+0xec>
    ip->size = off;
    80002cf4:	052aa623          	sw	s2,76(s5)
    80002cf8:	64e6                	ld	s1,88(sp)
    80002cfa:	7c02                	ld	s8,32(sp)
    80002cfc:	6ce2                	ld	s9,24(sp)
    80002cfe:	6d42                	ld	s10,16(sp)
    80002d00:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002d02:	8556                	mv	a0,s5
    80002d04:	b35ff0ef          	jal	80002838 <iupdate>

  return tot;
    80002d08:	854e                	mv	a0,s3
    80002d0a:	69a6                	ld	s3,72(sp)
}
    80002d0c:	70a6                	ld	ra,104(sp)
    80002d0e:	7406                	ld	s0,96(sp)
    80002d10:	6946                	ld	s2,80(sp)
    80002d12:	6a06                	ld	s4,64(sp)
    80002d14:	7ae2                	ld	s5,56(sp)
    80002d16:	7b42                	ld	s6,48(sp)
    80002d18:	7ba2                	ld	s7,40(sp)
    80002d1a:	6165                	addi	sp,sp,112
    80002d1c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002d1e:	89da                	mv	s3,s6
    80002d20:	b7cd                	j	80002d02 <writei+0xcc>
    80002d22:	64e6                	ld	s1,88(sp)
    80002d24:	7c02                	ld	s8,32(sp)
    80002d26:	6ce2                	ld	s9,24(sp)
    80002d28:	6d42                	ld	s10,16(sp)
    80002d2a:	6da2                	ld	s11,8(sp)
    80002d2c:	bfd9                	j	80002d02 <writei+0xcc>
    return -1;
    80002d2e:	557d                	li	a0,-1
}
    80002d30:	8082                	ret
    return -1;
    80002d32:	557d                	li	a0,-1
    80002d34:	bfe1                	j	80002d0c <writei+0xd6>
    return -1;
    80002d36:	557d                	li	a0,-1
    80002d38:	bfd1                	j	80002d0c <writei+0xd6>

0000000080002d3a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002d3a:	1141                	addi	sp,sp,-16
    80002d3c:	e406                	sd	ra,8(sp)
    80002d3e:	e022                	sd	s0,0(sp)
    80002d40:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002d42:	4639                	li	a2,14
    80002d44:	ce2fd0ef          	jal	80000226 <strncmp>
}
    80002d48:	60a2                	ld	ra,8(sp)
    80002d4a:	6402                	ld	s0,0(sp)
    80002d4c:	0141                	addi	sp,sp,16
    80002d4e:	8082                	ret

0000000080002d50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002d50:	711d                	addi	sp,sp,-96
    80002d52:	ec86                	sd	ra,88(sp)
    80002d54:	e8a2                	sd	s0,80(sp)
    80002d56:	e4a6                	sd	s1,72(sp)
    80002d58:	e0ca                	sd	s2,64(sp)
    80002d5a:	fc4e                	sd	s3,56(sp)
    80002d5c:	f852                	sd	s4,48(sp)
    80002d5e:	f456                	sd	s5,40(sp)
    80002d60:	f05a                	sd	s6,32(sp)
    80002d62:	ec5e                	sd	s7,24(sp)
    80002d64:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002d66:	04451703          	lh	a4,68(a0)
    80002d6a:	4785                	li	a5,1
    80002d6c:	00f71f63          	bne	a4,a5,80002d8a <dirlookup+0x3a>
    80002d70:	892a                	mv	s2,a0
    80002d72:	8aae                	mv	s5,a1
    80002d74:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d76:	457c                	lw	a5,76(a0)
    80002d78:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d7a:	fa040a13          	addi	s4,s0,-96
    80002d7e:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002d80:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002d84:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d86:	e39d                	bnez	a5,80002dac <dirlookup+0x5c>
    80002d88:	a8b9                	j	80002de6 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002d8a:	00004517          	auipc	a0,0x4
    80002d8e:	7ce50513          	addi	a0,a0,1998 # 80007558 <etext+0x558>
    80002d92:	4c5020ef          	jal	80005a56 <panic>
      panic("dirlookup read");
    80002d96:	00004517          	auipc	a0,0x4
    80002d9a:	7da50513          	addi	a0,a0,2010 # 80007570 <etext+0x570>
    80002d9e:	4b9020ef          	jal	80005a56 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002da2:	24c1                	addiw	s1,s1,16
    80002da4:	04c92783          	lw	a5,76(s2)
    80002da8:	02f4fe63          	bgeu	s1,a5,80002de4 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002dac:	874e                	mv	a4,s3
    80002dae:	86a6                	mv	a3,s1
    80002db0:	8652                	mv	a2,s4
    80002db2:	4581                	li	a1,0
    80002db4:	854a                	mv	a0,s2
    80002db6:	d8fff0ef          	jal	80002b44 <readi>
    80002dba:	fd351ee3          	bne	a0,s3,80002d96 <dirlookup+0x46>
    if(de.inum == 0)
    80002dbe:	fa045783          	lhu	a5,-96(s0)
    80002dc2:	d3e5                	beqz	a5,80002da2 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002dc4:	85da                	mv	a1,s6
    80002dc6:	8556                	mv	a0,s5
    80002dc8:	f73ff0ef          	jal	80002d3a <namecmp>
    80002dcc:	f979                	bnez	a0,80002da2 <dirlookup+0x52>
      if(poff)
    80002dce:	000b8463          	beqz	s7,80002dd6 <dirlookup+0x86>
        *poff = off;
    80002dd2:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002dd6:	fa045583          	lhu	a1,-96(s0)
    80002dda:	00092503          	lw	a0,0(s2)
    80002dde:	82fff0ef          	jal	8000260c <iget>
    80002de2:	a011                	j	80002de6 <dirlookup+0x96>
  return 0;
    80002de4:	4501                	li	a0,0
}
    80002de6:	60e6                	ld	ra,88(sp)
    80002de8:	6446                	ld	s0,80(sp)
    80002dea:	64a6                	ld	s1,72(sp)
    80002dec:	6906                	ld	s2,64(sp)
    80002dee:	79e2                	ld	s3,56(sp)
    80002df0:	7a42                	ld	s4,48(sp)
    80002df2:	7aa2                	ld	s5,40(sp)
    80002df4:	7b02                	ld	s6,32(sp)
    80002df6:	6be2                	ld	s7,24(sp)
    80002df8:	6125                	addi	sp,sp,96
    80002dfa:	8082                	ret

0000000080002dfc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002dfc:	711d                	addi	sp,sp,-96
    80002dfe:	ec86                	sd	ra,88(sp)
    80002e00:	e8a2                	sd	s0,80(sp)
    80002e02:	e4a6                	sd	s1,72(sp)
    80002e04:	e0ca                	sd	s2,64(sp)
    80002e06:	fc4e                	sd	s3,56(sp)
    80002e08:	f852                	sd	s4,48(sp)
    80002e0a:	f456                	sd	s5,40(sp)
    80002e0c:	f05a                	sd	s6,32(sp)
    80002e0e:	ec5e                	sd	s7,24(sp)
    80002e10:	e862                	sd	s8,16(sp)
    80002e12:	e466                	sd	s9,8(sp)
    80002e14:	e06a                	sd	s10,0(sp)
    80002e16:	1080                	addi	s0,sp,96
    80002e18:	84aa                	mv	s1,a0
    80002e1a:	8b2e                	mv	s6,a1
    80002e1c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002e1e:	00054703          	lbu	a4,0(a0)
    80002e22:	02f00793          	li	a5,47
    80002e26:	00f70f63          	beq	a4,a5,80002e44 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002e2a:	fe1fd0ef          	jal	80000e0a <myproc>
    80002e2e:	15053503          	ld	a0,336(a0)
    80002e32:	a85ff0ef          	jal	800028b6 <idup>
    80002e36:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002e38:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002e3c:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002e3e:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002e40:	4b85                	li	s7,1
    80002e42:	a879                	j	80002ee0 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002e44:	4585                	li	a1,1
    80002e46:	852e                	mv	a0,a1
    80002e48:	fc4ff0ef          	jal	8000260c <iget>
    80002e4c:	8a2a                	mv	s4,a0
    80002e4e:	b7ed                	j	80002e38 <namex+0x3c>
      iunlockput(ip);
    80002e50:	8552                	mv	a0,s4
    80002e52:	ca5ff0ef          	jal	80002af6 <iunlockput>
      return 0;
    80002e56:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002e58:	8552                	mv	a0,s4
    80002e5a:	60e6                	ld	ra,88(sp)
    80002e5c:	6446                	ld	s0,80(sp)
    80002e5e:	64a6                	ld	s1,72(sp)
    80002e60:	6906                	ld	s2,64(sp)
    80002e62:	79e2                	ld	s3,56(sp)
    80002e64:	7a42                	ld	s4,48(sp)
    80002e66:	7aa2                	ld	s5,40(sp)
    80002e68:	7b02                	ld	s6,32(sp)
    80002e6a:	6be2                	ld	s7,24(sp)
    80002e6c:	6c42                	ld	s8,16(sp)
    80002e6e:	6ca2                	ld	s9,8(sp)
    80002e70:	6d02                	ld	s10,0(sp)
    80002e72:	6125                	addi	sp,sp,96
    80002e74:	8082                	ret
      iunlock(ip);
    80002e76:	8552                	mv	a0,s4
    80002e78:	b23ff0ef          	jal	8000299a <iunlock>
      return ip;
    80002e7c:	bff1                	j	80002e58 <namex+0x5c>
      iunlockput(ip);
    80002e7e:	8552                	mv	a0,s4
    80002e80:	c77ff0ef          	jal	80002af6 <iunlockput>
      return 0;
    80002e84:	8a4e                	mv	s4,s3
    80002e86:	bfc9                	j	80002e58 <namex+0x5c>
  len = path - s;
    80002e88:	40998633          	sub	a2,s3,s1
    80002e8c:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002e90:	09ac5063          	bge	s8,s10,80002f10 <namex+0x114>
    memmove(name, s, DIRSIZ);
    80002e94:	8666                	mv	a2,s9
    80002e96:	85a6                	mv	a1,s1
    80002e98:	8556                	mv	a0,s5
    80002e9a:	b18fd0ef          	jal	800001b2 <memmove>
    80002e9e:	84ce                	mv	s1,s3
  while(*path == '/')
    80002ea0:	0004c783          	lbu	a5,0(s1)
    80002ea4:	01279763          	bne	a5,s2,80002eb2 <namex+0xb6>
    path++;
    80002ea8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002eaa:	0004c783          	lbu	a5,0(s1)
    80002eae:	ff278de3          	beq	a5,s2,80002ea8 <namex+0xac>
    ilock(ip);
    80002eb2:	8552                	mv	a0,s4
    80002eb4:	a39ff0ef          	jal	800028ec <ilock>
    if(ip->type != T_DIR){
    80002eb8:	044a1783          	lh	a5,68(s4)
    80002ebc:	f9779ae3          	bne	a5,s7,80002e50 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002ec0:	000b0563          	beqz	s6,80002eca <namex+0xce>
    80002ec4:	0004c783          	lbu	a5,0(s1)
    80002ec8:	d7dd                	beqz	a5,80002e76 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002eca:	4601                	li	a2,0
    80002ecc:	85d6                	mv	a1,s5
    80002ece:	8552                	mv	a0,s4
    80002ed0:	e81ff0ef          	jal	80002d50 <dirlookup>
    80002ed4:	89aa                	mv	s3,a0
    80002ed6:	d545                	beqz	a0,80002e7e <namex+0x82>
    iunlockput(ip);
    80002ed8:	8552                	mv	a0,s4
    80002eda:	c1dff0ef          	jal	80002af6 <iunlockput>
    ip = next;
    80002ede:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002ee0:	0004c783          	lbu	a5,0(s1)
    80002ee4:	01279763          	bne	a5,s2,80002ef2 <namex+0xf6>
    path++;
    80002ee8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002eea:	0004c783          	lbu	a5,0(s1)
    80002eee:	ff278de3          	beq	a5,s2,80002ee8 <namex+0xec>
  if(*path == 0)
    80002ef2:	cb8d                	beqz	a5,80002f24 <namex+0x128>
  while(*path != '/' && *path != 0)
    80002ef4:	0004c783          	lbu	a5,0(s1)
    80002ef8:	89a6                	mv	s3,s1
  len = path - s;
    80002efa:	4d01                	li	s10,0
    80002efc:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002efe:	01278963          	beq	a5,s2,80002f10 <namex+0x114>
    80002f02:	d3d9                	beqz	a5,80002e88 <namex+0x8c>
    path++;
    80002f04:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002f06:	0009c783          	lbu	a5,0(s3)
    80002f0a:	ff279ce3          	bne	a5,s2,80002f02 <namex+0x106>
    80002f0e:	bfad                	j	80002e88 <namex+0x8c>
    memmove(name, s, len);
    80002f10:	2601                	sext.w	a2,a2
    80002f12:	85a6                	mv	a1,s1
    80002f14:	8556                	mv	a0,s5
    80002f16:	a9cfd0ef          	jal	800001b2 <memmove>
    name[len] = 0;
    80002f1a:	9d56                	add	s10,s10,s5
    80002f1c:	000d0023          	sb	zero,0(s10)
    80002f20:	84ce                	mv	s1,s3
    80002f22:	bfbd                	j	80002ea0 <namex+0xa4>
  if(nameiparent){
    80002f24:	f20b0ae3          	beqz	s6,80002e58 <namex+0x5c>
    iput(ip);
    80002f28:	8552                	mv	a0,s4
    80002f2a:	b45ff0ef          	jal	80002a6e <iput>
    return 0;
    80002f2e:	4a01                	li	s4,0
    80002f30:	b725                	j	80002e58 <namex+0x5c>

0000000080002f32 <dirlink>:
{
    80002f32:	715d                	addi	sp,sp,-80
    80002f34:	e486                	sd	ra,72(sp)
    80002f36:	e0a2                	sd	s0,64(sp)
    80002f38:	f84a                	sd	s2,48(sp)
    80002f3a:	ec56                	sd	s5,24(sp)
    80002f3c:	e85a                	sd	s6,16(sp)
    80002f3e:	0880                	addi	s0,sp,80
    80002f40:	892a                	mv	s2,a0
    80002f42:	8aae                	mv	s5,a1
    80002f44:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002f46:	4601                	li	a2,0
    80002f48:	e09ff0ef          	jal	80002d50 <dirlookup>
    80002f4c:	ed1d                	bnez	a0,80002f8a <dirlink+0x58>
    80002f4e:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f50:	04c92483          	lw	s1,76(s2)
    80002f54:	c4b9                	beqz	s1,80002fa2 <dirlink+0x70>
    80002f56:	f44e                	sd	s3,40(sp)
    80002f58:	f052                	sd	s4,32(sp)
    80002f5a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f5c:	fb040a13          	addi	s4,s0,-80
    80002f60:	49c1                	li	s3,16
    80002f62:	874e                	mv	a4,s3
    80002f64:	86a6                	mv	a3,s1
    80002f66:	8652                	mv	a2,s4
    80002f68:	4581                	li	a1,0
    80002f6a:	854a                	mv	a0,s2
    80002f6c:	bd9ff0ef          	jal	80002b44 <readi>
    80002f70:	03351163          	bne	a0,s3,80002f92 <dirlink+0x60>
    if(de.inum == 0)
    80002f74:	fb045783          	lhu	a5,-80(s0)
    80002f78:	c39d                	beqz	a5,80002f9e <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f7a:	24c1                	addiw	s1,s1,16
    80002f7c:	04c92783          	lw	a5,76(s2)
    80002f80:	fef4e1e3          	bltu	s1,a5,80002f62 <dirlink+0x30>
    80002f84:	79a2                	ld	s3,40(sp)
    80002f86:	7a02                	ld	s4,32(sp)
    80002f88:	a829                	j	80002fa2 <dirlink+0x70>
    iput(ip);
    80002f8a:	ae5ff0ef          	jal	80002a6e <iput>
    return -1;
    80002f8e:	557d                	li	a0,-1
    80002f90:	a83d                	j	80002fce <dirlink+0x9c>
      panic("dirlink read");
    80002f92:	00004517          	auipc	a0,0x4
    80002f96:	5ee50513          	addi	a0,a0,1518 # 80007580 <etext+0x580>
    80002f9a:	2bd020ef          	jal	80005a56 <panic>
    80002f9e:	79a2                	ld	s3,40(sp)
    80002fa0:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002fa2:	4639                	li	a2,14
    80002fa4:	85d6                	mv	a1,s5
    80002fa6:	fb240513          	addi	a0,s0,-78
    80002faa:	ab6fd0ef          	jal	80000260 <strncpy>
  de.inum = inum;
    80002fae:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002fb2:	4741                	li	a4,16
    80002fb4:	86a6                	mv	a3,s1
    80002fb6:	fb040613          	addi	a2,s0,-80
    80002fba:	4581                	li	a1,0
    80002fbc:	854a                	mv	a0,s2
    80002fbe:	c79ff0ef          	jal	80002c36 <writei>
    80002fc2:	1541                	addi	a0,a0,-16
    80002fc4:	00a03533          	snez	a0,a0
    80002fc8:	40a0053b          	negw	a0,a0
    80002fcc:	74e2                	ld	s1,56(sp)
}
    80002fce:	60a6                	ld	ra,72(sp)
    80002fd0:	6406                	ld	s0,64(sp)
    80002fd2:	7942                	ld	s2,48(sp)
    80002fd4:	6ae2                	ld	s5,24(sp)
    80002fd6:	6b42                	ld	s6,16(sp)
    80002fd8:	6161                	addi	sp,sp,80
    80002fda:	8082                	ret

0000000080002fdc <namei>:

struct inode*
namei(char *path)
{
    80002fdc:	1101                	addi	sp,sp,-32
    80002fde:	ec06                	sd	ra,24(sp)
    80002fe0:	e822                	sd	s0,16(sp)
    80002fe2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002fe4:	fe040613          	addi	a2,s0,-32
    80002fe8:	4581                	li	a1,0
    80002fea:	e13ff0ef          	jal	80002dfc <namex>
}
    80002fee:	60e2                	ld	ra,24(sp)
    80002ff0:	6442                	ld	s0,16(sp)
    80002ff2:	6105                	addi	sp,sp,32
    80002ff4:	8082                	ret

0000000080002ff6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002ff6:	1141                	addi	sp,sp,-16
    80002ff8:	e406                	sd	ra,8(sp)
    80002ffa:	e022                	sd	s0,0(sp)
    80002ffc:	0800                	addi	s0,sp,16
    80002ffe:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003000:	4585                	li	a1,1
    80003002:	dfbff0ef          	jal	80002dfc <namex>
}
    80003006:	60a2                	ld	ra,8(sp)
    80003008:	6402                	ld	s0,0(sp)
    8000300a:	0141                	addi	sp,sp,16
    8000300c:	8082                	ret

000000008000300e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000300e:	1101                	addi	sp,sp,-32
    80003010:	ec06                	sd	ra,24(sp)
    80003012:	e822                	sd	s0,16(sp)
    80003014:	e426                	sd	s1,8(sp)
    80003016:	e04a                	sd	s2,0(sp)
    80003018:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000301a:	00021917          	auipc	s2,0x21
    8000301e:	57690913          	addi	s2,s2,1398 # 80024590 <log>
    80003022:	01892583          	lw	a1,24(s2)
    80003026:	02892503          	lw	a0,40(s2)
    8000302a:	9b0ff0ef          	jal	800021da <bread>
    8000302e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003030:	02c92603          	lw	a2,44(s2)
    80003034:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003036:	00c05f63          	blez	a2,80003054 <write_head+0x46>
    8000303a:	00021717          	auipc	a4,0x21
    8000303e:	58670713          	addi	a4,a4,1414 # 800245c0 <log+0x30>
    80003042:	87aa                	mv	a5,a0
    80003044:	060a                	slli	a2,a2,0x2
    80003046:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003048:	4314                	lw	a3,0(a4)
    8000304a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000304c:	0711                	addi	a4,a4,4
    8000304e:	0791                	addi	a5,a5,4
    80003050:	fec79ce3          	bne	a5,a2,80003048 <write_head+0x3a>
  }
  bwrite(buf);
    80003054:	8526                	mv	a0,s1
    80003056:	a5aff0ef          	jal	800022b0 <bwrite>
  brelse(buf);
    8000305a:	8526                	mv	a0,s1
    8000305c:	a86ff0ef          	jal	800022e2 <brelse>
}
    80003060:	60e2                	ld	ra,24(sp)
    80003062:	6442                	ld	s0,16(sp)
    80003064:	64a2                	ld	s1,8(sp)
    80003066:	6902                	ld	s2,0(sp)
    80003068:	6105                	addi	sp,sp,32
    8000306a:	8082                	ret

000000008000306c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000306c:	00021797          	auipc	a5,0x21
    80003070:	5507a783          	lw	a5,1360(a5) # 800245bc <log+0x2c>
    80003074:	0af05263          	blez	a5,80003118 <install_trans+0xac>
{
    80003078:	715d                	addi	sp,sp,-80
    8000307a:	e486                	sd	ra,72(sp)
    8000307c:	e0a2                	sd	s0,64(sp)
    8000307e:	fc26                	sd	s1,56(sp)
    80003080:	f84a                	sd	s2,48(sp)
    80003082:	f44e                	sd	s3,40(sp)
    80003084:	f052                	sd	s4,32(sp)
    80003086:	ec56                	sd	s5,24(sp)
    80003088:	e85a                	sd	s6,16(sp)
    8000308a:	e45e                	sd	s7,8(sp)
    8000308c:	0880                	addi	s0,sp,80
    8000308e:	8b2a                	mv	s6,a0
    80003090:	00021a97          	auipc	s5,0x21
    80003094:	530a8a93          	addi	s5,s5,1328 # 800245c0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003098:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000309a:	00021997          	auipc	s3,0x21
    8000309e:	4f698993          	addi	s3,s3,1270 # 80024590 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800030a2:	40000b93          	li	s7,1024
    800030a6:	a829                	j	800030c0 <install_trans+0x54>
    brelse(lbuf);
    800030a8:	854a                	mv	a0,s2
    800030aa:	a38ff0ef          	jal	800022e2 <brelse>
    brelse(dbuf);
    800030ae:	8526                	mv	a0,s1
    800030b0:	a32ff0ef          	jal	800022e2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800030b4:	2a05                	addiw	s4,s4,1
    800030b6:	0a91                	addi	s5,s5,4
    800030b8:	02c9a783          	lw	a5,44(s3)
    800030bc:	04fa5363          	bge	s4,a5,80003102 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800030c0:	0189a583          	lw	a1,24(s3)
    800030c4:	014585bb          	addw	a1,a1,s4
    800030c8:	2585                	addiw	a1,a1,1
    800030ca:	0289a503          	lw	a0,40(s3)
    800030ce:	90cff0ef          	jal	800021da <bread>
    800030d2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800030d4:	000aa583          	lw	a1,0(s5)
    800030d8:	0289a503          	lw	a0,40(s3)
    800030dc:	8feff0ef          	jal	800021da <bread>
    800030e0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800030e2:	865e                	mv	a2,s7
    800030e4:	05890593          	addi	a1,s2,88
    800030e8:	05850513          	addi	a0,a0,88
    800030ec:	8c6fd0ef          	jal	800001b2 <memmove>
    bwrite(dbuf);  // write dst to disk
    800030f0:	8526                	mv	a0,s1
    800030f2:	9beff0ef          	jal	800022b0 <bwrite>
    if(recovering == 0)
    800030f6:	fa0b19e3          	bnez	s6,800030a8 <install_trans+0x3c>
      bunpin(dbuf);
    800030fa:	8526                	mv	a0,s1
    800030fc:	a9eff0ef          	jal	8000239a <bunpin>
    80003100:	b765                	j	800030a8 <install_trans+0x3c>
}
    80003102:	60a6                	ld	ra,72(sp)
    80003104:	6406                	ld	s0,64(sp)
    80003106:	74e2                	ld	s1,56(sp)
    80003108:	7942                	ld	s2,48(sp)
    8000310a:	79a2                	ld	s3,40(sp)
    8000310c:	7a02                	ld	s4,32(sp)
    8000310e:	6ae2                	ld	s5,24(sp)
    80003110:	6b42                	ld	s6,16(sp)
    80003112:	6ba2                	ld	s7,8(sp)
    80003114:	6161                	addi	sp,sp,80
    80003116:	8082                	ret
    80003118:	8082                	ret

000000008000311a <initlog>:
{
    8000311a:	7179                	addi	sp,sp,-48
    8000311c:	f406                	sd	ra,40(sp)
    8000311e:	f022                	sd	s0,32(sp)
    80003120:	ec26                	sd	s1,24(sp)
    80003122:	e84a                	sd	s2,16(sp)
    80003124:	e44e                	sd	s3,8(sp)
    80003126:	1800                	addi	s0,sp,48
    80003128:	892a                	mv	s2,a0
    8000312a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000312c:	00021497          	auipc	s1,0x21
    80003130:	46448493          	addi	s1,s1,1124 # 80024590 <log>
    80003134:	00004597          	auipc	a1,0x4
    80003138:	45c58593          	addi	a1,a1,1116 # 80007590 <etext+0x590>
    8000313c:	8526                	mv	a0,s1
    8000313e:	3c3020ef          	jal	80005d00 <initlock>
  log.start = sb->logstart;
    80003142:	0149a583          	lw	a1,20(s3)
    80003146:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003148:	0109a783          	lw	a5,16(s3)
    8000314c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000314e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003152:	854a                	mv	a0,s2
    80003154:	886ff0ef          	jal	800021da <bread>
  log.lh.n = lh->n;
    80003158:	4d30                	lw	a2,88(a0)
    8000315a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000315c:	00c05f63          	blez	a2,8000317a <initlog+0x60>
    80003160:	87aa                	mv	a5,a0
    80003162:	00021717          	auipc	a4,0x21
    80003166:	45e70713          	addi	a4,a4,1118 # 800245c0 <log+0x30>
    8000316a:	060a                	slli	a2,a2,0x2
    8000316c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000316e:	4ff4                	lw	a3,92(a5)
    80003170:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003172:	0791                	addi	a5,a5,4
    80003174:	0711                	addi	a4,a4,4
    80003176:	fec79ce3          	bne	a5,a2,8000316e <initlog+0x54>
  brelse(buf);
    8000317a:	968ff0ef          	jal	800022e2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000317e:	4505                	li	a0,1
    80003180:	eedff0ef          	jal	8000306c <install_trans>
  log.lh.n = 0;
    80003184:	00021797          	auipc	a5,0x21
    80003188:	4207ac23          	sw	zero,1080(a5) # 800245bc <log+0x2c>
  write_head(); // clear the log
    8000318c:	e83ff0ef          	jal	8000300e <write_head>
}
    80003190:	70a2                	ld	ra,40(sp)
    80003192:	7402                	ld	s0,32(sp)
    80003194:	64e2                	ld	s1,24(sp)
    80003196:	6942                	ld	s2,16(sp)
    80003198:	69a2                	ld	s3,8(sp)
    8000319a:	6145                	addi	sp,sp,48
    8000319c:	8082                	ret

000000008000319e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000319e:	1101                	addi	sp,sp,-32
    800031a0:	ec06                	sd	ra,24(sp)
    800031a2:	e822                	sd	s0,16(sp)
    800031a4:	e426                	sd	s1,8(sp)
    800031a6:	e04a                	sd	s2,0(sp)
    800031a8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800031aa:	00021517          	auipc	a0,0x21
    800031ae:	3e650513          	addi	a0,a0,998 # 80024590 <log>
    800031b2:	3d3020ef          	jal	80005d84 <acquire>
  while(1){
    if(log.committing){
    800031b6:	00021497          	auipc	s1,0x21
    800031ba:	3da48493          	addi	s1,s1,986 # 80024590 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800031be:	4979                	li	s2,30
    800031c0:	a029                	j	800031ca <begin_op+0x2c>
      sleep(&log, &log.lock);
    800031c2:	85a6                	mv	a1,s1
    800031c4:	8526                	mv	a0,s1
    800031c6:	a56fe0ef          	jal	8000141c <sleep>
    if(log.committing){
    800031ca:	50dc                	lw	a5,36(s1)
    800031cc:	fbfd                	bnez	a5,800031c2 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800031ce:	5098                	lw	a4,32(s1)
    800031d0:	2705                	addiw	a4,a4,1
    800031d2:	0027179b          	slliw	a5,a4,0x2
    800031d6:	9fb9                	addw	a5,a5,a4
    800031d8:	0017979b          	slliw	a5,a5,0x1
    800031dc:	54d4                	lw	a3,44(s1)
    800031de:	9fb5                	addw	a5,a5,a3
    800031e0:	00f95763          	bge	s2,a5,800031ee <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800031e4:	85a6                	mv	a1,s1
    800031e6:	8526                	mv	a0,s1
    800031e8:	a34fe0ef          	jal	8000141c <sleep>
    800031ec:	bff9                	j	800031ca <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800031ee:	00021517          	auipc	a0,0x21
    800031f2:	3a250513          	addi	a0,a0,930 # 80024590 <log>
    800031f6:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800031f8:	421020ef          	jal	80005e18 <release>
      break;
    }
  }
}
    800031fc:	60e2                	ld	ra,24(sp)
    800031fe:	6442                	ld	s0,16(sp)
    80003200:	64a2                	ld	s1,8(sp)
    80003202:	6902                	ld	s2,0(sp)
    80003204:	6105                	addi	sp,sp,32
    80003206:	8082                	ret

0000000080003208 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003208:	7139                	addi	sp,sp,-64
    8000320a:	fc06                	sd	ra,56(sp)
    8000320c:	f822                	sd	s0,48(sp)
    8000320e:	f426                	sd	s1,40(sp)
    80003210:	f04a                	sd	s2,32(sp)
    80003212:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003214:	00021497          	auipc	s1,0x21
    80003218:	37c48493          	addi	s1,s1,892 # 80024590 <log>
    8000321c:	8526                	mv	a0,s1
    8000321e:	367020ef          	jal	80005d84 <acquire>
  log.outstanding -= 1;
    80003222:	509c                	lw	a5,32(s1)
    80003224:	37fd                	addiw	a5,a5,-1
    80003226:	893e                	mv	s2,a5
    80003228:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000322a:	50dc                	lw	a5,36(s1)
    8000322c:	ef9d                	bnez	a5,8000326a <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    8000322e:	04091863          	bnez	s2,8000327e <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003232:	00021497          	auipc	s1,0x21
    80003236:	35e48493          	addi	s1,s1,862 # 80024590 <log>
    8000323a:	4785                	li	a5,1
    8000323c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000323e:	8526                	mv	a0,s1
    80003240:	3d9020ef          	jal	80005e18 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003244:	54dc                	lw	a5,44(s1)
    80003246:	04f04c63          	bgtz	a5,8000329e <end_op+0x96>
    acquire(&log.lock);
    8000324a:	00021497          	auipc	s1,0x21
    8000324e:	34648493          	addi	s1,s1,838 # 80024590 <log>
    80003252:	8526                	mv	a0,s1
    80003254:	331020ef          	jal	80005d84 <acquire>
    log.committing = 0;
    80003258:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000325c:	8526                	mv	a0,s1
    8000325e:	a0afe0ef          	jal	80001468 <wakeup>
    release(&log.lock);
    80003262:	8526                	mv	a0,s1
    80003264:	3b5020ef          	jal	80005e18 <release>
}
    80003268:	a02d                	j	80003292 <end_op+0x8a>
    8000326a:	ec4e                	sd	s3,24(sp)
    8000326c:	e852                	sd	s4,16(sp)
    8000326e:	e456                	sd	s5,8(sp)
    80003270:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80003272:	00004517          	auipc	a0,0x4
    80003276:	32650513          	addi	a0,a0,806 # 80007598 <etext+0x598>
    8000327a:	7dc020ef          	jal	80005a56 <panic>
    wakeup(&log);
    8000327e:	00021497          	auipc	s1,0x21
    80003282:	31248493          	addi	s1,s1,786 # 80024590 <log>
    80003286:	8526                	mv	a0,s1
    80003288:	9e0fe0ef          	jal	80001468 <wakeup>
  release(&log.lock);
    8000328c:	8526                	mv	a0,s1
    8000328e:	38b020ef          	jal	80005e18 <release>
}
    80003292:	70e2                	ld	ra,56(sp)
    80003294:	7442                	ld	s0,48(sp)
    80003296:	74a2                	ld	s1,40(sp)
    80003298:	7902                	ld	s2,32(sp)
    8000329a:	6121                	addi	sp,sp,64
    8000329c:	8082                	ret
    8000329e:	ec4e                	sd	s3,24(sp)
    800032a0:	e852                	sd	s4,16(sp)
    800032a2:	e456                	sd	s5,8(sp)
    800032a4:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800032a6:	00021a97          	auipc	s5,0x21
    800032aa:	31aa8a93          	addi	s5,s5,794 # 800245c0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800032ae:	00021a17          	auipc	s4,0x21
    800032b2:	2e2a0a13          	addi	s4,s4,738 # 80024590 <log>
    memmove(to->data, from->data, BSIZE);
    800032b6:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800032ba:	018a2583          	lw	a1,24(s4)
    800032be:	012585bb          	addw	a1,a1,s2
    800032c2:	2585                	addiw	a1,a1,1
    800032c4:	028a2503          	lw	a0,40(s4)
    800032c8:	f13fe0ef          	jal	800021da <bread>
    800032cc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800032ce:	000aa583          	lw	a1,0(s5)
    800032d2:	028a2503          	lw	a0,40(s4)
    800032d6:	f05fe0ef          	jal	800021da <bread>
    800032da:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800032dc:	865a                	mv	a2,s6
    800032de:	05850593          	addi	a1,a0,88
    800032e2:	05848513          	addi	a0,s1,88
    800032e6:	ecdfc0ef          	jal	800001b2 <memmove>
    bwrite(to);  // write the log
    800032ea:	8526                	mv	a0,s1
    800032ec:	fc5fe0ef          	jal	800022b0 <bwrite>
    brelse(from);
    800032f0:	854e                	mv	a0,s3
    800032f2:	ff1fe0ef          	jal	800022e2 <brelse>
    brelse(to);
    800032f6:	8526                	mv	a0,s1
    800032f8:	febfe0ef          	jal	800022e2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800032fc:	2905                	addiw	s2,s2,1
    800032fe:	0a91                	addi	s5,s5,4
    80003300:	02ca2783          	lw	a5,44(s4)
    80003304:	faf94be3          	blt	s2,a5,800032ba <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003308:	d07ff0ef          	jal	8000300e <write_head>
    install_trans(0); // Now install writes to home locations
    8000330c:	4501                	li	a0,0
    8000330e:	d5fff0ef          	jal	8000306c <install_trans>
    log.lh.n = 0;
    80003312:	00021797          	auipc	a5,0x21
    80003316:	2a07a523          	sw	zero,682(a5) # 800245bc <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000331a:	cf5ff0ef          	jal	8000300e <write_head>
    8000331e:	69e2                	ld	s3,24(sp)
    80003320:	6a42                	ld	s4,16(sp)
    80003322:	6aa2                	ld	s5,8(sp)
    80003324:	6b02                	ld	s6,0(sp)
    80003326:	b715                	j	8000324a <end_op+0x42>

0000000080003328 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003328:	1101                	addi	sp,sp,-32
    8000332a:	ec06                	sd	ra,24(sp)
    8000332c:	e822                	sd	s0,16(sp)
    8000332e:	e426                	sd	s1,8(sp)
    80003330:	e04a                	sd	s2,0(sp)
    80003332:	1000                	addi	s0,sp,32
    80003334:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003336:	00021917          	auipc	s2,0x21
    8000333a:	25a90913          	addi	s2,s2,602 # 80024590 <log>
    8000333e:	854a                	mv	a0,s2
    80003340:	245020ef          	jal	80005d84 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003344:	02c92603          	lw	a2,44(s2)
    80003348:	47f5                	li	a5,29
    8000334a:	06c7c363          	blt	a5,a2,800033b0 <log_write+0x88>
    8000334e:	00021797          	auipc	a5,0x21
    80003352:	25e7a783          	lw	a5,606(a5) # 800245ac <log+0x1c>
    80003356:	37fd                	addiw	a5,a5,-1
    80003358:	04f65c63          	bge	a2,a5,800033b0 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000335c:	00021797          	auipc	a5,0x21
    80003360:	2547a783          	lw	a5,596(a5) # 800245b0 <log+0x20>
    80003364:	04f05c63          	blez	a5,800033bc <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003368:	4781                	li	a5,0
    8000336a:	04c05f63          	blez	a2,800033c8 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000336e:	44cc                	lw	a1,12(s1)
    80003370:	00021717          	auipc	a4,0x21
    80003374:	25070713          	addi	a4,a4,592 # 800245c0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003378:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000337a:	4314                	lw	a3,0(a4)
    8000337c:	04b68663          	beq	a3,a1,800033c8 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003380:	2785                	addiw	a5,a5,1
    80003382:	0711                	addi	a4,a4,4
    80003384:	fef61be3          	bne	a2,a5,8000337a <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003388:	0621                	addi	a2,a2,8
    8000338a:	060a                	slli	a2,a2,0x2
    8000338c:	00021797          	auipc	a5,0x21
    80003390:	20478793          	addi	a5,a5,516 # 80024590 <log>
    80003394:	97b2                	add	a5,a5,a2
    80003396:	44d8                	lw	a4,12(s1)
    80003398:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000339a:	8526                	mv	a0,s1
    8000339c:	fcbfe0ef          	jal	80002366 <bpin>
    log.lh.n++;
    800033a0:	00021717          	auipc	a4,0x21
    800033a4:	1f070713          	addi	a4,a4,496 # 80024590 <log>
    800033a8:	575c                	lw	a5,44(a4)
    800033aa:	2785                	addiw	a5,a5,1
    800033ac:	d75c                	sw	a5,44(a4)
    800033ae:	a80d                	j	800033e0 <log_write+0xb8>
    panic("too big a transaction");
    800033b0:	00004517          	auipc	a0,0x4
    800033b4:	1f850513          	addi	a0,a0,504 # 800075a8 <etext+0x5a8>
    800033b8:	69e020ef          	jal	80005a56 <panic>
    panic("log_write outside of trans");
    800033bc:	00004517          	auipc	a0,0x4
    800033c0:	20450513          	addi	a0,a0,516 # 800075c0 <etext+0x5c0>
    800033c4:	692020ef          	jal	80005a56 <panic>
  log.lh.block[i] = b->blockno;
    800033c8:	00878693          	addi	a3,a5,8
    800033cc:	068a                	slli	a3,a3,0x2
    800033ce:	00021717          	auipc	a4,0x21
    800033d2:	1c270713          	addi	a4,a4,450 # 80024590 <log>
    800033d6:	9736                	add	a4,a4,a3
    800033d8:	44d4                	lw	a3,12(s1)
    800033da:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800033dc:	faf60fe3          	beq	a2,a5,8000339a <log_write+0x72>
  }
  release(&log.lock);
    800033e0:	00021517          	auipc	a0,0x21
    800033e4:	1b050513          	addi	a0,a0,432 # 80024590 <log>
    800033e8:	231020ef          	jal	80005e18 <release>
}
    800033ec:	60e2                	ld	ra,24(sp)
    800033ee:	6442                	ld	s0,16(sp)
    800033f0:	64a2                	ld	s1,8(sp)
    800033f2:	6902                	ld	s2,0(sp)
    800033f4:	6105                	addi	sp,sp,32
    800033f6:	8082                	ret

00000000800033f8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800033f8:	1101                	addi	sp,sp,-32
    800033fa:	ec06                	sd	ra,24(sp)
    800033fc:	e822                	sd	s0,16(sp)
    800033fe:	e426                	sd	s1,8(sp)
    80003400:	e04a                	sd	s2,0(sp)
    80003402:	1000                	addi	s0,sp,32
    80003404:	84aa                	mv	s1,a0
    80003406:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003408:	00004597          	auipc	a1,0x4
    8000340c:	1d858593          	addi	a1,a1,472 # 800075e0 <etext+0x5e0>
    80003410:	0521                	addi	a0,a0,8
    80003412:	0ef020ef          	jal	80005d00 <initlock>
  lk->name = name;
    80003416:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000341a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000341e:	0204a423          	sw	zero,40(s1)
}
    80003422:	60e2                	ld	ra,24(sp)
    80003424:	6442                	ld	s0,16(sp)
    80003426:	64a2                	ld	s1,8(sp)
    80003428:	6902                	ld	s2,0(sp)
    8000342a:	6105                	addi	sp,sp,32
    8000342c:	8082                	ret

000000008000342e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000342e:	1101                	addi	sp,sp,-32
    80003430:	ec06                	sd	ra,24(sp)
    80003432:	e822                	sd	s0,16(sp)
    80003434:	e426                	sd	s1,8(sp)
    80003436:	e04a                	sd	s2,0(sp)
    80003438:	1000                	addi	s0,sp,32
    8000343a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000343c:	00850913          	addi	s2,a0,8
    80003440:	854a                	mv	a0,s2
    80003442:	143020ef          	jal	80005d84 <acquire>
  while (lk->locked) {
    80003446:	409c                	lw	a5,0(s1)
    80003448:	c799                	beqz	a5,80003456 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000344a:	85ca                	mv	a1,s2
    8000344c:	8526                	mv	a0,s1
    8000344e:	fcffd0ef          	jal	8000141c <sleep>
  while (lk->locked) {
    80003452:	409c                	lw	a5,0(s1)
    80003454:	fbfd                	bnez	a5,8000344a <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003456:	4785                	li	a5,1
    80003458:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000345a:	9b1fd0ef          	jal	80000e0a <myproc>
    8000345e:	591c                	lw	a5,48(a0)
    80003460:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003462:	854a                	mv	a0,s2
    80003464:	1b5020ef          	jal	80005e18 <release>
}
    80003468:	60e2                	ld	ra,24(sp)
    8000346a:	6442                	ld	s0,16(sp)
    8000346c:	64a2                	ld	s1,8(sp)
    8000346e:	6902                	ld	s2,0(sp)
    80003470:	6105                	addi	sp,sp,32
    80003472:	8082                	ret

0000000080003474 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003474:	1101                	addi	sp,sp,-32
    80003476:	ec06                	sd	ra,24(sp)
    80003478:	e822                	sd	s0,16(sp)
    8000347a:	e426                	sd	s1,8(sp)
    8000347c:	e04a                	sd	s2,0(sp)
    8000347e:	1000                	addi	s0,sp,32
    80003480:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003482:	00850913          	addi	s2,a0,8
    80003486:	854a                	mv	a0,s2
    80003488:	0fd020ef          	jal	80005d84 <acquire>
  lk->locked = 0;
    8000348c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003490:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003494:	8526                	mv	a0,s1
    80003496:	fd3fd0ef          	jal	80001468 <wakeup>
  release(&lk->lk);
    8000349a:	854a                	mv	a0,s2
    8000349c:	17d020ef          	jal	80005e18 <release>
}
    800034a0:	60e2                	ld	ra,24(sp)
    800034a2:	6442                	ld	s0,16(sp)
    800034a4:	64a2                	ld	s1,8(sp)
    800034a6:	6902                	ld	s2,0(sp)
    800034a8:	6105                	addi	sp,sp,32
    800034aa:	8082                	ret

00000000800034ac <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800034ac:	7179                	addi	sp,sp,-48
    800034ae:	f406                	sd	ra,40(sp)
    800034b0:	f022                	sd	s0,32(sp)
    800034b2:	ec26                	sd	s1,24(sp)
    800034b4:	e84a                	sd	s2,16(sp)
    800034b6:	1800                	addi	s0,sp,48
    800034b8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800034ba:	00850913          	addi	s2,a0,8
    800034be:	854a                	mv	a0,s2
    800034c0:	0c5020ef          	jal	80005d84 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800034c4:	409c                	lw	a5,0(s1)
    800034c6:	ef81                	bnez	a5,800034de <holdingsleep+0x32>
    800034c8:	4481                	li	s1,0
  release(&lk->lk);
    800034ca:	854a                	mv	a0,s2
    800034cc:	14d020ef          	jal	80005e18 <release>
  return r;
}
    800034d0:	8526                	mv	a0,s1
    800034d2:	70a2                	ld	ra,40(sp)
    800034d4:	7402                	ld	s0,32(sp)
    800034d6:	64e2                	ld	s1,24(sp)
    800034d8:	6942                	ld	s2,16(sp)
    800034da:	6145                	addi	sp,sp,48
    800034dc:	8082                	ret
    800034de:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800034e0:	0284a983          	lw	s3,40(s1)
    800034e4:	927fd0ef          	jal	80000e0a <myproc>
    800034e8:	5904                	lw	s1,48(a0)
    800034ea:	413484b3          	sub	s1,s1,s3
    800034ee:	0014b493          	seqz	s1,s1
    800034f2:	69a2                	ld	s3,8(sp)
    800034f4:	bfd9                	j	800034ca <holdingsleep+0x1e>

00000000800034f6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800034f6:	1141                	addi	sp,sp,-16
    800034f8:	e406                	sd	ra,8(sp)
    800034fa:	e022                	sd	s0,0(sp)
    800034fc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800034fe:	00004597          	auipc	a1,0x4
    80003502:	0f258593          	addi	a1,a1,242 # 800075f0 <etext+0x5f0>
    80003506:	00021517          	auipc	a0,0x21
    8000350a:	1d250513          	addi	a0,a0,466 # 800246d8 <ftable>
    8000350e:	7f2020ef          	jal	80005d00 <initlock>
}
    80003512:	60a2                	ld	ra,8(sp)
    80003514:	6402                	ld	s0,0(sp)
    80003516:	0141                	addi	sp,sp,16
    80003518:	8082                	ret

000000008000351a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000351a:	1101                	addi	sp,sp,-32
    8000351c:	ec06                	sd	ra,24(sp)
    8000351e:	e822                	sd	s0,16(sp)
    80003520:	e426                	sd	s1,8(sp)
    80003522:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003524:	00021517          	auipc	a0,0x21
    80003528:	1b450513          	addi	a0,a0,436 # 800246d8 <ftable>
    8000352c:	059020ef          	jal	80005d84 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003530:	00021497          	auipc	s1,0x21
    80003534:	1c048493          	addi	s1,s1,448 # 800246f0 <ftable+0x18>
    80003538:	00022717          	auipc	a4,0x22
    8000353c:	15870713          	addi	a4,a4,344 # 80025690 <disk>
    if(f->ref == 0){
    80003540:	40dc                	lw	a5,4(s1)
    80003542:	cf89                	beqz	a5,8000355c <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003544:	02848493          	addi	s1,s1,40
    80003548:	fee49ce3          	bne	s1,a4,80003540 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000354c:	00021517          	auipc	a0,0x21
    80003550:	18c50513          	addi	a0,a0,396 # 800246d8 <ftable>
    80003554:	0c5020ef          	jal	80005e18 <release>
  return 0;
    80003558:	4481                	li	s1,0
    8000355a:	a809                	j	8000356c <filealloc+0x52>
      f->ref = 1;
    8000355c:	4785                	li	a5,1
    8000355e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003560:	00021517          	auipc	a0,0x21
    80003564:	17850513          	addi	a0,a0,376 # 800246d8 <ftable>
    80003568:	0b1020ef          	jal	80005e18 <release>
}
    8000356c:	8526                	mv	a0,s1
    8000356e:	60e2                	ld	ra,24(sp)
    80003570:	6442                	ld	s0,16(sp)
    80003572:	64a2                	ld	s1,8(sp)
    80003574:	6105                	addi	sp,sp,32
    80003576:	8082                	ret

0000000080003578 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003578:	1101                	addi	sp,sp,-32
    8000357a:	ec06                	sd	ra,24(sp)
    8000357c:	e822                	sd	s0,16(sp)
    8000357e:	e426                	sd	s1,8(sp)
    80003580:	1000                	addi	s0,sp,32
    80003582:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003584:	00021517          	auipc	a0,0x21
    80003588:	15450513          	addi	a0,a0,340 # 800246d8 <ftable>
    8000358c:	7f8020ef          	jal	80005d84 <acquire>
  if(f->ref < 1)
    80003590:	40dc                	lw	a5,4(s1)
    80003592:	02f05063          	blez	a5,800035b2 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003596:	2785                	addiw	a5,a5,1
    80003598:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000359a:	00021517          	auipc	a0,0x21
    8000359e:	13e50513          	addi	a0,a0,318 # 800246d8 <ftable>
    800035a2:	077020ef          	jal	80005e18 <release>
  return f;
}
    800035a6:	8526                	mv	a0,s1
    800035a8:	60e2                	ld	ra,24(sp)
    800035aa:	6442                	ld	s0,16(sp)
    800035ac:	64a2                	ld	s1,8(sp)
    800035ae:	6105                	addi	sp,sp,32
    800035b0:	8082                	ret
    panic("filedup");
    800035b2:	00004517          	auipc	a0,0x4
    800035b6:	04650513          	addi	a0,a0,70 # 800075f8 <etext+0x5f8>
    800035ba:	49c020ef          	jal	80005a56 <panic>

00000000800035be <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800035be:	7139                	addi	sp,sp,-64
    800035c0:	fc06                	sd	ra,56(sp)
    800035c2:	f822                	sd	s0,48(sp)
    800035c4:	f426                	sd	s1,40(sp)
    800035c6:	0080                	addi	s0,sp,64
    800035c8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800035ca:	00021517          	auipc	a0,0x21
    800035ce:	10e50513          	addi	a0,a0,270 # 800246d8 <ftable>
    800035d2:	7b2020ef          	jal	80005d84 <acquire>
  if(f->ref < 1)
    800035d6:	40dc                	lw	a5,4(s1)
    800035d8:	04f05863          	blez	a5,80003628 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    800035dc:	37fd                	addiw	a5,a5,-1
    800035de:	c0dc                	sw	a5,4(s1)
    800035e0:	04f04e63          	bgtz	a5,8000363c <fileclose+0x7e>
    800035e4:	f04a                	sd	s2,32(sp)
    800035e6:	ec4e                	sd	s3,24(sp)
    800035e8:	e852                	sd	s4,16(sp)
    800035ea:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800035ec:	0004a903          	lw	s2,0(s1)
    800035f0:	0094ca83          	lbu	s5,9(s1)
    800035f4:	0104ba03          	ld	s4,16(s1)
    800035f8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800035fc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003600:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003604:	00021517          	auipc	a0,0x21
    80003608:	0d450513          	addi	a0,a0,212 # 800246d8 <ftable>
    8000360c:	00d020ef          	jal	80005e18 <release>

  if(ff.type == FD_PIPE){
    80003610:	4785                	li	a5,1
    80003612:	04f90063          	beq	s2,a5,80003652 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003616:	3979                	addiw	s2,s2,-2
    80003618:	4785                	li	a5,1
    8000361a:	0527f563          	bgeu	a5,s2,80003664 <fileclose+0xa6>
    8000361e:	7902                	ld	s2,32(sp)
    80003620:	69e2                	ld	s3,24(sp)
    80003622:	6a42                	ld	s4,16(sp)
    80003624:	6aa2                	ld	s5,8(sp)
    80003626:	a00d                	j	80003648 <fileclose+0x8a>
    80003628:	f04a                	sd	s2,32(sp)
    8000362a:	ec4e                	sd	s3,24(sp)
    8000362c:	e852                	sd	s4,16(sp)
    8000362e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003630:	00004517          	auipc	a0,0x4
    80003634:	fd050513          	addi	a0,a0,-48 # 80007600 <etext+0x600>
    80003638:	41e020ef          	jal	80005a56 <panic>
    release(&ftable.lock);
    8000363c:	00021517          	auipc	a0,0x21
    80003640:	09c50513          	addi	a0,a0,156 # 800246d8 <ftable>
    80003644:	7d4020ef          	jal	80005e18 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003648:	70e2                	ld	ra,56(sp)
    8000364a:	7442                	ld	s0,48(sp)
    8000364c:	74a2                	ld	s1,40(sp)
    8000364e:	6121                	addi	sp,sp,64
    80003650:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003652:	85d6                	mv	a1,s5
    80003654:	8552                	mv	a0,s4
    80003656:	340000ef          	jal	80003996 <pipeclose>
    8000365a:	7902                	ld	s2,32(sp)
    8000365c:	69e2                	ld	s3,24(sp)
    8000365e:	6a42                	ld	s4,16(sp)
    80003660:	6aa2                	ld	s5,8(sp)
    80003662:	b7dd                	j	80003648 <fileclose+0x8a>
    begin_op();
    80003664:	b3bff0ef          	jal	8000319e <begin_op>
    iput(ff.ip);
    80003668:	854e                	mv	a0,s3
    8000366a:	c04ff0ef          	jal	80002a6e <iput>
    end_op();
    8000366e:	b9bff0ef          	jal	80003208 <end_op>
    80003672:	7902                	ld	s2,32(sp)
    80003674:	69e2                	ld	s3,24(sp)
    80003676:	6a42                	ld	s4,16(sp)
    80003678:	6aa2                	ld	s5,8(sp)
    8000367a:	b7f9                	j	80003648 <fileclose+0x8a>

000000008000367c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000367c:	715d                	addi	sp,sp,-80
    8000367e:	e486                	sd	ra,72(sp)
    80003680:	e0a2                	sd	s0,64(sp)
    80003682:	fc26                	sd	s1,56(sp)
    80003684:	f44e                	sd	s3,40(sp)
    80003686:	0880                	addi	s0,sp,80
    80003688:	84aa                	mv	s1,a0
    8000368a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000368c:	f7efd0ef          	jal	80000e0a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003690:	409c                	lw	a5,0(s1)
    80003692:	37f9                	addiw	a5,a5,-2
    80003694:	4705                	li	a4,1
    80003696:	04f76263          	bltu	a4,a5,800036da <filestat+0x5e>
    8000369a:	f84a                	sd	s2,48(sp)
    8000369c:	f052                	sd	s4,32(sp)
    8000369e:	892a                	mv	s2,a0
    ilock(f->ip);
    800036a0:	6c88                	ld	a0,24(s1)
    800036a2:	a4aff0ef          	jal	800028ec <ilock>
    stati(f->ip, &st);
    800036a6:	fb840a13          	addi	s4,s0,-72
    800036aa:	85d2                	mv	a1,s4
    800036ac:	6c88                	ld	a0,24(s1)
    800036ae:	c68ff0ef          	jal	80002b16 <stati>
    iunlock(f->ip);
    800036b2:	6c88                	ld	a0,24(s1)
    800036b4:	ae6ff0ef          	jal	8000299a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800036b8:	46e1                	li	a3,24
    800036ba:	8652                	mv	a2,s4
    800036bc:	85ce                	mv	a1,s3
    800036be:	05093503          	ld	a0,80(s2)
    800036c2:	bf0fd0ef          	jal	80000ab2 <copyout>
    800036c6:	41f5551b          	sraiw	a0,a0,0x1f
    800036ca:	7942                	ld	s2,48(sp)
    800036cc:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800036ce:	60a6                	ld	ra,72(sp)
    800036d0:	6406                	ld	s0,64(sp)
    800036d2:	74e2                	ld	s1,56(sp)
    800036d4:	79a2                	ld	s3,40(sp)
    800036d6:	6161                	addi	sp,sp,80
    800036d8:	8082                	ret
  return -1;
    800036da:	557d                	li	a0,-1
    800036dc:	bfcd                	j	800036ce <filestat+0x52>

00000000800036de <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800036de:	7179                	addi	sp,sp,-48
    800036e0:	f406                	sd	ra,40(sp)
    800036e2:	f022                	sd	s0,32(sp)
    800036e4:	e84a                	sd	s2,16(sp)
    800036e6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800036e8:	00854783          	lbu	a5,8(a0)
    800036ec:	cfd1                	beqz	a5,80003788 <fileread+0xaa>
    800036ee:	ec26                	sd	s1,24(sp)
    800036f0:	e44e                	sd	s3,8(sp)
    800036f2:	84aa                	mv	s1,a0
    800036f4:	89ae                	mv	s3,a1
    800036f6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800036f8:	411c                	lw	a5,0(a0)
    800036fa:	4705                	li	a4,1
    800036fc:	04e78363          	beq	a5,a4,80003742 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003700:	470d                	li	a4,3
    80003702:	04e78763          	beq	a5,a4,80003750 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003706:	4709                	li	a4,2
    80003708:	06e79a63          	bne	a5,a4,8000377c <fileread+0x9e>
    ilock(f->ip);
    8000370c:	6d08                	ld	a0,24(a0)
    8000370e:	9deff0ef          	jal	800028ec <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003712:	874a                	mv	a4,s2
    80003714:	5094                	lw	a3,32(s1)
    80003716:	864e                	mv	a2,s3
    80003718:	4585                	li	a1,1
    8000371a:	6c88                	ld	a0,24(s1)
    8000371c:	c28ff0ef          	jal	80002b44 <readi>
    80003720:	892a                	mv	s2,a0
    80003722:	00a05563          	blez	a0,8000372c <fileread+0x4e>
      f->off += r;
    80003726:	509c                	lw	a5,32(s1)
    80003728:	9fa9                	addw	a5,a5,a0
    8000372a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000372c:	6c88                	ld	a0,24(s1)
    8000372e:	a6cff0ef          	jal	8000299a <iunlock>
    80003732:	64e2                	ld	s1,24(sp)
    80003734:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003736:	854a                	mv	a0,s2
    80003738:	70a2                	ld	ra,40(sp)
    8000373a:	7402                	ld	s0,32(sp)
    8000373c:	6942                	ld	s2,16(sp)
    8000373e:	6145                	addi	sp,sp,48
    80003740:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003742:	6908                	ld	a0,16(a0)
    80003744:	3a2000ef          	jal	80003ae6 <piperead>
    80003748:	892a                	mv	s2,a0
    8000374a:	64e2                	ld	s1,24(sp)
    8000374c:	69a2                	ld	s3,8(sp)
    8000374e:	b7e5                	j	80003736 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003750:	02451783          	lh	a5,36(a0)
    80003754:	03079693          	slli	a3,a5,0x30
    80003758:	92c1                	srli	a3,a3,0x30
    8000375a:	4725                	li	a4,9
    8000375c:	02d76863          	bltu	a4,a3,8000378c <fileread+0xae>
    80003760:	0792                	slli	a5,a5,0x4
    80003762:	00021717          	auipc	a4,0x21
    80003766:	ed670713          	addi	a4,a4,-298 # 80024638 <devsw>
    8000376a:	97ba                	add	a5,a5,a4
    8000376c:	639c                	ld	a5,0(a5)
    8000376e:	c39d                	beqz	a5,80003794 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003770:	4505                	li	a0,1
    80003772:	9782                	jalr	a5
    80003774:	892a                	mv	s2,a0
    80003776:	64e2                	ld	s1,24(sp)
    80003778:	69a2                	ld	s3,8(sp)
    8000377a:	bf75                	j	80003736 <fileread+0x58>
    panic("fileread");
    8000377c:	00004517          	auipc	a0,0x4
    80003780:	e9450513          	addi	a0,a0,-364 # 80007610 <etext+0x610>
    80003784:	2d2020ef          	jal	80005a56 <panic>
    return -1;
    80003788:	597d                	li	s2,-1
    8000378a:	b775                	j	80003736 <fileread+0x58>
      return -1;
    8000378c:	597d                	li	s2,-1
    8000378e:	64e2                	ld	s1,24(sp)
    80003790:	69a2                	ld	s3,8(sp)
    80003792:	b755                	j	80003736 <fileread+0x58>
    80003794:	597d                	li	s2,-1
    80003796:	64e2                	ld	s1,24(sp)
    80003798:	69a2                	ld	s3,8(sp)
    8000379a:	bf71                	j	80003736 <fileread+0x58>

000000008000379c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000379c:	00954783          	lbu	a5,9(a0)
    800037a0:	10078e63          	beqz	a5,800038bc <filewrite+0x120>
{
    800037a4:	711d                	addi	sp,sp,-96
    800037a6:	ec86                	sd	ra,88(sp)
    800037a8:	e8a2                	sd	s0,80(sp)
    800037aa:	e0ca                	sd	s2,64(sp)
    800037ac:	f456                	sd	s5,40(sp)
    800037ae:	f05a                	sd	s6,32(sp)
    800037b0:	1080                	addi	s0,sp,96
    800037b2:	892a                	mv	s2,a0
    800037b4:	8b2e                	mv	s6,a1
    800037b6:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800037b8:	411c                	lw	a5,0(a0)
    800037ba:	4705                	li	a4,1
    800037bc:	02e78963          	beq	a5,a4,800037ee <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800037c0:	470d                	li	a4,3
    800037c2:	02e78a63          	beq	a5,a4,800037f6 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800037c6:	4709                	li	a4,2
    800037c8:	0ce79e63          	bne	a5,a4,800038a4 <filewrite+0x108>
    800037cc:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800037ce:	0ac05963          	blez	a2,80003880 <filewrite+0xe4>
    800037d2:	e4a6                	sd	s1,72(sp)
    800037d4:	fc4e                	sd	s3,56(sp)
    800037d6:	ec5e                	sd	s7,24(sp)
    800037d8:	e862                	sd	s8,16(sp)
    800037da:	e466                	sd	s9,8(sp)
    int i = 0;
    800037dc:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800037de:	6b85                	lui	s7,0x1
    800037e0:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800037e4:	6c85                	lui	s9,0x1
    800037e6:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800037ea:	4c05                	li	s8,1
    800037ec:	a8ad                	j	80003866 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    800037ee:	6908                	ld	a0,16(a0)
    800037f0:	1fe000ef          	jal	800039ee <pipewrite>
    800037f4:	a04d                	j	80003896 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800037f6:	02451783          	lh	a5,36(a0)
    800037fa:	03079693          	slli	a3,a5,0x30
    800037fe:	92c1                	srli	a3,a3,0x30
    80003800:	4725                	li	a4,9
    80003802:	0ad76f63          	bltu	a4,a3,800038c0 <filewrite+0x124>
    80003806:	0792                	slli	a5,a5,0x4
    80003808:	00021717          	auipc	a4,0x21
    8000380c:	e3070713          	addi	a4,a4,-464 # 80024638 <devsw>
    80003810:	97ba                	add	a5,a5,a4
    80003812:	679c                	ld	a5,8(a5)
    80003814:	cbc5                	beqz	a5,800038c4 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003816:	4505                	li	a0,1
    80003818:	9782                	jalr	a5
    8000381a:	a8b5                	j	80003896 <filewrite+0xfa>
      if(n1 > max)
    8000381c:	2981                	sext.w	s3,s3
      begin_op();
    8000381e:	981ff0ef          	jal	8000319e <begin_op>
      ilock(f->ip);
    80003822:	01893503          	ld	a0,24(s2)
    80003826:	8c6ff0ef          	jal	800028ec <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000382a:	874e                	mv	a4,s3
    8000382c:	02092683          	lw	a3,32(s2)
    80003830:	016a0633          	add	a2,s4,s6
    80003834:	85e2                	mv	a1,s8
    80003836:	01893503          	ld	a0,24(s2)
    8000383a:	bfcff0ef          	jal	80002c36 <writei>
    8000383e:	84aa                	mv	s1,a0
    80003840:	00a05763          	blez	a0,8000384e <filewrite+0xb2>
        f->off += r;
    80003844:	02092783          	lw	a5,32(s2)
    80003848:	9fa9                	addw	a5,a5,a0
    8000384a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000384e:	01893503          	ld	a0,24(s2)
    80003852:	948ff0ef          	jal	8000299a <iunlock>
      end_op();
    80003856:	9b3ff0ef          	jal	80003208 <end_op>

      if(r != n1){
    8000385a:	02999563          	bne	s3,s1,80003884 <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    8000385e:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003862:	015a5963          	bge	s4,s5,80003874 <filewrite+0xd8>
      int n1 = n - i;
    80003866:	414a87bb          	subw	a5,s5,s4
    8000386a:	89be                	mv	s3,a5
      if(n1 > max)
    8000386c:	fafbd8e3          	bge	s7,a5,8000381c <filewrite+0x80>
    80003870:	89e6                	mv	s3,s9
    80003872:	b76d                	j	8000381c <filewrite+0x80>
    80003874:	64a6                	ld	s1,72(sp)
    80003876:	79e2                	ld	s3,56(sp)
    80003878:	6be2                	ld	s7,24(sp)
    8000387a:	6c42                	ld	s8,16(sp)
    8000387c:	6ca2                	ld	s9,8(sp)
    8000387e:	a801                	j	8000388e <filewrite+0xf2>
    int i = 0;
    80003880:	4a01                	li	s4,0
    80003882:	a031                	j	8000388e <filewrite+0xf2>
    80003884:	64a6                	ld	s1,72(sp)
    80003886:	79e2                	ld	s3,56(sp)
    80003888:	6be2                	ld	s7,24(sp)
    8000388a:	6c42                	ld	s8,16(sp)
    8000388c:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000388e:	034a9d63          	bne	s5,s4,800038c8 <filewrite+0x12c>
    80003892:	8556                	mv	a0,s5
    80003894:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003896:	60e6                	ld	ra,88(sp)
    80003898:	6446                	ld	s0,80(sp)
    8000389a:	6906                	ld	s2,64(sp)
    8000389c:	7aa2                	ld	s5,40(sp)
    8000389e:	7b02                	ld	s6,32(sp)
    800038a0:	6125                	addi	sp,sp,96
    800038a2:	8082                	ret
    800038a4:	e4a6                	sd	s1,72(sp)
    800038a6:	fc4e                	sd	s3,56(sp)
    800038a8:	f852                	sd	s4,48(sp)
    800038aa:	ec5e                	sd	s7,24(sp)
    800038ac:	e862                	sd	s8,16(sp)
    800038ae:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800038b0:	00004517          	auipc	a0,0x4
    800038b4:	d7050513          	addi	a0,a0,-656 # 80007620 <etext+0x620>
    800038b8:	19e020ef          	jal	80005a56 <panic>
    return -1;
    800038bc:	557d                	li	a0,-1
}
    800038be:	8082                	ret
      return -1;
    800038c0:	557d                	li	a0,-1
    800038c2:	bfd1                	j	80003896 <filewrite+0xfa>
    800038c4:	557d                	li	a0,-1
    800038c6:	bfc1                	j	80003896 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    800038c8:	557d                	li	a0,-1
    800038ca:	7a42                	ld	s4,48(sp)
    800038cc:	b7e9                	j	80003896 <filewrite+0xfa>

00000000800038ce <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800038ce:	7179                	addi	sp,sp,-48
    800038d0:	f406                	sd	ra,40(sp)
    800038d2:	f022                	sd	s0,32(sp)
    800038d4:	ec26                	sd	s1,24(sp)
    800038d6:	e052                	sd	s4,0(sp)
    800038d8:	1800                	addi	s0,sp,48
    800038da:	84aa                	mv	s1,a0
    800038dc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800038de:	0005b023          	sd	zero,0(a1)
    800038e2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800038e6:	c35ff0ef          	jal	8000351a <filealloc>
    800038ea:	e088                	sd	a0,0(s1)
    800038ec:	c549                	beqz	a0,80003976 <pipealloc+0xa8>
    800038ee:	c2dff0ef          	jal	8000351a <filealloc>
    800038f2:	00aa3023          	sd	a0,0(s4)
    800038f6:	cd25                	beqz	a0,8000396e <pipealloc+0xa0>
    800038f8:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800038fa:	805fc0ef          	jal	800000fe <kalloc>
    800038fe:	892a                	mv	s2,a0
    80003900:	c12d                	beqz	a0,80003962 <pipealloc+0x94>
    80003902:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003904:	4985                	li	s3,1
    80003906:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000390a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000390e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003912:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003916:	00004597          	auipc	a1,0x4
    8000391a:	d1a58593          	addi	a1,a1,-742 # 80007630 <etext+0x630>
    8000391e:	3e2020ef          	jal	80005d00 <initlock>
  (*f0)->type = FD_PIPE;
    80003922:	609c                	ld	a5,0(s1)
    80003924:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003928:	609c                	ld	a5,0(s1)
    8000392a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000392e:	609c                	ld	a5,0(s1)
    80003930:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003934:	609c                	ld	a5,0(s1)
    80003936:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000393a:	000a3783          	ld	a5,0(s4)
    8000393e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003942:	000a3783          	ld	a5,0(s4)
    80003946:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000394a:	000a3783          	ld	a5,0(s4)
    8000394e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003952:	000a3783          	ld	a5,0(s4)
    80003956:	0127b823          	sd	s2,16(a5)
  return 0;
    8000395a:	4501                	li	a0,0
    8000395c:	6942                	ld	s2,16(sp)
    8000395e:	69a2                	ld	s3,8(sp)
    80003960:	a01d                	j	80003986 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003962:	6088                	ld	a0,0(s1)
    80003964:	c119                	beqz	a0,8000396a <pipealloc+0x9c>
    80003966:	6942                	ld	s2,16(sp)
    80003968:	a029                	j	80003972 <pipealloc+0xa4>
    8000396a:	6942                	ld	s2,16(sp)
    8000396c:	a029                	j	80003976 <pipealloc+0xa8>
    8000396e:	6088                	ld	a0,0(s1)
    80003970:	c10d                	beqz	a0,80003992 <pipealloc+0xc4>
    fileclose(*f0);
    80003972:	c4dff0ef          	jal	800035be <fileclose>
  if(*f1)
    80003976:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000397a:	557d                	li	a0,-1
  if(*f1)
    8000397c:	c789                	beqz	a5,80003986 <pipealloc+0xb8>
    fileclose(*f1);
    8000397e:	853e                	mv	a0,a5
    80003980:	c3fff0ef          	jal	800035be <fileclose>
  return -1;
    80003984:	557d                	li	a0,-1
}
    80003986:	70a2                	ld	ra,40(sp)
    80003988:	7402                	ld	s0,32(sp)
    8000398a:	64e2                	ld	s1,24(sp)
    8000398c:	6a02                	ld	s4,0(sp)
    8000398e:	6145                	addi	sp,sp,48
    80003990:	8082                	ret
  return -1;
    80003992:	557d                	li	a0,-1
    80003994:	bfcd                	j	80003986 <pipealloc+0xb8>

0000000080003996 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003996:	1101                	addi	sp,sp,-32
    80003998:	ec06                	sd	ra,24(sp)
    8000399a:	e822                	sd	s0,16(sp)
    8000399c:	e426                	sd	s1,8(sp)
    8000399e:	e04a                	sd	s2,0(sp)
    800039a0:	1000                	addi	s0,sp,32
    800039a2:	84aa                	mv	s1,a0
    800039a4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800039a6:	3de020ef          	jal	80005d84 <acquire>
  if(writable){
    800039aa:	02090763          	beqz	s2,800039d8 <pipeclose+0x42>
    pi->writeopen = 0;
    800039ae:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800039b2:	21848513          	addi	a0,s1,536
    800039b6:	ab3fd0ef          	jal	80001468 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800039ba:	2204b783          	ld	a5,544(s1)
    800039be:	e785                	bnez	a5,800039e6 <pipeclose+0x50>
    release(&pi->lock);
    800039c0:	8526                	mv	a0,s1
    800039c2:	456020ef          	jal	80005e18 <release>
    kfree((char*)pi);
    800039c6:	8526                	mv	a0,s1
    800039c8:	e54fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800039cc:	60e2                	ld	ra,24(sp)
    800039ce:	6442                	ld	s0,16(sp)
    800039d0:	64a2                	ld	s1,8(sp)
    800039d2:	6902                	ld	s2,0(sp)
    800039d4:	6105                	addi	sp,sp,32
    800039d6:	8082                	ret
    pi->readopen = 0;
    800039d8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800039dc:	21c48513          	addi	a0,s1,540
    800039e0:	a89fd0ef          	jal	80001468 <wakeup>
    800039e4:	bfd9                	j	800039ba <pipeclose+0x24>
    release(&pi->lock);
    800039e6:	8526                	mv	a0,s1
    800039e8:	430020ef          	jal	80005e18 <release>
}
    800039ec:	b7c5                	j	800039cc <pipeclose+0x36>

00000000800039ee <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800039ee:	7159                	addi	sp,sp,-112
    800039f0:	f486                	sd	ra,104(sp)
    800039f2:	f0a2                	sd	s0,96(sp)
    800039f4:	eca6                	sd	s1,88(sp)
    800039f6:	e8ca                	sd	s2,80(sp)
    800039f8:	e4ce                	sd	s3,72(sp)
    800039fa:	e0d2                	sd	s4,64(sp)
    800039fc:	fc56                	sd	s5,56(sp)
    800039fe:	1880                	addi	s0,sp,112
    80003a00:	84aa                	mv	s1,a0
    80003a02:	8aae                	mv	s5,a1
    80003a04:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003a06:	c04fd0ef          	jal	80000e0a <myproc>
    80003a0a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003a0c:	8526                	mv	a0,s1
    80003a0e:	376020ef          	jal	80005d84 <acquire>
  while(i < n){
    80003a12:	0d405263          	blez	s4,80003ad6 <pipewrite+0xe8>
    80003a16:	f85a                	sd	s6,48(sp)
    80003a18:	f45e                	sd	s7,40(sp)
    80003a1a:	f062                	sd	s8,32(sp)
    80003a1c:	ec66                	sd	s9,24(sp)
    80003a1e:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003a20:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a22:	f9f40c13          	addi	s8,s0,-97
    80003a26:	4b85                	li	s7,1
    80003a28:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003a2a:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003a2e:	21c48c93          	addi	s9,s1,540
    80003a32:	a82d                	j	80003a6c <pipewrite+0x7e>
      release(&pi->lock);
    80003a34:	8526                	mv	a0,s1
    80003a36:	3e2020ef          	jal	80005e18 <release>
      return -1;
    80003a3a:	597d                	li	s2,-1
    80003a3c:	7b42                	ld	s6,48(sp)
    80003a3e:	7ba2                	ld	s7,40(sp)
    80003a40:	7c02                	ld	s8,32(sp)
    80003a42:	6ce2                	ld	s9,24(sp)
    80003a44:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003a46:	854a                	mv	a0,s2
    80003a48:	70a6                	ld	ra,104(sp)
    80003a4a:	7406                	ld	s0,96(sp)
    80003a4c:	64e6                	ld	s1,88(sp)
    80003a4e:	6946                	ld	s2,80(sp)
    80003a50:	69a6                	ld	s3,72(sp)
    80003a52:	6a06                	ld	s4,64(sp)
    80003a54:	7ae2                	ld	s5,56(sp)
    80003a56:	6165                	addi	sp,sp,112
    80003a58:	8082                	ret
      wakeup(&pi->nread);
    80003a5a:	856a                	mv	a0,s10
    80003a5c:	a0dfd0ef          	jal	80001468 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003a60:	85a6                	mv	a1,s1
    80003a62:	8566                	mv	a0,s9
    80003a64:	9b9fd0ef          	jal	8000141c <sleep>
  while(i < n){
    80003a68:	05495a63          	bge	s2,s4,80003abc <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80003a6c:	2204a783          	lw	a5,544(s1)
    80003a70:	d3f1                	beqz	a5,80003a34 <pipewrite+0x46>
    80003a72:	854e                	mv	a0,s3
    80003a74:	c27fd0ef          	jal	8000169a <killed>
    80003a78:	fd55                	bnez	a0,80003a34 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003a7a:	2184a783          	lw	a5,536(s1)
    80003a7e:	21c4a703          	lw	a4,540(s1)
    80003a82:	2007879b          	addiw	a5,a5,512
    80003a86:	fcf70ae3          	beq	a4,a5,80003a5a <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a8a:	86de                	mv	a3,s7
    80003a8c:	01590633          	add	a2,s2,s5
    80003a90:	85e2                	mv	a1,s8
    80003a92:	0509b503          	ld	a0,80(s3)
    80003a96:	8ccfd0ef          	jal	80000b62 <copyin>
    80003a9a:	05650063          	beq	a0,s6,80003ada <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003a9e:	21c4a783          	lw	a5,540(s1)
    80003aa2:	0017871b          	addiw	a4,a5,1
    80003aa6:	20e4ae23          	sw	a4,540(s1)
    80003aaa:	1ff7f793          	andi	a5,a5,511
    80003aae:	97a6                	add	a5,a5,s1
    80003ab0:	f9f44703          	lbu	a4,-97(s0)
    80003ab4:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ab8:	2905                	addiw	s2,s2,1
    80003aba:	b77d                	j	80003a68 <pipewrite+0x7a>
    80003abc:	7b42                	ld	s6,48(sp)
    80003abe:	7ba2                	ld	s7,40(sp)
    80003ac0:	7c02                	ld	s8,32(sp)
    80003ac2:	6ce2                	ld	s9,24(sp)
    80003ac4:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003ac6:	21848513          	addi	a0,s1,536
    80003aca:	99ffd0ef          	jal	80001468 <wakeup>
  release(&pi->lock);
    80003ace:	8526                	mv	a0,s1
    80003ad0:	348020ef          	jal	80005e18 <release>
  return i;
    80003ad4:	bf8d                	j	80003a46 <pipewrite+0x58>
  int i = 0;
    80003ad6:	4901                	li	s2,0
    80003ad8:	b7fd                	j	80003ac6 <pipewrite+0xd8>
    80003ada:	7b42                	ld	s6,48(sp)
    80003adc:	7ba2                	ld	s7,40(sp)
    80003ade:	7c02                	ld	s8,32(sp)
    80003ae0:	6ce2                	ld	s9,24(sp)
    80003ae2:	6d42                	ld	s10,16(sp)
    80003ae4:	b7cd                	j	80003ac6 <pipewrite+0xd8>

0000000080003ae6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ae6:	711d                	addi	sp,sp,-96
    80003ae8:	ec86                	sd	ra,88(sp)
    80003aea:	e8a2                	sd	s0,80(sp)
    80003aec:	e4a6                	sd	s1,72(sp)
    80003aee:	e0ca                	sd	s2,64(sp)
    80003af0:	fc4e                	sd	s3,56(sp)
    80003af2:	f852                	sd	s4,48(sp)
    80003af4:	f456                	sd	s5,40(sp)
    80003af6:	1080                	addi	s0,sp,96
    80003af8:	84aa                	mv	s1,a0
    80003afa:	892e                	mv	s2,a1
    80003afc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003afe:	b0cfd0ef          	jal	80000e0a <myproc>
    80003b02:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003b04:	8526                	mv	a0,s1
    80003b06:	27e020ef          	jal	80005d84 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b0a:	2184a703          	lw	a4,536(s1)
    80003b0e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b12:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b16:	02f71763          	bne	a4,a5,80003b44 <piperead+0x5e>
    80003b1a:	2244a783          	lw	a5,548(s1)
    80003b1e:	cf85                	beqz	a5,80003b56 <piperead+0x70>
    if(killed(pr)){
    80003b20:	8552                	mv	a0,s4
    80003b22:	b79fd0ef          	jal	8000169a <killed>
    80003b26:	e11d                	bnez	a0,80003b4c <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b28:	85a6                	mv	a1,s1
    80003b2a:	854e                	mv	a0,s3
    80003b2c:	8f1fd0ef          	jal	8000141c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b30:	2184a703          	lw	a4,536(s1)
    80003b34:	21c4a783          	lw	a5,540(s1)
    80003b38:	fef701e3          	beq	a4,a5,80003b1a <piperead+0x34>
    80003b3c:	f05a                	sd	s6,32(sp)
    80003b3e:	ec5e                	sd	s7,24(sp)
    80003b40:	e862                	sd	s8,16(sp)
    80003b42:	a829                	j	80003b5c <piperead+0x76>
    80003b44:	f05a                	sd	s6,32(sp)
    80003b46:	ec5e                	sd	s7,24(sp)
    80003b48:	e862                	sd	s8,16(sp)
    80003b4a:	a809                	j	80003b5c <piperead+0x76>
      release(&pi->lock);
    80003b4c:	8526                	mv	a0,s1
    80003b4e:	2ca020ef          	jal	80005e18 <release>
      return -1;
    80003b52:	59fd                	li	s3,-1
    80003b54:	a0a5                	j	80003bbc <piperead+0xd6>
    80003b56:	f05a                	sd	s6,32(sp)
    80003b58:	ec5e                	sd	s7,24(sp)
    80003b5a:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b5c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b5e:	faf40c13          	addi	s8,s0,-81
    80003b62:	4b85                	li	s7,1
    80003b64:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b66:	05505163          	blez	s5,80003ba8 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    80003b6a:	2184a783          	lw	a5,536(s1)
    80003b6e:	21c4a703          	lw	a4,540(s1)
    80003b72:	02f70b63          	beq	a4,a5,80003ba8 <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003b76:	0017871b          	addiw	a4,a5,1
    80003b7a:	20e4ac23          	sw	a4,536(s1)
    80003b7e:	1ff7f793          	andi	a5,a5,511
    80003b82:	97a6                	add	a5,a5,s1
    80003b84:	0187c783          	lbu	a5,24(a5)
    80003b88:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b8c:	86de                	mv	a3,s7
    80003b8e:	8662                	mv	a2,s8
    80003b90:	85ca                	mv	a1,s2
    80003b92:	050a3503          	ld	a0,80(s4)
    80003b96:	f1dfc0ef          	jal	80000ab2 <copyout>
    80003b9a:	01650763          	beq	a0,s6,80003ba8 <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b9e:	2985                	addiw	s3,s3,1
    80003ba0:	0905                	addi	s2,s2,1
    80003ba2:	fd3a94e3          	bne	s5,s3,80003b6a <piperead+0x84>
    80003ba6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003ba8:	21c48513          	addi	a0,s1,540
    80003bac:	8bdfd0ef          	jal	80001468 <wakeup>
  release(&pi->lock);
    80003bb0:	8526                	mv	a0,s1
    80003bb2:	266020ef          	jal	80005e18 <release>
    80003bb6:	7b02                	ld	s6,32(sp)
    80003bb8:	6be2                	ld	s7,24(sp)
    80003bba:	6c42                	ld	s8,16(sp)
  return i;
}
    80003bbc:	854e                	mv	a0,s3
    80003bbe:	60e6                	ld	ra,88(sp)
    80003bc0:	6446                	ld	s0,80(sp)
    80003bc2:	64a6                	ld	s1,72(sp)
    80003bc4:	6906                	ld	s2,64(sp)
    80003bc6:	79e2                	ld	s3,56(sp)
    80003bc8:	7a42                	ld	s4,48(sp)
    80003bca:	7aa2                	ld	s5,40(sp)
    80003bcc:	6125                	addi	sp,sp,96
    80003bce:	8082                	ret

0000000080003bd0 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003bd0:	1141                	addi	sp,sp,-16
    80003bd2:	e406                	sd	ra,8(sp)
    80003bd4:	e022                	sd	s0,0(sp)
    80003bd6:	0800                	addi	s0,sp,16
    80003bd8:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003bda:	0035151b          	slliw	a0,a0,0x3
    80003bde:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003be0:	8b89                	andi	a5,a5,2
    80003be2:	c399                	beqz	a5,80003be8 <flags2perm+0x18>
      perm |= PTE_W;
    80003be4:	00456513          	ori	a0,a0,4
    return perm;
}
    80003be8:	60a2                	ld	ra,8(sp)
    80003bea:	6402                	ld	s0,0(sp)
    80003bec:	0141                	addi	sp,sp,16
    80003bee:	8082                	ret

0000000080003bf0 <exec>:

int
exec(char *path, char **argv)
{
    80003bf0:	de010113          	addi	sp,sp,-544
    80003bf4:	20113c23          	sd	ra,536(sp)
    80003bf8:	20813823          	sd	s0,528(sp)
    80003bfc:	20913423          	sd	s1,520(sp)
    80003c00:	21213023          	sd	s2,512(sp)
    80003c04:	1400                	addi	s0,sp,544
    80003c06:	892a                	mv	s2,a0
    80003c08:	dea43823          	sd	a0,-528(s0)
    80003c0c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003c10:	9fafd0ef          	jal	80000e0a <myproc>
    80003c14:	84aa                	mv	s1,a0

  begin_op();
    80003c16:	d88ff0ef          	jal	8000319e <begin_op>

  if((ip = namei(path)) == 0){
    80003c1a:	854a                	mv	a0,s2
    80003c1c:	bc0ff0ef          	jal	80002fdc <namei>
    80003c20:	cd21                	beqz	a0,80003c78 <exec+0x88>
    80003c22:	fbd2                	sd	s4,496(sp)
    80003c24:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003c26:	cc7fe0ef          	jal	800028ec <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003c2a:	04000713          	li	a4,64
    80003c2e:	4681                	li	a3,0
    80003c30:	e5040613          	addi	a2,s0,-432
    80003c34:	4581                	li	a1,0
    80003c36:	8552                	mv	a0,s4
    80003c38:	f0dfe0ef          	jal	80002b44 <readi>
    80003c3c:	04000793          	li	a5,64
    80003c40:	00f51a63          	bne	a0,a5,80003c54 <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003c44:	e5042703          	lw	a4,-432(s0)
    80003c48:	464c47b7          	lui	a5,0x464c4
    80003c4c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003c50:	02f70863          	beq	a4,a5,80003c80 <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003c54:	8552                	mv	a0,s4
    80003c56:	ea1fe0ef          	jal	80002af6 <iunlockput>
    end_op();
    80003c5a:	daeff0ef          	jal	80003208 <end_op>
  }
  return -1;
    80003c5e:	557d                	li	a0,-1
    80003c60:	7a5e                	ld	s4,496(sp)
}
    80003c62:	21813083          	ld	ra,536(sp)
    80003c66:	21013403          	ld	s0,528(sp)
    80003c6a:	20813483          	ld	s1,520(sp)
    80003c6e:	20013903          	ld	s2,512(sp)
    80003c72:	22010113          	addi	sp,sp,544
    80003c76:	8082                	ret
    end_op();
    80003c78:	d90ff0ef          	jal	80003208 <end_op>
    return -1;
    80003c7c:	557d                	li	a0,-1
    80003c7e:	b7d5                	j	80003c62 <exec+0x72>
    80003c80:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003c82:	8526                	mv	a0,s1
    80003c84:	a2efd0ef          	jal	80000eb2 <proc_pagetable>
    80003c88:	8b2a                	mv	s6,a0
    80003c8a:	26050d63          	beqz	a0,80003f04 <exec+0x314>
    80003c8e:	ffce                	sd	s3,504(sp)
    80003c90:	f7d6                	sd	s5,488(sp)
    80003c92:	efde                	sd	s7,472(sp)
    80003c94:	ebe2                	sd	s8,464(sp)
    80003c96:	e7e6                	sd	s9,456(sp)
    80003c98:	e3ea                	sd	s10,448(sp)
    80003c9a:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c9c:	e7042683          	lw	a3,-400(s0)
    80003ca0:	e8845783          	lhu	a5,-376(s0)
    80003ca4:	0e078763          	beqz	a5,80003d92 <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ca8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003caa:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003cac:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003cb0:	6c85                	lui	s9,0x1
    80003cb2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003cb6:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003cba:	6a85                	lui	s5,0x1
    80003cbc:	a085                	j	80003d1c <exec+0x12c>
      panic("loadseg: address should exist");
    80003cbe:	00004517          	auipc	a0,0x4
    80003cc2:	97a50513          	addi	a0,a0,-1670 # 80007638 <etext+0x638>
    80003cc6:	591010ef          	jal	80005a56 <panic>
    if(sz - i < PGSIZE)
    80003cca:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003ccc:	874a                	mv	a4,s2
    80003cce:	009c06bb          	addw	a3,s8,s1
    80003cd2:	4581                	li	a1,0
    80003cd4:	8552                	mv	a0,s4
    80003cd6:	e6ffe0ef          	jal	80002b44 <readi>
    80003cda:	22a91963          	bne	s2,a0,80003f0c <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    80003cde:	009a84bb          	addw	s1,s5,s1
    80003ce2:	0334f263          	bgeu	s1,s3,80003d06 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003ce6:	02049593          	slli	a1,s1,0x20
    80003cea:	9181                	srli	a1,a1,0x20
    80003cec:	95de                	add	a1,a1,s7
    80003cee:	855a                	mv	a0,s6
    80003cf0:	f8cfc0ef          	jal	8000047c <walkaddr>
    80003cf4:	862a                	mv	a2,a0
    if(pa == 0)
    80003cf6:	d561                	beqz	a0,80003cbe <exec+0xce>
    if(sz - i < PGSIZE)
    80003cf8:	409987bb          	subw	a5,s3,s1
    80003cfc:	893e                	mv	s2,a5
    80003cfe:	fcfcf6e3          	bgeu	s9,a5,80003cca <exec+0xda>
    80003d02:	8956                	mv	s2,s5
    80003d04:	b7d9                	j	80003cca <exec+0xda>
    sz = sz1;
    80003d06:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d0a:	2d05                	addiw	s10,s10,1
    80003d0c:	e0843783          	ld	a5,-504(s0)
    80003d10:	0387869b          	addiw	a3,a5,56
    80003d14:	e8845783          	lhu	a5,-376(s0)
    80003d18:	06fd5e63          	bge	s10,a5,80003d94 <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003d1c:	e0d43423          	sd	a3,-504(s0)
    80003d20:	876e                	mv	a4,s11
    80003d22:	e1840613          	addi	a2,s0,-488
    80003d26:	4581                	li	a1,0
    80003d28:	8552                	mv	a0,s4
    80003d2a:	e1bfe0ef          	jal	80002b44 <readi>
    80003d2e:	1db51d63          	bne	a0,s11,80003f08 <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003d32:	e1842783          	lw	a5,-488(s0)
    80003d36:	4705                	li	a4,1
    80003d38:	fce799e3          	bne	a5,a4,80003d0a <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003d3c:	e4043483          	ld	s1,-448(s0)
    80003d40:	e3843783          	ld	a5,-456(s0)
    80003d44:	1ef4e263          	bltu	s1,a5,80003f28 <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003d48:	e2843783          	ld	a5,-472(s0)
    80003d4c:	94be                	add	s1,s1,a5
    80003d4e:	1ef4e063          	bltu	s1,a5,80003f2e <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003d52:	de843703          	ld	a4,-536(s0)
    80003d56:	8ff9                	and	a5,a5,a4
    80003d58:	1c079e63          	bnez	a5,80003f34 <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003d5c:	e1c42503          	lw	a0,-484(s0)
    80003d60:	e71ff0ef          	jal	80003bd0 <flags2perm>
    80003d64:	86aa                	mv	a3,a0
    80003d66:	8626                	mv	a2,s1
    80003d68:	85ca                	mv	a1,s2
    80003d6a:	855a                	mv	a0,s6
    80003d6c:	b27fc0ef          	jal	80000892 <uvmalloc>
    80003d70:	dea43c23          	sd	a0,-520(s0)
    80003d74:	1c050363          	beqz	a0,80003f3a <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d78:	e2843b83          	ld	s7,-472(s0)
    80003d7c:	e2042c03          	lw	s8,-480(s0)
    80003d80:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d84:	00098463          	beqz	s3,80003d8c <exec+0x19c>
    80003d88:	4481                	li	s1,0
    80003d8a:	bfb1                	j	80003ce6 <exec+0xf6>
    sz = sz1;
    80003d8c:	df843903          	ld	s2,-520(s0)
    80003d90:	bfad                	j	80003d0a <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d92:	4901                	li	s2,0
  iunlockput(ip);
    80003d94:	8552                	mv	a0,s4
    80003d96:	d61fe0ef          	jal	80002af6 <iunlockput>
  end_op();
    80003d9a:	c6eff0ef          	jal	80003208 <end_op>
  p = myproc();
    80003d9e:	86cfd0ef          	jal	80000e0a <myproc>
    80003da2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003da4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003da8:	6985                	lui	s3,0x1
    80003daa:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003dac:	99ca                	add	s3,s3,s2
    80003dae:	77fd                	lui	a5,0xfffff
    80003db0:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003db4:	4691                	li	a3,4
    80003db6:	6609                	lui	a2,0x2
    80003db8:	964e                	add	a2,a2,s3
    80003dba:	85ce                	mv	a1,s3
    80003dbc:	855a                	mv	a0,s6
    80003dbe:	ad5fc0ef          	jal	80000892 <uvmalloc>
    80003dc2:	8a2a                	mv	s4,a0
    80003dc4:	e105                	bnez	a0,80003de4 <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003dc6:	85ce                	mv	a1,s3
    80003dc8:	855a                	mv	a0,s6
    80003dca:	96cfd0ef          	jal	80000f36 <proc_freepagetable>
  return -1;
    80003dce:	557d                	li	a0,-1
    80003dd0:	79fe                	ld	s3,504(sp)
    80003dd2:	7a5e                	ld	s4,496(sp)
    80003dd4:	7abe                	ld	s5,488(sp)
    80003dd6:	7b1e                	ld	s6,480(sp)
    80003dd8:	6bfe                	ld	s7,472(sp)
    80003dda:	6c5e                	ld	s8,464(sp)
    80003ddc:	6cbe                	ld	s9,456(sp)
    80003dde:	6d1e                	ld	s10,448(sp)
    80003de0:	7dfa                	ld	s11,440(sp)
    80003de2:	b541                	j	80003c62 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003de4:	75f9                	lui	a1,0xffffe
    80003de6:	95aa                	add	a1,a1,a0
    80003de8:	855a                	mv	a0,s6
    80003dea:	c9ffc0ef          	jal	80000a88 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003dee:	7bfd                	lui	s7,0xfffff
    80003df0:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003df2:	e0043783          	ld	a5,-512(s0)
    80003df6:	6388                	ld	a0,0(a5)
  sp = sz;
    80003df8:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003dfa:	4481                	li	s1,0
    ustack[argc] = sp;
    80003dfc:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003e00:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003e04:	cd21                	beqz	a0,80003e5c <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003e06:	cd0fc0ef          	jal	800002d6 <strlen>
    80003e0a:	0015079b          	addiw	a5,a0,1
    80003e0e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003e12:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003e16:	13796563          	bltu	s2,s7,80003f40 <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003e1a:	e0043d83          	ld	s11,-512(s0)
    80003e1e:	000db983          	ld	s3,0(s11)
    80003e22:	854e                	mv	a0,s3
    80003e24:	cb2fc0ef          	jal	800002d6 <strlen>
    80003e28:	0015069b          	addiw	a3,a0,1
    80003e2c:	864e                	mv	a2,s3
    80003e2e:	85ca                	mv	a1,s2
    80003e30:	855a                	mv	a0,s6
    80003e32:	c81fc0ef          	jal	80000ab2 <copyout>
    80003e36:	10054763          	bltz	a0,80003f44 <exec+0x354>
    ustack[argc] = sp;
    80003e3a:	00349793          	slli	a5,s1,0x3
    80003e3e:	97e6                	add	a5,a5,s9
    80003e40:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffd1730>
  for(argc = 0; argv[argc]; argc++) {
    80003e44:	0485                	addi	s1,s1,1
    80003e46:	008d8793          	addi	a5,s11,8
    80003e4a:	e0f43023          	sd	a5,-512(s0)
    80003e4e:	008db503          	ld	a0,8(s11)
    80003e52:	c509                	beqz	a0,80003e5c <exec+0x26c>
    if(argc >= MAXARG)
    80003e54:	fb8499e3          	bne	s1,s8,80003e06 <exec+0x216>
  sz = sz1;
    80003e58:	89d2                	mv	s3,s4
    80003e5a:	b7b5                	j	80003dc6 <exec+0x1d6>
  ustack[argc] = 0;
    80003e5c:	00349793          	slli	a5,s1,0x3
    80003e60:	f9078793          	addi	a5,a5,-112
    80003e64:	97a2                	add	a5,a5,s0
    80003e66:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003e6a:	00148693          	addi	a3,s1,1
    80003e6e:	068e                	slli	a3,a3,0x3
    80003e70:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003e74:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003e78:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003e7a:	f57966e3          	bltu	s2,s7,80003dc6 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003e7e:	e9040613          	addi	a2,s0,-368
    80003e82:	85ca                	mv	a1,s2
    80003e84:	855a                	mv	a0,s6
    80003e86:	c2dfc0ef          	jal	80000ab2 <copyout>
    80003e8a:	f2054ee3          	bltz	a0,80003dc6 <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003e8e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003e92:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003e96:	df043783          	ld	a5,-528(s0)
    80003e9a:	0007c703          	lbu	a4,0(a5)
    80003e9e:	cf11                	beqz	a4,80003eba <exec+0x2ca>
    80003ea0:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003ea2:	02f00693          	li	a3,47
    80003ea6:	a029                	j	80003eb0 <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003ea8:	0785                	addi	a5,a5,1
    80003eaa:	fff7c703          	lbu	a4,-1(a5)
    80003eae:	c711                	beqz	a4,80003eba <exec+0x2ca>
    if(*s == '/')
    80003eb0:	fed71ce3          	bne	a4,a3,80003ea8 <exec+0x2b8>
      last = s+1;
    80003eb4:	def43823          	sd	a5,-528(s0)
    80003eb8:	bfc5                	j	80003ea8 <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003eba:	4641                	li	a2,16
    80003ebc:	df043583          	ld	a1,-528(s0)
    80003ec0:	3d8a8513          	addi	a0,s5,984
    80003ec4:	bdcfc0ef          	jal	800002a0 <safestrcpy>
  oldpagetable = p->pagetable;
    80003ec8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003ecc:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003ed0:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003ed4:	058ab783          	ld	a5,88(s5)
    80003ed8:	e6843703          	ld	a4,-408(s0)
    80003edc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003ede:	058ab783          	ld	a5,88(s5)
    80003ee2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003ee6:	85ea                	mv	a1,s10
    80003ee8:	84efd0ef          	jal	80000f36 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003eec:	0004851b          	sext.w	a0,s1
    80003ef0:	79fe                	ld	s3,504(sp)
    80003ef2:	7a5e                	ld	s4,496(sp)
    80003ef4:	7abe                	ld	s5,488(sp)
    80003ef6:	7b1e                	ld	s6,480(sp)
    80003ef8:	6bfe                	ld	s7,472(sp)
    80003efa:	6c5e                	ld	s8,464(sp)
    80003efc:	6cbe                	ld	s9,456(sp)
    80003efe:	6d1e                	ld	s10,448(sp)
    80003f00:	7dfa                	ld	s11,440(sp)
    80003f02:	b385                	j	80003c62 <exec+0x72>
    80003f04:	7b1e                	ld	s6,480(sp)
    80003f06:	b3b9                	j	80003c54 <exec+0x64>
    80003f08:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003f0c:	df843583          	ld	a1,-520(s0)
    80003f10:	855a                	mv	a0,s6
    80003f12:	824fd0ef          	jal	80000f36 <proc_freepagetable>
  if(ip){
    80003f16:	79fe                	ld	s3,504(sp)
    80003f18:	7abe                	ld	s5,488(sp)
    80003f1a:	7b1e                	ld	s6,480(sp)
    80003f1c:	6bfe                	ld	s7,472(sp)
    80003f1e:	6c5e                	ld	s8,464(sp)
    80003f20:	6cbe                	ld	s9,456(sp)
    80003f22:	6d1e                	ld	s10,448(sp)
    80003f24:	7dfa                	ld	s11,440(sp)
    80003f26:	b33d                	j	80003c54 <exec+0x64>
    80003f28:	df243c23          	sd	s2,-520(s0)
    80003f2c:	b7c5                	j	80003f0c <exec+0x31c>
    80003f2e:	df243c23          	sd	s2,-520(s0)
    80003f32:	bfe9                	j	80003f0c <exec+0x31c>
    80003f34:	df243c23          	sd	s2,-520(s0)
    80003f38:	bfd1                	j	80003f0c <exec+0x31c>
    80003f3a:	df243c23          	sd	s2,-520(s0)
    80003f3e:	b7f9                	j	80003f0c <exec+0x31c>
  sz = sz1;
    80003f40:	89d2                	mv	s3,s4
    80003f42:	b551                	j	80003dc6 <exec+0x1d6>
    80003f44:	89d2                	mv	s3,s4
    80003f46:	b541                	j	80003dc6 <exec+0x1d6>

0000000080003f48 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003f48:	7179                	addi	sp,sp,-48
    80003f4a:	f406                	sd	ra,40(sp)
    80003f4c:	f022                	sd	s0,32(sp)
    80003f4e:	ec26                	sd	s1,24(sp)
    80003f50:	e84a                	sd	s2,16(sp)
    80003f52:	1800                	addi	s0,sp,48
    80003f54:	892e                	mv	s2,a1
    80003f56:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003f58:	fdc40593          	addi	a1,s0,-36
    80003f5c:	f93fd0ef          	jal	80001eee <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003f60:	fdc42703          	lw	a4,-36(s0)
    80003f64:	47bd                	li	a5,15
    80003f66:	02e7e963          	bltu	a5,a4,80003f98 <argfd+0x50>
    80003f6a:	ea1fc0ef          	jal	80000e0a <myproc>
    80003f6e:	fdc42703          	lw	a4,-36(s0)
    80003f72:	01a70793          	addi	a5,a4,26
    80003f76:	078e                	slli	a5,a5,0x3
    80003f78:	953e                	add	a0,a0,a5
    80003f7a:	611c                	ld	a5,0(a0)
    80003f7c:	c385                	beqz	a5,80003f9c <argfd+0x54>
    return -1;
  if(pfd)
    80003f7e:	00090463          	beqz	s2,80003f86 <argfd+0x3e>
    *pfd = fd;
    80003f82:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003f86:	4501                	li	a0,0
  if(pf)
    80003f88:	c091                	beqz	s1,80003f8c <argfd+0x44>
    *pf = f;
    80003f8a:	e09c                	sd	a5,0(s1)
}
    80003f8c:	70a2                	ld	ra,40(sp)
    80003f8e:	7402                	ld	s0,32(sp)
    80003f90:	64e2                	ld	s1,24(sp)
    80003f92:	6942                	ld	s2,16(sp)
    80003f94:	6145                	addi	sp,sp,48
    80003f96:	8082                	ret
    return -1;
    80003f98:	557d                	li	a0,-1
    80003f9a:	bfcd                	j	80003f8c <argfd+0x44>
    80003f9c:	557d                	li	a0,-1
    80003f9e:	b7fd                	j	80003f8c <argfd+0x44>

0000000080003fa0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003fa0:	1101                	addi	sp,sp,-32
    80003fa2:	ec06                	sd	ra,24(sp)
    80003fa4:	e822                	sd	s0,16(sp)
    80003fa6:	e426                	sd	s1,8(sp)
    80003fa8:	1000                	addi	s0,sp,32
    80003faa:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003fac:	e5ffc0ef          	jal	80000e0a <myproc>
    80003fb0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003fb2:	0d050793          	addi	a5,a0,208
    80003fb6:	4501                	li	a0,0
    80003fb8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003fba:	6398                	ld	a4,0(a5)
    80003fbc:	cb19                	beqz	a4,80003fd2 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003fbe:	2505                	addiw	a0,a0,1
    80003fc0:	07a1                	addi	a5,a5,8
    80003fc2:	fed51ce3          	bne	a0,a3,80003fba <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003fc6:	557d                	li	a0,-1
}
    80003fc8:	60e2                	ld	ra,24(sp)
    80003fca:	6442                	ld	s0,16(sp)
    80003fcc:	64a2                	ld	s1,8(sp)
    80003fce:	6105                	addi	sp,sp,32
    80003fd0:	8082                	ret
      p->ofile[fd] = f;
    80003fd2:	01a50793          	addi	a5,a0,26
    80003fd6:	078e                	slli	a5,a5,0x3
    80003fd8:	963e                	add	a2,a2,a5
    80003fda:	e204                	sd	s1,0(a2)
      return fd;
    80003fdc:	b7f5                	j	80003fc8 <fdalloc+0x28>

0000000080003fde <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003fde:	715d                	addi	sp,sp,-80
    80003fe0:	e486                	sd	ra,72(sp)
    80003fe2:	e0a2                	sd	s0,64(sp)
    80003fe4:	fc26                	sd	s1,56(sp)
    80003fe6:	f84a                	sd	s2,48(sp)
    80003fe8:	f44e                	sd	s3,40(sp)
    80003fea:	ec56                	sd	s5,24(sp)
    80003fec:	e85a                	sd	s6,16(sp)
    80003fee:	0880                	addi	s0,sp,80
    80003ff0:	8b2e                	mv	s6,a1
    80003ff2:	89b2                	mv	s3,a2
    80003ff4:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003ff6:	fb040593          	addi	a1,s0,-80
    80003ffa:	ffdfe0ef          	jal	80002ff6 <nameiparent>
    80003ffe:	84aa                	mv	s1,a0
    80004000:	10050a63          	beqz	a0,80004114 <create+0x136>
    return 0;

  ilock(dp);
    80004004:	8e9fe0ef          	jal	800028ec <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004008:	4601                	li	a2,0
    8000400a:	fb040593          	addi	a1,s0,-80
    8000400e:	8526                	mv	a0,s1
    80004010:	d41fe0ef          	jal	80002d50 <dirlookup>
    80004014:	8aaa                	mv	s5,a0
    80004016:	c129                	beqz	a0,80004058 <create+0x7a>
    iunlockput(dp);
    80004018:	8526                	mv	a0,s1
    8000401a:	addfe0ef          	jal	80002af6 <iunlockput>
    ilock(ip);
    8000401e:	8556                	mv	a0,s5
    80004020:	8cdfe0ef          	jal	800028ec <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004024:	4789                	li	a5,2
    80004026:	02fb1463          	bne	s6,a5,8000404e <create+0x70>
    8000402a:	044ad783          	lhu	a5,68(s5)
    8000402e:	37f9                	addiw	a5,a5,-2
    80004030:	17c2                	slli	a5,a5,0x30
    80004032:	93c1                	srli	a5,a5,0x30
    80004034:	4705                	li	a4,1
    80004036:	00f76c63          	bltu	a4,a5,8000404e <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000403a:	8556                	mv	a0,s5
    8000403c:	60a6                	ld	ra,72(sp)
    8000403e:	6406                	ld	s0,64(sp)
    80004040:	74e2                	ld	s1,56(sp)
    80004042:	7942                	ld	s2,48(sp)
    80004044:	79a2                	ld	s3,40(sp)
    80004046:	6ae2                	ld	s5,24(sp)
    80004048:	6b42                	ld	s6,16(sp)
    8000404a:	6161                	addi	sp,sp,80
    8000404c:	8082                	ret
    iunlockput(ip);
    8000404e:	8556                	mv	a0,s5
    80004050:	aa7fe0ef          	jal	80002af6 <iunlockput>
    return 0;
    80004054:	4a81                	li	s5,0
    80004056:	b7d5                	j	8000403a <create+0x5c>
    80004058:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000405a:	85da                	mv	a1,s6
    8000405c:	4088                	lw	a0,0(s1)
    8000405e:	f1efe0ef          	jal	8000277c <ialloc>
    80004062:	8a2a                	mv	s4,a0
    80004064:	cd15                	beqz	a0,800040a0 <create+0xc2>
  ilock(ip);
    80004066:	887fe0ef          	jal	800028ec <ilock>
  ip->major = major;
    8000406a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000406e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004072:	4905                	li	s2,1
    80004074:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004078:	8552                	mv	a0,s4
    8000407a:	fbefe0ef          	jal	80002838 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000407e:	032b0763          	beq	s6,s2,800040ac <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004082:	004a2603          	lw	a2,4(s4)
    80004086:	fb040593          	addi	a1,s0,-80
    8000408a:	8526                	mv	a0,s1
    8000408c:	ea7fe0ef          	jal	80002f32 <dirlink>
    80004090:	06054563          	bltz	a0,800040fa <create+0x11c>
  iunlockput(dp);
    80004094:	8526                	mv	a0,s1
    80004096:	a61fe0ef          	jal	80002af6 <iunlockput>
  return ip;
    8000409a:	8ad2                	mv	s5,s4
    8000409c:	7a02                	ld	s4,32(sp)
    8000409e:	bf71                	j	8000403a <create+0x5c>
    iunlockput(dp);
    800040a0:	8526                	mv	a0,s1
    800040a2:	a55fe0ef          	jal	80002af6 <iunlockput>
    return 0;
    800040a6:	8ad2                	mv	s5,s4
    800040a8:	7a02                	ld	s4,32(sp)
    800040aa:	bf41                	j	8000403a <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800040ac:	004a2603          	lw	a2,4(s4)
    800040b0:	00003597          	auipc	a1,0x3
    800040b4:	5a858593          	addi	a1,a1,1448 # 80007658 <etext+0x658>
    800040b8:	8552                	mv	a0,s4
    800040ba:	e79fe0ef          	jal	80002f32 <dirlink>
    800040be:	02054e63          	bltz	a0,800040fa <create+0x11c>
    800040c2:	40d0                	lw	a2,4(s1)
    800040c4:	00003597          	auipc	a1,0x3
    800040c8:	59c58593          	addi	a1,a1,1436 # 80007660 <etext+0x660>
    800040cc:	8552                	mv	a0,s4
    800040ce:	e65fe0ef          	jal	80002f32 <dirlink>
    800040d2:	02054463          	bltz	a0,800040fa <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800040d6:	004a2603          	lw	a2,4(s4)
    800040da:	fb040593          	addi	a1,s0,-80
    800040de:	8526                	mv	a0,s1
    800040e0:	e53fe0ef          	jal	80002f32 <dirlink>
    800040e4:	00054b63          	bltz	a0,800040fa <create+0x11c>
    dp->nlink++;  // for ".."
    800040e8:	04a4d783          	lhu	a5,74(s1)
    800040ec:	2785                	addiw	a5,a5,1
    800040ee:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800040f2:	8526                	mv	a0,s1
    800040f4:	f44fe0ef          	jal	80002838 <iupdate>
    800040f8:	bf71                	j	80004094 <create+0xb6>
  ip->nlink = 0;
    800040fa:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800040fe:	8552                	mv	a0,s4
    80004100:	f38fe0ef          	jal	80002838 <iupdate>
  iunlockput(ip);
    80004104:	8552                	mv	a0,s4
    80004106:	9f1fe0ef          	jal	80002af6 <iunlockput>
  iunlockput(dp);
    8000410a:	8526                	mv	a0,s1
    8000410c:	9ebfe0ef          	jal	80002af6 <iunlockput>
  return 0;
    80004110:	7a02                	ld	s4,32(sp)
    80004112:	b725                	j	8000403a <create+0x5c>
    return 0;
    80004114:	8aaa                	mv	s5,a0
    80004116:	b715                	j	8000403a <create+0x5c>

0000000080004118 <sys_dup>:
{
    80004118:	7179                	addi	sp,sp,-48
    8000411a:	f406                	sd	ra,40(sp)
    8000411c:	f022                	sd	s0,32(sp)
    8000411e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004120:	fd840613          	addi	a2,s0,-40
    80004124:	4581                	li	a1,0
    80004126:	4501                	li	a0,0
    80004128:	e21ff0ef          	jal	80003f48 <argfd>
    return -1;
    8000412c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000412e:	02054363          	bltz	a0,80004154 <sys_dup+0x3c>
    80004132:	ec26                	sd	s1,24(sp)
    80004134:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004136:	fd843903          	ld	s2,-40(s0)
    8000413a:	854a                	mv	a0,s2
    8000413c:	e65ff0ef          	jal	80003fa0 <fdalloc>
    80004140:	84aa                	mv	s1,a0
    return -1;
    80004142:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004144:	00054d63          	bltz	a0,8000415e <sys_dup+0x46>
  filedup(f);
    80004148:	854a                	mv	a0,s2
    8000414a:	c2eff0ef          	jal	80003578 <filedup>
  return fd;
    8000414e:	87a6                	mv	a5,s1
    80004150:	64e2                	ld	s1,24(sp)
    80004152:	6942                	ld	s2,16(sp)
}
    80004154:	853e                	mv	a0,a5
    80004156:	70a2                	ld	ra,40(sp)
    80004158:	7402                	ld	s0,32(sp)
    8000415a:	6145                	addi	sp,sp,48
    8000415c:	8082                	ret
    8000415e:	64e2                	ld	s1,24(sp)
    80004160:	6942                	ld	s2,16(sp)
    80004162:	bfcd                	j	80004154 <sys_dup+0x3c>

0000000080004164 <sys_read>:
{
    80004164:	7179                	addi	sp,sp,-48
    80004166:	f406                	sd	ra,40(sp)
    80004168:	f022                	sd	s0,32(sp)
    8000416a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000416c:	fd840593          	addi	a1,s0,-40
    80004170:	4505                	li	a0,1
    80004172:	d99fd0ef          	jal	80001f0a <argaddr>
  argint(2, &n);
    80004176:	fe440593          	addi	a1,s0,-28
    8000417a:	4509                	li	a0,2
    8000417c:	d73fd0ef          	jal	80001eee <argint>
  if(argfd(0, 0, &f) < 0)
    80004180:	fe840613          	addi	a2,s0,-24
    80004184:	4581                	li	a1,0
    80004186:	4501                	li	a0,0
    80004188:	dc1ff0ef          	jal	80003f48 <argfd>
    8000418c:	87aa                	mv	a5,a0
    return -1;
    8000418e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004190:	0007ca63          	bltz	a5,800041a4 <sys_read+0x40>
  return fileread(f, p, n);
    80004194:	fe442603          	lw	a2,-28(s0)
    80004198:	fd843583          	ld	a1,-40(s0)
    8000419c:	fe843503          	ld	a0,-24(s0)
    800041a0:	d3eff0ef          	jal	800036de <fileread>
}
    800041a4:	70a2                	ld	ra,40(sp)
    800041a6:	7402                	ld	s0,32(sp)
    800041a8:	6145                	addi	sp,sp,48
    800041aa:	8082                	ret

00000000800041ac <sys_write>:
{
    800041ac:	7179                	addi	sp,sp,-48
    800041ae:	f406                	sd	ra,40(sp)
    800041b0:	f022                	sd	s0,32(sp)
    800041b2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800041b4:	fd840593          	addi	a1,s0,-40
    800041b8:	4505                	li	a0,1
    800041ba:	d51fd0ef          	jal	80001f0a <argaddr>
  argint(2, &n);
    800041be:	fe440593          	addi	a1,s0,-28
    800041c2:	4509                	li	a0,2
    800041c4:	d2bfd0ef          	jal	80001eee <argint>
  if(argfd(0, 0, &f) < 0)
    800041c8:	fe840613          	addi	a2,s0,-24
    800041cc:	4581                	li	a1,0
    800041ce:	4501                	li	a0,0
    800041d0:	d79ff0ef          	jal	80003f48 <argfd>
    800041d4:	87aa                	mv	a5,a0
    return -1;
    800041d6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800041d8:	0007ca63          	bltz	a5,800041ec <sys_write+0x40>
  return filewrite(f, p, n);
    800041dc:	fe442603          	lw	a2,-28(s0)
    800041e0:	fd843583          	ld	a1,-40(s0)
    800041e4:	fe843503          	ld	a0,-24(s0)
    800041e8:	db4ff0ef          	jal	8000379c <filewrite>
}
    800041ec:	70a2                	ld	ra,40(sp)
    800041ee:	7402                	ld	s0,32(sp)
    800041f0:	6145                	addi	sp,sp,48
    800041f2:	8082                	ret

00000000800041f4 <sys_close>:
{
    800041f4:	1101                	addi	sp,sp,-32
    800041f6:	ec06                	sd	ra,24(sp)
    800041f8:	e822                	sd	s0,16(sp)
    800041fa:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800041fc:	fe040613          	addi	a2,s0,-32
    80004200:	fec40593          	addi	a1,s0,-20
    80004204:	4501                	li	a0,0
    80004206:	d43ff0ef          	jal	80003f48 <argfd>
    return -1;
    8000420a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000420c:	02054063          	bltz	a0,8000422c <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004210:	bfbfc0ef          	jal	80000e0a <myproc>
    80004214:	fec42783          	lw	a5,-20(s0)
    80004218:	07e9                	addi	a5,a5,26
    8000421a:	078e                	slli	a5,a5,0x3
    8000421c:	953e                	add	a0,a0,a5
    8000421e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004222:	fe043503          	ld	a0,-32(s0)
    80004226:	b98ff0ef          	jal	800035be <fileclose>
  return 0;
    8000422a:	4781                	li	a5,0
}
    8000422c:	853e                	mv	a0,a5
    8000422e:	60e2                	ld	ra,24(sp)
    80004230:	6442                	ld	s0,16(sp)
    80004232:	6105                	addi	sp,sp,32
    80004234:	8082                	ret

0000000080004236 <sys_fstat>:
{
    80004236:	1101                	addi	sp,sp,-32
    80004238:	ec06                	sd	ra,24(sp)
    8000423a:	e822                	sd	s0,16(sp)
    8000423c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000423e:	fe040593          	addi	a1,s0,-32
    80004242:	4505                	li	a0,1
    80004244:	cc7fd0ef          	jal	80001f0a <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004248:	fe840613          	addi	a2,s0,-24
    8000424c:	4581                	li	a1,0
    8000424e:	4501                	li	a0,0
    80004250:	cf9ff0ef          	jal	80003f48 <argfd>
    80004254:	87aa                	mv	a5,a0
    return -1;
    80004256:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004258:	0007c863          	bltz	a5,80004268 <sys_fstat+0x32>
  return filestat(f, st);
    8000425c:	fe043583          	ld	a1,-32(s0)
    80004260:	fe843503          	ld	a0,-24(s0)
    80004264:	c18ff0ef          	jal	8000367c <filestat>
}
    80004268:	60e2                	ld	ra,24(sp)
    8000426a:	6442                	ld	s0,16(sp)
    8000426c:	6105                	addi	sp,sp,32
    8000426e:	8082                	ret

0000000080004270 <sys_link>:
{
    80004270:	7169                	addi	sp,sp,-304
    80004272:	f606                	sd	ra,296(sp)
    80004274:	f222                	sd	s0,288(sp)
    80004276:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004278:	08000613          	li	a2,128
    8000427c:	ed040593          	addi	a1,s0,-304
    80004280:	4501                	li	a0,0
    80004282:	ca5fd0ef          	jal	80001f26 <argstr>
    return -1;
    80004286:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004288:	0c054e63          	bltz	a0,80004364 <sys_link+0xf4>
    8000428c:	08000613          	li	a2,128
    80004290:	f5040593          	addi	a1,s0,-176
    80004294:	4505                	li	a0,1
    80004296:	c91fd0ef          	jal	80001f26 <argstr>
    return -1;
    8000429a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000429c:	0c054463          	bltz	a0,80004364 <sys_link+0xf4>
    800042a0:	ee26                	sd	s1,280(sp)
  begin_op();
    800042a2:	efdfe0ef          	jal	8000319e <begin_op>
  if((ip = namei(old)) == 0){
    800042a6:	ed040513          	addi	a0,s0,-304
    800042aa:	d33fe0ef          	jal	80002fdc <namei>
    800042ae:	84aa                	mv	s1,a0
    800042b0:	c53d                	beqz	a0,8000431e <sys_link+0xae>
  ilock(ip);
    800042b2:	e3afe0ef          	jal	800028ec <ilock>
  if(ip->type == T_DIR){
    800042b6:	04449703          	lh	a4,68(s1)
    800042ba:	4785                	li	a5,1
    800042bc:	06f70663          	beq	a4,a5,80004328 <sys_link+0xb8>
    800042c0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800042c2:	04a4d783          	lhu	a5,74(s1)
    800042c6:	2785                	addiw	a5,a5,1
    800042c8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800042cc:	8526                	mv	a0,s1
    800042ce:	d6afe0ef          	jal	80002838 <iupdate>
  iunlock(ip);
    800042d2:	8526                	mv	a0,s1
    800042d4:	ec6fe0ef          	jal	8000299a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800042d8:	fd040593          	addi	a1,s0,-48
    800042dc:	f5040513          	addi	a0,s0,-176
    800042e0:	d17fe0ef          	jal	80002ff6 <nameiparent>
    800042e4:	892a                	mv	s2,a0
    800042e6:	cd21                	beqz	a0,8000433e <sys_link+0xce>
  ilock(dp);
    800042e8:	e04fe0ef          	jal	800028ec <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800042ec:	00092703          	lw	a4,0(s2)
    800042f0:	409c                	lw	a5,0(s1)
    800042f2:	04f71363          	bne	a4,a5,80004338 <sys_link+0xc8>
    800042f6:	40d0                	lw	a2,4(s1)
    800042f8:	fd040593          	addi	a1,s0,-48
    800042fc:	854a                	mv	a0,s2
    800042fe:	c35fe0ef          	jal	80002f32 <dirlink>
    80004302:	02054b63          	bltz	a0,80004338 <sys_link+0xc8>
  iunlockput(dp);
    80004306:	854a                	mv	a0,s2
    80004308:	feefe0ef          	jal	80002af6 <iunlockput>
  iput(ip);
    8000430c:	8526                	mv	a0,s1
    8000430e:	f60fe0ef          	jal	80002a6e <iput>
  end_op();
    80004312:	ef7fe0ef          	jal	80003208 <end_op>
  return 0;
    80004316:	4781                	li	a5,0
    80004318:	64f2                	ld	s1,280(sp)
    8000431a:	6952                	ld	s2,272(sp)
    8000431c:	a0a1                	j	80004364 <sys_link+0xf4>
    end_op();
    8000431e:	eebfe0ef          	jal	80003208 <end_op>
    return -1;
    80004322:	57fd                	li	a5,-1
    80004324:	64f2                	ld	s1,280(sp)
    80004326:	a83d                	j	80004364 <sys_link+0xf4>
    iunlockput(ip);
    80004328:	8526                	mv	a0,s1
    8000432a:	fccfe0ef          	jal	80002af6 <iunlockput>
    end_op();
    8000432e:	edbfe0ef          	jal	80003208 <end_op>
    return -1;
    80004332:	57fd                	li	a5,-1
    80004334:	64f2                	ld	s1,280(sp)
    80004336:	a03d                	j	80004364 <sys_link+0xf4>
    iunlockput(dp);
    80004338:	854a                	mv	a0,s2
    8000433a:	fbcfe0ef          	jal	80002af6 <iunlockput>
  ilock(ip);
    8000433e:	8526                	mv	a0,s1
    80004340:	dacfe0ef          	jal	800028ec <ilock>
  ip->nlink--;
    80004344:	04a4d783          	lhu	a5,74(s1)
    80004348:	37fd                	addiw	a5,a5,-1
    8000434a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000434e:	8526                	mv	a0,s1
    80004350:	ce8fe0ef          	jal	80002838 <iupdate>
  iunlockput(ip);
    80004354:	8526                	mv	a0,s1
    80004356:	fa0fe0ef          	jal	80002af6 <iunlockput>
  end_op();
    8000435a:	eaffe0ef          	jal	80003208 <end_op>
  return -1;
    8000435e:	57fd                	li	a5,-1
    80004360:	64f2                	ld	s1,280(sp)
    80004362:	6952                	ld	s2,272(sp)
}
    80004364:	853e                	mv	a0,a5
    80004366:	70b2                	ld	ra,296(sp)
    80004368:	7412                	ld	s0,288(sp)
    8000436a:	6155                	addi	sp,sp,304
    8000436c:	8082                	ret

000000008000436e <sys_unlink>:
{
    8000436e:	7111                	addi	sp,sp,-256
    80004370:	fd86                	sd	ra,248(sp)
    80004372:	f9a2                	sd	s0,240(sp)
    80004374:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80004376:	08000613          	li	a2,128
    8000437a:	f2040593          	addi	a1,s0,-224
    8000437e:	4501                	li	a0,0
    80004380:	ba7fd0ef          	jal	80001f26 <argstr>
    80004384:	16054663          	bltz	a0,800044f0 <sys_unlink+0x182>
    80004388:	f5a6                	sd	s1,232(sp)
  begin_op();
    8000438a:	e15fe0ef          	jal	8000319e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000438e:	fa040593          	addi	a1,s0,-96
    80004392:	f2040513          	addi	a0,s0,-224
    80004396:	c61fe0ef          	jal	80002ff6 <nameiparent>
    8000439a:	84aa                	mv	s1,a0
    8000439c:	c955                	beqz	a0,80004450 <sys_unlink+0xe2>
  ilock(dp);
    8000439e:	d4efe0ef          	jal	800028ec <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800043a2:	00003597          	auipc	a1,0x3
    800043a6:	2b658593          	addi	a1,a1,694 # 80007658 <etext+0x658>
    800043aa:	fa040513          	addi	a0,s0,-96
    800043ae:	98dfe0ef          	jal	80002d3a <namecmp>
    800043b2:	12050463          	beqz	a0,800044da <sys_unlink+0x16c>
    800043b6:	00003597          	auipc	a1,0x3
    800043ba:	2aa58593          	addi	a1,a1,682 # 80007660 <etext+0x660>
    800043be:	fa040513          	addi	a0,s0,-96
    800043c2:	979fe0ef          	jal	80002d3a <namecmp>
    800043c6:	10050a63          	beqz	a0,800044da <sys_unlink+0x16c>
    800043ca:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800043cc:	f1c40613          	addi	a2,s0,-228
    800043d0:	fa040593          	addi	a1,s0,-96
    800043d4:	8526                	mv	a0,s1
    800043d6:	97bfe0ef          	jal	80002d50 <dirlookup>
    800043da:	892a                	mv	s2,a0
    800043dc:	0e050e63          	beqz	a0,800044d8 <sys_unlink+0x16a>
    800043e0:	edce                	sd	s3,216(sp)
  ilock(ip);
    800043e2:	d0afe0ef          	jal	800028ec <ilock>
  if(ip->nlink < 1)
    800043e6:	04a91783          	lh	a5,74(s2)
    800043ea:	06f05863          	blez	a5,8000445a <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800043ee:	04491703          	lh	a4,68(s2)
    800043f2:	4785                	li	a5,1
    800043f4:	06f70b63          	beq	a4,a5,8000446a <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    800043f8:	fb040993          	addi	s3,s0,-80
    800043fc:	4641                	li	a2,16
    800043fe:	4581                	li	a1,0
    80004400:	854e                	mv	a0,s3
    80004402:	d4dfb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004406:	4741                	li	a4,16
    80004408:	f1c42683          	lw	a3,-228(s0)
    8000440c:	864e                	mv	a2,s3
    8000440e:	4581                	li	a1,0
    80004410:	8526                	mv	a0,s1
    80004412:	825fe0ef          	jal	80002c36 <writei>
    80004416:	47c1                	li	a5,16
    80004418:	08f51f63          	bne	a0,a5,800044b6 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    8000441c:	04491703          	lh	a4,68(s2)
    80004420:	4785                	li	a5,1
    80004422:	0af70263          	beq	a4,a5,800044c6 <sys_unlink+0x158>
  iunlockput(dp);
    80004426:	8526                	mv	a0,s1
    80004428:	ecefe0ef          	jal	80002af6 <iunlockput>
  ip->nlink--;
    8000442c:	04a95783          	lhu	a5,74(s2)
    80004430:	37fd                	addiw	a5,a5,-1
    80004432:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004436:	854a                	mv	a0,s2
    80004438:	c00fe0ef          	jal	80002838 <iupdate>
  iunlockput(ip);
    8000443c:	854a                	mv	a0,s2
    8000443e:	eb8fe0ef          	jal	80002af6 <iunlockput>
  end_op();
    80004442:	dc7fe0ef          	jal	80003208 <end_op>
  return 0;
    80004446:	4501                	li	a0,0
    80004448:	74ae                	ld	s1,232(sp)
    8000444a:	790e                	ld	s2,224(sp)
    8000444c:	69ee                	ld	s3,216(sp)
    8000444e:	a869                	j	800044e8 <sys_unlink+0x17a>
    end_op();
    80004450:	db9fe0ef          	jal	80003208 <end_op>
    return -1;
    80004454:	557d                	li	a0,-1
    80004456:	74ae                	ld	s1,232(sp)
    80004458:	a841                	j	800044e8 <sys_unlink+0x17a>
    8000445a:	e9d2                	sd	s4,208(sp)
    8000445c:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    8000445e:	00003517          	auipc	a0,0x3
    80004462:	20a50513          	addi	a0,a0,522 # 80007668 <etext+0x668>
    80004466:	5f0010ef          	jal	80005a56 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000446a:	04c92703          	lw	a4,76(s2)
    8000446e:	02000793          	li	a5,32
    80004472:	f8e7f3e3          	bgeu	a5,a4,800043f8 <sys_unlink+0x8a>
    80004476:	e9d2                	sd	s4,208(sp)
    80004478:	e5d6                	sd	s5,200(sp)
    8000447a:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000447c:	f0840a93          	addi	s5,s0,-248
    80004480:	4a41                	li	s4,16
    80004482:	8752                	mv	a4,s4
    80004484:	86ce                	mv	a3,s3
    80004486:	8656                	mv	a2,s5
    80004488:	4581                	li	a1,0
    8000448a:	854a                	mv	a0,s2
    8000448c:	eb8fe0ef          	jal	80002b44 <readi>
    80004490:	01451d63          	bne	a0,s4,800044aa <sys_unlink+0x13c>
    if(de.inum != 0)
    80004494:	f0845783          	lhu	a5,-248(s0)
    80004498:	efb1                	bnez	a5,800044f4 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000449a:	29c1                	addiw	s3,s3,16
    8000449c:	04c92783          	lw	a5,76(s2)
    800044a0:	fef9e1e3          	bltu	s3,a5,80004482 <sys_unlink+0x114>
    800044a4:	6a4e                	ld	s4,208(sp)
    800044a6:	6aae                	ld	s5,200(sp)
    800044a8:	bf81                	j	800043f8 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800044aa:	00003517          	auipc	a0,0x3
    800044ae:	1d650513          	addi	a0,a0,470 # 80007680 <etext+0x680>
    800044b2:	5a4010ef          	jal	80005a56 <panic>
    800044b6:	e9d2                	sd	s4,208(sp)
    800044b8:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    800044ba:	00003517          	auipc	a0,0x3
    800044be:	1de50513          	addi	a0,a0,478 # 80007698 <etext+0x698>
    800044c2:	594010ef          	jal	80005a56 <panic>
    dp->nlink--;
    800044c6:	04a4d783          	lhu	a5,74(s1)
    800044ca:	37fd                	addiw	a5,a5,-1
    800044cc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800044d0:	8526                	mv	a0,s1
    800044d2:	b66fe0ef          	jal	80002838 <iupdate>
    800044d6:	bf81                	j	80004426 <sys_unlink+0xb8>
    800044d8:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    800044da:	8526                	mv	a0,s1
    800044dc:	e1afe0ef          	jal	80002af6 <iunlockput>
  end_op();
    800044e0:	d29fe0ef          	jal	80003208 <end_op>
  return -1;
    800044e4:	557d                	li	a0,-1
    800044e6:	74ae                	ld	s1,232(sp)
}
    800044e8:	70ee                	ld	ra,248(sp)
    800044ea:	744e                	ld	s0,240(sp)
    800044ec:	6111                	addi	sp,sp,256
    800044ee:	8082                	ret
    return -1;
    800044f0:	557d                	li	a0,-1
    800044f2:	bfdd                	j	800044e8 <sys_unlink+0x17a>
    iunlockput(ip);
    800044f4:	854a                	mv	a0,s2
    800044f6:	e00fe0ef          	jal	80002af6 <iunlockput>
    goto bad;
    800044fa:	790e                	ld	s2,224(sp)
    800044fc:	69ee                	ld	s3,216(sp)
    800044fe:	6a4e                	ld	s4,208(sp)
    80004500:	6aae                	ld	s5,200(sp)
    80004502:	bfe1                	j	800044da <sys_unlink+0x16c>

0000000080004504 <sys_open>:

uint64
sys_open(void)
{
    80004504:	7131                	addi	sp,sp,-192
    80004506:	fd06                	sd	ra,184(sp)
    80004508:	f922                	sd	s0,176(sp)
    8000450a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000450c:	f4c40593          	addi	a1,s0,-180
    80004510:	4505                	li	a0,1
    80004512:	9ddfd0ef          	jal	80001eee <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004516:	08000613          	li	a2,128
    8000451a:	f5040593          	addi	a1,s0,-176
    8000451e:	4501                	li	a0,0
    80004520:	a07fd0ef          	jal	80001f26 <argstr>
    80004524:	87aa                	mv	a5,a0
    return -1;
    80004526:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004528:	0a07c363          	bltz	a5,800045ce <sys_open+0xca>
    8000452c:	f526                	sd	s1,168(sp)

  begin_op();
    8000452e:	c71fe0ef          	jal	8000319e <begin_op>

  if(omode & O_CREATE){
    80004532:	f4c42783          	lw	a5,-180(s0)
    80004536:	2007f793          	andi	a5,a5,512
    8000453a:	c3dd                	beqz	a5,800045e0 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000453c:	4681                	li	a3,0
    8000453e:	4601                	li	a2,0
    80004540:	4589                	li	a1,2
    80004542:	f5040513          	addi	a0,s0,-176
    80004546:	a99ff0ef          	jal	80003fde <create>
    8000454a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000454c:	c549                	beqz	a0,800045d6 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000454e:	04449703          	lh	a4,68(s1)
    80004552:	478d                	li	a5,3
    80004554:	00f71763          	bne	a4,a5,80004562 <sys_open+0x5e>
    80004558:	0464d703          	lhu	a4,70(s1)
    8000455c:	47a5                	li	a5,9
    8000455e:	0ae7ee63          	bltu	a5,a4,8000461a <sys_open+0x116>
    80004562:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004564:	fb7fe0ef          	jal	8000351a <filealloc>
    80004568:	892a                	mv	s2,a0
    8000456a:	c561                	beqz	a0,80004632 <sys_open+0x12e>
    8000456c:	ed4e                	sd	s3,152(sp)
    8000456e:	a33ff0ef          	jal	80003fa0 <fdalloc>
    80004572:	89aa                	mv	s3,a0
    80004574:	0a054b63          	bltz	a0,8000462a <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004578:	04449703          	lh	a4,68(s1)
    8000457c:	478d                	li	a5,3
    8000457e:	0cf70363          	beq	a4,a5,80004644 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004582:	4789                	li	a5,2
    80004584:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004588:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000458c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004590:	f4c42783          	lw	a5,-180(s0)
    80004594:	0017f713          	andi	a4,a5,1
    80004598:	00174713          	xori	a4,a4,1
    8000459c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800045a0:	0037f713          	andi	a4,a5,3
    800045a4:	00e03733          	snez	a4,a4
    800045a8:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800045ac:	4007f793          	andi	a5,a5,1024
    800045b0:	c791                	beqz	a5,800045bc <sys_open+0xb8>
    800045b2:	04449703          	lh	a4,68(s1)
    800045b6:	4789                	li	a5,2
    800045b8:	08f70d63          	beq	a4,a5,80004652 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800045bc:	8526                	mv	a0,s1
    800045be:	bdcfe0ef          	jal	8000299a <iunlock>
  end_op();
    800045c2:	c47fe0ef          	jal	80003208 <end_op>

  return fd;
    800045c6:	854e                	mv	a0,s3
    800045c8:	74aa                	ld	s1,168(sp)
    800045ca:	790a                	ld	s2,160(sp)
    800045cc:	69ea                	ld	s3,152(sp)
}
    800045ce:	70ea                	ld	ra,184(sp)
    800045d0:	744a                	ld	s0,176(sp)
    800045d2:	6129                	addi	sp,sp,192
    800045d4:	8082                	ret
      end_op();
    800045d6:	c33fe0ef          	jal	80003208 <end_op>
      return -1;
    800045da:	557d                	li	a0,-1
    800045dc:	74aa                	ld	s1,168(sp)
    800045de:	bfc5                	j	800045ce <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800045e0:	f5040513          	addi	a0,s0,-176
    800045e4:	9f9fe0ef          	jal	80002fdc <namei>
    800045e8:	84aa                	mv	s1,a0
    800045ea:	c11d                	beqz	a0,80004610 <sys_open+0x10c>
    ilock(ip);
    800045ec:	b00fe0ef          	jal	800028ec <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800045f0:	04449703          	lh	a4,68(s1)
    800045f4:	4785                	li	a5,1
    800045f6:	f4f71ce3          	bne	a4,a5,8000454e <sys_open+0x4a>
    800045fa:	f4c42783          	lw	a5,-180(s0)
    800045fe:	d3b5                	beqz	a5,80004562 <sys_open+0x5e>
      iunlockput(ip);
    80004600:	8526                	mv	a0,s1
    80004602:	cf4fe0ef          	jal	80002af6 <iunlockput>
      end_op();
    80004606:	c03fe0ef          	jal	80003208 <end_op>
      return -1;
    8000460a:	557d                	li	a0,-1
    8000460c:	74aa                	ld	s1,168(sp)
    8000460e:	b7c1                	j	800045ce <sys_open+0xca>
      end_op();
    80004610:	bf9fe0ef          	jal	80003208 <end_op>
      return -1;
    80004614:	557d                	li	a0,-1
    80004616:	74aa                	ld	s1,168(sp)
    80004618:	bf5d                	j	800045ce <sys_open+0xca>
    iunlockput(ip);
    8000461a:	8526                	mv	a0,s1
    8000461c:	cdafe0ef          	jal	80002af6 <iunlockput>
    end_op();
    80004620:	be9fe0ef          	jal	80003208 <end_op>
    return -1;
    80004624:	557d                	li	a0,-1
    80004626:	74aa                	ld	s1,168(sp)
    80004628:	b75d                	j	800045ce <sys_open+0xca>
      fileclose(f);
    8000462a:	854a                	mv	a0,s2
    8000462c:	f93fe0ef          	jal	800035be <fileclose>
    80004630:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004632:	8526                	mv	a0,s1
    80004634:	cc2fe0ef          	jal	80002af6 <iunlockput>
    end_op();
    80004638:	bd1fe0ef          	jal	80003208 <end_op>
    return -1;
    8000463c:	557d                	li	a0,-1
    8000463e:	74aa                	ld	s1,168(sp)
    80004640:	790a                	ld	s2,160(sp)
    80004642:	b771                	j	800045ce <sys_open+0xca>
    f->type = FD_DEVICE;
    80004644:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004648:	04649783          	lh	a5,70(s1)
    8000464c:	02f91223          	sh	a5,36(s2)
    80004650:	bf35                	j	8000458c <sys_open+0x88>
    itrunc(ip);
    80004652:	8526                	mv	a0,s1
    80004654:	b86fe0ef          	jal	800029da <itrunc>
    80004658:	b795                	j	800045bc <sys_open+0xb8>

000000008000465a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000465a:	7175                	addi	sp,sp,-144
    8000465c:	e506                	sd	ra,136(sp)
    8000465e:	e122                	sd	s0,128(sp)
    80004660:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004662:	b3dfe0ef          	jal	8000319e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004666:	08000613          	li	a2,128
    8000466a:	f7040593          	addi	a1,s0,-144
    8000466e:	4501                	li	a0,0
    80004670:	8b7fd0ef          	jal	80001f26 <argstr>
    80004674:	02054363          	bltz	a0,8000469a <sys_mkdir+0x40>
    80004678:	4681                	li	a3,0
    8000467a:	4601                	li	a2,0
    8000467c:	4585                	li	a1,1
    8000467e:	f7040513          	addi	a0,s0,-144
    80004682:	95dff0ef          	jal	80003fde <create>
    80004686:	c911                	beqz	a0,8000469a <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004688:	c6efe0ef          	jal	80002af6 <iunlockput>
  end_op();
    8000468c:	b7dfe0ef          	jal	80003208 <end_op>
  return 0;
    80004690:	4501                	li	a0,0
}
    80004692:	60aa                	ld	ra,136(sp)
    80004694:	640a                	ld	s0,128(sp)
    80004696:	6149                	addi	sp,sp,144
    80004698:	8082                	ret
    end_op();
    8000469a:	b6ffe0ef          	jal	80003208 <end_op>
    return -1;
    8000469e:	557d                	li	a0,-1
    800046a0:	bfcd                	j	80004692 <sys_mkdir+0x38>

00000000800046a2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800046a2:	7135                	addi	sp,sp,-160
    800046a4:	ed06                	sd	ra,152(sp)
    800046a6:	e922                	sd	s0,144(sp)
    800046a8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800046aa:	af5fe0ef          	jal	8000319e <begin_op>
  argint(1, &major);
    800046ae:	f6c40593          	addi	a1,s0,-148
    800046b2:	4505                	li	a0,1
    800046b4:	83bfd0ef          	jal	80001eee <argint>
  argint(2, &minor);
    800046b8:	f6840593          	addi	a1,s0,-152
    800046bc:	4509                	li	a0,2
    800046be:	831fd0ef          	jal	80001eee <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800046c2:	08000613          	li	a2,128
    800046c6:	f7040593          	addi	a1,s0,-144
    800046ca:	4501                	li	a0,0
    800046cc:	85bfd0ef          	jal	80001f26 <argstr>
    800046d0:	02054563          	bltz	a0,800046fa <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800046d4:	f6841683          	lh	a3,-152(s0)
    800046d8:	f6c41603          	lh	a2,-148(s0)
    800046dc:	458d                	li	a1,3
    800046de:	f7040513          	addi	a0,s0,-144
    800046e2:	8fdff0ef          	jal	80003fde <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800046e6:	c911                	beqz	a0,800046fa <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800046e8:	c0efe0ef          	jal	80002af6 <iunlockput>
  end_op();
    800046ec:	b1dfe0ef          	jal	80003208 <end_op>
  return 0;
    800046f0:	4501                	li	a0,0
}
    800046f2:	60ea                	ld	ra,152(sp)
    800046f4:	644a                	ld	s0,144(sp)
    800046f6:	610d                	addi	sp,sp,160
    800046f8:	8082                	ret
    end_op();
    800046fa:	b0ffe0ef          	jal	80003208 <end_op>
    return -1;
    800046fe:	557d                	li	a0,-1
    80004700:	bfcd                	j	800046f2 <sys_mknod+0x50>

0000000080004702 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004702:	7135                	addi	sp,sp,-160
    80004704:	ed06                	sd	ra,152(sp)
    80004706:	e922                	sd	s0,144(sp)
    80004708:	e14a                	sd	s2,128(sp)
    8000470a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000470c:	efefc0ef          	jal	80000e0a <myproc>
    80004710:	892a                	mv	s2,a0
  
  begin_op();
    80004712:	a8dfe0ef          	jal	8000319e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004716:	08000613          	li	a2,128
    8000471a:	f6040593          	addi	a1,s0,-160
    8000471e:	4501                	li	a0,0
    80004720:	807fd0ef          	jal	80001f26 <argstr>
    80004724:	04054363          	bltz	a0,8000476a <sys_chdir+0x68>
    80004728:	e526                	sd	s1,136(sp)
    8000472a:	f6040513          	addi	a0,s0,-160
    8000472e:	8affe0ef          	jal	80002fdc <namei>
    80004732:	84aa                	mv	s1,a0
    80004734:	c915                	beqz	a0,80004768 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004736:	9b6fe0ef          	jal	800028ec <ilock>
  if(ip->type != T_DIR){
    8000473a:	04449703          	lh	a4,68(s1)
    8000473e:	4785                	li	a5,1
    80004740:	02f71963          	bne	a4,a5,80004772 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004744:	8526                	mv	a0,s1
    80004746:	a54fe0ef          	jal	8000299a <iunlock>
  iput(p->cwd);
    8000474a:	15093503          	ld	a0,336(s2)
    8000474e:	b20fe0ef          	jal	80002a6e <iput>
  end_op();
    80004752:	ab7fe0ef          	jal	80003208 <end_op>
  p->cwd = ip;
    80004756:	14993823          	sd	s1,336(s2)
  return 0;
    8000475a:	4501                	li	a0,0
    8000475c:	64aa                	ld	s1,136(sp)
}
    8000475e:	60ea                	ld	ra,152(sp)
    80004760:	644a                	ld	s0,144(sp)
    80004762:	690a                	ld	s2,128(sp)
    80004764:	610d                	addi	sp,sp,160
    80004766:	8082                	ret
    80004768:	64aa                	ld	s1,136(sp)
    end_op();
    8000476a:	a9ffe0ef          	jal	80003208 <end_op>
    return -1;
    8000476e:	557d                	li	a0,-1
    80004770:	b7fd                	j	8000475e <sys_chdir+0x5c>
    iunlockput(ip);
    80004772:	8526                	mv	a0,s1
    80004774:	b82fe0ef          	jal	80002af6 <iunlockput>
    end_op();
    80004778:	a91fe0ef          	jal	80003208 <end_op>
    return -1;
    8000477c:	557d                	li	a0,-1
    8000477e:	64aa                	ld	s1,136(sp)
    80004780:	bff9                	j	8000475e <sys_chdir+0x5c>

0000000080004782 <sys_exec>:

uint64
sys_exec(void)
{
    80004782:	7105                	addi	sp,sp,-480
    80004784:	ef86                	sd	ra,472(sp)
    80004786:	eba2                	sd	s0,464(sp)
    80004788:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000478a:	e2840593          	addi	a1,s0,-472
    8000478e:	4505                	li	a0,1
    80004790:	f7afd0ef          	jal	80001f0a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004794:	08000613          	li	a2,128
    80004798:	f3040593          	addi	a1,s0,-208
    8000479c:	4501                	li	a0,0
    8000479e:	f88fd0ef          	jal	80001f26 <argstr>
    800047a2:	87aa                	mv	a5,a0
    return -1;
    800047a4:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800047a6:	0e07c063          	bltz	a5,80004886 <sys_exec+0x104>
    800047aa:	e7a6                	sd	s1,456(sp)
    800047ac:	e3ca                	sd	s2,448(sp)
    800047ae:	ff4e                	sd	s3,440(sp)
    800047b0:	fb52                	sd	s4,432(sp)
    800047b2:	f756                	sd	s5,424(sp)
    800047b4:	f35a                	sd	s6,416(sp)
    800047b6:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800047b8:	e3040a13          	addi	s4,s0,-464
    800047bc:	10000613          	li	a2,256
    800047c0:	4581                	li	a1,0
    800047c2:	8552                	mv	a0,s4
    800047c4:	98bfb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800047c8:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800047ca:	89d2                	mv	s3,s4
    800047cc:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047ce:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800047d2:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800047d4:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047d8:	00391513          	slli	a0,s2,0x3
    800047dc:	85d6                	mv	a1,s5
    800047de:	e2843783          	ld	a5,-472(s0)
    800047e2:	953e                	add	a0,a0,a5
    800047e4:	e80fd0ef          	jal	80001e64 <fetchaddr>
    800047e8:	02054663          	bltz	a0,80004814 <sys_exec+0x92>
    if(uarg == 0){
    800047ec:	e2043783          	ld	a5,-480(s0)
    800047f0:	c7a1                	beqz	a5,80004838 <sys_exec+0xb6>
    argv[i] = kalloc();
    800047f2:	90dfb0ef          	jal	800000fe <kalloc>
    800047f6:	85aa                	mv	a1,a0
    800047f8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800047fc:	cd01                	beqz	a0,80004814 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800047fe:	865a                	mv	a2,s6
    80004800:	e2043503          	ld	a0,-480(s0)
    80004804:	eaafd0ef          	jal	80001eae <fetchstr>
    80004808:	00054663          	bltz	a0,80004814 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    8000480c:	0905                	addi	s2,s2,1
    8000480e:	09a1                	addi	s3,s3,8
    80004810:	fd7914e3          	bne	s2,s7,800047d8 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004814:	100a0a13          	addi	s4,s4,256
    80004818:	6088                	ld	a0,0(s1)
    8000481a:	cd31                	beqz	a0,80004876 <sys_exec+0xf4>
    kfree(argv[i]);
    8000481c:	801fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004820:	04a1                	addi	s1,s1,8
    80004822:	ff449be3          	bne	s1,s4,80004818 <sys_exec+0x96>
  return -1;
    80004826:	557d                	li	a0,-1
    80004828:	64be                	ld	s1,456(sp)
    8000482a:	691e                	ld	s2,448(sp)
    8000482c:	79fa                	ld	s3,440(sp)
    8000482e:	7a5a                	ld	s4,432(sp)
    80004830:	7aba                	ld	s5,424(sp)
    80004832:	7b1a                	ld	s6,416(sp)
    80004834:	6bfa                	ld	s7,408(sp)
    80004836:	a881                	j	80004886 <sys_exec+0x104>
      argv[i] = 0;
    80004838:	0009079b          	sext.w	a5,s2
    8000483c:	e3040593          	addi	a1,s0,-464
    80004840:	078e                	slli	a5,a5,0x3
    80004842:	97ae                	add	a5,a5,a1
    80004844:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80004848:	f3040513          	addi	a0,s0,-208
    8000484c:	ba4ff0ef          	jal	80003bf0 <exec>
    80004850:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004852:	100a0a13          	addi	s4,s4,256
    80004856:	6088                	ld	a0,0(s1)
    80004858:	c511                	beqz	a0,80004864 <sys_exec+0xe2>
    kfree(argv[i]);
    8000485a:	fc2fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000485e:	04a1                	addi	s1,s1,8
    80004860:	ff449be3          	bne	s1,s4,80004856 <sys_exec+0xd4>
  return ret;
    80004864:	854a                	mv	a0,s2
    80004866:	64be                	ld	s1,456(sp)
    80004868:	691e                	ld	s2,448(sp)
    8000486a:	79fa                	ld	s3,440(sp)
    8000486c:	7a5a                	ld	s4,432(sp)
    8000486e:	7aba                	ld	s5,424(sp)
    80004870:	7b1a                	ld	s6,416(sp)
    80004872:	6bfa                	ld	s7,408(sp)
    80004874:	a809                	j	80004886 <sys_exec+0x104>
  return -1;
    80004876:	557d                	li	a0,-1
    80004878:	64be                	ld	s1,456(sp)
    8000487a:	691e                	ld	s2,448(sp)
    8000487c:	79fa                	ld	s3,440(sp)
    8000487e:	7a5a                	ld	s4,432(sp)
    80004880:	7aba                	ld	s5,424(sp)
    80004882:	7b1a                	ld	s6,416(sp)
    80004884:	6bfa                	ld	s7,408(sp)
}
    80004886:	60fe                	ld	ra,472(sp)
    80004888:	645e                	ld	s0,464(sp)
    8000488a:	613d                	addi	sp,sp,480
    8000488c:	8082                	ret

000000008000488e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000488e:	7139                	addi	sp,sp,-64
    80004890:	fc06                	sd	ra,56(sp)
    80004892:	f822                	sd	s0,48(sp)
    80004894:	f426                	sd	s1,40(sp)
    80004896:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004898:	d72fc0ef          	jal	80000e0a <myproc>
    8000489c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000489e:	fd840593          	addi	a1,s0,-40
    800048a2:	4501                	li	a0,0
    800048a4:	e66fd0ef          	jal	80001f0a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800048a8:	fc840593          	addi	a1,s0,-56
    800048ac:	fd040513          	addi	a0,s0,-48
    800048b0:	81eff0ef          	jal	800038ce <pipealloc>
    return -1;
    800048b4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800048b6:	0a054463          	bltz	a0,8000495e <sys_pipe+0xd0>
  fd0 = -1;
    800048ba:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800048be:	fd043503          	ld	a0,-48(s0)
    800048c2:	edeff0ef          	jal	80003fa0 <fdalloc>
    800048c6:	fca42223          	sw	a0,-60(s0)
    800048ca:	08054163          	bltz	a0,8000494c <sys_pipe+0xbe>
    800048ce:	fc843503          	ld	a0,-56(s0)
    800048d2:	eceff0ef          	jal	80003fa0 <fdalloc>
    800048d6:	fca42023          	sw	a0,-64(s0)
    800048da:	06054063          	bltz	a0,8000493a <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048de:	4691                	li	a3,4
    800048e0:	fc440613          	addi	a2,s0,-60
    800048e4:	fd843583          	ld	a1,-40(s0)
    800048e8:	68a8                	ld	a0,80(s1)
    800048ea:	9c8fc0ef          	jal	80000ab2 <copyout>
    800048ee:	00054e63          	bltz	a0,8000490a <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800048f2:	4691                	li	a3,4
    800048f4:	fc040613          	addi	a2,s0,-64
    800048f8:	fd843583          	ld	a1,-40(s0)
    800048fc:	95b6                	add	a1,a1,a3
    800048fe:	68a8                	ld	a0,80(s1)
    80004900:	9b2fc0ef          	jal	80000ab2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004904:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004906:	04055c63          	bgez	a0,8000495e <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000490a:	fc442783          	lw	a5,-60(s0)
    8000490e:	07e9                	addi	a5,a5,26
    80004910:	078e                	slli	a5,a5,0x3
    80004912:	97a6                	add	a5,a5,s1
    80004914:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004918:	fc042783          	lw	a5,-64(s0)
    8000491c:	07e9                	addi	a5,a5,26
    8000491e:	078e                	slli	a5,a5,0x3
    80004920:	94be                	add	s1,s1,a5
    80004922:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004926:	fd043503          	ld	a0,-48(s0)
    8000492a:	c95fe0ef          	jal	800035be <fileclose>
    fileclose(wf);
    8000492e:	fc843503          	ld	a0,-56(s0)
    80004932:	c8dfe0ef          	jal	800035be <fileclose>
    return -1;
    80004936:	57fd                	li	a5,-1
    80004938:	a01d                	j	8000495e <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000493a:	fc442783          	lw	a5,-60(s0)
    8000493e:	0007c763          	bltz	a5,8000494c <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004942:	07e9                	addi	a5,a5,26
    80004944:	078e                	slli	a5,a5,0x3
    80004946:	97a6                	add	a5,a5,s1
    80004948:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000494c:	fd043503          	ld	a0,-48(s0)
    80004950:	c6ffe0ef          	jal	800035be <fileclose>
    fileclose(wf);
    80004954:	fc843503          	ld	a0,-56(s0)
    80004958:	c67fe0ef          	jal	800035be <fileclose>
    return -1;
    8000495c:	57fd                	li	a5,-1
}
    8000495e:	853e                	mv	a0,a5
    80004960:	70e2                	ld	ra,56(sp)
    80004962:	7442                	ld	s0,48(sp)
    80004964:	74a2                	ld	s1,40(sp)
    80004966:	6121                	addi	sp,sp,64
    80004968:	8082                	ret

000000008000496a <sys_mmap>:

uint64
sys_mmap(void)
{
    8000496a:	7119                	addi	sp,sp,-128
    8000496c:	fc86                	sd	ra,120(sp)
    8000496e:	f8a2                	sd	s0,112(sp)
    80004970:	ecce                	sd	s3,88(sp)
    80004972:	0100                	addi	s0,sp,128
  int index;
  int fd;
  uint64 va;
  struct VMA vma;
  struct proc *p = myproc();
    80004974:	c96fc0ef          	jal	80000e0a <myproc>
    80004978:	89aa                	mv	s3,a0

  // get args
  argaddr(0, &vma.addr);
    8000497a:	f9040593          	addi	a1,s0,-112
    8000497e:	4501                	li	a0,0
    80004980:	d8afd0ef          	jal	80001f0a <argaddr>
  argint(1, &vma.len);
    80004984:	f8040593          	addi	a1,s0,-128
    80004988:	4505                	li	a0,1
    8000498a:	d64fd0ef          	jal	80001eee <argint>
  vma.len = PGROUNDUP(vma.len);
    8000498e:	f8042703          	lw	a4,-128(s0)
    80004992:	6785                	lui	a5,0x1
    80004994:	37fd                	addiw	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004996:	9fb9                	addw	a5,a5,a4
    80004998:	777d                	lui	a4,0xfffff
    8000499a:	8ff9                	and	a5,a5,a4
    8000499c:	f8f42023          	sw	a5,-128(s0)
  argint(2, &vma.prot);
    800049a0:	f8440593          	addi	a1,s0,-124
    800049a4:	4509                	li	a0,2
    800049a6:	d48fd0ef          	jal	80001eee <argint>
  argint(3, &vma.flags);
    800049aa:	f8840593          	addi	a1,s0,-120
    800049ae:	450d                	li	a0,3
    800049b0:	d3efd0ef          	jal	80001eee <argint>
  if (argfd(4, &fd, &vma.f) < 0)
    800049b4:	fa040613          	addi	a2,s0,-96
    800049b8:	fac40593          	addi	a1,s0,-84
    800049bc:	4511                	li	a0,4
    800049be:	d8aff0ef          	jal	80003f48 <argfd>
    800049c2:	10054e63          	bltz	a0,80004ade <sys_mmap+0x174>
    return -1;
  argint(5, &vma.offset);
    800049c6:	f8c40593          	addi	a1,s0,-116
    800049ca:	4515                	li	a0,5
    800049cc:	d22fd0ef          	jal	80001eee <argint>

  // check prot and flags
  if (!(vma.flags & MAP_PRIVATE) && ((!vma.f->readable && (vma.prot & PROT_READ)) 
    800049d0:	f8842783          	lw	a5,-120(s0)
    800049d4:	8b89                	andi	a5,a5,2
    800049d6:	ef91                	bnez	a5,800049f2 <sys_mmap+0x88>
    800049d8:	fa043783          	ld	a5,-96(s0)
    800049dc:	0087c703          	lbu	a4,8(a5)
    800049e0:	e711                	bnez	a4,800049ec <sys_mmap+0x82>
    800049e2:	f8442703          	lw	a4,-124(s0)
    800049e6:	8b05                	andi	a4,a4,1
    800049e8:	0e071d63          	bnez	a4,80004ae2 <sys_mmap+0x178>
    || (!vma.f->writable && (vma.prot & PROT_WRITE))))
    800049ec:	0097c783          	lbu	a5,9(a5)
    800049f0:	cb8d                	beqz	a5,80004a22 <sys_mmap+0xb8>
    800049f2:	f4a6                	sd	s1,104(sp)
    800049f4:	f0ca                	sd	s2,96(sp)
    800049f6:	e8d2                	sd	s4,80(sp)
    800049f8:	e4d6                	sd	s5,72(sp)
    800049fa:	e0da                	sd	s6,64(sp)
    800049fc:	fc5e                	sd	s7,56(sp)
    return -1;

  // find a vma to store
  for (index = 0; index < NVMA; index++)
    800049fe:	15898793          	addi	a5,s3,344
{
    80004a02:	4a81                	li	s5,0
  for (index = 0; index < NVMA; index++)
    80004a04:	46c1                	li	a3,16
    if (!p->vmas[index].len) break;
    80004a06:	4398                	lw	a4,0(a5)
    80004a08:	0e070763          	beqz	a4,80004af6 <sys_mmap+0x18c>
  for (index = 0; index < NVMA; index++)
    80004a0c:	2a85                	addiw	s5,s5,1
    80004a0e:	02878793          	addi	a5,a5,40
    80004a12:	feda9ae3          	bne	s5,a3,80004a06 <sys_mmap+0x9c>
  if (index == NVMA) panic("sys_mmap: no VMA to free");
    80004a16:	00003517          	auipc	a0,0x3
    80004a1a:	ca250513          	addi	a0,a0,-862 # 800076b8 <etext+0x6b8>
    80004a1e:	038010ef          	jal	80005a56 <panic>
    || (!vma.f->writable && (vma.prot & PROT_WRITE))))
    80004a22:	f8442783          	lw	a5,-124(s0)
    80004a26:	8b89                	andi	a5,a5,2
    80004a28:	d7e9                	beqz	a5,800049f2 <sys_mmap+0x88>
    return -1;
    80004a2a:	557d                	li	a0,-1
    80004a2c:	a065                	j	80004ad4 <sys_mmap+0x16a>
  // find a va space to map
  for (va = VMABASE; va > 0; va -= PGSIZE) {
    if ((walkaddr(p->pagetable, va)) != 0) continue;

    uint64 vaend = va;
    for (; va > vaend - vma.len; va -= PGSIZE)
    80004a2e:	84ca                	mv	s1,s2
      if ((walkaddr(p->pagetable, va)) != 0) break;

    if (va == vaend - vma.len && conflictdet(p->vmas, va + PGSIZE, vma.len)) {
    80004a30:	f8042603          	lw	a2,-128(s0)
    80004a34:	40c907b3          	sub	a5,s2,a2
    80004a38:	8926                	mv	s2,s1
    80004a3a:	04978063          	beq	a5,s1,80004a7a <sys_mmap+0x110>
  for (va = VMABASE; va > 0; va -= PGSIZE) {
    80004a3e:	9952                	add	s2,s2,s4
    80004a40:	04090f63          	beqz	s2,80004a9e <sys_mmap+0x134>
    if ((walkaddr(p->pagetable, va)) != 0) continue;
    80004a44:	85ca                	mv	a1,s2
    80004a46:	0509b503          	ld	a0,80(s3)
    80004a4a:	a33fb0ef          	jal	8000047c <walkaddr>
    80004a4e:	f965                	bnez	a0,80004a3e <sys_mmap+0xd4>
    for (; va > vaend - vma.len; va -= PGSIZE)
    80004a50:	f8042783          	lw	a5,-128(s0)
    80004a54:	40f907b3          	sub	a5,s2,a5
    80004a58:	fd27fbe3          	bgeu	a5,s2,80004a2e <sys_mmap+0xc4>
    80004a5c:	84ca                	mv	s1,s2
      if ((walkaddr(p->pagetable, va)) != 0) break;
    80004a5e:	85a6                	mv	a1,s1
    80004a60:	0509b503          	ld	a0,80(s3)
    80004a64:	a19fb0ef          	jal	8000047c <walkaddr>
    80004a68:	f561                	bnez	a0,80004a30 <sys_mmap+0xc6>
    for (; va > vaend - vma.len; va -= PGSIZE)
    80004a6a:	94d2                	add	s1,s1,s4
    80004a6c:	f8042783          	lw	a5,-128(s0)
    80004a70:	40f907b3          	sub	a5,s2,a5
    80004a74:	fe97e5e3          	bltu	a5,s1,80004a5e <sys_mmap+0xf4>
    80004a78:	bf65                	j	80004a30 <sys_mmap+0xc6>
    if (va == vaend - vma.len && conflictdet(p->vmas, va + PGSIZE, vma.len)) {
    80004a7a:	01748933          	add	s2,s1,s7
    80004a7e:	85ca                	mv	a1,s2
    80004a80:	855a                	mv	a0,s6
    80004a82:	f19fc0ef          	jal	8000199a <conflictdet>
    80004a86:	e119                	bnez	a0,80004a8c <sys_mmap+0x122>
    80004a88:	8926                	mv	s2,s1
    80004a8a:	bf55                	j	80004a3e <sys_mmap+0xd4>
      p->vmas[index].addr = va + PGSIZE;
    80004a8c:	002a9793          	slli	a5,s5,0x2
    80004a90:	97d6                	add	a5,a5,s5
    80004a92:	078e                	slli	a5,a5,0x3
    80004a94:	97ce                	add	a5,a5,s3
    80004a96:	1727b423          	sd	s2,360(a5)
      p->vmas[index].base = va + PGSIZE;
    80004a9a:	1727b823          	sd	s2,368(a5)
      break;
    }
  }

  printf("vma.addr: %p\n", (void *)p->vmas[index].addr);
    80004a9e:	002a9493          	slli	s1,s5,0x2
    80004aa2:	015487b3          	add	a5,s1,s5
    80004aa6:	078e                	slli	a5,a5,0x3
    80004aa8:	97ce                	add	a5,a5,s3
    80004aaa:	1687b583          	ld	a1,360(a5)
    80004aae:	00003517          	auipc	a0,0x3
    80004ab2:	bfa50513          	addi	a0,a0,-1030 # 800076a8 <etext+0x6a8>
    80004ab6:	4d1000ef          	jal	80005786 <printf>
  if (p->vmas[index].addr) return p->vmas[index].addr;
    80004aba:	015487b3          	add	a5,s1,s5
    80004abe:	078e                	slli	a5,a5,0x3
    80004ac0:	97ce                	add	a5,a5,s3
    80004ac2:	1687b503          	ld	a0,360(a5)
    80004ac6:	c105                	beqz	a0,80004ae6 <sys_mmap+0x17c>
    80004ac8:	74a6                	ld	s1,104(sp)
    80004aca:	7906                	ld	s2,96(sp)
    80004acc:	6a46                	ld	s4,80(sp)
    80004ace:	6aa6                	ld	s5,72(sp)
    80004ad0:	6b06                	ld	s6,64(sp)
    80004ad2:	7be2                	ld	s7,56(sp)
  else return -1;
}
    80004ad4:	70e6                	ld	ra,120(sp)
    80004ad6:	7446                	ld	s0,112(sp)
    80004ad8:	69e6                	ld	s3,88(sp)
    80004ada:	6109                	addi	sp,sp,128
    80004adc:	8082                	ret
    return -1;
    80004ade:	557d                	li	a0,-1
    80004ae0:	bfd5                	j	80004ad4 <sys_mmap+0x16a>
    return -1;
    80004ae2:	557d                	li	a0,-1
    80004ae4:	bfc5                	j	80004ad4 <sys_mmap+0x16a>
  else return -1;
    80004ae6:	557d                	li	a0,-1
    80004ae8:	74a6                	ld	s1,104(sp)
    80004aea:	7906                	ld	s2,96(sp)
    80004aec:	6a46                	ld	s4,80(sp)
    80004aee:	6aa6                	ld	s5,72(sp)
    80004af0:	6b06                	ld	s6,64(sp)
    80004af2:	7be2                	ld	s7,56(sp)
    80004af4:	b7c5                	j	80004ad4 <sys_mmap+0x16a>
  p->vmas[index] = vma;
    80004af6:	002a9793          	slli	a5,s5,0x2
    80004afa:	97d6                	add	a5,a5,s5
    80004afc:	078e                	slli	a5,a5,0x3
    80004afe:	97ce                	add	a5,a5,s3
    80004b00:	fa043503          	ld	a0,-96(s0)
    80004b04:	f8043703          	ld	a4,-128(s0)
    80004b08:	14e7bc23          	sd	a4,344(a5)
    80004b0c:	f8843703          	ld	a4,-120(s0)
    80004b10:	16e7b023          	sd	a4,352(a5)
    80004b14:	f9043703          	ld	a4,-112(s0)
    80004b18:	16e7b423          	sd	a4,360(a5)
    80004b1c:	f9843703          	ld	a4,-104(s0)
    80004b20:	16e7b823          	sd	a4,368(a5)
    80004b24:	16a7bc23          	sd	a0,376(a5)
  filedup(p->vmas[index].f);
    80004b28:	a51fe0ef          	jal	80003578 <filedup>
  for (va = VMABASE; va > 0; va -= PGSIZE) {
    80004b2c:	04000937          	lui	s2,0x4000
    80004b30:	1975                	addi	s2,s2,-3 # 3fffffd <_entry-0x7c000003>
    80004b32:	0932                	slli	s2,s2,0xc
    if (va == vaend - vma.len && conflictdet(p->vmas, va + PGSIZE, vma.len)) {
    80004b34:	6b85                	lui	s7,0x1
    80004b36:	15898b13          	addi	s6,s3,344
    for (; va > vaend - vma.len; va -= PGSIZE)
    80004b3a:	7a7d                	lui	s4,0xfffff
    80004b3c:	b721                	j	80004a44 <sys_mmap+0xda>

0000000080004b3e <sys_munmap>:

uint64 
sys_munmap(void)
{
    80004b3e:	715d                	addi	sp,sp,-80
    80004b40:	e486                	sd	ra,72(sp)
    80004b42:	e0a2                	sd	s0,64(sp)
    80004b44:	f84a                	sd	s2,48(sp)
    80004b46:	0880                	addi	s0,sp,80
  int index;
  uint64 addr;
  uint64 writeaddr;
  struct VMA *vma;
  struct inode *ip;
  struct proc *p = myproc();
    80004b48:	ac2fc0ef          	jal	80000e0a <myproc>
    80004b4c:	892a                	mv	s2,a0

  argaddr(0, &addr);
    80004b4e:	fb040593          	addi	a1,s0,-80
    80004b52:	4501                	li	a0,0
    80004b54:	bb6fd0ef          	jal	80001f0a <argaddr>
  argint(1, &length);
    80004b58:	fbc40593          	addi	a1,s0,-68
    80004b5c:	4505                	li	a0,1
    80004b5e:	b90fd0ef          	jal	80001eee <argint>
  if ((index = conflictdet(p->vmas, addr, 0)) == -1)
    80004b62:	4601                	li	a2,0
    80004b64:	fb043583          	ld	a1,-80(s0)
    80004b68:	15890513          	addi	a0,s2,344
    80004b6c:	e2ffc0ef          	jal	8000199a <conflictdet>
    80004b70:	57fd                	li	a5,-1
    80004b72:	10f50963          	beq	a0,a5,80004c84 <sys_munmap+0x146>
    80004b76:	fc26                	sd	s1,56(sp)
    80004b78:	f44e                	sd	s3,40(sp)
    80004b7a:	f052                	sd	s4,32(sp)
    80004b7c:	84aa                	mv	s1,a0
    panic("munmap: not assigned addr");
  vma = &p->vmas[index];
  ip = vma->f->ip;
    80004b7e:	00251793          	slli	a5,a0,0x2
    80004b82:	97aa                	add	a5,a5,a0
    80004b84:	078e                	slli	a5,a5,0x3
    80004b86:	97ca                	add	a5,a5,s2
    80004b88:	1787b703          	ld	a4,376(a5)
    80004b8c:	01873983          	ld	s3,24(a4) # fffffffffffff018 <end+0xffffffff7ffd1748>

  writelen = addr - vma->base + vma->offset + length > ip->size ?
    80004b90:	fb043583          	ld	a1,-80(s0)
    80004b94:	1707b703          	ld	a4,368(a5)
    80004b98:	1647a603          	lw	a2,356(a5)
    80004b9c:	fbc42683          	lw	a3,-68(s0)
    80004ba0:	04c9a803          	lw	a6,76(s3)
    80004ba4:	02081513          	slli	a0,a6,0x20
    80004ba8:	9101                	srli	a0,a0,0x20
    80004baa:	00b687b3          	add	a5,a3,a1
    80004bae:	97b2                	add	a5,a5,a2
    80004bb0:	8f99                	sub	a5,a5,a4
    80004bb2:	00f57763          	bgeu	a0,a5,80004bc0 <sys_munmap+0x82>
  (ip->size - (addr - vma->base + vma->offset)) : length;
    80004bb6:	40b706bb          	subw	a3,a4,a1
    80004bba:	010686bb          	addw	a3,a3,a6
  writelen = addr - vma->base + vma->offset + length > ip->size ?
    80004bbe:	9e91                	subw	a3,a3,a2
  if (writelen < 0) writelen = 0;

  writeaddr = vma->offset + addr - vma->base > ip->size ? 
    80004bc0:	40e60733          	sub	a4,a2,a4
    80004bc4:	00b70a33          	add	s4,a4,a1
  (vma->offset) : vma->offset + addr - vma->base;
    80004bc8:	01457363          	bgeu	a0,s4,80004bce <sys_munmap+0x90>
    80004bcc:	8a32                	mv	s4,a2

  if (vma->flags & MAP_SHARED) {
    80004bce:	00249793          	slli	a5,s1,0x2
    80004bd2:	97a6                	add	a5,a5,s1
    80004bd4:	078e                	slli	a5,a5,0x3
    80004bd6:	97ca                	add	a5,a5,s2
    80004bd8:	1607a783          	lw	a5,352(a5)
    80004bdc:	8b85                	andi	a5,a5,1
    80004bde:	cf8d                	beqz	a5,80004c18 <sys_munmap+0xda>
    80004be0:	ec56                	sd	s5,24(sp)
  if (writelen < 0) writelen = 0;
    80004be2:	8736                	mv	a4,a3
    80004be4:	0a06ca63          	bltz	a3,80004c98 <sys_munmap+0x15a>
    80004be8:	00070a9b          	sext.w	s5,a4
    begin_op();
    80004bec:	db2fe0ef          	jal	8000319e <begin_op>
    ilock(ip);
    80004bf0:	854e                	mv	a0,s3
    80004bf2:	cfbfd0ef          	jal	800028ec <ilock>
    if ((writei(ip, 1, addr, writeaddr, writelen)) < 0) {
    80004bf6:	8756                	mv	a4,s5
    80004bf8:	000a069b          	sext.w	a3,s4
    80004bfc:	fb043603          	ld	a2,-80(s0)
    80004c00:	4585                	li	a1,1
    80004c02:	854e                	mv	a0,s3
    80004c04:	832fe0ef          	jal	80002c36 <writei>
    80004c08:	08054a63          	bltz	a0,80004c9c <sys_munmap+0x15e>
      iunlock(ip);
      end_op();
      printf("writelen:%d\n", writelen);
      panic("mumap: write back error");
    }
    iunlock(ip);
    80004c0c:	854e                	mv	a0,s3
    80004c0e:	d8dfd0ef          	jal	8000299a <iunlock>
    end_op();
    80004c12:	df6fe0ef          	jal	80003208 <end_op>
    80004c16:	6ae2                	ld	s5,24(sp)
  }

  vmaunmap(p->pagetable, addr, PGROUNDUP(length) / PGSIZE, 1);
    80004c18:	fbc42603          	lw	a2,-68(s0)
    80004c1c:	6985                	lui	s3,0x1
    80004c1e:	39fd                	addiw	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004c20:	00c9863b          	addw	a2,s3,a2
    80004c24:	4685                	li	a3,1
    80004c26:	40c6561b          	sraiw	a2,a2,0xc
    80004c2a:	fb043583          	ld	a1,-80(s0)
    80004c2e:	05093503          	ld	a0,80(s2)
    80004c32:	aebfb0ef          	jal	8000071c <vmaunmap>
  vma->len -= PGROUNDUP(length);
    80004c36:	fbc42783          	lw	a5,-68(s0)
    80004c3a:	00f989bb          	addw	s3,s3,a5
    80004c3e:	77fd                	lui	a5,0xfffff
    80004c40:	00f9f9b3          	and	s3,s3,a5
    80004c44:	00249793          	slli	a5,s1,0x2
    80004c48:	97a6                	add	a5,a5,s1
    80004c4a:	078e                	slli	a5,a5,0x3
    80004c4c:	97ca                	add	a5,a5,s2
    80004c4e:	1587a703          	lw	a4,344(a5) # fffffffffffff158 <end+0xffffffff7ffd1888>
    80004c52:	4137073b          	subw	a4,a4,s3
    80004c56:	14e7ac23          	sw	a4,344(a5)
  if (vma->len) {
    80004c5a:	cf25                	beqz	a4,80004cd2 <sys_munmap+0x194>
    if (addr == vma->addr)
    80004c5c:	00249793          	slli	a5,s1,0x2
    80004c60:	97a6                	add	a5,a5,s1
    80004c62:	078e                	slli	a5,a5,0x3
    80004c64:	97ca                	add	a5,a5,s2
    80004c66:	1687b703          	ld	a4,360(a5)
    80004c6a:	fb043783          	ld	a5,-80(s0)
    80004c6e:	04f70963          	beq	a4,a5,80004cc0 <sys_munmap+0x182>
      vma->addr += PGROUNDUP(length);
  } else
    fileclose(vma->f);
  return 0;
}
    80004c72:	4501                	li	a0,0
    80004c74:	74e2                	ld	s1,56(sp)
    80004c76:	79a2                	ld	s3,40(sp)
    80004c78:	7a02                	ld	s4,32(sp)
    80004c7a:	60a6                	ld	ra,72(sp)
    80004c7c:	6406                	ld	s0,64(sp)
    80004c7e:	7942                	ld	s2,48(sp)
    80004c80:	6161                	addi	sp,sp,80
    80004c82:	8082                	ret
    80004c84:	fc26                	sd	s1,56(sp)
    80004c86:	f44e                	sd	s3,40(sp)
    80004c88:	f052                	sd	s4,32(sp)
    80004c8a:	ec56                	sd	s5,24(sp)
    panic("munmap: not assigned addr");
    80004c8c:	00003517          	auipc	a0,0x3
    80004c90:	a4c50513          	addi	a0,a0,-1460 # 800076d8 <etext+0x6d8>
    80004c94:	5c3000ef          	jal	80005a56 <panic>
  if (writelen < 0) writelen = 0;
    80004c98:	4701                	li	a4,0
    80004c9a:	b7b9                	j	80004be8 <sys_munmap+0xaa>
      iunlock(ip);
    80004c9c:	854e                	mv	a0,s3
    80004c9e:	cfdfd0ef          	jal	8000299a <iunlock>
      end_op();
    80004ca2:	d66fe0ef          	jal	80003208 <end_op>
      printf("writelen:%d\n", writelen);
    80004ca6:	85d6                	mv	a1,s5
    80004ca8:	00003517          	auipc	a0,0x3
    80004cac:	a5050513          	addi	a0,a0,-1456 # 800076f8 <etext+0x6f8>
    80004cb0:	2d7000ef          	jal	80005786 <printf>
      panic("mumap: write back error");
    80004cb4:	00003517          	auipc	a0,0x3
    80004cb8:	a5450513          	addi	a0,a0,-1452 # 80007708 <etext+0x708>
    80004cbc:	59b000ef          	jal	80005a56 <panic>
      vma->addr += PGROUNDUP(length);
    80004cc0:	00249793          	slli	a5,s1,0x2
    80004cc4:	97a6                	add	a5,a5,s1
    80004cc6:	078e                	slli	a5,a5,0x3
    80004cc8:	97ca                	add	a5,a5,s2
    80004cca:	99ba                	add	s3,s3,a4
    80004ccc:	1737b423          	sd	s3,360(a5)
    80004cd0:	b74d                	j	80004c72 <sys_munmap+0x134>
    fileclose(vma->f);
    80004cd2:	00249793          	slli	a5,s1,0x2
    80004cd6:	97a6                	add	a5,a5,s1
    80004cd8:	078e                	slli	a5,a5,0x3
    80004cda:	993e                	add	s2,s2,a5
    80004cdc:	17893503          	ld	a0,376(s2)
    80004ce0:	8dffe0ef          	jal	800035be <fileclose>
    80004ce4:	b779                	j	80004c72 <sys_munmap+0x134>
	...

0000000080004cf0 <kernelvec>:
    80004cf0:	7111                	addi	sp,sp,-256
    80004cf2:	e006                	sd	ra,0(sp)
    80004cf4:	e40a                	sd	sp,8(sp)
    80004cf6:	e80e                	sd	gp,16(sp)
    80004cf8:	ec12                	sd	tp,24(sp)
    80004cfa:	f016                	sd	t0,32(sp)
    80004cfc:	f41a                	sd	t1,40(sp)
    80004cfe:	f81e                	sd	t2,48(sp)
    80004d00:	e4aa                	sd	a0,72(sp)
    80004d02:	e8ae                	sd	a1,80(sp)
    80004d04:	ecb2                	sd	a2,88(sp)
    80004d06:	f0b6                	sd	a3,96(sp)
    80004d08:	f4ba                	sd	a4,104(sp)
    80004d0a:	f8be                	sd	a5,112(sp)
    80004d0c:	fcc2                	sd	a6,120(sp)
    80004d0e:	e146                	sd	a7,128(sp)
    80004d10:	edf2                	sd	t3,216(sp)
    80004d12:	f1f6                	sd	t4,224(sp)
    80004d14:	f5fa                	sd	t5,232(sp)
    80004d16:	f9fe                	sd	t6,240(sp)
    80004d18:	85cfd0ef          	jal	80001d74 <kerneltrap>
    80004d1c:	6082                	ld	ra,0(sp)
    80004d1e:	6122                	ld	sp,8(sp)
    80004d20:	61c2                	ld	gp,16(sp)
    80004d22:	7282                	ld	t0,32(sp)
    80004d24:	7322                	ld	t1,40(sp)
    80004d26:	73c2                	ld	t2,48(sp)
    80004d28:	6526                	ld	a0,72(sp)
    80004d2a:	65c6                	ld	a1,80(sp)
    80004d2c:	6666                	ld	a2,88(sp)
    80004d2e:	7686                	ld	a3,96(sp)
    80004d30:	7726                	ld	a4,104(sp)
    80004d32:	77c6                	ld	a5,112(sp)
    80004d34:	7866                	ld	a6,120(sp)
    80004d36:	688a                	ld	a7,128(sp)
    80004d38:	6e6e                	ld	t3,216(sp)
    80004d3a:	7e8e                	ld	t4,224(sp)
    80004d3c:	7f2e                	ld	t5,232(sp)
    80004d3e:	7fce                	ld	t6,240(sp)
    80004d40:	6111                	addi	sp,sp,256
    80004d42:	10200073          	sret
	...

0000000080004d4e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004d4e:	1141                	addi	sp,sp,-16
    80004d50:	e406                	sd	ra,8(sp)
    80004d52:	e022                	sd	s0,0(sp)
    80004d54:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004d56:	0c000737          	lui	a4,0xc000
    80004d5a:	4785                	li	a5,1
    80004d5c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004d5e:	c35c                	sw	a5,4(a4)
}
    80004d60:	60a2                	ld	ra,8(sp)
    80004d62:	6402                	ld	s0,0(sp)
    80004d64:	0141                	addi	sp,sp,16
    80004d66:	8082                	ret

0000000080004d68 <plicinithart>:

void
plicinithart(void)
{
    80004d68:	1141                	addi	sp,sp,-16
    80004d6a:	e406                	sd	ra,8(sp)
    80004d6c:	e022                	sd	s0,0(sp)
    80004d6e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004d70:	866fc0ef          	jal	80000dd6 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004d74:	0085171b          	slliw	a4,a0,0x8
    80004d78:	0c0027b7          	lui	a5,0xc002
    80004d7c:	97ba                	add	a5,a5,a4
    80004d7e:	40200713          	li	a4,1026
    80004d82:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004d86:	00d5151b          	slliw	a0,a0,0xd
    80004d8a:	0c2017b7          	lui	a5,0xc201
    80004d8e:	97aa                	add	a5,a5,a0
    80004d90:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004d94:	60a2                	ld	ra,8(sp)
    80004d96:	6402                	ld	s0,0(sp)
    80004d98:	0141                	addi	sp,sp,16
    80004d9a:	8082                	ret

0000000080004d9c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004d9c:	1141                	addi	sp,sp,-16
    80004d9e:	e406                	sd	ra,8(sp)
    80004da0:	e022                	sd	s0,0(sp)
    80004da2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004da4:	832fc0ef          	jal	80000dd6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004da8:	00d5151b          	slliw	a0,a0,0xd
    80004dac:	0c2017b7          	lui	a5,0xc201
    80004db0:	97aa                	add	a5,a5,a0
  return irq;
}
    80004db2:	43c8                	lw	a0,4(a5)
    80004db4:	60a2                	ld	ra,8(sp)
    80004db6:	6402                	ld	s0,0(sp)
    80004db8:	0141                	addi	sp,sp,16
    80004dba:	8082                	ret

0000000080004dbc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004dbc:	1101                	addi	sp,sp,-32
    80004dbe:	ec06                	sd	ra,24(sp)
    80004dc0:	e822                	sd	s0,16(sp)
    80004dc2:	e426                	sd	s1,8(sp)
    80004dc4:	1000                	addi	s0,sp,32
    80004dc6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004dc8:	80efc0ef          	jal	80000dd6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004dcc:	00d5179b          	slliw	a5,a0,0xd
    80004dd0:	0c201737          	lui	a4,0xc201
    80004dd4:	97ba                	add	a5,a5,a4
    80004dd6:	c3c4                	sw	s1,4(a5)
}
    80004dd8:	60e2                	ld	ra,24(sp)
    80004dda:	6442                	ld	s0,16(sp)
    80004ddc:	64a2                	ld	s1,8(sp)
    80004dde:	6105                	addi	sp,sp,32
    80004de0:	8082                	ret

0000000080004de2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004de2:	1141                	addi	sp,sp,-16
    80004de4:	e406                	sd	ra,8(sp)
    80004de6:	e022                	sd	s0,0(sp)
    80004de8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004dea:	479d                	li	a5,7
    80004dec:	04a7ca63          	blt	a5,a0,80004e40 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004df0:	00021797          	auipc	a5,0x21
    80004df4:	8a078793          	addi	a5,a5,-1888 # 80025690 <disk>
    80004df8:	97aa                	add	a5,a5,a0
    80004dfa:	0187c783          	lbu	a5,24(a5)
    80004dfe:	e7b9                	bnez	a5,80004e4c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004e00:	00451693          	slli	a3,a0,0x4
    80004e04:	00021797          	auipc	a5,0x21
    80004e08:	88c78793          	addi	a5,a5,-1908 # 80025690 <disk>
    80004e0c:	6398                	ld	a4,0(a5)
    80004e0e:	9736                	add	a4,a4,a3
    80004e10:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004e14:	6398                	ld	a4,0(a5)
    80004e16:	9736                	add	a4,a4,a3
    80004e18:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004e1c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004e20:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004e24:	97aa                	add	a5,a5,a0
    80004e26:	4705                	li	a4,1
    80004e28:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004e2c:	00021517          	auipc	a0,0x21
    80004e30:	87c50513          	addi	a0,a0,-1924 # 800256a8 <disk+0x18>
    80004e34:	e34fc0ef          	jal	80001468 <wakeup>
}
    80004e38:	60a2                	ld	ra,8(sp)
    80004e3a:	6402                	ld	s0,0(sp)
    80004e3c:	0141                	addi	sp,sp,16
    80004e3e:	8082                	ret
    panic("free_desc 1");
    80004e40:	00003517          	auipc	a0,0x3
    80004e44:	8e050513          	addi	a0,a0,-1824 # 80007720 <etext+0x720>
    80004e48:	40f000ef          	jal	80005a56 <panic>
    panic("free_desc 2");
    80004e4c:	00003517          	auipc	a0,0x3
    80004e50:	8e450513          	addi	a0,a0,-1820 # 80007730 <etext+0x730>
    80004e54:	403000ef          	jal	80005a56 <panic>

0000000080004e58 <virtio_disk_init>:
{
    80004e58:	1101                	addi	sp,sp,-32
    80004e5a:	ec06                	sd	ra,24(sp)
    80004e5c:	e822                	sd	s0,16(sp)
    80004e5e:	e426                	sd	s1,8(sp)
    80004e60:	e04a                	sd	s2,0(sp)
    80004e62:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004e64:	00003597          	auipc	a1,0x3
    80004e68:	8dc58593          	addi	a1,a1,-1828 # 80007740 <etext+0x740>
    80004e6c:	00021517          	auipc	a0,0x21
    80004e70:	94c50513          	addi	a0,a0,-1716 # 800257b8 <disk+0x128>
    80004e74:	68d000ef          	jal	80005d00 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004e78:	100017b7          	lui	a5,0x10001
    80004e7c:	4398                	lw	a4,0(a5)
    80004e7e:	2701                	sext.w	a4,a4
    80004e80:	747277b7          	lui	a5,0x74727
    80004e84:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004e88:	14f71863          	bne	a4,a5,80004fd8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004e8c:	100017b7          	lui	a5,0x10001
    80004e90:	43dc                	lw	a5,4(a5)
    80004e92:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004e94:	4709                	li	a4,2
    80004e96:	14e79163          	bne	a5,a4,80004fd8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004e9a:	100017b7          	lui	a5,0x10001
    80004e9e:	479c                	lw	a5,8(a5)
    80004ea0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004ea2:	12e79b63          	bne	a5,a4,80004fd8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004ea6:	100017b7          	lui	a5,0x10001
    80004eaa:	47d8                	lw	a4,12(a5)
    80004eac:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004eae:	554d47b7          	lui	a5,0x554d4
    80004eb2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004eb6:	12f71163          	bne	a4,a5,80004fd8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004eba:	100017b7          	lui	a5,0x10001
    80004ebe:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ec2:	4705                	li	a4,1
    80004ec4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ec6:	470d                	li	a4,3
    80004ec8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004eca:	10001737          	lui	a4,0x10001
    80004ece:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004ed0:	c7ffe6b7          	lui	a3,0xc7ffe
    80004ed4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd0e8f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004ed8:	8f75                	and	a4,a4,a3
    80004eda:	100016b7          	lui	a3,0x10001
    80004ede:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ee0:	472d                	li	a4,11
    80004ee2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ee4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004ee8:	439c                	lw	a5,0(a5)
    80004eea:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004eee:	8ba1                	andi	a5,a5,8
    80004ef0:	0e078a63          	beqz	a5,80004fe4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004ef4:	100017b7          	lui	a5,0x10001
    80004ef8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004efc:	43fc                	lw	a5,68(a5)
    80004efe:	2781                	sext.w	a5,a5
    80004f00:	0e079863          	bnez	a5,80004ff0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004f04:	100017b7          	lui	a5,0x10001
    80004f08:	5bdc                	lw	a5,52(a5)
    80004f0a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004f0c:	0e078863          	beqz	a5,80004ffc <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004f10:	471d                	li	a4,7
    80004f12:	0ef77b63          	bgeu	a4,a5,80005008 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004f16:	9e8fb0ef          	jal	800000fe <kalloc>
    80004f1a:	00020497          	auipc	s1,0x20
    80004f1e:	77648493          	addi	s1,s1,1910 # 80025690 <disk>
    80004f22:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004f24:	9dafb0ef          	jal	800000fe <kalloc>
    80004f28:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004f2a:	9d4fb0ef          	jal	800000fe <kalloc>
    80004f2e:	87aa                	mv	a5,a0
    80004f30:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004f32:	6088                	ld	a0,0(s1)
    80004f34:	0e050063          	beqz	a0,80005014 <virtio_disk_init+0x1bc>
    80004f38:	00020717          	auipc	a4,0x20
    80004f3c:	76073703          	ld	a4,1888(a4) # 80025698 <disk+0x8>
    80004f40:	cb71                	beqz	a4,80005014 <virtio_disk_init+0x1bc>
    80004f42:	cbe9                	beqz	a5,80005014 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004f44:	6605                	lui	a2,0x1
    80004f46:	4581                	li	a1,0
    80004f48:	a06fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004f4c:	00020497          	auipc	s1,0x20
    80004f50:	74448493          	addi	s1,s1,1860 # 80025690 <disk>
    80004f54:	6605                	lui	a2,0x1
    80004f56:	4581                	li	a1,0
    80004f58:	6488                	ld	a0,8(s1)
    80004f5a:	9f4fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80004f5e:	6605                	lui	a2,0x1
    80004f60:	4581                	li	a1,0
    80004f62:	6888                	ld	a0,16(s1)
    80004f64:	9eafb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004f68:	100017b7          	lui	a5,0x10001
    80004f6c:	4721                	li	a4,8
    80004f6e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004f70:	4098                	lw	a4,0(s1)
    80004f72:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004f76:	40d8                	lw	a4,4(s1)
    80004f78:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004f7c:	649c                	ld	a5,8(s1)
    80004f7e:	0007869b          	sext.w	a3,a5
    80004f82:	10001737          	lui	a4,0x10001
    80004f86:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004f8a:	9781                	srai	a5,a5,0x20
    80004f8c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004f90:	689c                	ld	a5,16(s1)
    80004f92:	0007869b          	sext.w	a3,a5
    80004f96:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004f9a:	9781                	srai	a5,a5,0x20
    80004f9c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004fa0:	4785                	li	a5,1
    80004fa2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004fa4:	00f48c23          	sb	a5,24(s1)
    80004fa8:	00f48ca3          	sb	a5,25(s1)
    80004fac:	00f48d23          	sb	a5,26(s1)
    80004fb0:	00f48da3          	sb	a5,27(s1)
    80004fb4:	00f48e23          	sb	a5,28(s1)
    80004fb8:	00f48ea3          	sb	a5,29(s1)
    80004fbc:	00f48f23          	sb	a5,30(s1)
    80004fc0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004fc4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004fc8:	07272823          	sw	s2,112(a4)
}
    80004fcc:	60e2                	ld	ra,24(sp)
    80004fce:	6442                	ld	s0,16(sp)
    80004fd0:	64a2                	ld	s1,8(sp)
    80004fd2:	6902                	ld	s2,0(sp)
    80004fd4:	6105                	addi	sp,sp,32
    80004fd6:	8082                	ret
    panic("could not find virtio disk");
    80004fd8:	00002517          	auipc	a0,0x2
    80004fdc:	77850513          	addi	a0,a0,1912 # 80007750 <etext+0x750>
    80004fe0:	277000ef          	jal	80005a56 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004fe4:	00002517          	auipc	a0,0x2
    80004fe8:	78c50513          	addi	a0,a0,1932 # 80007770 <etext+0x770>
    80004fec:	26b000ef          	jal	80005a56 <panic>
    panic("virtio disk should not be ready");
    80004ff0:	00002517          	auipc	a0,0x2
    80004ff4:	7a050513          	addi	a0,a0,1952 # 80007790 <etext+0x790>
    80004ff8:	25f000ef          	jal	80005a56 <panic>
    panic("virtio disk has no queue 0");
    80004ffc:	00002517          	auipc	a0,0x2
    80005000:	7b450513          	addi	a0,a0,1972 # 800077b0 <etext+0x7b0>
    80005004:	253000ef          	jal	80005a56 <panic>
    panic("virtio disk max queue too short");
    80005008:	00002517          	auipc	a0,0x2
    8000500c:	7c850513          	addi	a0,a0,1992 # 800077d0 <etext+0x7d0>
    80005010:	247000ef          	jal	80005a56 <panic>
    panic("virtio disk kalloc");
    80005014:	00002517          	auipc	a0,0x2
    80005018:	7dc50513          	addi	a0,a0,2012 # 800077f0 <etext+0x7f0>
    8000501c:	23b000ef          	jal	80005a56 <panic>

0000000080005020 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005020:	711d                	addi	sp,sp,-96
    80005022:	ec86                	sd	ra,88(sp)
    80005024:	e8a2                	sd	s0,80(sp)
    80005026:	e4a6                	sd	s1,72(sp)
    80005028:	e0ca                	sd	s2,64(sp)
    8000502a:	fc4e                	sd	s3,56(sp)
    8000502c:	f852                	sd	s4,48(sp)
    8000502e:	f456                	sd	s5,40(sp)
    80005030:	f05a                	sd	s6,32(sp)
    80005032:	ec5e                	sd	s7,24(sp)
    80005034:	e862                	sd	s8,16(sp)
    80005036:	1080                	addi	s0,sp,96
    80005038:	89aa                	mv	s3,a0
    8000503a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000503c:	00c52b83          	lw	s7,12(a0)
    80005040:	001b9b9b          	slliw	s7,s7,0x1
    80005044:	1b82                	slli	s7,s7,0x20
    80005046:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000504a:	00020517          	auipc	a0,0x20
    8000504e:	76e50513          	addi	a0,a0,1902 # 800257b8 <disk+0x128>
    80005052:	533000ef          	jal	80005d84 <acquire>
  for(int i = 0; i < NUM; i++){
    80005056:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005058:	00020a97          	auipc	s5,0x20
    8000505c:	638a8a93          	addi	s5,s5,1592 # 80025690 <disk>
  for(int i = 0; i < 3; i++){
    80005060:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005062:	5c7d                	li	s8,-1
    80005064:	a095                	j	800050c8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005066:	00fa8733          	add	a4,s5,a5
    8000506a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000506e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005070:	0207c563          	bltz	a5,8000509a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80005074:	2905                	addiw	s2,s2,1
    80005076:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005078:	05490c63          	beq	s2,s4,800050d0 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    8000507c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000507e:	00020717          	auipc	a4,0x20
    80005082:	61270713          	addi	a4,a4,1554 # 80025690 <disk>
    80005086:	4781                	li	a5,0
    if(disk.free[i]){
    80005088:	01874683          	lbu	a3,24(a4)
    8000508c:	fee9                	bnez	a3,80005066 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    8000508e:	2785                	addiw	a5,a5,1
    80005090:	0705                	addi	a4,a4,1
    80005092:	fe979be3          	bne	a5,s1,80005088 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005096:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    8000509a:	01205d63          	blez	s2,800050b4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000509e:	fa042503          	lw	a0,-96(s0)
    800050a2:	d41ff0ef          	jal	80004de2 <free_desc>
      for(int j = 0; j < i; j++)
    800050a6:	4785                	li	a5,1
    800050a8:	0127d663          	bge	a5,s2,800050b4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800050ac:	fa442503          	lw	a0,-92(s0)
    800050b0:	d33ff0ef          	jal	80004de2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800050b4:	00020597          	auipc	a1,0x20
    800050b8:	70458593          	addi	a1,a1,1796 # 800257b8 <disk+0x128>
    800050bc:	00020517          	auipc	a0,0x20
    800050c0:	5ec50513          	addi	a0,a0,1516 # 800256a8 <disk+0x18>
    800050c4:	b58fc0ef          	jal	8000141c <sleep>
  for(int i = 0; i < 3; i++){
    800050c8:	fa040613          	addi	a2,s0,-96
    800050cc:	4901                	li	s2,0
    800050ce:	b77d                	j	8000507c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800050d0:	fa042503          	lw	a0,-96(s0)
    800050d4:	00451693          	slli	a3,a0,0x4

  if(write)
    800050d8:	00020797          	auipc	a5,0x20
    800050dc:	5b878793          	addi	a5,a5,1464 # 80025690 <disk>
    800050e0:	00a50713          	addi	a4,a0,10
    800050e4:	0712                	slli	a4,a4,0x4
    800050e6:	973e                	add	a4,a4,a5
    800050e8:	01603633          	snez	a2,s6
    800050ec:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800050ee:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800050f2:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800050f6:	6398                	ld	a4,0(a5)
    800050f8:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800050fa:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    800050fe:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005100:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005102:	6390                	ld	a2,0(a5)
    80005104:	00d605b3          	add	a1,a2,a3
    80005108:	4741                	li	a4,16
    8000510a:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000510c:	4805                	li	a6,1
    8000510e:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005112:	fa442703          	lw	a4,-92(s0)
    80005116:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000511a:	0712                	slli	a4,a4,0x4
    8000511c:	963a                	add	a2,a2,a4
    8000511e:	05898593          	addi	a1,s3,88
    80005122:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005124:	0007b883          	ld	a7,0(a5)
    80005128:	9746                	add	a4,a4,a7
    8000512a:	40000613          	li	a2,1024
    8000512e:	c710                	sw	a2,8(a4)
  if(write)
    80005130:	001b3613          	seqz	a2,s6
    80005134:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005138:	01066633          	or	a2,a2,a6
    8000513c:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005140:	fa842583          	lw	a1,-88(s0)
    80005144:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005148:	00250613          	addi	a2,a0,2
    8000514c:	0612                	slli	a2,a2,0x4
    8000514e:	963e                	add	a2,a2,a5
    80005150:	577d                	li	a4,-1
    80005152:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005156:	0592                	slli	a1,a1,0x4
    80005158:	98ae                	add	a7,a7,a1
    8000515a:	03068713          	addi	a4,a3,48
    8000515e:	973e                	add	a4,a4,a5
    80005160:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005164:	6398                	ld	a4,0(a5)
    80005166:	972e                	add	a4,a4,a1
    80005168:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000516c:	4689                	li	a3,2
    8000516e:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005172:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005176:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    8000517a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000517e:	6794                	ld	a3,8(a5)
    80005180:	0026d703          	lhu	a4,2(a3)
    80005184:	8b1d                	andi	a4,a4,7
    80005186:	0706                	slli	a4,a4,0x1
    80005188:	96ba                	add	a3,a3,a4
    8000518a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000518e:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005192:	6798                	ld	a4,8(a5)
    80005194:	00275783          	lhu	a5,2(a4)
    80005198:	2785                	addiw	a5,a5,1
    8000519a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000519e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800051a2:	100017b7          	lui	a5,0x10001
    800051a6:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800051aa:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    800051ae:	00020917          	auipc	s2,0x20
    800051b2:	60a90913          	addi	s2,s2,1546 # 800257b8 <disk+0x128>
  while(b->disk == 1) {
    800051b6:	84c2                	mv	s1,a6
    800051b8:	01079a63          	bne	a5,a6,800051cc <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    800051bc:	85ca                	mv	a1,s2
    800051be:	854e                	mv	a0,s3
    800051c0:	a5cfc0ef          	jal	8000141c <sleep>
  while(b->disk == 1) {
    800051c4:	0049a783          	lw	a5,4(s3)
    800051c8:	fe978ae3          	beq	a5,s1,800051bc <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    800051cc:	fa042903          	lw	s2,-96(s0)
    800051d0:	00290713          	addi	a4,s2,2
    800051d4:	0712                	slli	a4,a4,0x4
    800051d6:	00020797          	auipc	a5,0x20
    800051da:	4ba78793          	addi	a5,a5,1210 # 80025690 <disk>
    800051de:	97ba                	add	a5,a5,a4
    800051e0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800051e4:	00020997          	auipc	s3,0x20
    800051e8:	4ac98993          	addi	s3,s3,1196 # 80025690 <disk>
    800051ec:	00491713          	slli	a4,s2,0x4
    800051f0:	0009b783          	ld	a5,0(s3)
    800051f4:	97ba                	add	a5,a5,a4
    800051f6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800051fa:	854a                	mv	a0,s2
    800051fc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005200:	be3ff0ef          	jal	80004de2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005204:	8885                	andi	s1,s1,1
    80005206:	f0fd                	bnez	s1,800051ec <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005208:	00020517          	auipc	a0,0x20
    8000520c:	5b050513          	addi	a0,a0,1456 # 800257b8 <disk+0x128>
    80005210:	409000ef          	jal	80005e18 <release>
}
    80005214:	60e6                	ld	ra,88(sp)
    80005216:	6446                	ld	s0,80(sp)
    80005218:	64a6                	ld	s1,72(sp)
    8000521a:	6906                	ld	s2,64(sp)
    8000521c:	79e2                	ld	s3,56(sp)
    8000521e:	7a42                	ld	s4,48(sp)
    80005220:	7aa2                	ld	s5,40(sp)
    80005222:	7b02                	ld	s6,32(sp)
    80005224:	6be2                	ld	s7,24(sp)
    80005226:	6c42                	ld	s8,16(sp)
    80005228:	6125                	addi	sp,sp,96
    8000522a:	8082                	ret

000000008000522c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000522c:	1101                	addi	sp,sp,-32
    8000522e:	ec06                	sd	ra,24(sp)
    80005230:	e822                	sd	s0,16(sp)
    80005232:	e426                	sd	s1,8(sp)
    80005234:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005236:	00020497          	auipc	s1,0x20
    8000523a:	45a48493          	addi	s1,s1,1114 # 80025690 <disk>
    8000523e:	00020517          	auipc	a0,0x20
    80005242:	57a50513          	addi	a0,a0,1402 # 800257b8 <disk+0x128>
    80005246:	33f000ef          	jal	80005d84 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000524a:	100017b7          	lui	a5,0x10001
    8000524e:	53bc                	lw	a5,96(a5)
    80005250:	8b8d                	andi	a5,a5,3
    80005252:	10001737          	lui	a4,0x10001
    80005256:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005258:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000525c:	689c                	ld	a5,16(s1)
    8000525e:	0204d703          	lhu	a4,32(s1)
    80005262:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005266:	04f70663          	beq	a4,a5,800052b2 <virtio_disk_intr+0x86>
    __sync_synchronize();
    8000526a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000526e:	6898                	ld	a4,16(s1)
    80005270:	0204d783          	lhu	a5,32(s1)
    80005274:	8b9d                	andi	a5,a5,7
    80005276:	078e                	slli	a5,a5,0x3
    80005278:	97ba                	add	a5,a5,a4
    8000527a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000527c:	00278713          	addi	a4,a5,2
    80005280:	0712                	slli	a4,a4,0x4
    80005282:	9726                	add	a4,a4,s1
    80005284:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005288:	e321                	bnez	a4,800052c8 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000528a:	0789                	addi	a5,a5,2
    8000528c:	0792                	slli	a5,a5,0x4
    8000528e:	97a6                	add	a5,a5,s1
    80005290:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005292:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005296:	9d2fc0ef          	jal	80001468 <wakeup>

    disk.used_idx += 1;
    8000529a:	0204d783          	lhu	a5,32(s1)
    8000529e:	2785                	addiw	a5,a5,1
    800052a0:	17c2                	slli	a5,a5,0x30
    800052a2:	93c1                	srli	a5,a5,0x30
    800052a4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800052a8:	6898                	ld	a4,16(s1)
    800052aa:	00275703          	lhu	a4,2(a4)
    800052ae:	faf71ee3          	bne	a4,a5,8000526a <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800052b2:	00020517          	auipc	a0,0x20
    800052b6:	50650513          	addi	a0,a0,1286 # 800257b8 <disk+0x128>
    800052ba:	35f000ef          	jal	80005e18 <release>
}
    800052be:	60e2                	ld	ra,24(sp)
    800052c0:	6442                	ld	s0,16(sp)
    800052c2:	64a2                	ld	s1,8(sp)
    800052c4:	6105                	addi	sp,sp,32
    800052c6:	8082                	ret
      panic("virtio_disk_intr status");
    800052c8:	00002517          	auipc	a0,0x2
    800052cc:	54050513          	addi	a0,a0,1344 # 80007808 <etext+0x808>
    800052d0:	786000ef          	jal	80005a56 <panic>

00000000800052d4 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    800052d4:	1141                	addi	sp,sp,-16
    800052d6:	e406                	sd	ra,8(sp)
    800052d8:	e022                	sd	s0,0(sp)
    800052da:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    800052dc:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    800052e0:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    800052e4:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    800052e8:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    800052ec:	577d                	li	a4,-1
    800052ee:	177e                	slli	a4,a4,0x3f
    800052f0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    800052f2:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    800052f6:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    800052fa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    800052fe:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80005302:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80005306:	000f4737          	lui	a4,0xf4
    8000530a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000530e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80005310:	14d79073          	csrw	stimecmp,a5
}
    80005314:	60a2                	ld	ra,8(sp)
    80005316:	6402                	ld	s0,0(sp)
    80005318:	0141                	addi	sp,sp,16
    8000531a:	8082                	ret

000000008000531c <start>:
{
    8000531c:	1141                	addi	sp,sp,-16
    8000531e:	e406                	sd	ra,8(sp)
    80005320:	e022                	sd	s0,0(sp)
    80005322:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005324:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005328:	7779                	lui	a4,0xffffe
    8000532a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd0f2f>
    8000532e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005330:	6705                	lui	a4,0x1
    80005332:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005336:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005338:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000533c:	ffffb797          	auipc	a5,0xffffb
    80005340:	fc878793          	addi	a5,a5,-56 # 80000304 <main>
    80005344:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005348:	4781                	li	a5,0
    8000534a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000534e:	67c1                	lui	a5,0x10
    80005350:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005352:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005356:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000535a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000535e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005362:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005366:	57fd                	li	a5,-1
    80005368:	83a9                	srli	a5,a5,0xa
    8000536a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000536e:	47bd                	li	a5,15
    80005370:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005374:	f61ff0ef          	jal	800052d4 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005378:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000537c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000537e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005380:	30200073          	mret
}
    80005384:	60a2                	ld	ra,8(sp)
    80005386:	6402                	ld	s0,0(sp)
    80005388:	0141                	addi	sp,sp,16
    8000538a:	8082                	ret

000000008000538c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000538c:	711d                	addi	sp,sp,-96
    8000538e:	ec86                	sd	ra,88(sp)
    80005390:	e8a2                	sd	s0,80(sp)
    80005392:	e0ca                	sd	s2,64(sp)
    80005394:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80005396:	04c05863          	blez	a2,800053e6 <consolewrite+0x5a>
    8000539a:	e4a6                	sd	s1,72(sp)
    8000539c:	fc4e                	sd	s3,56(sp)
    8000539e:	f852                	sd	s4,48(sp)
    800053a0:	f456                	sd	s5,40(sp)
    800053a2:	f05a                	sd	s6,32(sp)
    800053a4:	ec5e                	sd	s7,24(sp)
    800053a6:	8a2a                	mv	s4,a0
    800053a8:	84ae                	mv	s1,a1
    800053aa:	89b2                	mv	s3,a2
    800053ac:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800053ae:	faf40b93          	addi	s7,s0,-81
    800053b2:	4b05                	li	s6,1
    800053b4:	5afd                	li	s5,-1
    800053b6:	86da                	mv	a3,s6
    800053b8:	8626                	mv	a2,s1
    800053ba:	85d2                	mv	a1,s4
    800053bc:	855e                	mv	a0,s7
    800053be:	c44fc0ef          	jal	80001802 <either_copyin>
    800053c2:	03550463          	beq	a0,s5,800053ea <consolewrite+0x5e>
      break;
    uartputc(c);
    800053c6:	faf44503          	lbu	a0,-81(s0)
    800053ca:	02d000ef          	jal	80005bf6 <uartputc>
  for(i = 0; i < n; i++){
    800053ce:	2905                	addiw	s2,s2,1
    800053d0:	0485                	addi	s1,s1,1
    800053d2:	ff2992e3          	bne	s3,s2,800053b6 <consolewrite+0x2a>
    800053d6:	894e                	mv	s2,s3
    800053d8:	64a6                	ld	s1,72(sp)
    800053da:	79e2                	ld	s3,56(sp)
    800053dc:	7a42                	ld	s4,48(sp)
    800053de:	7aa2                	ld	s5,40(sp)
    800053e0:	7b02                	ld	s6,32(sp)
    800053e2:	6be2                	ld	s7,24(sp)
    800053e4:	a809                	j	800053f6 <consolewrite+0x6a>
    800053e6:	4901                	li	s2,0
    800053e8:	a039                	j	800053f6 <consolewrite+0x6a>
    800053ea:	64a6                	ld	s1,72(sp)
    800053ec:	79e2                	ld	s3,56(sp)
    800053ee:	7a42                	ld	s4,48(sp)
    800053f0:	7aa2                	ld	s5,40(sp)
    800053f2:	7b02                	ld	s6,32(sp)
    800053f4:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    800053f6:	854a                	mv	a0,s2
    800053f8:	60e6                	ld	ra,88(sp)
    800053fa:	6446                	ld	s0,80(sp)
    800053fc:	6906                	ld	s2,64(sp)
    800053fe:	6125                	addi	sp,sp,96
    80005400:	8082                	ret

0000000080005402 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005402:	711d                	addi	sp,sp,-96
    80005404:	ec86                	sd	ra,88(sp)
    80005406:	e8a2                	sd	s0,80(sp)
    80005408:	e4a6                	sd	s1,72(sp)
    8000540a:	e0ca                	sd	s2,64(sp)
    8000540c:	fc4e                	sd	s3,56(sp)
    8000540e:	f852                	sd	s4,48(sp)
    80005410:	f456                	sd	s5,40(sp)
    80005412:	f05a                	sd	s6,32(sp)
    80005414:	1080                	addi	s0,sp,96
    80005416:	8aaa                	mv	s5,a0
    80005418:	8a2e                	mv	s4,a1
    8000541a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000541c:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    8000541e:	00028517          	auipc	a0,0x28
    80005422:	3b250513          	addi	a0,a0,946 # 8002d7d0 <cons>
    80005426:	15f000ef          	jal	80005d84 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000542a:	00028497          	auipc	s1,0x28
    8000542e:	3a648493          	addi	s1,s1,934 # 8002d7d0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005432:	00028917          	auipc	s2,0x28
    80005436:	43690913          	addi	s2,s2,1078 # 8002d868 <cons+0x98>
  while(n > 0){
    8000543a:	0b305b63          	blez	s3,800054f0 <consoleread+0xee>
    while(cons.r == cons.w){
    8000543e:	0984a783          	lw	a5,152(s1)
    80005442:	09c4a703          	lw	a4,156(s1)
    80005446:	0af71063          	bne	a4,a5,800054e6 <consoleread+0xe4>
      if(killed(myproc())){
    8000544a:	9c1fb0ef          	jal	80000e0a <myproc>
    8000544e:	a4cfc0ef          	jal	8000169a <killed>
    80005452:	e12d                	bnez	a0,800054b4 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80005454:	85a6                	mv	a1,s1
    80005456:	854a                	mv	a0,s2
    80005458:	fc5fb0ef          	jal	8000141c <sleep>
    while(cons.r == cons.w){
    8000545c:	0984a783          	lw	a5,152(s1)
    80005460:	09c4a703          	lw	a4,156(s1)
    80005464:	fef703e3          	beq	a4,a5,8000544a <consoleread+0x48>
    80005468:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000546a:	00028717          	auipc	a4,0x28
    8000546e:	36670713          	addi	a4,a4,870 # 8002d7d0 <cons>
    80005472:	0017869b          	addiw	a3,a5,1
    80005476:	08d72c23          	sw	a3,152(a4)
    8000547a:	07f7f693          	andi	a3,a5,127
    8000547e:	9736                	add	a4,a4,a3
    80005480:	01874703          	lbu	a4,24(a4)
    80005484:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005488:	4691                	li	a3,4
    8000548a:	04db8663          	beq	s7,a3,800054d6 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000548e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005492:	4685                	li	a3,1
    80005494:	faf40613          	addi	a2,s0,-81
    80005498:	85d2                	mv	a1,s4
    8000549a:	8556                	mv	a0,s5
    8000549c:	b1cfc0ef          	jal	800017b8 <either_copyout>
    800054a0:	57fd                	li	a5,-1
    800054a2:	04f50663          	beq	a0,a5,800054ee <consoleread+0xec>
      break;

    dst++;
    800054a6:	0a05                	addi	s4,s4,1 # fffffffffffff001 <end+0xffffffff7ffd1731>
    --n;
    800054a8:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800054aa:	47a9                	li	a5,10
    800054ac:	04fb8b63          	beq	s7,a5,80005502 <consoleread+0x100>
    800054b0:	6be2                	ld	s7,24(sp)
    800054b2:	b761                	j	8000543a <consoleread+0x38>
        release(&cons.lock);
    800054b4:	00028517          	auipc	a0,0x28
    800054b8:	31c50513          	addi	a0,a0,796 # 8002d7d0 <cons>
    800054bc:	15d000ef          	jal	80005e18 <release>
        return -1;
    800054c0:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800054c2:	60e6                	ld	ra,88(sp)
    800054c4:	6446                	ld	s0,80(sp)
    800054c6:	64a6                	ld	s1,72(sp)
    800054c8:	6906                	ld	s2,64(sp)
    800054ca:	79e2                	ld	s3,56(sp)
    800054cc:	7a42                	ld	s4,48(sp)
    800054ce:	7aa2                	ld	s5,40(sp)
    800054d0:	7b02                	ld	s6,32(sp)
    800054d2:	6125                	addi	sp,sp,96
    800054d4:	8082                	ret
      if(n < target){
    800054d6:	0169fa63          	bgeu	s3,s6,800054ea <consoleread+0xe8>
        cons.r--;
    800054da:	00028717          	auipc	a4,0x28
    800054de:	38f72723          	sw	a5,910(a4) # 8002d868 <cons+0x98>
    800054e2:	6be2                	ld	s7,24(sp)
    800054e4:	a031                	j	800054f0 <consoleread+0xee>
    800054e6:	ec5e                	sd	s7,24(sp)
    800054e8:	b749                	j	8000546a <consoleread+0x68>
    800054ea:	6be2                	ld	s7,24(sp)
    800054ec:	a011                	j	800054f0 <consoleread+0xee>
    800054ee:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800054f0:	00028517          	auipc	a0,0x28
    800054f4:	2e050513          	addi	a0,a0,736 # 8002d7d0 <cons>
    800054f8:	121000ef          	jal	80005e18 <release>
  return target - n;
    800054fc:	413b053b          	subw	a0,s6,s3
    80005500:	b7c9                	j	800054c2 <consoleread+0xc0>
    80005502:	6be2                	ld	s7,24(sp)
    80005504:	b7f5                	j	800054f0 <consoleread+0xee>

0000000080005506 <consputc>:
{
    80005506:	1141                	addi	sp,sp,-16
    80005508:	e406                	sd	ra,8(sp)
    8000550a:	e022                	sd	s0,0(sp)
    8000550c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000550e:	10000793          	li	a5,256
    80005512:	00f50863          	beq	a0,a5,80005522 <consputc+0x1c>
    uartputc_sync(c);
    80005516:	5fe000ef          	jal	80005b14 <uartputc_sync>
}
    8000551a:	60a2                	ld	ra,8(sp)
    8000551c:	6402                	ld	s0,0(sp)
    8000551e:	0141                	addi	sp,sp,16
    80005520:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005522:	4521                	li	a0,8
    80005524:	5f0000ef          	jal	80005b14 <uartputc_sync>
    80005528:	02000513          	li	a0,32
    8000552c:	5e8000ef          	jal	80005b14 <uartputc_sync>
    80005530:	4521                	li	a0,8
    80005532:	5e2000ef          	jal	80005b14 <uartputc_sync>
    80005536:	b7d5                	j	8000551a <consputc+0x14>

0000000080005538 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005538:	7179                	addi	sp,sp,-48
    8000553a:	f406                	sd	ra,40(sp)
    8000553c:	f022                	sd	s0,32(sp)
    8000553e:	ec26                	sd	s1,24(sp)
    80005540:	1800                	addi	s0,sp,48
    80005542:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005544:	00028517          	auipc	a0,0x28
    80005548:	28c50513          	addi	a0,a0,652 # 8002d7d0 <cons>
    8000554c:	039000ef          	jal	80005d84 <acquire>

  switch(c){
    80005550:	47d5                	li	a5,21
    80005552:	08f48e63          	beq	s1,a5,800055ee <consoleintr+0xb6>
    80005556:	0297c563          	blt	a5,s1,80005580 <consoleintr+0x48>
    8000555a:	47a1                	li	a5,8
    8000555c:	0ef48863          	beq	s1,a5,8000564c <consoleintr+0x114>
    80005560:	47c1                	li	a5,16
    80005562:	10f49963          	bne	s1,a5,80005674 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    80005566:	ae6fc0ef          	jal	8000184c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000556a:	00028517          	auipc	a0,0x28
    8000556e:	26650513          	addi	a0,a0,614 # 8002d7d0 <cons>
    80005572:	0a7000ef          	jal	80005e18 <release>
}
    80005576:	70a2                	ld	ra,40(sp)
    80005578:	7402                	ld	s0,32(sp)
    8000557a:	64e2                	ld	s1,24(sp)
    8000557c:	6145                	addi	sp,sp,48
    8000557e:	8082                	ret
  switch(c){
    80005580:	07f00793          	li	a5,127
    80005584:	0cf48463          	beq	s1,a5,8000564c <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005588:	00028717          	auipc	a4,0x28
    8000558c:	24870713          	addi	a4,a4,584 # 8002d7d0 <cons>
    80005590:	0a072783          	lw	a5,160(a4)
    80005594:	09872703          	lw	a4,152(a4)
    80005598:	9f99                	subw	a5,a5,a4
    8000559a:	07f00713          	li	a4,127
    8000559e:	fcf766e3          	bltu	a4,a5,8000556a <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800055a2:	47b5                	li	a5,13
    800055a4:	0cf48b63          	beq	s1,a5,8000567a <consoleintr+0x142>
      consputc(c);
    800055a8:	8526                	mv	a0,s1
    800055aa:	f5dff0ef          	jal	80005506 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800055ae:	00028797          	auipc	a5,0x28
    800055b2:	22278793          	addi	a5,a5,546 # 8002d7d0 <cons>
    800055b6:	0a07a683          	lw	a3,160(a5)
    800055ba:	0016871b          	addiw	a4,a3,1
    800055be:	863a                	mv	a2,a4
    800055c0:	0ae7a023          	sw	a4,160(a5)
    800055c4:	07f6f693          	andi	a3,a3,127
    800055c8:	97b6                	add	a5,a5,a3
    800055ca:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800055ce:	47a9                	li	a5,10
    800055d0:	0cf48963          	beq	s1,a5,800056a2 <consoleintr+0x16a>
    800055d4:	4791                	li	a5,4
    800055d6:	0cf48663          	beq	s1,a5,800056a2 <consoleintr+0x16a>
    800055da:	00028797          	auipc	a5,0x28
    800055de:	28e7a783          	lw	a5,654(a5) # 8002d868 <cons+0x98>
    800055e2:	9f1d                	subw	a4,a4,a5
    800055e4:	08000793          	li	a5,128
    800055e8:	f8f711e3          	bne	a4,a5,8000556a <consoleintr+0x32>
    800055ec:	a85d                	j	800056a2 <consoleintr+0x16a>
    800055ee:	e84a                	sd	s2,16(sp)
    800055f0:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    800055f2:	00028717          	auipc	a4,0x28
    800055f6:	1de70713          	addi	a4,a4,478 # 8002d7d0 <cons>
    800055fa:	0a072783          	lw	a5,160(a4)
    800055fe:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005602:	00028497          	auipc	s1,0x28
    80005606:	1ce48493          	addi	s1,s1,462 # 8002d7d0 <cons>
    while(cons.e != cons.w &&
    8000560a:	4929                	li	s2,10
      consputc(BACKSPACE);
    8000560c:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80005610:	02f70863          	beq	a4,a5,80005640 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005614:	37fd                	addiw	a5,a5,-1
    80005616:	07f7f713          	andi	a4,a5,127
    8000561a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000561c:	01874703          	lbu	a4,24(a4)
    80005620:	03270363          	beq	a4,s2,80005646 <consoleintr+0x10e>
      cons.e--;
    80005624:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005628:	854e                	mv	a0,s3
    8000562a:	eddff0ef          	jal	80005506 <consputc>
    while(cons.e != cons.w &&
    8000562e:	0a04a783          	lw	a5,160(s1)
    80005632:	09c4a703          	lw	a4,156(s1)
    80005636:	fcf71fe3          	bne	a4,a5,80005614 <consoleintr+0xdc>
    8000563a:	6942                	ld	s2,16(sp)
    8000563c:	69a2                	ld	s3,8(sp)
    8000563e:	b735                	j	8000556a <consoleintr+0x32>
    80005640:	6942                	ld	s2,16(sp)
    80005642:	69a2                	ld	s3,8(sp)
    80005644:	b71d                	j	8000556a <consoleintr+0x32>
    80005646:	6942                	ld	s2,16(sp)
    80005648:	69a2                	ld	s3,8(sp)
    8000564a:	b705                	j	8000556a <consoleintr+0x32>
    if(cons.e != cons.w){
    8000564c:	00028717          	auipc	a4,0x28
    80005650:	18470713          	addi	a4,a4,388 # 8002d7d0 <cons>
    80005654:	0a072783          	lw	a5,160(a4)
    80005658:	09c72703          	lw	a4,156(a4)
    8000565c:	f0f707e3          	beq	a4,a5,8000556a <consoleintr+0x32>
      cons.e--;
    80005660:	37fd                	addiw	a5,a5,-1
    80005662:	00028717          	auipc	a4,0x28
    80005666:	20f72723          	sw	a5,526(a4) # 8002d870 <cons+0xa0>
      consputc(BACKSPACE);
    8000566a:	10000513          	li	a0,256
    8000566e:	e99ff0ef          	jal	80005506 <consputc>
    80005672:	bde5                	j	8000556a <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005674:	ee048be3          	beqz	s1,8000556a <consoleintr+0x32>
    80005678:	bf01                	j	80005588 <consoleintr+0x50>
      consputc(c);
    8000567a:	4529                	li	a0,10
    8000567c:	e8bff0ef          	jal	80005506 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005680:	00028797          	auipc	a5,0x28
    80005684:	15078793          	addi	a5,a5,336 # 8002d7d0 <cons>
    80005688:	0a07a703          	lw	a4,160(a5)
    8000568c:	0017069b          	addiw	a3,a4,1
    80005690:	8636                	mv	a2,a3
    80005692:	0ad7a023          	sw	a3,160(a5)
    80005696:	07f77713          	andi	a4,a4,127
    8000569a:	97ba                	add	a5,a5,a4
    8000569c:	4729                	li	a4,10
    8000569e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800056a2:	00028797          	auipc	a5,0x28
    800056a6:	1cc7a523          	sw	a2,458(a5) # 8002d86c <cons+0x9c>
        wakeup(&cons.r);
    800056aa:	00028517          	auipc	a0,0x28
    800056ae:	1be50513          	addi	a0,a0,446 # 8002d868 <cons+0x98>
    800056b2:	db7fb0ef          	jal	80001468 <wakeup>
    800056b6:	bd55                	j	8000556a <consoleintr+0x32>

00000000800056b8 <consoleinit>:

void
consoleinit(void)
{
    800056b8:	1141                	addi	sp,sp,-16
    800056ba:	e406                	sd	ra,8(sp)
    800056bc:	e022                	sd	s0,0(sp)
    800056be:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800056c0:	00002597          	auipc	a1,0x2
    800056c4:	16058593          	addi	a1,a1,352 # 80007820 <etext+0x820>
    800056c8:	00028517          	auipc	a0,0x28
    800056cc:	10850513          	addi	a0,a0,264 # 8002d7d0 <cons>
    800056d0:	630000ef          	jal	80005d00 <initlock>

  uartinit();
    800056d4:	3ea000ef          	jal	80005abe <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800056d8:	0001f797          	auipc	a5,0x1f
    800056dc:	f6078793          	addi	a5,a5,-160 # 80024638 <devsw>
    800056e0:	00000717          	auipc	a4,0x0
    800056e4:	d2270713          	addi	a4,a4,-734 # 80005402 <consoleread>
    800056e8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800056ea:	00000717          	auipc	a4,0x0
    800056ee:	ca270713          	addi	a4,a4,-862 # 8000538c <consolewrite>
    800056f2:	ef98                	sd	a4,24(a5)
}
    800056f4:	60a2                	ld	ra,8(sp)
    800056f6:	6402                	ld	s0,0(sp)
    800056f8:	0141                	addi	sp,sp,16
    800056fa:	8082                	ret

00000000800056fc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800056fc:	7179                	addi	sp,sp,-48
    800056fe:	f406                	sd	ra,40(sp)
    80005700:	f022                	sd	s0,32(sp)
    80005702:	ec26                	sd	s1,24(sp)
    80005704:	e84a                	sd	s2,16(sp)
    80005706:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005708:	c219                	beqz	a2,8000570e <printint+0x12>
    8000570a:	06054a63          	bltz	a0,8000577e <printint+0x82>
    x = -xx;
  else
    x = xx;
    8000570e:	4e01                	li	t3,0

  i = 0;
    80005710:	fd040313          	addi	t1,s0,-48
    x = xx;
    80005714:	869a                	mv	a3,t1
  i = 0;
    80005716:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005718:	00002817          	auipc	a6,0x2
    8000571c:	27080813          	addi	a6,a6,624 # 80007988 <digits>
    80005720:	88be                	mv	a7,a5
    80005722:	0017861b          	addiw	a2,a5,1
    80005726:	87b2                	mv	a5,a2
    80005728:	02b57733          	remu	a4,a0,a1
    8000572c:	9742                	add	a4,a4,a6
    8000572e:	00074703          	lbu	a4,0(a4)
    80005732:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005736:	872a                	mv	a4,a0
    80005738:	02b55533          	divu	a0,a0,a1
    8000573c:	0685                	addi	a3,a3,1
    8000573e:	feb771e3          	bgeu	a4,a1,80005720 <printint+0x24>

  if(sign)
    80005742:	000e0c63          	beqz	t3,8000575a <printint+0x5e>
    buf[i++] = '-';
    80005746:	fe060793          	addi	a5,a2,-32
    8000574a:	00878633          	add	a2,a5,s0
    8000574e:	02d00793          	li	a5,45
    80005752:	fef60823          	sb	a5,-16(a2)
    80005756:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    8000575a:	fff7891b          	addiw	s2,a5,-1
    8000575e:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005762:	fff4c503          	lbu	a0,-1(s1)
    80005766:	da1ff0ef          	jal	80005506 <consputc>
  while(--i >= 0)
    8000576a:	397d                	addiw	s2,s2,-1
    8000576c:	14fd                	addi	s1,s1,-1
    8000576e:	fe095ae3          	bgez	s2,80005762 <printint+0x66>
}
    80005772:	70a2                	ld	ra,40(sp)
    80005774:	7402                	ld	s0,32(sp)
    80005776:	64e2                	ld	s1,24(sp)
    80005778:	6942                	ld	s2,16(sp)
    8000577a:	6145                	addi	sp,sp,48
    8000577c:	8082                	ret
    x = -xx;
    8000577e:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005782:	4e05                	li	t3,1
    x = -xx;
    80005784:	b771                	j	80005710 <printint+0x14>

0000000080005786 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005786:	7155                	addi	sp,sp,-208
    80005788:	e506                	sd	ra,136(sp)
    8000578a:	e122                	sd	s0,128(sp)
    8000578c:	f0d2                	sd	s4,96(sp)
    8000578e:	0900                	addi	s0,sp,144
    80005790:	8a2a                	mv	s4,a0
    80005792:	e40c                	sd	a1,8(s0)
    80005794:	e810                	sd	a2,16(s0)
    80005796:	ec14                	sd	a3,24(s0)
    80005798:	f018                	sd	a4,32(s0)
    8000579a:	f41c                	sd	a5,40(s0)
    8000579c:	03043823          	sd	a6,48(s0)
    800057a0:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800057a4:	00028797          	auipc	a5,0x28
    800057a8:	0ec7a783          	lw	a5,236(a5) # 8002d890 <pr+0x18>
    800057ac:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800057b0:	e3a1                	bnez	a5,800057f0 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800057b2:	00840793          	addi	a5,s0,8
    800057b6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800057ba:	00054503          	lbu	a0,0(a0)
    800057be:	26050663          	beqz	a0,80005a2a <printf+0x2a4>
    800057c2:	fca6                	sd	s1,120(sp)
    800057c4:	f8ca                	sd	s2,112(sp)
    800057c6:	f4ce                	sd	s3,104(sp)
    800057c8:	ecd6                	sd	s5,88(sp)
    800057ca:	e8da                	sd	s6,80(sp)
    800057cc:	e0e2                	sd	s8,64(sp)
    800057ce:	fc66                	sd	s9,56(sp)
    800057d0:	f86a                	sd	s10,48(sp)
    800057d2:	f46e                	sd	s11,40(sp)
    800057d4:	4981                	li	s3,0
    if(cx != '%'){
    800057d6:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800057da:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800057de:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800057e2:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800057e6:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800057ea:	07000d93          	li	s11,112
    800057ee:	a80d                	j	80005820 <printf+0x9a>
    acquire(&pr.lock);
    800057f0:	00028517          	auipc	a0,0x28
    800057f4:	08850513          	addi	a0,a0,136 # 8002d878 <pr>
    800057f8:	58c000ef          	jal	80005d84 <acquire>
  va_start(ap, fmt);
    800057fc:	00840793          	addi	a5,s0,8
    80005800:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005804:	000a4503          	lbu	a0,0(s4)
    80005808:	fd4d                	bnez	a0,800057c2 <printf+0x3c>
    8000580a:	ac3d                	j	80005a48 <printf+0x2c2>
      consputc(cx);
    8000580c:	cfbff0ef          	jal	80005506 <consputc>
      continue;
    80005810:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005812:	2485                	addiw	s1,s1,1
    80005814:	89a6                	mv	s3,s1
    80005816:	94d2                	add	s1,s1,s4
    80005818:	0004c503          	lbu	a0,0(s1)
    8000581c:	1e050b63          	beqz	a0,80005a12 <printf+0x28c>
    if(cx != '%'){
    80005820:	ff5516e3          	bne	a0,s5,8000580c <printf+0x86>
    i++;
    80005824:	0019879b          	addiw	a5,s3,1
    80005828:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000582a:	00fa0733          	add	a4,s4,a5
    8000582e:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005832:	1e090063          	beqz	s2,80005a12 <printf+0x28c>
    80005836:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    8000583a:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    8000583c:	c701                	beqz	a4,80005844 <printf+0xbe>
    8000583e:	97d2                	add	a5,a5,s4
    80005840:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    80005844:	03690763          	beq	s2,s6,80005872 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    80005848:	05890163          	beq	s2,s8,8000588a <printf+0x104>
    } else if(c0 == 'u'){
    8000584c:	0d990b63          	beq	s2,s9,80005922 <printf+0x19c>
    } else if(c0 == 'x'){
    80005850:	13a90163          	beq	s2,s10,80005972 <printf+0x1ec>
    } else if(c0 == 'p'){
    80005854:	13b90b63          	beq	s2,s11,8000598a <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005858:	07300793          	li	a5,115
    8000585c:	16f90a63          	beq	s2,a5,800059d0 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80005860:	1b590463          	beq	s2,s5,80005a08 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005864:	8556                	mv	a0,s5
    80005866:	ca1ff0ef          	jal	80005506 <consputc>
      consputc(c0);
    8000586a:	854a                	mv	a0,s2
    8000586c:	c9bff0ef          	jal	80005506 <consputc>
    80005870:	b74d                	j	80005812 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    80005872:	f8843783          	ld	a5,-120(s0)
    80005876:	00878713          	addi	a4,a5,8
    8000587a:	f8e43423          	sd	a4,-120(s0)
    8000587e:	4605                	li	a2,1
    80005880:	45a9                	li	a1,10
    80005882:	4388                	lw	a0,0(a5)
    80005884:	e79ff0ef          	jal	800056fc <printint>
    80005888:	b769                	j	80005812 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    8000588a:	03670663          	beq	a4,s6,800058b6 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000588e:	05870263          	beq	a4,s8,800058d2 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    80005892:	0b970463          	beq	a4,s9,8000593a <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    80005896:	fda717e3          	bne	a4,s10,80005864 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000589a:	f8843783          	ld	a5,-120(s0)
    8000589e:	00878713          	addi	a4,a5,8
    800058a2:	f8e43423          	sd	a4,-120(s0)
    800058a6:	4601                	li	a2,0
    800058a8:	45c1                	li	a1,16
    800058aa:	6388                	ld	a0,0(a5)
    800058ac:	e51ff0ef          	jal	800056fc <printint>
      i += 1;
    800058b0:	0029849b          	addiw	s1,s3,2
    800058b4:	bfb9                	j	80005812 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800058b6:	f8843783          	ld	a5,-120(s0)
    800058ba:	00878713          	addi	a4,a5,8
    800058be:	f8e43423          	sd	a4,-120(s0)
    800058c2:	4605                	li	a2,1
    800058c4:	45a9                	li	a1,10
    800058c6:	6388                	ld	a0,0(a5)
    800058c8:	e35ff0ef          	jal	800056fc <printint>
      i += 1;
    800058cc:	0029849b          	addiw	s1,s3,2
    800058d0:	b789                	j	80005812 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800058d2:	06400793          	li	a5,100
    800058d6:	02f68863          	beq	a3,a5,80005906 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800058da:	07500793          	li	a5,117
    800058de:	06f68c63          	beq	a3,a5,80005956 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800058e2:	07800793          	li	a5,120
    800058e6:	f6f69fe3          	bne	a3,a5,80005864 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    800058ea:	f8843783          	ld	a5,-120(s0)
    800058ee:	00878713          	addi	a4,a5,8
    800058f2:	f8e43423          	sd	a4,-120(s0)
    800058f6:	4601                	li	a2,0
    800058f8:	45c1                	li	a1,16
    800058fa:	6388                	ld	a0,0(a5)
    800058fc:	e01ff0ef          	jal	800056fc <printint>
      i += 2;
    80005900:	0039849b          	addiw	s1,s3,3
    80005904:	b739                	j	80005812 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005906:	f8843783          	ld	a5,-120(s0)
    8000590a:	00878713          	addi	a4,a5,8
    8000590e:	f8e43423          	sd	a4,-120(s0)
    80005912:	4605                	li	a2,1
    80005914:	45a9                	li	a1,10
    80005916:	6388                	ld	a0,0(a5)
    80005918:	de5ff0ef          	jal	800056fc <printint>
      i += 2;
    8000591c:	0039849b          	addiw	s1,s3,3
    80005920:	bdcd                	j	80005812 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80005922:	f8843783          	ld	a5,-120(s0)
    80005926:	00878713          	addi	a4,a5,8
    8000592a:	f8e43423          	sd	a4,-120(s0)
    8000592e:	4601                	li	a2,0
    80005930:	45a9                	li	a1,10
    80005932:	4388                	lw	a0,0(a5)
    80005934:	dc9ff0ef          	jal	800056fc <printint>
    80005938:	bde9                	j	80005812 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    8000593a:	f8843783          	ld	a5,-120(s0)
    8000593e:	00878713          	addi	a4,a5,8
    80005942:	f8e43423          	sd	a4,-120(s0)
    80005946:	4601                	li	a2,0
    80005948:	45a9                	li	a1,10
    8000594a:	6388                	ld	a0,0(a5)
    8000594c:	db1ff0ef          	jal	800056fc <printint>
      i += 1;
    80005950:	0029849b          	addiw	s1,s3,2
    80005954:	bd7d                	j	80005812 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005956:	f8843783          	ld	a5,-120(s0)
    8000595a:	00878713          	addi	a4,a5,8
    8000595e:	f8e43423          	sd	a4,-120(s0)
    80005962:	4601                	li	a2,0
    80005964:	45a9                	li	a1,10
    80005966:	6388                	ld	a0,0(a5)
    80005968:	d95ff0ef          	jal	800056fc <printint>
      i += 2;
    8000596c:	0039849b          	addiw	s1,s3,3
    80005970:	b54d                	j	80005812 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    80005972:	f8843783          	ld	a5,-120(s0)
    80005976:	00878713          	addi	a4,a5,8
    8000597a:	f8e43423          	sd	a4,-120(s0)
    8000597e:	4601                	li	a2,0
    80005980:	45c1                	li	a1,16
    80005982:	4388                	lw	a0,0(a5)
    80005984:	d79ff0ef          	jal	800056fc <printint>
    80005988:	b569                	j	80005812 <printf+0x8c>
    8000598a:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8000598c:	f8843783          	ld	a5,-120(s0)
    80005990:	00878713          	addi	a4,a5,8
    80005994:	f8e43423          	sd	a4,-120(s0)
    80005998:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000599c:	03000513          	li	a0,48
    800059a0:	b67ff0ef          	jal	80005506 <consputc>
  consputc('x');
    800059a4:	07800513          	li	a0,120
    800059a8:	b5fff0ef          	jal	80005506 <consputc>
    800059ac:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800059ae:	00002b97          	auipc	s7,0x2
    800059b2:	fdab8b93          	addi	s7,s7,-38 # 80007988 <digits>
    800059b6:	03c9d793          	srli	a5,s3,0x3c
    800059ba:	97de                	add	a5,a5,s7
    800059bc:	0007c503          	lbu	a0,0(a5)
    800059c0:	b47ff0ef          	jal	80005506 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800059c4:	0992                	slli	s3,s3,0x4
    800059c6:	397d                	addiw	s2,s2,-1
    800059c8:	fe0917e3          	bnez	s2,800059b6 <printf+0x230>
    800059cc:	6ba6                	ld	s7,72(sp)
    800059ce:	b591                	j	80005812 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    800059d0:	f8843783          	ld	a5,-120(s0)
    800059d4:	00878713          	addi	a4,a5,8
    800059d8:	f8e43423          	sd	a4,-120(s0)
    800059dc:	0007b903          	ld	s2,0(a5)
    800059e0:	00090d63          	beqz	s2,800059fa <printf+0x274>
      for(; *s; s++)
    800059e4:	00094503          	lbu	a0,0(s2)
    800059e8:	e20505e3          	beqz	a0,80005812 <printf+0x8c>
        consputc(*s);
    800059ec:	b1bff0ef          	jal	80005506 <consputc>
      for(; *s; s++)
    800059f0:	0905                	addi	s2,s2,1
    800059f2:	00094503          	lbu	a0,0(s2)
    800059f6:	f97d                	bnez	a0,800059ec <printf+0x266>
    800059f8:	bd29                	j	80005812 <printf+0x8c>
        s = "(null)";
    800059fa:	00002917          	auipc	s2,0x2
    800059fe:	e2e90913          	addi	s2,s2,-466 # 80007828 <etext+0x828>
      for(; *s; s++)
    80005a02:	02800513          	li	a0,40
    80005a06:	b7dd                	j	800059ec <printf+0x266>
      consputc('%');
    80005a08:	02500513          	li	a0,37
    80005a0c:	afbff0ef          	jal	80005506 <consputc>
    80005a10:	b509                	j	80005812 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80005a12:	f7843783          	ld	a5,-136(s0)
    80005a16:	e385                	bnez	a5,80005a36 <printf+0x2b0>
    80005a18:	74e6                	ld	s1,120(sp)
    80005a1a:	7946                	ld	s2,112(sp)
    80005a1c:	79a6                	ld	s3,104(sp)
    80005a1e:	6ae6                	ld	s5,88(sp)
    80005a20:	6b46                	ld	s6,80(sp)
    80005a22:	6c06                	ld	s8,64(sp)
    80005a24:	7ce2                	ld	s9,56(sp)
    80005a26:	7d42                	ld	s10,48(sp)
    80005a28:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80005a2a:	4501                	li	a0,0
    80005a2c:	60aa                	ld	ra,136(sp)
    80005a2e:	640a                	ld	s0,128(sp)
    80005a30:	7a06                	ld	s4,96(sp)
    80005a32:	6169                	addi	sp,sp,208
    80005a34:	8082                	ret
    80005a36:	74e6                	ld	s1,120(sp)
    80005a38:	7946                	ld	s2,112(sp)
    80005a3a:	79a6                	ld	s3,104(sp)
    80005a3c:	6ae6                	ld	s5,88(sp)
    80005a3e:	6b46                	ld	s6,80(sp)
    80005a40:	6c06                	ld	s8,64(sp)
    80005a42:	7ce2                	ld	s9,56(sp)
    80005a44:	7d42                	ld	s10,48(sp)
    80005a46:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005a48:	00028517          	auipc	a0,0x28
    80005a4c:	e3050513          	addi	a0,a0,-464 # 8002d878 <pr>
    80005a50:	3c8000ef          	jal	80005e18 <release>
    80005a54:	bfd9                	j	80005a2a <printf+0x2a4>

0000000080005a56 <panic>:

void
panic(char *s)
{
    80005a56:	1101                	addi	sp,sp,-32
    80005a58:	ec06                	sd	ra,24(sp)
    80005a5a:	e822                	sd	s0,16(sp)
    80005a5c:	e426                	sd	s1,8(sp)
    80005a5e:	1000                	addi	s0,sp,32
    80005a60:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005a62:	00028797          	auipc	a5,0x28
    80005a66:	e207a723          	sw	zero,-466(a5) # 8002d890 <pr+0x18>
  printf("panic: ");
    80005a6a:	00002517          	auipc	a0,0x2
    80005a6e:	dc650513          	addi	a0,a0,-570 # 80007830 <etext+0x830>
    80005a72:	d15ff0ef          	jal	80005786 <printf>
  printf("%s\n", s);
    80005a76:	85a6                	mv	a1,s1
    80005a78:	00002517          	auipc	a0,0x2
    80005a7c:	dc050513          	addi	a0,a0,-576 # 80007838 <etext+0x838>
    80005a80:	d07ff0ef          	jal	80005786 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005a84:	4785                	li	a5,1
    80005a86:	00005717          	auipc	a4,0x5
    80005a8a:	b0f72323          	sw	a5,-1274(a4) # 8000a58c <panicked>
  for(;;)
    80005a8e:	a001                	j	80005a8e <panic+0x38>

0000000080005a90 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005a90:	1101                	addi	sp,sp,-32
    80005a92:	ec06                	sd	ra,24(sp)
    80005a94:	e822                	sd	s0,16(sp)
    80005a96:	e426                	sd	s1,8(sp)
    80005a98:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005a9a:	00028497          	auipc	s1,0x28
    80005a9e:	dde48493          	addi	s1,s1,-546 # 8002d878 <pr>
    80005aa2:	00002597          	auipc	a1,0x2
    80005aa6:	d9e58593          	addi	a1,a1,-610 # 80007840 <etext+0x840>
    80005aaa:	8526                	mv	a0,s1
    80005aac:	254000ef          	jal	80005d00 <initlock>
  pr.locking = 1;
    80005ab0:	4785                	li	a5,1
    80005ab2:	cc9c                	sw	a5,24(s1)
}
    80005ab4:	60e2                	ld	ra,24(sp)
    80005ab6:	6442                	ld	s0,16(sp)
    80005ab8:	64a2                	ld	s1,8(sp)
    80005aba:	6105                	addi	sp,sp,32
    80005abc:	8082                	ret

0000000080005abe <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005abe:	1141                	addi	sp,sp,-16
    80005ac0:	e406                	sd	ra,8(sp)
    80005ac2:	e022                	sd	s0,0(sp)
    80005ac4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ac6:	100007b7          	lui	a5,0x10000
    80005aca:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ace:	10000737          	lui	a4,0x10000
    80005ad2:	f8000693          	li	a3,-128
    80005ad6:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ada:	468d                	li	a3,3
    80005adc:	10000637          	lui	a2,0x10000
    80005ae0:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ae4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ae8:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005aec:	8732                	mv	a4,a2
    80005aee:	461d                	li	a2,7
    80005af0:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005af4:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005af8:	00002597          	auipc	a1,0x2
    80005afc:	d5058593          	addi	a1,a1,-688 # 80007848 <etext+0x848>
    80005b00:	00028517          	auipc	a0,0x28
    80005b04:	d9850513          	addi	a0,a0,-616 # 8002d898 <uart_tx_lock>
    80005b08:	1f8000ef          	jal	80005d00 <initlock>
}
    80005b0c:	60a2                	ld	ra,8(sp)
    80005b0e:	6402                	ld	s0,0(sp)
    80005b10:	0141                	addi	sp,sp,16
    80005b12:	8082                	ret

0000000080005b14 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005b14:	1101                	addi	sp,sp,-32
    80005b16:	ec06                	sd	ra,24(sp)
    80005b18:	e822                	sd	s0,16(sp)
    80005b1a:	e426                	sd	s1,8(sp)
    80005b1c:	1000                	addi	s0,sp,32
    80005b1e:	84aa                	mv	s1,a0
  push_off();
    80005b20:	224000ef          	jal	80005d44 <push_off>

  if(panicked){
    80005b24:	00005797          	auipc	a5,0x5
    80005b28:	a687a783          	lw	a5,-1432(a5) # 8000a58c <panicked>
    80005b2c:	e795                	bnez	a5,80005b58 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005b2e:	10000737          	lui	a4,0x10000
    80005b32:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005b34:	00074783          	lbu	a5,0(a4)
    80005b38:	0207f793          	andi	a5,a5,32
    80005b3c:	dfe5                	beqz	a5,80005b34 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80005b3e:	0ff4f513          	zext.b	a0,s1
    80005b42:	100007b7          	lui	a5,0x10000
    80005b46:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005b4a:	27e000ef          	jal	80005dc8 <pop_off>
}
    80005b4e:	60e2                	ld	ra,24(sp)
    80005b50:	6442                	ld	s0,16(sp)
    80005b52:	64a2                	ld	s1,8(sp)
    80005b54:	6105                	addi	sp,sp,32
    80005b56:	8082                	ret
    for(;;)
    80005b58:	a001                	j	80005b58 <uartputc_sync+0x44>

0000000080005b5a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005b5a:	00005797          	auipc	a5,0x5
    80005b5e:	a367b783          	ld	a5,-1482(a5) # 8000a590 <uart_tx_r>
    80005b62:	00005717          	auipc	a4,0x5
    80005b66:	a3673703          	ld	a4,-1482(a4) # 8000a598 <uart_tx_w>
    80005b6a:	08f70163          	beq	a4,a5,80005bec <uartstart+0x92>
{
    80005b6e:	7139                	addi	sp,sp,-64
    80005b70:	fc06                	sd	ra,56(sp)
    80005b72:	f822                	sd	s0,48(sp)
    80005b74:	f426                	sd	s1,40(sp)
    80005b76:	f04a                	sd	s2,32(sp)
    80005b78:	ec4e                	sd	s3,24(sp)
    80005b7a:	e852                	sd	s4,16(sp)
    80005b7c:	e456                	sd	s5,8(sp)
    80005b7e:	e05a                	sd	s6,0(sp)
    80005b80:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005b82:	10000937          	lui	s2,0x10000
    80005b86:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005b88:	00028a97          	auipc	s5,0x28
    80005b8c:	d10a8a93          	addi	s5,s5,-752 # 8002d898 <uart_tx_lock>
    uart_tx_r += 1;
    80005b90:	00005497          	auipc	s1,0x5
    80005b94:	a0048493          	addi	s1,s1,-1536 # 8000a590 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005b98:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80005b9c:	00005997          	auipc	s3,0x5
    80005ba0:	9fc98993          	addi	s3,s3,-1540 # 8000a598 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ba4:	00094703          	lbu	a4,0(s2)
    80005ba8:	02077713          	andi	a4,a4,32
    80005bac:	c715                	beqz	a4,80005bd8 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005bae:	01f7f713          	andi	a4,a5,31
    80005bb2:	9756                	add	a4,a4,s5
    80005bb4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005bb8:	0785                	addi	a5,a5,1
    80005bba:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80005bbc:	8526                	mv	a0,s1
    80005bbe:	8abfb0ef          	jal	80001468 <wakeup>
    WriteReg(THR, c);
    80005bc2:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005bc6:	609c                	ld	a5,0(s1)
    80005bc8:	0009b703          	ld	a4,0(s3)
    80005bcc:	fcf71ce3          	bne	a4,a5,80005ba4 <uartstart+0x4a>
      ReadReg(ISR);
    80005bd0:	100007b7          	lui	a5,0x10000
    80005bd4:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005bd8:	70e2                	ld	ra,56(sp)
    80005bda:	7442                	ld	s0,48(sp)
    80005bdc:	74a2                	ld	s1,40(sp)
    80005bde:	7902                	ld	s2,32(sp)
    80005be0:	69e2                	ld	s3,24(sp)
    80005be2:	6a42                	ld	s4,16(sp)
    80005be4:	6aa2                	ld	s5,8(sp)
    80005be6:	6b02                	ld	s6,0(sp)
    80005be8:	6121                	addi	sp,sp,64
    80005bea:	8082                	ret
      ReadReg(ISR);
    80005bec:	100007b7          	lui	a5,0x10000
    80005bf0:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    80005bf4:	8082                	ret

0000000080005bf6 <uartputc>:
{
    80005bf6:	7179                	addi	sp,sp,-48
    80005bf8:	f406                	sd	ra,40(sp)
    80005bfa:	f022                	sd	s0,32(sp)
    80005bfc:	ec26                	sd	s1,24(sp)
    80005bfe:	e84a                	sd	s2,16(sp)
    80005c00:	e44e                	sd	s3,8(sp)
    80005c02:	e052                	sd	s4,0(sp)
    80005c04:	1800                	addi	s0,sp,48
    80005c06:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005c08:	00028517          	auipc	a0,0x28
    80005c0c:	c9050513          	addi	a0,a0,-880 # 8002d898 <uart_tx_lock>
    80005c10:	174000ef          	jal	80005d84 <acquire>
  if(panicked){
    80005c14:	00005797          	auipc	a5,0x5
    80005c18:	9787a783          	lw	a5,-1672(a5) # 8000a58c <panicked>
    80005c1c:	efbd                	bnez	a5,80005c9a <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005c1e:	00005717          	auipc	a4,0x5
    80005c22:	97a73703          	ld	a4,-1670(a4) # 8000a598 <uart_tx_w>
    80005c26:	00005797          	auipc	a5,0x5
    80005c2a:	96a7b783          	ld	a5,-1686(a5) # 8000a590 <uart_tx_r>
    80005c2e:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005c32:	00028997          	auipc	s3,0x28
    80005c36:	c6698993          	addi	s3,s3,-922 # 8002d898 <uart_tx_lock>
    80005c3a:	00005497          	auipc	s1,0x5
    80005c3e:	95648493          	addi	s1,s1,-1706 # 8000a590 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005c42:	00005917          	auipc	s2,0x5
    80005c46:	95690913          	addi	s2,s2,-1706 # 8000a598 <uart_tx_w>
    80005c4a:	00e79d63          	bne	a5,a4,80005c64 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005c4e:	85ce                	mv	a1,s3
    80005c50:	8526                	mv	a0,s1
    80005c52:	fcafb0ef          	jal	8000141c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005c56:	00093703          	ld	a4,0(s2)
    80005c5a:	609c                	ld	a5,0(s1)
    80005c5c:	02078793          	addi	a5,a5,32
    80005c60:	fee787e3          	beq	a5,a4,80005c4e <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005c64:	00028497          	auipc	s1,0x28
    80005c68:	c3448493          	addi	s1,s1,-972 # 8002d898 <uart_tx_lock>
    80005c6c:	01f77793          	andi	a5,a4,31
    80005c70:	97a6                	add	a5,a5,s1
    80005c72:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005c76:	0705                	addi	a4,a4,1
    80005c78:	00005797          	auipc	a5,0x5
    80005c7c:	92e7b023          	sd	a4,-1760(a5) # 8000a598 <uart_tx_w>
  uartstart();
    80005c80:	edbff0ef          	jal	80005b5a <uartstart>
  release(&uart_tx_lock);
    80005c84:	8526                	mv	a0,s1
    80005c86:	192000ef          	jal	80005e18 <release>
}
    80005c8a:	70a2                	ld	ra,40(sp)
    80005c8c:	7402                	ld	s0,32(sp)
    80005c8e:	64e2                	ld	s1,24(sp)
    80005c90:	6942                	ld	s2,16(sp)
    80005c92:	69a2                	ld	s3,8(sp)
    80005c94:	6a02                	ld	s4,0(sp)
    80005c96:	6145                	addi	sp,sp,48
    80005c98:	8082                	ret
    for(;;)
    80005c9a:	a001                	j	80005c9a <uartputc+0xa4>

0000000080005c9c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005c9c:	1141                	addi	sp,sp,-16
    80005c9e:	e406                	sd	ra,8(sp)
    80005ca0:	e022                	sd	s0,0(sp)
    80005ca2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005ca4:	100007b7          	lui	a5,0x10000
    80005ca8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005cac:	8b85                	andi	a5,a5,1
    80005cae:	cb89                	beqz	a5,80005cc0 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005cb0:	100007b7          	lui	a5,0x10000
    80005cb4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005cb8:	60a2                	ld	ra,8(sp)
    80005cba:	6402                	ld	s0,0(sp)
    80005cbc:	0141                	addi	sp,sp,16
    80005cbe:	8082                	ret
    return -1;
    80005cc0:	557d                	li	a0,-1
    80005cc2:	bfdd                	j	80005cb8 <uartgetc+0x1c>

0000000080005cc4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005cc4:	1101                	addi	sp,sp,-32
    80005cc6:	ec06                	sd	ra,24(sp)
    80005cc8:	e822                	sd	s0,16(sp)
    80005cca:	e426                	sd	s1,8(sp)
    80005ccc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005cce:	54fd                	li	s1,-1
    int c = uartgetc();
    80005cd0:	fcdff0ef          	jal	80005c9c <uartgetc>
    if(c == -1)
    80005cd4:	00950563          	beq	a0,s1,80005cde <uartintr+0x1a>
      break;
    consoleintr(c);
    80005cd8:	861ff0ef          	jal	80005538 <consoleintr>
  while(1){
    80005cdc:	bfd5                	j	80005cd0 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005cde:	00028497          	auipc	s1,0x28
    80005ce2:	bba48493          	addi	s1,s1,-1094 # 8002d898 <uart_tx_lock>
    80005ce6:	8526                	mv	a0,s1
    80005ce8:	09c000ef          	jal	80005d84 <acquire>
  uartstart();
    80005cec:	e6fff0ef          	jal	80005b5a <uartstart>
  release(&uart_tx_lock);
    80005cf0:	8526                	mv	a0,s1
    80005cf2:	126000ef          	jal	80005e18 <release>
}
    80005cf6:	60e2                	ld	ra,24(sp)
    80005cf8:	6442                	ld	s0,16(sp)
    80005cfa:	64a2                	ld	s1,8(sp)
    80005cfc:	6105                	addi	sp,sp,32
    80005cfe:	8082                	ret

0000000080005d00 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005d00:	1141                	addi	sp,sp,-16
    80005d02:	e406                	sd	ra,8(sp)
    80005d04:	e022                	sd	s0,0(sp)
    80005d06:	0800                	addi	s0,sp,16
  lk->name = name;
    80005d08:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005d0a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005d0e:	00053823          	sd	zero,16(a0)
}
    80005d12:	60a2                	ld	ra,8(sp)
    80005d14:	6402                	ld	s0,0(sp)
    80005d16:	0141                	addi	sp,sp,16
    80005d18:	8082                	ret

0000000080005d1a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005d1a:	411c                	lw	a5,0(a0)
    80005d1c:	e399                	bnez	a5,80005d22 <holding+0x8>
    80005d1e:	4501                	li	a0,0
  return r;
}
    80005d20:	8082                	ret
{
    80005d22:	1101                	addi	sp,sp,-32
    80005d24:	ec06                	sd	ra,24(sp)
    80005d26:	e822                	sd	s0,16(sp)
    80005d28:	e426                	sd	s1,8(sp)
    80005d2a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005d2c:	6904                	ld	s1,16(a0)
    80005d2e:	8bcfb0ef          	jal	80000dea <mycpu>
    80005d32:	40a48533          	sub	a0,s1,a0
    80005d36:	00153513          	seqz	a0,a0
}
    80005d3a:	60e2                	ld	ra,24(sp)
    80005d3c:	6442                	ld	s0,16(sp)
    80005d3e:	64a2                	ld	s1,8(sp)
    80005d40:	6105                	addi	sp,sp,32
    80005d42:	8082                	ret

0000000080005d44 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005d44:	1101                	addi	sp,sp,-32
    80005d46:	ec06                	sd	ra,24(sp)
    80005d48:	e822                	sd	s0,16(sp)
    80005d4a:	e426                	sd	s1,8(sp)
    80005d4c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005d4e:	100024f3          	csrr	s1,sstatus
    80005d52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005d56:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005d58:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005d5c:	88efb0ef          	jal	80000dea <mycpu>
    80005d60:	5d3c                	lw	a5,120(a0)
    80005d62:	cb99                	beqz	a5,80005d78 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005d64:	886fb0ef          	jal	80000dea <mycpu>
    80005d68:	5d3c                	lw	a5,120(a0)
    80005d6a:	2785                	addiw	a5,a5,1
    80005d6c:	dd3c                	sw	a5,120(a0)
}
    80005d6e:	60e2                	ld	ra,24(sp)
    80005d70:	6442                	ld	s0,16(sp)
    80005d72:	64a2                	ld	s1,8(sp)
    80005d74:	6105                	addi	sp,sp,32
    80005d76:	8082                	ret
    mycpu()->intena = old;
    80005d78:	872fb0ef          	jal	80000dea <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005d7c:	8085                	srli	s1,s1,0x1
    80005d7e:	8885                	andi	s1,s1,1
    80005d80:	dd64                	sw	s1,124(a0)
    80005d82:	b7cd                	j	80005d64 <push_off+0x20>

0000000080005d84 <acquire>:
{
    80005d84:	1101                	addi	sp,sp,-32
    80005d86:	ec06                	sd	ra,24(sp)
    80005d88:	e822                	sd	s0,16(sp)
    80005d8a:	e426                	sd	s1,8(sp)
    80005d8c:	1000                	addi	s0,sp,32
    80005d8e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005d90:	fb5ff0ef          	jal	80005d44 <push_off>
  if(holding(lk))
    80005d94:	8526                	mv	a0,s1
    80005d96:	f85ff0ef          	jal	80005d1a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005d9a:	4705                	li	a4,1
  if(holding(lk))
    80005d9c:	e105                	bnez	a0,80005dbc <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005d9e:	87ba                	mv	a5,a4
    80005da0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005da4:	2781                	sext.w	a5,a5
    80005da6:	ffe5                	bnez	a5,80005d9e <acquire+0x1a>
  __sync_synchronize();
    80005da8:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005dac:	83efb0ef          	jal	80000dea <mycpu>
    80005db0:	e888                	sd	a0,16(s1)
}
    80005db2:	60e2                	ld	ra,24(sp)
    80005db4:	6442                	ld	s0,16(sp)
    80005db6:	64a2                	ld	s1,8(sp)
    80005db8:	6105                	addi	sp,sp,32
    80005dba:	8082                	ret
    panic("acquire");
    80005dbc:	00002517          	auipc	a0,0x2
    80005dc0:	a9450513          	addi	a0,a0,-1388 # 80007850 <etext+0x850>
    80005dc4:	c93ff0ef          	jal	80005a56 <panic>

0000000080005dc8 <pop_off>:

void
pop_off(void)
{
    80005dc8:	1141                	addi	sp,sp,-16
    80005dca:	e406                	sd	ra,8(sp)
    80005dcc:	e022                	sd	s0,0(sp)
    80005dce:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005dd0:	81afb0ef          	jal	80000dea <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005dd4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005dd8:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005dda:	e39d                	bnez	a5,80005e00 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005ddc:	5d3c                	lw	a5,120(a0)
    80005dde:	02f05763          	blez	a5,80005e0c <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005de2:	37fd                	addiw	a5,a5,-1
    80005de4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005de6:	eb89                	bnez	a5,80005df8 <pop_off+0x30>
    80005de8:	5d7c                	lw	a5,124(a0)
    80005dea:	c799                	beqz	a5,80005df8 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005dec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005df0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005df4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005df8:	60a2                	ld	ra,8(sp)
    80005dfa:	6402                	ld	s0,0(sp)
    80005dfc:	0141                	addi	sp,sp,16
    80005dfe:	8082                	ret
    panic("pop_off - interruptible");
    80005e00:	00002517          	auipc	a0,0x2
    80005e04:	a5850513          	addi	a0,a0,-1448 # 80007858 <etext+0x858>
    80005e08:	c4fff0ef          	jal	80005a56 <panic>
    panic("pop_off");
    80005e0c:	00002517          	auipc	a0,0x2
    80005e10:	a6450513          	addi	a0,a0,-1436 # 80007870 <etext+0x870>
    80005e14:	c43ff0ef          	jal	80005a56 <panic>

0000000080005e18 <release>:
{
    80005e18:	1101                	addi	sp,sp,-32
    80005e1a:	ec06                	sd	ra,24(sp)
    80005e1c:	e822                	sd	s0,16(sp)
    80005e1e:	e426                	sd	s1,8(sp)
    80005e20:	1000                	addi	s0,sp,32
    80005e22:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005e24:	ef7ff0ef          	jal	80005d1a <holding>
    80005e28:	c105                	beqz	a0,80005e48 <release+0x30>
  lk->cpu = 0;
    80005e2a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005e2e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005e32:	0310000f          	fence	rw,w
    80005e36:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005e3a:	f8fff0ef          	jal	80005dc8 <pop_off>
}
    80005e3e:	60e2                	ld	ra,24(sp)
    80005e40:	6442                	ld	s0,16(sp)
    80005e42:	64a2                	ld	s1,8(sp)
    80005e44:	6105                	addi	sp,sp,32
    80005e46:	8082                	ret
    panic("release");
    80005e48:	00002517          	auipc	a0,0x2
    80005e4c:	a3050513          	addi	a0,a0,-1488 # 80007878 <etext+0x878>
    80005e50:	c07ff0ef          	jal	80005a56 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
