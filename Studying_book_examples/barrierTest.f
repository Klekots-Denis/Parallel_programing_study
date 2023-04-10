      program test
        implicit none
        include 'mpif.h'

        integer ierr, MAXPROC, rank, size, i, TIMES 
        parameter (MAXPROC = 64, TIMES=1000)
        integer req(2*MAXPROC), stats(MPI_STATUS_SIZE, 2*MAXPROC)
        integer buf(MAXPROC)
        real time

        call MPI_INIT(ierr)

        call MPI_COMM_SIZE(MPI_COMM_WORLD, size)
        call MPI_COMM_RANK(MPI_COMM_WORLD, rank)

        time = MPI_WTIME(ierr)

        if (rank .eq. 0) then
          do i=1,size-1
            call MPI_SEND_INIT(rank, 1, MPI_INTEGER, i, 1,
     &            MPI_COMM_WORLD, req(i), ierr)
            call MPI_RECV_INIT(buf(i), 1, MPI_INTEGER, i, 1,
     &            MPI_COMM_WORLD, req(i+size-1), ierr)
          enddo

          do i=1,TIMES
            call MPI_STARTALL(size-1, req,       ierr)
            call MPI_STARTALL(size-1, req(size), ierr)

            call MPI_WAITALL(size-1, req,       stats, ierr)
            call MPI_WAITALL(size-1, req(size), stats, ierr)
          enddo
        else
          call MPI_RECV_INIT(buf(1), 1, MPI_INTEGER, 0, 1,
     &          MPI_COMM_WORLD, req(1), ierr)
          call MPI_SEND_INIT(rank, 1, MPI_INTEGER, 0, 1,
     &          MPI_COMM_WORLD, req(size), ierr)

          do i=1,TIMES
            call MPI_START(req(1),    ierr)
            call MPI_START(req(size), ierr)


            call MPI_WAIT(req(1),    stats(1,1),    ierr)
            call MPI_WAIT(req(size), stats(1,size), ierr)
          enddo
        endif

        time = MPI_WTIME(ierr) - time

        print*, "rank = ", rank, " all time = ", time/TIMES

C====================================================================72


        time = MPI_WTIME(ierr)

        do i=1,TIMES
          call MPI_BARRIER(MPI_COMM_WORLD, ierr)
        enddo

        time = MPI_WTIME(ierr) - time

        print*, "rank = ", rank, " barrier time = ", time/TIMES


        call MPI_FINALIZE(ierr)
        


      endprogram
