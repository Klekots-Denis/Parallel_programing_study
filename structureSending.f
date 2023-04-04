      program test
        implicit none
        include 'mpif.h'

        integer rank, size, ierr, dtype, i, len
        integer blocklens(2), displs(2), types(2)
        character(MPI_MAX_PROCESSOR_NAME) prname

        call MPI_INIT(ierr)

        blocklens(1) = 1
        blocklens(2) = MPI_MAX_PROCESSOR_NAME

        call MPI_ADDRESS(rank, displs(1), ierr)
        call MPI_ADDRESS(prname, displs(2), ierr)
        
        print*, displs(2) / 2.d0**30
        print*, displs(1) / 2.d0**30
        displs(2) = displs(2) - displs(1)
        displs(1) = 0

        types(1) = MPI_INTEGER
        types(2) = MPI_CHARACTER

        call MPI_TYPE_STRUCT(2, blocklens, displs, types, dtype, ierr)

        call MPI_TYPE_COMMIT(dtype, ierr)

        call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
        call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
        call MPI_GET_PROCESSOR_NAME(prname, len, ierr)

        if (rank .ne. 0) then

          call MPI_SEND(rank, 1, dtype, 0, 1,MPI_COMM_WORLD, ierr)
          
        else

          do i=1, size-1
            call MPI_RECV(rank, 1, dtype, i, 1, MPI_COMM_WORLD,
     &                    MPI_STATUS_IGNORE, ierr)
            print*, "process ", rank, " is running on ", prname(1:32)

          enddo

        endif

        call MPI_TYPE_FREE(dtype, ierr)

        call MPI_FINALIZE(ierr)


      endprogram test