      program matrmult
        implicit none
        include "omp_lib.h"
        
        integer N
        parameter(N=590)
        double precision a(N, N), b(N, N), c(N, N)
        integer i, j, k
        double precision t1, t2
        integer ni, numthr
        character*32, inarg

        call get_command_argument(1, inarg)
        read(inarg,*) numthr

        call get_command_argument(2, inarg)
        read(inarg,*) ni

        call omp_set_num_threads(numthr)

        print'(a,i2,a,i2,a)', 
     &          'The paralel part of program is running on ',
     &          omp_get_max_threads(), ' threads, ',
     &          omp_get_num_procs(), ' processors'

C initialisation of the matrices
        do i=1, ni
          do j=1, ni
            a(i, j)=(i-1)*(j-1)
            b(i, j)=(i-1)*(j-1)
          end do
        end do
        t1=omp_get_wtime()

C main calculation block
!$omp parallel do shared(a, b, c) private(i, j, k)
        do j=1, ni
          do i=1, ni  
            c(i, j) = 0.0
            do k=1, ni
              c(i, j)=c(i, j)+a(i, k)*b(k, j)
            end do
          end do
        end do

        t2=omp_get_wtime()
        print'(a,e18.11)', "Time =", t2-t1

        if (ni < 20) then

            open(10, file="Out_f.txt")

            do i=1, ni

                write(10,'(20f10.0)') ( c(i,j), j=1,ni )

            enddo

            close(10)

        endif

      end