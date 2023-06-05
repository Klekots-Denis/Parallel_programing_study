#include <stdio.h>
#include <omp.h>
#include <math.h>

const double piRef = 3.141592653589793238;

double f(double y) {return(4.0/(1.0+y*y));}

int main(int argc, const char** argv)
{
    int num_threads;
    sscanf(argv[1], "%d", &num_threads);

    omp_set_num_threads(num_threads);

    double w, x, sum, pi;
    int i;
    int n = 9100;
    w = 1.0/n;
    sum = 0.0;

    double test = 1.1;
 
    printf("The paralel part of program is running on %d"\
           " threads, %d processors \n",
            omp_get_max_threads(), omp_get_num_procs());

    #pragma omp parallel for private(x) shared(w)\
    reduction(+:sum)
    for(i=0; i < n; i++)
    {
        x = w*(i+0.5);
        sum = sum + f(x);
    }

    pi = w*sum;
    printf("pi    = %.16f\n", pi);
    printf("piRef = %.16f\n", piRef);
    printf("The differnce is %.2e \n", fabs(pi - piRef));

    return 0;
}