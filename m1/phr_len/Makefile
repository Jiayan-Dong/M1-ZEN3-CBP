mispred_test: perf.c perf.h mispred_test.s
	gcc -flto -no-pie perf.c mispred_test.s -o mispred_test -pthread
mispred_test.s: mispred_test.c perf.h
	gcc -S mispred_test.c
dump: mispred_test
	objdump -D mispred_test > mispred_test.dump
run: mispred_test 
	./mispred_test
clean:
	rm -r -f mispred_test
	rm -r -f mispred_test.dump