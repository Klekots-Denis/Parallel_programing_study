      program main
        implicit none
        include 'mpif.h'

        integer bufsize
        parameter (bufsize=10000)
        integer i, j, buf(bufsize), ierr, rank, request

        real time

        call MPI_INIT(ierr)

        call MPI_COMM_RANK(MPI_COMM_WORLD, rank)

        if (rank .eq. 0) then

          time = MPI_WTIME(ierr)

          call MPI_SEND_INIT(buf, bufsize, MPI_INTEGER, 1, 0,
     &                    MPI_COMM_WORLD, request, ierr)

          do i=1,1000

            do j = 1, bufsize
              buf(j) = i + j
            enddo

    !       call MPI_SEND(buf, bufsize, MPI_INTEGER, 1, 0,
    !  &                    MPI_COMM_WORLD, ierr)

            call MPI_START(request, ierr)
            call MPI_WAIT(request, MPI_STATUS_IGNORE, ierr)
          enddo

          call MPI_REQUEST_FREE(request, ierr)

          time = MPI_WTIME(ierr) - time

          print*, "The time is ", time

        else

          call MPI_RECV_INIT(buf, bufsize, MPI_INTEGER, 0, 0,
     &                       MPI_COMM_WORLD, request, ierr)

          do i=1,1000
            call MPI_START(request, ierr)
            call MPI_WAIT(request, MPI_STATUS_IGNORE, ierr)

    !       call MPI_RECV(buf, bufsize, MPI_INTEGER, 0, 0,
    !  &                       MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)

          ! print*, (/ (buf(i), i=1,bufsize) /)

          enddo

          call MPI_REQUEST_FREE(request, ierr)

        endif

        call MPI_FINALIZE(ierr)

      end program