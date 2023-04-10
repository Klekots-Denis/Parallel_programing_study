      program test
        implicit none
        include 'mpif.h'

        integer BUFSIZE, MAXPROC
        parameter (BUFSIZE = 16, MAXPROC = 64)
        integer sbuf(BUFSIZE), rbuf(BUFSIZE)
        integer req(2*MAXPROC), stats(2*MAXPROC)
        integer i, ierr, size, rank

        call MPI_INIT(ierr)

        call MPI_COMM_SIZE(MPI_COMM_WORLD, size)
        call MPI_COMM_RANK(MPI_COMM_WORLD, rank)
        
        do i=1,BUFSIZE
          sbuf(i) = rank
          rbuf(i) = -1
        enddo        

        call MY_ALL2ALL(sbuf, 1, MPI_INTEGER, rbuf, 2, MPI_COMM_WORLD,
     &                  req, ierr)
        call MPI_WAITALL(size*2, req, stats)

        print'(i3, a, 16i3)', rank, "|", rbuf

        call MPI_FINALIZE(ierr)

      contains!=========================================================

      subroutine MY_ALL2ALL(sbuf, scount, type, rbuf, rcount, comm, req,
     &                      ierr)

        integer scount, type, rcount, comm, ierr
        integer sbuf(:), rbuf(:), req(:)

        integer i

      
        do i=0,size-1

          call MPI_ISEND(sbuf(scount*i+1), scount, type, i, 3569,
     &                   comm, req(i+1), ierr)
          call MPI_IRECV(rbuf(rcount*i+1), rcount, type, i, 3569,
     &                   comm, req(size+i), ierr)
        enddo


      endsubroutine MY_ALL2ALL

      endprogram test