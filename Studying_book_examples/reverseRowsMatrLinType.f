      program example19
        implicit none
        include 'mpif.h'
        
        integer ierr, rank, size, N, nl
        parameter (N = 8)
        integer a(N, N), b(N, N)
        
        call MPI_INIT(ierr)
        call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
        call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
        
        nl = (N-1)/size+1
        
        call work(a, b, N, nl, size, rank)
        call MPI_FINALIZE(ierr)
      
        end

      subroutine work(a, b, n, nl, size, rank)
        include 'mpif.h'
        
        integer ierr, rank, size, n, nl, ii, matr_rov
        integer matr_part, matr_recv
        integer a(nl, n), b(nl, n)
        integer i, j, status(MPI_STATUS_SIZE)

        do i=1,nl
          do j=1,n
            ii = i+rank*nl
            a(i,j) = 100*ii+j
            b(i,j) = 0
          enddo
        enddo

        call MPI_TYPE_VECTOR(n, 1, nl, MPI_INTEGER, matr_rov, ierr)
        call MPI_TYPE_COMMIT(matr_rov, ierr)

        call MPI_TYPE_HVECTOR(nl, 1, -4, matr_rov, matr_part, iarr)
        call MPI_TYPE_COMMIT(matr_part, ierr)

        call MPI_TYPE_HVECTOR(nl, 1, 4, matr_rov, matr_recv, iarr)
        call MPI_TYPE_COMMIT(matr_recv, ierr)

        call MPI_SENDRECV(a(nl,1), 1, matr_part, size-1-rank, 1,
     &                     b(1,1), 1, matr_recv, size-1-rank, 1,
     &                     MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)

      do j=1, size
        do i = 1, nl
          call MPI_BARRIER(ierr)
          if (j .eq. rank+1) print'(8i4, "|", 8i4)', a(i,1:8), b(i,1:8)
        enddo
      enddo

      call MPI_TYPE_FREE(matr_rov, ierr)
      call MPI_TYPE_FREE(matr_part, ierr)
      call MPI_TYPE_FREE(matr_recv, ierr)

      endsubroutine work