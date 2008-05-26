%  pde5.m -- Solve convection-diffusion using chebfuns
%
%    u_t + u_x = nu*u_xx,  u(+-1)=0
%
%  Using BD4 in time with RK4 startup, and spectral solutions called adaptively by
%  chebfun construction.

%  TAD & LNT,  19/01/07

function u=pde5()
  x = chebfun(@(x) x,[-1,1]);
  nu = 0.02;
  u = cos(pi/2*x);    % initial condition
  dt = .04/32;                % time step
  tmax = 1;
  t = 0;
  % RK4 startup
  N = length(u); 
  xc = cos((0:N)'*pi/N);
  D = cheb(N);  D2= D^2;  
  L = nu*D2 - D;
  L = L(2:N,2:N);
  U(:,1) = u(xc(2:N));
  for n = 1:3
    s1 = dt*L*U(:,n);
    s2 = dt*L*(U(:,n)+s1/2);
    s3 = dt*L*(U(:,n)+s2/2);
    s4 = dt*L*(U(:,n)+s3);
    U(:,n+1) = U(:,n) + ( s1 + 2*(s2+s3) + s4 ) / 6;
  end
  % Convert to funs
  for n = 1:4
    temp = fun([],[0;U(:,n);0]);
    ustore{n} = chebfun( @(x) temp(x) );
  end
  while t < tmax
    rhs = (48*ustore{4} - 36*ustore{3} + 16*ustore{2} - 3*ustore{1})/25; 
   %rhs = 4/3*ustore{4} - 1/3*ustore{3};
    dt = min(dt,tmax-t);
    u = chebfun(@(x) bvp(x,rhs,12/25*dt));
    t = t+dt;
    ustore = { ustore{2:4}, u };
    plot(u), ylim([-0.5 1.5]), grid on
    title(sprintf('t = %0.4f;  length(u) = %i',t,length(u)))
    drawnow
  end

  %%
  % Solve the BVP associated with the implicit time stepping.
  function u = bvp(x,f,k)

    N = length(x)-1; 
    D = cheb(N); D2 = D^2;
    L = nu*D2 - D;
    A = eye(N-1) - k*L(2:N,2:N);
    u = A\f(x(2:N));
    u = [0; u; 0];
    
  end
  
  
end

