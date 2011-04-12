#include <stdio.h>
#include <iostream.h>

int main (int argc, char *argv[])
{
    char str[5];
    char outFile[1000];
    sprintf(str,"%4d",atoi(argv[3]));
    for(int i=0;i<4;i++) {if(' '==str[i]) str[i]='0';}    
    sprintf(outFile,"%s%s%s%s",argv[1],argv[2],str,argv[4]);
    cout << outFile << endl; 
}
