#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#define PHR_SIZE 50

int main(int argc, char* argv[]){
    srand(time(0));
    int i;
    int value_array[PHR_SIZE]={0};

    for(i=0;i<PHR_SIZE;i++){
        value_array[i] = atoi(argv[1]);
    }
    
    printf("%%macro PHR_Maker_%s 1\n\n", argv[1]);
    
    printf("jmp phr_bit_victim%d_%%+ %%1\n", PHR_SIZE-1);
    for(i=1;i<PHR_SIZE;i++){
        printf("align 1<<16\n");
        printf("%%rep %d\n", 16+(3-value_array[PHR_SIZE-i]));
        printf("nop\n");
        printf("%%endrep\n");
        printf("phr_bit_victim%d_%%+ %%1:\n",PHR_SIZE-i);
        // printf("%%rep 1<<3\n");
        // printf("nop\n");
        // printf("%%endrep\n");
        if (value_array[PHR_SIZE-i] == 3) {
            printf("%%rep 8\n");
            printf("nop\n");
            printf("%%endrep\n");            
        }
        else {
            printf("align 1<<3\n");
        }
        printf("jmp phr_bit_victim%d_%%+ %%1\n\n\n",PHR_SIZE-1-i);
    }
    printf("align 1<<16\n");
    printf("%%rep %d\n", 19);
    printf("nop\n");
    printf("%%endrep\n");
    printf("phr_bit_victim%d_%%+ %%1:\n\n",0);
    printf("%%endmacro\n");

}