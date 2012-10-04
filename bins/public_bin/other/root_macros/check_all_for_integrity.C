//This macro loops checks a file for integrity
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <algorithm>
#include "TFile.h"
#include "TKey.h"
#include "TTree.h"
#include <fstream>

using namespace std;

// int main(void)
// {
// 
// }

////////////////////////////////////////////////////////////////////////
//check file existence
int check_existence(char *filename, int feedback=1)
{
  fstream fin;
  fin.open(filename,ios::in);
  if( fin.is_open() )
  {
    if(feedback) cout<<"file "<<filename<<" exists"<<endl;
    return(1);
  }
  else
  {
    if(feedback) cerr<<"error: file "<<filename<<" does not exist"<<endl;
    return(0);
  }    
  fin.close();
}
////////////////////////////////////////////////////////////////////////
//special check for parameter files
int check_2(char *fileName,int feedback,int k,FILE *corrupt, FILE *missing, FILE *cleanup)
{
  if(feedback) cout << k <<"->"<< fileName << endl;
  int ok=check_existence(fileName,feedback);
  if(!ok)
  {
    fprintf(missing,"ERROR: %s not found\n",fileName);
    return(-1);
  }
  return(0);
}
////////////////////////////////////////////////////////////////////////
//Check file integrity
int integrity(char *filename, char *the_name, char *the_class, int feedback=1)
{
  int ok=0;
  TFile f(filename,"READ");
  if(f.IsZombie())
  {
    if(feedback)
      cout<<"ERROR: File "<<filename<<" not found"<<endl;
    return(-2);
  }
  TIter next(f.GetListOfKeys());
  TKey *key;
  while ((key=(TKey*)next()))
  {
    if(strcmp(key->GetName(),the_name) == 0 && strcmp(key->GetClassName(),the_class) == 0) ok=1;
  }
  f.Close();
  if(ok==1)
  {
    return(0);
  }
  else
  {
    if(feedback)
      cout<<"ERROR: Key "<<the_name<<" pointing to object of class "<<the_class<<" not found."<<endl;
    return(-1);
  }
}
////////////////////////////////////////////////////////////////////////
//get number of events in file
int get_nEvents(char *filename)
{
  int N=-1;
  TFile InputFile(filename,"READ");
  TTree *InputTree = (TTree*)InputFile.Get("cbmsim");
  N=InputTree->GetEntries();  
  InputFile.Close();
  return(N);
}      
////////////////////////////////////////////////////////////////////////
//special check function
int check(char *fileName,int feedback,int k,FILE *corrupt, FILE *missing, FILE *cleanup, int chk_evts=1)
{
  if(feedback) cout << k <<"->"<< fileName << endl;
  int ok=integrity(fileName,"cbmsim","TTree",feedback);
  if(ok==-1)
  {
    fprintf(corrupt,"ERROR: cbmsim not found in %s\n",fileName);
    fprintf(cleanup,"rm %s\n",fileName);
  }
  if(ok==-2)
  {
    fprintf(missing,"ERROR: %s not found\n",fileName);
  }
  if(ok==0 && chk_evts==1)
  {
   int N=get_nEvents(fileName);
   if(N!=1000)
   {
     fprintf(corrupt,"WARNING: %s has only %d events.\n",fileName,N);
     fprintf(cleanup,"rm %s\n",fileName);
   }
  }
  return(0);
}
////////////////////////////////////////////////////////////////////////
void check_all_for_integrity(int start=0,int stop=99,int feedback=1)
{
  FILE *corrupt=fopen("corrupt.log","w");
  FILE *missing=fopen("missing.log","w");
  FILE *cleanup=fopen("cleanup.sh","w");
  int par=0;
  for(int k=start; k<=stop; k++)
  {
    char fileName[256];
    
    char str[5];
    sprintf(str,"%4d",k);
    for(int i=0;i<4;i++) {if(' '==str[i]) str[i]='0';}
    
    //simulation files in data
    sprintf(fileName,"/s/$USER_flast/data/Pluto.noUrqmd.auau.25gev.centr.params.%s.root",str);
    par=check_2(fileName,feedback,k,corrupt,missing,cleanup);
    sprintf(fileName,"/s/$USER_flast/data/Pluto.noUrqmd.auau.25gev.centr.mc.%s.root",str);
    check(fileName,feedback,k,corrupt,missing,cleanup);
    if(par==-1) fprintf(cleanup,"rm %s\n",fileName);par=0;
    
    sprintf(fileName,"/s/$USER_flast/data/noPluto.Urqmd.auau.25gev.centr.params.%s.root",str);    
    par=check_2(fileName,feedback,k,corrupt,missing,cleanup);
    sprintf(fileName,"/s/$USER_flast/data/noPluto.Urqmd.auau.25gev.centr.mc.%s.root",str);
    check(fileName,feedback,k,corrupt,missing,cleanup);
    if(par==-1) fprintf(cleanup,"rm %s\n",fileName);par=0;
    
    sprintf(fileName,"/s/$USER_flast/data/Pluto.Urqmd.auau.25gev.centr.params.%s.root",str);    
    par=check_2(fileName,feedback,k,corrupt,missing,cleanup);
    sprintf(fileName,"/s/$USER_flast/data/Pluto.Urqmd.auau.25gev.centr.mc.%s.root",str);
    check(fileName,feedback,k,corrupt,missing,cleanup);
    if(par==-1) fprintf(cleanup,"rm %s\n",fileName);par=0;
    
    //simulation files in data_Psi_prime
    sprintf(fileName,"/s/$USER_flast/data_Psi_prime/Pluto.noUrqmd.auau.25gev.centr.params.%s.root",str);
    par=check_2(fileName,feedback,k,corrupt,missing,cleanup);
    sprintf(fileName,"/s/$USER_flast/data_Psi_prime/Pluto.noUrqmd.auau.25gev.centr.mc.%s.root",str);
    check(fileName,feedback,k,corrupt,missing,cleanup);
    if(par==-1) fprintf(cleanup,"rm %s\n",fileName);par=0;
    
    sprintf(fileName,"/s/$USER_flast/data_Psi_prime/noPluto.Urqmd.auau.25gev.centr.params.%s.root",str);    
    par=check_2(fileName,feedback,k,corrupt,missing,cleanup);
    sprintf(fileName,"/s/$USER_flast/data_Psi_prime/noPluto.Urqmd.auau.25gev.centr.mc.%s.root",str);    
    check(fileName,feedback,k,corrupt,missing,cleanup);
    if(par==-1) fprintf(cleanup,"rm %s\n",fileName);par=0;
    
    sprintf(fileName,"/s/$USER_flast/data_Psi_prime/Pluto.Urqmd.auau.25gev.centr.params.%s.root",str);    
    par=check_2(fileName,feedback,k,corrupt,missing,cleanup);
    sprintf(fileName,"/s/$USER_flast/data_Psi_prime/Pluto.Urqmd.auau.25gev.centr.mc.%s.root",str);    
    check(fileName,feedback,k,corrupt,missing,cleanup);
    if(par==-1) fprintf(cleanup,"rm %s\n",fileName);par=0;
    
    
    //STS reconstruction files in data
    sprintf(fileName,"/s/$USER_flast/data/Pluto.noUrqmd.auau.25gev.centr.sts_reco.%s.root",str);
    check(fileName,feedback,k,corrupt,missing,cleanup);
    
    sprintf(fileName,"/s/$USER_flast/data/noPluto.Urqmd.auau.25gev.centr.sts_reco.%s.root",str);
    check(fileName,feedback,k,corrupt,missing,cleanup);
    
    sprintf(fileName,"/s/$USER_flast/data/Pluto.Urqmd.auau.25gev.centr.sts_reco.%s.root",str);
    check(fileName,feedback,k,corrupt,missing,cleanup);
    
    //STS reconstruction files in data_Psi_prime
    sprintf(fileName,"/s/$USER_flast/data_Psi_prime/Pluto.noUrqmd.auau.25gev.centr.sts_reco.%s.root",str);
    check(fileName,feedback,k,corrupt,missing,cleanup);
    
    sprintf(fileName,"/s/$USER_flast/data_Psi_prime/noPluto.Urqmd.auau.25gev.centr.sts_reco.%s.root",str);    
    check(fileName,feedback,k,corrupt,missing,cleanup);
    
    sprintf(fileName,"/s/$USER_flast/data_Psi_prime/Pluto.Urqmd.auau.25gev.centr.sts_reco.%s.root",str);
    check(fileName,feedback,k,corrupt,missing,cleanup);
    
  }
  fclose(corrupt);
  fclose(missing);
  fclose(cleanup);
}
