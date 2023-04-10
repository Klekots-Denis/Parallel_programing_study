      program test
        implicit none
        include 'mpif.h'

        integer BUFSIZE
        parameter (BUFSIZE = 1000)
        integer i, j, rank, buf1(BUFSIZE), buf2(BUFSIZE),ierr, reqs(2)
        integer stats(MPI_STATUS_SIZE, 2)

        real time

        call MPI_INIT(ierr)
        
        call MPI_COMM_RANK(MPI_COMM_WORLD, rank)
        
        if (rank .eq. 0) then

          time = MPI_WTIME(ierr)

          do i=1,1000

            ! buf1(:) = (/ (i+j, j=1,BUFSIZE) /)

            call MPI_ISEND(buf1, BUFSIZE, MPI_INTEGER, 1, 0, 
     &                     MPI_COMM_WORLD, reqs(1), ierr)

            call MPI_IRECV(buf2, BUFSIZE, MPI_INTEGER, 1, 0, 
     &                     MPI_COMM_WORLD, reqs(2), ierr)

            call MPI_WAITALL(2, reqs, stats, ierr)

    !         call MPI_SENDRECV(buf1, BUFSIZE, MPI_INTEGER, 1, 0, buf2, 
    !  &                        BUFSIZE, MPI_INTEGER, 1, 0, 
    !  &                        MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr )

            ! print*, (/ (buf2(j), j=1,BUFSIZE) /)
            ! print*, "=================================================="

          enddo

          time = MPI_WTIME(ierr) - time
          print*, "The time is ", time

        else

          do i=1,1000

            ! buf2(:) = (/ (i+j, j=1,BUFSIZE) /)

    !       call MPI_SENDRECV(buf2, BUFSIZE, MPI_INTEGER, 0, 0, buf1, 
    !  &                        BUFSIZE, MPI_INTEGER, 0, 0, 
    !  &                        MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr )

            call MPI_IRECV(buf1, BUFSIZE, MPI_INTEGER, 0, 0, 
     &                     MPI_COMM_WORLD, reqs(1), ierr)

            call MPI_ISEND(buf2, BUFSIZE, MPI_INTEGER, 0, 0, 
     &                     MPI_COMM_WORLD, reqs(2), ierr)

            call MPI_WAITALL(2, reqs, stats, ierr)

          enddo

        endif

        call MPI_FINALIZE(ierr)

      endprogram test