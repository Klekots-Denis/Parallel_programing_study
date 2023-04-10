      program relayCircle
        implicit none
        include 'mpif.h'

        integer ierr, rank, size, prev, next, reqs(4), buf(2)
        integer stats(MPI_STATUS_SIZE,4)

        call MPI_INIT(ierr)

        call MPI_COMM_RANK(MPI_COMM_WORLD, rank)
        call MPI_COMM_SIZE(MPI_COMM_WORLD, size)

        next = rank + 1
        prev = rank - 1
        
        if( next .eq. size) next = 0
        if( prev .eq.   -1) prev = size -1

        call MPI_IRECV(buf(1), 1, MPI_INTEGER, prev, 0, MPI_COMM_WORLD,
     &                 reqs(1), ierr)
        call MPI_IRECV(buf(2), 1, MPI_INTEGER, next, 0, MPI_COMM_WORLD,
     &                 reqs(2), ierr)
        call MPI_ISEND(rank, 1, MPI_INTEGER, next, 0, MPI_COMM_WORLD,
     &                 reqs(3), ierr)
        call MPI_ISEND(rank, 1, MPI_INTEGER, prev, 0, MPI_COMM_WORLD,
     &                 reqs(4), ierr)
        call MPI_WAITALL(4, reqs, stats, ierr)

        print'(a,i2,a,i2,a,i2)', "Rank = ", rank, " prev = ", buf(1), 
     &       " next = ", buf(2)

        call MPI_FINALIZE(ierr)

      end program relayCircle
