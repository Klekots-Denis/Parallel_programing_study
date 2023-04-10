      program decompositionTest
        implicit none
        include 'mpif.h'

        integer maxNum, maxProc
        parameter (maxNum = 1000, maxProc = 128)
        integer primes(maxNum)
        integer i, ks, kr, ierr, rank, size, ocnt
        integer req(maxProc), indx(maxProc)
        integer numberBuf(maxProc), primesBuf(2, maxProc)
        integer statuses(MPI_STATUS_SIZE, maxProc)
        integer prn1, prn2

        call MPI_INIT(ierr)

        call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
        call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
        
        if (rank .eq. 0) then
          
          call generatrPrimes(primes, maxNum)

          ks = 1
          kr = maxNum*maxNum

          do i=1,size-1
            prn1 = ceiling(ks/float(maxNum))
            prn2 = mod(ks, maxNum)

            numberBuf(i) = primes(prn1)*primes(prn2)

            call MPI_ISEND(numberBuf(i), 1, MPI_INTEGER, i, 0,
     &                     MPI_COMM_WORLD, req(i), ierr)
            req(i) = MPI_REQUEST_NULL
            ks = ks+1
            call MPI_IRECV(primesBuf(1,i), 2, MPI_INTEGER, i, 0,
     &                  MPI_COMM_WORLD, req(i), ierr)
          enddo

          do while(kr .ge. 1)
            
            call MPI_WAITSOME(size-1, req, ocnt, indx, statuses, ierr)

            ! print*, "ocnt", ocnt, "kr", kr, "ks", ks

            do i=1, ocnt

              print*, "The primes of ", 
     &           numberBuf(indx(i)), " is ",
     &           primesBuf(1,indx(i)), " and ", primesBuf(2,indx(i))

              kr = kr-1

              if (ks .gt. maxNum*maxNum) then
                call MPI_ISEND(-1, 1, MPI_INTEGER,  
     &              indx(i), 0, MPI_COMM_WORLD, req(indx(i)), ierr)
                req(indx(i)) = MPI_REQUEST_NULL
                cycle
              endif 

              prn1 = ceiling(ks/float(maxNum))
              prn2 = mod(ks, maxNum) + 1

              numberBuf(indx(i)) = primes(prn1)*primes(prn2)

              call MPI_ISEND(numberBuf(indx(i)), 1, MPI_INTEGER,  
     &              indx(i), 0,MPI_COMM_WORLD, req(indx(i)), ierr)
              ks = ks+1

              call MPI_IRECV(primesBuf(1,indx(i)), 2, MPI_INTEGER,
     &              indx(i), 0, MPI_COMM_WORLD, req(indx(i)), ierr)
              

            enddo

          enddo


        else

          do while(.true.)
            call MPI_RECV(numberBuf(1), 1, MPI_INTEGER, 0, 0, 
     &                    MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
     
            if (numberBuf(1) .eq. -1) exit

            call decomposite(numberBuf(1), primesBuf(1,1), 
     &                       primesBuf(2,1))
            call MPI_SEND(primesBuf(1,1), 2, MPI_INTEGER, 0, 0,
     &                    MPI_COMM_WORLD, ierr)
          enddo


        endif

        call MPI_FINALIZE(ierr)

      contains !======================================================72

      subroutine generatrPrimes(array, N)
        implicit none

        integer N
        integer array(:)
        real testNum
        integer :: ami
        integer :: aci
        

        array(1) = 2

        do ami = 2,N
          
          array(ami) = array(ami-1)+1

            aci = 1
            do while(aci .lt. ami)
                
              testNum = float(array(ami))/array(aci)

              if(testNum .eq. floor(testNum)) then
                array(ami) = array(ami) + 1
                aci = 1
                cycle
              endif

              aci = aci+1

            enddo

        enddo

      end subroutine generatrPrimes

      !===============================================================72

      subroutine decomposite(number, p1, p2)

        integer number 
        integer it
        real p2test
        integer p1
        integer p2

        do it = 2, number
          p2test = float(number)/it

          if (p2test .eq. floor(p2test)) then
            p1 = it
            p2 = int(p2test)
            return
          endif

        enddo

      end subroutine decomposite


      end program decompositionTest