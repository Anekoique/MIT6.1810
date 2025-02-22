// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define BUCKETS_NUM 13
#define HASH_SEATCH(blockno) (blockno % BUCKETS_NUM)  // find the bucket

struct {
  // new buffer cache
  struct spinlock lock;                     // global lock for move buf
  struct buf buf[NBUF];                     // buffer cache less than NBUF

  struct buf buckets[BUCKETS_NUM];          // use buckets to store and get cache
  struct spinlock bucketlock[BUCKETS_NUM];  // bucket lock instead of the global lock
} bcache;

void
binit(void)
{
  struct buf *b;

  // init global lock
  initlock(&bcache.lock, "bcache");

  // Each bucket starts with a double-ended circular linked list
  // Set head'refcnt to 1 to indicate that it cannot be moved.
  for (int i = 0; i < BUCKETS_NUM; i++) {
    initlock(&bcache.bucketlock[i], "bcachelock");
    bcache.buckets[i].next = &bcache.buckets[i];
    bcache.buckets[i].prev = &bcache.buckets[i];
    bcache.buckets[i].refcnt = 1;
  }

  // Initialize each buffer cache and store in buckets
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    initsleeplock(&b->lock, "buffer");
    b->next = bcache.buckets[0].next;
    b->prev = &bcache.buckets[0];
    bcache.buckets[0].next->prev = b;
    bcache.buckets[0].next = b;
  }
}

// Find the cache in the bucket corresponding to blockno
static struct buf*
bucketsearch(uint dev, uint blockno)
{
  struct buf *b;
  int key = HASH_SEATCH(blockno);

  // Accessing the bucket requires the corresponding lock
  acquire(&bcache.bucketlock[key]);
  for (b = bcache.buckets[key].next; b != &bcache.buckets[key]; b = b->next) {
    if (b->dev == dev && b->blockno == blockno) {
      b->refcnt++;
      release(&bcache.bucketlock[key]);
      acquiresleep(&b->lock);
      return b;
    }
  }
  release(&bcache.bucketlock[key]);
  return 0;
}

// move the buf from the old bucket to the new bucket
static struct buf*
bufmove(struct buf *b, int old, int new) {
  if (old == new) return b;

  // Put the buffer in the prev of new bucket head
  b->prev->next = b->next;
  b->next->prev = b->prev;
  b->next = &bcache.buckets[new];
  b->prev = bcache.buckets[new].prev;
  bcache.buckets[new].prev->next = b;
  bcache.buckets[new].prev = b;
  return b;
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;
  // search the bucket without global lock
  if ((b = bucketsearch(dev, blockno)) != 0)
    return b;

  acquire(&bcache.lock);
  // search the bucket with global lock
  if ((b = bucketsearch(dev, blockno)) != 0) {
    release(&bcache.lock);
    return b;
  }

  // find a buffer to move
  int new = HASH_SEATCH(blockno);
  for (int i = 0; i < BUCKETS_NUM; i++) {
    // start from the key
    int old = (new + i) % BUCKETS_NUM;
    b = bcache.buckets[old].prev;

    // search current bucket for buf
    while (b != &bcache.buckets[old]) {
      if (b->refcnt == 0) {
        // get both the old and the new bucket lock to move
        acquire(&bcache.bucketlock[old]);
        if (old != new) acquire(&bcache.bucketlock[new]);
        if ((b = bufmove(b, old, new)) != 0) {
          b->dev = dev;
          b->blockno = blockno;
          b->valid = 0;
          b->refcnt = 1;
          if (old != new) release(&bcache.bucketlock[new]); 
          acquiresleep(&b->lock);
          release(&bcache.bucketlock[old]);
          release(&bcache.lock);
          return b;
        }

        // can't reach here
        if (old != new) release(&bcache.bucketlock[new]); 
        release(&bcache.bucketlock[old]);
        release(&bcache.lock);
        panic("bget error");
      }
      b = b->prev;
    }
  }

  // can't reach here
  release(&bcache.lock);
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  int key = HASH_SEATCH(b->blockno);
  acquire(&bcache.bucketlock[key]);
  b->refcnt--;
  if (b->refcnt == 0) {
    // Put the buffer in the next of new bucket head for quicker search
    struct buf *head = &bcache.buckets[key];
    b->prev->next = b->next;
    b->next->prev = b->prev;
    b->next = head->next;
    head->next->prev = b;
    head->next = b;
    b->prev = head;
  }
  release(&bcache.bucketlock[key]);
}

void
bpin(struct buf *b) {
  int key = HASH_SEATCH(b->blockno);
  acquire(&bcache.bucketlock[key]);
  b->refcnt++;
  release(&bcache.bucketlock[key]);
}

void
bunpin(struct buf *b) {
  int key = HASH_SEATCH(b->blockno);
  acquire(&bcache.bucketlock[key]);
  b->refcnt--;
  release(&bcache.bucketlock[key]);
}


