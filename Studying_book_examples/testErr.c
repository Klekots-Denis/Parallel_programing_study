// the program to check is the entire mpi program crash if
// one of the procrss got an emergency exit
                                                                                                                               
                                                                                                                               
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
                                                                                                                               
int main()
{                                                                                                                              
                                                                                                                               
        MPI_Init(NULL, NULL);
                                                                                                                               
        int world_rank;
        MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);                                                                            
                                                                                                                               
        if(world_rank == 0)
        {                                                                                                                      
           printf("Hello from rank %d \n", world_rank);
           printf("The program in about to crash \n");
           exit(1);
        }                                                                                                                      
        else
        {                                                                                                                      
           for(int i = 1; i < 10; ++i)
           {                                                                                                                   
             printf("Hello form rank %d %d time \n",world_rank, i);
           }                                                                                                                   
        }                                                                                                                      
                                                                                                                               
        MPI_Finalize();                                                                                                        
                                                                                                                               
        return 0;
}                                                                                                                              