      program main
        implicit none
        include 'mpif.h'

        integer ierr, rank, size, divn, i

        double precision a, b, a1, b1, b2, sum, gsum, dx, x, F
        double precision fx, fxp, time, gtime
        parameter (a = 0, b = 1)

        F(x) = 1 + x

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

        if (rank .ne. 0) then
          call MPI_SEND(sum, 1, MPI_DOUBLE_PRECISION, 0, 0, 
     &                  MPI_COMM_WORLD, ierr)
        else 
          gsum = sum

          do i=1,size-1
            call MPI_RECV(sum, 1, MPI_DOUBLE_PRECISION, MPI_ANY_SOURCE,
     &                    0, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
            gsum = gsum + sum
          enddo

          print*, "The result is ", gsum

        endif

        time = MPI_WTIME(ierr) - time

        call MPI_REDUCE(time, gtime, 1, MPI_DOUBLE_PRECISION, MPI_SUM, 
     &                  0, MPI_COMM_WORLD, ierr)  

        if (rank .eq. 0) then

          print*, "The processor time is ", gtime

        endif

        call MPI_FINALIZE(ierr)


      endprogram main 