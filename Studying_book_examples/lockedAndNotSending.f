      real function r4_random ( s1, s2, s3 ) result(res)

        implicit none

        integer s1
        integer s2
        integer s3

        s1 = mod ( 171 * s1, 30269 )
        s2 = mod ( 172 * s2, 30307 )
        s3 = mod ( 170 * s3, 30323 )

        res = mod ( real ( s1 ) / 30269.0E+00 
     &                  + real ( s2 ) / 30307.0E+00 
     &                  + real ( s3 ) / 30323.0E+00, 1.0E+00 )

        return
      end function 

C---------------------------------------------------------------------72

      program main
        implicit none
        include 'mpif.h'

        integer :: s1 = 1000
        integer :: s2 = 30007
        integer :: s3 = 7698
        real r4_random
        integer rank, ierr, request
        real :: result = 0
        real :: result2 = 0
        integer i, j
        double precision time

        call MPI_INIT(ierr)

        call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)

        time = MPI_WTIME()

        if (rank .eq. 0) then
          
          do i = 1,100000
            result2 = result
          call MPI_ISEND(result2, 1, MPI_REAL, 1, 0, MPI_COMM_WORLD,
     &                   request, ierr)

    !       call MPI_SSEND(result2, 1, MPI_REAL, 1, 0, MPI_COMM_WORLD,
    !  &                   ierr)

            do j=1,1
              result = result + r4_random(s1, s2, s3)
            end do

            call MPI_WAIT(request, MPI_STATUS_IGNORE, ierr)
          end do

        else

          do i = 1,100000
            result = result + result2
            call MPI_IRECV(result2, 1, MPI_REAL, 0, 0, MPI_COMM_WORLD, 
     &                     request, ierr)

    !         call MPI_RECV(result2, 1, MPI_REAL, 0, 0, MPI_COMM_WORLD, 
    !  &                     MPI_STATUS_IGNORE, ierr)
        
            do j=1,1
              result = result + r4_random(s1, s2, s3)
            end do

            call MPI_WAIT(request, MPI_STATUS_IGNORE, ierr)
          end do            

          print*, "The result after all is equal to ", result
          time = MPI_WTIME() - time
          print*, "The time is ", time

        end if

        call MPI_FINALIZE(ierr)

      end program main