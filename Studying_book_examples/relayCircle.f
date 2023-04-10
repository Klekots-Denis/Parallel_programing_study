      program relayCircle
        implicit none
        include 'mpif.h'

        integer ierr, rank, size, buf

        call MPI_INIT(ierr)

        call MPI_COMM_RANK(MPI_COMM_WORLD, rank)
        call MPI_COMM_SIZE(MPI_COMM_WORLD, size)

        if (rank .eq. 0) then
            call MPI_SEND(rank, 1, MPI_INTEGER, size-1, 0, 
     &                    MPI_COMM_WORLD, ierr)
            call MPI_RECV(buf, 1, MPI_INTEGER, 1, 0, MPI_COMM_WORLD,
     &                    MPI_STATUS_IGNORE, ierr)
        elseif (rank .eq. size-1) then
          call MPI_RECV(buf, 1, MPI_INTEGER, 0, 0, MPI_COMM_WORLD,
     &                  MPI_STATUS_IGNORE, ierr)
          call MPI_SEND(rank, 1, MPI_INTEGER, rank-1, 0, MPI_COMM_WORLD,
     &                  ierr)
        else
          call MPI_RECV(buf, 1, MPI_INTEGER, rank+1, 0, MPI_COMM_WORLD, 
     &                  MPI_STATUS_IGNORE, ierr)
          call MPI_SEND(rank, 1, MPI_INTEGER, rank-1, 0, MPI_COMM_WORLD,
     &                  ierr)
        endif

        print'(a,i2,a,i2)', "Rank = ", rank, " prev = ", buf

        call MPI_FINALIZE(ierr)

      end program relayCircle
