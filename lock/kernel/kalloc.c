// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem[NCPU];

int references[NCPU];

void
kinit()
{
  for (int i = 0; i < NCPU; i++) {
    references[i] = 0;
    initlock(&kmem[i].lock, "kmem");
  }
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(int i = 0; p + PGSIZE <= (char*)pa_end;i++, p += PGSIZE) {
    memfree(p, i % NCPU);
  }
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  int id = getcpuid();

  acquire(&kmem[id].lock);
  r->next = kmem[id].freelist;
  kmem[id].freelist = r;
  references[id]++;
  release(&kmem[id].lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  int id = getcpuid();

  acquire(&kmem[id].lock);
  r = kmem[id].freelist;
  if(r) {
    references[id]--;
    kmem[id].freelist = r->next;
  }
  else
    r = steal(id);
  release(&kmem[id].lock);

  if(r) {
    memset((char*)r, 5, PGSIZE); // fill with junk
  }

  return (void*)r;
}

void
memfree(void *pa, int id)
{
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    panic("memfree");

  memset(pa, 1, PGSIZE);
  r = (struct run*)pa;
  acquire(&kmem[id].lock);
  r->next = kmem[id].freelist;
  kmem[id].freelist = r;
  references[id]++;
  release(&kmem[id].lock);
}

int
getcpuid()
{
  int id;
  push_off();
  id = cpuid();
  pop_off();
  return id;
}

void*
steal(int id)
{
  struct run *r;
  int max = 0;
  for (int i = 1; i < NCPU; i++)
    if (references[i] > references[max]) max = i;
  if (references[max] == 0) return 0;

  acquire(&kmem[max].lock);
  r = kmem[max].freelist;
  kmem[max].freelist = kmem[max].freelist->next;
  references[max]--;
  release(&kmem[max].lock);
  return r;
}
