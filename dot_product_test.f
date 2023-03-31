      program main
        implicit none
        include 'mpif.h'

        integer i, ierr, rank
        double precision :: result = 0
        double precision :: summ   = 0

        double precision vec1(1000)
        double precision vec2(1000)

        double precision  buf1(500), buf2(500)

        data vec1, vec2 / 1000*0.2, 1000*0.4 /

        call MPI_INIT(ierr)

        call MPI_COMM_RANK(MPI_COMM_WORLD, rank)

        if (rank .eq. 0) then

            call MPI_SEND(vec1, 500, MPI_DOUBLE_PRECISION, 1, 1, 
     &               MPI_COMM_WORLD, ierr)
            call MPI_SEND(vec2, 500, MPI_DOUBLE_PRECISION, 1, 2, 
     &               MPI_COMM_WORLD, ierr)

            call MPI_SEND(vec1(501:1000), 500, MPI_DOUBLE_PRECISION, 2, 
     &               1, MPI_COMM_WORLD, ierr)
            call MPI_SEND(vec2(501:1000), 500, MPI_DOUBLE_PRECISION, 2, 
     &                2, MPI_COMM_WORLD, ierr)

            call MPI_RECV(result, 1, MPI_DOUBLE_PRECISION, 1, 3,
     &               MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)

            call MPI_RECV(summ, 1, MPI_DOUBLE_PRECISION, 2, 3,
     &               MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)

            summ = result + summ

            print*, "The dot product of vectors is ", summ

        else if(rank .eq. 1) then

            call MPI_RECV(buf1, 500, MPI_DOUBLE_PRECISION, 0, 1,
     &               MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)

            call MPI_RECV(buf2, 500, MPI_DOUBLE_PRECISION, 0, 2,
     &               MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)

            do i=1,500
              result = result + buf1(i)*buf2(i)
            enddo

            call MPI_SEND(result, 1, MPI_DOUBLE_PRECISION, 0, 3,
     &               MPI_COMM_WORLD, ierr)

        else if(rank .eq. 2) then

            call MPI_RECV(buf1, 500, MPI_DOUBLE_PRECISION, 0, 1,
     &               MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)

            call MPI_RECV(buf2, 500, MPI_DOUBLE_PRECISION, 0, 2,
     &               MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)

            do i=1,500
                result = result + buf1(i)*buf2(i)
            enddo

            call MPI_SEND(result, 1, MPI_DOUBLE_PRECISION, 0, 3,
     &               MPI_COMM_WORLD, ierr)

        endif


        call MPI_FINALIZE(ierr)


      end program