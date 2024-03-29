      subroutine make_sparse_matrix(val,col,row,d,Ap,Ae,Aw,An,As,At,Ab,bp,m,n,l)
      
      integer, intent(in) :: m, n, l
      real, intent(in), dimension(m,n,l) :: Ap, Ae, Aw, An, As, At, Ab, bp
      real, intent(out), dimension(m*n*l) :: row, d
      real, intent(out), dimension() :: val, col
      

      ! Determine Number of Nodes
      i_nodes = (m-2)*(n-2)*(l-2)
      l_nodes = 4*((m-2)+(n-2)+(l-2))
      s_nodes = 2*((m-2)*(n-2)+(n-2)*(l-2)+(l-2)*(m-2))
      c_nodes = 8

      ! Calculate Total A matrix Variables
      i_vars = i_nodes*7
      s_vars = s_nodes*6
      l_vars = l_nodes*5
      c_vars = c_nodes*4

      t_vars = i_vars+l_vars+s_vars+c_vars

      val = zeros(1,t_vars)
      row = zeros(1,t_vars)
      col = zeros(1,t_vars)

      d = zeros(1,m*n*l)

      indx = zeros(m,n,l)

      ! Calculate indx Values
      do i = 1:1:m
          do j = 1:1:n
              do k = 1:1:l
                  call calc_index_3d(index,i,j,k,m,n,l)
                  indx(i,j,k) = index                  
              end do
          end do
      end do

      ! -------------------------------------------------------------------------
      ! Fill Interior Nodes
      do k = 2:1:l-1
          do j = 2:1:n-1
              do i = 2:1:m-1
            
            
                  ! Bottom Node
                  val(indx(i,j,k)-3) = -Ab(i,j,k)
                  row(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-1)
                  col(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-2)
            
                  ! South Node
                  val(indx(i,j,k)-2) = -As(i,j,k) 
                  row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
                  col(indx(i,j,k)-2) = i+m*(j-2)+m*n*(k-1)
            
                  ! West Node
                  val(indx(i,j,k)-1) = -Aw(i,j,k)
                  row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
                  col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 
            
                  ! Center Node (p)
                  val(indx(i,j,k)) = Ap(i,j,k)
                  row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
                  col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
            
                  ! East Node
                  val(indx(i,j,k)+1) = -Ae(i,j,k) 
                  row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
                  col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)
            
                  ! North Node
                  val(indx(i,j,k)+2) = -An(i,j,k)
                  row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
                  col(indx(i,j,k)+2) = i+m*(j)+m*n*(k-1)
            
                  ! Top Node
                  val(indx(i,j,k)+3) = -At(i,j,k)
                  row(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k-1)
                  col(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k)
            
                  ! Solution Value
                  d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
            
              end do
          end do
      end do
      ! -------------------------------------------------------------------------
      ! Fill West Wall (i = 1)
      do k = 2:1:l-1
          do j = 2:1:n-1
        
              i = 1
        
              ! Bottom Node
              val(indx(i,j,k)-2) = -Ab(i,j,k)
              row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-2)

              ! South Node
              val(indx(i,j,k)-1) = -As(i,j,k) 
              row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)-1) = i+m*(j-2)+m*n*(k-1)

              ! Center Node (p)
              val(indx(i,j,k)) = Ap(i,j,k)
              row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

              ! East Node
              val(indx(i,j,k)+1) = -Ae(i,j,k) 
              row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

              ! North Node
              val(indx(i,j,k)+2) = -An(i,j,k)
              row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+2) = i+m*(j)+m*n*(k-1)

              ! Top Node
              val(indx(i,j,k)+3) = -At(i,j,k)
              row(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k)
        
              ! Solution Value
              d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
        
          end do
      end do
      ! -------------------------------------------------------------------------
      ! Fill East Wall (i = m)
      do k = 2:1:l-1
          do j = 2:1:n-1
            
              i = m
        
              ! Bottom Node
              val(indx(i,j,k)-3) = -Ab(i,j,k)
              row(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-2)

              ! South Node
              val(indx(i,j,k)-2) = -As(i,j,k) 
              row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)-2) = i+m*(j-2)+m*n*(k-1)

              ! West Node
              val(indx(i,j,k)-1) = -Aw(i,j,k)
              row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
              col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

              ! Center Node (p)
              val(indx(i,j,k)) = Ap(i,j,k)
              row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

              ! North Node
              val(indx(i,j,k)+1) = -An(i,j,k)
              row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+1) = i+m*(j)+m*n*(k-1)

              ! Top Node
              val(indx(i,j,k)+2) = -At(i,j,k)
              row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k)
            
              ! Solution Value
              d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
            
          end do
      end do
      ! -------------------------------------------------------------------------
      ! Fill South Wall (j = 1)
      do k = 2:1:l-1
          do i = 2:1:m-1
        
              j = 1
        
              ! Bottom Node
              val(indx(i,j,k)-2) = -Ab(i,j,k)
              row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-2)

              ! West Node
              val(indx(i,j,k)-1) = -Aw(i,j,k)
              row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
              col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

              ! Center Node (p)
              val(indx(i,j,k)) = Ap(i,j,k)
              row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

              ! East Node
              val(indx(i,j,k)+1) = -Ae(i,j,k) 
              row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

              ! North Node
              val(indx(i,j,k)+2) = -An(i,j,k)
              row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+2) = i+m*(j)+m*n*(k-1)

              ! Top Node
              val(indx(i,j,k)+3) = -At(i,j,k)
              row(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k)
            
              ! Solution Value
              d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)

          end do
      end do
      ! -------------------------------------------------------------------------
      ! Fill North Wall (j = n)
      do k = 2:1:l-1
          do i = 2:1:m-1
        
              j = n

              ! Bottom Node
              val(indx(i,j,k)-3) = -Ab(i,j,k)
              row(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-2)

              ! South Node
              val(indx(i,j,k)-2) = -As(i,j,k) 
              row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)-2) = i+m*(j-2)+m*n*(k-1)

              ! West Node
              val(indx(i,j,k)-1) = -Aw(i,j,k)
              row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
              col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

              ! Center Node (p)
              val(indx(i,j,k)) = Ap(i,j,k)
              row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

              ! East Node
              val(indx(i,j,k)+1) = -Ae(i,j,k) 
              row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

              ! Top Node
              val(indx(i,j,k)+2) = -At(i,j,k)
              row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k)
            
              ! Solution Value
              d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)

          end do
      end do
      ! -------------------------------------------------------------------------
      ! Fill Bottom Wall (k = 1)
      do j = 2:1:n-1
          do i = 2:1:m-1

              k = 1
            
              ! South Node
              val(indx(i,j,k)-2) = -As(i,j,k) 
              row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)-2) = i+m*(j-2)+m*n*(k-1)

              ! West Node
              val(indx(i,j,k)-1) = -Aw(i,j,k)
              row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
              col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

              ! Center Node (p)
              val(indx(i,j,k)) = Ap(i,j,k)
              row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

              ! East Node
              val(indx(i,j,k)+1) = -Ae(i,j,k) 
              row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

              ! North Node
              val(indx(i,j,k)+2) = -An(i,j,k)
              row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+2) = i+m*(j)+m*n*(k-1)

              ! Top Node
              val(indx(i,j,k)+3) = -At(i,j,k)
              row(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k)
            
              ! Solution Value
              d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)

          end do
      end do
      ! -------------------------------------------------------------------------
      ! Fill Top Wall (k = l)
      do j = 2:1:n-1
          do i = 2:1:m-1

              k = l

              ! Bottom Node
              val(indx(i,j,k)-3) = -Ab(i,j,k)
              row(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-2)

              ! South Node
              val(indx(i,j,k)-2) = -As(i,j,k) 
              row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)-2) = i+m*(j-2)+m*n*(k-1)

              ! West Node
              val(indx(i,j,k)-1) = -Aw(i,j,k)
              row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
              col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

              ! Center Node (p)
              val(indx(i,j,k)) = Ap(i,j,k)
              row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

              ! East Node
              val(indx(i,j,k)+1) = -Ae(i,j,k) 
              row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

              ! North Node
              val(indx(i,j,k)+2) = -An(i,j,k)
              row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
              col(indx(i,j,k)+2) = i+m*(j)+m*n*(k-1)
            
              ! Solution Value
              d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)

          end do
      end do
      ! -------------------------------------------------------------------------
      ! Fill in Corner (W,S,B)
      i = 1
      j = 1
      k = 1

      ! Center Node (p)
      val(indx(i,j,k)) = Ap(i,j,k)
      row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

      ! East Node
      val(indx(i,j,k)+1) = -Ae(i,j,k) 
      row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

      ! North Node
      val(indx(i,j,k)+2) = -An(i,j,k)
      row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)+2) = i+m*(j)+m*n*(k-1)

      ! Top Node
      val(indx(i,j,k)+3) = -At(i,j,k)
      row(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k)
            
      ! Solution Value
      d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
      ! -------------------------------------------------------------------------
      ! Fill in Corner (E,S,B)
      i = m
      j = 1
      k = 1

      ! West Node
      val(indx(i,j,k)-1) = -Aw(i,j,k)
      row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
      col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

      ! Center Node (p)
      val(indx(i,j,k)) = Ap(i,j,k)
      row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

      ! North Node
      val(indx(i,j,k)+1) = -An(i,j,k)
      row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)+1) = i+m*(j)+m*n*(k-1)

      ! Top Node
      val(indx(i,j,k)+2) = -At(i,j,k)
      row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k)
            
      ! Solution Value
      d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
      ! -------------------------------------------------------------------------
      ! Fill in Corner (W,N,B)
      i = 1
      j = n
      k = 1

      ! South Node
      val(indx(i,j,k)-1) = -As(i,j,k) 
      row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)-1) = i+m*(j-2)+m*n*(k-1)

      ! Center Node (p)
      val(indx(i,j,k)) = Ap(i,j,k)
      row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

      ! East Node
      val(indx(i,j,k)+1) = -Ae(i,j,k) 
      row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

      ! Top Node
      val(indx(i,j,k)+2) = -At(i,j,k)
      row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k)
            
      ! Solution Value
      d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
      ! -------------------------------------------------------------------------
      ! Fill in Corner (E,N,B)
      i = m
      j = n
      k = 1

      ! South Node
      val(indx(i,j,k)-2) = -As(i,j,k) 
      row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)-2) = i+m*(j-2)+m*n*(k-1)

      ! West Node
      val(indx(i,j,k)-1) = -Aw(i,j,k)
      row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
      col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

      ! Center Node (p)
      val(indx(i,j,k)) = Ap(i,j,k)
      row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

      ! Top Node
      val(indx(i,j,k)+1) = -At(i,j,k)
      row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k)
            
      ! Solution Value
      d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
      ! -------------------------------------------------------------------------
      ! Fill in Corner (W,S,T)
      i = 1
      j = 1
      k = l

      ! Bottom Node
      val(indx(i,j,k)-1) = -Ab(i,j,k)
      row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-2)

      ! Center Node (p)
      val(indx(i,j,k)) = Ap(i,j,k)
      row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

      ! East Node
      val(indx(i,j,k)+1) = -Ae(i,j,k) 
      row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

      ! North Node
      val(indx(i,j,k)+2) = -An(i,j,k)
      row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)+2) = i+m*(j)+m*n*(k-1)

      ! Solution Value
      d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
      ! -------------------------------------------------------------------------
      ! Fill in Corner (E,S,T)
      i = m
      j = 1
      k = l

      ! Bottom Node
      val(indx(i,j,k)-2) = -Ab(i,j,k)
      row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-2)

      ! West Node
      val(indx(i,j,k)-1) = -Aw(i,j,k)
      row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
      col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

      ! Center Node (p)
      val(indx(i,j,k)) = Ap(i,j,k)
      row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

      ! North Node
      val(indx(i,j,k)+1) = -An(i,j,k)
      row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)+1) = i+m*(j)+m*n*(k-1)
            
      ! Solution Value
      d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
      ! -------------------------------------------------------------------------
      ! Fill in Corner (W,N,T)
      i = 1
      j = n
      k = l

      ! Bottom Node
      val(indx(i,j,k)-2) = -Ab(i,j,k)
      row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-2)

      ! South Node
      val(indx(i,j,k)-1) = -As(i,j,k) 
      row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)-1) = i+m*(j-2)+m*n*(k-1)

      ! Center Node (p)
      val(indx(i,j,k)) = Ap(i,j,k)
      row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

      ! East Node
      val(indx(i,j,k)+1) = -Ae(i,j,k) 
      row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)
            
      ! Solution Value
      d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
      ! -------------------------------------------------------------------------
      ! Fill in Corner (E,N,T)
      i = m
      j = n
      k = l

      ! Bottom Node
      val(indx(i,j,k)-3) = -Ab(i,j,k)
      row(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-2)

      ! South Node
      val(indx(i,j,k)-2) = -As(i,j,k) 
      row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)-2) = i+m*(j-2)+m*n*(k-1)

      ! West Node
      val(indx(i,j,k)-1) = -Aw(i,j,k)
      row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
      col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

      ! Center Node (p)
      val(indx(i,j,k)) = Ap(i,j,k)
      row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
      col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
            
      ! Solution Value
      d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
      ! -------------------------------------------------------------------------
      ! Fill in Line (W2E - S,B)
      do i = 2:1:m-1
          j = 1
          k = 1

          ! West Node
          val(indx(i,j,k)-1) = -Aw(i,j,k)
          row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
          col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

          ! Center Node (p)
          val(indx(i,j,k)) = Ap(i,j,k)
          row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

          ! East Node
          val(indx(i,j,k)+1) = -Ae(i,j,k) 
          row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

          ! North Node
          val(indx(i,j,k)+2) = -An(i,j,k)
          row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+2) = i+m*(j)+m*n*(k-1)

          ! Top Node
          val(indx(i,j,k)+3) = -At(i,j,k)
          row(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k)
            
          ! Solution Value
          d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
      end do
      ! -------------------------------------------------------------------------
      ! Fill in Line (W2E - N,B)
      do i = 2:1:m-1
          j = n
          k = 1

          ! South Node
          val(indx(i,j,k)-2) = -As(i,j,k) 
          row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-2) = i+m*(j-2)+m*n*(k-1)

          ! West Node
          val(indx(i,j,k)-1) = -Aw(i,j,k)
          row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
          col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

          ! Center Node (p)
          val(indx(i,j,k)) = Ap(i,j,k)
          row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

          ! East Node
          val(indx(i,j,k)+1) = -Ae(i,j,k) 
          row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)
    
          ! Top Node
          val(indx(i,j,k)+2) = -At(i,j,k)
          row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k)
            
          ! Solution Value
          d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
      end do
      ! -------------------------------------------------------------------------
      ! Fill in Line (W2E - S,T)
      do i = 2:1:m-1
          j = 1
          k = l

          ! Bottom Node
          val(indx(i,j,k)-2) = -Ab(i,j,k)
          row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-2)

          ! West Node
          val(indx(i,j,k)-1) = -Aw(i,j,k)
          row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
          col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

          ! Center Node (p)
          val(indx(i,j,k)) = Ap(i,j,k)
          row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

          ! East Node
          val(indx(i,j,k)+1) = -Ae(i,j,k) 
          row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

          ! North Node
          val(indx(i,j,k)+2) = -An(i,j,k)
          row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+2) = i+m*(j)+m*n*(k-1)
            
          ! Solution Value
          d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
      end do
      ! -------------------------------------------------------------------------
      ! Fill in Line (W2E - N,T)
      do i = 2:1:m-1
          j = n
          k = l
    
          ! Bottom Node
          val(indx(i,j,k)-3) = -Ab(i,j,k)
          row(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-2)

          ! South Node
          val(indx(i,j,k)-2) = -As(i,j,k) 
          row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-2) = i+m*(j-2)+m*n*(k-1)

          ! West Node
          val(indx(i,j,k)-1) = -Aw(i,j,k)
          row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
          col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

          ! Center Node (p)
          val(indx(i,j,k)) = Ap(i,j,k)
          row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

          ! East Node
          val(indx(i,j,k)+1) = -Ae(i,j,k) 
          row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)
            
          ! Solution Value
          d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
      end do
      ! -------------------------------------------------------------------------
      ! Fill in Line (S2N - W,B)
      do j = 2:1:n-1
          i = 1
          k = 1

          ! South Node
          val(indx(i,j,k)-1) = -As(i,j,k) 
          row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-1) = i+m*(j-2)+m*n*(k-1)

          ! Center Node (p)
          val(indx(i,j,k)) = Ap(i,j,k)
          row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

          ! East Node
          val(indx(i,j,k)+1) = -Ae(i,j,k) 
          row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

          ! North Node
          val(indx(i,j,k)+2) = -An(i,j,k)
          row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+2) = i+m*(j)+m*n*(k-1)

          ! Top Node
          val(indx(i,j,k)+3) = -At(i,j,k)
          row(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k)
            
          ! Solution Value
          d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
    
      end do
      ! -------------------------------------------------------------------------
      ! Fill in Line (S2N - E,B)
      do j = 2:1:n-1
          i = m
          k = 1

          ! South Node
          val(indx(i,j,k)-2) = -As(i,j,k) 
          row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-2) = i+m*(j-2)+m*n*(k-1)

          ! West Node
          val(indx(i,j,k)-1) = -Aw(i,j,k)
          row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
          col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

          ! Center Node (p)
          val(indx(i,j,k)) = Ap(i,j,k)
          row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

          ! North Node
          val(indx(i,j,k)+1) = -An(i,j,k)
          row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+1) = i+m*(j)+m*n*(k-1)

          ! Top Node
          val(indx(i,j,k)+2) = -At(i,j,k)
          row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k)
            
          ! Solution Value
          d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
    
      end do
      ! -------------------------------------------------------------------------
      ! Fill in Line (S2N - W,T)
      do j = 2:1:n-1
          i = 1
          k = l

          ! Bottom Node
          val(indx(i,j,k)-2) = -Ab(i,j,k)
          row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-2)

          ! South Node
          val(indx(i,j,k)-1) = -As(i,j,k) 
          row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-1) = i+m*(j-2)+m*n*(k-1)

          ! Center Node (p)
          val(indx(i,j,k)) = Ap(i,j,k)
          row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

          ! East Node
          val(indx(i,j,k)+1) = -Ae(i,j,k) 
          row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

          ! North Node
          val(indx(i,j,k)+2) = -An(i,j,k)
          row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+2) = i+m*(j)+m*n*(k-1)

          ! Solution Value
          d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
    
      end do
      ! -------------------------------------------------------------------------
      ! Fill in Line (S2N - E,T)
      do j = 2:1:n-1
          i = m
          k = l
    
          ! Bottom Node
          val(indx(i,j,k)-3) = -Ab(i,j,k)
          row(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-2)

          ! South Node
          val(indx(i,j,k)-2) = -As(i,j,k) 
          row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-2) = i+m*(j-2)+m*n*(k-1)

          ! West Node
          val(indx(i,j,k)-1) = -Aw(i,j,k)
          row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
          col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

          ! Center Node (p)
          val(indx(i,j,k)) = Ap(i,j,k)
          row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

          ! North Node
          val(indx(i,j,k)+1) = -An(i,j,k)
          row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+1) = i+m*(j)+m*n*(k-1)
            
          ! Solution Value
          d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
    
      end do
      ! -------------------------------------------------------------------------
      ! Fill in Line (B2T - W,S)
      do k = 2:1:l-1
          i = 1
          j = 1

          ! Bottom Node
          val(indx(i,j,k)-1) = -Ab(i,j,k)
          row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-2)

          ! Center Node (p)
          val(indx(i,j,k)) = Ap(i,j,k)
          row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

          ! East Node
          val(indx(i,j,k)+1) = -Ae(i,j,k) 
          row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

          ! North Node
          val(indx(i,j,k)+2) = -An(i,j,k)
          row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+2) = i+m*(j)+m*n*(k-1)

          ! Top Node
          val(indx(i,j,k)+3) = -At(i,j,k)
          row(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+3) = i+m*(j-1)+m*n*(k)
            
          ! Solution Value
          d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
    
      end do
      ! -------------------------------------------------------------------------
      ! Fill in Line (B2T - E,S)
      do k = 2:1:l-1
          i = m
          j = 1
    
          ! Bottom Node
          val(indx(i,j,k)-2) = -Ab(i,j,k)
          row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-2)

          ! West Node
          val(indx(i,j,k)-1) = -Aw(i,j,k)
          row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
          col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

          ! Center Node (p)
          val(indx(i,j,k)) = Ap(i,j,k)
          row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

          ! North Node
          val(indx(i,j,k)+1) = -An(i,j,k)
          row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+1) = i+m*(j)+m*n*(k-1)

          ! Top Node
          val(indx(i,j,k)+2) = -At(i,j,k)
          row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k)
            
          ! Solution Value
          d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
    
      end do
      ! -------------------------------------------------------------------------
      ! Fill in Line (B2T - W,N)
      do k = 2:1:l-1
          i = 1
          j = n
    
          ! Bottom Node
          val(indx(i,j,k)-2) = -Ab(i,j,k)
          row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-2)

          ! South Node
          val(indx(i,j,k)-1) = -As(i,j,k) 
          row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-1) = i+m*(j-2)+m*n*(k-1)

          ! Center Node (p)
          val(indx(i,j,k)) = Ap(i,j,k)
          row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

          ! East Node
          val(indx(i,j,k)+1) = -Ae(i,j,k) 
          row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+1) = (i+1)+m*(j-1)+m*n*(k-1)

          ! Top Node
          val(indx(i,j,k)+2) = -At(i,j,k)
          row(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+2) = i+m*(j-1)+m*n*(k)
            
          ! Solution Value
          d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
    
      end do
      ! -------------------------------------------------------------------------
      ! Fill in Line (B2T - E,N)
      do k = 2:1:l-1
          i = m
          j = n
    
          ! Bottom Node
          val(indx(i,j,k)-3) = -Ab(i,j,k)
          row(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-3) = i+m*(j-1)+m*n*(k-2)

          ! South Node
          val(indx(i,j,k)-2) = -As(i,j,k) 
          row(indx(i,j,k)-2) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)-2) = i+m*(j-2)+m*n*(k-1)

          ! West Node
          val(indx(i,j,k)-1) = -Aw(i,j,k)
          row(indx(i,j,k)-1) = i+m*(j-1)+m*n*(k-1) 
          col(indx(i,j,k)-1) = (i-1)+m*(j-1)+m*n*(k-1) 

          ! Center Node (p)
          val(indx(i,j,k)) = Ap(i,j,k)
          row(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)) = i+m*(j-1)+m*n*(k-1)

          ! Top Node
          val(indx(i,j,k)+1) = -At(i,j,k)
          row(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k-1)
          col(indx(i,j,k)+1) = i+m*(j-1)+m*n*(k)
            
          ! Solution Value
          d(i+m*(j-1)+m*n*(k-1)) = bp(i,j,k)
    
      end do
      ! -------------------------------------------------------------------------

      return val, col, row, d
      
      end subroutine make_sparse_matrix