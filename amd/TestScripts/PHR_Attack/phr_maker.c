#include<stdio.h>
#include<stdlib.h>

int main(int argc, char* argv[]){
    int offset;
    printf("%%macro PHR_Model_Init 0\n\n");
    for (int i = 0; i <= 192; i++) {
        offset = 2000 + i;
        printf("mov byte[UserData+%d],%s\n", offset, argv[194-i]);
    }
    printf("\nmov byte[UserData+2193],4\n\n");
    printf("%%endmacro\n\n");
}
