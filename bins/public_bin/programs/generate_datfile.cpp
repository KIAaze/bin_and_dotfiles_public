#include <stdio.h>
#include <stdlib.h>
#include <iostream.h>

void create_MUCHnew_geo_file(char *geometry="much_large");
int display_file(char *filename);

int main(int argc,char *argv[])
{
//-----------------------------------------------------
  //initialization of main variables
  char outfile[20];//output file
  const int max = 100;   // max. number of stations
  
  int n;             // number of stations
  float dDD;         // detector/detector distance [mm]
  float dAD;         // absorber/detector distance [mm]  
  
  int type[max];     // detector type
  float z[max];         // z position from target [mm]
  float d[max];         // detector thickness [mm]
  char material[256][max];//material
//-----------------------------------------------------
  //reading and checking input arguments
  if(argc<6)
  {
    printf("not enough arguments\n");
    printf("You gave %d argumenst.\n",argc-1);
    printf("At least 5 arguments are needed:\n");
    printf("outfile,n,dDD,dAD,absorber thickness(es)...\n");
    exit(-1);
  }
  
  strcpy(outfile,argv[1]);
  n=atoi(argv[2]);
  dDD=atof(argv[3]);
  dAD=atof(argv[4]);
  
  if((n/4)*4!=n || n>max)
  {
    printf("Unacceptable number of stations. Must be a multiple of 4 and less than %d.\n",max);
    exit(-1);
  }
  
  int given=argc-5;
  int needed=n/4;
  
  if(given!=needed)
  {
    printf("You gave %d absorber thickness(es), but %d are needed.\n",given,needed);
    exit(-1);
  }
  
  //N_absorbers=argc-5;
  int N_absorbers=n/4;
  int *absorbers=new int[N_absorbers];
  
  for(int i=0;i<N_absorbers;i++)
  {
    absorbers[i]=atoi(argv[i+5]);
  }  
//-----------------------------------------------------
  //input verification
  cout<<"outfile="<<outfile<<endl;
  cout<<"n="<<n<<endl;
  cout<<"dDD="<<dDD<<endl;
  cout<<"dAD="<<dAD<<endl;
  for(int i=0;i<N_absorbers;i++)
  {
    cout<<"absorbers["<<i<<"]="<<absorbers[i]<<endl;
  }  
//-----------------------------------------------------
  //MUCH_large.geo:
  /*n=24;
  dDD=50;
  dAD=25;
  int absorbers[6]={200,200,200,300,350,1000};*/  
//-----------------------------------------------------
  //creating filenames with extensions
  char datfile[256];       // geometry data file - input
  char logfile[256];      // log file for the conversion
  char geofile[256];      // geometry data file for CBMROOT - output
  sprintf(datfile,"%s.dat",outfile);
  sprintf(logfile,"%s.log",outfile);
  sprintf(geofile,"%s.geo",outfile);  
//-----------------------------------------------------
  //create .dat file
  FILE *out=fopen(datfile,"w");
  
  fprintf(out,"stations\n");
  fprintf(out,"%d\n",n);
  fprintf(out,"distance1\n");
  fprintf(out,"%f\n",dDD);
  fprintf(out,"distance2\n");
  fprintf(out,"%f\n",dAD);
  
  fprintf(out,"parameters\n");
  for(int i=0; i<n; i++)
  {
    if(i%4==0)
    {
      type[i]=0;
      sprintf(material[i],"MUCHiron");
      d[i]=absorbers[i/4];
    }
    else
    {
      type[i]=1;
      sprintf(material[i],"MUCHargon");
      d[i]=10;
    }
    if(i==0) z[i]=1025;
    else z[i]=0;    
    fprintf(out,"%d\t%d\t%f\t%f\t%s\n",i+1,type[i],z[i],d[i],material[i]);
  }
  
  fclose(out);
//-----------------------------------------------------
  //freeing memory
  delete(absorbers);
//-----------------------------------------------------
  //create .log and .geo file from .dat file
  create_MUCHnew_geo_file(outfile);
//-----------------------------------------------------
  //display generated files
  cout<<"==="<<datfile<<"==="<<endl;
  display_file(datfile);
  cout<<"==="<<logfile<<"==="<<endl;
  display_file(logfile);
  cout<<"==="<<geofile<<"==="<<endl;
  display_file(geofile);
}

/***********************************************************/
/* Function to generate .log and .geo files from .dat file */ 
/***********************************************************/

