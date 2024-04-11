/* Modified from https://github.com/cloudflare/cloudflare-blog/tree/master/2021-05-branch-prediction */

#include <stdarg.h>
#include <time.h>
#include <stdint.h>

struct perf {
	int fd[16];
	uint64_t cycles;
	uint64_t branches;
	uint64_t missed_branches;
	uint64_t instructions;
};

void perf_open(struct perf *perf);
void perf_start(struct perf *perf);
void perf_stop(struct perf *perf, uint64_t *numbers);