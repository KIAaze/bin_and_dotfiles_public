#include <time.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <iostream>
using namespace std;

// Simple program to generate random integer numbers between 2 values
// Usage: ./rand Nmin Nmax
// Compilation: g++ random_number_generator.cpp -o random_number_generator.bin
// The randomness is seeded using the process PID, so it works nicely when called in a while loop for example.
// Using time() to seed leads to the random number changing only every second.
// Of course, if someone can catch the PID, they will be able to predict the random number...

int main(int argc, char **argv)
{
  // pid_t jo = getpid();
  // cout<<getpid()<<endl;
  // return(0);

  // cout<<argc<<endl;
  // cout<<argv[1]<<endl;
  // cout<<argv[2]<<endl;
  int Nmin = atoi(argv[1]); // cout<<"Nmin="<<Nmin<<endl;
  int Nmax = atoi(argv[2]); // cout<<"Nmax="<<Nmax<<endl;

  time_t t;
  time(&t);
  // cout<<t<<endl;
  srandom(getpid());
  int n=random();
  cout << Nmin + ( n%(Nmax - Nmin + 1) ) << endl;
  // cout<<RAND_MAX<<endl;
  return(0);
}
