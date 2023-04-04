      program example16
        implicit none
        include 'mpif.h'
      
        integer rank, size, i
        integer group, group1, group2, group3 
        integer ranks(8), ranks1(8), ranks2(8), ranks3(8)
        integer ierr

        data ranks1(1:3) / 0,3,4 /
        data ranks2(1:2) / 5,7 /
        data ranks3(1:3) / 6,1,2/

        call MPI_INIT(ierr)

        call MPI_COMM_RANK(MPI_COMM_WORLD, rank)

        if(rank .eq. 0) then
          call MPI_COMM_GROUP(MPI_COMM_WORLD, group, ierr)
          call MPI_GROUP_INCL(group, 3, ranks1, group1, ierr)
          call MPI_GROUP_INCL(group, 3, ranks2, group2, ierr)
          call MPI_GROUP_INCL(group, 3, ranks3, group3, ierr)
          
          do i = 1,8
            ranks1(i) = -1
            ranks2(i) = -1
            ranks3(i) = -1

            ranks(i) = i-1
          enddo

          
          call MPI_GROUP_TRANSLATE_RANKS(group1, 3, ranks, group,
     &                                   ranks1, ierr)
          print"('1| ', 8i3)", ranks1

          call MPI_GROUP_TRANSLATE_RANKS(group2, 2, ranks, group,
     &                                   ranks2, ierr)
          print"('2| ', 8i3)", ranks2

          call MPI_GROUP_TRANSLATE_RANKS(group3, 3, ranks, group,
     &                                   ranks3, ierr)
          print"('3| ', 8i3)", ranks3

          call MPI_GROUP_FREE(group, ierr)
          call MPI_GROUP_FREE(group1, ierr)

        endif

        call MPI_FINALIZE(ierr)

      end