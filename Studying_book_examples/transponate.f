      program example11
        include 'mpif.h'
        integer ierr, rank, size, N, nl, i, j
        parameter (N = 9)
        double precision a(N, N), b(N, N)
        call MPI_INIT(ierr)
        call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
        call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
        nl = (N-1)/size + 1
        call work(a, b, N, nl, size, rank)
        call MPI_FINALIZE(ierr)
      end


      subroutine work(a, b, n, nl, size, rank)
        include 'mpif.h'
        integer ierr, rank, size, n, MAXPROC, nl, i, j, ii, jj, ir
        parameter (MAXPROC = 64)
        double precision a(nl, n), b(nl, n), c
        integer irr, status(MPI_STATUS_SIZE), req(MAXPROC*2)

        do i = 1, nl
          do j = 1, n
            ii = i+rank*nl
            if(ii .le. n) a(i, j) = 100*ii+j
          end do
        end do

        do ir = 0, size-1
          if(ir .ne. rank)
     &        call MPI_IRECV(b(1, ir*nl+1), nl*nl,
     &        MPI_DOUBLE_PRECISION, ir,
     &        MPI_ANY_TAG, MPI_COMM_WORLD,
     &        req(ir+1), ierr)
        end do

        req(rank+1) = MPI_REQUEST_NULL

        do ir = 0, size-1
          if(ir .ne. rank)
     &      call MPI_ISEND(a(1, ir*nl+1), nl*nl,
     &      MPI_DOUBLE_PRECISION, ir,
     &      1, MPI_COMM_WORLD,
     &      req(ir+1+size), ierr)
        end do

        ir = rank
        do i = 1, nl
          ii = i+ir*nl
          do j = i+1, nl
            jj = j+ir*nl
            b(i, jj) = a(j, ii)
            b(j, ii) = a(i, jj)
          end do
          b(i, ii) = a(i, ii)
        end do

        do irr = 1, size-1
          call MPI_WAITANY(size, req, ir, status, ierr)
          ir = ir-1
          do i = 1, nl
            ii = i+ir*nl
            do j = i+1, nl
              jj = j+ir*nl
              c = b(i, jj)
              b(i, jj) = b(j, ii)
              b(j, ii) = c
            end do
          end do
        end do

        do i = 1, nl
          do j = 1, N
            ii = i+rank*nl
            if(ii .le. n) 
     &        print *, 'process ', rank,
     &        ': a(', ii, ', ', j, ') =', a(i,j),
     &        ', b(', ii, ', ', j, ') =', b(i,j)
          end do
        end do
      end