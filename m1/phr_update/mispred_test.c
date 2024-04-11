#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <errno.h>

#include <sys/mman.h>

#include <linux/memfd.h>
#include <linux/mman.h>

#include <sched.h>

#include <string.h>

#include "perf.h"

#define ARR_SIZE 220
#define RAND_SIZE 1000
#define OUTTER_LOOP 20

int a[ARR_SIZE];

void genRand()
{
    // srand(time(NULL));
    for (int i = 0; i < ARR_SIZE; ++i)
        a[i] = rand() % 2;
}

int main()
{
    /* [2] Setaffinity */
    {
        cpu_set_t set;
        CPU_ZERO(&set);
        CPU_SET(CPU_NUMBER, &set);
        int r = sched_setaffinity(0, sizeof(set), &set);
        if (r == -1)
        {
            perror("sched_setaffinity([0])");
            exit(-1);
        }
    }

    /* Attempt to clear BTB */
    {
        int r = system("python3 -c 'import math'");
        (void)r;
    }

    struct perf perf;
    memset(&perf, 0, sizeof(struct perf));
    perf_open(&perf);

    register int r, c;
    register int* addr_a = &a[0];
    volatile int y;
    int i, j;
    for (i = 0; i < OUTTER_LOOP; ++i)
    {
        uint64_t numbers[RAND_SIZE][4] = {{0}};
        for (j = 0; j < RAND_SIZE; j++) {
            genRand();
            r = a[0];
            // printf("%d\n", r);
            
            
            
            if (r)
                y += 114;

            if (*(addr_a + 1))
                y += 1;
            if (*(addr_a + 2))
                y += 1;
            if (*(addr_a + 3))
                y += 1;
                ...
            
            perf_start(&perf);
            if (r)
                y += 514;

            perf_stop(&perf, &numbers[j][0]);
        }

        double cs = 0;
        double is = 0;
        double bs = 0;
        double mbs = 0;
        for (j = 0; j < RAND_SIZE; j++)
        {
            double cycles = numbers[j][0] * 1.0; // cycles has a base number around 70.0
            double instructions = numbers[j][1] * 1.0; // instructions has a base number around 36.0
            double branches = numbers[j][3] * 1.0; // branches has a base number around 6.0
            double missed_branches = numbers[j][2] * 1.0;

            cs += cycles;
            is += instructions;
            bs += branches;
            mbs += missed_branches;
        }

        printf("%5.3f\n", (mbs / RAND_SIZE));
        // printf("%5.3f  %5.3f  %5.3f  %5.3f\n", (cs / RAND_SIZE), (is / RAND_SIZE), (bs / RAND_SIZE), (mbs / RAND_SIZE));

    }

    return 0;
}