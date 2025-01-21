//
// uart.c
// these simplified functions replace uartputc() and uartintr()
//

static int tx_busy;           // is the UART busy sending?
static int tx_chan;           // &tx_chan is the "wait channel"
struct spinlock tx_lock;      // the "condition lock"

// transmit buf[].
void
uartwrite(char buf[], int n)
{
  acquire(&tx_lock);

  int i = 0;
  while(i < n){
    while(tx_busy){
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    }
    
    WriteReg(THR, buf[i]);
    i += 1;
    tx_busy = 1;
  }

  release(&tx_lock);
}

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
  acquire(&tx_lock);
  if(ReadReg(LSR) & LSR_TX_IDLE){
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
      break;
    consoleintr(c);
  }
}

//
// proc.c
//
// (this sleep() does not work correctly)
//

void
broken_sleep(void *chan)
{
  struct proc *p = myproc();
  
  // Must acquire p->lock in order to
  // change p->state and then call sched.
  acquire(&p->lock);

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;
  release(&p->lock);
}
