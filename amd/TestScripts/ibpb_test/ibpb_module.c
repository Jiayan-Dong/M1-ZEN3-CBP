#include <linux/module.h>
#include <linux/init.h>
#include <asm/msr.h> // Header for MSR functions

#define IBPB_CMD_BIT      (1UL << 0) // The bit for IBPB command

static inline uint64_t get_time_stamp(void)
{
    unsigned long long cycles;

    asm volatile(
    "mfence\n\t"
    "lfence\n\t"
    "rdtscp\n\t"
    //"shl %%edx, 32\n\t"
    //"or %%rdx, %%rax\n\t"
    : "=a"(cycles) /*output*/
    :
    : "rdx"); /*reserved register*/

    return cycles;
}


static int __init my_module_init(void)
{
    
    unsigned long long start, end, sum = 0, avg;
    // double ;

    // Read the timestamp counter before executing the wrmsr instruction
    
    int i;
    // Issue the IBPB command
    for (i = 0; i < 1000; i++)
    {
        start = get_time_stamp();
        wrmsr(73, IBPB_CMD_BIT, 0);
        end = get_time_stamp();
        sum = sum + end - start;
    }
    
    avg = sum / 1000;
    // Compute the elapsed time and print it
    printk(KERN_INFO "Issued IBPB command. Execution time: %llu cycles.\n", avg);
    return 0;
}

static void __exit my_module_exit(void)
{
    printk(KERN_INFO "Module exiting.\n");
}

module_init(my_module_init);
module_exit(my_module_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("LUYI LI");
MODULE_DESCRIPTION("Enable Intel IBPB example with rdtscp timing");