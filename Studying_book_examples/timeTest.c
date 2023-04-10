#include <stdio.h>
#include <mpi.h>

int main()
{

    MPI_Init(NULL, NULL);

    double time = MPI_Wtime();
    printf("the time is %f\n", time);
    printf("MPI_WTIME_IS_GLOBAL = %d\n", MPI_WTIME_IS_GLOBAL);

    MPI_Finalize();

    return 0;
}
