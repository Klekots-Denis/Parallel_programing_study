      program main
        implicit none
        include 'mpif.h'

        integer ierr, rank, size, divn, i

        double precision a, b, a1, b1, b2, sum, gsum, dx, x, F
        double precision fx, fxp, time, gtime
        parameter (a = -2, b = 0)
        double precision prsum
        parameter (prsum = 1.6026115940)

        F(x) = (x*x+5*x+6)*cos(2*x)

        call MPI_INIT(ierr)

        time = MPI_WTIME(ierr)

        call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
        call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)

        if (rank .eq. 0) then
          print*, "Please enter the number of divisions "
          read(*,*) divn
          divn = ceiling(1.d0*divn/size)
        endif

        call MPI_BCAST(divn, 1, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)

        a1 = a + (b-a)*rank/size
        b1 = a + (b-a)*(rank+1)/size

        dx = (b1-a1)/divn

        fxp = F(a1)

        b2 = a1+dx
        fx = F(b2)
        
        sum = 0

        do i = 1, divn

          sum = sum + (fxp + fx)/2

          fxp = fx
          b2 = b2+dx
          fx = F(b2)

        enddo

        sum = sum * (b1-a1)/divn

        call MPI_REDUCE(sum, gsum, 1, MPI_DOUBLE_PRECISION, MPI_SUM, 0,
     &                  MPI_COMM_WORLD, ierr)

        if (rank .eq. 0) then

          print*, "The result is ", gsum
          print*, "The precise value is", prsum
          print*, "The error is ", prsum - gsum

          time = MPI_WTIME(ierr) - time

          print*, "The calculation time is ", time

        endif

        call MPI_FINALIZE(ierr)

      endprogram main 