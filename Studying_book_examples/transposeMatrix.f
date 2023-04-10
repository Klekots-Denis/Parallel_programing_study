      program test
        implicit none
        include 'mpif.h'

        integer ierr, i, j, N, type, rank
        parameter (N = 9)
        integer a(N,N), b(N,N), req(2*N), stats(MPI_STATUS_SIZE, 2*N)

        call MPI_INIT(ierr)

        call MPI_COMM_RANK(MPI_COMM_WORLD, rank)

        if (rank .ne. 0) then
          call MPI_FINALIZE(ierr)
          stop
        endif

        do i=1,N
          do j=1,N
            a(i,j) = 100*i+j
            b(i,j) = 0
          enddo
        enddo

        call MPI_TYPE_VECTOR(n, 1, n, MPI_INTEGER, type, ierr)
        call MPI_TYPE_COMMIT(type, ierr)

        do i = 1, N
          call MPI_ISEND(a(i,1), 1, type, 0, 0, MPI_COMM_WORLD,
     &                   req(i), ierr)
          call MPI_IRECV(b(1,i), n, MPI_INTEGER, 0,0, MPI_COMM_WORLD,
     &                   req(i+N), ierr)
        enddo

        call MPI_WAITALL(2*N, req, stats, ierr)

        print*, "a(i,j) = "
        print'(9i4)', a
        print*, "============================="
        print*, "b(i,j) = "
        print'(9i4)', b

        call MPI_TYPE_FREE(type, ierr)
        call MPI_FINALIZE(ierr)


      endprogram test