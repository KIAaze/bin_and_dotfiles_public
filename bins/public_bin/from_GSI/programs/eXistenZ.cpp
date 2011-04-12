#include <iostream>
#include <fstream>
using namespace std;

int main(int argc, char *argv[])
{
  if(argc!=2)
  {
    cerr<<"error: Please enter filename (only one argument accepted)"<<endl;
    return(-2);
  }
  fstream fin;
  fin.open(argv[1],ios::in);
  if( fin.is_open() )
  {
    cout<<"file exists"<<endl;
    return(0);
  }
  else
  {
    cerr<<"error: file does not exist"<<endl;
    return(-1);
  }    
  fin.close();
}