void create_MUCHnew_geo_file(char *geometry)
{

  char infile[256];       // geometry data file - input
  char outfile[256];      // geometry data file for CBMROOT - output
  char logfile[256];      // log file for the conversion
  const int max = 100;   // max. number of stations
  float d[max];         // detector thickness [mm]
  float dDD;         // detector/detector distance [mm]
  float dAD;         // absorber/detector distance [mm]  
  float ri1[max];        // inner radius       [mm]
  float ro1[max];        // outer radius       [mm]
  float ri2[max];        // inner radius       [mm]
  float ro2[max];        // outer radius       [mm]
  float z[max];         // z position from target [mm]
  float ai[max];        // inner acceptance [deg]
  float ao[max];        // outer acceptance [deg]
  int type[max];     // detector type
  char material[256][max];
  int n,nn;             // counters
  char dummy[16];         //dummy text

  printf("geometry: %s\n",geometry);

  sprintf(infile,"%s.dat",geometry);
  sprintf(outfile,"%s.geo",geometry);
  sprintf(logfile,"%s.log",geometry);

  printf("input file: %s\n",infile);
  
//-----------------------------------------------------
    // read .dat file
  if(!fopen(infile,"r")){
    printf("... does not exist.\n");
    printf("... exit.\n\n");
  }
  else
  {
    printf("output file: %s\n",outfile);
    printf("log file:    %s\n",logfile);
    
    FILE *fin= fopen(infile,"r");
    fscanf (fin, "%s",dummy);
    fscanf (fin, "%d", &n);
    fscanf (fin, "%s",dummy);
    fscanf (fin, "%f", &dDD);
    fscanf (fin, "%s",dummy);
    fscanf (fin, "%f", &dAD);
    fscanf (fin, "%s",dummy);

    for(int i=0; i<n; i++){
      fscanf (fin, "%d %d %f %f %s", &nn, &type[i],&z[i],&d[i],material[i]);
      printf("%d %d %f %f %s\n", nn, type[i],z[i],d[i],material[i]);
    }
    fclose(fin);
   for(int i=1; i<n; i++)
	 {
	 	if(type[i-1] == 1 && type[i] == 1) z[i] = z[i-1] + d[i-1] + dDD;
		 else z[i] = z[i-1] + d[i-1] + dAD;
//   z[i] = z[i-1] + d[i-1] + dAD;
	 }

    // calculate inner and outer radius of the disk
    for(int i=0; i<n; i++) {
      ri1[i] = z[i]*0.1;
      ri2[i] = (z[i]+d[i])*0.1;
      ro1[i] = z[i]*0.5;
      ro2[i] = (z[i]+d[i])*0.5;
    }
//-----------------------------------------------------
    // print info to screen and log file
    FILE *flog= fopen(logfile,"w");

    printf("detector layout:\n");
    for(int i=0; i<n; i++) {
      printf("station: %2d  %3d  %10s z=%6.1f  ri=%5.1f  ro=%5.1f  d=%3.1f\n",
	     i+1,type[i],material[i],z[i],ri1[i],ro1[i],d[i]);
    }

    fprintf(flog,"input file:  %s\n",infile);
    fprintf(flog,"output file: %s\n",outfile);
    fprintf(flog,"detector layout:\n");
    for(int i=0; i<n; i++) {
      fprintf(flog,"station: %2d  %3d  %10s  z=%6.1f  ri=%5.1f  ro=%5.1f  d=%3.1f\n",
	     i+1,type[i],material[i],z[i],ri1[i],ro1[i],d[i]);
    }
    fclose(flog);
//-----------------------------------------------------
    // output to geo file
    FILE *fout= fopen(outfile,"w");
    fprintf(fout,"much1\n");
    fprintf(fout,"cave\n");
    fprintf(fout,"PCON\n");
    fprintf(fout,"air\n");
    fprintf(fout,"2\n");
    fprintf(fout,"0. 360.\n");
    fprintf(fout,"0. %d %d\n", ri1[0], ro1[0]);
    fprintf(fout,"%d %d %d\n",z[nn-1]+d[nn-1]-z[0], ri2[nn-1], ro2[nn-1]);
    fprintf(fout," \n");
    fprintf(fout,"0. 0. %d\n",z[0]);
    fprintf(fout,"1.  0.  0.  0.  1.  0.  0.  0.  1.\n");
    for(int i=0; i<nn; i++)
    {
    	fprintf(fout,"//*********************************\n");
	fprintf(fout,"much1Layer%d\n",i+1);
	fprintf(fout,"much1\n");
	fprintf(fout,"PCON\n");
     	fprintf(fout,"%s\n",material[i]);
     	fprintf(fout,"2\n");
     	fprintf(fout,"0. 360.\n");
     	fprintf(fout,"%d %d %d\n",z[i]-z[0], ri1[i], ro1[i]);
     	fprintf(fout,"%d %d %d\n",z[i]-z[0]+d[i], ri2[i], ro2[i]);
	fprintf(fout," \n");
	fprintf(fout,"0. 0. 0.\n");
	fprintf(fout,"1.  0.  0.  0.  1.  0.  0.  0.  1.\n");
	fprintf(fout,"//*********************************\n");
    }
    fclose(fout);

    printf("... done.\n\n");
  }

}

/**************************************************************/
/* Function to display the text of a file (just like cat :) ) */ 
/**************************************************************/

int display_file(char *filename)
{
  FILE *in;
  char c;
  in = fopen(filename, "r");
  if(in != NULL)
  {
    while((c = fgetc(in)) != EOF) putchar(c);
    
    fclose(in);
  }
  else printf("Unable to open file\n");
  return 0;
}
