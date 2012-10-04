#include <stdio.h>
#include <iostream.h>

int main (int argc, char *argv[])
{
    char str[5];
    char outFile[1000];
    sprintf(str,"%4d",atoi(argv[2]));
    for(int i=0;i<4;i++) {if(' '==str[i]) str[i]='0';}    
    sprintf(outFile,"%s%s%s",argv[1],str,argv[3]);
    cout << outFile << endl; 
}
