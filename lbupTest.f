      program test
        implicit none
        include 'mpif.h'

        integer nl, n, matr_rev, ierr

        integer lb, up, extent, size

        n = 100
        nl = 25

        call MPI_INIT(ierr)

        call MPI_TYPE_VECTOR(nl, n, -2*n, MPI_INTEGER,
     &                       matr_rev, ierr)

        call MPI_TYPE_COMMIT(matr_rev, ierr)

        call MPI_TYPE_LB(matr_rev, lb, ierr)
        print*, lb/4

        call MPI_TYPE_UB(matr_rev, up, ierr)
        print*, up/4

        call MPI_TYPE_EXTENT(matr_rev, extent, ierr)
        print*, extent/4

        call MPI_TYPE_SIZE(matr_rev, size, ierr)
        print*, size/4

        call MPI_TYPE_FREE(matr_rev, ierr)

        call MPI_FINALIZE(ierr)

      endprogram test