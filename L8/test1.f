      program main_mpi
        implicit none
        include 'mpif.h'
       
        integer myid, nproc, ierr

        call MPI_Init(ierr)
        call MPI_Comm_rank(MPI_COMM_WORLD, myid, ierr)
        call MPI_Comm_size(MPI_COMM_WORLD, nproc, ierr)
        print'(a8,i1,a4,i1)', "process ", myid, " of ", nproc
        call MPI_Finalize(ierr)
      end program
