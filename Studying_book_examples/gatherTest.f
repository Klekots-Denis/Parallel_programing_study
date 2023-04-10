      program test
        implicit none
        include 'mpif.h'

        integer size, rank, i, ierr, MAXBUFSIZE
        parameter (MAXBUFSIZE = 10)
        integer sbuf(MAXBUFSIZE) 
        integer rbuf(MAXBUFSIZE)

        call MPI_INIT(ierr)

        call MPI_COMM_RANK(MPI_COMM_WORLD, rank)
        call MPI_COMM_SIZE(MPI_COMM_WORLD, size)

        do i=1,MAXBUFSIZE
          sbuf(i) = rank+1
          rbuf(i) = -1
        enddo


    !     call MPI_GATHER(sbuf, rank+1, MPI_REAL, rbuf, 3,
    !  &                    MPI_DOUBLE_PRECISION, 0, MPI_COMM_WORLD, ierr)
        
        call MY_GATHER(sbuf, rank+1, MPI_INTEGER, rbuf, 3,
     &                  0, MPI_COMM_WORLD, ierr)

        print'(a, i3, a, 20i6)', "rank = ", rank, "|", rbuf

        call MPI_FINALIZE(ierr)

      contains !=======================================================

      subroutine MY_GATHER(sb, scount, type, rb, rcount, root, com,
     &                     ierr)
        implicit none
        include 'mpif.h'

        integer scount, type, rcount, root, com, ierr
        integer :: sb(:)
        integer :: rb(:)
        integer MAXNPROC
        parameter (MAXNPROC = 128)
        integer req(MAXNPROC), stats(MPI_STATUS_SIZE, MAXNPROC)

        integer rank, size, i

        i = sb(1)!this line do nothing, but without it the program crash

        call MPI_COMM_RANK(com, rank)
        call MPI_COMM_SIZE(com, size)
        
        call MPI_SEND(sb(1), scount, type, root, 16598, com, ierr)
        
        if(rank .eq. root) then

          do i=0,size-1
            call MPI_IRECV(rb(i*rcount+1), rcount, type, i, 16598, 
     &           com, req(i+1), ierr)
          enddo

          call MPI_WAITALL(size, req, stats, ierr)

        endif

      endsubroutine MY_GATHER

      endprogram test