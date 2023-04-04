      program test
        implicit none
        include 'mpif.h'

        integer commpr, comm
        integer sizew, rankw, size, rank
        integer i, ierr

        integer sorc, dest
        
        integer MAXPROC, MAXEGNUM
        parameter (MAXPROC = 1000, MAXEGNUM = 1000)
        integer idx(MAXPROC), edges(MAXEGNUM)

        integer neighbors(MAXPROC), nghnum

        integer buf

        call MPI_INIT(ierr)

        call MPI_COMM_RANK(MPI_COMM_WORLD, rankw, ierr)
        call MPI_COMM_SIZE(MPI_COMM_WORLD, sizew, ierr)
      
        call MPI_COMM_SPLIT(MPI_COMM_WORLD, mod(rankw, 2), rankw,
     &                      commpr, ierr)
        call sleep(1)
        call MPI_COMM_SIZE(commpr, size, ierr)

        if (mod(rankw, 2) .eq. 0) then ! cartesian topology 
          
          call MPI_CART_CREATE(commpr, 1, size, .true., .true.,
     &                         comm, ierr)
          
          call MPI_CART_SHIFT(comm, 1, 1, sorc, dest, ierr)
          
          call MPI_COMM_RANK(comm, rank, ierr)
          
          call MPI_SENDRECV(rank, 1, MPI_INTEGER, dest,
     &             0, buf, 1, MPI_INTEGER, sorc, 0, comm, 
     &             MPI_STATUS_IGNORE, ierr)

          print*, "The process ", rankw, " reseive ", buf

        else ! graph topology

          do i=1,size
            idx(i) = size-2+i
          enddo

          do i=1, size-1
            edges(i) = i
            edges(size-1+i) = 0
          enddo

          call MPI_GRAPH_CREATE(commpr, size, idx, edges, .true.,
     &                          comm, ierr)

          call MPI_COMM_RANK(comm, rank, ierr)

          call MPI_GRAPH_NEIGHBORS_COUNT(comm, rank, nghnum, ierr)

          call MPI_GRAPH_NEIGHBORS(comm, rank, MAXPROC, neighbors, ierr)

          do i=1,nghnum
            call MPI_SENDRECV(rank, 1, MPI_INTEGER, neighbors(i),
     &             0, buf, 1, MPI_INTEGER, neighbors(i), 0, comm, 
     &             MPI_STATUS_IGNORE, ierr)
       
            print*,"                                                  ",
     &        "The process ", rankw, " reseive ", buf
          enddo


        endif

        call MPI_COMM_FREE(comm, ierr)
        call MPI_COMM_FREE(commpr, ierr)

        call MPI_FINALIZE(ierr)

      endprogram