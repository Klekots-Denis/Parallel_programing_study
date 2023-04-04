      program test
        implicit none
        include 'mpif.h'

        integer ierr, rank, n, i, j, type
        parameter (n = 10)
        integer a(n,n), b(n,n)

        call MPI_INIT(ierr)

        do i = 1,n
          do j = 1,n
            
            if (i .eq. j) then
              a(i,j) = i
            else
              a(i,j) = 0
            endif

            b(i,j) = -1

          enddo
        enddo

        call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)

        call MPI_TYPE_VECTOR(n, 1, n+1, MPI_INTEGER, type, ierr)
        call MPI_TYPE_COMMIT(type, ierr)

        if(rank .eq. 0) then
          call MPI_SEND(a, 1, type, 1, 1, MPI_COMM_WORLD, ierr)
        else if(rank .eq. 1) then
          call MPI_RECV(b, 1, type, 0, 1, MPI_COMM_WORLD,
     &                  MPI_STATUS_IGNORE, ierr)
        endif

        if(rank .eq. 0) then
          print*, "Rank = 0"
          print*, "=========================="
          print*, "a(i,j) = "

          print'(10i3)', (/ ((a(i,j), j=1,10), i=1,10) /)

          print*, "=========================="
          print*, "b(i,j) = "

          print'(10i3)', (/ ((b(i,j), j=1,10), i=1,10) /)

          call MPI_BARRIER(MPI_COMM_WORLD, ierr)

        else if(rank .eq. 1) then

          call MPI_BARRIER(MPI_COMM_WORLD, ierr)

          print*, "Rank = 1"
          print*, "=========================="
          print*, "a(i,j) = "

          print'(10i3)', (/ ((a(i,j), j=1,10), i=1,10) /)

          print*, "=========================="
          print*, "b(i,j) = "

          print'(10i3)', (/ ((b(i,j), j=1,10), i=1,10) /)

        else

        endif

        call MPI_TYPE_FREE(type, ierr)

        call MPI_FINALIZE(ierr)

      endprogram