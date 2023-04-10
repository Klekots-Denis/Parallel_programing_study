      program example14
      include 'mpif.h'
      integer ierr, rank, i, size, n, nproc, req
      parameter (n = 1 000 000)
      double precision time_start, time_finish
      double precision a(n), b(n), c(n)
      integer status(MPI_STATUS_SIZE)
      call MPI_INIT(ierr)
      call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
      call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
      nproc = size
      do i = 1, n
        a(i) = 1.d0/size
      end do
      call MPI_BARRIER(MPI_COMM_WORLD, ierr)
      time_start = MPI_WTIME(ierr)
      do i = 1, n
        c(i) = a(i)
      end do
      do while (nproc .gt. 1)
        if(rank .lt. nproc/2) then
          call MPI_RECV(b, n, MPI_DOUBLE_PRECISION,
     &                nproc-rank-1, 1, MPI_COMM_WORLD,
     &                status, ierr)
          do i = 1, n
            c(i) = c(i) + b(i)
          end do

          if(rank+1 .ge. nproc/2 .and. rank + 1 .lt. (nproc+1)/2) then  ! modification begin
            call MPI_RECV(b, n, MPI_DOUBLE_PRECISION,
     &                    nproc-rank-2, 1, MPI_COMM_WORLD,
     &                    status, ierr)
            do i = 1, n
              c(i) = c(i) + b(i)
            end do
          endif

        else if(rank .lt. (nproc+1)/2) then
          call MPI_ISEND(c, n, MPI_DOUBLE_PRECISION,
     &                    nproc-rank-2, 1, MPI_COMM_WORLD, req, ierr)   ! modification end, ISEND to make asynchronous
        else if(rank .lt. nproc) then
          call MPI_ISEND(c, n, MPI_DOUBLE_PRECISION,                    ! ISEND to make asynchronous
     &                  nproc-rank-1, 1, MPI_COMM_WORLD, req, ierr)     
        end if

        nproc = nproc/2
      end do
      do i = 1, n
        b(i) = c(i)
      end do
      time_finish = MPI_WTIME(ierr)-time_start
      if(rank .eq. 0) print *, 'model b(1)=', b(1)
      print *, 'rank=', rank, ' model time =', time_finish

      do i = 1, n
        a(i) = 1.d0/size
      end do
      call MPI_BARRIER(MPI_COMM_WORLD, ierr)
      time_start = MPI_WTIME(ierr)
      call MPI_REDUCE(a, b, n, MPI_DOUBLE_PRECISION, MPI_SUM, 0,
     &                MPI_COMM_WORLD, ierr)
      time_finish = MPI_WTIME(ierr)-time_start
      if(rank .eq. 0) print *, 'reduce b(1)=', b(1)
      print *, 'rank=', rank, ' reduce time =', time_finish
      call MPI_FINALIZE(ierr)
      end