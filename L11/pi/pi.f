      program compute_pi
        implicit none
        include "omp_lib.h"
        
        integer n, i, numthr
        character*32 inarg
        parameter (n = 9100)
        double precision w, x, sum, pi, f, y, piref
        parameter (piref = 3.141592653589793238d0)
        
        f(y) = 4.d0/(1.d0+y*y)
  
        call get_command_argument(1, inarg)
        read(inarg,'(i2)') numthr

        call omp_set_num_threads(numthr)

        print'(a,i2,a,i2,a)', 
     &          'The paralel part of program is running on ',
     &          omp_get_max_threads(), ' threads, ',
     &          omp_get_num_procs(), ' processors'

        w = 1.0d0/n
        sum = 0.0d0;
!$omp parallel do private(x) shared(w)
!$omp& reduction(+:sum)
        do i=1,n
          x = w*(i-0.5d0)
          sum = sum + f(x)
        end do
        
        pi = w*sum
        print'(a, f18.16)', 'pi    = ', pi
        print'(a, f18.16)', 'piref = ', piref
        print'(a, e9.3)', 'The difference is ', abs(pi-piref)
      end