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
        
        integer ierr, rank, size, n, nl, ii, SENDBUFSIZE, packsize
        parameter (SENDBUFSIZE = 1024)
        integer a(nl, n), b(nl, n), sendBuf(SENDBUFSIZE), bufcolumn(nl)
        integer i, j, position

        do i=1,nl
          do j=1,n
            ii = i+rank*nl
            a(i,j) = 100*ii+j
            b(i,j) = 0
          enddo
        enddo

        call MPI_PACK_SIZE(n*nl, MPI_INTEGER, MPI_COMM_WORLD,
     &                     packsize, ierr)

        position = 0

        do j = 1,n

          bufcolumn(1:nl) = (/ (a(1,j), i=nl,1,-1) /)

          call MPI_PACK(bufcolumn, nl, MPI_INTEGER, sendBuf, packsize,
     &                  position, MPI_COMM_WORLD, ierr)
          
        enddo

        call MPI_SENDRECV_REPLACE(sendBuf, packsize, MPI_PACKED,
     &           size-rank-1, 0, size-rank-1, 0, 
     &           MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
        
        position = 0
        call MPI_UNPACK(sendBuf, packsize, position, b, nl*n, 
     &                  MPI_INTEGER, MPI_COMM_WORLD, ierr)

        do j=1, size
          do i = 1, nl
            call MPI_BARRIER(ierr)
            if (j .eq. rank+1) print'(8i4, "|", 8i4)', 
     &                         a(i,1:8), b(i,1:8)
          enddo
        enddo

      endsubroutine work