#include <stdio.h>

#include <cyg/kernel/kapi.h>            /* All the kernel specific stuff */
#include <cyg/devs/common/table.h>      

#define NTHREADS 1
#define STACKSIZE 4096

static cyg_handle_t thread[NTHREADS];
static cyg_thread thread_obj[NTHREADS];
static char stack[NTHREADS][STACKSIZE];

static void simple_prog(CYG_ADDRESS data)
{
    Cyg_IORB iorb;
    cyg_addrword_t my_io_cookie;
    
    /* set the I/O cookie to point to our favorite serial device */
/* start-sanitize-mn10300 */
    my_io_cookie = stdeval1_serial1;
/* end-sanitize-mn10300 */
/* start-sanitize-tx39 */
    my_io_cookie = jmr3904_serial;
/* end-sanitize-tx39 */

    iorb.buffer = "This is test 1\n";
    iorb.buffer_length = 15; /* strlen(iorb.data); */
    cyg_write_blocking(my_io_cookie, &iorb);
    printf("Done with my non-blocking serial write\n");
}

void cyg_user_start(void)
{
    cyg_thread_create(4, simple_prog, (cyg_addrword_t) 0, "serial1",
                      (void *)stack[0], STACKSIZE, &thread[0], &thread_obj[0]);
    cyg_thread_resume(thread[0]);
}
