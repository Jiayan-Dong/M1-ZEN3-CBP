/* Modified from https://github.com/cloudflare/cloudflare-blog/tree/master/2021-05-branch-prediction */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>

#include "perf.h"

#if __linux__
#include <error.h>
#include <linux/perf_event.h>
#include <sys/ioctl.h>
#include <sys/syscall.h>
#include <unistd.h>

#define CPMU_NONE 0
#define CPMU_CORE_CYCLE 0x02
#define CPMU_INST_A64 0x8c
#define CPMU_INST_BRANCH 0x8d
#define CPMU_SYNC_DC_LOAD_MISS 0xbf
#define CPMU_SYNC_DC_STORE_MISS 0xc0
#define CPMU_SYNC_DTLB_MISS 0xc1
#define CPMU_SYNC_ST_HIT_YNGR_LD 0xc4
#define CPMU_SYNC_BR_ANY_MISP 0xcb
#define CPMU_FED_IC_MISS_DEM 0xd3
#define CPMU_FED_ITLB_MISS 0xd4

static long perf_event_open(struct perf_event_attr *hw_event, pid_t pid,
							int cpu, int group_fd, unsigned long flags)
{
	int ret = syscall(__NR_perf_event_open, hw_event, pid, cpu, group_fd,
					  flags);
	return ret;
}

/* Notice: the layout of this struct depends on the flags passed to perf_event_open. */
struct read_format
{
	uint64_t nr;
	struct
	{
		uint64_t value;
	} values[];
};

struct events
{
	uint32_t type;
	uint32_t config;
	char *name;
};

struct events events[] = {
	{PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES, "cycles"},
	{PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS, "instructions"},
	{PERF_TYPE_RAW, CPMU_SYNC_BR_ANY_MISP, "missed_branches"},
	{PERF_TYPE_RAW, CPMU_INST_BRANCH, "branches"},
};

#define ARRAY_SIZE(array) (sizeof(array) / sizeof(array[0]))
#define EVENTS_SZ ((int)ARRAY_SIZE(events))

void perf_open(struct perf *perf)
{
	if (ARRAY_SIZE(perf->fd) < EVENTS_SZ)
	{
		abort();
	}

	perf->fd[0] = -1;
	int i;
	for (i = 0; i < EVENTS_SZ; i++)
	{
		struct perf_event_attr pe = {
			.type = events[i].type,
			.size = sizeof(struct perf_event_attr),
			.config = events[i].config,
			.disabled = 1,
			.exclude_kernel = 1,
			.exclude_guest = 1,
			.exclude_hv = 1,
			.read_format = PERF_FORMAT_GROUP,
			.sample_type = PERF_SAMPLE_IDENTIFIER,
		};
		perf->fd[i] = perf_event_open(&pe, 0, CPU_NUMBER, perf->fd[0], PERF_FLAG_FD_CLOEXEC);
		if (perf->fd[i] == -1)
		{
			fprintf(stderr, "%d\n", i);
			fprintf(stderr, "Error opening perf %s\n", events[i].name);
			exit(EXIT_FAILURE);
		}
	}
}

inline void perf_start(struct perf *perf)
{
	asm volatile("" ::
					 : "memory");
	ioctl(perf->fd[0], PERF_EVENT_IOC_RESET, PERF_IOC_FLAG_GROUP);
	ioctl(perf->fd[0], PERF_EVENT_IOC_ENABLE, PERF_IOC_FLAG_GROUP);
	asm volatile("" ::
					 : "memory");
}

inline void perf_stop(struct perf *perf, uint64_t *numbers)
{
	asm volatile("" ::
					 : "memory");
	ioctl(perf->fd[0], PERF_EVENT_IOC_DISABLE, PERF_IOC_FLAG_GROUP);
	char perf_buf[4096];
	int r = read(perf->fd[0], &perf_buf, sizeof(perf_buf));
	if (r < 1)
		error(-1, errno, "read(perf)");

	struct read_format *rf = (struct read_format *)perf_buf;

	numbers[0] = rf->values[0].value; // cycles
	numbers[1] = rf->values[1].value; // instructions
	numbers[2] = rf->values[2].value; // missed_branches
	numbers[3] = rf->values[3].value; // branches
}

#endif