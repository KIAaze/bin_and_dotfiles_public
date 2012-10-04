#include <stdio.h>

int check_existence(char *filename, int feedback=1);
int check_2(char *fileName,int feedback,int k,FILE *corrupt, FILE *missing, FILE *cleanup);
int integrity(char *filename, char *the_name, char *the_class, int feedback=1);
int get_nEvents(char *filename);
int check(char *fileName,int feedback,int k,FILE *corrupt, FILE *missing, FILE *cleanup, int chk_evts=1);
void check_all_for_integrity(int start=0,int stop=99,int feedback=1);
