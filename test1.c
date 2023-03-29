#include <mpi.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    int procNum, procRank, tmp;
    MPI_Status status;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &procNum);
    MPI_Comm_rank(MPI_COMM_WORLD, &procRank);
    printf("Hello from process %i \n", procRank);
    MPI_Finalize();
    return 0;
}
