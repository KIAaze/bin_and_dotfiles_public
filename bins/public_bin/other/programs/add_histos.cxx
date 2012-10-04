#include <stdio.h>
#include <stdlib.h>
#include <iostream.h>
#include "TFile.h"
#include "TKey.h"
#include "TH1.h"

int integrity(char *filename, char *the_name, char *the_class);
int add_histos(char *histo1_name,char *histo2_name,char *histo3_name,char *oldname,char *newname);

int main (int argc, char *argv[])
{
  char histo1_name[256];
  char histo2_name[256];
  char histo3_name[256];
  char oldname[256];
  char newname[256];

  if(argc==1)
    {
      cout<<"int add_histos(char *histo1_name,char *histo2_name,char *histo3_name,char *oldname,char *newname)"<<endl;
    }
  else
    {
      sprintf(histo1_name,"%s",argv[1]);
      sprintf(histo2_name,"%s",argv[2]);
      sprintf(histo3_name,"%s",argv[3]);
      sprintf(oldname,"%s",argv[4]);
      sprintf(newname,"%s",argv[5]);

      cout<<"histo1_name="<<histo1_name<<endl;
      cout<<"histo2_name="<<histo2_name<<endl;
      cout<<"histo3_name="<<histo3_name<<endl;
      cout<<"oldname="<<oldname<<endl;
      cout<<"newname="<<newname<<endl;

      add_histos(histo1_name,histo2_name,histo3_name,oldname,newname);
    }

  return(0);
}

//Check file integrity
int integrity(char *filename, char *the_name, char *the_class)
{
  int ok=0;
  TFile f(filename,"READ");
  if(f.IsZombie())
    {
      cout<<"ERROR: File "<<filename<<" not found"<<endl;
      return(-2);
    }
  TIter next(f.GetListOfKeys());
  TKey *key;
  while ((key=(TKey*)next()))
    {
      if(strcmp(key->GetName(),the_name) == 0 && strcmp(key->GetClassName(),the_class) == 0)
        ok=1;
    }
  f.Close();
  if(ok==1)
    return(0);
  else
    {
      cout<<"ERROR: Key "<<the_name<<" pointing to object of class "<<the_class<<" not found."<<endl;
      return(-1);
    }
}

int add_histos(char *histo1_name,char *histo2_name,char *histo3_name,char *oldname,char *newname)
{
  //check file integrity
  if(integrity(histo1_name,oldname,"TH1D")!=0)
    exit(-1);
  if(integrity(histo2_name,oldname,"TH1D")!=0)
    exit(-1);

  //open input files
  TFile f1(histo1_name,"READ");
  TFile f2(histo2_name,"READ");

  //get input histos
  TH1D *H1 = (TH1D*)f1.Get(oldname);
  TH1D *H2 = (TH1D*)f2.Get(oldname);

  //Clone H3 from H1
  TH1D *H3 = (TH1D*)H1->Clone(newname);

  //histo1+histo2->histo3
  H3->Add(H1,H2);

  //write histo3
  TFile f3(histo3_name,"RECREATE");
  H3->Write();
  f3.Close();

  //close input files
  f1.Close();
  f2.Close();

  return(0);
}
