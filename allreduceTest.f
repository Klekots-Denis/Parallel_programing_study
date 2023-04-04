      program test
        implicit none
        include 'mpif.h'

        integer i, n, size, rank, ierr
        parameter (n = 12)
        double precision a(n), b(n)

        call MPI_INIT(ierr)

        call MPI_COMM_RANK(MPI_COMM_WORLD, rank)
        call MPI_COMM_SIZE(MPI_COMM_WORLD, size)

        do i=1,n
          a(i) = 1.d0/(size+i-1)
        enddo

        call MPI_REDUCE(a, b, n, MPI_DOUBLE_PRECISION, MPI_SUM, 0,
     &         MPI_COMM_WORLD, ierr)

        call MPI_BCAST(b, n, MPI_DOUBLE_PRECISION, 0, MPI_COMM_WORLD,
     &         IERR)

        print'(a, i3)', "rank = ", rank
        print'(12(f5.3" ")/a)', b, "======================"

        call MPI_FINALIZE(ierr)

      endprogram test
