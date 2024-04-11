#include<stdio.h>
#include<stdlib.h>

int main(int argc, char* argv[]){
    int offset;
    printf("%%macro Victim_PHR_Model_Init 0\n\n");
    for (int i = 0; i <= 193; i++) {
        offset = 3000 + i;
        //printf("mov byte[UserData+%d],%s\n", offset, argv[194-i]);
        printf("mov byte[UserData+%d],0\n", offset);
    }
    printf("mov byte[UserData+3194],4\n\n");
    printf("%%endmacro\n\n");
}
