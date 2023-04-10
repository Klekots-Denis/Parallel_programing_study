#include "mpi.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define REALVALUE 0.566

const double A = 0	;
const double B = 1;

double integral(double x){
	return (x*x*x + x)/(x*x*x*x + 1.);
	}

int main(int argc, char** argv)	{
	long long N = atoll(argv[1]);
	int size, rank 		;
	double rsum, timeStart, timeFinish, timeDelta, Ai, Bi, x, yi, yj, F, ISum, timeUser	;
	MPI_Status Status 	;

	MPI_Init(NULL, NULL);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank)	;

	timeStart = MPI_Wtime()	;
	N /= size ;
	Ai = A + (B - A) * rank/ size ;
	Bi = Ai + (B - A) / size ;

	double sum = 0 ;
	yi = integral(Ai) ;
	for (long long i = 0; i < N; ++i){
		x = Ai + (Bi - Ai) * i / N ;
		yj = integral(x);
		sum += yj + yi;
		yi = yj	;
			}

	timeDelta = MPI_Wtime() - timeStart	;

	MPI_Reduce(&sum, &rsum, 1, MPI_DOUBLE_PRECISION, MPI_SUM, 0, MPI_COMM_WORLD);
	MPI_Reduce(&timeDelta, &timeUser, 1, MPI_DOUBLE_PRECISION, MPI_SUM, 0, MPI_COMM_WORLD);

	if (rank == 0)	{
		timeFinish = MPI_Wtime();
		rsum = rsum/(N*size)/2*(B-A);
		std::cout << "Result= " << rsum << " Error= " << (REALVALUE - rsum) << std::endl<<
		"Time user= " << timeUser << "Time real= " << timeFinish - timeStart << std::endl;
		}
	MPI_Finalize()	;
	return 0;
	}