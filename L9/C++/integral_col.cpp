#include <mpi.h>
#include <iostream>
#include <cmath>

using namespace std;

double F(double x)
{
    return (x*x+5*x+6)*cos(2*x);
}

int main(int argc, char **argv)
{
    const double a = -2;
    const double b = 0;

    const double prsum = 1.6026115940;

    int rank;
    int size;

    MPI_Init(&argc, &argv);

    double time = MPI_Wtime();

    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    int divn;

    if(rank == 0)
    {
        cout << "Please enter the number of divisions " << endl;
        cin >> divn;
        divn = ceil(1.0*divn/size);
    }

    MPI_Bcast(&divn, 1, MPI_INT, 0, MPI_COMM_WORLD);

    double a1 = a + (b-a)*rank/size;
    double b1 = a + (b-a)*(rank+1)/size;

    double dx = (b1-a1)/divn;

    double Fxp = F(a1);

    double b2 = a1+dx;
    double Fx = F(b2);

    double sum = 0;

    for(int i = 0; i < divn; ++i)
    {
        sum += (Fxp+Fx)/2;

        Fxp = Fx;
        b2 = b2 + dx;
        Fx = F(b2);
    }

    sum *= (b1-a1)/divn;

    double gsum;

    MPI_Reduce(&sum, &gsum, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0)
    {
        cout << "The result is " << gsum << endl;
        cout << "The precise value is " << prsum << endl;
        cout << "The error is " << prsum - gsum << endl;

        time = MPI_Wtime() - time;

        cout << "The calculation time is " << time << endl;
    }

    MPI_Finalize();

    return 0;
}