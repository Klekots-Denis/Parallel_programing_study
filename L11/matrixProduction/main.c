#include <stdio.h>
#include <omp.h>

#define N 590

double a[N][N], b[N][N], c[N][N];

int main(int argc, const char** argv)
{

    int num_threads;
    sscanf(argv[1], "%d", &num_threads);

    int n;
    sscanf(argv[2], "%d", &n);

    omp_set_num_threads(num_threads);

    int i, j, k;
    double t1, t2;
    
    // matrix initialisation
    for (i=0; i<n; i++)
    {
        for (j=0; j<n; j++)
        {
            a[i][j]=b[i][j]=i*j;
        }
    }

    printf("The paralel part of program is running on %d"\
           " threads, %d processors \n",
            omp_get_max_threads(), omp_get_num_procs());

    t1=omp_get_wtime();

    // main calculation block
    #pragma omp parallel for shared(a, b, c) private(i, j, k)
    for(i=0; i<N; i++)
    {
        for(j=0; j<n; j++)
        {
            c[i][j] = 0.0;
            for(k=0; k<n; k++) c[i][j]+=a[i][k]*b[k][j];
        }
    }

    t2=omp_get_wtime();

    printf("Time = %11e\n", t2-t1);

    if(n < 20)
    {
        FILE* fptr;

        fptr = fopen("Out_c.txt", "w");

        for(int i=0; i < n; ++i)
        {
            for(int j=0; j < n; ++j)
            {
                fprintf(fptr, "%3.0f\t ", c[i][j]);
            }
            fprintf(fptr, "\n");
        }

        fclose(fptr);
    }
}